import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _phoneEditController;
  TextEditingController _verifyCodeEditController;

  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _verifyCodeFocusNode = FocusNode();

  bool _userContractChecked;

  @override
  void initState() {
    super.initState();

    _userContractChecked = true;
    _phoneEditController = TextEditingController();
    _verifyCodeEditController = TextEditingController();
    _phoneFocusNode.addListener(() => setState(() => {}));
    _verifyCodeFocusNode.addListener(() => setState(() => {}));
  }

  _buildAccountLoginTip() {
    return Padding(
      padding: EdgeInsets.only(top:80, left: 15, right: 15, bottom: 70),
      child: Text(
        "登录后，遇见你",
        maxLines: 1,
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: 16, color: Colors.black54),
      ),
    );
  }

  _buildEditWidget() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
            width: 1.0 / MediaQuery.of(context).devicePixelRatio,
            color: Colors.grey.withOpacity(0.5)),
      ),
      child: Column(
        children: <Widget>[
          _buildPhoneTextField(),
          Divider(height: 1.0),
          _buildVerifyCodeTextField(),
        ],
      ),
    );
  }

  _buildPhoneTextField() {
    return TextField(
        controller: _phoneEditController,
        focusNode: _phoneFocusNode,
        decoration: InputDecoration(hintText: "手机号", border: InputBorder.none));
  }

  _buildVerifyCodeTextField() {
    return TextField(
        controller: _verifyCodeEditController,
        focusNode: _verifyCodeFocusNode,
        decoration: InputDecoration(
            hintText: "验证码",
            border: InputBorder.none,
            suffixIcon: FlatButton(
                child: Text("获取验证码"),
                onPressed: () {
                  _phoneFocusNode.unfocus();
                  _verifyCodeFocusNode.unfocus();
                })));
  }

  _onLogin(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userInfo', "ok");
    Navigator.pop(context);
  }

  _buildLoginButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.grey.withOpacity(0.3),
              ),
              child: FlatButton(
                  onPressed: () {_onLogin(context);},
                  child: Text(
                    "登录",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          )
        ],
      ),
    );
  }

  _onChangedUserContractChecked(bool checked) {
    setState(() {
      _userContractChecked = checked;
    });
  }

  _buildUserContractTip() {
    return Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Checkbox(
                value: _userContractChecked,
                onChanged: _onChangedUserContractChecked),
            Text(
              "登录即表示同意《用户协议》",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('遇见你'),),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildAccountLoginTip(),
            _buildEditWidget(),
            _buildLoginButton(context),
            _buildUserContractTip(),
          ],
        ),
      ),
    );
  }
}
