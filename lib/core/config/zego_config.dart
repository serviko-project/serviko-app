abstract final class ZegoConfig {
  static const int appId = int.fromEnvironment('ZEGO_APP_ID', defaultValue: 0);
  static const String appSign = String.fromEnvironment('ZEGO_APP_SIGN');
}
