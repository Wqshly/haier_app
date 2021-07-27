import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// 模块函数，加载状态类组件 LoginPageState .
class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => new LoginPageState();
}

// 点击验证码前未作手机号验证，需补充验证内容。
// 有状态组件类，渲染成登录页面。
class LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  GlobalKey<FormState> _quickLoginFormKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // 焦点
  final FocusNode _focusNodePhoneNumber = FocusNode();
  final FocusNode _focusNodeValidCode = FocusNode();
  final FocusNode _focusNodeLoginUser = FocusNode();
  final FocusNode _focusNodeLoginPassword = FocusNode();

  // 用户名、密码控制器，监听用户名、密码输入框的操作
  TextEditingController phoneNumberController = new TextEditingController();
  TextEditingController validCodeController = new TextEditingController();
  TextEditingController loginUserController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  late Timer timer;
  int count = 60;
  String buttonText = '获取验证码';

  bool _isClearPhoneNum = false;
  bool _isClearValidCode = false;
  bool confirmAgreement = false;
  bool _isClearUser = false;
  bool _isClearPwd = false;
  bool passwordHidden = true;

  //按钮状态，是否可点击
  bool isSMSBtnEnable = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    phoneNumberController.addListener(() {
      _isClearPhoneNum = (phoneNumberController.text.length > 0) ? true : false;
      setState(() {});
    });
    validCodeController.addListener(() {
      _isClearValidCode = (validCodeController.text.length > 0) ? true : false;
      setState(() {});
    });
    loginUserController.addListener(() {
      _isClearUser = (loginUserController.text.length > 0) ? true : false;
      setState(() {});
    });
    loginPasswordController.addListener(() {
      if (loginPasswordController.text.length > 0) {
        _isClearPwd = true;
      } else {
        _isClearPwd = false;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phoneNumberController.dispose();
    validCodeController.dispose();
    _focusNodeLoginUser.dispose();
    _focusNodeLoginPassword.dispose();
    loginUserController.dispose();
    loginPasswordController.dispose();
    timer.cancel(); //销毁计时器
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
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
              Tab(text: "手机号快捷登录"),
              Tab(text: "帐号密码登录"),
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
          children: <Widget>[
            _quickLogin(context),
            _normalLogin(context),
          ],
        ),
      ),
    );
    throw UnimplementedError();
  }

  // 快速登录
  Widget _quickLogin(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Form(
            key: _quickLoginFormKey,
            child: Column(
              children: <Widget>[
                // 手机号栏
                Container(
                  margin: EdgeInsets.only(
                    top: 10.0,
                    left: 20.0,
                    right: 20.0,
                    bottom: 10.0,
                  ),
                  child: TextFormField(
                    focusNode: _focusNodePhoneNumber,
                    controller: phoneNumberController,
                    keyboardType: TextInputType.number,
                    validator: phoneNumValid,
                    style: TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 16.0,
                        color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 1.0),
                      fillColor: Color(0xFFF6F6F6),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      hintText: "请输入手机号",
                      hintStyle: TextStyle(
                          fontFamily: "WorkSansSemiBold", fontSize: 15.0),
                      prefix: SizedBox(
                        width: 20.0,
                      ),
                      suffixIcon: (_isClearPhoneNum &&
                              _focusNodePhoneNumber.hasFocus)
                          ? IconButton(
                              icon: Icon(
                                FontAwesomeIcons.timesCircle,
                                size: 18.0,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                // 清空输入框内容，flutter需要先移除焦点才能clear，否则会报错，此处控制build的生命周期插入指定时机才去运行方法
                                // 感叹号在后面，check作用，flutter2.0 新语法？。
                                WidgetsBinding.instance!.addPostFrameCallback(
                                    (_) => phoneNumberController.clear());
                              },
                            )
                          : null,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(11),
                    ],
                  ),
                ),
                // 验证码栏
                Container(
                  margin: EdgeInsets.only(
                    top: 10.0,
                    left: 20.0,
                    right: 20.0,
                    bottom: 10.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          focusNode: _focusNodeValidCode,
                          controller: validCodeController,
                          keyboardType: TextInputType.number,
                          validator: (val) =>
                              (val == null || val.isEmpty) ? "请输入验证码" : null,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 10),
                            fillColor: Color(0xFFF6F6F6),
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            hintText: "验证码",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 15.0),
                            prefix: SizedBox(
                              width: 20.0,
                            ),
                            suffixIcon: (_isClearValidCode &&
                                    _focusNodeValidCode.hasFocus)
                                ? IconButton(
                                    icon: Icon(
                                      FontAwesomeIcons.timesCircle,
                                      size: 18.0,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      // 清空输入框内容
                                      WidgetsBinding.instance!
                                          .addPostFrameCallback((_) =>
                                              validCodeController.clear());
                                    },
                                  )
                                : null,
                          ),
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(6),
                          ],
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          height: 48.0,
                          margin: EdgeInsets.only(left: 10.0),
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          decoration: BoxDecoration(
                            color: Color(0xFFF6F6F6),
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          child: Center(
                            child: Text(
                              '$buttonText',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        onTap: () {
                          if (isSMSBtnEnable &&
                              isPhoneNum(phoneNumberController.text)) {
                            getVerifyCode();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                // 登录按钮栏
                GestureDetector(
                  child: Container(
                    width: double.infinity,
                    height: 40.0,
                    margin: EdgeInsets.only(
                      top: 10.0,
                      left: 20.0,
                      right: 20.0,
                      bottom: 10.0,
                    ),
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    child: Center(
                      child: Text(
                        "登 录",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () {
                    quickLogin();
                  },
                ),
                // 用户协议栏
                Container(
                  margin: EdgeInsets.only(
                    top: 10.0,
                    left: 20.0,
                    right: 20.0,
                    bottom: 10.0,
                  ),
                  child: Row(
                    children: <Widget>[
                      // 自定义的原型勾选框，代替原有的勾选框。
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            confirmAgreement = !confirmAgreement;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: confirmAgreement
                              ? Icon(
                                  FontAwesomeIcons.checkCircle,
                                  size: 16.0,
                                  color: Colors.red,
                                )
                              : Icon(
                                  FontAwesomeIcons.circle,
                                  size: 16.0,
                                  color: Colors.grey,
                                ),
                        ),
                      ),
                      Text(
                        "已阅读并同意《",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        child: Text(
                          "用户服务协议",
                          style: TextStyle(
                            fontSize: 12.0,
                            decoration: TextDecoration.underline,
                            decorationColor: const Color(0xff000000),
                          ),
                        ),
                        onTap: () {
                          // 跳转至协议页面
                        },
                      ),
                      Text(
                        "》及《",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        child: Text(
                          "隐私保护协议",
                          style: TextStyle(
                            fontSize: 12.0,
                            decoration: TextDecoration.underline,
                            decorationColor: const Color(0xff000000),
                          ),
                        ),
                        onTap: () {
                          // 跳转至隐私保护协议页面
                        },
                      ),
                      Text(
                        "》",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 常规登录
  Widget _normalLogin(BuildContext context) {
    return new SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQueryData.fromWindow(window).padding.top),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: _buildLoginImg(context),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: _buildLoginForm(context),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: _buildLoginButton(context),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: _buildTextButton(context),
            ),
          ],
        ),
      ),
    );
  }

  // 登录页面上方的图片
  Widget _buildLoginImg(BuildContext context) {
    return new Image(
        width: double.infinity,
        height: 175,
        fit: BoxFit.contain,
        image: new AssetImage('assets/img/test.jpg'));
  }

  // 登录表单
  Widget _buildLoginForm(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Form(
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(left: 45, top: 20, right: 45, bottom: 15),
              child: TextFormField(
                focusNode: _focusNodeLoginUser,
                controller: loginUserController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                    fontFamily: "WorkSansSemiBold",
                    fontSize: 16.0,
                    color: Colors.black),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  fillColor: Color(0xFFF6F6F6),
                  filled: true,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(40)),
                  prefixIcon: Icon(
                    FontAwesomeIcons.userAstronaut,
                    color: Color(0xff00ffff),
                    size: 15.0,
                  ),
                  hintText: "用户名",
                  hintStyle:
                      TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 15.0),
                  suffixIcon: (_isClearUser && _focusNodeLoginUser.hasFocus)
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            size: 18.0,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            // 清空输入框内容
                            loginUserController.clear();
                          },
                        )
                      : null,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 45, top: 0, right: 45, bottom: 10),
              child: TextFormField(
                focusNode: _focusNodeLoginPassword,
                controller: loginPasswordController,
                obscureText: passwordHidden,
                style: TextStyle(
                    fontFamily: "WorkSansSemiBold",
                    fontSize: 16.0,
                    color: Colors.black),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  fillColor: Color(0xFFF6F6F6),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  prefixIcon: (_isClearPwd)
                      ? IconButton(
                          icon: Icon(
                            passwordHidden
                                ? FontAwesomeIcons.eye
                                : FontAwesomeIcons.eyeSlash,
                            size: 15.0,
                            color: Color(0xff00ffff),
                          ),
                          onPressed: () {
                            setState(() {
                              passwordHidden = !passwordHidden;
                            });
                          },
                        )
                      : Icon(
                          FontAwesomeIcons.lock,
                          size: 15.0,
                          color: Color(0xff00ffff),
                        ),
                  hintText: "密码",
                  hintStyle:
                      TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 15.0),
                  suffixIcon: (_isClearPwd && _focusNodeLoginPassword.hasFocus)
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            size: 18.0,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            // 清空输入框内容
                            loginPasswordController.clear();
                          },
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 登录按钮
  Widget _buildLoginButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      height: 75.0,
      child: FlatButton(
        onPressed: () async {
          login();
        },
        color: Colors.white70,
        child: Icon(
          FontAwesomeIcons.arrowRight,
          color: Color(0xff00ffff),
        ),
        shape: CircleBorder(),
      ),
    );
  }

  // 快速注册和忘记密码按钮
  Widget _buildTextButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      height: 30.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            child: Text(
              '用户注册',
            ),
            onTap: () {
              Navigator.of(context).pushNamed("/register");
            },
          ),
          GestureDetector(
            child: Text(
              '忘记密码',
            ),
          ),
        ],
      ),
    );
  }

  // 手机号是否合法 合法为 true
  static bool isPhoneNum(value) {
    RegExp exp = RegExp(
        '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$');
    return exp.hasMatch(value);
  }

  // 表单验证 - 手机号
  static String? phoneNumValid(value) {
    if (value.isEmpty) {
      return '手机号不能为空!';
    } else if (!isPhoneNum(value)) {
      return '请输入正确的手机号!';
    }
    return null;
  }

  // 获取验证码事件
  void getVerifyCode() async {
    try {
      Fluttertoast.showToast(
        msg: "发送成功~",
        timeInSecForIosWeb: 1,
      );
      // 设置按钮状态
      isSMSBtnEnable = false;
      // 计时器
      timer = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
        count--;
        setState(() {
          if (count == 0) {
            timer.cancel(); //倒计时结束取消定时器
            isSMSBtnEnable = true; //按钮可点击
            count = 60; //重置时间
            buttonText = '获取验证码'; //重置按钮文本
          } else {
            buttonText = '($count)s'; //更新文本内容
          }
        });
      });
    } catch (e) {}

