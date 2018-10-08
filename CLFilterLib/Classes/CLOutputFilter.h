//
//  CLOutputFilter.h
//  tiaooo
//
//  Created by ClaudeLi on 15/12/27.
//  Copyright © 2015年 dali. All rights reserved.
//

#import "GPUImageFilterGroup.h"

@class GPUImagePicture;


@interface CLOutputFilter: GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

- (instancetype)init __deprecated_msg("Used 'initWithFileName'");
- (instancetype)initWithFileName:(NSString *)fileName;

@end
