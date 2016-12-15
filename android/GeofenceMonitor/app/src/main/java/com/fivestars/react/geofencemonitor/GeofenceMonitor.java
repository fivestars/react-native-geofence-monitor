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
    public void startMonitoring() {
        handler = new GeofenceHandler();
        //Log.e("plucas", "MY ACTIVITY: " + getCurrentActivity().toString());
        handler.init(this.reactApplicationContext, this.applicationContext, this.locations);
    }

    @ReactMethod
    public void addRegion(String regionId, double lat, double lon, float radius) {
        GeofenceLocation location = new GeofenceLocation(regionId, lat, lon, radius);

        Log.e("plucas", "[][][] addRegion: " + regionId + "; " + lat + "; " + lon + "; " + radius);
        this.locations.add(location);
    }

    @ReactMethod
    public void startRanging() {
        handler.startLocationUpdates();
    }

    @ReactMethod
    public void stopRanging() {
        handler.stopLocationUpdates();
    }

    public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
        Log.e("plucas", "[]][] onActivityResult!");
    }

    public void onNewIntent(Intent intent) {
        Log.e("plucas", "[]][] onNewIntent");
    }
}
