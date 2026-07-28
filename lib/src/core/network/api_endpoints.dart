class ApiEndpoints {
  static const String _baseUrl = 'https://api.roundz.ae/api/';
  static const String domain = 'https://api.roundz.ae/';

  /// API endpoints for auth
  static const String login = '${_baseUrl}beneficiary/send-login-otp';
  static const String verifyLoginOtp =
      '${_baseUrl}beneficiary/verify-login-otp';
  static const String completeProfile = '${_baseUrl}beneficiary/profile';
  static const String logout = '${_baseUrl}beneficiary/logout';
  static const String profile = '${_baseUrl}beneficiary/profile';

  /// API endpoints for Fund
  static const String funds = '${_baseUrl}beneficiary/funds';
  static const String fundPurposes = '${_baseUrl}reference/fund-purposes';

  /// API endpoints for Static
  static const String checkReferralCode =
      '${_baseUrl}beneficiary/check-referral-code';
  static const String countries = '${_baseUrl}reference/countries';
  static const String emirates =
      '${_baseUrl}reference/cities/country/227'; // For Only United Arab Emirates

  // API endpoints for Settings
  static const String settings = '${_baseUrl}settings';
  static const String notifications = '${_baseUrl}beneficiary/notifications';

  // API endpoints for Faqs
  static const String faqs = '${_baseUrl}faqs';
  static const String faqCategories = '${_baseUrl}faqs/categories';
  static const String faqHomepage = '${_baseUrl}faqs/homepage';
  static const String faqFeature = '${_baseUrl}faqs/feature';
  static const String faqFeedback = '${_baseUrl}faqs/feedback';
  static const String supportRequests = '${_baseUrl}beneficiary/support-requests';

  // API endpoints for Delete Account
  static const String getReasons = '${_baseUrl}beneficiary/account/deletion-reasons';
  static const String initiateDelete = '${_baseUrl}beneficiary/account/delete/initiate';
  static const String confirmDelete = '${_baseUrl}beneficiary/account/delete/confirm';
}
