package com.fivestars.react.geofencemonitor;

import android.os.Build;
import android.os.Bundle;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Set;

public class GeofenceMonitorJsDelivery {
    private ReactApplicationContext mReactContext;

    public GeofenceMonitorJsDelivery(ReactApplicationContext reactContext) {
        mReactContext = reactContext;
    }

    void sendEvent(String eventName, Bundle bundle) {
        if (mReactContext.hasActiveCatalystInstance()) {
            String bundleString = convertJSON(bundle);
            WritableMap params = Arguments.createMap();
            params.putString("dataJSON", bundleString);

            mReactContext
                    .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                    .emit(eventName, params);
        }
    }

    void sendGeofenceTransition(Bundle bundle) {
        String bundleString = convertJSON(bundle);

        sendEvent("geofenceTransition", bundle);
    }

    void sendLocationUpdate(Bundle bundle) {
        String bundleString = convertJSON(bundle);

        WritableMap params = Arguments.createMap();
        params.putString("dataJSON", bundleString);

        sendEvent("locationUpdate", bundle);
    }

    String convertJSON(Bundle bundle) {
        JSONObject json = new JSONObject();
        Set<String> keys = bundle.keySet();
        for (String key : keys) {
            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                    json.put(key, JSONObject.wrap(bundle.get(key)));
                } else {
                    json.put(key, bundle.get(key));
                }
            } catch (JSONException e) {
                return null;
            }
        }
        return json.toString();
    }

}