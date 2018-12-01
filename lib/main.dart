import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
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

  DateTime _currentDate=DateTime.parse("2019-02-01");

  String article="Статья";
  String summary="Описание";

  List<String> monthsLong=["Тохсунньу", "Олунньу", "Кулун тутар", "Муус устар", "Ыам ыйа", "Бэс ыйа", "От ыйа", "Атырдьах ыйа", "Бала5ан ыйа","Алтынньы","Сэтинньи","Ахсынньы"];
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
//              Padding(
//                padding: EdgeInsets.only(top: 0),
//                child:Image.asset(
//                  "assets/images/pattern_1.png",
//                  fit: BoxFit.cover,
//                  color: Colors.blue,
//                ),
//
//              ),
              (summary.isNotEmpty)?getContent(summary):Container(),
              //getCarousel(),
              getContent(article),
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
            //print("Duration:${_currentDate.difference(DateTime.now()).inDays}");
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
        height: 380.0,
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
        Padding(
          padding:EdgeInsets.only(top: 20),
          child:Text(
            '${monthsLong[_currentDate.month-1]}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            Expanded(
              flex: 1,
              child:IconButton(
                color:Colors.white,
                alignment: Alignment.centerRight,
                iconSize: 48,
                icon: Icon(Icons.arrow_left),
                tooltip: 'Previous',
                onPressed: () { setState(() {
                  _currentDate=_currentDate.add(-Duration(days:1));
                  print("Previous pressed");
                  reloadAssets();
                });},
              ),
            ),
            Text(
              '${_currentDate.day}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
              ),
            ),
            Expanded(
              flex: 1,
              child:IconButton(
                color:Colors.white,
                alignment: Alignment.centerLeft,
                iconSize: 48,
                icon: Icon(Icons.arrow_right),
                tooltip: 'Next',
                onPressed: () { setState(() {
                  _currentDate=_currentDate.add(Duration(days:1));
                  print("Next pressed");
                  reloadAssets();
                });},
              ),
            ),
          ]
        ),
        Text(
          '${weekDaysLong[_currentDate.weekday-1]}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),),

      ],
    );
  }

  Widget getContent(String data){
    return Card(
        child: Padding(
          padding:EdgeInsets.all(14.0),
          child:getFormattedWidget(data),
        )
      );
  }

  Widget getFormattedWidget(String data){
    return
      Html(
        data: data,
        padding: EdgeInsets.all(0.0),
        customRender: (node, children) {
          if (node is dom.Element) {
            switch (node.localName) {
              case "p": {
                switch (node.className) {
                  case "юбилей" :
                  case "билгэ" :
                    return Padding(
                        padding:EdgeInsets.only(bottom:14),
                        child:SizedBox(
                          width: double.infinity,
                          child:DefaultTextStyle.merge(
                            child: Text(node.text),
                            style: TextStyle(fontStyle: FontStyle.italic,),
                            textAlign: TextAlign.center,
                          )
                        )
                    );

                  case "подзаголовок-2" :
                  case "подзаголовок-2 ParaOverride-32":
                  case "подзаголовок-2 ParaOverride-37":
                    return SizedBox(
                        width: double.infinity,
                        child: Text(
                          node.text,
                          style: TextStyle(fontWeight: FontWeight.bold,),
                          textAlign: TextAlign.center,
                        )
                    );

                  case "подзаголовок-2 ParaOverride-34":
                    return SizedBox(
                        width: double.infinity,
                        child: Text(
                          node.text,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        )
                    );

                  case "профдень" :
                  case "примета" :
                    return Padding(
                      padding:EdgeInsets.only(bottom:14),
                      child:SizedBox(
                        width: double.infinity,
                        child: Text(
                          node.text,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: "SKH_VERDANA",
                          ),
                          textAlign: TextAlign.center,

                        )
                      )
                    );

                  case "бичик":
                    return Padding(
                        padding:EdgeInsets.only(),
                        child:SizedBox(
                            width: double.infinity,
                            child: Text(
                              node.text,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: "SKH_VERDANA",
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,

                            )
                        )
                    );

                  case "рубрики":
                    return SizedBox(
                        width: double.infinity,
                        child: Text(
                          node.text,
                          style: TextStyle(
                            //fontWeight: FontWeight.bold,
                              fontFamily: "SKH_VERDANA",
                              decoration: TextDecoration.underline
                          ),
                          textAlign: TextAlign.right,
                        )
                    );


                  case "стих-строка" :
                  case "Основной-текст ParaOverride-18":
                  case "Основной-текст ParaOverride-30":
                  case "Основной-текст ParaOverride-33":
                  case "Основной-текст ParaOverride-38":
                    return SizedBox(
                        width: double.infinity,
                        child: Text(
                          node.text,
                          textAlign: TextAlign.center,
                        )
                    );

                  case "стих-строка-первая" :
                  case "Основной-текст ParaOverride-17":
                  case "Основной-текст ParaOverride-31":
                  case "осн-до-1-5 ParaOverride-18":
                  case "осн-до-1-5 ParaOverride-30":
                  case "осн-до-1-5 ParaOverride-33":
                  case "осн-до-1-5 _idGenParaOverride-1":
                  return SizedBox(
                    width: double.infinity,
                    child: Padding(
                        child:Text(
                          node.text,
                          textAlign: TextAlign.center,
                        ),
                        padding:EdgeInsetsDirectional.only(top:14)
                    ),
                  );

                  case "ХЫ" :
                  case "ХЫ _idGenParaOverride-1":
                    return SizedBox(
                      width: double.infinity,
                      child: Padding(
                          child:Text(
                            node.text,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          padding:EdgeInsetsDirectional.only(top:14)
                      ),
                    );

                  case "подпись" :
                    return SizedBox(
                      width: double.infinity,
                      child: Padding(
                          child:Text(
                            node.text,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: "SKH_VERDANA",
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                          padding:EdgeInsetsDirectional.only(top:14)
                      ),
                    );

                  case "подпись _idGenParaOverride-1" :
                  case "подпись ParaOverride-7":
                    return SizedBox(
                      width: double.infinity,
                      child: Padding(
                          child:Text(
                            node.text,
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          padding:EdgeInsetsDirectional.only(top:0)
                      ),
                    );

                  case "таайыыта":
                  case "салгыыта ParaOverride-11" :
                    return SizedBox(
                      width: double.infinity,
                      child: Padding(
                          child: RotationTransition(
                            turns: new AlwaysStoppedAnimation(180 / 360),
                            child:Text(
                              node.text,
                              style: TextStyle(
                                fontFamily: "SKH_VERDANA",
                                fontStyle: FontStyle.italic,
                                fontSize: 12,
                                //fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          padding:EdgeInsetsDirectional.only(top:14)
                      ),
                    );

                  case "саҕаланыыта":
                  case "саҕаланыыта ParaOverride-6":
                  case "саҕаланыыта ParaOverride-28" :
                    return SizedBox(
                      width: double.infinity,
                      child: Padding(
                          child:Text(
                            node.text,
                            style: TextStyle(
                              fontFamily: "SKH_VERDANA",
                              fontStyle: FontStyle.italic,
                              fontSize: 12,
                              //fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          padding:EdgeInsetsDirectional.only(top:0)
                      ),
                    );

                  case "салгыыта":
                  case "салгыыта _idGenParaOverride-1" :
                  case "салгыыта ParaOverride-6":
                    return SizedBox(
                      width: double.infinity,
                      child: Padding(
                          child:Text(
                            node.text,
                            style: TextStyle(
                              fontFamily: "SKH_VERDANA",
                              fontStyle: FontStyle.italic,
                              fontSize: 12,
                              //fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          padding:EdgeInsetsDirectional.only(top:0)
                      ),
                    );

                  default :
                    return SizedBox(
                        width: double.infinity,
                        child: (children.length==0)?Text(
                          node.text,
                          textAlign: TextAlign.justify,
                        ):
                        DefaultTextStyle.merge(
                            child:getFormattedWidget(node.innerHtml),
                            textAlign: TextAlign.justify,
                        )
                    );
                }



              }break;

              case "span": {
                switch (node.className) {
                  case "CharOverride-21" :
                    return DefaultTextStyle.merge(
                        child: getFormattedWidget(node.innerHtml),
                        style: TextStyle(fontStyle: FontStyle.italic),
                        textAlign: TextAlign.left
                    );

                  case "жирный" :
                  case "CharOverride-15":
                    return DefaultTextStyle.merge(
                        child: getFormattedWidget(node.innerHtml),
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left
                    );

                }

              }break;

              case "pattern": {
                print("getFormattedWidget case=pattern");
                return Padding(
                  padding: EdgeInsets.all(0),
                  child:Image.asset(
                    "assets/images/pattern_1.png",
                    fit: BoxFit.cover,
                    color: Colors.black,
                  ),

                );

              }break;

            }

            return null;

          }
        },
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

