import 'package:json_annotation/json_annotation.dart';
import 'package:my_flutter/model/RootModel.dart';
import 'package:my_flutter/model/article_list/ArticleListDataModel.dart';

part 'ArticleListModel.g.dart';

@JsonSerializable()
class ArticleListModel extends RootModel<ArticleListDataModel> {
  ArticleListModel(ArticleListDataModel data, int errorCode, String errorMsg)
      : super(data, errorCode, errorMsg);

  factory ArticleListModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleListModelFromJson(json);
}
