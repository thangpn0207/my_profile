// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_info_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyInfoState _$MyInfoStateFromJson(Map<String, dynamic> json) => MyInfoState(
      userInfo:
          json['userInfo'] == null ? null : UserInfo.fromJson(json['userInfo']),
      moreInfos: (json['moreInfos'] as List<dynamic>?)
              ?.map(MoreInfo.fromJson)
              .toList() ??
          const [],
      myProjects: (json['myProjects'] as List<dynamic>?)
              ?.map(MyProject.fromJson)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$MyInfoStateToJson(MyInfoState instance) =>
    <String, dynamic>{
      'userInfo': instance.userInfo,
      'moreInfos': instance.moreInfos,
      'myProjects': instance.myProjects,
    };
