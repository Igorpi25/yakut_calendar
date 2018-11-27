import 'dart:async';

import 'package:html/dom.dart';
import 'package:yakut_calendar/model/repository.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

class ArticleAssetProvider implements ArticleRepository{

  @override
  Future<String> getArticleFor(DateTime date) async {

    Element element;

    await getHtmlString(date).then(( value ){
      element=getElementWithTag(value,"article");
    }).catchError((error){
      print("I catch error");
      element=getElementWithTag("<article>Контент не найден</article>","article");
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
      element=getElementWithTag("<summary>Короткое описание не найдено</summary>","summary");
    });


    return element.innerHtml;
  }

  Future<String> getHtmlString(DateTime date)async{
    return rootBundle.loadString('assets/${date.year}/${date.month}/${date.day}');
  }

  Element getElementWithTag(String html_string, String tagname){
    dom.Document document = parser.parse(html_string);


    Element article=document.getElementsByTagName(tagname).elementAt(0);

    print("getElementWithTag article="+article.innerHtml);

    return article;
  }
  
  


}