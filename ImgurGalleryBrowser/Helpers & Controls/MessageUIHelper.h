//
//  MessageUIHelper.h
//
//  Copyright (c) 2013 Vitaly Chupryk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface MessageUIHelper : NSObject<MFMailComposeViewControllerDelegate>

+ (BOOL)canSendMail;

+ (void)presentComposeMailControllerIn:(UIViewController *)parentController
                        configureBlock:(void (^)(MFMailComposeViewController *))configureBlock;

+ (void)presentComposeMailControllerIn:(UIViewController *)parentController
                               subject:(NSString *)subject
                                  body:(NSString *)body
                                isHTML:(BOOL)isHTML
                          toRecipients:(NSArray *)toRecipients
                          ccRecipients:(NSArray *)ccRecipients
                         bccRecipients:(NSArray *)bccRecipients;

@end