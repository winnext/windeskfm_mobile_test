// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserGroupModel _$UserGroupModelFromJson(Map<String, dynamic> json) =>
    UserGroupModel(
      id: json['id'] as int?,
      labels:
          (json['labels'] as List<dynamic>?)?.map((e) => e as String).toList(),
      name: json['name'] as String?,
    );
