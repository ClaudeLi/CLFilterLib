//
//  CLFilterManager.m
//  tiaooo
//
//  Created by ClaudeLi on 15/12/27.
//  Copyright © 2015年 ClaudeLi. All rights reserved.
//

#import "CLFilterManager.h"
#import "CLOutputFilter.h"

NSString *CreateTempVideoPath(){
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *str = [NSString stringWithFormat:@"%.0f.mp4", time*1000];
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:str];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    return path;
}

static CGFloat LVignetteStart = 0.4;
static CGFloat LVignetteEnd = 1.0;

@interface CLFilterManager ()<GPUImageMovieWriterDelegate>{
    BOOL    _isCancel;
    CGFloat _progress;
}

@property (strong, nonatomic) GPUImageMovie *movieFile;
@property (strong, nonatomic) GPUImageOutput<GPUImageInput> *filter;
@property (strong, nonatomic) GPUImageMovieWriter   *movieWriter;
@property (strong, nonatomic) AVAssetExportSession  *exportSession;
@property (nonatomic, strong) NSTimer *timerEffect;

@end

@implementation CLFilterManager

+ (UIImage *)imageFilterWithImage:(UIImage *)image style:(CLFilterStyle)style{
    UIImage *filterImage = image;
//    struct GPUVector3  color;
//    color.one = 38/255;
//    color.two = 38/255;
//    color.three = 38/255;
//    switch (style) {
//        case 0:
//            break;
//        case 7:
//        {
//            // Old school
//            GPUImageSepiaFilter *filter = [[GPUImageSepiaFilter alloc]init];
//            filterImage = [filter imageByFilteringImage:image];
//        }
//            break;
//        case 8:
//        {
//            //锐化
//            GPUImageSharpenFilter *filt = [[GPUImageSharpenFilter alloc]init];
//            filt.sharpness = 4;
//            filterImage = [filt imageByFilteringImage:image];
//        }
//            break;
//        case 9:
//        {
//            //#import "GPUImageGaussianSelectiveBlurFilter.h" //高斯模糊，选择部分清晰
//            GPUImageGaussianSelectiveBlurFilter *filt = [[GPUImageGaussianSelectiveBlurFilter alloc]init];
//            filt.excludeCircleRadius = 0.8;
//            filt.blurRadiusInPixels = 10;
//            filterImage = [filt imageByFilteringImage:image];
//        }
//            break;
//        case 10:
//        {
//            //#import "GPUImageLowPassFilter.h" //用于图像加亮
//            GPUImageLowPassFilter *filt = [[GPUImageLowPassFilter alloc]init];
//            filterImage = [filt imageByFilteringImage:image];
//        }
//            break;
//        case 11:
//        {
//            //"GPUImageBulgeDistortionFilter.h" //凸起失真，鱼眼效果 #import "GPUImagePinchDistortionFilter.h" //收缩失真，凹面镜 #import
//            // #import "GPUImageSwirlFilter.h" //漩涡，中间形成卷曲的画面 #import"GPUImageStretchDistortionFilter.h" //伸展失真，哈哈镜
//            //#import "GPUImageGlassSphereFilter.h" //水晶球效果 #import "GPUImageSphereRefractionFilter.h" //球形折射，图形倒立
//            GPUImageBulgeDistortionFilter *filt = [[GPUImageBulgeDistortionFilter alloc]init];
//            filt.radius = 0.5; // 失真半径
//            filt.scale = 0.2; // 变形量
//            filterImage = [filt imageByFilteringImage:image];
//        }
//            break;
//        case 12:
//        {
//            //GPUImageSketchFilter.h" //素描
//            GPUImageSketchFilter *filt = [[GPUImageSketchFilter alloc]init];
//            filterImage = [filt imageByFilteringImage:image];
//        }
//            break;
//        default:
//            break;
//    }
    if (style > 0) {
        style+=100;
        NSString *index = [NSString stringWithFormat:@"%ld", (long)style];
        CLOutputFilter *filter = [[CLOutputFilter alloc] initWithFileName:index];
        filterImage = [filter imageByFilteringImage:image];
//        GPUImageVignetteFilter *filt1 = [[GPUImageVignetteFilter alloc]init];
//        filt1.vignetteColor = color;
//        filt1.vignetteStart = VignetteStart;
//        filt1.vignetteEnd = VignetteEnd;
//        filterImage = [filt1 imageByFilteringImage:filterImage];
    }
    return filterImage;
}


