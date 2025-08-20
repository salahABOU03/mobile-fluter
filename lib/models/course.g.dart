// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) => Course(
      id: (json['id'] as num).toInt(),
      activity: json['activity'] as String,
      date: json['date'] as String,
      status: json['status'] as String,
      moniteur: Moniteur.fromJson(json['moniteur'] as Map<String, dynamic>),
      client: json['client'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
      'id': instance.id,
      'activity': instance.activity,
      'date': instance.date,
      'status': instance.status,
      'moniteur': instance.moniteur,
      'client': instance.client,
    };
