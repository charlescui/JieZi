//
//  ABSQLiteField.h
//  Easy Spend Log
//
//  Created by Aaron Bratcher on 04/25/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "ABField.h"
#include <sqlite3.h>


@interface ABSQLiteField : NSObject<ABField> {
    sqlite3_stmt *dbps;
	NSString *name;
	int fieldIndex;
}

- (id) initWithSQLitePreparedStatement: (sqlite3_stmt *) initial_dbps withName: (NSString*) initial_name dispatchQueue:(dispatch_queue_t) dispatchQueue withfieldIndex: (int) initial_fieldIndex;
@end