+ (GPUImageOutput<GPUImageInput> *)getFilterWithMovieFile:(GPUImageMovie *)movieFile style:(CLFilterStyle)style{
    
    GPUImageFilter *filter = [[GPUImageFilter alloc]init];
    
    struct GPUVector3  color;
    color.one = 38/255;
    color.two = 38/255;
    color.three = 38/255;
    GPUImageVignetteFilter *filt1 = [[GPUImageVignetteFilter alloc]init];
    filt1.vignetteColor = color;
    filt1.vignetteStart = LVignetteStart;
    filt1.vignetteEnd = LVignetteEnd;
    
    switch (style) {
        case 0:
        {
            // 原
            GPUImageFilter *filt = [[GPUImageFilter alloc]init];
            filt1.vignetteStart = 1;
            filt1.vignetteEnd = 1;
            [movieFile addTarget:filt];
            [filt addTarget:filt1];
        }
            break;
//        case 7:
//        {
//            // Old school
//            GPUImageSepiaFilter *filt = [[GPUImageSepiaFilter alloc]init];
//            [movieFile addTarget:filt];
//            [filt addTarget:filt1];
//        }
//            break;
//        case 8:
//        {
//            //锐化
//            GPUImageSharpenFilter *filt = [[GPUImageSharpenFilter alloc]init];
//            filt.sharpness = 4;
//            [movieFile addTarget:filt];
//            [filt addTarget:filt1];
//        }
//            break;
//        case 9:
//        {
//            //#import "GPUImageGaussianSelectiveBlurFilter.h" //高斯模糊，选择部分清晰
//            GPUImageGaussianSelectiveBlurFilter *filt = [[GPUImageGaussianSelectiveBlurFilter alloc]init];
//            filt.excludeCircleRadius = 0.8;
//            filt.blurRadiusInPixels = 10;
//            [movieFile addTarget:filt];
//            [filt addTarget:filt1];
//        }
//            break;
//        case 10:
//        {
//            //#import "GPUImageLowPassFilter.h" //用于图像加亮
//            GPUImageLowPassFilter *filt = [[GPUImageLowPassFilter alloc]init];
//            [movieFile addTarget:filt];
//            [filt addTarget:filt1];
//        }
//            break;
//        case 11:
//        {
//            //"GPUImageBulgeDistortionFilter.h" //凸起失真，鱼眼效果 #import "GPUImagePinchDistortionFilter.h" //收缩失真，凹面镜 #import
//            // #import "GPUImageSwirlFilter.h" //漩涡，中间形成卷曲的画面 #import"GPUImageStretchDistortionFilter.h" //伸展失真，哈哈镜
//            GPUImageBulgeDistortionFilter *filt = [[GPUImageBulgeDistortionFilter alloc]init];
//            filt.radius = 0.5; // 失真半径
//            filt.scale = 0.15; // 变形量
//            [movieFile addTarget:filt];
//            [filt addTarget:filt1];
//        }
//            break;
//        case 12:
//        {
//            //GPUImageSketchFilter.h" //素描
//            GPUImageSketchFilter *filt = [[GPUImageSketchFilter alloc]init];
//            [movieFile addTarget:filt];
//            [filt addTarget:filt1];
//        }
//            break;
        default:{
            style+=100;
            NSString *index = [NSString stringWithFormat:@"%ld", (long)style];
            CLOutputFilter *filt = [[CLOutputFilter alloc]initWithFileName:index];
            [movieFile addTarget:filt];
            [filt addTarget:filt1];
        }
            break;
    }
    [filt1 addTarget:filter];
    return filt1;
}


#pragma mark --
#pragma mark -- init --
+ (instancetype)new{
    return [super new];
}

- (id)init{
    self = [super init];
    if (self){
        [self clearMemory];
    }
    return self;
}

