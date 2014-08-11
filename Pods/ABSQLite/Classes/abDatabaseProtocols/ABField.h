//
//  ABField.h
//  Easy Spend Log
//
//  Created by Aaron Bratcher on 04/18/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ABField <NSObject>

- (NSString*) name;
- (BOOL) isNull;
- (BOOL) booleanValue;
- (NSString*) stringValue;
- (NSDate*) dateValue;
- (int) intValue;
- (double) doubleValue;
- (long long int) longLongValue;
- (NSData*) rawValue;

@end
