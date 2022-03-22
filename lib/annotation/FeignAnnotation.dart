import 'package:meta/meta.dart';

@immutable
class EnableFeign {
  const EnableFeign();
}

@immutable
class Feign {
  const Feign();
}

@immutable
class FeignLoading {
  const FeignLoading();
}

@immutable
class FeignError {
  const FeignError();
}

@immutable
class FeignDismiss {
  const FeignDismiss();
}

@immutable
class FeignCall {
  final String authenticationCode;
  const FeignCall([this.authenticationCode = "401"]);
}

@immutable
class FeignLogout {
  const FeignLogout();
}