//
//  GeofenceMonitor.h
//  GeofenceMonitor
//
//  Created by Patrick Lucas on 12/13/16.
//  Copyright © 2016 FiveStars. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "RCTBridgeModule.h"


@interface GeofenceMonitor : NSObject <RCTBridgeModule, CLLocationManagerDelegate>

@end
