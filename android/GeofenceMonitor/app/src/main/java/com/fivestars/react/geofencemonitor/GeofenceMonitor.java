package com.fivestars.react.geofencemonitor;

import android.app.Activity;
import android.app.Application;
import android.content.Intent;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;


import android.util.Log;

public class GeofenceMonitor extends ReactContextBaseJavaModule implements ActivityEventListener {

    private GeofenceHandler handler;
    private GeofenceMonitorJsDelivery mJsDelivery;

    public GeofenceMonitor(ReactApplicationContext reactContext) {
        super(reactContext);
        reactContext.addActivityEventListener(this);

        Application applicationContext = (Application) reactContext.getApplicationContext();

        // This is used to delivery callbacks to JS
        mJsDelivery = new GeofenceMonitorJsDelivery(reactContext);
    }

    @Override
    public String getName() {
        return "GeofenceMonitor";
    }

    @ReactMethod
    public void init(Callback errorCallback) {
        handler = new GeofenceHandler();
        Log.e("plucas", "MY ACTIVITY: " + getCurrentActivity().toString());
        handler.init(getCurrentActivity());
    }

    @ReactMethod
    public void addRegion(double lat, double lon, double radius, Callback errorCallback) {
        Log.e("plucas", "[][][] addRegion" + lat + " " + lon + " " + radius);
        errorCallback.invoke("abc", 123);
    }

    public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
        Log.e("plucas", "[]][] onActivityResult!");
    }

    public void onNewIntent(Intent intent) {
        Log.e("plucas", "[]][] onNewIntent!!!");
        if (intent.hasExtra("notification")) {
//            Bundle bundle = intent.getBundleExtra("notification");
//            bundle.putBoolean("foreground", false);
//            intent.putExtra("notification", bundle);
//            mJsDelivery.notifyNotification(bundle);
        }
    }
}
