//
//  CHUtil.h
//  TransfarDriver
//
//  Created by 孙伟伟 on 15/6/26.
//  Copyright (c) 2015年 Transfar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CHUtil : NSObject


+ (CHUtil *)sharedInstance;

+ (CGSize)ljGetTextSize:(NSString*)str;

+ (CGSize)widthForString:(NSString *)value;

//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width;

/**
 * @brief   获取当前系统时间。
 */
+ (NSString *) currentSystemTime;

/**
 * @brief   将毫秒数转换成时间
 */
+(NSString *) ConvertSecToTime:(NSString *)timeStr;

/**
 * @brief   颜色转换 IOS中十六进制的颜色转换为UIColor
 */
+ (UIColor *) colorWithHexString: (NSString *) hexString;

/**
 * @brief   验证手机号码。
 */
+ (BOOL) validateMobile:(NSString *)mobileNum;

/** 
 *  @author Kevin 2015-07-09 16:20
 *
 *  @brief 根据字符串动态计算lable的宽度
 */
+ (float) widthForString:(NSString *)value andHeight:(float)height;

/**
 * @brief   根据传入的字符串和字体大小来返回text的CGSize
 */
+ (CGSize)getTextCGSize:(NSString*)str Font :(UIFont*)font;

/**
 * 功能:验证身份证是否合法
 * 参数:输入的身份证号
 */
+ (BOOL) chk18PaperId:(NSString *) sPaperId;

/**
 * @brief   获取设备udid
 */
+ (NSString *) deviceID;

/**
 * @brief   替换现有的字符串，单个字符替换
 *
 * example  13989809140    用* 替换后为 139****9140
 *
 * @pram   oldString  被替换的字符串
 * @pram   num        将被替换的单个字符的个数
 * @pram   location   替换的起始位置
 * @pram   NewChar    将替换的单字符
 */
+ (NSString*) replaceCharacters:(NSString*)oldString
                      number:(NSInteger)num
                    Location:(NSInteger)location
                  withString:(NSString*)NewChar;


/**
 * @brief   md5加密
 */
+ (NSString *) md5:(NSString *)inPutText;

/*对话框*/
+ (void)showDialog :(NSString*)msg;

//保存图片到本地
+ (NSString*) saveImage:(UIImage *)currentImage withName:(NSString *)imageName;

//创建文件夹
+ (void)createFileDirWithName:(NSString*)dirName;

//删除所有png的图片
+ (void)deleteAllFileWithExtensionName:(NSString*)extensionName FileDir:(NSString*)FileDirStr;

+ (void) loadALLfileWithPath:(NSString*)pathStr;

//返回该目录下的所有文件名字
+ (NSArray*) allFilesAtPath:(NSString*) dirString;

//删除指定文件夹目录下的文件，根据文件名
+ (void)deleteFileByName:(NSString*)fileNameStr FileDir:(NSString*)FileDirStr;

//是否是图片Url
+ (BOOL)isPictureByUrl:(NSString*)ljUrlStr;

/**
 * dispatch block to main thread.
 */
void dispatchToMain (dispatch_block_t block);


@end









