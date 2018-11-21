import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  DateTime _currentDate=DateTime.now();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Text("asdasd"),
            getCarousel(),
          ],
        )
    );
  }

  Widget getCarousel() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: CalendarCarousel(
        onDayPressed: (DateTime date) {
          this.setState(() => _currentDate = date);
        },
        thisMonthDayBorderColor: Colors.grey,
        height: 420.0,
        selectedDateTime: _currentDate,
        daysHaveCircularBorder: null,

        /// null for not rendering any border, true for circular border, false for rectangular border
//        markedDatesMap: _markedDateMap,
//          weekendStyle: TextStyle(
//            color: Colors.red,
//          ),
//          weekDays: null, /// for pass null when you do not want to render weekDays
//          headerText: Container( /// Example for rendering custom header
//            child: Text('Custom Header'),
//          ),
      ),
    );
  }
}

