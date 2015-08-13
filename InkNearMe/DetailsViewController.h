//
//  DetailsViewController.h
//  InkNearMe
//
//  Created by Michael Kozy on 8/5/15.
//  Copyright (c) 2015 Michael Kozy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Places.h"

@interface DetailsViewController : UIViewController 
@property Places *inkPlace;
@property CLLocation *currentLocation;
@property Places *selected;
@property MKMapItem *mapItem;
@property (strong, nonatomic) NSMutableArray *allPins;
@property (strong,nonatomic) NSMutableArray *mapPins;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@end
