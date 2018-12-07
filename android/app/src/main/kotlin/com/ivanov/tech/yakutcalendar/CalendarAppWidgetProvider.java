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
        for (int i=0; i<N; i++) {

            Log.e("Igor Log","onUpdate i="+i);

            int appWidgetId = appWidgetIds[i];

            // Create an Intent to launch ExampleActivity
            Intent intent = new Intent(context, MainActivity.class);
            PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, intent, 0);

            // Get the layout for the App Widget
            RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.widget_layout);

            Calendar calendar=Calendar.getInstance();

            //Title & Subtitle
            views.setTextViewText(R.id.title,getTitle(calendar));
            views.setTextViewText(R.id.subtitle,getSubtitle(calendar));

            //Summary
            views.setTextViewText(R.id.summary,getSummary(context,calendar));

            //Pattern
            //views.setImageViewBitmap(R.id.pattern,getPattern(context));

            //Open App when click
            views.setOnClickPendingIntent(R.id.root, pendingIntent);

            // Tell the AppWidgetManager to perform an update on the current app widget
            appWidgetManager.updateAppWidget(appWidgetId, views);
        }
    }

    static String[] monthsLong={"Тохсунньу", "Олунньу", "Кулун тутар", "Муус устар", "Ыам ыйа", "Бэс ыйа", "От ыйа", "Атырдьах ыйа", "Бала5ан ыйа","Алтынньы","Сэтинньи","Ахсынньы"};
    static String[] weekdaysLong={"Воскресенье","Понедельник","Вторник","Среда","Четверг","Пятница","Суббота"};


    public static String readFile(AssetManager mgr, String path) {

        Log.d("Igor","readFile begin");
        Log.d("Igor","readFile path="+path);


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
            Log.e("Igor","readFile Exception e:"+e);
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
                    Log.e("Igor","readFile IOException ignored:"+ignored);
                }
            }
        }

        Log.d("Igor","readFile end");

        Log.d("Igor","readFile result:"+contents);

        return contents;
    }

    public static String assetPath(Calendar calendar){

        int year=calendar.get(Calendar.YEAR);
        int month=calendar.get(Calendar.MONTH)+1;
        int day=calendar.get(Calendar.DAY_OF_MONTH);

        String result="assets/"+year+"/"+month+"/"+day;

        Log.d("Igor Log","assetPath value="+result);

        return result;
    }

    public static Spanned getSummary(Context context,Calendar calendar){

        AssetManager assetManager = context.getAssets();
        String key = getLookupKeyForAsset(assetPath(calendar));

        String html=readFile(assetManager,key);

        Document doc = Jsoup.parse(html);
        Elements summary_element = doc.getElementsByTag("summary");

        String summary_html=summary_element.html();

        Spanned spanned=null;

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N) {
            spanned = Html.fromHtml(summary_html,Html.FROM_HTML_MODE_LEGACY);
        } else {
            spanned = Html.fromHtml(summary_html);
        }

        return spanned;
    }

    public static String getTitle(Calendar calendar){

        int month=calendar.get(Calendar.MONTH);
        int day=calendar.get(Calendar.DAY_OF_MONTH);

        return monthsLong[month]+" "+day;
    }

    public static String getSubtitle(Calendar calendar){

        int weekday=calendar.get(Calendar.DAY_OF_WEEK);
        int year=calendar.get(Calendar.YEAR);

        return weekdaysLong[weekday-1]+", "+year;
    }

    public static Bitmap getPattern(Context context){

        Bitmap b=null;

        try {
            Log.d("Igor","imageview begin");

            AssetManager assetManager = context.getAssets();
            String key = getLookupKeyForAsset("assets/images/pattern_1.png");

            InputStream is=assetManager.open(key);
            BitmapFactory.decodeStream(is);

            Log.d("Igor","imageview key="+key);
            Log.d("Igor","imageview b.height="+b.getHeight()+" b.width="+b.getWidth());

        } catch (IOException e) {
            Log.d("Igor","IOException e:"+e);
        } catch (NullPointerException e){
            Log.d("Igor","NullPointerException e:"+e);
        }finally{
            Log.d("Igor","imageview end");
        }

        return b;
    }


}
