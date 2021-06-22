import 'dart:async';

import 'package:html/dom.dart';
import 'package:yakut_calendar/repository/content_gateway.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:yakut_calendar/model/day_data.dart';

class ContentService implements ContentGateway{

  @override
  Future<String> getArticleFor(DateTime date) async {

    Element element;

    await _getHtmlString(date).then(( value ){
      element=_getElementWithTag(value,"article");
    }).catchError((error){
      print("I catch error");
      //return "";
      element=_getElementWithTag("<article></article>","article");
    }).whenComplete((){
      if(element==null||element.children.length==0){
        //return "";
        element=_getElementWithTag("<article></article>","article");
      }
    });

    return element.innerHtml;
  }

  @override
  Future<String> getSummaryFor(DateTime date) async{

    Element element;

    await _getHtmlString(date).then(( value ){
      element=_getElementWithTag(value,"summary");
    }).catchError((error){
      print("I catch error");
      //return "";
      element=_getElementWithTag("<summary></summary>","summary");
    }).whenComplete((){
      if(element==null||element.children.length==0){
        element=_getElementWithTag("<summary></summary>","summary");
        //return "";
      }
    });


    return element.innerHtml;
  }

  @override
  Future<String> getAdFor(DateTime date) async{

    Element element;

    await _getHtmlString(date).then(( value ){
      element=_getElementWithTag(value,"ad");
    }).catchError((error){
      print("I catch error");
      //return "";
      element=_getElementWithTag("<ad></ad>","ad");
    }).whenComplete((){
      if(element==null||element.children.length==0){
        element=_getElementWithTag("<ad></ad>","ad");
        //return "";
      }
    });


    return element.innerHtml;
  }

  @override
  Future<DayData> getSunDataFor(DateTime date)async{
    return await _getDayDataFor(date, "sun");
  }

  @override
  Future<DayData> getMoonDataFor(DateTime date)async{
    return await _getDayDataFor(date, "moon");
  }

  Future<String> _getHtmlString(DateTime date)async{
    return rootBundle.loadString('assets/${date.year}/${date.month}/${date.day}');
  }

  Element _getElementWithTag(String html_string, String tagname){
    dom.Document document = parser.parse(html_string);

    Element article=document.getElementsByTagName(tagname).elementAt(0);

    print("getElementWithTag tagname=$tagname: "+article.innerHtml);

    return article;
  }

  Future<DayData> _getDayDataFor(DateTime date, String tag)async{

    DayData data;

    String rise="",set="",comment="",icon="";

    await _getHtmlString(date).then(( value ){
      Element element;
      element=_getElementWithTag(value,tag);

      try {
        icon = element.getElementsByTagName("ico").elementAt(0).innerHtml;
      }catch(error){
      }
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
      data.icon=icon;

    }).catchError((error){
      print("error on getDayDataFor tag=$tag error: $error");

      data=null;
    });

    return data;
  }

}