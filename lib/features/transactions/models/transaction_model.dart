import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';

class TransactionModel {
  final String id;
  final String uid;
  final double amount;
  final String type;
  final String category;
  final String description;
  final DateTime date;
  final DateTime? createdAt;
  final List<String> tags;
  final String? budgetId;
  final String? goalId;

  TransactionModel({
    required this.id,
    required this.uid,
    required this.amount,
    required this.type,
    required this.category,
    required this.description,
    required this.date,
    this.createdAt,
    this.tags = const <String>[],
    this.budgetId,
    this.goalId,
  });

  factory TransactionModel.fromDocument(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>? ?? {});
    final tsDate = data[AppConstants.fDate];
    final tsCreated = data[AppConstants.fCreatedAt];
    return TransactionModel(
      id: doc.id,
      uid: data[AppConstants.fUid] as String? ?? '',
      amount: (data[AppConstants.fAmount] as num?)?.toDouble() ?? 0.0,
      type: data[AppConstants.fType] as String? ?? AppConstants.txExpense,
      category: data[AppConstants.fCategory] as String? ?? '',
      description: (data[AppConstants.fDescription] as String?) ??
          (data['title'] as String? ?? ''),
      date: tsDate is Timestamp ? tsDate.toDate() : DateTime.fromMillisecondsSinceEpoch(0),
      createdAt: tsCreated is Timestamp ? tsCreated.toDate() : null,
      tags: (data[AppConstants.fTags] as List?)?.cast<String>() ?? const <String>[],
      budgetId: data[AppConstants.fBudgetId] as String?,
      goalId: data[AppConstants.fGoalId] as String?,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      AppConstants.fUid: uid,
      AppConstants.fAmount: amount,
      AppConstants.fType: type,
      AppConstants.fCategory: category,
      AppConstants.fDescription: description,
      AppConstants.fDate: Timestamp.fromDate(date),
      AppConstants.fCreatedAt: createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      AppConstants.fTags: tags,
      AppConstants.fBudgetId: budgetId,
      AppConstants.fGoalId: goalId,
    };
  }
}
