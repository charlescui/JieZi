//
//  ABSQLiteField.m
//  Easy Spend Log
//
//  Created by Aaron Bratcher on 04/25/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ABSQLiteField.h"

static NSDateFormatter* dateFormatter;


@implementation ABSQLiteField

	dispatch_queue_t dbAccessQueue;

- (id) initWithSQLitePreparedStatement: (sqlite3_stmt *) initial_dbps withName:(NSString *)initial_name dispatchQueue:(dispatch_queue_t) dispatchQueue withfieldIndex:(int)initial_fieldIndex {
	
	self = [super init];
	dbps = initial_dbps;
	name = initial_name;
	fieldIndex = initial_fieldIndex;
	dbAccessQueue = dispatchQueue;
	
	return self;
}


- (NSString*) name {
	return name;
}

- (BOOL) isNull {
	__block BOOL nullValue = NO;
	dispatch_sync(dbAccessQueue, ^{
		nullValue = (sqlite3_column_type(dbps, fieldIndex) == SQLITE_NULL);
	});
	
	return nullValue;
}

- (BOOL) booleanValue {
	return ([self intValue] != 0);
}

- (NSString*) stringValue {
	__block NSString* value;
	
	dispatch_sync(dbAccessQueue, ^{
		
		if (sqlite3_column_type(dbps, fieldIndex) == SQLITE_NULL) {
			value = nil;
		} else {
			const char *c = (const char *)sqlite3_column_text(dbps, fieldIndex);
			if (c)
				value = @(c);
		}
	});

	return value;
}

- (NSDate*) dateValue {
	if (!dateFormatter) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	}
	
	__block NSDate *date;
	dispatch_sync(dbAccessQueue, ^{
		if (sqlite3_column_type(dbps, fieldIndex) == SQLITE_NULL) {
			date = nil;
		} else {
			NSString* value;
			if (sqlite3_column_type(dbps, fieldIndex) == SQLITE_NULL) {
				value = nil;
			} else {
				const char *c = (const char *)sqlite3_column_text(dbps, fieldIndex);
				if (c) {
					value = @(c);
					date = [dateFormatter dateFromString:value];
				}
			}
		}
	});
	
	return date;
}

- (int) intValue {
	__block int value;
	dispatch_sync(dbAccessQueue, ^{
		value = sqlite3_column_int(dbps, fieldIndex);
	});
	
	return value;
}

- (double) doubleValue {
	__block double value;
	dispatch_sync(dbAccessQueue, ^{
		value = sqlite3_column_double(dbps, fieldIndex);
	});
	return value;
}

- (long long int) longLongValue {
	__block long long int value;
	dispatch_sync(dbAccessQueue, ^{
		value = sqlite3_column_int64(dbps, fieldIndex);
	});
	return value;
}

- (NSData*) rawValue {
	__block NSMutableData *data;
	
	dispatch_sync(dbAccessQueue, ^{
		
		if (sqlite3_column_type(dbps, fieldIndex) == SQLITE_NULL) {
			data = nil;
		} else {
			int dataSize = sqlite3_column_bytes(dbps, fieldIndex);
			data = [NSMutableData dataWithLength:dataSize];
			memcpy([data mutableBytes], sqlite3_column_blob(dbps, fieldIndex), dataSize);
		}
	});
   
    return data;
}

@end
