import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';

  // Vision model for image analysis
  static const String _visionModel = 'meta-llama/llama-4-scout-17b-16e-instruct';

  // Text model for chat / advice
  static const String _textModel = 'llama3-70b-8192';

  static String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  static Future<Map<String, String>> get _headers async => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      };

  /// Analyze crop image and detect disease
  static Future<Map<String, dynamic>> analyzeCropImage({
    required File imageFile,
    required String language,
  }) async {
    final imageBytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(imageBytes);

    final prompt = '''
You are an expert agricultural scientist and plant pathologist. Analyze this crop/plant image carefully.

Respond ONLY with a valid JSON object (no markdown, no extra text) in this exact format:
{
  "diseaseName": "Name of disease or 'Healthy Plant' if no disease",
  "confidence": "High/Medium/Low",
  "severity": "None/Low/Moderate/High/Critical",
  "cropType": "Type of crop detected",
  "affectedPart": "Leaf/Stem/Root/Fruit/Flower/Whole Plant",
  "description": "Brief description of the condition in $language language",
  "symptoms": ["symptom 1 in $language", "symptom 2 in $language", "symptom 3 in $language"],
  "treatments": ["treatment step 1 in $language", "treatment step 2 in $language", "treatment step 3 in $language", "treatment step 4 in $language"],
  "preventions": ["prevention tip 1 in $language", "prevention tip 2 in $language", "prevention tip 3 in $language"],
  "isHealthy": true or false,
  "urgency": "immediate/within_week/monitor/none"
}

Important: All text values (description, symptoms, treatments, preventions) MUST be written in $language language.
If you cannot identify the plant or image is unclear, set diseaseName to "Unable to Identify" and provide guidance.
''';

    final body = jsonEncode({
      'model': _visionModel,
      'messages': [
        {
          'role': 'user',
          'content': [
            {
              'type': 'image_url',
              'image_url': {
                'url': 'data:image/jpeg;base64,$base64Image',
              },
            },
            {
              'type': 'text',
              'text': prompt,
            },
          ],
        }
      ],
      'max_tokens': 1024,
      'temperature': 0.2,
    });

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: await _headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final responseText =
            data['choices'][0]['message']['content'] as String? ?? '{}';

        // Clean JSON response
        String cleanJson = responseText
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();

        try {
          return json.decode(cleanJson) as Map<String, dynamic>;
        } catch (e) {
          return _errorResponse();
        }
      } else {
        return _errorResponse();
      }
    } catch (e) {
      return _errorResponse();
    }
  }

  static Map<String, dynamic> _errorResponse() => {
        'diseaseName': 'Analysis Error',
        'confidence': 'Low',
        'severity': 'Unknown',
        'cropType': 'Unknown',
        'affectedPart': 'Unknown',
        'description':
            'Could not analyze the image. Please try again with a clearer photo.',
        'symptoms': [],
        'treatments': [
          'Please retake the photo in good lighting',
          'Ensure the affected area is clearly visible'
        ],
        'preventions': [],
        'isHealthy': false,
        'urgency': 'monitor',
      };

  /// Get treatment advice in specific language
  static Future<String> getTreatmentAdvice({
    required String diseaseName,
    required String cropType,
    required String language,
  }) async {
    final prompt = '''
Give detailed treatment advice for "$diseaseName" disease in "$cropType" crop.
Write in $language language.
Include: organic remedies, chemical treatments, dosage, application method.
Keep it practical for small farmers. Format as numbered steps.
''';

    final body = jsonEncode({
      'model': _textModel,
      'messages': [
        {'role': 'user', 'content': prompt}
      ],
      'max_tokens': 1024,
      'temperature': 0.3,
    });

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: await _headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String? ??
            'Unable to get advice. Please consult a local agricultural expert.';
      }
    } catch (_) {}
    return 'Unable to get advice. Please consult a local agricultural expert.';
  }

  /// Chat with AI about farming questions
  static Future<String> askFarmingQuestion({
    required String question,
    required String language,
    String? context,
  }) async {
    final prompt = '''
You are a helpful agricultural expert assistant for small farmers.
${context != null ? 'Context: $context\n' : ''}
Question: $question

Answer in $language language. Be practical, clear, and helpful.
Keep the answer concise but complete.
''';

    final body = jsonEncode({
      'model': _textModel,
      'messages': [
        {'role': 'user', 'content': prompt}
      ],
      'max_tokens': 1024,
      'temperature': 0.5,
    });

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: await _headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String? ??
            'Unable to answer. Please try again.';
      }
    } catch (_) {}
    return 'Unable to answer. Please try again.';
  }
}
