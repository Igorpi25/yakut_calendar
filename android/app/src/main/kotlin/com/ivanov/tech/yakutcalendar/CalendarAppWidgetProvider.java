package com.ivanov.tech.yakutcalendar;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.Intent;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.text.Html;
import android.text.Spanned;
import android.util.Log;
import android.view.ViewStructure;
import android.widget.RemoteViews;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.BufferedReader;
import java.io.FileDescriptor;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.time.LocalDate;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;

import static io.flutter.view.FlutterMain.getLookupKeyForAsset;

public class CalendarAppWidgetProvider extends AppWidgetProvider {

    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        final int N = appWidgetIds.length;

        // Perform this loop procedure for each App Widget that belongs to this provider
        for (int i = 0; i < N; i++) {

            Log.e("Igor", "onUpdate i=" + i);

            int appWidgetId = appWidgetIds[i];

            // Create an Intent to launch ExampleActivity
            Intent intent = new Intent(context, MainActivity.class);
            PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, intent, 0);

            // Get the layout for the App Widget
            RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.widget_layout);

            Calendar calendar = Calendar.getInstance();
            //calendar.add(Calendar.DAY_OF_YEAR, 1);

            //Title & Subtitle
            views.setTextViewText(R.id.title, getTitle(calendar));
            views.setTextViewText(R.id.subtitle, getSubtitle(calendar));

            //Summary
            Spanned summary = getSummary(context, calendar);
            views.setTextViewText(R.id.summary, summary);

            views = setupSunAndMoon(context, calendar, views);

            //Open App when click
            views.setOnClickPendingIntent(R.id.root, pendingIntent);

            // Tell the AppWidgetManager to perform an update on the current app widget
            appWidgetManager.updateAppWidget(appWidgetId, views);
        }

    }

    static String[] monthsLong = {"Тохсунньу", "Олунньу", "Кулун тутар", "Муус устар", "Ыам ыйа", "Бэс ыйа", "От ыйа", "Атырдьах ыйа", "Балаҕан ыйа", "Алтынньы", "Сэтинньи", "Ахсынньы"};
    static String[] weekdaysLong = {"Бэнидиэнньик", "Оптуорунньук", "Сэрэдэ", "Чэппиэр", "Бээтинсэ", "Субуота", "Баскыһыанньа"};


    public static String readFile(AssetManager mgr, String path) {

        Log.d("Igor", "readFile begin");
        Log.d("Igor", "readFile path=" + path);


        String contents = "";
        InputStream is = null;
        BufferedReader reader = null;
        try {
            is = mgr.open(path);
            reader = new BufferedReader(new InputStreamReader(is));
            contents = reader.readLine();
            String line = null;
            while ((line = reader.readLine()) != null) {
                contents += '\n' + line;
            }
        } catch (final Exception e) {
            Log.e("Igor", "readFile Exception e:" + e);
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException ignored) {
                }
            }
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException ignored) {
                    Log.e("Igor", "readFile IOException ignored:" + ignored);
                }
            }
        }

        Log.d("Igor", "readFile end");

        Log.d("Igor", "readFile result:" + contents);

        return contents;
    }

    public static String assetPath(Calendar calendar) {

        int year = calendar.get(Calendar.YEAR);
        int month = calendar.get(Calendar.MONTH) + 1;
        int day = calendar.get(Calendar.DAY_OF_MONTH);

        String result = "assets/" + year + "/" + month + "/" + day;

        Log.d("Igor Log", "assetPath value=" + result);

        return result;
    }

    public static Spanned getSummary(Context context, Calendar calendar) {

        AssetManager assetManager = context.getAssets();
        String key = getLookupKeyForAsset(assetPath(calendar));

        String html = readFile(assetManager, key);

        Document doc = Jsoup.parse(html);
        Elements summary_element = doc.getElementsByTag("summary");

        String summary_html = summary_element.text();

        summary_html = summary_html.replaceAll("([\\n\\r]+\\s*)*$", "");

        Spanned spanned = null;

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N) {
            spanned = Html.fromHtml(summary_html, Html.FROM_HTML_MODE_LEGACY);
        } else {
            spanned = Html.fromHtml(summary_html);
        }

        return spanned;
    }

    public static Spanned getArticle(Context context, Calendar calendar) {

        AssetManager assetManager = context.getAssets();
        String key = getLookupKeyForAsset(assetPath(calendar));

        String html = readFile(assetManager, key);

        Document doc = Jsoup.parse(html);
        Elements summary_element = doc.getElementsByTag("article");

        String summary_html = summary_element.text();

        summary_html = summary_html.replaceAll("([\\n\\r]+\\s*)*$", "");

        Spanned spanned = null;

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N) {
            spanned = Html.fromHtml(summary_html, Html.FROM_HTML_MODE_LEGACY);
        } else {
            spanned = Html.fromHtml(summary_html);
        }

        return spanned;
    }

    public static RemoteViews setupSunAndMoon(Context context, Calendar calendar, RemoteViews views) {

        AssetManager assetManager = context.getAssets();
        String key = getLookupKeyForAsset(assetPath(calendar));

        String html = readFile(assetManager, key);

        Document doc = Jsoup.parse(html);

        Element sun_element = doc.getElementsByTag("sun").first();

        if (sun_element != null) {
            try {
                String sun_ico = sun_element.getElementsByTag("ico").first().text();
                if (sun_ico != null && !sun_ico.isEmpty()) {
                    views.setImageViewBitmap(R.id.sun_icon, getImage(context, "assets/icon/" + sun_ico + ".png"));
                } else {
                    views.setImageViewBitmap(R.id.sun_icon, getImage(context, "assets/icon/sun.png"));
                }
            } catch (Exception e) {

            }

            try {
                String sun_ris = sun_element.getElementsByTag("ris").first().text();
                views.setTextViewText(R.id.sun_rise, sun_ris);
            } catch (Exception e) {
            }

            try {
                String sun_set = sun_element.getElementsByTag("set").first().text();
                views.setTextViewText(R.id.sun_set, sun_set);
            } catch (Exception e) {
            }

            try {
                String sun_com = sun_element.getElementsByTag("com").first().text();
                views.setTextViewText(R.id.sun_comment, sun_com);
            } catch (Exception e) {
            }
        }


        Element moon_element = doc.getElementsByTag("moon").first();

        if (sun_element != null) {
            try {
                String moon_ico = moon_element.getElementsByTag("ico").first().text();
                views.setImageViewBitmap(R.id.moon_icon, getImage(context, "assets/icon/" + moon_ico + ".png"));
            } catch (Exception e) {
            }

            try {
                String moon_ris = moon_element.getElementsByTag("ris").first().text();
                views.setTextViewText(R.id.moon_rise, moon_ris);
            } catch (Exception e) {
            }

            try {
                String moon_set = moon_element.getElementsByTag("set").first().text();
                views.setTextViewText(R.id.moon_set, moon_set);
            } catch (Exception e) {
            }
        }


        return views;

    }

    public static String getTitle(Calendar calendar) {

        int month = calendar.get(Calendar.MONTH);
        int day = calendar.get(Calendar.DAY_OF_MONTH);

        return monthsLong[month] + " " + day;
    }

    public static String getSubtitle(Calendar calendar) {

        int weekday = calendar.get(Calendar.DAY_OF_WEEK);
        int year = calendar.get(Calendar.YEAR);

        return weekdaysLong[weekday - 1] + ", " + year;
    }

    public static Bitmap getImage(Context context, String path) {

        Bitmap b = null;

        try {
            Log.d("Igor", "imageview begin");

            AssetManager assetManager = context.getAssets();
            String key = getLookupKeyForAsset(path);

            InputStream is = assetManager.open(key);
            b = BitmapFactory.decodeStream(is);

            Log.d("Igor", "imageview key=" + key);
            Log.d("Igor", "imageview b.height=" + b.getHeight() + " b.width=" + b.getWidth());

        } catch (IOException e) {
            Log.d("Igor", "imageview IOException e:" + e);
        } catch (NullPointerException e) {
            Log.d("Igor", "imageview NullPointerException e:" + e);
        } finally {
            Log.d("Igor", "imageview end");
        }

        return b;
    }


}
