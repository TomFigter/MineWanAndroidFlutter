import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter/api/Api.dart';
import 'package:my_flutter/common/GlobalConfig.dart';
import 'package:my_flutter/common/Router.dart';
import 'package:my_flutter/fonts/IconF.dart';
import 'package:my_flutter/model/article_list/ArticleItemModel.dart';
import 'package:my_flutter/utils/StringUtil.dart';
import 'package:my_flutter/widget/StrokeWidget.dart';

class ArticleItemPage extends StatelessWidget {
  final ArticleItemModel item;

  ArticleItemPage(this.item);

  @override
  Widget build(BuildContext context) {
    //去掉html中的高亮
    item.title = item.title
        .replaceAll(RegExp("(<em[^>]*>)|(</em>)"), "")
        .replaceAll("&mdash;", "-");

    item.desc = (null == item.desc)
        ? ""
        : item.desc
            .replaceAll(RegExp("(<em[^>]*>)|(</em>)"), "")
            .replaceAll("&mdash;", "-")
            .replaceAll(RegExp("\n{2,}"), "\n")
            .replaceAll(RegExp("\s{2,}"), " ");

    return GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        Router().openArticlePage(context, item);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.5),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)), //Item的圆角卡
          ),
          elevation: 5.0,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: _buildListViewItem(item),
          ),
        ),
      ),
    );
  }

  /**
   * Item的布局
   */
  Widget _buildListViewItem(ArticleItemModel item) {
    var widget = (null != item.envelopePic &&
            item.envelopePic.isNotEmpty &&
            !item.envelopePic.endsWith(Api.DEFAULT_PROJECT_IMG)) //默认图片就不显示了
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: _buildItemLeftSide(item),
              ),
              Container(
                width: 70.0,
                child: CachedNetworkImage(
                  //缓存网络照片
                  fadeInDuration: Duration(milliseconds: 15),
                  fadeOutDuration: Duration(milliseconds: 0),
                  imageUrl: item.envelopePic,
                ),
              )
            ],
          ) //此布局为显示图片
        : _buildItemLeftSide(item);

    return widget;
  }

  /**
   * Item的左侧布局
   */
  Widget _buildItemLeftSide(ArticleItemModel item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: _buildItemLeftColumns(item),
    );
  }

  List<Widget> _buildItemLeftColumns(ArticleItemModel item) {
    List<Widget> list = List();
    list.add(Text(
      item.title,
      style: TextStyle(
          fontSize: 16.0,
          color: GlobalConfig.color_black,
          fontWeight: FontWeight.w500),
      textAlign: TextAlign.left,
    ));
    if (item.desc.length > item.title.length) {
      list.add(Text(
        item.desc,
        maxLines: 3,
        style: TextStyle(color: GlobalConfig.color_dark_gray, fontSize: 13.0),
      ));
    }
    list.add(Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            IconF.time,
            size: 13.0,
            color: GlobalConfig.color_dark_gray,
          ),
          Text(" ${item.niceDate} @${item.author}",
              style: TextStyle(
                  color: GlobalConfig.color_dark_gray, fontSize: 13.0))
        ],
      ),
    ));
    var tags = _buildTagsAndDate(item);
    if (tags.length > 0) {
      list.add(Row(
        textBaseline: TextBaseline.ideographic,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: tags,
      ));
    }
    return list;
  }

  List<Widget> _buildTagsAndDate(ArticleItemModel item) {
    List<Widget> list = List();

    item.tags?.forEach((tag) {
      list.add(StrokeWidget(
          strokeWidth: 0.5,
          edgeInsets: EdgeInsets.symmetric(horizontal: 2.0, vertical: 0.0),
          color: GlobalConfig.color_tags,
          childWidget: Text(
            tag.name,
            style: TextStyle(
                fontSize: 11.0,
                color: GlobalConfig.color_tags,
                fontWeight: FontWeight.w100),
          )));
    });
    String chapterNameStr =
        "${StringUtil.isNullOrEmpty(item.superChapterName) ? "" : "${(list.length <= 0 ? "分类：" : "  ")}${item.superChapterName}"}"
        "${(StringUtil.isNullOrEmpty(item.superChapterName) || StringUtil.isNullOrEmpty(item.chapterName)) ? "" : "/"}"
        "${StringUtil.isNullOrEmpty(item.chapterName) ? "" : item.chapterName}";
    if (!StringUtil.isNullOrEmpty(chapterNameStr.trim())) {
      list.add(Text(
        chapterNameStr,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 13.0, color: GlobalConfig.color_dark_gray),
      ));
    }
    return list;
  }
}
