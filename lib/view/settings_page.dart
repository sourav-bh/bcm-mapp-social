import 'package:app/main.dart';
import 'package:app/util/app_style.dart';
import 'package:app/util/common_util.dart';
import 'package:app/util/shared_preference.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  void initState() {
    super.initState();
  }

  _logoutAction(BuildContext context) {
    showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Confirm'),
          content: const Text('Are you sure to logout now?'),
          actions: [
            TextButton(
                child: const Text("NO"),
                onPressed:  () => Navigator.of(context).pop() // dismiss dialog,
            ),
            TextButton(
              child: const Text("YES"),
              onPressed: () {
                CommonUtil.logoutUser(dialogContext);
              },
            ),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/images/bcm_logo.png', height: 80, ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 200,
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
                      _logoutAction(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'LOGOUT',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    )
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          )
      ),
    );
  }
}