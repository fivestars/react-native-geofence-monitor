package com.fivestars.react.geofencemonitor;

import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import android.util.Log;

public class GeofenceMonitor extends ReactContextBaseJavaModule {

    public GeofenceMonitor(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "ToastAndroid";
    }

    @ReactMethod
    public void addRegion(double lat, double lon, double radius) {
        Log.e("plucas", "[][][] addRegion" + lat + " " + lon + " " + radius);
    }
}
