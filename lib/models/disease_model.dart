import 'package:flutter/material.dart' show Color;

class DiseaseResult {
  final String diseaseName;
  final String confidence;
  final String severity;
  final String description;
  final List<String> symptoms;
  final List<String> treatments;
  final List<String> preventions;
  final String cropType;
  final String affectedPart;
  final DateTime detectedAt;

  DiseaseResult({
    required this.diseaseName,
    required this.confidence,
    required this.severity,
    required this.description,
    required this.symptoms,
    required this.treatments,
    required this.preventions,
    required this.cropType,
    required this.affectedPart,
    required this.detectedAt,
  });

  factory DiseaseResult.fromJson(Map<String, dynamic> json) {
    return DiseaseResult(
      diseaseName: json['diseaseName'] ?? 'Unknown',
      confidence: json['confidence'] ?? 'Medium',
      severity: json['severity'] ?? 'Moderate',
      description: json['description'] ?? '',
      symptoms: List<String>.from(json['symptoms'] ?? []),
      treatments: List<String>.from(json['treatments'] ?? []),
      preventions: List<String>.from(json['preventions'] ?? []),
      cropType: json['cropType'] ?? 'Unknown Crop',
      affectedPart: json['affectedPart'] ?? 'Leaf',
      detectedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'diseaseName': diseaseName,
        'confidence': confidence,
        'severity': severity,
        'description': description,
        'symptoms': symptoms,
        'treatments': treatments,
        'preventions': preventions,
        'cropType': cropType,
        'affectedPart': affectedPart,
        'detectedAt': detectedAt.toIso8601String(),
      };

  Color get severityColor {
    switch (severity.toLowerCase()) {
      case 'low':
        return const Color(0xFF4CAF50);
      case 'moderate':
        return const Color(0xFFFF9800);
      case 'high':
        return const Color(0xFFF44336);
      case 'critical':
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFF2196F3);
    }
  }
}

// ignore: depend_on_referenced_packages

class AgriSupplier {
  final String name;
  final String address;
  final String phone;
  final double distance;
  final double rating;
  final List<String> products;

  AgriSupplier({
    required this.name,
    required this.address,
    required this.phone,
    required this.distance,
    required this.rating,
    required this.products,
  });
}
