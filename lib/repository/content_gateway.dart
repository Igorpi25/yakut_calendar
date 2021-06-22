import 'package:yakut_calendar/model/day_data.dart';

abstract class ContentGateway{
  Future<String> getArticleFor(DateTime date);
  Future<String> getSummaryFor(DateTime date);
  Future<String> getAdFor(DateTime date);
  Future<DayData> getSunDataFor(DateTime date);
  Future<DayData> getMoonDataFor(DateTime date);
}