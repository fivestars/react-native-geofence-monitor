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
NSMutableArray *clRegions;

- (void)dealloc {
    _locationManager.delegate = nil;
    _locationManager = nil;
    regions = nil;
    region = nil;
    clRegions = nil;
}

RCT_EXPORT_METHOD(startMonitoring)
{
    [self startMonitoringRegions:regions];
}

RCT_EXPORT_METHOD(startRanging)
{
    [self initLocationManager];
    [_locationManager startUpdatingLocation];
}

RCT_EXPORT_METHOD(stopRanging)
{
    [self initLocationManager];
    [_locationManager stopUpdatingLocation];
}

RCT_EXPORT_METHOD(addRegion:(NSString *)regionId lat:(nonnull NSNumber *) lat lon:(nonnull NSNumber *) lon radius:( nonnull NSNumber *) radius)
{
    if (!regions) {
        regions = [[NSMutableArray alloc] init];
    }

    CLLocation *coordinate = [[CLLocation alloc] initWithLatitude:[lat doubleValue] longitude:[lon doubleValue]];
    [regions addObject:@{@"regionId": regionId, @"coordinate": coordinate, @"radius": radius}];
}


-(void) requestStateForAllRegions {
    for (CLRegion *clRegion in clRegions) {
        [_locationManager requestStateForRegion:clRegion];
    }
}

- (void)startMonitoringRegions:(NSArray *)regions {
    [self initLocationManager];

    clRegions = [[NSMutableArray alloc] init];
    for (NSDictionary *region in regions) {
        NSString *regionId = [region objectForKey:@"regionId"];
        CLLocation *coordinate = [region objectForKey:@"coordinate"];
        NSNumber *radius = [region objectForKey:@"radius"];

        CLRegion *clRegion = [[CLCircularRegion alloc] initWithCenter:[coordinate coordinate] radius:[radius doubleValue] identifier:regionId];
        [clRegions addObject:clRegion];

        [_locationManager startMonitoringForRegion:clRegion];
        //[_locationManager requestStateForRegion:clRegion];
    }
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
    [self requestStateForAllRegions];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSString *type = @"GEOFENCE_TRANSITION_ENTER";
    [self sendMessage:@"geofenceTransition" body:@{@"type": type, @"regionId": region.identifier}];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSString *type = @"GEOFENCE_TRANSITION_EXIT";
    [self sendMessage:@"geofenceTransition" body:@{@"type": type, @"regionId": region.identifier}];
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {

    NSString *type;
    if (state == CLRegionStateInside) {
        type = @"GEOFENCE_RANGING_INSIDE";
    }
    else if (state == CLRegionStateOutside) {
        type = @"GEOFENCE_RANGING_OUTSIDE";
    }
    else {
        type = @"GEOFENCE_RANGING_OTHER";
    }

    [self sendMessage:@"geofenceRanging" body:@{@"type": type, @"regionId": region.identifier}];
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    [manager requestStateForRegion:region];
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    RCTLogWarn(@"GeofenceMonitor: monitoringDidFailForRegion: %@; %@", region, [error localizedDescription]);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    RCTLogWarn(@"GeofenceMonitor: locationManager didFailWithError: %@;", [error localizedDescription]);
}


- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

@end
