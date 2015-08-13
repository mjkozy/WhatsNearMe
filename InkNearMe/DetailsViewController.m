//
//  DetailsViewController.m
//  InkNearMe
//
//  Created by Michael Kozy on 8/5/15.
//  Copyright (c) 2015 Michael Kozy. All rights reserved.
//
#import "WebViewController.h"
#import "DetailsViewController.h"
#import "MainViewController.h"
#import <UIKit/UIKit.h>

@interface DetailsViewController ()<UITextViewDelegate,MKMapViewDelegate>

@property (nonatomic, retain) MKPolyline *routeLine;
@property (nonatomic, retain) MKPolylineView *routeLineView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property CLPlacemark *thePlacemark;
@property MKPointAnnotation *annotation;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setPolyLine];
    self.mapView.delegate = self;
    self.mapView.zoomEnabled = YES;
    self.title = self.inkPlace.mapItem.name;
    [self getPathDirections:self.currentLocation.coordinate withDestination:self.inkPlace.mapItem.placemark.location.coordinate];
    self.mapView.showsUserLocation = YES;
    [self zoomToCurrentLocation];




}

- (void)getPathDirections:(CLLocationCoordinate2D)source withDestination:(CLLocationCoordinate2D)destination {
    //pull directions, list out via auto, display annotation and overlay to selected location
    MKPlacemark *placemarkSource = [[MKPlacemark alloc] initWithCoordinate:source addressDictionary:nil];
    MKMapItem *mapItemSource = [[MKMapItem alloc] initWithPlacemark:placemarkSource];
    MKPlacemark *placemarkDestination = [[MKPlacemark alloc] initWithCoordinate:destination addressDictionary:nil];
    MKMapItem *mapItemDestination = [[MKMapItem alloc] initWithPlacemark:placemarkDestination];

    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    [request setSource:mapItemSource];
    [request setDestination:mapItemDestination];
    [request setTransportType:MKDirectionsTransportTypeAutomobile];
    request.requestsAlternateRoutes = NO;

    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];

    MKPointAnnotation *annotate = [MKPointAnnotation new];
    annotate.coordinate = destination;
    [self.mapView addAnnotation:annotate];

    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        MKRoute *route = response.routes.lastObject;
        //array init loop through stored directions and finally display in textview
        NSString *allSteps = [NSString new];
        for (int i = 0; i < route.steps.count; i++) {
            MKRouteStep *step = [route.steps objectAtIndex:i];
            NSString *newString = step.instructions;
            allSteps = [allSteps stringByAppendingString:newString];
            allSteps = [allSteps stringByAppendingString:@"\n\n"];
        }
        for (MKRoute *route in response.routes) {
            [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        }
        self.textView.text = allSteps;
    }];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer *render = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    render.strokeColor = [UIColor blueColor];
    render.lineWidth = 5.0;
    return render;
}

- (void)zoomToCurrentLocation {
    float spanX = 0.00725;
    float spanY = 0.00725;
    MKCoordinateRegion region;
    region.center.latitude = self.currentLocation.coordinate.latitude;
    region.center.longitude = self.currentLocation.coordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    [self.mapView setRegion:region animated:YES];
}

#pragma mark Mapview Delegate Method

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {

    MKPinAnnotationView *callOut = [MKPinAnnotationView new];
    callOut.canShowCallout = YES;
    callOut.animatesDrop = YES;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    callOut.rightCalloutAccessoryView = button;
    return callOut;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {

    return self.routeLineView;
}

- (void)setPolyLine {
    //remove previous
    [self.mapView removeOverlay:self.routeLine];
    //create an array of coordinates of all pins
    CLLocationCoordinate2D coordinate[self.allPins.count];
    int i = 0;
    for(MKPointAnnotation *currentPin in self.allPins) {
        coordinate[i] = currentPin.coordinate;
        i++;
        [self.mapView reloadInputViews];
        NSLog(@" %@", currentPin);
    }
    //create a polyline with all coordinates
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinate count:self.allPins.count];
    [self.mapView addOverlay:polyLine];
    self.routeLine = polyLine;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"wikiSegue"]){
    WebViewController *webView = [segue destinationViewController];
//        webView.urlString = [NSString stringWithFormat:@"http://www.%@.com", self.selected.mapItem.name];
        webView.urlString = @"http://www.nfl.com"; //tempory url
    }
}

- (IBAction)unwindToDetails:(UIStoryboardSegue *)segue {
    //unwind to detail view controller
    WebViewController *webVC = segue.destinationViewController;
    webVC = segue.destinationViewController;
    NSLog(@"Unwound");
}


@end
