//
//  pwSAXToParserXML.m
//  pwControls
//
//  Created by MartinLee on 17/2/7.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwSAXToParserXML.h"
#import "pwXMLModel.h"

@interface pwSAXToParserXML () <NSXMLParserDelegate>

@property(nonatomic,strong) NSMutableArray *videos;
@property(nonatomic,strong) pwXMLModel *xmlModel;
@property(nonatomic,copy) NSMutableString *mString;

@end

@implementation pwSAXToParserXML

- (NSMutableArray *)videos{
    if(_videos == nil){
        _videos = [NSMutableArray array];
    }
    return _videos;
}

- (NSMutableString *)mString{
    if(_mString == nil){
        _mString = [NSMutableString string];
    }
    return _mString;
}

- (instancetype)init{
    self = [super init];
    if(self){
    }
    return self;
}

- (void)loadXML{
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/videos.xml"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if(connectionError){
            NSLog(@"链接错误 %@",connectionError);
            return;
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200 || httpResponse.statusCode == 304){
            //解析XML,创建XML的解析器
            NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
            //设置代理
            parser.delegate = self;
            //开始解析
            [parser parse];
        }else{
            
        }
    }];
}

//1.开始解析
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    
    NSLog(@"============ Step 1 开始 ===========");
    //移除模型中的数据
    [self.videos removeAllObjects];
}

//2.找开始标签

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    //elementName  标签名称
    //attributeDict 标签的属性
    NSLog(@"============ Step 2 开始标签 %@ -- %@",elementName,attributeDict);
    
    if([elementName isEqualToString:@"video"]){
        self.xmlModel = [pwXMLModel new];
        self.xmlModel.videoId = @([attributeDict[@"videoId"] intValue]);
        [self.videos addObject:self.xmlModel];
    }
    
    [self.mString setString:@""];
}

//3.找标签之间的内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    NSLog(@"============ Step 3 标签间的内容 %@",string);
    [self.mString appendString:string];
}

//4.找结束标签
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    NSLog(@"============ Step 4 结束标签 %@",elementName);
    
    if(![elementName isEqualToString:@"video"] && ![elementName isEqualToString:@"videos"]){
        [self.xmlModel setValue:self.mString forKey:elementName];
    }
}

//5.结束解析
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"============ Step 5 结束 %@",self.videos);
}

//6.错误
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"============= Step 6 错误");
}
@end
