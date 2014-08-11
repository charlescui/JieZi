//
//  ABSQLiteRecordset.h
//  Easy Spend Log
//
//  Created by Aaron Bratcher on 04/25/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABSQLiteField.h"
#import "ABRecordset.h"
#include <sqlite3.h>

@interface ABSQLiteRecordset : NSObject<ABRecordset>

- (id) initWithSQLitePreparedStatement: (sqlite3_stmt *) initial_dbps db: (sqlite3*) db dispatchQueue:(dispatch_queue_t) dispatchQueue isForwardOnly: (BOOL) isForwardOnly;

@end
