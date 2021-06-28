import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('it'),
  ];

  static String getFlag(String code) {
    switch (code) {
      case 'it':
        return '🇮🇹';
      case 'en':
      default:
        return '🇺🇸';
    }
  }
}
