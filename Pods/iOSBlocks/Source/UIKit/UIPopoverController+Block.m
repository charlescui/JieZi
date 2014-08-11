//
//  UIPopoverController+Block.m
//  iOS Blocks
//
//  Created by Ignacio Romero Zurbuchen on 12/11/12.
//  Copyright (c) 2011 DZN Labs.
//  Licence: MIT-Licence
//

#import "UIPopoverController+Block.h"

static VoidBlock _shouldDismissBlock;
static VoidBlock _cancelBlock;

static UIPopoverController *_sharedPopover;

@implementation UIPopoverController (Block)

+ (UIPopoverController *)sharedPopover
{
    return _sharedPopover;
}

+ (void)popOverWithContentViewController:(UIViewController *)controller
                              showInView:(UIView *)view
                         onShouldDismiss:(VoidBlock)shouldDismiss
                                onCancel:(VoidBlock)cancelled
{
    _shouldDismissBlock = [shouldDismiss copy];
    _cancelBlock = [cancelled copy];
    
    if (_sharedPopover && ![controller isEqual:[UIPopoverController sharedPopover].contentViewController]) {
        _sharedPopover = nil;
    }
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    popover.popoverContentSize = controller.contentSizeForViewInPopover;
    popover.delegate = weakObject(popover);

    if ([view isKindOfClass:[UIBarButtonItem class]]) {
        [popover presentPopoverFromBarButtonItem:(UIBarButtonItem *)view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else if ([view isKindOfClass:[UIView class]]) {
        [popover presentPopoverFromRect:view.frame inView:view.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    
    _sharedPopover = popover;
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    if (_shouldDismissBlock) {
        _shouldDismissBlock();
    }
    
    return YES;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (_cancelBlock) {
        _cancelBlock();
    }
}

@end
