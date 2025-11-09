import 'package:cloud_firestore/cloud_firestore.dart';


class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? photoURL;
  final String currency;
  final String theme;
  final bool notificationsEnabled;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoURL,
    this.currency = 'USD',
    this.theme = 'system',
    this.notificationsEnabled = true,
    required this.createdAt,
  });


  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['profile']['name'] as String? ?? '',
      email: data['profile']['email'] as String? ?? '',
      photoURL: data['profile']['photoURL'] as String?,
      currency: data['profile']['currency'] as String? ?? 'USD',
      theme: data['profile']['theme'] as String? ?? 'system',
      notificationsEnabled:
          data['settings']['notificationsEnabled'] as bool? ?? true,
      createdAt: (data['profile']['createdAt'] as Timestamp).toDate(),
    );
  }


  Map<String, dynamic> toDocument() {
    return {
      'profile': {
        'name': name,
        'email': email,
        'photoURL': photoURL,
        'currency': currency,
        'theme': theme,
        'createdAt': Timestamp.fromDate(createdAt),
      },
      'settings': {
        'notificationsEnabled': notificationsEnabled,
        'budgetAlerts': true,
        'goalReminders': true,
        'monthlyReports': true,
      },
    };
  }
}
