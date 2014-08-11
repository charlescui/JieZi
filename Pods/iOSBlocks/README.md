iOS Blocks
============

Delegates are a real pain in the ars. Objective-C blocks rule!
This are some category classes of my own to allow easy implementation of the basic iOS frameworks & APIs without the need of using delegation.

## Installation
Available in [Cocoa Pods](http://cocoapods.org/?q=iOSBlocks)
```
pod 'iOSBlocks', '~> 1.0.2', :inhibit_warnings => true
```
(You should add the 'inhibit_warnings' flag to avoid some existing warnings that must be fixed soon)

Then import the library wherever you need it, or in you application's Prefix.pch file.
```
#import "iOSBlocks.h"
```

## Some Examples
### UINavigationController
```
- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
              onCompletion:(VoidBlock)completion;
```

&

```
- (void)popViewControllerAnimated:(BOOL)animated
                     onCompletion:(VoidBlock)completion;
```

### UIPopoverController
```
+ (UIPopoverController *)popOverWithContentViewController:(UIViewController *)controller
                                               showInView:(UIView *)view
                                          onShouldDismiss:(VoidBlock)shouldDismiss
                                                 onCancel:(CancelBlock)cancelled;
```

### UIAlertView
```
+ (UIAlertView *)alertViewWithTitle:(NSString *)title
                            message:(NSString *)message
                  cancelButtonTitle:(NSString *)cancelButtonTitle
                  otherButtonTitles:(NSArray *)otherButtons
                          onDismiss:(DismissBlock)dismissed
                           onCancel:(CancelBlock)cancelled;
```

### UIActionSheet
```
+ (UIActionSheet *)actionSheetWithTitle:(NSString *)title
                                  style:(UIActionSheetStyle)sheetStyle
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                           buttonTitles:(NSArray *)buttonTitles
                         disabledTitles:(NSArray *)disabledTitles
                             showInView:(UIView *)view
                              onDismiss:(DismissBlock)dismissed
                               onCancel:(CancelBlock)cancelled;
```

### MFMailComposeViewController
```
+ (void)mailWithSubject:(NSString *)subject
                message:(NSString *)message
             recipients:(NSArray *)recipients
         andAttachments:(NSArray *)attachments
             onCreation:(ComposeCreatedBlock)creation
               onFinish:(ComposeFinishedBlock)finished;
```

### MFMessageComposeViewController
```
+ (void)messageWithBody:(NSString *)body
             recipients:(NSArray *)recipients
             onCreation:(ComposeCreatedBlock)creation
               onFinish:(ComposeFinishedBlock)finished;
```

### NSURLConnection
```
+ (NSURLConnection *)sendAsynchronousRequest:(NSURLRequest *)request
                           didUpdateProgress:(ProgressBlock)progress
                              didReceiveData:(DataBlock)data
                          didReceiveResponse:(SuccessBlock)success
                            didFailWithError:(FailureBlock)fail;
```

### CLLocation
```
+ (void)updateLocationWithDistanceFilter:(CLLocationDistance)filter
                      andDesiredAccuracy:(CLLocationAccuracy)accuracy
            didChangeAuthorizationStatus:(StatusBlock)status
                      didUpdateLocations:(LocationBlock)located
                        didFailWithError:(FailureBlock)failed;
```

And more to come. Enjoy!

## Sample project
Take a look into the sample project. Everything is there.<br>
Enjoy and collaborate if you feel this library could be improved.


## License
(The MIT License)

Copyright (c) 2012 Ignacio Romero Zurbuchen <iromero@dzen.cl>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
