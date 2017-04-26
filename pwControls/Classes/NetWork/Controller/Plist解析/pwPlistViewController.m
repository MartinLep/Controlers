//
//  pwPlistViewController.m
//  pwControls
//
//  Created by MartinLee on 17/2/7.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwPlistViewController.h"

@interface pwPlistViewController ()

@end

@implementation pwPlistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self netRequest];
}

- (void)netRequest{
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/videos.plist"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if(connectionError){
            NSLog(@"链接错误 %@",connectionError);
            return;
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200 || httpResponse.statusCode == 304){
            id plist = [NSPropertyListSerialization propertyListWithData:data options:0 format:0 error:NULL];
            NSLog(@"plist = %@",plist);
        }else{
            
        }
    }];
}

@end
