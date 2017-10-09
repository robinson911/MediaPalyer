//
//  LJMQTT.m
//  LJMediaPalyer
//
//  Created by 孙伟伟 on 2017/4/23.
//  Copyright © 2017年 孙伟伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJMQTTKit.h"
#import "MQTTKit.h"

@interface LJMQTTKit ()

@property (nonatomic, strong) NSTimer *ljTimer;
@property (nonatomic, strong) MQTTClient *client;
@property (nonatomic, strong) NSMutableArray *ljMessageArray;


@end

@implementation LJMQTTKit

#pragma mark -- 断开连接
- (void)disconnectLJMQTTKit
{
    // disconnect the MQTT client
    [self.client disconnectWithCompletionHandler:^(NSUInteger code)
     {
        NSLog(@"MQTT is disconnected");
    }];
    
    [_ljTimer invalidate];
    _ljTimer = nil;
}

- (instancetype)initMqttByServerHost:(NSString*)hostStr
{
    self = [super init];
    if (self)
    {
        if (!_ljMessageArray)
        {
            _ljMessageArray = [[NSMutableArray alloc]init];
        }
        
        if (!_ljTimer)
        {
            _ljTimer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(dealWithMessage) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop]addTimer:_ljTimer forMode:NSDefaultRunLoopMode];
        }

        [self connectMqttSerive:hostStr];
    }
    return self;
}

#pragma mark -- 连接服务器
- (void)connectMqttSerive:(NSString*)hostStr
{
    // create the MQTT client with an unique identifier
    NSString *clientID = [UIDevice currentDevice].identifierForVendor.UUIDString;
    self.client = [[MQTTClient alloc] initWithClientId:clientID];
    
    // connect the MQTT client
    [self.client connectToHost:hostStr completionHandler:^(MQTTConnectionReturnCode code)
     {
         if (code == ConnectionAccepted)
         {
             // The client is connected when this completion handler is called
             NSLog(@"client is connected with id %@", clientID);
             [self subscribeTop:kTopic];
         }
     }];
    
    //获取话题消息回调
    [self handleMqttMessage];
}

#pragma mark -- 订阅话题
- (void)subscribeTop:(NSString*)topicStr
{
    // Subscribe to the topic
    [self.client subscribe:topicStr withCompletionHandler:^(NSArray *grantedQos)
     {
         NSLog(@"subscribed to topic %@", kTopic);
     }];
}

#pragma mark -- 发布
- (void)publishString:(NSString*)payload
{
    // use the MQTT client to send a message with the switch status to the topic
    [self.client publishString:payload
                       toTopic:kTopic
                       withQos:AtMostOnce
                        retain:YES
             completionHandler:nil];
}

#pragma mark -- Received MQTT Message
- (void)handleMqttMessage
{
    // define the handler that will be called when MQTT messages are received by the client
    @myWeakify(self);
    [self.client setMessageHandler:^(MQTTMessage *message)
     {
         @myStrongify(self);
         
         NSLog(@"received message %@", message.payloadString);
         [self.ljMessageArray addObject:message.payloadString];
     }];
}

/** 定时处理MQTT的消息*/
- (void)dealWithMessage
{
    if (self.handleMQTTMessage)
    {
        if (self.ljMessageArray.count > 0)
        {
            self.handleMQTTMessage([self.ljMessageArray mutableCopy]);
            [self.ljMessageArray removeAllObjects];
        }
    }
}

@end

