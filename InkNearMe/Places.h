//
//  InkPlaces.h
//  InkNearMe
//
//  Created by Michael Kozy on 8/5/15.
//  Copyright (c) 2015 Michael Kozy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Places : NSObject

@property MKMapItem *mapItem;
@property float milesDifference;
@end
