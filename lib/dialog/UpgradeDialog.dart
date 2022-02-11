import 'package:flutter/material.dart';

class UpgradeDialog extends StatefulWidget {
  final List<String> upgradeProgress;

  UpgradeDialog(this.upgradeProgress, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UpgradeDialogState();
}

class _UpgradeDialogState extends State<UpgradeDialog> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            height: 120,
            margin: EdgeInsets.only(left: 25, right: 25),
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.all(Radius.circular(8))
            ),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 65,
                      width: 65,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                      ),
                    ),
                    Text("更新中", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 8),)
                  ],
                ),
                Padding(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("正在更新中,请稍后....", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15),),
                      Padding(
                        child: Text("完成进度:    ${widget.upgradeProgress[0]} / 100", style: TextStyle(color: Colors.black87, fontSize: 13),),
                        padding: EdgeInsets.only(top: 5),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.only(left: 18),
                ),
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