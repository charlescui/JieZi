//
//  UIPickerView+Block.m
//  iOS Blocks
//
//  Created by Ignacio Romero Zurbuchen on 12/19/12.
//  Copyright (c) 2011 DZN Labs.
//  Licence: MIT-Licence
//

#import "UIPickerView+Block.h"
#import "UIPopoverController+Block.h"

static NSArray *_content;
static RowPickedBlock _rowPickedBlock;

@implementation UIPickerView (Block)

+ (BOOL)canShowInView:(UIView *)view
{
    if (!view.window) {
        return NO;
    }
    return YES;
}

+ (UIPickerView *)pickerViewWithContent:(NSArray *)content
                             showInView:(UIView *)view
                            onRowPicked:(RowPickedBlock)rowPickedBlock
{
    if (![self canShowInView:view] || content.count == 0) {
        return nil;
    }
    
    if (_content) {
        _content = nil;
    }
    
    _rowPickedBlock = [rowPickedBlock copy];
    _content = [content copy];
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.dataSource = weakObject(pickerView);
    pickerView.delegate = weakObject(pickerView);
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.showsSelectionIndicator = YES;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [view addSubview:pickerView];
    }
    else {
        UIViewController *controller = [UIViewController new];
        [controller.view addSubview:pickerView];
        
        controller.contentSizeForViewInPopover = pickerView.frame.size;
        
        [UIPopoverController popOverWithContentViewController:controller
                                                   showInView:view
                                              onShouldDismiss:^(void){
                                                  [[UIPopoverController sharedPopover] dismissPopoverAnimated:YES];
                                              }
                                                     onCancel:^(void){
                                                     }
         ];
    }
    
    return pickerView;
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [_content count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_content objectAtIndex:row];
}


#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_rowPickedBlock) {
        _rowPickedBlock([_content objectAtIndex:row]);
    }
}

@end
