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
import 'package:yakut_calendar/localization/name_collections.dart';
import 'package:yakut_calendar/localization/sah_date_format.dart';

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
    return weekdaysNarrowNameList;
  }


}

class LocalizationsDelegateSah extends LocalizationsDelegate<MaterialLocalizations> {

  const LocalizationsDelegateSah();

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    return SynchronousFuture(MaterialLocalizationSah(
      fullYearFormat: DateFormat("yyyy","ru"),
      twoDigitZeroPaddedFormat: NumberFormat("","ru"),
      mediumDateFormat: SahDateFormat(_formatWeekday),
      decimalFormat: NumberFormat("","ru"),
      yearMonthFormat: SahDateFormat(_formatMonth),//DateFormat("yMMMM","ru"),
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

  String _formatMonth(DateTime date) {
    final String month = monthsNameList[date.month - DateTime.january];
    return '$month ${date.year} с.';
  }

  String _formatWeekday(DateTime date) {
    return '${weekdaysNameList[(date.weekday==7)?0:date.weekday]}, ${date.day}';
  }
}



