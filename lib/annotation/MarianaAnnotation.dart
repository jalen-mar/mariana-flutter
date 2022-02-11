import 'package:meta/meta.dart';

@immutable
class AutoApplication {
  final String? applicationName;
  const AutoApplication([this.applicationName]);
}

@immutable
class Initialize {
  const Initialize();
}

@immutable
class Config {
  final String configurationName;
  const Config([this.configurationName = "application"]);
}

@immutable
class Session {
  const Session();
}