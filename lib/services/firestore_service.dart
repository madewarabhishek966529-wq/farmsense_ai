import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/disease_model.dart';

class FirestoreService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static String get _uid => _auth.currentUser?.uid ?? 'anonymous';

  /// Save scan history to Firestore
  static Future<void> saveScanResult({
    required DiseaseResult result,
    required String imageUrl,
    String? location,
  }) async {
    await _db
        .collection('users')
        .doc(_uid)
        .collection('scans')
        .add({
      ...result.toJson(),
      'imageUrl': imageUrl,
      'location': location,
      'userId': _uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Get scan history
  static Stream<QuerySnapshot> getScanHistory() {
    return _db
        .collection('users')
        .doc(_uid)
        .collection('scans')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots();
  }

  /// Get nearby agri-suppliers (mock data — replace with real Firestore data)
  static Future<List<AgriSupplier>> getNearbySuppliers({
    double? lat,
    double? lng,
  }) async {
    // In production, query Firestore with geohash or use Google Places API
    // For prototype, returning mock data
    return [
      AgriSupplier(
        name: 'Green Valley Agro Store',
        address: '12, Farm Road, Near Bus Stand',
        phone: '+91 98765 43210',
        distance: 1.2,
        rating: 4.5,
        products: ['Fungicides', 'Pesticides', 'Seeds', 'Fertilizers'],
      ),
      AgriSupplier(
        name: 'Kisan Agri Centre',
        address: 'Main Market, Agricultural Zone',
        phone: '+91 87654 32109',
        distance: 2.8,
        rating: 4.2,
        products: ['Organic Pesticides', 'Bio Fertilizers', 'Seeds'],
      ),
      AgriSupplier(
        name: 'Farmer\'s Friend Store',
        address: 'NH-44, Village Chowk',
        phone: '+91 76543 21098',
        distance: 4.1,
        rating: 4.7,
        products: ['Herbicides', 'Growth Regulators', 'Seeds'],
      ),
    ];
  }

  /// Save user preferences
  static Future<void> saveUserPreference({
    required String language,
    required String region,
  }) async {
    await _db.collection('users').doc(_uid).set({
      'language': language,
      'region': region,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Get user preferences
  static Future<Map<String, dynamic>?> getUserPreferences() async {
    final doc = await _db.collection('users').doc(_uid).get();
    return doc.data();
  }

  /// Sign in anonymously for prototype
  static Future<void> signInAnonymously() async {
    if (_auth.currentUser == null) {
      await _auth.signInAnonymously();
    }
  }
}
