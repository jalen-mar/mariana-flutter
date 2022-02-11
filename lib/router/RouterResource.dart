import 'package:flutter/widgets.dart';

abstract class RouterResource {
  String initialRoute();
  Map<String, WidgetBuilder> getRoutes();
  WidgetBuilder getRoute(String key);
}