//
//  LJMQTTKit.h
//  LJMediaPalyer
//
//  Created by 孙伟伟 on 2017/4/23.
//  Copyright © 2017年 孙伟伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJMQTTKit : NSObject

/** 订阅的消息回调*/
@property (nonatomic, copy) void (^handleMQTTMessage)(NSArray *messageArray);

/** 连接服务器*/
- (instancetype)initMqttByServerHost:(NSString*)hostStr;

/** 发布话题*/
- (void)publishString:(NSString*)payload;

/** 订阅话题*/
- (void)subscribeTop:(NSString*)topicStr;

/** 断开连接*/
- (void)disconnectLJMQTTKit;

@end
