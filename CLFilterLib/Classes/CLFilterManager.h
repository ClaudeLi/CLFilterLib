//
//  CLFilterManager.h
//  tiaooo
//
//  Created by ClaudeLi on 15/12/27.
//  Copyright © 2015年 dali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GPUImage/GPUImage.h>
#import "CLFilterVideoProcessingDelegate.h"

FOUNDATION_EXTERN NSString *CreateTempVideoPath(void);

@interface CLFilterManager : NSObject

/**
 图片滤镜
 
 @param image 图片
 @param style 滤镜风格
 @param enabledBeauty 开启美颜
 @return 带滤镜图片
 */
+ (UIImage *)imageFilterWithImage:(UIImage *)image
                            style:(CLFilterStyle)style
                    enabledBeauty:(BOOL)enabledBeauty;


/**
 获取视频组合滤镜
 
 @param movieFile movieFile
 @param style 滤镜风格
 @param enabledBeauty 开启美颜
 @return 组合滤镜
 */
+ (GPUImageOutput<GPUImageInput> *)getFilterWithMovieFile:(GPUImageMovie *)movieFile
                                                    style:(CLFilterStyle)style
                                            enabledBeauty:(BOOL)enabledBeauty;

+ (instancetype)new __deprecated_msg("Using 'init'");

@property (nonatomic, weak) id<CLFilterVideoProcessingDelegate>delegate;

@property (nonatomic, assign) BOOL recode;
@property (nonatomic, assign) BOOL enabledBeauty;

- (void)addFilterWithStyle:(CLFilterStyle)style
                  inputURL:(NSURL *)inputURL
                outputPath:(NSString *)outputPath;

- (void)onError;
- (void)clearMemory;

@end
