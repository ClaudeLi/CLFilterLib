//
//  UIImage+CLFilter.h
//  CLFilterLib
//
//  Created by ClaudeLi on 2018/9/30.
//

#import <UIKit/UIKit.h>
#import "CLFilterVideoProcessingDelegate.h"

FOUNDATION_EXTERN NSBundle *CLFilterBundle(void);

@interface UIImage (CLFilter)

- (UIImage *)imageFilterWithStyle:(CLFilterStyle)style;

+ (UIImage *)imageInCFilterBundleWithNamed:(NSString *)named;

@end
