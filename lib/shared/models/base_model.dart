abstract class BaseModel<T> {
  String get id;
  Map<String, dynamic> toMap();
  T copyWith();
}
