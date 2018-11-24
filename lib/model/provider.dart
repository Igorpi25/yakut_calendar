import 'package:yakut_calendar/model/repository.dart';
import 'package:flutter/services.dart' show rootBundle;

class ArticleAssetProvider implements ArticleRepository{
  @override
  Future<String> getArticleFor(DateTime date) async {

    return await rootBundle.loadString('assets/${date.year}/${date.month}/${date.day}.html');
  }

  @override
  Future<String> getSummaryFor(DateTime date) {
    // TODO: implement getSummaryFor
    return null;
  }


}