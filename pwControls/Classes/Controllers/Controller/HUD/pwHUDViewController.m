//
//  pwHUDViewController.m
//  pwControls
//
//  Created by MartinLee on 17/1/4.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwHUDViewController.h"
#import <MBProgressHUD.h>

@interface pwHUDViewController ()
@property (atomic, assign) BOOL canceled;
@end

static NSString *cellID = @"cellID";

@implementation pwHUDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleName = [NSString stringWithFormat:@"%lu",self.navigationController.viewControllers.count];
}

- (NSArray *)HUDArray{
    if(_HUDArray == nil){
        NSArray *array = [NSArray arrayWithObjects:@"Default Mode",@"With Label",@"With details label",@"Determinate mode", @"Annular determinate mode",@"Bar determinate mode",@"Text only",@"Custom view",@"With action button",@"Mode switching",@"NSURLSession",@"Determinate with NSProgress",@"Dim background",@"Colored",nil];
        _HUDArray = array;
    }
    return _HUDArray;
}

-(void)setUpUI{
    [super setUpUI];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一页" style:UIBarButtonItemStyleDone target:self action:@selector(showNext)];
}

- (void)showNext{
    pwHUDViewController *vc = [[pwHUDViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.HUDArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.textLabel.text = self.HUDArray[(int)indexPath.row];
    return cell;
}
- (void)doSomeWork {
    // Simulate by just waiting.
    sleep(3.0);
}

- (void)cancelWork:(id)sender {
    self.canceled = YES;
}

- (void)doSomeWorkWithProgress {
    self.canceled = NO;
    // This just increases the progress indicator in a loop.
    float progress = 0.0f;
    while (progress < 1.0f) {
        if (self.canceled) break;
        progress += 0.01f;
        dispatch_async(dispatch_get_main_queue(), ^{
            // Instead we could have also passed a reference to the HUD
            // to the HUD to myProgressTask as a method parameter.
            [MBProgressHUD HUDForView:self.navigationController.view].progress = progress;
        });
        usleep(50000);
    }
}

- (void)doSomeWorkWithMixedProgress {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
    // Indeterminate mode
    sleep(2);
    // Switch to determinate mode
    dispatch_async(dispatch_get_main_queue(), ^{
        hud.mode = MBProgressHUDModeDeterminate;
        hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    });
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.progress = progress;
        });
        usleep(50000);
    }
    // Back to indeterminate mode
    dispatch_async(dispatch_get_main_queue(), ^{
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = NSLocalizedString(@"Cleaning up...", @"HUD cleanining up title");
    });
    sleep(2);
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
        hud.label.text = NSLocalizedString(@"Completed", @"HUD completed title");
    });
    sleep(2);
}

- (void)doSomeNetworkWorkWithProgress {
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    NSURL *URL = [NSURL URLWithString:@"https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/HT1425/sample_iPod.m4v.zip"];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:URL];
    [task resume];
}

- (void)doSomeWorkWithProgressObject:(NSProgress *)progressObject {
    while (progressObject.fractionCompleted < 1.0f) {
        if (progressObject.isCancelled) break;
        [progressObject becomeCurrentWithPendingUnitCount:1];
        [progressObject resignCurrent];
        usleep(50000);
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    switch (indexPath.row) {
        case 0:{
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                [self doSomeWork];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                });
            });
        }
            break;
        case 1:{
            hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                [self doSomeWork];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                });
            });
        }
            break;
        case 2:{
            hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
            hud.detailsLabel.text = NSLocalizedString(@"Parsing data\n(1/1)", @"HUD title");
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                [self doSomeWork];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                });
            });
        }
            break;
        case 3:{
            hud.mode = MBProgressHUDModeDeterminate;
            hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                [self doSomeWorkWithProgress];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                });
            });
        }
            break;
        case 4:{
            hud.mode = MBProgressHUDModeAnnularDeterminate;
            hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                [self doSomeWorkWithProgress];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                });
            });
        }
            break;
        case 5:{
            hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
            hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                [self doSomeWorkWithProgress];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                });
            });
        }
            break;
        case 6:{
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"Message here!", @"HUD message title");
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }
            break;
        case 7:{
            hud.mode = MBProgressHUDModeCustomView;
            UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            hud.customView = [[UIImageView alloc] initWithImage:image];
            hud.square = YES;
            hud.label.text = NSLocalizedString(@"Done", @"HUD done title");
            [hud hideAnimated:YES afterDelay:3.f];
        }
            break;
        case 8:{
            hud.mode = MBProgressHUDModeDeterminate;
            hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
            [hud.button setTitle:NSLocalizedString(@"Cancel", @"HUD cancel button title") forState:UIControlStateNormal];
            [hud.button addTarget:self action:@selector(cancelWork:) forControlEvents:UIControlEventTouchUpInside];
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                [self doSomeWorkWithProgress];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                });
            });
        }
            break;
        case 9:{
            hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
            hud.minSize = CGSizeMake(150.f, 100.f);
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                [self doSomeWorkWithMixedProgress];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                });
            });
        }
            break;
        case 10:{
            hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
            hud.minSize = CGSizeMake(150.f, 100.f);
            [self doSomeNetworkWorkWithProgress];
        }
            break;
        case 11:{
            hud.mode = MBProgressHUDModeDeterminate;
            hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
            NSProgress *progressObject = [NSProgress progressWithTotalUnitCount:100];
            hud.progressObject = progressObject;
            [hud.button setTitle:NSLocalizedString(@"Cancel", @"HUD cancel button title") forState:UIControlStateNormal];
            [hud.button addTarget:progressObject action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                [self doSomeWorkWithProgressObject:progressObject];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                });
            });
        }
            break;
        case 12:{
            hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
            hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                [self doSomeWork];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                });
            });
        }
            break;
        case 13:{
            hud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
            hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                [self doSomeWork];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                });
            });
        }
            break;
        default:
            break;
    }
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    // Do something with the data at location...
    
    // Update the UI on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
        hud.label.text = NSLocalizedString(@"Completed", @"HUD completed title");
        [hud hideAnimated:YES afterDelay:3.f];
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
    
    // Update the UI on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
        hud.mode = MBProgressHUDModeDeterminate;
        hud.progress = progress;
    });
}

@end
