//
//  GeofenceMonitor.m
//  GeofenceMonitor
//
//  Created by Patrick Lucas on 12/13/16.
//  Copyright © 2016 FiveStars. All rights reserved.
//
#import "RCTLog.h"
#import "RCTBridge.h"
#import "RCTEventDispatcher.h"

#import "GeofenceMonitor.h"

@implementation GeofenceMonitor
RCT_EXPORT_MODULE();

@synthesize bridge = _bridge;


NSMutableArray *regions;
CLLocationManager *_locationManager;
CLCircularRegion *region;


RCT_EXPORT_METHOD(startMonitoring)
{
    RCTLogInfo(@"startMonitoring method called.");
    [self startMonitoringRegions:regions];
}

RCT_EXPORT_METHOD(startLocationUpdates)
{
    RCTLogInfo(@"startLocationUpdates method called.");
    [self initLocationManager];
    //[_locationManager startUpdatingLocation];
}

RCT_EXPORT_METHOD(stopLocationUpdates)
{
    RCTLogInfo(@"stopLocationUpdates method called.");
    [self initLocationManager];
    [_locationManager stopUpdatingLocation];
}

RCT_EXPORT_METHOD(addRegion:(NSString *)regionId lat:(nonnull NSNumber *) lat lon:(nonnull NSNumber *) lon radius:( nonnull NSNumber *) radius)
{
    RCTLogInfo(@"Adding region: %@ ; %@ ; %@; %@", regionId, lat, lon, radius);
    if (!regions) {
        regions = [[NSMutableArray alloc] init];
    }

    CLLocation *coordinate = [[CLLocation alloc] initWithLatitude:[lat doubleValue] longitude:[lon doubleValue]];
    [regions addObject:@{@"regionId": regionId, @"coordinate": coordinate, @"radius": radius}];
}



- (void)startMonitoringRegions:(NSArray *)regions {
    [self initLocationManager];

    for (NSDictionary *region in regions) {
        NSString *regionId = [region objectForKey:@"regionId"];
        CLLocation *coordinate = [region objectForKey:@"coordinate"];
        NSNumber *radius = [region objectForKey:@"radius"];

        CLRegion *clRegion = [[CLCircularRegion alloc] initWithCenter:[coordinate coordinate] radius:[radius doubleValue] identifier:regionId];

        NSLog(@"region: %@", clRegion);

        [_locationManager startMonitoringForRegion:clRegion];
        [_locationManager requestStateForRegion:clRegion];
    }

    NSLog(@"[][] plucas startMonitoring");
    NSLog(@"[][] _locationManager: %@", _locationManager);
}

- (void)initLocationManager {
    if (_locationManager) {
        return;
    }
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;

    [_locationManager requestAlwaysAuthorization];
}

- (void)sendMessage: (NSString *)name body:(id) body {
    [self.bridge.eventDispatcher sendAppEventWithName:name body:body];
}

# pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"[][] plucas: didUpdateLocations: %@", locations);
}
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"[][] plucas: didEnterRegion: %@", region.identifier);
    NSString *type = @"GEOFENCE_TRANSITION_ENTER";
    [self sendMessage:@"geofenceTransition" body:@{@"type": type, @"ids": @[]}];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"[][] plucas: didExitRegion: %@", region.identifier);
    NSString *type = @"GEOFENCE_TRANSITION_EXIT";
    [self sendMessage:@"geofenceTransition" body:@{@"type": type, @"ids": @[]}];
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {

    NSString *type;
    if (state == CLRegionStateInside) {
        NSLog(@"[][] plucas: locationManager didDetermineState INSIDE for %@", region.identifier);
        type = @"GEOFENCE_TRANSITION_ENTER";
    }
    else if (state == CLRegionStateOutside) {
        NSLog(@"[][] plucas: locationManager didDetermineState OUTSIDE for %@", region.identifier);
        type = @"GEOFENCE_TRANSITION_EXIT";
    }
    else {
        NSLog(@"[][] plucas: locationManager didDetermineState OTHER for %@", region.identifier);
        type = @"GEOFENCE_TRANSITION_OTHER";
    }

    //[self sendMessage:@"geofenceTransition" body:@{@"type": type, @"ids": @[]}];
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"[][] plucas: monitoringDidFailForRegion - error: %@", [error localizedDescription]);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"[][] plucas: error: %@", error);
}


- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

@end
