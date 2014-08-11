//
//  MFMailComposeViewController+Block.m
//  iOS Blocks
//
//  Created by Ignacio Romero Zurbuchen on 12/11/12.
//  Copyright (c) 2011 DZN Labs.
//  Licence: MIT-Licence
//

#import "MFMailComposeViewController+Block.h"

static ComposeCreatedBlock _composeCreatedBlock;
static ComposeFinishedBlock _composeFinishedBlock;

@implementation MFMailComposeViewController (Block)

+ (void)mailWithSubject:(NSString *)subject
                message:(NSString *)message
             recipients:(NSArray *)recipients
             onCreation:(ComposeCreatedBlock)creation
               onFinish:(ComposeFinishedBlock)finished
{
    [MFMailComposeViewController mailWithSubject:subject
                                         message:message
                                      recipients:recipients
                                   bccRecipients:nil
                                    ccRecipients:nil
                                  andAttachments:nil
                                      onCreation:creation
                                        onFinish:finished];
}




+ (void)mailWithSubject:(NSString *)subject
                message:(NSString *)message
             recipients:(NSArray *)recipients
          bccRecipients:(NSArray *)bccRecipients
           ccRecipients:(NSArray *)ccRecipients
         andAttachments:(NSArray *)attachments
             onCreation:(ComposeCreatedBlock)creation
               onFinish:(ComposeFinishedBlock)finished
{
    if (![self canSendMail]) {
        return;
    }
    
    _composeCreatedBlock = [creation copy];
    _composeFinishedBlock = [finished copy];

    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = weakObject(controller);
    [controller setSubject:subject];
    [controller setMessageBody:message isHTML:YES];
    [controller setToRecipients:recipients];
    [controller setBccRecipients:bccRecipients];
    [controller setCcRecipients:ccRecipients];
    
    for (NSDictionary *attachment in attachments) {
        NSData *data = [attachment objectForKey:kMFAttachmentData];
        NSString *mimeType = [attachment objectForKey:kMFAttachmentMimeType];
        NSString *filename = [attachment objectForKey:kMFAttachmentFileName];
        
        [controller addAttachmentData:data mimeType:mimeType fileName:filename];
    }
    
    controller.modalPresentationStyle = UIModalPresentationFormSheet;
    
    if (_composeCreatedBlock) {
        _composeCreatedBlock(controller);
    }
}


#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (_composeFinishedBlock) {
        _composeFinishedBlock(controller, result, error);
    }
}

@end
