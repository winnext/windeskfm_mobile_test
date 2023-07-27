import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';


part 'generator_wo_create/wo_create_requestedby_model.g.dart';

@JsonSerializable()
class WoCreateRequestedByModel extends Equatable{
    final String? id;
    final int? createdTimestamp;
    final String? username;
    final bool? enabled;
    final bool? totp;
    final bool? emailVerified;
    final String? firstName;
    final String? lastName;
    final String? email;
    final List<dynamic>? disableableCredentialTypes;
    final List<String>? requiredActions;
    final int? notBefore;
    final dynamic? access;
    final dynamic? attributes;

    WoCreateRequestedByModel({
        this.id,
        this.createdTimestamp,
        this.username,
        this.enabled,
        this.totp,
        this.emailVerified,
        this.firstName,
        this.lastName,
        this.email,
        this.disableableCredentialTypes,
        this.requiredActions,
        this.notBefore,
        this.access,
        this.attributes,
    });
    factory WoCreateRequestedByModel.fromJson(Map<String, dynamic> json) => _$WoCreateRequestedByModelFromJson(json);

    Map<String, dynamic> toJson() => _$WoCreateRequestedByModelToJson(this);
    
      @override
      // TODO: implement props
      List<Object?> get props => [
        id,
        createdTimestamp,
        username,
        enabled,
        totp,
        emailVerified,
        firstName,
        lastName,
        email,
        disableableCredentialTypes,
        requiredActions,
        notBefore,
        access,
        attributes,
      ];

}