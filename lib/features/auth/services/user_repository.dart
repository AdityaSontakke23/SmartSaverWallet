import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/auth_service.dart';

class UserRepository {
  final _db = FirebaseFirestore.instance;
  final _auth = AuthService();

  DocumentReference<Map<String, dynamic>> get _doc =>
      _db.collection(AppConstants.colUsers).doc(_auth.uidOrThrow);


  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUserDoc() {
    return _doc.snapshots();
  }


  Future<void> updateProfile({
    String? name,
    String? photoURL,
    String? currency,
    String? theme,
    bool? notificationsEnabled,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) {
      data['${AppConstants.fProfile}.${AppConstants.fProfileName}'] = name;
    }
    if (photoURL != null) {
      data['${AppConstants.fProfile}.${AppConstants.fProfilePhotoURL}'] =
          photoURL;
    }
    if (currency != null) {
      data['${AppConstants.fProfile}.${AppConstants.fProfileCurrency}'] =
          currency;
    }
    if (theme != null) {
      data['${AppConstants.fProfile}.${AppConstants.fProfileTheme}'] = theme;
    }
    if (notificationsEnabled != null) {
      data['${AppConstants.fProfile}.${AppConstants.fProfileNotificationsEnabled}'] =
          notificationsEnabled;
    }
    if (data.isEmpty) return;
    await _doc.set(data, SetOptions(merge: true));
  }


  Future<void> updateSettings({
    bool? budgetAlerts,
    bool? goalReminders,
    bool? monthlyReports,
  }) async {
    final data = <String, dynamic>{};
    if (budgetAlerts != null) {
      data['${AppConstants.fSettings}.${AppConstants.fSettingsBudgetAlerts}'] =
          budgetAlerts;
    }
    if (goalReminders != null) {
      data['${AppConstants.fSettings}.${AppConstants.fSettingsGoalReminders}'] =
          goalReminders;
    }
    if (monthlyReports != null) {
      data['${AppConstants.fSettings}.${AppConstants.fSettingsMonthlyReports}'] =
          monthlyReports;
    }
    if (data.isEmpty) return;
    await _doc.set(data, SetOptions(merge: true));
  }
}
