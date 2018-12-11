// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// A simple "rough and ready" example of localizing a Flutter app.
// Spanish and English (locale language codes 'en' and 'es') are
// supported.

// The pubspec.yaml file must include flutter_localizations in its
// dependencies section. For example:
//
// dependencies:
//   flutter:
//   sdk: flutter
//  flutter_localizations:
//    sdk: flutter

// If you run this app with the device's locale set to anything but
// English or Spanish, the app's locale will be English. If you
// set the device's locale to Spanish, the app's locale will be
// Spanish.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:yakut_calendar/main.dart';

class MaterialLocalizationSah extends MaterialLocalizationRu {

  const MaterialLocalizationSah({
    String localeName = 'ar',
    @required DateFormat fullYearFormat,
    @required DateFormat mediumDateFormat,
    @required DateFormat longDateFormat,
    @required DateFormat yearMonthFormat,
    @required NumberFormat decimalFormat,
    @required NumberFormat twoDigitZeroPaddedFormat,
  }) : super(
    localeName: localeName,
    fullYearFormat: fullYearFormat,
    mediumDateFormat: mediumDateFormat,
    longDateFormat: longDateFormat,
    yearMonthFormat: yearMonthFormat,
    decimalFormat: decimalFormat,
    twoDigitZeroPaddedFormat: twoDigitZeroPaddedFormat,
  );

  @override
  List<String> get narrowWeekdays {
    return _weekdaysNarrow;
  }


}

class LocalizationsDelegateSah extends LocalizationsDelegate<MaterialLocalizations> {

  const LocalizationsDelegateSah();

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    return SynchronousFuture(MaterialLocalizationSah(
      fullYearFormat: DateFormat("yyyy","ru"),
      twoDigitZeroPaddedFormat: NumberFormat("","ru"),
      mediumDateFormat: SahDateFormat(formatWeekday),
      decimalFormat: NumberFormat("","ru"),
      yearMonthFormat: SahDateFormat(formatMonth),//DateFormat("yMMMM","ru"),
      longDateFormat: DateFormat("yyyy-MM-dd","ru"),
    )
    );
  }

  @override
  bool shouldReload(LocalizationsDelegateSah old) => false;

  @override
  bool isSupported(Locale locale) {

    return locale.languageCode=="sah";
  }
}

class DemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("asdasd"),
      ),
      body: Center(
        child: Text("asdasd"),
      ),
    );
  }


}

class Demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        const LocalizationsDelegateSah(),
      ],
      supportedLocales: [
        //const Locale('en', ''),
        const Locale('sah', 'RU'),
      ],
      // Watch out: MaterialApp creates a Localizations widget
      // with the specified delegates. DemoLocalizations.of()
      // will only find the app's Localizations widget if its
      // context is a child of the app.
      home: DemoApp(),
    );
  }


}

void main() {
  runApp(Demo());
}


class SahDateFormat extends DateFormat{

  Function f;

  SahDateFormat(Function f){
    this.f=f;
  }

  @override
  String format(DateTime date){
    if(date==null)date=DateTime.now();
    return f(date);
  }
}

List<String> _months=["Тохсунньу", "Олунньу", "Кулун тутар", "Муус устар", "Ыам ыйа", "Бэс ыйа", "От ыйа", "Атырдьах ыйа", "Балаҕан ыйа","Алтынньы","Сэтинньи","Ахсынньы"];
List<String> _weekdays=["Бас-ньа","Бэн-ник","Оп-ньук","Сэрэдэ","Чэппиэр","Бээт-сэ","Субуота"];
List<String> _weekdaysNarrow=["Бс","Бн","Опт","Сэр","Чп","Бт","Сб"];

String formatMonth(DateTime date) {
  final String month = _months[date.month - DateTime.january];
  return '$month ${date.year} с.';
}


String formatWeekday(DateTime date) {
  return '${_weekdays[(date.weekday==7)?0:date.weekday]}, ${date.day}';
}