- (void)clearMemory{
    if (_exportSession){
        _exportSession = nil;
    }
    
    if (_timerEffect)
    {
        [_timerEffect invalidate];
        _timerEffect = nil;
    }
    
    if (_filter) {
        [_filter removeAllTargets];
        _filter = nil;
    }
    
    if (_movieFile)
    {
        [_movieFile removeAllTargets];
        _movieFile = nil;
    }
    
    if (_movieWriter)
    {
        _movieWriter = nil;
    }
    
    if (_exportSession)
    {
        _exportSession = nil;
    }
}


- (void)dealloc{
    [self clearMemory];
    NSLog(@"%s", __func__);
}


- (void)addFilterWithStyle:(CLFilterStyle)style
                  inputURL:(NSURL *)inputURL
                outputPath:(NSString *)outputPath{
    if (_recode) {
        [self recodeWithVideoURL:inputURL outputPath:outputPath style:style];
    }else{
        [self _addFilterWithStyle:style videoUrl:inputURL outputPath:outputPath];
    }
}

- (void)recodeWithVideoURL:(NSURL *)videoURL outputPath:(NSString *)outputPath style:(CLFilterStyle)style{
    [self clearMemory];
    NSString *tempPath = CreateTempVideoPath();
    AVURLAsset *asset = [AVURLAsset assetWithURL:videoURL];
    NSArray *videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if (!videoTracks.count) {
        return;
    }
    AVAssetTrack *videoAssetTrack = [videoTracks objectAtIndex:0];
    // 判断视频方向
    BOOL isVideoAssetPortrait_ = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
    }
    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
    }
    // 视频显示大小
    CGSize renderSize;
    if(isVideoAssetPortrait_){
        renderSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        renderSize = videoAssetTrack.naturalSize;
    }
    // 1. - Create AVMutableVideoCompositionInstruction
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
    
    // 2. - Create an AVMutableVideoCompositionLayerInstruction for the video track and fix the orientation.
    AVMutableVideoCompositionLayerInstruction *videoLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoAssetTrack];
    // 不透明度
    [videoLayerInstruction setOpacity:1.0 atTime:kCMTimeZero];
    
    // 3. - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videoLayerInstruction, nil];
    
    // 4. - Create AVMutableVideoComposition
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    mainCompositionInst.renderSize = renderSize;
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    [videoLayerInstruction setTransform:videoTransform atTime:kCMTimeZero];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    
    self.exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPreset960x540];
    _exportSession.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
    NSURL *exportFileUrl = [NSURL fileURLWithPath:tempPath];
    _exportSession.outputURL = exportFileUrl;
    _exportSession.outputFileType = AVFileTypeMPEG4;
    [_exportSession setVideoComposition:mainCompositionInst];
    [_exportSession setShouldOptimizeForNetworkUse:YES];
    __weak __typeof(&*self) weak_self = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        // Progress monitor for effect
        weak_self.timerEffect = [NSTimer scheduledTimerWithTimeInterval:0.3f
                                                        target:self
                                                      selector:@selector(videoRetrievingProgress)
                                                      userInfo:nil
                                                       repeats:YES];
    });
    [_exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        switch ([weak_self.exportSession status]) {
            case AVAssetExportSessionStatusFailed:{
                [weak_self.timerEffect invalidate];
                weak_self.timerEffect = nil;
                if ([weak_self.delegate respondsToSelector:@selector(filterManager:didFailure:)]) {
                    [weak_self.delegate filterManager:weak_self didFailure:[[weak_self.exportSession error] localizedDescription]];
                }
            }
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"Export canceled");
                break;
            default:{
                [weak_self.timerEffect invalidate];
                weak_self.timerEffect = nil;
                [weak_self _addFilterWithStyle:style videoUrl:exportFileUrl outputPath:outputPath];
            }
                
                break;
        }
    }];
}

