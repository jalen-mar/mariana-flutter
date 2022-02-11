import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mariana_flutter/router/RouterResource.dart';

class RouterUtil {
  static RouterResource? _resource;

  static Map<String, WidgetBuilder> init(RouterResource resource) {
    _resource = resource;
    return _resource!.getRoutes();
  }

  BuildContext _context;
  String _routeName;
  Map<String, Object> params = HashMap<String, Object>();

  RouterUtil._(this._context, this._routeName);

  static RouterUtil build(BuildContext context, String name) {
    return RouterUtil._(context, name);
  }

  RouterUtil withParam(String key, Object value) {
    params[key] = value;
    return this;
  }

  Future<T?> forward<T extends Object?>() {
    return Navigator.push(_context, _createRoute());
  }

  Future<T?> goto<T extends Object?>() {
    return Navigator.pushAndRemoveUntil(_context, _createRoute(), (Route<dynamic>? route) => route == null,);
  }

  static void finish(BuildContext context, [Object? result]) {
    Navigator.of(context).pop(result);
  }

  _createRoute() {
    return MaterialPageRoute(builder: (BuildContext context){
      var result = _resource!.getRoute(_routeName).call(context);
      if (result is ParamsWidget) {
        result.setParams(params);
      }
      return result;
    });
  }
}

abstract class ParamsWidget extends StatefulWidget {
  final Map<String, Object> _params = HashMap<String, Object>();

  getParams(String key, [dynamic def]) {
    return _params[key]??def;
  }

  void setParams(Map<String, Object> params) {
    _params.addAll(params);
  }

  void clearParams() {
    _params.clear();
  }
}