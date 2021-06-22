import 'package:flutter/material.dart';
import 'package:yakut_calendar/localization/localization_sah.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
        const Locale('sah', 'RU'),
      ],
      home: DemoApp(),
    );
  }


}

void main() {
  runApp(Demo());
}