- (void)_addFilterWithStyle:(CLFilterStyle)style videoUrl:(NSURL *)videoUrl outputPath:(NSString *)outputPath{
    @autoreleasepool {
        [self clearMemory];
        _isCancel = NO;
        AVURLAsset* asset = [AVURLAsset assetWithURL:videoUrl];
        if ([asset tracksWithMediaType:AVMediaTypeVideo].count == 0) {
            if ([self.delegate respondsToSelector:@selector(filterManager:didFailure:)]) {
                [self.delegate filterManager:self didFailure:@"Video Processing Error"];
            }
            return;
        }
        AVAssetTrack *asetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        if (![asset tracksWithMediaType:AVMediaTypeAudio]) {
            if ([self.delegate respondsToSelector:@selector(filterManager:didFailure:)]) {
                [self.delegate filterManager:self didFailure:@"Audio Processing Error"];
            }
            return;
        }
        if ([asset tracksWithMediaType:AVMediaTypeAudio].count == 0) {
            if ([self.delegate respondsToSelector:@selector(filterManager:didFailure:)]) {
                [self.delegate filterManager:self didFailure:@"Audio Processing Error"];
            }
            return;
        }
        AVAssetTrack *audioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
        if (!audioTrack.formatDescriptions.count) {
            if ([self.delegate respondsToSelector:@selector(filterManager:didFailure:)]) {
                [self.delegate filterManager:self didFailure:@"Audio Processing Error"];
            }
            return;
        }
        if ([[NSFileManager defaultManager] fileExistsAtPath:outputPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:outputPath error:nil];
        }
        NSURL *writeUrl = [NSURL fileURLWithPath:outputPath];
        // 添加滤镜
        [self initializeVideo:videoUrl];
        
        CGSize videoSize = asetTrack.naturalSize;
//        CGSize videoSize = CGSizeMake(640, 360);
//        if (asetTrack.naturalSize.width/asetTrack.naturalSize.height < 1) {
//            videoSize = CGSizeMake(360, 640);
//        }
        NSDictionary* settings = @{AVVideoCodecKey : AVVideoCodecH264,
                                   AVVideoWidthKey : @(videoSize.width),
                                   AVVideoHeightKey : @(videoSize.height),
                                   AVVideoCompressionPropertiesKey: @ {
                                       AVVideoAverageBitRateKey : @(1200000),
//                                       AVVideoExpectedSourceFrameRateKey : @(25),
//                                       AVVideoMaxKeyFrameIntervalKey : @(25), // 关键帧
//                                       AVVideoMaxKeyFrameIntervalDurationKey : @(1.0),
                                       AVVideoProfileLevelKey : AVVideoProfileLevelH264HighAutoLevel,
                                   },
                                   AVVideoScalingModeKey : AVVideoScalingModeResizeAspect};
        // 音频设置
//        AudioChannelLayout channelLayout;
//        memset(&channelLayout, 0, sizeof(AudioChannelLayout));
//        channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
//        NSDictionary *audioSettings = [NSDictionary dictionaryWithObjectsAndKeys:
//                                       [NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
//                                       [NSNumber numberWithInt: 2 ], AVNumberOfChannelsKey,
//                                       [NSNumber numberWithFloat: 16000.0 ], AVSampleRateKey,
//                                       [NSData dataWithBytes:&channelLayout length: sizeof( AudioChannelLayout )], AVChannelLayoutKey,
//                                       [NSNumber numberWithInt: 32000], AVEncoderBitRateKey,
//                                       nil];
        _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:writeUrl size:videoSize fileType:AVFileTypeQuickTimeMovie outputSettings:settings];
//        _movieWriter.audioFormatDescription = (__bridge CMFormatDescriptionRef)([audioTrack.formatDescriptions objectAtIndex:0]);
        [_movieWriter setTransform:asetTrack.preferredTransform];
        
        // 2. Add filter effect
        _filter = nil;
        _filter = [CLFilterManager getFilterWithMovieFile:_movieFile style:style];
        
//        CGFloat duration = CMTimeGetSeconds([asset duration]);
//        UIView *water = [CLVideoWaterDeal getWaterViewWithVideoSize:videoSize videoTransform:asetTrack.preferredTransform];
//        GPUImageUIElement *uielement = [[GPUImageUIElement alloc] initWithView:water];
//        GPUImageGaussianBlurFilter *gaussian = [[GPUImageGaussianBlurFilter alloc] init];
//        GPUImageFilter* progressFilter = [[GPUImageFilter alloc] init];
//        _filter = [[GPUImageAlphaBlendFilter alloc] init];
//
        if ((NSNull*)_filter != [NSNull null] && _filter != nil)
        {
//            progressFilter = (GPUImageFilter *)[CLFiltersClass addFilterWithMovieFile:_movieFile index:index];
//            [progressFilter addTarget:gaussian];
//            [gaussian addTarget:_filter];
//            [uielement addTarget:_filter];
            [_filter addTarget:_movieWriter];
        }
        else
        {
            [_movieFile addTarget:_movieWriter];
        }
//        [progressFilter setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime currentTime) {
//            NSLog(@"%f",CMTimeGetSeconds(currentTime));
//            CGFloat current = CMTimeGetSeconds(currentTime);
//            if (current < (duration - 1.0)) {
//                [(GPUImageAlphaBlendFilter *)_filter setMix:0];
//            }else{
//                [(GPUImageAlphaBlendFilter *)_filter setMix:1.0];
//                gaussian.blurRadiusInPixels = (current - (duration - 1.0))*20;
//            }
//            [uielement update];
//        }];
        
        // 4. Configure this for video from the movie file, where we want to preserve all video frames and audio samples
        _movieWriter.shouldPassthroughAudio = YES;
        _movieFile.audioEncodingTarget = _movieWriter;
        [_movieFile enableSynchronizedEncodingUsingMovieWriter:_movieWriter];
        
        // 5.
        [_movieWriter startRecording];
        [_movieFile startProcessing];
        
        __unsafe_unretained typeof(self) weakSelf = self;
        
        // 7. Filter effect finished
        [_movieWriter setCompletionBlock:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if ((NSNull*)strongSelf.filter != [NSNull null] && strongSelf.filter != nil)
            {
                [strongSelf.filter removeTarget:strongSelf.movieWriter];
            }else{
                [strongSelf.movieFile removeTarget:strongSelf.movieWriter];
            }
            // 完成后处理进度计时器 关闭、清空
            [strongSelf.timerEffect invalidate];
            strongSelf.timerEffect = nil;
            [strongSelf didFinishWithUrl:writeUrl];
        }];
        
        // 8. Filter failed
        [_movieWriter  setFailureBlock: ^(NSError* error){
            if ((NSNull*)weakSelf.filter != [NSNull null] && weakSelf.filter != nil)
            {
                [weakSelf.filter removeTarget:weakSelf.movieWriter];
            }else{
                [weakSelf.movieFile removeTarget:weakSelf.movieWriter];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // strongSelf处理进度计时器 关闭、清空
                [weakSelf.timerEffect invalidate];
                weakSelf.timerEffect = nil;
                if ([weakSelf.delegate respondsToSelector:@selector(filterManager:didFailure:)]) {
                    [weakSelf.delegate filterManager:weakSelf didFailure:error.description];
                }
            });
            return;
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].idleTimerDisabled = YES;
            weakSelf.timerEffect = [NSTimer scheduledTimerWithTimeInterval:0.3f
                                                            target:self
                                                          selector:@selector(filterRetrievingProgress)
                                                          userInfo:nil
                                                           repeats:YES];
        });
    }
}

