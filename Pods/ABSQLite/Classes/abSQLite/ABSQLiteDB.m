//
//  ABSQLiteDB.m
//  Easy Spend Log
//
//  Created by Aaron Bratcher on 04/18/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ABSQLiteDB.h"

@interface ABSQLiteDB ()

@property (assign, readwrite) sqlite3 *db;

@end

@implementation ABSQLiteDB {
	int lastErrorCode;
	dispatch_queue_t dbAccessQueue;
}

@synthesize  db;

#define DEG2RAD(degrees) (degrees * 0.01745327) // degrees * pi over 180

static void distanceFunc(sqlite3_context *context, int argc, sqlite3_value **argv) {
	// check that we have four arguments (lat1, lon1, lat2, lon2)
	assert(argc == 4);
	// check that all four arguments are non-null
	if (sqlite3_value_type(argv[0]) == SQLITE_NULL || sqlite3_value_type(argv[1]) == SQLITE_NULL || sqlite3_value_type(argv[2]) == SQLITE_NULL || sqlite3_value_type(argv[3]) == SQLITE_NULL) {
		sqlite3_result_null(context);
		return;
	}
	// get the four argument values
	double lat1 = sqlite3_value_double(argv[0]);
	double lon1 = sqlite3_value_double(argv[1]);
	double lat2 = sqlite3_value_double(argv[2]);
	double lon2 = sqlite3_value_double(argv[3]);
	// convert lat1 and lat2 into radians now, to avoid doing it twice below
	double lat1rad = DEG2RAD(lat1);
	double lat2rad = DEG2RAD(lat2);
	// apply the spherical law of cosines to our latitudes and longitudes, and set the result appropriately
	// 6378.1 is the approximate radius of the earth in kilometres
	sqlite3_result_double(context, acos(sin(lat1rad) * sin(lat2rad) + cos(lat1rad) * cos(lat2rad) * cos(DEG2RAD(lon2) - DEG2RAD(lon1))) * 6378.1);
}

- (id)init {
	self = [super init];
	dbAccessQueue = dispatch_queue_create("com.AaronLBratcher.dbAccessQueue", NULL);
    
	return self;
}

- (void)close {
	sqlite3_close(db);
}

- (BOOL)connect:(NSString *)uri {
	if (db) {
		return YES;
	}
    
	lastErrorCode = sqlite3_open((uri ? [uri fileSystemRepresentation] : ""), &db);
	if (lastErrorCode != SQLITE_OK) {
		NSLog(@"error opening!: %d", lastErrorCode);
		return NO;
	}
    
	lastErrorCode = sqlite3_create_function(db, "distance", 4, SQLITE_UTF8, NULL, &distanceFunc, NULL, NULL);
    
	return YES;
}

- (void)beginTransaction {
	[self sqlExecute:@"BEGIN EXCLUSIVE TRANSACTION;"];
}

- (void)rollback {
	[self sqlExecute:@"ROLLBACK TRANSACTION;"];
}

- (void)commit {
	[self sqlExecute:@"COMMIT TRANSACTION;"];
}

//-(void) explainCommand:(NSString*) command {
//	return;
//
//	char *zExplain;                 /* SQL with EXPLAIN QUERY PLAN prepended */
//	sqlite3_stmt *pExplain;         /* Compiled EXPLAIN QUERY PLAN command */
//	int rc;                         /* Return code from sqlite3_prepare_v2() */
//
//	zExplain = sqlite3_mprintf("EXPLAIN QUERY PLAN %s", [command UTF8String]);
//
//	rc = sqlite3_prepare_v2(db, zExplain, -1, &pExplain, 0);
//	sqlite3_free(zExplain);
//	NSLog(@"\n\n.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  \nQuery:%@\n\nAnalysis:\n",command);
//
//	while( SQLITE_ROW==sqlite3_step(pExplain) ){
//		int iSelectid = sqlite3_column_int(pExplain, 0);
//		int iOrder = sqlite3_column_int(pExplain, 1);
//		int iFrom = sqlite3_column_int(pExplain, 2);
//		const char *zDetail = (const char *)sqlite3_column_text(pExplain, 3);
//
//		NSLog(@"%d %d %d %s\n=================================================\n\n",iSelectid, iOrder, iFrom, zDetail);
//	}
//}


- (void)sqlExecute:(NSString *)command {
	dispatch_sync(dbAccessQueue, ^{
        //		[self explainCommand:command];
        
	    sqlite3_stmt *dbps; // database prepared statement
	    sqlite3_busy_timeout(db, 10000);
        
	    // execute the command
	    const char *sql = [command UTF8String];
	    lastErrorCode = sqlite3_prepare_v2(db, sql, -1, &dbps, NULL);
	    if (lastErrorCode && lastErrorCode < 100) {
	        NSString *errorMessage = [[NSString alloc] initWithUTF8String:sqlite3_errmsg(db)];
	        [self logEvent:[NSString stringWithFormat:@"!!!! SELECT PREP ERROR (%@) !!!!  SQL:%@", errorMessage, command]];
		}
        
	    lastErrorCode = sqlite3_step(dbps);
	    if (lastErrorCode && lastErrorCode < 100) {
	        NSString *errorMessage = [[NSString alloc] initWithUTF8String:sqlite3_errmsg(db)];
	        [self logEvent:[NSString stringWithFormat:@"!!!! SELECT PREP ERROR (%@) !!!!  SQL:%@", errorMessage, command]];
		}
        
	    sqlite3_finalize(dbps);
	});
}

- (id <ABRecordset> )sqlSelect:(NSString *)command {
	return [self sqlSelect:command isForwardOnly:YES];
}

- (id <ABRecordset> )sqlSelect:(NSString *)command isForwardOnly:(BOOL)isForwardOnly {
	__block ABSQLiteRecordset *results;
	dispatch_sync(dbAccessQueue, ^{
        //		[self explainCommand:command];
        
	    sqlite3_stmt *dbps; // database prepared statement
        
	    const char *sql = [command UTF8String];
	    lastErrorCode = sqlite3_prepare_v2(db, sql, -1, &dbps, NULL);
        
	    if (lastErrorCode && lastErrorCode < 100) {
	        NSString *errorMessage = [[NSString alloc] initWithUTF8String:sqlite3_errmsg(db)];
	        [self logEvent:[NSString stringWithFormat:@"!!!! SELECT PREP ERROR (%@) !!!!  SQL:%@", errorMessage, command]];
		}
	    results = [[ABSQLiteRecordset alloc] initWithSQLitePreparedStatement:dbps db:db dispatchQueue:dbAccessQueue isForwardOnly:isForwardOnly];
	});
    
	[results moveNext];
	return results;
}

- (id <ABRecordset> )tableSchema {
	return [self sqlSelect:@"SELECT * FROM sqlite_master WHERE type='table'"];
}

- (id <ABRecordset> )fieldSchemaWithTableName:(NSString *)tableName {
	return [self sqlSelect:[NSString stringWithFormat:@"PRAGMA table_info(%@)]", tableName]];
}

- (long long)lastIdentity {
	return sqlite3_last_insert_rowid(db);
}

- (void)logEvent:(NSString *)eventText {
    //	NSLog(eventText);
}

- (int)lastErrorCode {
	return lastErrorCode;
}

- (int)freeMemory {
	return sqlite3_release_memory(10000);
}

@end
