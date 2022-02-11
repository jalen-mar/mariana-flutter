import 'package:flutter/material.dart';

class ThemeConfig {
  final String applicationName;
  bool? debugShowCheckedModeBanner;
  bool? showSemanticsDebugger;
  bool? checkerboardRasterCacheImages;
  bool? showPerformanceOverlay;
  bool? checkerboardOffscreenLayers;
  Color? backgroundColor;
  MaterialColor? themeColor;

  ThemeConfig(this.applicationName): super();
}