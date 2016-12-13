package com.fivestars.react.geofencemonitor;

import java.util.ArrayList;

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
import com.facebook.react.bridge.ReadableArray;


import android.util.Log;

public class GeofenceMonitor extends ReactContextBaseJavaModule implements ActivityEventListener {

    private GeofenceHandler handler;
    private GeofenceMonitorJsDelivery mJsDelivery;
    private Application applicationContext;
    private ReactApplicationContext reactApplicationContext;

    private ArrayList<GeofenceLocation> locations;

    public GeofenceMonitor(ReactApplicationContext reactContext) {
        super(reactContext);
        reactContext.addActivityEventListener(this);

        applicationContext = (Application) reactContext.getApplicationContext();
        reactApplicationContext = getReactApplicationContext();

        // This is used to delivery callbacks to JS
        mJsDelivery = new GeofenceMonitorJsDelivery(reactContext);

        locations = new ArrayList<>();
    }

    @Override
    public String getName() {
        return "GeofenceMonitor";
    }

    @ReactMethod
    public void init() {
        handler = new GeofenceHandler();
        //Log.e("plucas", "MY ACTIVITY: " + getCurrentActivity().toString());
        handler.init(this.reactApplicationContext, this.applicationContext, this.locations);
    }

    @ReactMethod
    public void addRegion(ReadableArray jsLocation) {
        String geofenceId = jsLocation.getString(0);
        double lat = jsLocation.getDouble(1);
        double lon = jsLocation.getDouble(2);
        float radius = (float) jsLocation.getDouble(3);

        GeofenceLocation location = new GeofenceLocation(geofenceId, lat, lon, radius);

        Log.e("plucas", "[][][] addRegion: " + geofenceId + "; " + lat + "; " + lon + "; " + radius);
        this.locations.add(location);
    }

    @ReactMethod
    public void startLocationUpdates() {
        handler.startLocationUpdates();
    }

    @ReactMethod
    public void stopLocationUpdates() {
        handler.stopLocationUpdates();
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
