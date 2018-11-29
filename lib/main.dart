import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:yakut_calendar/model/provider.dart';


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

  String article="Статья";
  String summary="Описание";

  List<String> monthsLong=["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь","Октябрь","Ноябрь","Декабрь"];
  List<String> weekDaysLong=["Воскресенье","Понедельник","Вторник","Среда","Четверг","Пятница","Суббота"];

  @override
  void initState(){
    super.initState();

    reloadAssets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //color:Colors.blue,
        body:CustomScrollView(
      primary: true,
      slivers: <Widget>[
        SliverAppBar(
          //title: Text('SliverAppBar'),
          backgroundColor: Colors.blue,
          expandedHeight: 140,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(color: Colors.blue,child:getDateBar(),),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              getSummary(),
              getCarousel(),
              getArticle(),
            ],
          ),
        ),
      ],
        )
    );
  }

  Widget getCarousel() {
    return Card(
      //color: Colors.green,
      //margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: CalendarCarousel(
        onDayPressed: (DateTime date) {
          this.setState((){
            _currentDate = date;
            print("Duration:${_currentDate.difference(DateTime.now()).inDays}");
            reloadAssets();
          });
        },
        todayButtonColor: Colors.transparent,
        todayTextStyle: TextStyle(color:(_currentDate.difference(DateTime.now()).inDays==0)?Colors.white:Colors.blue),
        thisMonthDayBorderColor: Colors.grey,
        weekdayTextStyle:TextStyle(color:Colors.red),
        weekendTextStyle:TextStyle(color:Colors.red),
        headerTextStyle:TextStyle(color:Colors.blue),
        //selectedDayButtonColor: Colors.blue,
        selectedDayBorderColor: Colors.blue,
        selectedDayTextStyle: TextStyle(color:Colors.white),
        height: 420.0,
        selectedDateTime: _currentDate,
        daysHaveCircularBorder: null,

        //headerText: Text('${monthsLong[_currentDate.month-1]} ${DateFormat.y().format(_currentDate)}'),


          ///null for not rendering any border, true for circular border, false for rectangular border
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

  Widget getDateBar(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '${monthsLong[_currentDate.month-1]}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),),
        Text(
          '${_currentDate.day}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 48,
        ),),
        Text(
          '${weekDaysLong[_currentDate.weekday-1]}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),),
      ],
    );
  }

  Widget getSummary(){
    return
      Card(child:
      Container(
          //color:Colors.red,
          child: Html(
            data: summary,
            //Optional parameters:
            padding: EdgeInsets.all(8.0),
          )
      )
      );
  }

  Widget getArticle(){
    return
      Card(child:
          Container(
            //color:Colors.orange,
            child: Html(
              data: article,
              //Optional parameters:
              padding: EdgeInsets.all(8.0),
            )
          )
    );
  }

  void reloadAssets(){
    ArticleAssetProvider().getArticleFor(_currentDate).then((value){
      print("aricle ready");
      article=value;
      setState((){});
    });
    ArticleAssetProvider().getSummaryFor(_currentDate).then((value){
      print("summary ready");
      summary=value;
      setState((){});
    });
  }



}

