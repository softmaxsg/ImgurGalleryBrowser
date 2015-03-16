//
//  MessageUIHelper.m
//
//  Copyright (c) 2013 Vitaly Chupryk. All rights reserved.
//

#import "MessageUIHelper.h"

@implementation MessageUIHelper

+ (MessageUIHelper *)helper
{
    static MessageUIHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[MessageUIHelper alloc] init];
    });

    return helper;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (controller.navigationController != nil)
    {
        [controller.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [controller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

+ (BOOL)canSendMail
{
    return [MFMailComposeViewController canSendMail];
}

+ (void)presentComposeMailControllerIn:(UIViewController *)parentController
                        configureBlock:(void (^)(MFMailComposeViewController *))configureBlock
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = [MessageUIHelper helper];
        configureBlock(controller);
        [parentController presentViewController:controller animated:YES completion:nil];
    }
}

+ (void)presentComposeMailControllerIn:(UIViewController *)parentController
                               subject:(NSString *)subject
                                  body:(NSString *)body
                                isHTML:(BOOL)isHTML
                          toRecipients:(NSArray *)toRecipients
                          ccRecipients:(NSArray *)ccRecipients
                         bccRecipients:(NSArray *)bccRecipients
{
    [self presentComposeMailControllerIn:parentController
                          configureBlock:^(MFMailComposeViewController *controller)
                          {
                              [controller setToRecipients:toRecipients];
                              [controller setCcRecipients:ccRecipients];
                              [controller setBccRecipients:bccRecipients];
                              [controller setSubject:subject];
                              [controller setMessageBody:body isHTML:isHTML];
                          }];
}

@end