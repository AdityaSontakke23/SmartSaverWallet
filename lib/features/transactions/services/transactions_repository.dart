import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/auth_service.dart';

class TransactionsRepository {
  final _db = FirebaseFirestore.instance;
  final _auth = AuthService();

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection(AppConstants.colTransactions);

  String get _uid => _auth.uidOrThrow;

  
  Stream<QuerySnapshot<Map<String, dynamic>>> streamUserTransactions({
    DateTime? start,
    DateTime? end,
    String? type,
    int? limit,
  }) {
    Query<Map<String, dynamic>> q =
        _col.where(AppConstants.fUid, isEqualTo: _uid);

    if (type != null) {
      q = q.where(AppConstants.fType, isEqualTo: type);
    }
    if (start != null) {
      q = q.where(AppConstants.fDate,
          isGreaterThanOrEqualTo: Timestamp.fromDate(start));
    }
    if (end != null) {
      q = q.where(AppConstants.fDate,
          isLessThanOrEqualTo: Timestamp.fromDate(end));
    }
    q = q.orderBy(AppConstants.fDate, descending: true);
    if (limit != null) q = q.limit(limit);
    return q.snapshots();
  }

  
  Future<DocumentReference<Map<String, dynamic>>> addTransaction({
    required double amount,
    required String type,
    required String category,
    String? description,
    required DateTime date,
    List<String>? tags,
    String? budgetId,
    String? goalId,
    bool createIfGoalContributionIsIncome = true,
  }) async {
    final batch = _db.batch();
    final txRef = _col.doc();

    final data = <String, dynamic>{
      AppConstants.fUid: _uid,
      AppConstants.fAmount: amount,
      AppConstants.fType: type,
      AppConstants.fCategory: category,
      AppConstants.fDescription: description ?? '',
      AppConstants.fDate: Timestamp.fromDate(date),
      AppConstants.fCreatedAt: FieldValue.serverTimestamp(),
      AppConstants.fTags: tags ?? <String>[],
      AppConstants.fBudgetId: budgetId,
      AppConstants.fGoalId: goalId,
    };

    batch.set(txRef, data);

    
    if (type == AppConstants.txExpense && budgetId != null) {
      final budgetRef =
          _db.collection(AppConstants.colBudgets).doc(budgetId);
      batch.update(budgetRef, {
        AppConstants.fBudgetSpent: FieldValue.increment(amount),
      });
    }

    
    if (goalId != null) {
      final goalRef = _db.collection(AppConstants.colGoals).doc(goalId);
      batch.update(goalRef, {
        AppConstants.fGoalCurrentAmount: FieldValue.increment(amount),
      });
    }

    await batch.commit();
    return txRef;
  }


Future<void> updateTransaction(
  String txId, {
  double? amount,
  String? type,
  String? category,
  String? description,
  DateTime? date,
  List<String>? tags,
}) async {
  final docRef = _col.doc(txId);
  final snap = await docRef.get();
  
  if (!snap.exists || (snap.data()?[AppConstants.fUid] != _uid)) {
    throw StateError('Not authorized to modify this transaction');
  }

  final oldData = snap.data()!;
  final oldAmount = (oldData[AppConstants.fAmount] as num?)?.toDouble() ?? 0.0;
  final oldType = oldData[AppConstants.fType] as String?;
  final budgetId = oldData[AppConstants.fBudgetId] as String?;
  final goalId = oldData[AppConstants.fGoalId] as String?;

  final batch = _db.batch();
  final data = <String, dynamic>{};

  
  if (amount != null) data[AppConstants.fAmount] = amount;
  if (type != null) data[AppConstants.fType] = type;
  if (category != null) data[AppConstants.fCategory] = category;
  if (description != null) data[AppConstants.fDescription] = description;
  if (date != null) data[AppConstants.fDate] = Timestamp.fromDate(date);
  if (tags != null) data[AppConstants.fTags] = tags;

  if (data.isEmpty) return;

  
  batch.update(docRef, data);

  
  if (amount != null && amount != oldAmount && budgetId != null) {
    if (oldType == AppConstants.txExpense || type == AppConstants.txExpense) {
      final budgetRef = _db.collection(AppConstants.colBudgets).doc(budgetId);
      final delta = amount - oldAmount;
      batch.update(budgetRef, {
        AppConstants.fBudgetSpent: FieldValue.increment(delta),
      });
    }
  }

  
  if (amount != null && amount != oldAmount && goalId != null) {
    final goalRef = _db.collection(AppConstants.colGoals).doc(goalId);
    final delta = amount - oldAmount;
    batch.update(goalRef, {
      AppConstants.fGoalCurrentAmount: FieldValue.increment(delta),
    });
  }

  await batch.commit();
}


  
  Future<void> deleteTransaction(String txId) async {
    final docRef = _col.doc(txId);
    await _ensureOwner(docRef);
    await docRef.delete();
  }

  Future<void> _ensureOwner(DocumentReference<Map<String, dynamic>> ref) async {
    final snap = await ref.get();
    if (!snap.exists || (snap.data()?[AppConstants.fUid] != _uid)) {
      throw StateError('Not authorized to modify this transaction');
    }
  }
}
