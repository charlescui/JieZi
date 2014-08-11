//
//  MFMessageComposeViewController+Block.m
//  iOS Blocks
//
//  Created by Ignacio Romero Zurbuchen on 12/11/12.
//  Copyright (c) 2011 DZN Labs.
//  Licence: MIT-Licence
//

#import "MFMessageComposeViewController+Block.h"

static ComposeCreatedBlock _composeCreatedBlock;
static ComposeFinishedBlock _composeFinishedBlock;

@implementation MFMessageComposeViewController (Block)

+ (void)messageWithBody:(NSString *)body
             recipients:(NSArray *)recipients
             onCreation:(ComposeCreatedBlock)creation
               onFinish:(ComposeFinishedBlock)finished
{
    [self messageWithBody:body subject:nil recipients:recipients andAttachments:nil onCreation:creation onFinish:finished];
}

+ (void)messageWithBody:(NSString *)body
                subject:(NSString *)subject
             recipients:(NSArray *)recipients
         andAttachments:(NSArray *)attachments
             onCreation:(ComposeCreatedBlock)creation
               onFinish:(ComposeFinishedBlock)finished
{
    if (![self canSendText]) {
#if TARGET_IPHONE_SIMULATOR
        NSLog(@"MFMessageComposeViewController is not supported in Simulator.");
#endif
        return;
    }
    
    _composeCreatedBlock = [creation copy];
    _composeFinishedBlock = [finished copy];
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    controller.messageComposeDelegate = weakObject(controller);
    
    [controller setBody:body];
    [controller setRecipients:recipients];
    
    if ([self canSendSubject] && subject) {
        [controller setSubject:subject];
    }
    
    if ([self canSendAttachments] && attachments.count > 0) {
        
        for (NSDictionary *attachment in attachments) {
            NSData *data = [attachment objectForKey:kMFMessageAttachmentData];
            NSString *mimeType = [attachment objectForKey:kMFMessageAttachmentMimeType];
            NSString *filename = [attachment objectForKey:kMFMessageAttachmentFileName];
            
            [controller addAttachmentData:data typeIdentifier:mimeType filename:filename];
        }
    }

    if (_composeCreatedBlock) {
        _composeCreatedBlock(controller);
    }
}


#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if (_composeFinishedBlock) {
        _composeFinishedBlock(controller, result, nil);
    }
}

@end
