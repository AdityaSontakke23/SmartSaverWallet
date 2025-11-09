import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'storage_service.dart';
import '../constants/app_constants.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final StorageService _storage = StorageService();


  User? get currentUser => _auth.currentUser;
  String get uidOrThrow {
    final u = _auth.currentUser;
    if (u == null) {
      throw StateError('No authenticated user');
    }
    return u.uid;
  }


  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserCredential> signUp(String email, String password, {String? displayName}) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    if (displayName != null && displayName.isNotEmpty) {
      await cred.user?.updateDisplayName(displayName);
    }
    await _ensureUserDoc(cred.user!);
    await _storage.setLoggedIn(true);
    await _storage.setUserId(cred.user!.uid);
    return cred;
  }


  Future<UserCredential> login(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    await _storage.setLoggedIn(true);
    await _storage.setUserId(cred.user!.uid);
    return cred;
  }


  Future<void> logout() async {
    await _auth.signOut();
    await _storage.setLoggedIn(false);
    await _storage.setUserId('');
  }


  Future<void> _ensureUserDoc(User user) async {
    final docRef = _db.collection(AppConstants.colUsers).doc(user.uid);
    final snap = await docRef.get();
    if (snap.exists) return;

    await docRef.set({
      AppConstants.fProfile: {
        AppConstants.fProfileName: user.displayName ?? '',
        AppConstants.fProfileEmail: user.email ?? '',
        AppConstants.fProfilePhotoURL: user.photoURL,
        AppConstants.fCreatedAt: FieldValue.serverTimestamp(),
        AppConstants.fProfileCurrency: 'USD',
        AppConstants.fProfileTheme: 'system',
        AppConstants.fProfileNotificationsEnabled: true,
      },
      AppConstants.fSettings: {
        AppConstants.fSettingsBudgetAlerts: true,
        AppConstants.fSettingsGoalReminders: true,
        AppConstants.fSettingsMonthlyReports: true,
      },
    }, SetOptions(merge: true));
  }


  Future<void> updateProfile({String? name, String? photoURL, String? currency, String? theme, bool? notificationsEnabled}) async {
    final uid = uidOrThrow;
    final data = <String, dynamic>{};
    if (name != null) data['${AppConstants.fProfile}.${AppConstants.fProfileName}'] = name;
    if (photoURL != null) data['${AppConstants.fProfile}.${AppConstants.fProfilePhotoURL}'] = photoURL;
    if (currency != null) data['${AppConstants.fProfile}.${AppConstants.fProfileCurrency}'] = currency;
    if (theme != null) data['${AppConstants.fProfile}.${AppConstants.fProfileTheme}'] = theme;
    if (notificationsEnabled != null) {
      data['${AppConstants.fProfile}.${AppConstants.fProfileNotificationsEnabled}'] = notificationsEnabled;
    }
    if (data.isEmpty) return;
    await _db.collection(AppConstants.colUsers).doc(uid).set(data, SetOptions(merge: true));
  }

  Future<void> updateSettings({bool? budgetAlerts, bool? goalReminders, bool? monthlyReports}) async {
    final uid = uidOrThrow;
    final data = <String, dynamic>{};
    if (budgetAlerts != null) data['${AppConstants.fSettings}.${AppConstants.fSettingsBudgetAlerts}'] = budgetAlerts;
    if (goalReminders != null) data['${AppConstants.fSettings}.${AppConstants.fSettingsGoalReminders}'] = goalReminders;
    if (monthlyReports != null) data['${AppConstants.fSettings}.${AppConstants.fSettingsMonthlyReports}'] = monthlyReports;
    if (data.isEmpty) return;
    await _db.collection(AppConstants.colUsers).doc(uid).set(data, SetOptions(merge: true));
  }
}
