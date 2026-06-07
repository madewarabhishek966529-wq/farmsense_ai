import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

class LanguageSelectScreen extends StatefulWidget {
  const LanguageSelectScreen({super.key});

  @override
  State<LanguageSelectScreen> createState() => _LanguageSelectScreenState();
}

class _LanguageSelectScreenState extends State<LanguageSelectScreen> {
  String _selectedLanguage = 'English';

  final List<Map<String, String>> _languages = [
    {'name': 'English', 'native': 'English', 'flag': '🇺🇸'},
    {'name': 'Hindi', 'native': 'हिन्दी', 'flag': '🇮🇳'},
    {'name': 'Marathi', 'native': 'मराठी', 'flag': '🇮🇳'},
    {'name': 'Tamil', 'native': 'தமிழ்', 'flag': '🇮🇳'},
    {'name': 'Telugu', 'native': 'తెలుగు', 'flag': '🇮🇳'},
    {'name': 'Kannada', 'native': 'ಕನ್ನಡ', 'flag': '🇮🇳'},
    {'name': 'Bengali', 'native': 'বাংলা', 'flag': '🇮🇳'},
    {'name': 'Gujarati', 'native': 'ગુજરાતી', 'flag': '🇮🇳'},
    {'name': 'Punjabi', 'native': 'ਪੰਜਾਬੀ', 'flag': '🇮🇳'},
    {'name': 'Spanish', 'native': 'Español', 'flag': '🇪🇸'},
    {'name': 'Swahili', 'native': 'Kiswahili', 'flag': '🇰🇪'},
    {'name': 'Portuguese', 'native': 'Português', 'flag': '🇧🇷'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF1F8E9), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  '🌍 Choose Your\nLanguage',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A3C20),
                    height: 1.2,
                  ),
                ).animate().slideX(begin: -0.2).fadeIn(),
                const SizedBox(height: 8),
                Text(
                  'Results will appear in your selected language',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 32),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _languages.length,
                    itemBuilder: (context, index) {
                      final lang = _languages[index];
                      final isSelected = _selectedLanguage == lang['name'];
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedLanguage = lang['name']!),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF2D7A3A)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF2D7A3A)
                                  : Colors.grey.shade200,
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? const Color(0xFF2D7A3A).withOpacity(0.3)
                                    : Colors.black.withOpacity(0.05),
                                blurRadius: isSelected ? 12 : 4,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(lang['flag']!, style: const TextStyle(fontSize: 20)),
                                const SizedBox(height: 2),
                                Text(
                                  lang['native']!,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: isSelected ? Colors.white : const Color(0xFF1A3C20),
                                  ),
                                ),
                                Text(
                                  lang['name']!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: isSelected
                                        ? Colors.white70
                                        : Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ).animate().scale(delay: (index * 50).ms, duration: 300.ms),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              HomeScreen(language: _selectedLanguage),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D7A3A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      'Continue →',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ).animate().slideY(begin: 0.3).fadeIn(delay: 400.ms),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
