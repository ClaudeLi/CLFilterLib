//
//  CLOutputFilter.m
//  tiaooo
//
//  Created by ClaudeLi on 15/12/27.
//  Copyright © 2015年 ClaudeLi. All rights reserved.
//

#import "CLOutputFilter.h"
#import "GPUImagePicture.h"
#import "GPUImageLookupFilter.h"
#import "UIImage+CLFilter.h"

@implementation CLOutputFilter

- (instancetype)init{
    if (!(self = [super init]))
    {
        return nil;
    }
    return self;
}

- (instancetype)initWithFileName:(NSString *)fileName{
    if (!(self = [super init]))
    {
        return nil;
    }
    NSString *file = [NSString stringWithFormat:@"Filter_%@", fileName];
    NSString *path = [CLFilterBundle() pathForResource:[file stringByAppendingPathComponent:@"config"] ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        return nil;
    }
    if (![dict[@"content"] allKeys].count) {
        return nil;
    }
    NSString *filterName = [dict[@"content"] allKeys].firstObject;
    NSDictionary *filterObj = dict[@"content"][filterName];
    if (![filterObj isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSString *imageName = [[file stringByAppendingPathComponent:filterName] stringByAppendingPathComponent:filterName];
    
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
    UIImage *image = [UIImage imageInCFilterBundleWithNamed:imageName];
#else
    NSImage *image = [NSImage imageInCFilterBundleWithNamed:imageName];
#endif
    
    NSAssert(image, @"To use CLAmatorkaFilter you need to add file from CLFilterLib/Resources to your application bundle.");
    
    lookupImageSource = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageLookupFilter *lookupFilter = [[GPUImageLookupFilter alloc] init];
    if (filterObj[@"intensity"]) {
        lookupFilter.intensity = [filterObj[@"intensity"] floatValue];        
    }
    [self addFilter:lookupFilter];
    
    [lookupImageSource addTarget:lookupFilter atTextureLocation:1];
    [lookupImageSource processImage];
    
    self.initialFilters = [NSArray arrayWithObjects:lookupFilter, nil];
    self.terminalFilter = lookupFilter;
    
    return self;
}

#pragma mark -
#pragma mark Accessors
@end
