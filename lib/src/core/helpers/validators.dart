// import 'package:autobus_complete/src/config/language/locale_keys.dart';

// class Validators {
//   static String? validateEmpty(String? value, {String? message}) {
//     if (value == null || value.isEmpty) {
//       return message ?? LocaleKeys.fillField;
//     }
//     return null;
//   }

//   static String? validateName(String? value, {String? message}) {
//     if (value?.trim().isEmpty ?? true) {
//       return message ?? LocaleKeys.fillField;
//     } else if (value!.length < 2) {
//       return message ?? LocaleKeys.nameValidation;
//     }
//     return null;
//   }

//   static String? validateNote(String? value, {String? message}) {
//     if (value?.trim().isEmpty ?? true) {
//       return message ?? LocaleKeys.fillField;
//     } else if (value!.length < 10) {
//       return message ?? LocaleKeys.noteValidation;
//     }
//     return null;
//   }

//   static String? validatePassword(String? value, {String? message}) {
//     if (value?.trim().isEmpty ?? true) {
//       return message ?? LocaleKeys.passRequiredValidation;
//     } else if (value!.length < 6) {
//       return message ?? LocaleKeys.passValidation;
//     }
//     return null;
//   }

//   static String? validateEmail(String? value, {String? message}) {
//     if (value?.trim().isEmpty ?? true) {
//       return message ?? LocaleKeys.mailValidation;
//     } else if (!RegExp(
//       r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.["
//       r"a-zA-Z]+",
//     ).hasMatch(value!)) {
//       return message ?? LocaleKeys.mailValidation;
//     }
//     return null;
//   }

//   static String? validateEmailOrNull(String? value, {String? message}) {
//     if (value?.trim().isNotEmpty ?? true) {
//       if (!RegExp(
//         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.["
//         r"a-zA-Z]+",
//       ).hasMatch(value!)) {
//         return message ?? LocaleKeys.mailValidation;
//       }
//     }
//     return null;
//   }

//   static String? validatePhone(String? value, {String? message}) {
//     if (value!.trim().isEmpty) {
//       return '';
//     } else if (!RegExp(
//       r"^(?:\0)?(?:50|52|54|55|56|58)\d{7}$",
//     ).hasMatch(value)) {
//       return '';
//     }
//     return null;
//   }

//   static String? validatePhoneOrNull(String? value, {String? message}) {
//     if (value!.trim().isNotEmpty) {
//       if (!RegExp(r"^(?:\0)?(?:50|52|54|55|56|58)\d{7}$").hasMatch(value)) {
//         return message ?? LocaleKeys.phoneValidation;
//       }
//     }
//     return null;
//   }

//   static String? validatePasswordConfirm(
//     String? value,
//     String? pass, {
//     String? message,
//   }) {
//     if (value?.trim().isEmpty ?? true) {
//       return message ?? LocaleKeys.fillField;
//     } else if (value != pass) {
//       return message ?? LocaleKeys.confirmValidation;
//     }
//     return null;
//   }

//   static String? validateDropDown<T>(T? value, {String? message}) {
//     if (value == null) {
//       return message ?? LocaleKeys.fillField;
//     }
//     return null;
//   }

//   static String? validateUrl(String? value) {
//     RegExp regex = RegExp(
//       r"^https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,}$",
//     );

//     if (!regex.hasMatch(value!)) {
//       return LocaleKeys.validatorUrl;
//     } else {
//       return null;
//     }
//   }
// }
