//
//  UIPopoverController+Block.h
//  iOS Blocks
//
//  Created by Ignacio Romero Zurbuchen on 12/11/12.
//  Copyright (c) 2011 DZN Labs.
//  Licence: MIT-Licence
//

#import <UIKit/UIKit.h>
#import "iOSBlocksProtocol.h"

/*
 * UIPopoverController Delegate block methods.
 */
@interface UIPopoverController (Block) <UIPopoverControllerDelegate, iOSBlocksProtocol>

/*
 * A shared popoverController object across all the application.
 *
 * @returns A shared object for the popoverController.
 */
+ (UIPopoverController *)sharedPopover;

/*
 * Displays the popover and anchors it to the specified location in the view.
 *
 * @param controller The view controller for managing the popover’s content. This parameter must not be nil.
 * @param view The view on which to anchor the popover.
 * @param shouldDismiss A block object to be executed when the popover should be dismissed.
 * @param cancelled A block object to be executed when the popover was dismissed.
 */
+ (void)popOverWithContentViewController:(UIViewController *)controller
                              showInView:(UIView *)view
                         onShouldDismiss:(VoidBlock)shouldDismiss
                                onCancel:(VoidBlock)cancelled;

@end
