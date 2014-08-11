//
//  CLLocationManager+Block.m
//  iOS Blocks
//
//  Created by Ignacio Romero Zurbuchen on 3/8/13.
//  Copyright (c) 2011 DZN Labs.
//  Licence: MIT-Licence
//

#import "CLLocationManager+Block.h"

static ListBlock _locationBlock;
static FailureBlock _failureBlock;
static StatusBlock _statusBlock;

static CLLocationManager *_sharedManager = nil;

@implementation CLLocationManager (Block)

+ (CLLocationManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[CLLocationManager alloc] init];
    });
    
    return _sharedManager;
}

- (void)updateLocationWithDistanceFilter:(CLLocationDistance)filter
                      andDesiredAccuracy:(CLLocationAccuracy)accuracy
            didChangeAuthorizationStatus:(StatusBlock)changedStatus
                      didUpdateLocations:(ListBlock)located
                        didFailWithError:(FailureBlock)failed
{
    _statusBlock = [changedStatus copy];
    _locationBlock = [located copy];
    _failureBlock = [failed copy];
    
    [[CLLocationManager sharedManager] setDelegate:weakObject(self)];
    [[CLLocationManager sharedManager] setDistanceFilter:filter];
    [[CLLocationManager sharedManager] setDesiredAccuracy:accuracy];
    [[CLLocationManager sharedManager] startUpdatingLocation];
}

- (void)updateLocationWithDistanceFilter:(CLLocationDistance)filter
                      andDesiredAccuracy:(CLLocationAccuracy)accuracy
                      didUpdateLocations:(ListBlock)located
                        didFailWithError:(FailureBlock)failed
{
    [[CLLocationManager sharedManager] updateLocationWithDistanceFilter:filter
                                     andDesiredAccuracy:accuracy
                           didChangeAuthorizationStatus:NULL
                                     didUpdateLocations:located
                                       didFailWithError:failed];
}

- (void)locationManagerDidUpdateLocations:(ListBlock)located
                         didFailWithError:(FailureBlock)failed
{
    [[CLLocationManager sharedManager] updateLocationWithDistanceFilter:1.0
                                     andDesiredAccuracy:kCLLocationAccuracyBest
                           didChangeAuthorizationStatus:NULL
                                     didUpdateLocations:located
                                       didFailWithError:failed];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [[CLLocationManager sharedManager] stopUpdatingLocation];
    
    if (_locationBlock) {
        _locationBlock(locations);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [[CLLocationManager sharedManager] stopUpdatingLocation];
    
    if (_failureBlock) {
        _failureBlock(error);
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (_statusBlock) {
        _statusBlock(status);
    }
}

@end
