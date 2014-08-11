//
//  ABDatabase.h
//  Easy Spend Log
//
//  Created by Aaron Bratcher on 04/18/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABRecordset.h"
#import "ABField.h"


@protocol ABDatabase <NSObject>

- (void) close;
- (void) beginTransaction;
- (void) commit;
- (BOOL) connect:(NSString*) uri;
- (void) rollback;
- (void) sqlExecute:(NSString*) command;
- (id<ABRecordset>) sqlSelect:(NSString*) command;
- (id<ABRecordset>) sqlSelect:(NSString*) command isForwardOnly: (BOOL) isForwardOnly;
- (id<ABRecordset>) tableSchema;
- (id<ABRecordset>) fieldSchemaWithTableName: (NSString*) tableName;
- (long long) lastIdentity;
- (int) lastErrorCode;
- (int) freeMemory;

@end

// Any errors throw an exception with the errorID and message