//    try {
//      var response = await RequestUtil.initInstance()
//          .get("customer/quickLoginGetVerify/" + phoneNumberController.text);
//      if (response.data['code'] == 0) {
//        Fluttertoast.showToast(
//          msg: "发送成功~",
//          timeInSecForIosWeb: 1,
//        );
//        // 设置按钮状态
//        isButtonEnable = false;
//        // 计时器
//        timer = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
//          count--;
//          setState(() {
//            if (count == 0) {
//              timer.cancel(); //倒计时结束取消定时器
//              isButtonEnable = true; //按钮可点击
//              count = 60; //重置时间
//              buttonText = '获取验证码'; //重置按钮文本
//            } else {
//              buttonText = '($count)s'; //更新文本内容
//            }
//          });
//        });
//      } else if (response.data['code'] == 3002) {
//        Fluttertoast.showToast(
//          msg: "短时间内禁止多次发送验证码~",
//          timeInSecForIosWeb: 1,
//        );
//      }
//    } catch (e) {}
  }

  // 快速登录
  void quickLogin() async {
//    if () {}
    if (!confirmAgreement) {
      Fluttertoast.showToast(
        msg: "请勾选同意服务~",
        timeInSecForIosWeb: 1,
      );
    } else if (_quickLoginFormKey.currentState!.validate() &&
        confirmAgreement) {
      debugPrint('保存口令成功');
      Navigator.of(context)
          .pushNamedAndRemoveUntil("/mainPage", (router) => router == null);
    }
//    var data = {
//      "phone": phoneNumberController.text,
//      "code": validCodeController.text
//    };
//    if (_quickLoginFormKey.currentState!.validate() && confirmAgreement) {
//      Response res = await RequestUtil.getInstance().post("customer/quickLogin", data: data);
//      if (res.data['code'] == 0) {
//        CustomerInfo customerInfo = CustomerInfoEntity.fromJson(res.data).data;
//        final SharedPreferences prefs = await SharedPreferences.getInstance();
//        final setCustomerInfo = await prefs.setString('customerInfo', jsonEncode(customerInfo).toString());
//        if (setCustomerInfo) {
//      debugPrint('保存口令成功');
//      Navigator.of(context)
//          .pushNamedAndRemoveUntil("/mainPage", (router) => router == null);
//        } else if(res.data['code'] == -1005) {
//          Fluttertoast.showToast(
//            msg: "验证码无效~",
//            timeInSecForIosWeb: 1,
//          );
//        }
//      }
//    } else if (!confirmAgreement) {
//      Fluttertoast.showToast(
//        msg: "请勾选同意服务~",
//        timeInSecForIosWeb: 1,
//      );
//    }
  }

  // 普通登录
  void login() async {
    try {
      debugPrint('保存登录口令成功');
      Navigator.of(context)
          .pushNamedAndRemoveUntil("/mainPage", (router) => router == null);
    } catch (e) {
      print(e);
    }
//    var dio = Dio();
//    var path = Api.basicUrl + "customer/login4Phone";
//    var data = {
//      "phone": loginUserController.text,
//      "password": loginPasswordController.text
//    };
//    try {
//      Response response = await dio.post(path, data: data);
//      print(response.data);
//      if (response.data['code'] == 0) {
//        final prefs = await SharedPreferences.getInstance();
//        final setIdResult =
//        await prefs.setInt('user_id', response.data['data']['id']);
//        final setNameResult =
//        await prefs.setString('user_name', response.data['data']['name']);
//        final setNickNameResult = await prefs.setString(
//            'user_nick_name', response.data['data']['nickName']);
//        final setPhoneResult =
//        await prefs.setString('user_phone', data['phone']);
//        final setPasswordResult =
//        await prefs.setString('user_password', data['password']);
//        if (setPasswordResult &&
//            setIdResult &&
//            setNameResult &&
//            setNickNameResult &&
//            setPhoneResult) {
//          debugPrint('保存登录口令成功');
//          Navigator.of(context)
//              .pushNamedAndRemoveUntil("/mainPage", (router) => router == null);
//        } else {
//          debugPrint('error, 保存登录token失败');
//        }
//      } else if (response.data['code'] == -1) {
//        bool accountWrong = await accountWrongDialog();
//      }
//    } catch (e) {
//      print(e);
//    }
  }
}
