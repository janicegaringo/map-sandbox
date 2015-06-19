//
//  Artwork.m
//  MapTutorial
//
//  Created by Janice Garingo on 6/19/15.
//  Copyright (c) 2015 Janice Taylor. All rights reserved.
//

#import "Artwork.h"

@implementation Artwork

- (id)initWithTitle:(NSString *)artTitle locationName:(NSString *)locationName discipline:(NSString *)discipline coordinate:(CLLocationCoordinate2D)coordinate
{
    if(self = [super init]) {
        
        self.artTitle = artTitle;
        self.locationName = locationName;
        self.discipline = discipline;
        self.coordinate = coordinate;
        
    }
    
    return self;
}

- (NSString *)subtitle
{
    return self.locationName;
}

@end
