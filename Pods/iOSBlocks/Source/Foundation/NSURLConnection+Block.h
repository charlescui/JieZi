//
//  NSURLConnection+Block.h
//  iOS Blocks
//
//  Created by Ignacio Romero Zurbuchen on 1/11/13.
//  Copyright (c) 2011 DZN Labs.
//  Licence: MIT-Licence
//

#import <Foundation/Foundation.h>
#import "iOSBlocksProtocol.h"

/*
 * NSURLConnection Delegate block methods.
 * @warning This implementation may be deprecated very soon as Apple did depcrecated NSURLConnectionDelegate methods since iOS4.3 but still works under the lastest iOS versions.
 */
@interface NSURLConnection (Block) <NSURLConnectionDelegate, iOSBlocksProtocol>

/*
 * Loads the data for a URL request and executes a handler block on an operation queue when the request completes or fails.
 *
 * @param request The URL request to load. The request object is deep-copied as part of the initialization process.
 * @param progress A block object to be executed everytime the data of a request is transmitted, updating it progress value. Returns a connection progress integer.
 * @param data A block object to be executed when a connection loads data incrementally. Returns the newly concatenated data.
 * @param success A block object to be executed when the connection has received sufficient data to construct the URL response for its request. Returns the URL response for the connection's request.
 * @param fail A block object to be executed when a connection fails to load its request successfully. Returns an error object containing details of why the connection failed to load the request successfully.
 *
 * @returns The URL connection for the URL request. Returns nil if a connection can't be created.
 */
+ (NSURLConnection *)sendAsynchronousRequest:(NSURLRequest *)request
                           didUpdateProgress:(ProgressBlock)progress
                              didReceiveData:(DataBlock)data
                          didReceiveResponse:(SuccessBlock)success
                            didFailWithError:(FailureBlock)fail;

@end
