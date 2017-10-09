//
//  VedioModel.h
//  LJMediaPalyer
//
//  Created by 孙伟伟 on 2017/10/8.
//  Copyright © 2017年 孙伟伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VedioModel : NSObject

@property(nonatomic, copy)NSString *imageUrlstr;

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *videoUrlStr;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end
