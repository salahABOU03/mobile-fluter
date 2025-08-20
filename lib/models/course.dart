import 'package:json_annotation/json_annotation.dart';
import 'moniteur.dart';

part 'course.g.dart';

@JsonSerializable()
class Course {
  final int id;
  final String activity;
  final String date;
  final String status;
  final Moniteur moniteur;
  final Map<String, dynamic> client;

  Course({
    required this.id,
    required this.activity,
    required this.date,
    required this.status,
    required this.moniteur,
    required this.client,
  });

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
  Map<String, dynamic> toJson() => _$CourseToJson(this);
}
