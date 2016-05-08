//
//  ViewController.m
//  TwitterSearch
//
//  Created by Pramod Sharma on 06/05/16.
//  Copyright © 2016 Pramod Sharma. All rights reserved.
//

#import "ViewController.h"
#import "FHSTwitterEngine.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "TwitterAddData.h"
#import "SearchResultViewController.h"

#define TWITTER_COSUMER_KEY @"pShXllYF1InLlb1UVG0TBDJyN"
#define TWITTER_SECRET_KEY @"JYouJRUlzRX6Y4YXm7u1JKcxH64YyPH8Te6m7vivdUC9NjlWex"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //default search for iOS
    txtSearch.text = @"iOS";
    [self twitterInitilization];
    [self setLoginBtnStatus];
}

/*!
 *  @author Pramod Sharma, 16-05-06 16:05:07
 *
 *  @brief Twitter Auth setup
 *
 *  @since <#1.0#>
 */
- (void)loginOAuth {
    UIViewController *loginController = [[FHSTwitterEngine sharedEngine]loginControllerWithCompletionHandler:^(BOOL success) {
        NSLog(success ? @"Login Sucees":@"Login Failure");
        [btnTwitterLogin setTitle:@"Logout" forState:UIControlStateNormal];
    }];
    [self presentViewController:loginController animated:YES completion:nil];
}

- (void)setLoginBtnStatus {
    if (![[FHSTwitterEngine sharedEngine]isAuthorized]) {
        [btnTwitterLogin setTitle:@"Login" forState:UIControlStateNormal];
    } else {
        [btnTwitterLogin setTitle:@"Logout" forState:UIControlStateNormal];
    }
}

/*!
 *  @author Pramod Sharma, 16-05-06 16:05:42
 *
 *  @brief Twitter Key Setup
 *
 *  @since <#1.0#>
 */
- (void)twitterInitilization {
    [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey:TWITTER_COSUMER_KEY andSecret:TWITTER_SECRET_KEY];
    [[FHSTwitterEngine sharedEngine]loadAccessToken];
}

- (IBAction)twitterLoginBtnPressed:(id)sender {
    if (![[FHSTwitterEngine sharedEngine]isAuthorized]) {
        [btnTwitterLogin setTitle:@"Login" forState:UIControlStateNormal];
        [self loginOAuth];
    } else {
        [[FHSTwitterEngine sharedEngine]clearAccessToken];
        [btnTwitterLogin setTitle:@"Login" forState:UIControlStateNormal];
    }
}

- (IBAction)searchBtnPressed:(id)sender {
    if (![[FHSTwitterEngine sharedEngine]isAuthorized]) {
        [self showAlertMessage:@"Please login first in Twitter account using Login button."];
        return;
    } else if (!txtSearch.text.length > 0) {
        [self showAlertMessage:@"Please enter search term."];
        return;
    }
    [self searchQuery];
}

/*!
 *  @author Pramod Sharma, 16-05-06 16:05:24
 *
 *  @brief Twitter search API Call
 *
 *  @since <#1.0#>
 */
- (void)searchQuery {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            NSDictionary *dictResult = [[FHSTwitterEngine sharedEngine]searchTweetsWithQuery:txtSearch.text count:100 resultType:FHSTwitterEngineResultTypeMixed unil:nil sinceID:nil maxID:nil];
            NSArray *arr = [dictResult objectForKey:@"statuses"];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *strTitle = [obj objectForKey:@"text"];
                [self storeDataInDB:strTitle];
            }];
            dispatch_sync(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    [self pushOnResultView];
            });
        }
    });
}

- (void)storeDataInDB:(NSString *)titleStr {
    NSLog(@"title str>>>%@",titleStr);
    AppDelegate *app = [AppDelegate sharedInstance];
    NSManagedObjectContext *context = app.managedObjectContext;
    [TwitterAddData storeDataInDatabase:titleStr inManagedObjectContext:context];
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }

}

- (void)pushOnResultView {
    SearchResultViewController *searchView = [self.storyboard instantiateViewControllerWithIdentifier:@"searchResultView"];
    [self.navigationController pushViewController:searchView animated:true];
}

- (void)showAlertMessage:(NSString *)msg {
    UIAlertController *alert = [UIAlertController
                                  alertControllerWithTitle:nil
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
