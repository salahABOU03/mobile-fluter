// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moniteur.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Moniteur _$MoniteurFromJson(Map<String, dynamic> json) => Moniteur(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$MoniteurToJson(Moniteur instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'role': instance.role,
    };
