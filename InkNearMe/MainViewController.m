//
//  ViewController.m
//  InkNearMe
//
//  Created by Michael Kozy on 8/5/15.
//  Copyright (c) 2015 Michael Kozy. All rights reserved.
//

#import "MainViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "Places.h"
#import "DetailsViewController.h"

@interface MainViewController ()<CLLocationManagerDelegate, UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property
CLLocationManager *locationManager;
@property CLLocation *currentLocation;
@property (strong, nonatomic) NSMutableArray *destinationURL;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"WhatsNearMe";
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self updateCurrentLocation];
    [self.searchTextField resignFirstResponder];

}

- (IBAction)searchButtonTapped:(id)sender {

    [self findLocations:self.currentLocation];
    [self.searchButton resignFirstResponder];
    [self validateTextField];

}

- (void)updateCurrentLocation {
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (void)validateTextField {
    //handle empty textfield search error
    NSString *emptyField = self.searchTextField.text;
    BOOL error = NO;

    if (emptyField == 0) {
        error = YES;
    }
    if (error) {
        [[[UIAlertView alloc] initWithTitle:@"No Locations Found"
                                    message:@"Please enter new search"
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (void)findLocations:(CLLocation *)location {
    //querry based on user , sets user region, init search mutable array to hold results and display to user in tableview.
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
        request.naturalLanguageQuery = self.searchTextField.text;
        request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(3.0, 3.0));

    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
        [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
    NSArray *mapItems = response.mapItems;
    NSMutableArray *tempArray = [NSMutableArray new];
    //iterate through array of 10 locations within a 2 mile radius.
        for(int i = 0; i < 6; i++)
        {
            MKMapItem *mapItem = [mapItems objectAtIndex:i];
            CLLocationDistance metersFrom = [mapItem.placemark.location distanceFromLocation:location];
            float milesDifference = metersFrom / 3218.68;
            //alloc and init with *places being added to array
            Places *places = [Places new];
                places.mapItem = mapItem;
                places.milesDifference = milesDifference;
                [tempArray addObject:places];
}
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"milesDifference" ascending:true];
        NSArray *sorted = [tempArray sortedArrayUsingDescriptors:@[sortDescriptor]];
        self.inkSpots = [NSArray arrayWithArray:sorted];
        {
            [self.myTableView reloadData];
        }

    }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

        self.currentLocation = locations.firstObject;
        //NSLog(@" %@", self.currentLocation);
        [self.locationManager stopUpdatingLocation];
        [self findLocations:self.currentLocation];
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {

    [self performSegueWithIdentifier:@"detailSegue" sender:view];
}

#pragma mark TableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.inkSpots.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inkCell"];
    cell.textLabel.text = [[[self.inkSpots objectAtIndex:indexPath.row]mapItem]name];
    cell.detailTextLabel.text = @"Get Route";

    return cell;
}

#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"detailSegue"])
    {
    DetailsViewController *detailVC = [segue destinationViewController];
        detailVC.inkPlace = [self.inkSpots objectAtIndex:self.myTableView.indexPathForSelectedRow.row];
        detailVC.currentLocation = self.currentLocation;

    }
}

- (IBAction)unwindToMain:(UIStoryboardSegue *)segue {
//unwind segue to Main
}
@end
