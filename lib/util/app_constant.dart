class AppConstant {
  static const productionBuild = false;

  static const apiBaseUrl = 'https://kontikat.de/parse/';

  static const applicationId = 'ckxdqnASa9kijVHdcqm7';
  static const clientVersion = 'js3.2.0';
  static const installationId = 'fb96f42c-f965-4ef5-9a8c-ae9cdaa8744d';

  static const displayTicketUrlPrefix = apiBaseUrl + 'event/display.php?th=';
  static const registerPaperTicketPrefix = apiBaseUrl + 'event/signup.php?th=';
  static const voucherPageUrl = apiBaseUrl + 'event/voucher.php';
}

class AppCache {
  String? userId;
  String? sessionToken;

  AppCache._privateConstructor();
  static final AppCache instance = AppCache._privateConstructor();
}