//
//  CHUtil.m
//  TransfarDriver
//
//  Created by 孙伟伟 on 15/6/26.
//  Copyright (c) 2015年 Transfar. All rights reserved.
//

#import "CHUtil.h"
//#import "UIDevice+IdentifierAddition.h"
#import <UIKit/UIView.h>
#import "CommonCrypto/CommonDigest.h"
#import <CoreText/CoreText.h>

@implementation CHUtil

#pragma mark --sharedInstance

+ (CHUtil *)sharedInstance
{
    static dispatch_once_t  onceToken;
    static CHUtil * sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[CHUtil alloc] init];
    });
    return sSharedInstance;
}

+(NSString *)ConvertSecToTime:(NSString *)timeStr
{
    long long time=[timeStr longLongValue];
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString*timeString=[formatter stringFromDate:d];
    return timeString;
}

+ (NSString *)currentSystemTime
{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"HH:mm:ss"];
    
    NSString *strTime = [formatter stringFromDate:date];
    
    return strTime;
    
}


#pragma mark ----颜色转换 IOS中十六进制的颜色转换为UIColor----
CGFloat alpha, red, blue, green;
+ (UIColor *) colorWithHexString: (NSString *) hexString
{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#"withString: @""] uppercaseString];
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
            
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            return [UIColor colorWithRed: 00 green: 00 blue: 00 alpha: 00];

            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

#pragma mark------NSString转换成UICololr----------
+ (CGFloat) colorComponentFrom: (NSString *) string
                         start: (NSUInteger) start
                         length: (NSUInteger) length
{
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

#pragma mark----------验证手机号码-----------
+ (BOOL)validateMobile:(NSString *)mobileNum
{
    //手机号以13， 15，18, 14, 17开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(14[0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobileNum];
}


+ (CGSize)widthForString:(NSString *)value
{
    //获取当前文本的属性
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:value];
    NSRange range = NSMakeRange(0, attrStr.length);
    // 获取该段attributedString的属性字典
    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    // 计算文本的大小
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                        attributes:dic        // 文字的属性
                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    return sizeToFit;
}

//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:loadFont(14)} context:nil];
    
    return rect.size.height;
}

+ (CGSize)ljGetTextSize:(NSString*)str
{
    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;//默认居中水平居中
    NSDictionary *attributes = @{
                                 NSFontAttributeName: loadFont(14) ? : [UIFont systemFontOfSize:[UIFont buttonFontSize]],
                                 NSForegroundColorAttributeName : [UIColor blackColor] ? : [UIColor blackColor],
                                 NSParagraphStyleAttributeName : style};
    
    //获取当前文本的属性
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:str attributes:attributes];
    
    CTFramesetterRef framesetter =   CTFramesetterCreateWithAttributedString((__bridge  CFAttributedStringRef)attrStr);
    CGSize targetSize = CGSizeMake(kScreenWidth - 30, CGFLOAT_MAX);
    CGSize fitSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [str length]), NULL, targetSize, NULL);
    CFRelease(framesetter);
    
    return fitSize;
}

//+ (CGSize) getTextCGSize :(NSString*)str Font :(UIFont*)font{
// CGSize textSize = [str sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
//    return textSize;
//}


/**
 * 功能:获取指定范围的字符串
 * 参数:字符串的开始小标
 * 参数:字符串的结束下标
 */

+ (NSString *)getStringWithRange:(NSString *)str
                          Value1:(int)value1
                          Value2:(int)value2;
{
    return [str substringWithRange:NSMakeRange(value1,value2)];
}

/**
 * 功能:判断是否在地区码内
 * 参数:地区码
 */
+ (BOOL)areaCode:(NSString *)code
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"北京" forKey:@"11"];
    [dic setObject:@"天津" forKey:@"12"];
    [dic setObject:@"河北" forKey:@"13"];
    [dic setObject:@"山西" forKey:@"14"];
    [dic setObject:@"内蒙古" forKey:@"15"];
    [dic setObject:@"辽宁" forKey:@"21"];
    [dic setObject:@"吉林" forKey:@"22"];
    [dic setObject:@"黑龙江" forKey:@"23"];
    [dic setObject:@"上海" forKey:@"31"];
    [dic setObject:@"江苏" forKey:@"32"];
    [dic setObject:@"浙江" forKey:@"33"];
    [dic setObject:@"安徽" forKey:@"34"];
    [dic setObject:@"福建" forKey:@"35"];
    [dic setObject:@"江西" forKey:@"36"];
    [dic setObject:@"山东" forKey:@"37"];
    [dic setObject:@"河南" forKey:@"41"];
    [dic setObject:@"湖北" forKey:@"42"];
    [dic setObject:@"湖南" forKey:@"43"];
    [dic setObject:@"广东" forKey:@"44"];
    [dic setObject:@"广西" forKey:@"45"];
    [dic setObject:@"海南" forKey:@"46"];
    [dic setObject:@"重庆" forKey:@"50"];
    [dic setObject:@"四川" forKey:@"51"];
    [dic setObject:@"贵州" forKey:@"52"];
    [dic setObject:@"云南" forKey:@"53"];
    [dic setObject:@"西藏" forKey:@"54"];
    [dic setObject:@"陕西" forKey:@"61"];
    [dic setObject:@"甘肃" forKey:@"62"];
    [dic setObject:@"青海" forKey:@"63"];
    [dic setObject:@"宁夏" forKey:@"64"];
    [dic setObject:@"新疆" forKey:@"65"];
    [dic setObject:@"台湾" forKey:@"71"];
    [dic setObject:@"香港" forKey:@"81"];
    [dic setObject:@"澳门" forKey:@"82"];
    [dic setObject:@"国外" forKey:@"91"];
    
    if ([dic objectForKey:code] == nil)
    {
        return NO;
    }
    return YES;
}

