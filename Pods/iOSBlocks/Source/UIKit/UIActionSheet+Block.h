//
//  UIActionSheet+Block.h
//  iOS Blocks
//
//  Created by Ignacio Romero Zurbuchen on 12/11/12.
//  Copyright (c) 2011 DZN Labs.
//  Licence: MIT-Licence
//

#import <UIKit/UIKit.h>
#import "iOSBlocksProtocol.h"

/*
 * UIActionSheet Delegate block methods.
 */
@interface UIActionSheet (Block) <UIActionSheetDelegate, UIImagePickerControllerDelegate, iOSBlocksProtocol>

/*
 * Displays an action sheet with all the possible options, like title, normal & destructive buttons, style, and with update blocks to notify when the user dismisses or cancels the action sheet.
 *
 * @param title A string to display in the title area of the action sheet. Pass nil if you do not want to display any text in the title area.
 * @param sheetStyle The action sheet presentation style.
 * @param cancelButtonTitle The title of the cancel button or nil if there is no cancel.
 * @param destructiveButtonTitle The title of the destructive red button.
 * @param buttonTitles The titles of any additional buttons you want to add.
 * @param disabledTitles An array of button titles to be disabled.
 * @param view The view from which the action sheet originates.
 * @param dismissed A block object to be executed after the action sheet is dismissed from the screen. Returns the pressed button's index and title.
 * @param cancelled A block object to be executed when the action sheet view is cancelled by the user.
 */
+ (UIActionSheet *)actionSheetWithTitle:(NSString *)title
                                  style:(UIActionSheetStyle)sheetStyle
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                 destructiveButtonTitle:(NSString *)destructiveButtonTitle
                           buttonTitles:(NSArray *)buttonTitles
                         disabledTitles:(NSArray *)disabledTitles
                             showInView:(UIView *)view
                              onDismiss:(DismissBlock)dismissed
                               onCancel:(VoidBlock)cancelled;

/*
 * Displays a standard action sheet filled with title and buttons, and with update blocks to notify when the user dismisses or cancels the action sheet.
 *
 * @param title A string to display in the title area of the action sheet. Pass nil if you do not want to display any text in the title area.
 * @param buttonTitles The titles of any additional buttons you want to add.
 * @param destructiveButtonTitle The title of the destructive red button.
 * @param view The view from which the action sheet originates.
 * @param dismissed A block object to be executed after the action sheet is dismissed from the screen. Returns the pressed button's index and title.
 * @param cancelled A block object to be executed when the action sheet view is cancelled by the user.
 */
+ (UIActionSheet *)actionSheetWithTitle:(NSString *)title
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                 destructiveButtonTitle:(NSString *)destructiveButtonTitle
                           buttonTitles:(NSArray *)buttonTitles
                             showInView:(UIView *)view
                              onDismiss:(DismissBlock)dismissed
                               onCancel:(VoidBlock)cancelled;

/*
 * Displays an action sheet with fewer options, like title and buttons, and with only one update block to notify when the user dismisses the action sheet.
 *
 * @param title A string to display in the title area of the action sheet. Pass nil if you do not want to display any text in the title area.
 * @param buttonTitles The titles of any additional buttons you want to add.
 * @param view The view from which the action sheet originates.
 * @param dismissed A block object to be executed after the action sheet is dismissed from the screen. Returns the pressed button's index and title.
 */
+ (UIActionSheet *)actionSheetWithTitle:(NSString *)title
                           buttonTitles:(NSArray *)buttonTitles
                             showInView:(UIView *)view
                              onDismiss:(DismissBlock)dismissed;

/*
 * Displays a photo picker action sheet, with update blocks to notify when the user chooses a pitcure or cancels the action sheet.
 *
 * @param title A string to display in the title area of the action sheet. Pass nil if you do not want to display any text in the title area.
 * @param cancelButtonTitle The title of the cancel button or nil if there is no cancel.
 * @param view The view from which the action sheet originates.
 * @param presentVC The viewController from where the UIImagePickerController should be modaly presented and dismissed.
 * @param photoPicked A block object to be executed when the user picked a still image.
 * @param cancelled A block object to be executed when the action sheet view is cancelled by the user.
 */
+ (UIActionSheet *)photoPickerWithTitle:(NSString *)title
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                             showInView:(UIView *)view
                              presentVC:(UIViewController *)presentVC
                          onPhotoPicked:(PhotoPickedBlock)photoPicked
                               onCancel:(VoidBlock)cancelled;

@end
