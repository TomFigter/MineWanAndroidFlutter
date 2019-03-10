import 'package:flutter/material.dart';
import 'package:my_flutter/api/CommonService.dart';
import 'package:my_flutter/common/GlobalConfig.dart';
import 'package:my_flutter/pages/article_list/ArticleListPage.dart';
import 'package:my_flutter/widget/BackBtn.dart';
import 'package:my_flutter/widget/ClearableInputField.dart';

class SearchDetailPage extends StatefulWidget {
  SearchDetailPage();

  @override
  State<StatefulWidget> createState() {
    return new _SearchDetailPageState();
  }
}

class _SearchDetailPageState extends State<SearchDetailPage> {
  String _key = "";
  GlobalKey<ArticleListPageState> _itemListPage = new GlobalKey();
  final String loadingMessage = "Search Whatever You Want";
  var _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(context),
      body: ArticleListPage(
        key: _itemListPage,
        emptyMsg: "It's Empty",
        request: (page) {
          return CommonService().getSearchListData(_key, page);
        },
      ),
    );
  }

  AppBar _buildAppbar(BuildContext context) {
    var originTheme = Theme.of(context);
    return AppBar(
      leading: BackBtn(),
      title: Theme(
          data: originTheme.copyWith(
            hintColor: GlobalConfig.color_white_a80,
            textTheme: TextTheme(subhead: TextStyle(color: Colors.white)),
          ),
          child: ClearableInputField(
            hintTxt: loadingMessage,
            controller: _controller,
            border: InputBorder.none,
            onchange: (str) {
              _key = str;
              _itemListPage.currentState.handleRefresh();
            },
          )),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

