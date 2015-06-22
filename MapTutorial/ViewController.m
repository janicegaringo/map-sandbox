//
//  ViewController.m
//  MapTutorial
//
//  Created by Janice Taylor on 6/18/15.
//  Copyright (c) 2015 Janice Taylor. All rights reserved.
//

#import "ViewController.h"
#import "Artwork.h"
#import <Foundation/NSJSONSerialization.h>

@interface ViewController ()

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define METERS_PER_MILE 1609.344
#define kbackgroundQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) NSMutableArray *artworkArray;

- (IBAction)plotPoints:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.artworkArray = [@[] mutableCopy];
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    // set initial location in Honolulu
    CLLocationCoordinate2D initialLocation = CLLocationCoordinate2DMake(21.282778, -157.829444);
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(initialLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    [self.mapView setRegion:viewRegion];
    
    
    CLLocationCoordinate2D artLocation = CLLocationCoordinate2DMake(21.283921, -157.831661);

    Artwork *artwork = [[Artwork alloc] initWithTitle:@"King David Kalakaua" locationName:@"Waikiki Gateway Park" discipline:@"Sculpture" coordinate:artLocation];
    
    [self.mapView addAnnotation:artwork];
    
    [self parseJsonFromFile]; 
    
}


- (void)parseJsonFromFile
{
    // NSJsonSerializer
    
    dispatch_async(kbackgroundQueue, ^{
         NSURL *url = [NSURL URLWithString:@"http://www.meladori.com/maptest/PublicArt.json"];
        
         NSData *data = [NSData dataWithContentsOfURL:url];
        
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];

    });
    
}


- (void)fetchedData:(NSData *)responseData
{
    NSError *error;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
        
    NSArray *data = [json objectForKey:@"data"];
    
    for(id row in data) {
        
        NSNumber *latitude = [row objectAtIndex:18];
        NSNumber *longtitude = [row objectAtIndex:19];
        NSString *locationName = [row objectAtIndex:12];
        NSString *title = [row objectAtIndex:16];
        NSString *discipline = [row objectAtIndex:15];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([latitude doubleValue], [longtitude doubleValue]);
        
        Artwork *artwork = [self artworkWithTitle:title locationName:locationName discipline:discipline coordinate:coordinate];
        
        [self.artworkArray addObject:artwork];

    }
    
    // NSLog(@"self.artworkArray : %@", self.artworkArray);
    
}


- (Artwork *)artworkWithTitle:(NSString *)title locationName:(NSString *)locationName discipline:(NSString *)discipline coordinate:(CLLocationCoordinate2D)coordinate
{
    Artwork *artwork = [[Artwork alloc] initWithTitle:title locationName:locationName discipline:discipline coordinate:coordinate];
    
    return artwork;
}


- (IBAction)plotPoints:(id)sender
{
    [self.mapView addAnnotations:self.artworkArray];
}


#pragma mark - MapKit delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *identifier = @"Artwork";
    
    if([annotation isKindOfClass:[Artwork class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if(annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.calloutOffset = CGPointMake(-5, 5);
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
        
        }
        else {
            annotationView.annotation = annotation;
        }
    
        return annotationView;
        
    }
    
     return nil;
}

@end
