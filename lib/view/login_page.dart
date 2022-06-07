import 'dart:io';

import 'package:app/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app/api/api_manager.dart';
import 'package:app/main.dart';
import 'package:app/util/app_constant.dart';
import 'package:app/util/app_style.dart';
import 'package:app/util/common_util.dart';
import 'package:app/util/shared_preference.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey _scaffold = GlobalKey();
  bool _loadingRequested = false;

  bool _obscureText = true;
  IconData _iconVisible = Icons.visibility_off;

  final _emailText = TextEditingController();
  final _passwordText = TextEditingController();

  final Color _gradientTop = const Color(0xFF039be6);
  final Color _gradientBottom = const Color(0xFF0299e2);

  @override
  void initState() {
    super.initState();

    _emailText.text = 'vicki@test.de';
    _passwordText.text = 'bcm123';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _loadAuthToken();
  }

  _loadAuthToken() async {
    var token = await SharedPref.instance.getValue(SharedPref.keySessionToken);
    if (token != null) AppCache.instance.sessionToken = token as String;

    var userId = await SharedPref.instance.getValue(SharedPref.keyUserId);
    if (userId != null) AppCache.instance.userId = userId as String;
  }

  @override
  void dispose() {
    super.dispose();
  }

  _loginAction(BuildContext context) {
    var email = _emailText.text.trim();
    var password = _passwordText.text.trim();
    if (email.isNotEmpty && password.length >= 6) {
      setState(() => _loadingRequested = true);

      ApiManager().requestLogin(email, password).then((response) {
        setState(() => _loadingRequested = false);

        if (response.userId != null && response.userId!.isNotEmpty) {
          AppCache.instance.userId = response.userId ?? '';
          AppCache.instance.sessionToken = response.sessionToken ?? '';

          SharedPref.instance.saveJsonValue(SharedPref.keySessionToken, response.sessionToken);
          SharedPref.instance.saveJsonValue(SharedPref.keyUserId, response.userId);
          SharedPref.instance.saveJsonValue(SharedPref.keyUserInfo, response);

          Navigator.pushNamedAndRemoveUntil(_scaffold.currentContext!, homeRoute, (r) => false);
        } else {
          Fluttertoast.showToast(msg: 'Failed to login, please try again!', toastLength: Toast.LENGTH_LONG);
        }
      }, onError: (e) {
        setState(() => _loadingRequested = false);
        Fluttertoast.showToast(msg: 'Failed to login, please try again!', toastLength: Toast.LENGTH_LONG);
      });
    } else {
      CommonUtil.showAlertDialog(context, 'Invalid Input!', 'Please enter your valid email and password');
    }
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
      if (_obscureText == true) {
        _iconVisible = Icons.visibility_off;
      } else {
        _iconVisible = Icons.visibility;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: SharedPref.instance.hasValue(SharedPref.keyUserInfo),
      initialData: null,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data == true ? const HomePage() : _buildLoginView(context);
        } else {
          return _buildSplashView(context);
        }
      },
    );
  }

  Widget _buildLoginView(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: Platform.isIOS?SystemUiOverlayStyle.light:const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light
          ),
          child: Stack(
            children: <Widget>[
              // top blue background gradient
              Container(
                height: MediaQuery.of(context).size.height / 3.5,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [_gradientTop, _gradientBottom],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Image.asset('assets/images/bcm_logo.png', height: 80, color: Colors.white,),
                  ],
                )),
              _loadingRequested ?
              const Center(
                child: CircularProgressIndicator(),
              ) :
              ListView(
                children: <Widget>[
                  // create form login
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.fromLTRB(32, MediaQuery.of(context).size.height / 3.5 - 80, 32, 0),
                    color: Colors.white,
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 40,
                            ),
                            const Center(
                              child: Text(
                                'SIGN IN',
                                style: TextStyle(
                                    color: AppColor.Primary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailText,
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey[600]!)),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: AppColor.EditTextUnderlineColor),
                                  ),
                                  labelText: 'Email',
                                  labelStyle: TextStyle(color: Colors.grey[700])),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              obscureText: _obscureText,
                              controller: _passwordText,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey[600]!)),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: AppColor.EditTextUnderlineColor),
                                ),
                                labelText: 'Password',
                                labelStyle: TextStyle(color: Colors.grey[700]),
                                suffixIcon: IconButton(
                                    icon: Icon(_iconVisible, color: Colors.grey[700], size: 20),
                                    onPressed: () {
                                      _toggleObscureText();
                                    }),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            SizedBox(
                              width: double.maxFinite,
                              child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) => AppColor.Primary,),
                                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        )
                                    ),
                                  ),
                                  onPressed: () {
                                    _loginAction(context);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      'LOGIN',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                              ),
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              )
            ],
          ),
        )
    );
  }

  Widget _buildSplashView(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Image(image: const AssetImage("assets/images/bcm_logo.png"), width: MediaQuery.of(context).size.width/2,),
        ),
      ),
    );
  }
}
