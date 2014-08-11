//
//  ABRecordset.h
//  Easy Spend Log
//
//  Created by Aaron Bratcher on 04/18/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABField.h"


@protocol ABRecordset <NSObject>

- (BOOL) bof;
- (void) close;
- (BOOL) eof;
- (int) fieldCount;
- (id<ABField>) fieldWithName:(NSString*)fieldName;
- (id<ABField>) fieldAtIndex: (int) index;
- (void) moveFirst;
- (void) moveLast;
- (void) moveNext;
- (void) movePrevious;
- (int) recordCount;

@end