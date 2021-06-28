import 'dart:io';

import 'package:e_tutoring/provider/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:e_tutoring/l10n/l10n.dart';
import 'package:provider/provider.dart';

class LanguageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    final flag = L10n.getFlag(locale.languageCode);
    return Center(
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 72,
        child: Text(
          flag,
          style: TextStyle(fontSize: 80),
        ),
      ),
    );
  }
}

class LanguagePickerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    // print(provider.locale);
    /*if (provider.locale == null) {
      UserSecureStorage.setLanguage('en');
      print(UserSecureStorage.getLanguage());
    }*/
    // print(provider.locale);
    // print(Platform.localeName.toString().substring(0, 2));
    final locale = provider.locale ??
        (Platform.localeName.toString().substring(0, 2) == "it"
            ? Locale("it")
            : Locale('en'));
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        value: locale,
        icon: Container(width: 12),
        items: L10n.all.map(
          (locale) {
            final flag = L10n.getFlag(locale.languageCode);
            return DropdownMenuItem(
              child: Center(
                child: Text(
                  flag,
                  style: TextStyle(fontSize: 32),
                ),
              ),
              value: locale,
              onTap: () {
                final provider =
                    Provider.of<LocaleProvider>(context, listen: false);

                provider.setLocale(locale);
              },
            );
          },
        ).toList(),
        onChanged: (_) {},
      ),
    );
  }
}
