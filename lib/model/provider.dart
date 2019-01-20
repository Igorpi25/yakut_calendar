import 'dart:async';

import 'package:html/dom.dart';
import 'package:yakut_calendar/model/repository.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:yakut_calendar/model/day_data.dart';

class ArticleAssetProvider implements ArticleRepository{

  @override
  Future<String> getArticleFor(DateTime date) async {

    Element element;

    await getHtmlString(date).then(( value ){
      element=getElementWithTag(value,"article");
    }).catchError((error){
      print("I catch error");
      //return "";
      element=getElementWithTag("<article></article>","article");
    }).whenComplete((){
      if(element==null||element.children.length==0){
        //return "";
        element=getElementWithTag("<article></article>","article");
      }
    });

    return element.innerHtml;
  }

  @override
  Future<String> getSummaryFor(DateTime date) async{

    Element element;

    await getHtmlString(date).then(( value ){
      element=getElementWithTag(value,"summary");
    }).catchError((error){
      print("I catch error");
      //return "";
      element=getElementWithTag("<summary></summary>","summary");
    }).whenComplete((){
      if(element==null||element.children.length==0){
        element=getElementWithTag("<summary></summary>","summary");
        //return "";
      }
    });


    return element.innerHtml;
  }

  @override
  Future<String> getAdFor(DateTime date) async{

    Element element;

    await getHtmlString(date).then(( value ){
      element=getElementWithTag(value,"ad");
    }).catchError((error){
      print("I catch error");
      //return "";
      element=getElementWithTag("<ad></ad>","ad");
    }).whenComplete((){
      if(element==null||element.children.length==0){
        element=getElementWithTag("<ad></ad>","ad");
        //return "";
      }
    });


    return element.innerHtml;
  }

  Future<String> getHtmlString(DateTime date)async{
    return rootBundle.loadString('assets/${date.year}/${date.month}/${date.day}');
  }

  Element getElementWithTag(String html_string, String tagname){
    dom.Document document = parser.parse(html_string);

    Element article=document.getElementsByTagName(tagname).elementAt(0);

    print("getElementWithTag tagname=$tagname: "+article.innerHtml);

    return article;
  }

  Future<DayData> getDayDataFor(DateTime date, String tag)async{

    DayData data;

    String rise="",set="",comment="";

    await getHtmlString(date).then(( value ){
      Element element;
      element=getElementWithTag(value,tag);

      try {
        rise = element.getElementsByTagName("ris").elementAt(0).innerHtml;
      }catch(error){
      }
      try {
        set = element.getElementsByTagName("set").elementAt(0).innerHtml;
      }catch(error){
      }
      try {
        comment = element.getElementsByTagName("com").elementAt(0).innerHtml;
      }catch(error){
      }

      data=new DayData();

      data.rise=rise;
      data.set=set;
      data.comment=comment;

    }).catchError((error){
      print("error on getDayDataFor tag=$tag error: $error");

      data=null;
    });

    return data;
  }

  @override
  Future<DayData> getSunDataFor(DateTime date)async{
    return await getDayDataFor(date, "sun");
  }

  @override
  Future<DayData> getMoonDataFor(DateTime date)async{
    return await getDayDataFor(date, "moon");
  }


}