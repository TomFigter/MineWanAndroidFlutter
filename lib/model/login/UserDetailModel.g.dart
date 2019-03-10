part of 'UserDetailModel.dart';
/**
 * Json与实体数据之间互转
 */
//Json转换成实体数据
UserDetailModel _$UserDetailModelFromJson(Map<String, dynamic> json) {
  return UserDetailModel(
      (json['chapterTops'] as List)?.map((e) => e as String)?.toList(),
      (json['collectIds'] as List)?.map((e) => e as int)?.toList(),
      json['email'] as String,
      json['icon'] as String,
      json['id'] as int,
      json['password'] as String,
      json['token'] as String,
      json['type'] as int,
      json['username'] as String);
}
/**
 * 实体数据转换成Json
 */
Map<String,dynamic> _$UserDetailModelToJson(UserDetailModel instance)=>
    <String,dynamic>{
      'chapterTops':instance.chapterTops,
      'collectIds':instance.collectIds,
      'email': instance.email,
      'icon': instance.icon,
      'id':instance.id,
      'password':instance.password,
      'token':instance.token,
      'type':instance.type,
      'username':instance.username
    };
