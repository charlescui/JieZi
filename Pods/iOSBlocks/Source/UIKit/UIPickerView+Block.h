//
//  UIPickerView+Block.h
//  iOS Blocks
//
//  Created by Ignacio Romero Zurbuchen on 12/19/12.
//  Copyright (c) 2011 DZN Labs.
//  Licence: MIT-Licence
//

#import <UIKit/UIKit.h>
#import "iOSBlocksProtocol.h"

/*
 * UIPickerView Delegate block methods.
 */
@interface UIPickerView (Block) <UIPickerViewDataSource, UIPickerViewDelegate>

/*
 * Displays a picker view filled with content from an array.
 *
 * @param content Array containing the row's titles.
 * @param view The view from which the picker view originates.
 * @param rowPickedBlock A block object to be executed when the user selects a specified row. Returns the pressed row's title.
 */
+ (UIPickerView *)pickerViewWithContent:(NSArray *)content
                             showInView:(UIView *)view
                            onRowPicked:(RowPickedBlock)rowPickedBlock;

@end
