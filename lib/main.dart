import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:intl/intl.dart';
import 'package:yakut_calendar/localization_sah.dart';
import 'package:yakut_calendar/model/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:share/share.dart';
import 'package:yakut_calendar/model/day_data.dart';
import 'my_date_picker.dart';



void main() => runApp(new MyApp(

));


//#77061c
final Color color_firm=Colors.blueGrey;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        const LocalizationsDelegateSah(),
      ],
      supportedLocales: [
        const Locale('ru', 'RU'), // English
        const Locale('en', 'US'), // English
        const Locale('sah', 'RU'), // English
        // ... other locales the app supports
      ],
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: color_firm,
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

  DateTime _currentDate=DateTime.now();//.parse("2019-02-01");

  String article="Статья";
  String summary="Описание";
  String ad="Реклама";

  DayData sun=null;
  DayData moon=null;

  List<String> monthsLong=["Тохсунньу", "Олунньу", "Кулун тутар", "Муус устар", "Ыам ыйа", "Бэс ыйа", "От ыйа", "Атырдьах ыйа", "Балаҕан ыйа","Алтынньы","Сэтинньи","Ахсынньы"];
  List<String> weekDaysLong=["Бэнидиэнньик","Оптуорунньук","Сэрэдэ","Чэппиэр","Бээтинсэ","Субуота","Баскыһыанньа"];

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
          backgroundColor: color_firm,
          expandedHeight: 140,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(color: color_firm,child:getHeader(),),
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
              (sun!=null || moon!=null)?getSunAndMoon():Container(),
              (summary.isNotEmpty)?getContent(summary):Container(),
              //getCarousel(),
              (article.isNotEmpty)?getContent(article):Container(),
              (ad.isNotEmpty)?getContent(ad):Container(),
              (summary.isEmpty && article.isEmpty && ad.isEmpty)?getEmptyContent():Container(),
            ],
          ),
        ),
      ],
        )
    );
  }

  Widget getHeader(){
    return
      Stack(
        fit:StackFit.expand,
        alignment: AlignmentDirectional.center,
        children:[
          Image.asset(
              'assets/images/header_${_currentDate.difference(DateTime.fromMillisecondsSinceEpoch(0)).inDays%5}.jpg',
              fit: BoxFit.cover
            ,
          ),
          Row(
            children:[
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Container(
                width: 200,
                child:getDateBar(),
              ),
              Expanded(
                flex:1,
                child:Container(
                    //color:Colors.orange,
                    alignment: AlignmentDirectional.bottomEnd,
                    child:getDatePicker(),
                ),
              ),
            ]
          )
          ]
      );
  }

  Widget getKeyValueRow(String text, String value) {
    return Row(

      children: <Widget>[
        Text(
          text,
        ),
        Padding(
          padding: EdgeInsets.only(left:4),
          child:Text(
            value,
          ),
        )
      ],
    );
  }

  Widget getSunColumn(DayData data){
    return Card(
        child: Padding(
        padding:EdgeInsets.all(14.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:EdgeInsets.only(right:14.0),
          child:Icon(Icons.stars,size: 28.0,),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            (data.rise.isNotEmpty) ? getKeyValueRow("Тахсыыта", data.rise) : Container(),
            (data.set.isNotEmpty) ? getKeyValueRow("Киириитэ", data.set) : Container(),
            (data.comment.isNotEmpty) ? getKeyValueRow("Кун уьуна", data.comment) : Container(),
          ]
        ),
      ],
    )));

  }

  Widget getMoonColumn(DayData data){
    return Card(
        child: Padding(
            padding:EdgeInsets.all(14.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:EdgeInsets.only(right:14.0),
                  child:Icon(Icons.stars,size: 28.0,),
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:<Widget>[
                      (data.rise.isNotEmpty) ? getKeyValueRow("Тахсыыта", data.rise) : Container(),
                      (data.set.isNotEmpty) ? getKeyValueRow("Киириитэ", data.set) : Container(),
                      (data.comment.isNotEmpty) ? Row(
                        children: <Widget>[
                          Text(
                            data.comment,
                            maxLines: 2,
                          ),
                        ],
                      ) : Container(),
                    ]
                ),
              ],
            )));

  }

  Widget getSunAndMoonIcon(){
    return Icon(Icons.star_half,size: 45.0,);

  }

  Widget getSunAndMoon(){

    return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            sun != null ? getSunColumn(sun) : Container(),
            moon!=null ? getMoonColumn(moon) : Container(),
          ],
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
              shadows: [
                Shadow(
                  //offset: Offset(4,4),
                  blurRadius: 8
                )
              ]
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
                shadows: [
                  Shadow(
                    //offset: Offset(4,4),
                      blurRadius: 8
                  )
                ]
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
            shadows: [
              Shadow(
                //offset: Offset(4,4),
                  blurRadius: 8
              )
            ]
          ),),

      ],
    );
  }

  Widget getDatePicker(){
    return IconButton(
      color:Colors.white,
      alignment: Alignment.topRight,
      //iconSize: 48,
      icon: Icon(Icons.calendar_today),
      tooltip: 'Previous',
      onPressed: () {
        selectDateFromPicker();
        },
    );
  }

  void selectDateFromPicker()async{

    //print(DateTime.parse("2018-10-30").add(Duration(days:38)).toString());

    //print(kSupportedLanguages);


    DateTime picked = await showMyDatePicker(
        context: context,
        initialDate: _currentDate,
        locale: Locale("sah"),
        firstDate: new DateTime(2018),
        lastDate: new DateTime(2020)
    );
    if(picked != null) setState(() {
      _currentDate=picked;
      reloadAssets();
    });
  }

  Widget getContent(String data){
    return Card(
        child: Padding(
          padding:EdgeInsets.all(14.0),
          child:Column(
            children: <Widget>[
              Container(
                alignment: AlignmentDirectional.topEnd,
                child:IconButton(
                  color:Colors.black,
                  alignment: Alignment.topRight,
                  icon: Icon(Icons.share),
                  tooltip: 'Share',
                  onPressed: () { setState(() {

                    print("Share pressed");
                    Share.share(getTextOfHtml(data));

                  });},
                ),
              ),
              getFormattedWidget(data),
            ],
          )
        )
      );
  }

  Widget getEmptyContent(){
    return Card(
        child: Padding(
            padding:EdgeInsets.all(14.0),
            child:Column(
              children: <Widget>[
                Container(
                  alignment: AlignmentDirectional.center,
                  child:IconButton(
                    color:Colors.black,
                    alignment: Alignment.center,
                    icon: Icon(Icons.no_encryption),
                    iconSize: 48,
                    tooltip: 'Обновите приложение',
                    onPressed: () { setState(() {

                      print("Empty content pressed");

                    });},
                  ),
                ),
                Text(
                  "Информация сейчас отсутствует. "+((_currentDate.difference(DateTime.now()).inDays<3)?"Обновите приложение чтобы получить свежие данные":"Обновление выйдет ближе к дате"),
                  textAlign: TextAlign.center,
                ),
              ],
            )
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

                  case "подзаголовок-2 курсив" :
                    return SizedBox(
                        width: double.infinity,
                        child: Text(
                          node.text,
                          style: TextStyle(fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        )
                    );

                  case "подзаголовок-3":
                    return SizedBox(
                      width: double.infinity,
                      child: Text(
                        node.text,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
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

                  case "курсив" :
                    return DefaultTextStyle.merge(
                        child: getFormattedWidget(node.innerHtml),
                        style: TextStyle(fontStyle: FontStyle.italic),
                        textAlign: TextAlign.left
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

                  case "автор":
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

                  case "иннитэ":
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

              case "img": {
                switch(node.className){
                  case "book" :
                    print("getFormattedWidget case=img class=book src="+node.attributes["src"]);
                    return Padding(
                      padding: EdgeInsets.all(0),
                      child:Image.asset(
                        node.attributes["src"],
                        fit: BoxFit.cover,
                        //color: Colors.blueGrey,
                      ),

                    );
                    break;
                }


              }break;

            }

            return null;

          }
        },
      );

  }

  String getTextOfHtml(String data){

    var element=dom.Element.html("<div>"+data+"""<p class="Основной-текст"></p><p class="Основной-текст">http://bichik.ru</p></div>""");


    return element.text;


  }

  void reloadAssets() async{
    print("current date: ${_currentDate.toIso8601String()}");
    print("now: ${DateTime.now().toIso8601String()}");
    print("current date and now difference in days ${_currentDate.difference(DateTime.now()).inDays}");

    Future.wait([
      ArticleAssetProvider().getSummaryFor(_currentDate).then((value){
        print("summary ready");
        summary=value;
      }),
      ArticleAssetProvider().getArticleFor(_currentDate).then((value){
        print("aricle ready");
        article=value;
      }),
      ArticleAssetProvider().getAdFor(_currentDate).then((value){
        print("ad ready");
        ad=value;
      }),
      ArticleAssetProvider().getSunDataFor(_currentDate).then((value){
        print("sun ready=$value");
        sun=value;
      }),
      ArticleAssetProvider().getMoonDataFor(_currentDate).then((value){
        print("moon ready=$value");
        moon=value;
      }),
    ]).then((onValue)=>
      setState((){})
    );

  }


}

