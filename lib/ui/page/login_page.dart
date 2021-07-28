import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          elevation: 0,
          centerTitle: true,
          title: Text(
            '登 录',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.white,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: "帐号密码登录"),
              Tab(text: "手机号快捷登录"),
            ],
            labelStyle: TextStyle(
              fontSize: 14.0,
            ),
            labelColor: Colors.red,
            unselectedLabelColor: Colors.grey,
            indicator: BoxDecoration(),
          ),
        ),
        body: TabBarView(
          children: [
            _NormalLoginPage(),
            _QuickLoginPage(),
          ],
        ),
      ),
    );
  }
}

class _NormalLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const SizedBox()
        ],
      ),
    );
  }
}

class _QuickLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
