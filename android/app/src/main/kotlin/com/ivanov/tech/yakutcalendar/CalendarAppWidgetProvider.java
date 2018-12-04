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
import android.util.Log;
import android.widget.RemoteViews;

import java.io.FileDescriptor;
import java.io.IOException;
import java.io.InputStream;

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

            // Get the layout for the App Widget and attach an on-click listener
            // to the button
            RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.widget_layout);

            views.setOnClickPendingIntent(R.id.empty_view, pendingIntent);

            String summary_text="<p class=\"юбилей\">СӨ тыатын хаһаайыстыбатын үтүөлээх үлэһитэ Н. Е.&#160;Павлов (1944) 75&#160;сааһа</p>\n"
                    +"    <p class=\"юбилей\">РФ уонна СӨ искусстволарын үтүөлээх диэйэтэлэ А. Л.&#160;Габышева (1949) 70&#160;сааһа</p>\n"
                    +"    <p class=\"юбилей\">СӨ государственнай бириэмийэтин <br />лауреата П. П.&#160;Томскай (1949) 70&#160;сааһа</p>\n"
                    +"    <p class=\"юбилей\">СӨ искусстволарын үтүөлээх диэйэтэлэ М. Г.&#160;Старостин (1959) 60&#160;сааһа</p>"
                    ;

            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N) {
                views.setTextViewText(R.id.summary,Html.fromHtml(summary_text,Html.FROM_HTML_MODE_LEGACY));
            } else {
                views.setTextViewText(R.id.summary,Html.fromHtml(summary_text));
            }



            /*try {
                Log.d("Igor","imageview begin");

                AssetManager assetManager = context.getAssets();
                String key = getLookupKeyForAsset("assets/images/pattern_1.png");

                InputStream is=assetManager.open(key);
                Bitmap b=BitmapFactory.decodeStream(is);

                views.setImageViewBitmap(R.id.pattern,b);
                Log.d("Igor","imageview key="+key);
                Log.d("Igor","imageview b.height="+b.getHeight()+" b.width="+b.getWidth());
            } catch (IOException e) {
                Log.d("Igor","IOException e:"+e);
            } catch (NullPointerException e){
                Log.d("Igor","NullPointerException e:"+e);
            }finally{
                Log.d("Igor","imageview end");
            }*/




            // Tell the AppWidgetManager to perform an update on the current app widget
            appWidgetManager.updateAppWidget(appWidgetId, views);
        }
    }

}
