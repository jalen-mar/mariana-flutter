import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mariana_flutter/config/ThemeConfig.dart';
import 'package:mariana_flutter/router/RouterResource.dart';
import 'package:mariana_flutter/widget/DecorView.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:yaml/yaml.dart';

typedef InitializeCallback(Map? config);

class BasicApp {
  static void run(RouterResource resource, [Map<String?, InitializeCallback>? handlers, List<SingleChildWidget>? providers]) async {
    var configuration = await loadConfiguration();
    ThemeConfig? applicationConfig;
    for (String configurationName in configuration.keys) {
      if ("application" == configurationName) {
        applicationConfig = getApplicationConfig(configuration["application"]);
      }
      await handlers?[configurationName]?.call(configuration[configurationName]);
    }
    Widget mainWidget;
    if (providers != null && providers.isNotEmpty) {
      mainWidget = MultiProvider(providers: providers, child: DecorView(resource, applicationConfig),);
    } else {
      mainWidget = DecorView(resource, applicationConfig);
    }
    runApp(mainWidget);
  }

  static Future<Map> loadConfiguration() async {
    var mode = String.fromEnvironment("mode");
    if (mode.isEmpty) {
      mode = kReleaseMode ? "release" : (kProfileMode ? "profile" : "debug");
    }
    WidgetsFlutterBinding.ensureInitialized();
    var data = await rootBundle.loadString("assets/config/application_$mode.yaml");
    return loadYaml(data);
  }

  static ThemeConfig? getApplicationConfig(data) {
    ThemeConfig config = ThemeConfig(data["name"]);
    config.backgroundColor = Color(data["backgroundColor"]);
    config.themeColor = MaterialColor(data["themeColor[500]"],  <int, Color>{
      50: Color(data["themeColor[50]"]),
      100: Color(data["themeColor[100]"]),
      200: Color(data["themeColor[200]"]),
      300: Color(data["themeColor[300]"]),
      400: Color(data["themeColor[400]"]),
      500: Color(data["themeColor[500]"]),
      600: Color(data["themeColor[600]"]),
      700: Color(data["themeColor[700]"]),
      800: Color(data["themeColor[800]"]),
      900: Color(data["themeColor[900]"]),
    });
    var debugConfig = data["debug"];
    config.debugShowCheckedModeBanner = debugConfig["logo"];
    config.showSemanticsDebugger = debugConfig["true"];
    config.checkerboardRasterCacheImages = debugConfig["grid"];
    config.showPerformanceOverlay = debugConfig["overlay"];
    config.checkerboardOffscreenLayers = debugConfig["board"];
    return config;
  }
}