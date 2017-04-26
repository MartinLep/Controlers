//
//  pwSocket.m
//  pwControls
//
//  Created by MartinLee on 17/2/8.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwSocket.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@interface pwSocket ()

@property (nonatomic,assign)int clientSocket;

@end

@implementation pwSocket

- (NSString *)createSocket{
    BOOL result = [self connet:@"127.0.0.1" port:6666];
    if(!result){
        NSLog(@"error");
        return @"error";
    }
    //http 请求头
//    NSString *request = @"GET / HTTP/1.1\r\n"
//    "Host: www.baidu.com\r\n"
//    "User-Agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.76 Mobile Safari/537.36\r\n"
//    "Connection: close\r\n\r\n";
    
    NSString *request = @"Socket";
    //服务器返回响应
    NSString *respose = [self sendAndRecv:request];
    NSLog(@"respose = %@",respose);
    //关闭连接
    close(self.clientSocket);
    
    //截取响应头，响应头结束的表示\r\n\r\n

    NSRange range = [respose rangeOfString:@"\r\n\r\n"];
    //从range之后的第一个位置开始截取字符串，响应体
    NSString *html = [respose substringFromIndex:range.length+range.location-1];
    return html;
}

- (BOOL)connet:(NSString *)ip port:(int)port{
    //1.创建socket
    //domain 协议簇 制定IPv4
    //type socket的类型 流式socket，数据报socket
    //protocol 协议
    int clientSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    self.clientSocket = clientSocket;
    //2.连接服务器
    
    //socket的描述符
    //结构体 ip地址和端口
    //结构体的长度
    
    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = inet_addr(ip.UTF8String);
    addr.sin_port = htons(port);
    
    int resule = connect(clientSocket, (const struct sockaddr *)&addr, sizeof(addr));
    if(resule == 0) return YES;
    else return NO;
}

- (NSString *)sendAndRecv:(NSString *)sendMsg{
    //3.向服务器发送数据
    //第二个参数 发送数据的缓冲区
    //第三个参数，发送数据的字符数
    //最后一个参数一般为0
    const char *msg = sendMsg.UTF8String;
    ssize_t sendCount = send(self.clientSocket, msg, strlen(msg), 0);// 发送的字节数
    NSLog(@"sendCount = %zd",sendCount);
    
    //4.接收服务器返回的数据
    //返回实际接收的字节数
    uint8_t buffer[1024];
    NSMutableData *mData = [NSMutableData data];
    ssize_t recvCount = recv(self.clientSocket, buffer, sizeof(buffer), 0);
    [mData appendBytes:buffer length:recvCount];
    NSLog(@"实际接收的字节数= %zd,buffer = %s",recvCount,buffer);
    while (recvCount != 0) {
        recvCount = recv(self.clientSocket, buffer, sizeof(buffer), 0);
        [mData appendBytes:buffer length:recvCount];
    }
    NSString *recvMsg = [[NSString alloc] initWithData:mData encoding:NSUTF8StringEncoding];
    return recvMsg;
}
@end
