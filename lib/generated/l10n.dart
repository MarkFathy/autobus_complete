// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Login`
  String get loginTitle {
    return Intl.message('Login', name: 'loginTitle', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Enter your email`
  String get emailHint {
    return Intl.message(
      'Enter your email',
      name: 'emailHint',
      desc: '',
      args: [],
    );
  }

  /// `Email is required`
  String get emailRequired {
    return Intl.message(
      'Email is required',
      name: 'emailRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address`
  String get invalidEmail {
    return Intl.message(
      'Please enter a valid email address',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Enter your password`
  String get passwordHint {
    return Intl.message(
      'Enter your password',
      name: 'passwordHint',
      desc: '',
      args: [],
    );
  }

  /// `Password is required`
  String get passwordRequired {
    return Intl.message(
      'Password is required',
      name: 'passwordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 8 characters`
  String get passwordMinLength {
    return Intl.message(
      'Password must be at least 8 characters',
      name: 'passwordMinLength',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot your password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get forgotPasswordTitle {
    return Intl.message(
      'Reset Password',
      name: 'forgotPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter your registered email address to receive a password reset link.\n(Note: Please check your Spam / Junk folder if you don't see it in your Inbox)`
  String get enterEmailToResetPassword {
    return Intl.message(
      'Enter your registered email address to receive a password reset link.\n(Note: Please check your Spam / Junk folder if you don\'t see it in your Inbox)',
      name: 'enterEmailToResetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Send Reset Link`
  String get sendResetLink {
    return Intl.message(
      'Send Reset Link',
      name: 'sendResetLink',
      desc: '',
      args: [],
    );
  }

  /// `Password reset link sent to your email!`
  String get passwordResetEmailSent {
    return Intl.message(
      'Password reset link sent to your email!',
      name: 'passwordResetEmailSent',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dontHaveAnAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Login with`
  String get loginWith {
    return Intl.message('Login with', name: 'loginWith', desc: '', args: []);
  }

  /// `Login with`
  String get loginWithGoogle {
    return Intl.message(
      'Login with',
      name: 'loginWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Or`
  String get or {
    return Intl.message('Or', name: 'or', desc: '', args: []);
  }

  /// `Bus Complete!`
  String get autobusComplete {
    return Intl.message(
      'Bus Complete!',
      name: 'autobusComplete',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Register`
  String get registerTitle {
    return Intl.message('Register', name: 'registerTitle', desc: '', args: []);
  }

  /// `Full Name`
  String get fullName {
    return Intl.message('Full Name', name: 'fullName', desc: '', args: []);
  }

  /// `Enter your full name`
  String get fullNameHint {
    return Intl.message(
      'Enter your full name',
      name: 'fullNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Full name is required`
  String get fullNameRequired {
    return Intl.message(
      'Full name is required',
      name: 'fullNameRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password Confirmation`
  String get passwordConfirmation {
    return Intl.message(
      'Password Confirmation',
      name: 'passwordConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password again`
  String get passwordConfirmationHint {
    return Intl.message(
      'Enter your password again',
      name: 'passwordConfirmationHint',
      desc: '',
      args: [],
    );
  }

  /// `Host Game`
  String get hostGame {
    return Intl.message('Host Game', name: 'hostGame', desc: '', args: []);
  }

  /// `Create a new game with your friends`
  String get hostGameSubtitle {
    return Intl.message(
      'Create a new game with your friends',
      name: 'hostGameSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Join Game`
  String get joinGame {
    return Intl.message('Join Game', name: 'joinGame', desc: '', args: []);
  }

  /// `Join an existing game room`
  String get joinGameSubtitle {
    return Intl.message(
      'Join an existing game room',
      name: 'joinGameSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Arabic`
  String get arabic {
    return Intl.message('Arabic', name: 'arabic', desc: '', args: []);
  }

  /// `Choose Language`
  String get chooseLanguage {
    return Intl.message(
      'Choose Language',
      name: 'chooseLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `About Us`
  String get aboutUs {
    return Intl.message('About Us', name: 'aboutUs', desc: '', args: []);
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Complaints & Suggestions`
  String get complaintsAndSuggestions {
    return Intl.message(
      'Complaints & Suggestions',
      name: 'complaintsAndSuggestions',
      desc: '',
      args: [],
    );
  }

  /// `Submit Complaint or Suggestion`
  String get submitComplaintOrSuggestion {
    return Intl.message(
      'Submit Complaint or Suggestion',
      name: 'submitComplaintOrSuggestion',
      desc: '',
      args: [],
    );
  }

  /// `Complaint`
  String get complaint {
    return Intl.message('Complaint', name: 'complaint', desc: '', args: []);
  }

  /// `Suggestion`
  String get suggestion {
    return Intl.message('Suggestion', name: 'suggestion', desc: '', args: []);
  }

  /// `Subject`
  String get subject {
    return Intl.message('Subject', name: 'subject', desc: '', args: []);
  }

  /// `Enter subject`
  String get subjectHint {
    return Intl.message(
      'Enter subject',
      name: 'subjectHint',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get messageDetails {
    return Intl.message('Details', name: 'messageDetails', desc: '', args: []);
  }

  /// `Type details here...`
  String get messageHint {
    return Intl.message(
      'Type details here...',
      name: 'messageHint',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message('Send', name: 'send', desc: '', args: []);
  }

  /// `Pending Response`
  String get pendingResponse {
    return Intl.message(
      'Pending Response',
      name: 'pendingResponse',
      desc: '',
      args: [],
    );
  }

  /// `Replied`
  String get replied {
    return Intl.message('Replied', name: 'replied', desc: '', args: []);
  }

  /// `Admin Response`
  String get adminReply {
    return Intl.message(
      'Admin Response',
      name: 'adminReply',
      desc: '',
      args: [],
    );
  }

  /// `No complaints or suggestions yet`
  String get noComplaintsYet {
    return Intl.message(
      'No complaints or suggestions yet',
      name: 'noComplaintsYet',
      desc: '',
      args: [],
    );
  }

  /// `Submitted successfully!`
  String get complaintSentSuccess {
    return Intl.message(
      'Submitted successfully!',
      name: 'complaintSentSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Delete Complaint/Suggestion`
  String get deleteComplaint {
    return Intl.message(
      'Delete Complaint/Suggestion',
      name: 'deleteComplaint',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this complaint/suggestion?`
  String get deleteComplaintConfirmation {
    return Intl.message(
      'Are you sure you want to delete this complaint/suggestion?',
      name: 'deleteComplaintConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Yes, Delete`
  String get yesDelete {
    return Intl.message('Yes, Delete', name: 'yesDelete', desc: '', args: []);
  }

  /// `Deleted successfully!`
  String get complaintDeletedSuccess {
    return Intl.message(
      'Deleted successfully!',
      name: 'complaintDeletedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contactUs {
    return Intl.message('Contact Us', name: 'contactUs', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Are you sure you want to log out?`
  String get logoutConfirmation {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'logoutConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Yes, Logout`
  String get yesLogout {
    return Intl.message('Yes, Logout', name: 'yesLogout', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get saveChanges {
    return Intl.message(
      'Save Changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Send password reset link to email`
  String get changePasswordInfo {
    return Intl.message(
      'Send password reset link to email',
      name: 'changePasswordInfo',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your account? This action cannot be undone.`
  String get deleteAccountConfirmation {
    return Intl.message(
      'Are you sure you want to delete your account? This action cannot be undone.',
      name: 'deleteAccountConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Yes, Delete Account`
  String get yesDeleteAccount {
    return Intl.message(
      'Yes, Delete Account',
      name: 'yesDeleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Profile updated successfully!`
  String get profileUpdatedSuccess {
    return Intl.message(
      'Profile updated successfully!',
      name: 'profileUpdatedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Choose Image Source`
  String get chooseImageSource {
    return Intl.message(
      'Choose Image Source',
      name: 'chooseImageSource',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message('Camera', name: 'camera', desc: '', args: []);
  }

  /// `Gallery`
  String get gallery {
    return Intl.message('Gallery', name: 'gallery', desc: '', args: []);
  }

  /// `Enter 6-digit room code`
  String get enterRoomCode {
    return Intl.message(
      'Enter 6-digit room code',
      name: 'enterRoomCode',
      desc: '',
      args: [],
    );
  }

  /// `Join`
  String get join {
    return Intl.message('Join', name: 'join', desc: '', args: []);
  }

  /// `Lobby`
  String get lobby {
    return Intl.message('Lobby', name: 'lobby', desc: '', args: []);
  }

  /// `Copy Room Code`
  String get copyRoomCode {
    return Intl.message(
      'Copy Room Code',
      name: 'copyRoomCode',
      desc: '',
      args: [],
    );
  }

  /// `Room Code`
  String get roomCode {
    return Intl.message('Room Code', name: 'roomCode', desc: '', args: []);
  }

  /// `Room code copied successfully!`
  String get roomCodeCopied {
    return Intl.message(
      'Room code copied successfully!',
      name: 'roomCodeCopied',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for host to calculate scores`
  String get waitingForOtherPlayers {
    return Intl.message(
      'Waiting for host to calculate scores',
      name: 'waitingForOtherPlayers',
      desc: '',
      args: [],
    );
  }

  /// `Ready`
  String get ready {
    return Intl.message('Ready', name: 'ready', desc: '', args: []);
  }

  /// `Not Ready`
  String get unReady {
    return Intl.message('Not Ready', name: 'unReady', desc: '', args: []);
  }

  /// `Leave Room`
  String get leaveRoom {
    return Intl.message('Leave Room', name: 'leaveRoom', desc: '', args: []);
  }

  /// `Are you sure you want to leave the room?`
  String get leaveRoomConfirmation {
    return Intl.message(
      'Are you sure you want to leave the room?',
      name: 'leaveRoomConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Leave`
  String get yesLeave {
    return Intl.message('Leave', name: 'yesLeave', desc: '', args: []);
  }

  /// `Start Game`
  String get startGame {
    return Intl.message('Start Game', name: 'startGame', desc: '', args: []);
  }

  /// `Room Settings`
  String get roomSettings {
    return Intl.message(
      'Room Settings',
      name: 'roomSettings',
      desc: '',
      args: [],
    );
  }

  /// `Number of Rounds`
  String get numberOfRounds {
    return Intl.message(
      'Number of Rounds',
      name: 'numberOfRounds',
      desc: '',
      args: [],
    );
  }

  /// `Rounds`
  String get rounds {
    return Intl.message('Rounds', name: 'rounds', desc: '', args: []);
  }

  /// `Categories`
  String get categories {
    return Intl.message('Categories', name: 'categories', desc: '', args: []);
  }

  /// `Select at least 4 categories`
  String get selectAtLeast4Categories {
    return Intl.message(
      'Select at least 4 categories',
      name: 'selectAtLeast4Categories',
      desc: '',
      args: [],
    );
  }

  /// `Select All`
  String get selectAll {
    return Intl.message('Select All', name: 'selectAll', desc: '', args: []);
  }

  /// `Deselect All`
  String get deselectAll {
    return Intl.message(
      'Deselect All',
      name: 'deselectAll',
      desc: '',
      args: [],
    );
  }

  /// `{count} categories selected`
  String categoriesSelected(Object count) {
    return Intl.message(
      '$count categories selected',
      name: 'categoriesSelected',
      desc: '',
      args: [count],
    );
  }

  /// `Select at least {count} more category(ies)`
  String categoriesRemaining(Object count) {
    return Intl.message(
      'Select at least $count more category(ies)',
      name: 'categoriesRemaining',
      desc: '',
      args: [count],
    );
  }

  /// `Boy`
  String get boyCategory {
    return Intl.message('Boy', name: 'boyCategory', desc: '', args: []);
  }

  /// `Girl`
  String get girlCategory {
    return Intl.message('Girl', name: 'girlCategory', desc: '', args: []);
  }

  /// `Object`
  String get objectCategory {
    return Intl.message('Object', name: 'objectCategory', desc: '', args: []);
  }

  /// `Plant`
  String get plantCategory {
    return Intl.message('Plant', name: 'plantCategory', desc: '', args: []);
  }

  /// `Food`
  String get foodCategory {
    return Intl.message('Food', name: 'foodCategory', desc: '', args: []);
  }

  /// `Animal`
  String get animalCategory {
    return Intl.message('Animal', name: 'animalCategory', desc: '', args: []);
  }

  /// `Country`
  String get countryCategory {
    return Intl.message('Country', name: 'countryCategory', desc: '', args: []);
  }

  /// `Players`
  String get players {
    return Intl.message('Players', name: 'players', desc: '', args: []);
  }

  /// `Host`
  String get host {
    return Intl.message('Host', name: 'host', desc: '', args: []);
  }

  /// `Make Host`
  String get makeHost {
    return Intl.message('Make Host', name: 'makeHost', desc: '', args: []);
  }

  /// `Kick Player`
  String get kickPlayer {
    return Intl.message('Kick Player', name: 'kickPlayer', desc: '', args: []);
  }

  /// `The host has removed you from the room`
  String get kickedByHost {
    return Intl.message(
      'The host has removed you from the room',
      name: 'kickedByHost',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordsDoNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Logged in successfully!`
  String get loginSuccess {
    return Intl.message(
      'Logged in successfully!',
      name: 'loginSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Account created successfully!`
  String get registerSuccess {
    return Intl.message(
      'Account created successfully!',
      name: 'registerSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Logged out successfully!`
  String get logoutSuccess {
    return Intl.message(
      'Logged out successfully!',
      name: 'logoutSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in all required fields`
  String get pleaseFillAllFields {
    return Intl.message(
      'Please fill in all required fields',
      name: 'pleaseFillAllFields',
      desc: '',
      args: [],
    );
  }

  /// `Operation was cancelled`
  String get operationCancelled {
    return Intl.message(
      'Operation was cancelled',
      name: 'operationCancelled',
      desc: '',
      args: [],
    );
  }

  /// `User not found. Please check your email`
  String get firebaseUserNotFound {
    return Intl.message(
      'User not found. Please check your email',
      name: 'firebaseUserNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect password`
  String get firebaseWrongPassword {
    return Intl.message(
      'Incorrect password',
      name: 'firebaseWrongPassword',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email or password`
  String get firebaseInvalidCredential {
    return Intl.message(
      'Invalid email or password',
      name: 'firebaseInvalidCredential',
      desc: '',
      args: [],
    );
  }

  /// `Email is already in use. Please login`
  String get firebaseEmailAlreadyInUse {
    return Intl.message(
      'Email is already in use. Please login',
      name: 'firebaseEmailAlreadyInUse',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email address format`
  String get firebaseInvalidEmail {
    return Intl.message(
      'Invalid email address format',
      name: 'firebaseInvalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password is too weak. Please use a stronger password`
  String get firebaseWeakPassword {
    return Intl.message(
      'Password is too weak. Please use a stronger password',
      name: 'firebaseWeakPassword',
      desc: '',
      args: [],
    );
  }

  /// `Network error. Please check your internet connection`
  String get firebaseNetworkFailed {
    return Intl.message(
      'Network error. Please check your internet connection',
      name: 'firebaseNetworkFailed',
      desc: '',
      args: [],
    );
  }

  /// `Too many failed attempts. Please try again later`
  String get firebaseTooManyRequests {
    return Intl.message(
      'Too many failed attempts. Please try again later',
      name: 'firebaseTooManyRequests',
      desc: '',
      args: [],
    );
  }

  /// `This user account has been disabled`
  String get firebaseUserDisabled {
    return Intl.message(
      'This user account has been disabled',
      name: 'firebaseUserDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Authentication error occurred`
  String get firebaseAuthError {
    return Intl.message(
      'Authentication error occurred',
      name: 'firebaseAuthError',
      desc: '',
      args: [],
    );
  }

  /// `Account created! Verification link sent to your email.`
  String get firebaseEmailVerificationSent {
    return Intl.message(
      'Account created! Verification link sent to your email.',
      name: 'firebaseEmailVerificationSent',
      desc: '',
      args: [],
    );
  }

  /// `Email not verified. Please check your inbox and verify.`
  String get firebaseEmailNotVerified {
    return Intl.message(
      'Email not verified. Please check your inbox and verify.',
      name: 'firebaseEmailNotVerified',
      desc: '',
      args: [],
    );
  }

  /// `Google sign-in was cancelled`
  String get firebaseGoogleSignCancel {
    return Intl.message(
      'Google sign-in was cancelled',
      name: 'firebaseGoogleSignCancel',
      desc: '',
      args: [],
    );
  }

  /// `Failed to create user account`
  String get firebaseFailedToCreateUser {
    return Intl.message(
      'Failed to create user account',
      name: 'firebaseFailedToCreateUser',
      desc: '',
      args: [],
    );
  }

  /// `Failed to sign in with Google`
  String get firebaseFailedToSignInGoogle {
    return Intl.message(
      'Failed to sign in with Google',
      name: 'firebaseFailedToSignInGoogle',
      desc: '',
      args: [],
    );
  }

  /// `This email is already registered. Please login`
  String get firebaseEmailAlreadyRegistered {
    return Intl.message(
      'This email is already registered. Please login',
      name: 'firebaseEmailAlreadyRegistered',
      desc: '',
      args: [],
    );
  }

  /// `Game starts in`
  String get gameStartsIn {
    return Intl.message(
      'Game starts in',
      name: 'gameStartsIn',
      desc: '',
      args: [],
    );
  }

  /// `Get Ready!`
  String get getReady {
    return Intl.message('Get Ready!', name: 'getReady', desc: '', args: []);
  }

  /// `Round`
  String get round {
    return Intl.message('Round', name: 'round', desc: '', args: []);
  }

  /// `Letter`
  String get currentLetter {
    return Intl.message('Letter', name: 'currentLetter', desc: '', args: []);
  }

  /// `Submit Answers`
  String get submitAnswers {
    return Intl.message(
      'Submit Answers',
      name: 'submitAnswers',
      desc: '',
      args: [],
    );
  }

  /// `No answer given`
  String get noAnswerGiven {
    return Intl.message(
      'No answer given',
      name: 'noAnswerGiven',
      desc: '',
      args: [],
    );
  }

  /// `Round Evaluation`
  String get scoringTitle {
    return Intl.message(
      'Round Evaluation',
      name: 'scoringTitle',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get roundTotal {
    return Intl.message('Total', name: 'roundTotal', desc: '', args: []);
  }

  /// `Next Round`
  String get nextRound {
    return Intl.message('Next Round', name: 'nextRound', desc: '', args: []);
  }

  /// `Final Leaderboard`
  String get finalResults {
    return Intl.message(
      'Final Leaderboard',
      name: 'finalResults',
      desc: '',
      args: [],
    );
  }

  /// `End Game`
  String get endGame {
    return Intl.message('End Game', name: 'endGame', desc: '', args: []);
  }

  /// `Round`
  String get roundScore {
    return Intl.message('Round', name: 'roundScore', desc: '', args: []);
  }

  /// `Total Score`
  String get totalScore {
    return Intl.message('Total Score', name: 'totalScore', desc: '', args: []);
  }

  /// `The room is full`
  String get roomIsFull {
    return Intl.message(
      'The room is full',
      name: 'roomIsFull',
      desc: '',
      args: [],
    );
  }

  /// `Play Again`
  String get playAgain {
    return Intl.message('Play Again', name: 'playAgain', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
