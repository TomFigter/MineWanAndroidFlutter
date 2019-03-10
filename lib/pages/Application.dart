import 'package:flutter/material.dart';
import 'package:my_flutter/fonts/IconF.dart';
import 'package:my_flutter/common/GlobalConfig.dart';
import 'package:my_flutter/common/User.dart';
import 'package:my_flutter/pages/home/HomePage.dart';
import 'package:my_flutter/pages/knowledge_systems/KnowledgeSystemsPage.dart';
import 'package:my_flutter/pages/left_scaffold/LearnScaffold.dart';
import 'package:my_flutter/pages/project/ProjectPage.dart';
import 'package:my_flutter/pages/wechat/MineWeChatPage.dart';
class ApplicationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ApplicationPageState();
  }
}

class ApplicationPageState extends State<ApplicationPage>
    with SingleTickerProviderStateMixin {
  int _page = 0;
  PageController _pageController;

  //底部菜单栏
  final List<BottomNavigationBarItem> _bottomTabs = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
        icon: Icon(IconF.blog),
        title: Text(GlobalConfig.homeTab),
        backgroundColor: GlobalConfig.colorPrimary),
    BottomNavigationBarItem(
        icon: Icon(IconF.project),
        title: Text(GlobalConfig.projectTab),
        backgroundColor: GlobalConfig.colorPrimary),
    BottomNavigationBarItem(
        icon: Icon(IconF.wechat),
        title: Text(GlobalConfig.weChatTab),
        backgroundColor: GlobalConfig.colorPrimary),
    BottomNavigationBarItem(
        icon: Icon(IconF.tree),
        title: Text(GlobalConfig.knowledgeSystemsTab),
        backgroundColor: GlobalConfig.colorPrimary),

  ];

  /**
   * 在StatefulWidget调用createState之后，框架将新的状态对象插入树中，然后调用状态对象的initState。
   * 子类化State可以重写initState，以完成仅需要执行一次的工作。
   * 例如，您可以重写initState以配置动画或订阅platform services。initState的实现中需要调用super.initState。
   * 相当于Activity的onCreate()
   */
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: this._page); //初始页面下标序号
  }

  /**
   * 当一个状态对象不再需要时，框架调用状态对象的dispose。 您可以覆盖该dispose方法来执行清理工作。
   * 例如，您可以覆盖dispose取消定时器或取消订阅platform services。 dispose典型的实现是直接调用super.dispose。
   * 应该相当于Android Activity生命周期中的Destory()
   */
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User().refreshUserData();
    return DefaultTabController(
      length: _bottomTabs.length,
      child: new Scaffold(
        drawer: new Drawer(
          child: new LearnScaffold(),
          elevation: 10.0,
          semanticLabel: "提示",
        ),
        primary: true,
        body: PageView(
          children: <Widget>[
            HomePage(),
            ProjectPage(),
            MineWeChatPage(),
            KnowledgeSystemsPage(),
          ],
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: onPageChanged,
          controller: _pageController,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: _bottomTabs,
          currentIndex: _page,
          fixedColor: GlobalConfig.color_tags,
          type: BottomNavigationBarType.fixed,
          onTap: onTap,
        ),
      ),
    );
  }



  void onTap(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
}
