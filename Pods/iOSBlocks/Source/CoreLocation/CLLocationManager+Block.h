//
//  CLLocationManager+Block.h
//  iOS Blocks
//
//  Created by Ignacio Romero Zurbuchen on 3/8/13.
//  Copyright (c) 2011 DZN Labs.
//  Licence: MIT-Licence
//

#import <CoreLocation/CoreLocation.h>
#import "iOSBlocksProtocol.h"

/*
 * CoreLocation Manager Delegate block methods.
 */
@interface CLLocationManager (Block) <CLLocationManagerDelegate, iOSBlocksProtocol>

/*
 * Returns the singleton app instance.
 * @returns The location manager instance.
 */
+ (CLLocationManager *)sharedManager;

/*
 * Updates the user location with status change updates, location update and failure notification.
 *
 * @param filter The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
 * @param accuracy The accuracy of the location data.
 * @param status A block object to be executed when the authorization status for the application changed. Returns a new authorization status for the application.
* @param located A block object to be executed when new location data is available. Returns an array of CLLocation objects containing the location data. This array always contains at least one object representing the current location.
 * @param failed A block object to be executed when the location manager was unable to retrieve a location value. Returns the error object containing the reason the location or heading could not be retrieved.
 */
- (void)updateLocationWithDistanceFilter:(CLLocationDistance)filter
                      andDesiredAccuracy:(CLLocationAccuracy)accuracy
            didChangeAuthorizationStatus:(StatusBlock)changedStatus
                      didUpdateLocations:(ListBlock)located
                        didFailWithError:(FailureBlock)failed;

/*
 * Updates the user location with location update and failure notification.
 *
 * @param filter The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
 * @param accuracy The accuracy of the location data.
 * @param status A block object to be executed when the authorization status for the application changed. Returns a new authorization status for the application.
 * @param located A block object to be executed when new location data is available. Returns an array of CLLocation objects containing the location data. This array always contains at least one object representing the current location.
 * @param failed A block object to be executed when the location manager was unable to retrieve a location value. Returns the error object containing the reason the location or heading could not be retrieved.
 */
- (void)updateLocationWithDistanceFilter:(CLLocationDistance)filter
                      andDesiredAccuracy:(CLLocationAccuracy)accuracy
                      didUpdateLocations:(ListBlock)located
                        didFailWithError:(FailureBlock)failed;

/*
 * Shorter method for updating the user location, similar to updateLocationWithDistanceFilter:andDesiredAccuracy:didUpdateLocations:didFailWithError: with a standard location filter and accuracy setup.
 *
 * @param located A block object to be executed when new location data is available. Returns an array of CLLocation objects containing the location data. This array always contains at least one object representing the current location.
 * @param failed A block object to be executed when the location manager was unable to retrieve a location value. Returns the error object containing the reason the location or heading could not be retrieved.
 */
- (void)locationManagerDidUpdateLocations:(ListBlock)located
                        didFailWithError:(FailureBlock)failed;

@end
