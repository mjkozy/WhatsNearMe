//
//  ViewController.h
//  InkNearMe
//
//  Created by Michael Kozy on 8/5/15.
//  Copyright (c) 2015 Michael Kozy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailsViewController.h"

@interface MainViewController : UIViewController
@property MKPointAnnotation *annotation;
@property (strong,nonatomic) NSArray *inkSpots;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;


@end

