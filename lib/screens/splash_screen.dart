import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/firestore_service.dart';
import 'language_select_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await FirestoreService.signInAnonymously();
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LanguageSelectScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1B5E20),
              Color(0xFF2D7A3A),
              Color(0xFF43A047),
              Color(0xFF81C784),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.eco,
                  size: 70,
                  color: Color(0xFF2D7A3A),
                ),
              )
                  .animate()
                  .scale(duration: 600.ms, curve: Curves.elasticOut)
                  .fadeIn(),
              const SizedBox(height: 28),
              Text(
                'FarmSense AI',
                style: GoogleFonts.poppins(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ).animate().slideY(begin: 0.3).fadeIn(delay: 300.ms),
              const SizedBox(height: 8),
              Text(
                'Protect Your Crops. Save Your Harvest.',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.85),
                  fontWeight: FontWeight.w400,
                ),
              ).animate().fadeIn(delay: 500.ms),
              const Spacer(flex: 2),
              // Leaf icons row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.spa,
                      color: Colors.white.withOpacity(0.5 + i * 0.15),
                      size: 20 + i * 4.0,
                    )
                        .animate(onPlay: (c) => c.repeat())
                        .moveY(
                          begin: 0,
                          end: -8,
                          duration: (1200 + i * 200).ms,
                          curve: Curves.easeInOut,
                        )
                        .then()
                        .moveY(begin: -8, end: 0, duration: (1200 + i * 200).ms),
                  );
                }),
              ),
              const SizedBox(height: 40),
              // Loading indicator
              SizedBox(
                width: 40,
                height: 4,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  borderRadius: BorderRadius.circular(4),
                ),
              ).animate().fadeIn(delay: 800.ms),
              const SizedBox(height: 12),
              Text(
                'Powered by Gemini AI',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.6),
                ),
              ).animate().fadeIn(delay: 900.ms),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
