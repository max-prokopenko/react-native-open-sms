#import "OpenSmsManager.h"
#import <React/RCTConvert.h>
#import <MessageUI/MessageUI.h>

@interface OpenSmsManager() <MFMessageComposeViewControllerDelegate>

@end

@implementation OpenSmsManager
{
    NSMutableArray *composeViews;
    NSMutableArray *composeCallbacks;
}

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

+ (BOOL)requiresMainQueueSetup
{
    // Module require access to UIKit, so requiring main thread
    return YES;
}

- (instancetype)init
{
    if ((self = [super init]))
    {
        composeCallbacks = [[NSMutableArray alloc] init];
        composeViews = [[NSMutableArray alloc] init];
    }
    return self;
}

RCT_EXPORT_MODULE(OpenSms)

RCT_EXPORT_METHOD(displaySMSComposerSheet:(NSDictionary *)props
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
                
{
    // Checking the availability of message services
    if(![MFMessageComposeViewController canSendText])
    {
        resolve(@"notsupported");
        return;
    }

    MFMessageComposeViewController *composeVC = [[MFMessageComposeViewController alloc] init];
    composeVC.messageComposeDelegate = self;

    if(props[@"recipients"])
    {
        if([props[@"recipients"] isKindOfClass:[NSArray class]])
        {
            NSArray *recipients = props[@"recipients"];
            if(recipients.count > 0)
            {
                NSMutableArray *validRecipientTypes = [[NSMutableArray alloc] init];

                for(id recipient in recipients)
                {
                    if([recipient isKindOfClass:[NSString class]])
                    {
                        [validRecipientTypes addObject:recipient];
                    }
                }
                if(validRecipientTypes.count != 0)
                {
                    composeVC.recipients = validRecipientTypes;
                }
                else
                {
                    RCTLog(@"Recipients are invalid");
                }
            }
            else
            {
                RCTLog(@"Recipients must be NOT empty");
            }
        }
        else
        {
            RCTLog(@"Recipients must be an array");
        }
    }
    
    if(props[@"body"])
    {
        composeVC.body = [RCTConvert NSString:props[@"body"]];
    }
   
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [rootViewController presentViewController:composeVC animated:YES completion:nil];

    [composeViews addObject:composeVC];
    [composeCallbacks addObject:resolve];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    NSUInteger index = [composeViews indexOfObject:controller];
    RCTAssert(index != NSNotFound, @"Dismissed view controller was not recognised");
    RCTPromiseResolveBlock callback = composeCallbacks[index];

    switch (result) {
        case MessageComposeResultCancelled:
            callback(@"cancelled");
            break;
        case MessageComposeResultFailed:
            callback(@"failed");
            break;
        case MessageComposeResultSent:
            callback(@"sent");
            break;
        default:
            break;
    }

    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [vc dismissViewControllerAnimated:YES completion:nil];

    [composeViews removeObjectAtIndex:index];
    [composeCallbacks removeObjectAtIndex:index];
}

@end