/**
 * 功能:验证身份证是否合法
 * 参数:输入的身份证号
 */
+ (BOOL) chk18PaperId:(NSString *) sPaperId
{
    //判断位数
    if ([sPaperId length] != 15 && [sPaperId length] != 18)
    {
        return NO;
    }
    NSString *carid = sPaperId;
    long lSumQT =0;
    //加权因子
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    //校验码
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    //将15位身份证号转换成18位
    NSMutableString *mString = [NSMutableString stringWithString:sPaperId];
    if ([sPaperId length] == 15) {
        [mString insertString:@"19" atIndex:6];
        long p = 0;
        const char *pid = [mString UTF8String];
        for (int i=0; i<=16; i++)
        {
            p += (pid[i]-48) * R[i];
        }
        int o = p%11;
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        carid = mString;
    }
    //判断地区码
    NSString * sProvince = [carid substringToIndex:2];
    if (![self areaCode:sProvince]) {
        return NO;
    }
    //判断年月日是否有效
    //年份
    int strYear = [[self getStringWithRange:carid Value1:6 Value2:4] intValue];
    //月份
    int strMonth = [[self getStringWithRange:carid Value1:10 Value2:2] intValue];
    //日
    int strDay = [[self getStringWithRange:carid Value1:12 Value2:2] intValue];
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeZone:localZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
    if (date == nil) {
        return NO;
    }
    const char *PaperId  = [carid UTF8String];
    //检验长度
    if( 18 != strlen(PaperId)) return -1;
    //校验数字
    for (int i=0; i<18; i++)
    {
        if ( !isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i) )
        {
            return NO;
        }
    }
    //验证最末的校验码
    for (int i=0; i<=16; i++)
    {
        lSumQT += (PaperId[i]-48) * R[i];
    }
    if (sChecker[lSumQT%11] != PaperId[17] )
    {
        return NO;
    }
    return YES;
}

//+ (NSString *) deviceID
//{
//    return [[[UIDevice currentDevice] uniqueDeviceIdentifier] substringToIndex:14];
//}

+ (NSString*)replaceCharacters:(NSString*)oldString
                        number:(NSInteger)num
                      Location:(NSInteger)location
                    withString:(NSString*)NewChar
{
    NSRange NuRange;
    
    NSMutableString *str = [[NSMutableString alloc]initWithString:oldString];
    
    for (NSInteger i = 0; i < num; i++)
    {
        NuRange.location = location+i;
        NuRange.length = 1;
        [str replaceCharactersInRange:NuRange withString:NewChar];
    }
    
    return  str;
}

+ (NSString *) md5:(NSString *)inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

+ (void)showDialog :(NSString*)msg
{
    UIAlertView *dialog = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [dialog show];
}

#pragma mark -- 文件

//保存图片至沙盒
+ (NSString*) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ImageCaches"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    
    return fullPath;
}

+ (void)createFileDirWithName:(NSString*)dirName
{
    // NSString *imageDir = [NSString stringWithFormat:@"%@/Documents/ImageCaches", NSHomeDirectory()];
    NSString *imageDir = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(),dirName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (void)deleteAllFileWithExtensionName:(NSString*)extensionName FileDir:(NSString*)FileDirStr
{
    NSString *extension = extensionName;//@"png";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // NSString *documentsDirectory = [NSString stringWithFormat:@"%@/Documents/ImageCaches", NSHomeDirectory()];
    NSString *documentsDirectory = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(),FileDirStr];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject]))
    {
        if ([[filename pathExtension] isEqualToString:extension])
        {
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
    }
}


+ (void) loadALLfileWithPath:(NSString*)pathStr
{
    /*NSFileManager *fileManager = [NSFileManager defaultManager];
     NSError *error = nil;
     NSArray *fileList = [[NSArray alloc] init];
     
     //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
     fileList = [fileManager contentsOfDirectoryAtPath:pathStr error:&error];
     NSLog(@"路径==%@,fileList%@",pathStr,fileList);*/
    
}

+ (NSArray*) allFilesAtPath:(NSString*)dirName
{
    NSString *dirString = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(),dirName];
    
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:10];
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    
    NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:dirString error:nil];
    
    for (NSString* fileName in tempArray)
    {
        BOOL flag = YES;
        
        NSString* fullPath = [dirString stringByAppendingPathComponent:fileName];
        
        if ([fileMgr fileExistsAtPath:fullPath isDirectory:&flag])
        {
            if (!flag)
            {
                //[array addObject:fullPath];
                [array addObject:fileName];
            }
        }
    }
    
    return array;
}

+ (void)deleteFileByName:(NSString*)fileNameStr FileDir:(NSString*)FileDirStr
{
    //删除文件夹及文件级内的文件：
    NSString *fileName = [NSString stringWithFormat:@"%@/Documents/%@/%@", NSHomeDirectory(),FileDirStr,fileNameStr];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager removeItemAtPath:fileName error:nil])
    {
        NSLog(@"文件删除成功");
    }
}

//是否是图片Url
+ (BOOL)isPictureByUrl:(NSString*)ljUrlStr
{
    if ([ljUrlStr hasSuffix:@".png"]  || [ljUrlStr hasSuffix:@".jpg"] || [ljUrlStr hasSuffix:@".PNG"] || [ljUrlStr hasSuffix:@".JPG"])
    {
        return YES;
    }
    return NO;
}

void dispatchToMain (dispatch_block_t block)
{
    if ([NSThread isMainThread]) {
        block();
    }else{
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

+ (CGSize)getTextCGSize :(NSString*)str Font :(UIFont*)font
{
    CGSize size = [str sizeWithAttributes:@{NSFontAttributeName:font}];
    return size;
}

@end
