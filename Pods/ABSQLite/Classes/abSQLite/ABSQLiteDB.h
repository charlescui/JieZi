//
//  ABSQLiteDB.h
//  Easy Spend Log
//
//  Created by Aaron Bratcher on 04/18/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABDatabase.h"
#import "ABSQLiteRecordset.h"
#include <sqlite3.h>

@interface ABSQLiteDB : NSObject <ABDatabase> 

@property (assign,readonly) sqlite3* db;

@end
