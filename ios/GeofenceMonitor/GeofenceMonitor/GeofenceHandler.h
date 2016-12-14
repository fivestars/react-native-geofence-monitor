//
//  GeofenceHandler.h
//  GeofenceMonitor
//
//  Created by Patrick Lucas on 12/13/16.
//  Copyright © 2016 FiveStars. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface GeofenceHandler : NSObject <CLLocationManagerDelegate>
- (id)initWithBridge:(id)bridge;
- (void)startMonitoringRegions:(NSArray *)regions;
- (void)startLocationUpdates;
- (void)stopLocationUpdates;
@end
