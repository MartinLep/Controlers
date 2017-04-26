//
//  pwJsonViewController.m
//  pwControls
//
//  Created by MartinLee on 17/2/7.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwJsonViewController.h"
#import "pwJsonMessageModel.h"

@interface pwJsonViewController ()

@end

@implementation pwJsonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self netRequest];
}

- (void)netRequest{
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/demo.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if(connectionError){
            NSLog(@"链接错误 %@",connectionError);
            return;
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200 || httpResponse.statusCode == 304){
            //Json反序列化
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            pwJsonMessageModel *messageModel = [pwJsonMessageModel messageWithDic:dic];
            NSLog(@"messageModel = %@",messageModel);
        }else{
            
        }
    }];
}
@end
