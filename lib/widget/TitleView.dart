import 'package:flutter/material.dart';

class TitleView extends StatelessWidget {
  final BuildContext context;
  final String? title;
  final Widget? body;
  final PreferredSizeWidget? bottom;
  final bool? centerTitle;
  final double? height;
  final double? elevation;
  final Color? color;
  final Color? titleColor;
  final Color? iconColor;
  final bool? hasLeftButton;
  final Function? onBackPressed;
  final FocusNode? fn = FocusNode();
  final List<dynamic>? actions;
  final bool? isGestureDetector;
  final bool? resizeToAvoidBottomPadding;

  TitleView(this.context, {this.title, this.body, this.centerTitle, this.bottom,
    this.height, this.color, this.titleColor, this.iconColor, this.elevation,
    this.hasLeftButton, this.onBackPressed, this.actions, this.isGestureDetector,
    this.resizeToAvoidBottomPadding}): super();

  Future<bool> onBack() {
    if (onBackPressed != null) {
      onBackPressed!.call();
    } else {
      Navigator.of(context).pop();
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return (isGestureDetector??false) ? GestureDetector(
      child: _createWidget(),
      onPanDown: (DragDownDetails details){
        FocusScope.of(context).requestFocus(fn);
      },
    ) : _createWidget();
  }

  Widget _createWidget() {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomPadding??false,
      appBar: title != null ? PreferredSize(
        preferredSize: Size.fromHeight(height??40),
        child: AppBar(
          backgroundColor: color ?? Theme.of(context).primaryColor,
          leading: (hasLeftButton ?? true) ? InkWell(
            child: Icon(Icons.arrow_back),
            onTap: onBack,
          ) : null,
          title: Text(title??""),
          bottom: bottom,
          elevation: elevation ?? 3,
          iconTheme: IconThemeData(
            color: iconColor ?? titleColor ?? Colors.white,
          ),
          textTheme: TextTheme(
              headline6: TextStyle(
                  color: titleColor ?? Colors.white,
                  fontSize: 17.5,
                  fontWeight: FontWeight.w600
              )
          ),
          actions: _createActions(context),
          centerTitle: centerTitle ?? true,
        ),
      ) : null,
      body: body,
    );
  }

  List<Widget> _createActions(BuildContext context) {
    List<Widget> result = [];
    List<PopupMenuEntry<dynamic>> temp = [];
    if (actions != null) {
      actions!.forEach((element) {
        if (element is String || element is IconData) {
          if (actions!.length > 2) {
            temp.add(PopupMenuItem(
              value: element,
              height: 0,
              child: InkWell(
                child: Container(
                  height: 45,
                  alignment: Alignment.center,
                  child: Text(element ,style: TextStyle(color: Colors.black, fontSize: 14),),
                ),
                onTap: () {
                  Navigator.of(context, rootNavigator: false).pop();
                  actions![actions!.length - 1].call(element);
                },
              ),
            ));
          } else {
            result.add(InkWell(
              child: Container(
                padding: EdgeInsets.only(right: 10, left: 10),
                child: element is IconData ? Icon(element) : Text(element, style: TextStyle(
                  color: Colors.white,
                ),),
                alignment: Alignment.center,
              ),
              onTap: () {
                try {
                  actions![actions!.length - 1].call();
                } catch (error) {
                  actions![actions!.length - 1].call(element);
                }
              },
            ));
          }
        }
      });
      if (actions!.length > 2) {
        var menuParent = InkWell(
          child: Padding(
            child: Icon(Icons.more_vert, color: Colors.white,),
            padding: EdgeInsets.only(left: 10, right: 10),
          ),
          onTap: () {
            showMenu(context: context, items: temp, position: RelativeRect.fromLTRB(double.infinity, MediaQuery.of(context).padding.top + (height??40), 0, 0));
          },
        );
        result.add(menuParent);
      }
    }
    return result;
  }
}