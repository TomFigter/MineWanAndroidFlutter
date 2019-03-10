import 'package:json_annotation/json_annotation.dart';
import 'package:my_flutter/model/RootModel.dart';
import 'package:my_flutter/model/homebanner/HomeBannerItemModel.dart';

part 'HomeBannerModel.g.dart';

@JsonSerializable()
class HomeBannerModel extends RootModel<List<HomeBannerItemModel>> {
  HomeBannerModel(
      List<HomeBannerItemModel> data, int errorCode, String errorMsg)
      : super(data, errorCode, errorMsg);

  factory HomeBannerModel.fromJson(Map<String, dynamic> json) =>
      _$HomeBannerModelFromJson(json);

  toJson() => _$HomeBannerModelToJson(this);
}
