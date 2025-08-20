import 'package:json_annotation/json_annotation.dart';

part 'moniteur.g.dart';

@JsonSerializable()
class Moniteur {
  final int id;
  final String username;
  final String role;

  Moniteur({
    required this.id,
    required this.username,
    required this.role,
  });

  factory Moniteur.fromJson(Map<String, dynamic> json) =>
      _$MoniteurFromJson(json);

  Map<String, dynamic> toJson() => _$MoniteurToJson(this);
}
