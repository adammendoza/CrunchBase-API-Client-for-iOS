//
//  ViewController.m
//  CrunchBaseClientDemo
//
//  Created by shuichi on 9/7/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import "ViewController.h"
#import "CrunchBaseClient.h"
#import "SVProgressHUD.h"
#import <CoreLocation/CoreLocation.h>


#define kCompanyName @"appsocially"
#define kStateName   @"CA"
#define kRadiusForNearby 50.0


@interface ViewController ()
<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, weak) IBOutlet UITextView *resultTextView;
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// =============================================================================
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"location:%@", newLocation);
    
    [self.locationManager stopUpdatingLocation];
    
    [CrunchBaseClient searchByLocation:newLocation
                         radiusInMiles:kRadiusForNearby
                               handler:
     ^(NSDictionary *result, NSError *error) {
         
         if (error) {
             
             self.resultTextView.text = error.localizedDescription;

             [SVProgressHUD showErrorWithStatus:error.localizedDescription];
         }
         else if (!result) {
             
             [SVProgressHUD showErrorWithStatus:@"Failed. See logs."];
         }
         else {
             
             self.resultTextView.text = result.description;
             NSLog(@"result:%@", result);
             [SVProgressHUD showSuccessWithStatus:@"Succeeded!"];
         }
     }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
}


// =============================================================================
#pragma mark Private


// =============================================================================
#pragma mark - IBAction

/**
 sample for retrieving a specific company's information
 */
- (IBAction)retrieveCompanyInfo {
    
    [SVProgressHUD showWithStatus:@"Loading..."
                         maskType:SVProgressHUDMaskTypeGradient];

    self.resultTextView.text = nil;
    
    [CrunchBaseClient companyWithName:kCompanyName
                              handler:
     ^(NSDictionary *result, NSError *error) {
         
         if (error) {

             self.resultTextView.text = error.localizedDescription;

             [SVProgressHUD showErrorWithStatus:error.localizedDescription];
         }
         else {

             self.resultTextView.text = result.description;
             
             [SVProgressHUD showSuccessWithStatus:@"Succeeded!"];
         }
     }];
}

- (IBAction)retrievePersonsInfo {

    [SVProgressHUD showWithStatus:@"Loading..."
                         maskType:SVProgressHUDMaskTypeGradient];
    
    self.resultTextView.text = nil;

    [CrunchBaseClient personsWithCompanyName:kCompanyName
                                     handler:
     ^(NSArray *result, NSError *error) {
         
         if (error) {
             
             self.resultTextView.text = error.localizedDescription;
             
             [SVProgressHUD showErrorWithStatus:error.localizedDescription];
         }
         else {

             NSLog(@"result:%@", result);

             self.resultTextView.text = result.description;             
             
             [SVProgressHUD showSuccessWithStatus:@"Succeeded!"];
         }
     }];
}

- (IBAction)searchNearby {

    self.locationManager = [[CLLocationManager alloc] init];
    
    if ([CLLocationManager locationServicesEnabled]) {

        [SVProgressHUD showWithStatus:@"Loading..."
                             maskType:SVProgressHUDMaskTypeGradient];
        
        self.resultTextView.text = nil;

        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
    }
}

- (IBAction)searchByState
{
    [SVProgressHUD showWithStatus:@"Loading..."
                         maskType:SVProgressHUDMaskTypeGradient];
    
    self.resultTextView.text = nil;
    
    [CrunchBaseClient searchByState:kStateName
                              handler:
     ^(NSDictionary *result, NSError *error) {
         
         if (error) {
             
             self.resultTextView.text = error.localizedDescription;
             
             [SVProgressHUD showErrorWithStatus:error.localizedDescription];
         }
         else {
             
             self.resultTextView.text = result.description;

             NSLog(@"result:%@", result);

             [SVProgressHUD showSuccessWithStatus:@"Succeeded!"];
         }
     }];
}

@end
