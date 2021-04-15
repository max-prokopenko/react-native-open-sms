#import "OpenSmsViewManager.h"
#import <React/RCTConvert.h>
#import <MessageUI/MessageUI.h>

@interface OpenSmsViewManager() <MFMessageComposeViewControllerDelegate>

@end

@implementation OpenSmsViewManager
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

RCT_EXPORT_MODULE(OpenSmsView)

RCT_EXPORT_METHOD(displaySMSComposerSheet:(NSDictionary *)props callback:(RCTResponseSenderBlock)callback)
{
    // Checking the availability of message services
    if(![MFMessageComposeViewController canSendText])
    {
        callback(@[@"notsupported"]);
        return;
    }

    MFMessageComposeViewController *composeVC = [[MFMessageComposeViewController alloc] init];
    composeVC.messageComposeDelegate = self;

    if(props[@"recipients"])
    {
        // check that recipients was passed as an NSArray
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
                    RCTLog(@"You provided a recipients array but it did not contain any valid argument types");
                }
            }
            else
            {
                RCTLog(@"You provided a recipients array but it was empty. No values to add");
            }
        }
        else
        {
            RCTLog(@"recipients must be supplied as an array. Ignoring the values provided");
        }
    }
    
    if(props[@"body"])
    {
        composeVC.body = [RCTConvert NSString:props[@"body"]];
    }
   
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [rootViewController presentViewController:composeVC animated:YES completion:nil];

    [composeViews addObject:composeVC];
    [composeCallbacks addObject:callback];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    NSUInteger index = [composeViews indexOfObject:controller];
    RCTAssert(index != NSNotFound, @"Dismissed view controller was not recognised");
    RCTResponseSenderBlock callback = composeCallbacks[index];

    switch (result) {
        case MessageComposeResultCancelled:
            callback(@[@"cancelled"]);
            break;
        case MessageComposeResultFailed:
            callback(@[@"failed"]);
            break;
        case MessageComposeResultSent:
            callback(@[@"sent"]);
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
