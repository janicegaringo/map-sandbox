//
//  Artwork.m
//  MapTutorial
//
//  Created by Janice Taylor on 6/19/15.
//  Copyright (c) 2015 Janice Taylor. All rights reserved.
//

#import "Artwork.h"

@implementation Artwork

- (id)initWithTitle:(NSString *)title locationName:(NSString *)locationName discipline:(NSString *)discipline coordinate:(CLLocationCoordinate2D)coordinate
{
    if(self = [super init]) {
        
        if ([title isKindOfClass:[NSNull class]])
            self.title = @"";
        else
            self.title = title;

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
