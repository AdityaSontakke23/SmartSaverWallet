import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/auth_service.dart'; // fixed singular file name
import '../../../core/constants/app_constants.dart';
import '../models/user_model.dart';

class AuthRepository {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up: create auth user, ensure users/{uid} exists, set display name, then read user doc
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final UserCredential cred = await _authService.signUp(
      email,
      password,
      displayName: name,
    ); // AuthService ensures users/{uid} with profile/settings
    final uid = cred.user!.uid;

    // Optionally update profile name field in Firestore map
    await _authService.updateProfile(name: name);

    final snapshot =
        await _firestore.collection(AppConstants.colUsers).doc(uid).get();
    return UserModel.fromDocument(snapshot);
  }

  // Login: authenticate, then fetch users/{uid}
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final UserCredential cred = await _authService.login(email, password);
    final uid = cred.user!.uid;

    final snapshot =
        await _firestore.collection(AppConstants.colUsers).doc(uid).get();
    return UserModel.fromDocument(snapshot);
  }

  // Logout
  Future<void> logout() async {
    await _authService.logout();
  }

  // Get current user model (reads users/{uid})
  Future<UserModel?> getCurrentUser() async {
    final user = _authService.currentUser;
    if (user == null) return null;

    final snapshot =
        await _firestore.collection(AppConstants.colUsers).doc(user.uid).get();
    return UserModel.fromDocument(snapshot);
  }

// Password reset
Future<void> resetPassword({required String email}) async {
  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
}



  // Stream auth state mapped to users/{uid}
  Stream<UserModel?> userChanges() {
    return _authService.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      final snapshot =
          await _firestore.collection(AppConstants.colUsers).doc(user.uid).get();
      return UserModel.fromDocument(snapshot);
    });
  }
}
