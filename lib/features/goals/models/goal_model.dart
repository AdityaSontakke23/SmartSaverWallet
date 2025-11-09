import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';

class GoalModel {
  final String id;
  final String uid;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final DateTime? targetDate;
  final String? category;
  final bool isCompleted;
  final bool archived;
  final DateTime? createdAt;

  GoalModel({
    required this.id,
    required this.uid,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    this.targetDate,
    this.category,
    required this.isCompleted,
    required this.archived,
    this.createdAt,
  });

  factory GoalModel.fromDocument(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>? ?? {});
    final tsTarget = data[AppConstants.fGoalTargetDate];
    final tsCreated = data[AppConstants.fCreatedAt];
    return GoalModel(
      id: doc.id,
      uid: data[AppConstants.fUid] as String? ?? '',
      title: data[AppConstants.fGoalTitle] as String? ?? '',
      targetAmount: (data[AppConstants.fGoalTargetAmount] as num?)?.toDouble() ?? 0.0,
      currentAmount: (data[AppConstants.fGoalCurrentAmount] as num?)?.toDouble() ?? 0.0,
      targetDate: tsTarget is Timestamp ? tsTarget.toDate() : null,
      category: data[AppConstants.fCategory] as String?,
      isCompleted: data[AppConstants.fGoalIsCompleted] as bool? ?? false,
      archived: data[AppConstants.fGoalArchived] as bool? ?? false,
      createdAt: tsCreated is Timestamp ? tsCreated.toDate() : null,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      AppConstants.fUid: uid,
      AppConstants.fGoalTitle: title,
      AppConstants.fGoalTargetAmount: targetAmount,
      AppConstants.fGoalCurrentAmount: currentAmount,
      AppConstants.fGoalTargetDate: targetDate != null ? Timestamp.fromDate(targetDate!) : null,
      AppConstants.fCategory: category,
      AppConstants.fGoalIsCompleted: isCompleted,
      AppConstants.fGoalArchived: archived,
      AppConstants.fCreatedAt: createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }
}
