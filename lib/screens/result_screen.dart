import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../models/disease_model.dart';
import '../services/firestore_service.dart';
import 'suppliers_screen.dart';

class ResultScreen extends StatefulWidget {
  final DiseaseResult disease;
  final File imageFile;
  final String language;

  const ResultScreen({
    super.key,
    required this.disease,
    required this.imageFile,
    required this.language,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _autoSave();
  }

  Future<void> _autoSave() async {
    try {
      await FirestoreService.saveScanResult(
        result: widget.disease,
        imageUrl: widget.imageFile.path,
      );
      setState(() => _saved = true);
    } catch (_) {}
  }

  Color get _severityColor {
    switch (widget.disease.severity.toLowerCase()) {
      case 'none':
        return const Color(0xFF4CAF50);
      case 'low':
        return const Color(0xFF8BC34A);
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

  @override
  Widget build(BuildContext context) {
    final isHealthy = widget.disease.diseaseName.toLowerCase().contains('healthy');

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Image App Bar
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: const Color(0xFF1A3C20),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.share, color: Colors.white, size: 20),
                ),
                onPressed: () {
                  Share.share(
                    'FarmSense AI detected: ${widget.disease.diseaseName} in ${widget.disease.cropType}\n'
                    'Severity: ${widget.disease.severity}\n'
                    'Treatments: ${widget.disease.treatments.join(", ")}',
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(widget.imageFile, fit: BoxFit.cover),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _severityColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.disease.severity.toUpperCase(),
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.disease.diseaseName,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '${widget.disease.cropType} • ${widget.disease.affectedPart}',
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Confidence Badge
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.verified,
                        label: '${widget.disease.confidence} Confidence',
                        color: const Color(0xFF2D7A3A),
                      ),
                      const SizedBox(width: 8),
                      _InfoChip(
                        icon: Icons.language,
                        label: widget.language,
                        color: Colors.blue,
                      ),
                      if (_saved) ...[
                        const SizedBox(width: 8),
                        _InfoChip(
                          icon: Icons.save_alt,
                          label: 'Saved',
                          color: Colors.purple,
                        ),
                      ],
                    ],
                  ).animate().slideX(begin: -0.2).fadeIn(),

                  const SizedBox(height: 20),

                  // Description
                  _SectionCard(
                    icon: isHealthy ? '✅' : '🔬',
                    title: 'Analysis',
                    child: Text(
                      widget.disease.description,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.6,
                      ),
                    ),
                  ).animate().slideY(begin: 0.2).fadeIn(delay: 100.ms),

                  const SizedBox(height: 16),

                  // Symptoms
                  if (widget.disease.symptoms.isNotEmpty) ...[
                    _SectionCard(
                      icon: '🚨',
                      title: 'Symptoms Detected',
                      child: Column(
                        children: widget.disease.symptoms
                            .map((s) => _BulletPoint(text: s, color: Colors.orange))
                            .toList(),
                      ),
                    ).animate().slideY(begin: 0.2).fadeIn(delay: 200.ms),
                    const SizedBox(height: 16),
                  ],

                  // Treatments
                  if (widget.disease.treatments.isNotEmpty) ...[
                    _SectionCard(
                      icon: '💊',
                      title: 'Treatment Steps',
                      child: Column(
                        children: widget.disease.treatments
                            .asMap()
                            .entries
                            .map((e) => _NumberedStep(
                                  number: e.key + 1,
                                  text: e.value,
                                ))
                            .toList(),
                      ),
                    ).animate().slideY(begin: 0.2).fadeIn(delay: 300.ms),
                    const SizedBox(height: 16),
                  ],

                  // Prevention
                  if (widget.disease.preventions.isNotEmpty) ...[
                    _SectionCard(
                      icon: '🛡️',
                      title: 'Prevention Tips',
                      child: Column(
                        children: widget.disease.preventions
                            .map((p) => _BulletPoint(text: p, color: Colors.green))
                            .toList(),
                      ),
                    ).animate().slideY(begin: 0.2).fadeIn(delay: 400.ms),
                    const SizedBox(height: 16),
                  ],

                  // Find Supplier Button
                  if (!isHealthy) ...[
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SuppliersScreen(
                                language: widget.language,
                                searchTerm: widget.disease.diseaseName,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.store),
                        label: Text(
                          'Find Nearby Agri-Suppliers',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D7A3A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                      ),
                    ).animate().slideY(begin: 0.2).fadeIn(delay: 500.ms),
                    const SizedBox(height: 12),
                  ],

                  // Disclaimer
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Text('⚠️', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'AI analysis is for guidance only. Consult a local agricultural expert for serious cases.',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.amber[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 600.ms),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String icon;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: const Color(0xFF1A3C20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;
  final Color color;

  const _BulletPoint({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700], height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _NumberedStep extends StatelessWidget {
  final int number;
  final String text;

  const _NumberedStep({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: const Color(0xFF2D7A3A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$number',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700], height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
