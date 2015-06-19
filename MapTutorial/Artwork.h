//
//  Artwork.h
//  MapTutorial
//
//  Created by Janice Garingo on 6/19/15.
//  Copyright (c) 2015 Janice Taylor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>

@interface Artwork : NSObject <MKAnnotation>

@property (nonatomic) NSString *artTitle;
@property (nonatomic) NSString *locationName;
@property (nonatomic) NSString *discipline;
@property (nonatomic) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString *)artTitle locationName:(NSString *)locationName discipline:(NSString *)discipline coordinate:(CLLocationCoordinate2D)coordinate;

- (NSString *)subtitle;

@end
