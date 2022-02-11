import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefreshView extends StatelessWidget {
  final RefreshController controller;
  final VoidCallback? onRefresh;
  final VoidCallback? onLoad;
  final Widget? child;
  final List<dynamic>? data;
  final Color? color;

  RefreshView(this.controller, {Key? key, this.onRefresh,
    this.onLoad, this.child, this.data, this.color}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: onRefresh != null,
      enablePullUp: onLoad != null,
      onRefresh: onRefresh,
      onLoading: onLoad,
      controller: controller,
      header: MaterialClassicHeader(),
      footer: onLoad != null ? CustomFooter(
        height: 40,
        builder: (context, mode) {
          Widget resultView;
          switch (mode) {
            case LoadStatus.canLoading:
            case LoadStatus.loading:
            case LoadStatus.idle : {
              resultView = _LoadView(color ?? Theme.of(context).primaryColor);
            }
            break;
            case LoadStatus.failed: {
              resultView = _FailedView(color ?? Theme.of(context).primaryColor);
            }
            break;
            default: {
              resultView = Container(
                height: 40,
                child: Text("您已经触碰到我的底线了( •̥́ ˍ •̀ू )", style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                )),
                alignment: Alignment.center,
              );
            }
            break;
          }
          return resultView;
        },
      ) : null,
      child: (data?.length??0) == 0 ? Container(
        child: Text("暂无数据", style: TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),),
        alignment: Alignment.center,
      ) : child,
    );
  }
}

class _LoadView extends StatelessWidget {
  final Color color;

  _LoadView(this.color) : super();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
              )
          ),
          Text("    数据加载中....", style: TextStyle(
            fontSize: 13,
            color: color,
          ),)
        ],
      ),
      height: 40,
    );
  }
}

class _FailedView extends StatelessWidget {
  final Color color;

  _FailedView(this.color): super();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("加载失败,请点击", style: TextStyle(
              color: Colors.grey,
              fontSize: 13
          ),),
          Container(
            child: Text("重试", style: TextStyle(
                color: Colors.white,
                fontSize: 13
            ),),
            padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
            margin: EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.all(Radius.circular(6.5))
            ),
          ),
        ],
      ),
      height: 40,
    );
  }
}

class Controller extends RefreshController {
  final List<dynamic> data;

  Controller(this.data, {bool? initialRefresh}) : super(initialRefresh: initialRefresh ?? true);

  void addItem({List<dynamic>? data, int? page}) {
    if (data != null) {
      if (page == 1) {
        this.data.clear();
      }
      if (data.isEmpty) {
        _finish(page ?? 1);
        loadNoData();
      } else {
        this.data.addAll(data);
        _finish(page ?? 1);
      }
    } else {
      _finish(page ?? 1);
      loadFailed();
    }
  }

  void _finish(int page) {
    if (page == 1) {
      refreshCompleted();
      loadComplete();
    } else {
      loadComplete();
    }
  }
}