// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivered_spare_of_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveredSpareOfModel _$DeliveredSpareOfModelFromJson(
        Map<String, dynamic> json) =>
    DeliveredSpareOfModel(
      id: json['id'],
      label:
          (json['label'] as List<dynamic>?)?.map((e) => e as String).toList(),
      name: json['name'] as String?,
      amount: json['amount'],
      measurementUnit: json['measurementUnit'],
      user: json['user'] as String?,
      totalAmount: json['totalAmount'],
      materialDeliveredDate: json['materialDeliveredDate'] as String?,
    );

Map<String, dynamic> _$DeliveredSpareOfModelToJson(
        DeliveredSpareOfModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'name': instance.name,
      'amount': instance.amount,
      'measurementUnit': instance.measurementUnit,
      'user': instance.user,
      'totalAmount': instance.totalAmount,
      'materialDeliveredDate': instance.materialDeliveredDate,
    };
