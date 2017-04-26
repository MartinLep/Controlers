//
//  pwDOMToParserXML.m
//  pwControls
//
//  Created by MartinLee on 17/2/7.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwDOMToParserXML.h"
#import "GDataXMLNode.h"
#import "pwXMLModel.h"

@implementation pwDOMToParserXML

+ (void)loadXML{
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/videos.xml"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if(connectionError){
            NSLog(@"链接错误 %@",connectionError);
            return;
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200 || httpResponse.statusCode == 304){
            GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data error:nil];
            //获取xml文档的根元素 (标签)
            GDataXMLElement *rooElement = document.rootElement;
            
            NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:10];
            
            //遍历所有的video节点
            for(GDataXMLElement *element in rooElement.children){
                NSLog(@"element = %@",element);
                //创建对象
                pwXMLModel *model = [[pwXMLModel alloc] init];
                [mArray addObject:model];
                
                //给对象的属性赋值
                //遍历Video的子标签
                for(GDataXMLElement *subElement in element.children){
                    NSLog(@"subElement = %@",subElement);
                    [model setValue:subElement.stringValue forKey:subElement.name];
                }
                
                //遍历Video的所有属性 {type:2 name:videoId xml:"videoId="1""}
                for(GDataXMLElement *attr in element.attributes){
                    NSLog(@"attr = %@",attr);
                    [model setValue:attr.stringValue forKey:attr.name];
                }
            }
            NSLog(@"rootElement = %@",mArray);
        }else{
            
        }
    }];
}
@end
