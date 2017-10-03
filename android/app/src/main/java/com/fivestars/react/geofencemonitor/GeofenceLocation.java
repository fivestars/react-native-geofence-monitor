package com.fivestars.react.geofencemonitor;

/**
 * Created by plucas on 12/9/16.
 */

public class GeofenceLocation {
    public String id;
    public double lat;
    public double lon;
    public float radius;

    public GeofenceLocation(String id, double lat, double lon, float radius) {
        this.id = id;
        this.lat = lat;
        this.lon = lon;
        this.radius = radius;
    }
}
