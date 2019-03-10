import 'package:json_annotation/json_annotation.dart';

part 'UserDetailModel.g.dart';

/**
 * 实体类数据声明
 */
@JsonSerializable()
class UserDetailModel {
  List<String> chapterTops;
  List<int> collectIds;
  String email;
  String icon;
  int id;
  String password;
  String token;
  int type;
  String username;

  /**
   * 实体类构造方法
   */
  UserDetailModel(this.chapterTops, this.collectIds, this.email, this.icon,
      this.id, this.password, this.token, this.type, this.username);

  /**
   * 数据转化工厂 Json数据---->实体数据
   */
  factory UserDetailModel.fromJson(Map<String, dynamic> json) =>
      _$UserDetailModelFromJson(json);

  /**
   * 数据转化  实体数据---->Json数据
   */
  toJson() => _$UserDetailModelToJson(this);
}
