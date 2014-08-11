//
//  ABSQLiteRecordset.m
//  Easy Spend Log
//
//  Created by Aaron Bratcher on 04/25/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ABSQLiteRecordset.h"


@implementation ABSQLiteRecordset {
	int _fieldCount;
	int _recordCount;
	int recordNumber;
	BOOL eof;
	BOOL closed;
	sqlite3_stmt *dbps;
	sqlite3* db;
	dispatch_queue_t dbAccessQueue;
	
	BOOL columnNamesSetup;
	NSMutableDictionary *columnNameToIndexMap;
}


- (id) init {
	self = [super init];
	return self;
}


- (id) initWithSQLitePreparedStatement: (sqlite3_stmt *) initial_dbps db: (sqlite3*) initial_db  dispatchQueue:(dispatch_queue_t) dispatchQueue isForwardOnly:(BOOL) isForwardOnly {
	self = [super init];
	db = initial_db;
	dbps = initial_dbps;
	dbAccessQueue = dispatchQueue;
	closed = NO;
	_recordCount = 0;
	recordNumber = 0;
	columnNamesSetup = NO;
	[self setupColumnNames];
	
	return self;
}

- (void) dealloc {
	[self close];
}

- (void)setupColumnNames {
	if (!columnNameToIndexMap) {
		columnNameToIndexMap =[NSMutableDictionary dictionary];
	}
	
	_fieldCount = sqlite3_column_count(dbps);
	
	int columnIdx = 0;
	for (columnIdx = 0; columnIdx < _fieldCount; columnIdx++) {
		columnNameToIndexMap[[@(sqlite3_column_name(dbps, columnIdx)) lowercaseString]] = @(columnIdx);
	}
	
	columnNamesSetup = YES;
}

- (int)columnIndexForName:(NSString*)columnName {
	columnName = [columnName lowercaseString];
	NSNumber *n = columnNameToIndexMap[columnName];
	
	if (n) {
		return [n intValue];
	}
	
//	NSLog(@"Warning: I could not find the column named '%@'.", columnName);
	
	return -1;
}


- (BOOL) bof {
	return (recordNumber == 0);
}

- (void) close {
	dispatch_sync(dbAccessQueue, ^{
		if (!closed) {
			closed = YES;
			sqlite3_finalize (dbps);
		}
	});
}


- (BOOL) eof {
	return eof;
}

- (int) fieldCount {
	return _fieldCount;
}


- (id<ABField>) fieldWithName:(NSString*)fieldName {
	int i = [self columnIndexForName:fieldName];
	if(i == -1)
		return nil;
	
	return [self fieldAtIndex: i];
}

- (id<ABField>) fieldAtIndex: (int) index {
	__block ABSQLiteField* field;
	
	dispatch_sync(dbAccessQueue, ^{
		NSString* fieldName = @(sqlite3_column_name(dbps, index));
		field = [[ABSQLiteField alloc] initWithSQLitePreparedStatement:dbps withName:fieldName dispatchQueue:dbAccessQueue withfieldIndex:index];
	});

	return field;
}

- (void) moveFirst {
	dispatch_sync(dbAccessQueue, ^{
		sqlite3_reset(dbps);
		eof = NO;
		recordNumber = 0;
	});
	[self moveNext];
}

- (void) moveLast {
	
}

- (void) moveNext {
	dispatch_sync(dbAccessQueue, ^{
		if (!eof) {
			int dbrc = sqlite3_step(dbps);
			
			if (dbrc == SQLITE_ROW)
				recordNumber++;
			else {
				eof = YES;
				
				if (dbrc < 100) {
//					NSString* errorMessage = [[NSString alloc] initWithUTF8String:sqlite3_errmsg(db)];
					NSLog(@"!!!! SQLite Error in moveNext !!!! ");
				}
			}
		}
	});
}

- (void) movePrevious {
	
}

- (int) recordCount {
	if (_recordCount > 0) {
		return _recordCount;
	}
	
	if([self eof]) {
		_recordCount = recordNumber;
		return _recordCount;
	}
	
	int currentRecordNumber = recordNumber;
	int maxRecordNumber = 0;
	[self moveFirst];
	while (![self eof]) {
		[self moveNext];
	}
	maxRecordNumber = recordNumber;
	[self moveFirst];
	while (recordNumber < currentRecordNumber) {
		[self moveNext];
	}
	
	_recordCount = maxRecordNumber;
	return maxRecordNumber;
}


@end
