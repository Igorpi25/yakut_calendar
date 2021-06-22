import 'package:intl/intl.dart';

class SahDateFormat extends DateFormat{

  Function f;

  SahDateFormat(Function f){
    this.f=f;
  }

  @override
  String format(DateTime date){
    if(date==null)date=DateTime.now();
    return f(date);
  }
}