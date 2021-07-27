import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  RegisterState createState() => new RegisterState();
}

class RegisterState extends State<RegisterPage> with TickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQueryData.fromWindow(window).padding.top),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 10.0,
                  left: 5.0,
                  right: 35.0,
                  bottom: 10.0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.angleLeft,
                        size: 30.0,
                        color: Color(0xff666666),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Text(
                      '注册',
                      style: TextStyle(
                        fontSize: 24.0,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    throw UnimplementedError();
  }
}
