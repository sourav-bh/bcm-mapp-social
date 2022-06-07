import 'package:app/view/login_page.dart';
import 'package:app/view/tweet_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/util/app_constant.dart';
import 'package:app/view/home_page.dart';
import 'package:app/view/settings_page.dart';

const loginRoute = '/';
const homeRoute = '/home';
const tweetDetailsRoute = '/tweets';
const settingsRoute = '/settings';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstant.installationId,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: _routes(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }

  /// Method to handle the page navigation
  RouteFactory _routes() {
    return (settings) {
      final dynamic arguments = settings.arguments;
      Widget screen;
      switch (settings.name) {
        case loginRoute:
          screen = const LoginPage();
          break;
        case homeRoute:
          screen = const HomePage();
          break;
        case tweetDetailsRoute:
          screen = const TweetListPage();
          break;
        case settingsRoute:
          screen = const SettingsPage();
          break;
        default:
          return null;
      }

      return MaterialPageRoute(builder: (BuildContext context) => screen,
          settings: RouteSettings(arguments: arguments,));
    };
  }
}
