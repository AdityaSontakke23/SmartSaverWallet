import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/auth_service.dart';

class GoalsRepository {
  final _db = FirebaseFirestore.instance;
  final _auth = AuthService();

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection(AppConstants.colGoals);

  String get _uid => _auth.uidOrThrow;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamUserGoals({
  bool? isCompleted,
  int? limit,
}) {
  Query<Map<String, dynamic>> q = _col.where(AppConstants.fUid, isEqualTo: _uid);
  

  
  if (limit != null) q = q.limit(limit);
  
  return q.snapshots();
}



  Future<DocumentReference<Map<String, dynamic>>> addGoal({
    required String title,
    required double targetAmount,
    DateTime? targetDate,
    String? category,
  }) async {
    final ref = _col.doc();
    await ref.set({
      AppConstants.fUid: _uid,
      AppConstants.fGoalTitle: title,
      AppConstants.fGoalTargetAmount: targetAmount,
      AppConstants.fGoalCurrentAmount: 0.0,
      AppConstants.fGoalTargetDate:
          targetDate != null ? Timestamp.fromDate(targetDate) : null,
      AppConstants.fCategory: category ?? '',
      AppConstants.fGoalIsCompleted: false,
      AppConstants.fCreatedAt: FieldValue.serverTimestamp(),
      AppConstants.fGoalArchived: false,
    });
    return ref;
  }

  Future<void> contributeToGoal({
    required String goalId,
    required double amount,
  }) async {
    final ref = _col.doc(goalId);
    final snap = await ref.get();
    if (!snap.exists || (snap.data()?[AppConstants.fUid] != _uid)) {
      throw StateError('Not authorized to modify this goal');
    }
    await ref.update({
      AppConstants.fGoalCurrentAmount: FieldValue.increment(amount),
    });
  }

  Future<void> markCompleted(String goalId) async {
    final ref = _col.doc(goalId);
    final snap = await ref.get();
    if (!snap.exists || (snap.data()?[AppConstants.fUid] != _uid)) {
      throw StateError('Not authorized to modify this goal');
    }
    await ref.update({AppConstants.fGoalIsCompleted: true});
  }



  Future<void> updateGoal({
    required String goalId,
    String? title,
    double? targetAmount,
    DateTime? targetDate,
    String? category,
  }) async {
    final ref = _col.doc(goalId);
    final snap = await ref.get();
    if (!snap.exists || (snap.data()?[AppConstants.fUid] != _uid)) {
      throw StateError('Not authorized to modify this goal');
    }

    final data = <String, dynamic>{};
    if (title != null) data[AppConstants.fGoalTitle] = title;
    if (targetAmount != null)
      data[AppConstants.fGoalTargetAmount] = targetAmount;
    if (targetDate != null) {
      data[AppConstants.fGoalTargetDate] = Timestamp.fromDate(targetDate);
    }
    if (category != null) data[AppConstants.fCategory] = category;

    if (data.isEmpty) return;
    await ref.update(data);
  }

  Future<void> deleteGoal(String goalId) async {
    final ref = _col.doc(goalId);
    final snap = await ref.get();
    if (!snap.exists || (snap.data()?[AppConstants.fUid] != _uid)) {
      throw StateError('Not authorized to delete this goal');
    }
    await ref.delete();
  }

  Future<void> archiveGoal(String goalId) async {
    final ref = _col.doc(goalId);
    final snap = await ref.get();
    if (!snap.exists || (snap.data()?[AppConstants.fUid] != _uid)) {
      throw StateError('Not authorized to modify this goal');
    }
    await ref.update({AppConstants.fGoalArchived: true});
  }

}
