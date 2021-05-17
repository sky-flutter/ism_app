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
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Log In`
  String get log_in {
    return Intl.message(
      'Log In',
      name: 'log_in',
      desc: '',
      args: [],
    );
  }

  /// `Please Login to Continue Using\nOur App.`
  String get login_into_app {
    return Intl.message(
      'Please Login to Continue Using\nOur App.',
      name: 'login_into_app',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dont_have_account {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dont_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signup {
    return Intl.message(
      'Sign up',
      name: 'signup',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Receipts`
  String get receipts {
    return Intl.message(
      'Receipts',
      name: 'receipts',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Enter password`
  String get error_enter_password {
    return Intl.message(
      'Enter password',
      name: 'error_enter_password',
      desc: '',
      args: [],
    );
  }

  /// `Enter email`
  String get error_enter_email {
    return Intl.message(
      'Enter email',
      name: 'error_enter_email',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection. Make sure that Wi-Fi or mobile is turned on, then try again.`
  String get error_no_internet_connection {
    return Intl.message(
      'No internet connection. Make sure that Wi-Fi or mobile is turned on, then try again.',
      name: 'error_no_internet_connection',
      desc: '',
      args: [],
    );
  }

  /// `We could not complete your request. The network connection timed out.`
  String get error_connection_timeout {
    return Intl.message(
      'We could not complete your request. The network connection timed out.',
      name: 'error_connection_timeout',
      desc: '',
      args: [],
    );
  }

  /// `Your request has been cancelled. Please try again.`
  String get error_request_cancelled {
    return Intl.message(
      'Your request has been cancelled. Please try again.',
      name: 'error_request_cancelled',
      desc: '',
      args: [],
    );
  }

  /// `The server encountered an internal error or misconfiguration and was unable to complete request.`
  String get error_server_down {
    return Intl.message(
      'The server encountered an internal error or misconfiguration and was unable to complete request.',
      name: 'error_server_down',
      desc: '',
      args: [],
    );
  }

  /// `Check your messages. We've sent you OTP number at`
  String get error_check_your_messages {
    return Intl.message(
      'Check your messages. We\'ve sent you OTP number at',
      name: 'error_check_your_messages',
      desc: '',
      args: [],
    );
  }

  /// `Please connect with us later. There is some problem occurred.`
  String get error_apiError {
    return Intl.message(
      'Please connect with us later. There is some problem occurred.',
      name: 'error_apiError',
      desc: '',
      args: [],
    );
  }

  /// `Detailed Operations`
  String get detailed_operations {
    return Intl.message(
      'Detailed Operations',
      name: 'detailed_operations',
      desc: '',
      args: [],
    );
  }

  /// `CONFIRM`
  String get confirm {
    return Intl.message(
      'CONFIRM',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `DISCARD`
  String get discard {
    return Intl.message(
      'DISCARD',
      name: 'discard',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr', countryCode: 'FR'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}