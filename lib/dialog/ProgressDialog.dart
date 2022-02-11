import 'package:flutter/material.dart';
import 'package:mariana_flutter/widget/DecorView.dart';
import 'package:synchronized/synchronized.dart';

class ProgressDialog extends StatelessWidget {
  static int marks = 0;
  static BuildContext? dialogContext;

  static Future<Null> show() async {
    var lock = new Lock();
    lock.synchronized(() async {
      if (0 == marks++) {
        await showDialog(context: DecorView.navigatorKey.currentContext!, builder: (ctx) {
          dialogContext = ctx;
          return ProgressDialog();
        });
      }
    });
    return;
  }

  static void dismiss() {
    var lock = new Lock();
    lock.synchronized(() {
      if (0 == --marks) {
        Navigator.pop(dialogContext!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.all(Radius.circular(12))
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 65,
                  width: 65,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                  ),
                ),
                Text("加载中...", style: TextStyle(color: Colors.white, fontSize: 8),)
              ],
            ),
          ),
        ),
      ),
      onWillPop: () {
        return Future.value(false);
      },
    );
  }
}