import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';

class BudgetModel {
  final String id;
  final String uid;
  final String category;
  final String title;
  final double amount;
  final double spent;
  final String? month;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isActive;
  final DateTime? createdAt;

  BudgetModel({
    required this.id,
    required this.uid,
    required this.category,
    required this.title,
    required this.amount,
    required this.spent,
    this.month,
    this.startDate,
    this.endDate,
    required this.isActive,
    this.createdAt,
  });

  factory BudgetModel.fromDocument(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>? ?? {});
    final tsStart = data[AppConstants.fBudgetStartDate];
    final tsEnd = data[AppConstants.fBudgetEndDate];
    final tsCreated = data[AppConstants.fCreatedAt];
    return BudgetModel(
      id: doc.id,
      uid: data[AppConstants.fUid] as String? ?? '',
      category: data[AppConstants.fCategory] as String? ?? '',
      title: data[AppConstants.fBudgetTitle] as String? ?? '',
      amount: (data[AppConstants.fAmount] as num?)?.toDouble() ?? 0.0,
      spent: (data[AppConstants.fBudgetSpent] as num?)?.toDouble() ?? 0.0,
      month: data[AppConstants.fBudgetMonth] as String?,
      startDate: tsStart is Timestamp ? tsStart.toDate() : null,
      endDate: tsEnd is Timestamp ? tsEnd.toDate() : null,
      isActive: data[AppConstants.fBudgetIsActive] as bool? ?? true,
      createdAt: tsCreated is Timestamp ? tsCreated.toDate() : null,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      AppConstants.fUid: uid,
      AppConstants.fCategory: category,
      AppConstants.fBudgetTitle: title,
      AppConstants.fAmount: amount,
      AppConstants.fBudgetSpent: spent,
      AppConstants.fBudgetMonth: month,
      AppConstants.fBudgetStartDate: startDate != null ? Timestamp.fromDate(startDate!) : null,
      AppConstants.fBudgetEndDate: endDate != null ? Timestamp.fromDate(endDate!) : null,
      AppConstants.fBudgetIsActive: isActive,
      AppConstants.fCreatedAt: createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }
}
