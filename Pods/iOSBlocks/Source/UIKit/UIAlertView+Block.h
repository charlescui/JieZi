//
//  UIAlertView+Block.h
//  iOS Blocks
//
//  Created by Ignacio Romero Zurbuchen on 12/11/12.
//  Copyright (c) 2011 DZN Labs.
//  Licence: MIT-Licence
//

#import <UIKit/UIKit.h>
#import "iOSBlocksProtocol.h"

/*
 * UIAlertView Delegate block methods.
 */
@interface UIAlertView (Block) <UIAlertViewDelegate, iOSBlocksProtocol>

/*
 * Displays an alert view filled with titles and buttons, and with update blocks to notify when the user dismisses or cancels the alert.
 *
 * @param title The string that appears in the receiver’s title bar.
 * @param message Descriptive text that provides more details than the title.
 * @param cancelButtonTitle The title of the cancel button or nil if there is no cancel button.
 * @param otherButtonTitles The title of aditional buttons.
 * @param dismissed A block object to be executed after the alert view is dismissed from the screen. Returns the pressed button's index and title.
 * @param cancelled A block object to be executed when the alert view is cancelled by the user.
 */
+ (UIAlertView *)alertViewWithTitle:(NSString *)title
                   message:(NSString *)message
         cancelButtonTitle:(NSString *)cancelButtonTitle
         otherButtonTitles:(NSArray *)otherButtonTitles
                 onDismiss:(DismissBlock)dismissed
                  onCancel:(VoidBlock)cancelled;

/*
 * Shorter method to Display an alert view with titles, description message and cancel button title, but with no blocks.
 *
 * @param title The string that appears in the receiver’s title bar.
 * @param message Descriptive text that provides more details than the title.
 * @param cancelButtonTitle The title of the cancel button or nil if there is no cancel button.
 */
+ (UIAlertView *)alertViewWithTitle:(NSString *)title
                   message:(NSString *)message
         cancelButtonTitle:(NSString *)cancelButtonTitle;

/*
 * Shorter method to Display an alert view with titles and description message, but with no blocks.
 *
 * @param title The string that appears in the receiver’s title bar.
 * @param message Descriptive text that provides more details than the title.
 */
+ (UIAlertView *)alertViewWithTitle:(NSString *)title
                   message:(NSString *)message;

@end
