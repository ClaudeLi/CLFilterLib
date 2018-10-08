//
//  UIImage+CLFilter.m
//  CLFilterLib
//
//  Created by ClaudeLi on 2018/9/30.
//

#import "UIImage+CLFilter.h"
#import "CLFilterManager.h"

NSBundle *CLFilterBundle(){
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[CLFilterManager class]] pathForResource:@"CLFilters" ofType:@"bundle"]];
    }
    return bundle;
}

@implementation UIImage (CLFilter)

- (UIImage *)imageFilterWithStyle:(CLFilterStyle)style{
    return [CLFilterManager imageFilterWithImage:self style:style];
}

+ (UIImage *)imageInCFilterBundleWithNamed:(NSString *)named{
    return [UIImage imageWithContentsOfFile:[CLFilterBundle() pathForResource:named ofType:@"png"]];
}

@end
