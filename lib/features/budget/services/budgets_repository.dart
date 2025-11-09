import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/auth_service.dart';

class BudgetsRepository {
  final _db = FirebaseFirestore.instance;
  final _auth = AuthService();

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection(AppConstants.colBudgets);

  String get _uid => _auth.uidOrThrow;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamUserBudgets({
    String? month,
    bool? isActive,
    int? limit,
  }) {
    Query<Map<String, dynamic>> q =
        _col.where(AppConstants.fUid, isEqualTo: _uid);
    if (month != null) {
      q = q.where(AppConstants.fBudgetMonth, isEqualTo: month);
    }
    if (isActive != null) {
      q = q.where(AppConstants.fBudgetIsActive, isEqualTo: isActive);
    }
    q = q.orderBy(AppConstants.fCreatedAt, descending: true);
    if (limit != null) q = q.limit(limit);
    return q.snapshots();
  }


  Future<DocumentReference<Map<String, dynamic>>> addBudget({
    required String category,
    required double amount,
    String? title,
    String? month,
    DateTime? startDate,
    DateTime? endDate,
    bool isActive = true,
  }) async {
    final docRef = _col.doc();
    await docRef.set({
      AppConstants.fUid: _uid,
      AppConstants.fCategory: category,
      AppConstants.fBudgetTitle: title ?? '',
      AppConstants.fAmount: amount,
      AppConstants.fBudgetSpent: 0.0,
      AppConstants.fBudgetMonth: month,
      AppConstants.fBudgetStartDate:
          startDate != null ? Timestamp.fromDate(startDate) : null,
      AppConstants.fBudgetEndDate:
          endDate != null ? Timestamp.fromDate(endDate) : null,
      AppConstants.fBudgetIsActive: isActive,
      AppConstants.fCreatedAt: FieldValue.serverTimestamp(),
    });
    return docRef;
  }

  Future<void> addSpend({
    required String budgetId,
    required double amount,
  }) async {
    final ref = _col.doc(budgetId);
    final snap = await ref.get();
    if (!snap.exists || (snap.data()?[AppConstants.fUid] != _uid)) {
      throw StateError('Not authorized to modify this budget');
    }
    await ref.update({
      AppConstants.fBudgetSpent: FieldValue.increment(amount),
    });
  }

  Future<void> updateBudget(
    String budgetId, {
    String? category,
    String? title,
    double? amount,
    bool? isActive,
  }) async {
    final ref = _col.doc(budgetId);
    final snap = await ref.get();
    if (!snap.exists || (snap.data()?[AppConstants.fUid] != _uid)) {
      throw StateError('Not authorized to modify this budget');
    }
    final data = <String, dynamic>{};
    if (category != null) data[AppConstants.fCategory] = category;
    if (title != null) data[AppConstants.fBudgetTitle] = title;
    if (amount != null) data[AppConstants.fAmount] = amount;
    if (isActive != null) data[AppConstants.fBudgetIsActive] = isActive;
    if (data.isEmpty) return;
    await ref.update(data);
  }

Future<void> deleteBudget(String budgetId) async {
    final ref = _col.doc(budgetId);
    final snap = await ref.get();
    if (!snap.exists || (snap.data()?[AppConstants.fUid] != _uid)) {
      throw StateError('Not authorized to delete this budget');
    }
    await ref.delete();
  }

}
