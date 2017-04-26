//
//  pwXMLViewController.m
//  pwControls
//
//  Created by MartinLee on 17/2/7.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwXMLViewController.h"
#import "UIButton+pwAddition.h"
#import "pwSAXToParserXML.h"
#import "pwDOMToParserXML.h"
#import "pwSocket.h"

@interface pwXMLViewController ()

@end

@implementation pwXMLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setUpUI{
    [super setUpUI];
    [self.tableView removeFromSuperview];
    UIButton *SAXBtn = [UIButton pwButonText:@"SAX" fontSize:16 normalColor:[UIColor blueColor] highlightedColor:[UIColor grayColor]];
    [SAXBtn addTarget:self action:@selector(SAXParserXML) forControlEvents:UIControlEventTouchUpInside];
    SAXBtn.frame = CGRectMake(10, 100, 60, 40);
    [self.view addSubview:SAXBtn];
    
    UIButton *DOMBtn = [UIButton pwButonText:@"DOM" fontSize:16 normalColor:[UIColor blueColor] highlightedColor:[UIColor grayColor]];
    [DOMBtn addTarget:self action:@selector(DOMParserXML) forControlEvents:UIControlEventTouchUpInside];
    DOMBtn.frame = CGRectMake(200, 100, 60, 40);
    [self.view addSubview:DOMBtn];
    
    UIButton *SocketBtn = [UIButton pwButonText:@"Socket" fontSize:16 normalColor:[UIColor blueColor] highlightedColor:[UIColor grayColor]];
    [SocketBtn addTarget:self action:@selector(socket) forControlEvents:UIControlEventTouchUpInside];
    SocketBtn.frame = CGRectMake(10, 200, 60, 40);
    [self.view addSubview:SocketBtn];
}

- (void)SAXParserXML{
    pwSAXToParserXML *sax = [[pwSAXToParserXML alloc] init];
    [sax loadXML];
}

- (void)DOMParserXML{
    [pwDOMToParserXML loadXML];
}

- (void)socket{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        pwSocket *socket = [[pwSocket alloc] init];
        NSString *dataString = [socket createSocket];
        NSLog(@"[socket createSocket] = %@",dataString);
    });

}

@end
