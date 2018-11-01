//
//  Utile.m
//  SYChuangKeProject
//
//  Created by 朱佳男 on 16/6/29.
//  Copyright © 2016年 ShangYuKeJi. All rights reserved.
//

#import "Utile.h"

@implementation Utile
+(void)addClickEvent:(id)target action:(SEL)action owner:(UIView *)view
{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    gesture.numberOfTouchesRequired = 1;
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:gesture];
}
+(void)makeCorner:(CGFloat)corner view:(UIView *)view
{
    CALayer *layer = view.layer;
    layer.cornerRadius = corner;
    layer.masksToBounds = YES;
}
+(void)makecorner:(CGFloat)corner view:(UIView *)view color:(UIColor *)color
{
    CALayer *layer = view.layer;
    layer.borderColor = color.CGColor;
    layer.borderWidth = corner;
}
+(void)setFourSides:(UIView *)view direction:(NSString *)direction sizeW:(CGFloat)width color:(UIColor *)color
{
    if ([direction isEqualToString:@"left"]) {
        UIView *bottomview = [[UIView alloc] initWithFrame:CGRectMake(0, (view.frame.size.height-width)/2.0f, 0.5, width)];
        bottomview.backgroundColor = color;
        [view addSubview:bottomview];
    }else if ([direction isEqualToString:@"right"])
    {
        UIView *bottomview = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width - 0.5, (view.frame.size.height-width)/2.0f, 0.5, width)];
        bottomview.backgroundColor = color;
        [view addSubview:bottomview];
    }else if ([direction isEqualToString:@"top"])
    {
        UIView *bottomview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 0.5)];
        bottomview.backgroundColor = color;
        [view addSubview:bottomview];
    }else if ([direction isEqualToString:@"bottom"])
    {
        UIView *bottomview = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 0.5, width, 0.5)];
        bottomview.backgroundColor = color;
        [view addSubview:bottomview];
    }
}
+(void)setUILabel:(UILabel *)label data:(NSString *)data setData:(NSString *)setData color:(UIColor *)color font:(CGFloat)font underLine:(BOOL)isbool
{
    NSRange range = [label.text rangeOfString:setData];
    if (range.location != NSNotFound) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:label.text];
        [string addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(data.length, setData.length)];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(data.length, setData.length)];
        if (isbool) {
            [string addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(data.length, setData.length)];
        }
        label.attributedText = string;
    }
}

+(CGFloat)returnViewFrame:(UIView *)view direction:(NSString *)direction
{
    if ([direction isEqualToString:@"X"]) {
        return view.frame.origin.x+view.frame.size.width;
    }else
    {
        return view.frame.origin.y+view.frame.size.height;
    }
}
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;}

#pragma mark 判断字符是否为空
+ (BOOL)stringIsNilZero:(NSString *)strings{
    if ([strings isEqualToString:@""]||[strings isEqualToString:@"(null)"]||[strings isEqualToString:@"<null>"]||(strings.length == 0)) {
        return YES;
    }else{
        return NO;
    }
    
}
+ (UIImage *)drawTabbarItemBackGroundImageWithSIze:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    CGContextRef cts = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(cts, 10.0/255,189.0/255,245.0/255,1);
    CGContextFillRect(cts, CGRectMake(0, 0, size.width, size.height));
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//用颜色创建一张图片
+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
//UIImage大小变更
+ (UIImage*)resizeImage:(UIImage *)img rect:(CGRect)rect{
    
    UIGraphicsBeginImageContext(rect.size);
    [img drawInRect:rect];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}
+ (CGSize)getStrSize:(NSString *)textStr andTexFont:(UIFont *)font andMaxSize:(CGSize)maxSize

{
    NSDictionary *textAttDict = @{NSFontAttributeName : font};
    return [textStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttDict context:nil].size;
    
}
+ (UIImage *)imageWithMediaURL:(NSURL *)url {
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    // 初始化媒体文件
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    // 根据asset构造一张图
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    // 设定缩略图的方向
    // 如果不设定，可能会在视频旋转90/180/270°时，获取到的缩略图是被旋转过的，而不是正向的（自己的理解）
    generator.appliesPreferredTrackTransform = YES;
    // 设置图片的最大size(分辨率)
    generator.maximumSize = CGSizeMake(600, 450);
    // 初始化error
    NSError *error = nil;
    // 根据时间，获得第N帧的图片
    // CMTimeMake(a, b)可以理解为获得第a/b秒的frame
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 10000) actualTime:NULL error:&error];
    // 构造图片
    UIImage *image = [UIImage imageWithCGImage: img];
    return image;
}
@end
