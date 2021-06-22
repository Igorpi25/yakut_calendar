# Календарь издательство "Бичик"

Календарь и виджет на якутском языке по заказу издательства Бичик 2018 г.

![alt text](../media/screenshots/banner.jpg?raw=true)

## Виджеты для iOS и Android

В обоих платформах реалтизованы виджеты, 
где отображаются текущая дата и краткий контент (summary)

<img src="../media/screenshots/widget-ios.png?raw=true" height="400"> <img src="../media/screenshots/widget-android.jpg?raw=true" height="400">

## Поддержка якутского формата даты и времени

Приложение поддерживает только один язык - якутский. 
Якутский не входит в состав `MaterialLocalizations`, поэтому реализована собственная поддержка 
правильных наименований месяцев и дней недели на якутском языке.

Файл с локализацией лежит в [lib/localization_sah.dart](lib/localization_sah.dart).
Подключение к проекту в файле `main.dart` в `MaterialApp.localizationsDelegates`.

## Шрифты

Используются спец шрифты с поддержкой якутских букв:

- SKH_VERDANA.ttf
- SKH_VERDANAB.ttf (bold)

ВНИМАНИЕ! Если у вас проблема с отображением текста из папки /assets, 
то установите эти шрифты на ваш компьютер

## Формат хранение контента

<img src="../media/screenshots/screen-3.jpg?raw=true" height="400"> <img src="../media/screenshots/screen-27.jpg?raw=true" height="400"> <img src="../media/screenshots/screen-picker.jpg?raw=true" height="400"> 

В приложении используется формат XML(расширенный вариант HTML) для хранения контента.
XML, по сравнению с JSON, более удобен с точки зрения читабельности и редактирования 
большого объема текста.

Автор ввел следующие теги:

- article основное тело контента
- summary краткое описание
- p текст с нового абзаца
    - class атрибут для оформления текста
- span тег для оформления текста внутри тега p
    - class атрибут оформления 
- sun циклы солнца
    - ico иконка `assets/icon/sun.png`
    - ris
    - set
    - com
- moon циклы луны
    - ico иконки `assets/icon/[1-8].png`
    - ris
    - set
    - com

## Парсер контента

Автор парсит XML, испольуя виджет `Html`, для рекурсивного обхода XML.
Отрисовка происходит полностью кастомно, НЕ используя стандартный рендер Html
(т.к. хреново справляется) 
В зависимости от тега и атрибута, динамически формирется древо из стандартных виджетов.

Кастомный рендер можно посмотреть в файле `main.dart`, в функции getFormattedWidget

## GooglePlay и Appstore

В данное время приложение может быть удалено из маркетов,
т.к. автор прекратил поддержку приложения  

[<img src="../media/screenshots/icon-googleplay.png?raw=true" width="200">](https://play.google.com/store/apps/details?id=com.ivanov.tech.yakutcalendar)
[<img src="../media/screenshots/icon-appstore.png?raw=true" width="200">](https://apps.apple.com/us/app/сахалыы-халандаар/id1446178866)

## Share

Приложение дает возможность поделиться контентом. Можно поделиться как основным контентом,
также можно отправить отдельно только summary

