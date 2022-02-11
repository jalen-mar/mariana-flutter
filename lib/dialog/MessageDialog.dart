import 'package:flutter/material.dart';

class MessageDialog extends StatelessWidget {
  final String title;
  final Widget message;
  final Function callback;
  final Function? cancel;
  final double? height;
  final String? submitText;
  final Color? color;

  MessageDialog(this.title, this.message, this.callback,
      {this.color, this.height, this.cancel, this.submitText}) : super();

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: height??180,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12))
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: color??Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
                ),
                child: Text(title, style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),),
                padding: EdgeInsets.all(12),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: message,
                  alignment: Alignment.center,
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text("取消", style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ), textAlign: TextAlign.center,),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          cancel?.call();
                        },
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                              color: color == null ? Theme.of(context).primaryColor : color,
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(12))
                          ),
                          padding: EdgeInsets.all(12),
                          child: Text(submitText??"确定", style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ), textAlign: TextAlign.center,),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          callback.call();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}