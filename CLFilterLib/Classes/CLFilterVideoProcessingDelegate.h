//
//  CLFilterVideoProcessingDelegate.h
//  CLFilterLib
//
//  Created by ClaudeLi on 2018/9/29.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CLFilterStyle) {
    CLFilterStyleNone     = 0,
    CLFilterStyleMissEtikate,
    CLFilterStyleSoftElegance,
    CLFilterStyleSexy,
    CLFilterStyleLomo,
    CLFilterStyleBlackWhite,
    CLFilterStyleAmatorka,
    CLFilterStyleSepia,
};

@class CLFilterManager;
@protocol CLFilterVideoProcessingDelegate <NSObject>

// 处理完成
- (void)filterManager:(CLFilterManager *)filterManager didFinishURL:(NSURL *)videoURL;

// 处理进度
- (void)filterManager:(CLFilterManager *)filterManager dealProgress:(CGFloat)progress;

// 处理失败
- (void)filterManager:(CLFilterManager *)filterManager didFailure:(NSString *)failure;

@end