- (void) initializeVideo:(NSURL*) inputMovieURL{
    // 1.
    _movieFile = [[GPUImageMovie alloc] initWithURL:inputMovieURL];
    _movieFile.runBenchmark = NO;
    _movieFile.playAtActualSpeed = NO;
}

//
- (void)videoRetrievingProgress{
    _progress = _exportSession.progress/2.0;
    [self retrievingProgress];
}

// 滤镜处理进度
- (void)filterRetrievingProgress
{
    if (_recode) {
        _progress = 0.5+_movieFile.progress/2.0;
    }else{
        _progress = _movieFile.progress;
    }
    [self retrievingProgress];
}

-(void)retrievingProgress{
    if ([self.delegate respondsToSelector:@selector(filterManager:dealProgress:)]) {
        [self.delegate filterManager:self dealProgress:_progress];
    }
}

- (void)onError{
    _isCancel = YES;
    if (_movieFile) {
        [_movieFile cancelProcessing];
    }
    if (_movieWriter) {
        [_movieWriter cancelRecording];
    }
    [self clearMemory];
}


- (void)didFinishWithUrl:(NSURL *)url{
    if (_isCancel) {
        return;
    }
    __unsafe_unretained typeof(self) weakSelf = self;
    [_movieWriter finishRecordingWithCompletionHandler:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if ([strongSelf.delegate respondsToSelector:@selector(filterManager:didFinishURL:)]) {
            [strongSelf.delegate filterManager:self didFinishURL:url];
        }
    }];
}

@end
