//
//  GeofenceHandler.m
//  GeofenceMonitor
//
//  Created by Patrick Lucas on 12/13/16.
//  Copyright © 2016 FiveStars. All rights reserved.
//

#import "GeofenceHandler.h"

@implementation GeofenceHandler {
    CLLocationManager *_locationManager;
    CLCircularRegion *region;
}

- (void)startMonitoringRegions:(NSArray *)regions {
    [self initLocationManager];
    [_locationManager requestLocation];

    for (NSDictionary *region in regions) {
        NSString *regionId = [region objectForKey:@"regionId"];
        CLLocation *coordinate = [region objectForKey:@"coordinate"];
        NSNumber *radius = [region objectForKey:@"radius"];

        CLRegion *clRegion = [[CLCircularRegion alloc] initWithCenter:[coordinate coordinate] radius:[radius doubleValue] identifier:regionId];

        [_locationManager requestStateForRegion:region];
        [_locationManager startMonitoringForRegion:clRegion];
        [_locationManager requestStateForRegion:region];
    }

    NSLog(@"[][] plucas startMonitoring");
    NSLog(@"[][] _locationManager: %@", _locationManager);
}

- (void)startLocationUpdates {
    [self initLocationManager];
    [_locationManager startUpdatingLocation];
}

- (void)stopLocationUpdates {
    [self initLocationManager];
    [_locationManager stopUpdatingLocation];
}

- (void)initLocationManager {
    if (_locationManager) {
        return;
    }
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;

    [_locationManager requestAlwaysAuthorization];
}


# pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"[][] plucas: didUpdateLocations: %@", locations);
}
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"[][] plucas: didEnterRegion: %@", region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"[][] plucas: didExitRegion: %@", region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    if (state == CLRegionStateInside) {
        NSLog(@"[][] plucas: locationManager didDetermineState INSIDE for %@", region.identifier);
    }
    else if (state == CLRegionStateOutside) {
        NSLog(@"[][] plucas: locationManager didDetermineState OUTSIDE for %@", region.identifier);
    }
    else {
        NSLog(@"[][] plucas: locationManager didDetermineState OTHER for %@", region.identifier);
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"[][] plucas: monitoringDidFailForRegion - error: %@", [error localizedDescription]);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"[][] plucas: error: %@", error);
}


@end
