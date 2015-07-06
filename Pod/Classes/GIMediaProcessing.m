//
//  GIMediaProcessing.m
//  KingsChat
//
//  Created by Emil Wojtaszek on 21/04/15.
//  Copyright (c) 2015 Appunite. All rights reserved.
//

#import "GIMediaProcessing.h"

//Helpers
#import "SDAVAssetExportSession.h"
//Categories
#import "UIImage+Resizing.h"

#import <MobileCoreServices/MobileCoreServices.h>

@implementation GIMediaProcessing {
    NSOperationQueue *_queue;
    NSURL *_bucketURL;
}

- (void)dealloc {
    [_queue cancelAllOperations];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // generate random bucket
        _bucket = [[NSUUID UUID] UUIDString];

        // create new queue
        _queue = [NSOperationQueue new];
        _queue.maxConcurrentOperationCount = 2;
        
        // set default value
        _thumbnailSize = CGSizeMake(300.0, 300.0);
    }
    return self;
}

- (instancetype)initWithBucket:(NSString *)bucket {
    self = [self init];
    if (self) {
        // assing bucket
        _bucket = bucket;
    }
    return self;
}

#pragma mark -
#pragma mark Processing

- (NSUUID *)processImageWithPickerParams:(NSDictionary *)info
                       completitionBlock:(void (^)(NSUUID *process, NSURL *fileURL, CGSize size, NSURL *thumbnailURL))block {

    // generate unique process id
    NSUUID *process = [NSUUID UUID];
    
    //
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    BOOL isImage = CFStringCompare((__bridge CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo;
    NSAssert(isImage, @"Asset need to be image");
    
    // enque operation
    [_queue addOperationWithBlock:^{
        // Access the uncropped image from info dictionary and downscale it
        UIImage *originalPhoto = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *downscaledPhoto = [self downscaleImage:originalPhoto];

        // generate random file paths
        NSURL *photoURL = [self temporaryMediaFileURLWithExtension:@"jpg"];
        NSURL *thumbnailURL = [self temporaryMediaFileURLWithExtension:@"jpg"];

        // generate jpeg data
        NSData *jpegData = UIImageJPEGRepresentation(downscaledPhoto, 0.95f);
        
        // write file to temporary localisation
        [jpegData writeToURL:photoURL options:NSDataWritingFileProtectionNone error:NULL];

        // crate thumbnale image (aspect fill)
        UIImage *thumbImage = [self generateThumbnail:downscaledPhoto];

        // generate jpeg data
        jpegData = UIImageJPEGRepresentation(thumbImage, 0.95f);

        // write thumbnail to temporary location
        [jpegData writeToURL:thumbnailURL options:NSDataWritingFileProtectionNone error:NULL];

        // fire completition block
        dispatch_async(dispatch_get_main_queue(), ^{
            block(process, photoURL, downscaledPhoto.size, thumbnailURL);
        });
    }];
    
    return process;
}

- (NSUUID *)processVideoWithPickerParams:(NSDictionary *)info
                          thumbnailBlock:(void (^)(NSUUID *process, NSURL *fileURL, CGSize size, NSURL *thumbnailURL))thumbnailBlock
                       completitionBlock:(void (^)(NSUUID *process, AVAssetExportSessionStatus status, NSError *error))processingBlock {
    
    // generate unique process id
    NSUUID *process = [NSUUID UUID];

    //
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    BOOL isVideo = CFStringCompare((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo;
    NSAssert(isVideo, @"Asset need to be video");
    
    // enque operation
    [_queue addOperationWithBlock:^{

        // access video URL
        NSURL *mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        // get frame from video
        UIImage *videThumb = [self generateFrameImageFromVideoAsset:mediaURL];
        
        // crate thumbnale image (aspect fill)
        UIImage *thumbImage = [self generateThumbnail:videThumb];

        // generate jpeg data for thumbnail
        NSData *jpegData = UIImageJPEGRepresentation(thumbImage, 0.95f);

        // generate random file paths
        NSURL *videoURL = [self temporaryMediaFileURLWithExtension:@"mp4"];
        NSURL *thumbnailURL = [self temporaryMediaFileURLWithExtension:@"jpg"];
        
        // write thumbnail to temporary location
        [jpegData writeToURL:thumbnailURL options:NSDataWritingFileProtectionNone error:NULL];

        // fire thubnail block
        dispatch_async(dispatch_get_main_queue(), ^{
            thumbnailBlock(process, videoURL, videThumb.size, thumbnailURL);
        });
        
        // access video URL
        AVAsset *avAsset = [AVAsset assetWithURL:mediaURL];
      
        // create export session
        SDAVAssetExportSession *encoder = [SDAVAssetExportSession.alloc initWithAsset:avAsset];
        encoder.outputFileType = AVFileTypeMPEG4;
        encoder.shouldOptimizeForNetworkUse = YES;
        encoder.outputURL = videoURL;
        encoder.videoSettings = @{
            AVVideoCodecKey: AVVideoCodecH264,
            AVVideoWidthKey: @1920,
            AVVideoHeightKey: @1080,
            AVVideoCompressionPropertiesKey: @{
                  AVVideoAverageBitRateKey: @6000000,
                  AVVideoProfileLevelKey: AVVideoProfileLevelH264High40,
            },
        };
        encoder.audioSettings = @{
            AVFormatIDKey: @(kAudioFormatMPEG4AAC),
            AVNumberOfChannelsKey: @2,
            AVSampleRateKey: @44100,
            AVEncoderBitRateKey: @128000,
        };
        
        // call completition block
        [encoder exportAsynchronouslyWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                processingBlock(process, encoder.status, encoder.error);
            });
        }];
    }];
    
    return process;
}

#pragma mark -
#pragma mark Private

- (UIImage *)generateFrameImageFromVideoAsset:(NSURL *)url {
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    CGImageRef image = [generator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:NULL error:NULL];
    UIImage * output = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    
    return output;
}

- (UIImage *)downscaleImage:(UIImage *)image {
    static CGFloat maxDimension = 1024.f;

    //    CGFloat verticalImageRatio = image.size.width / image.size.height;
    CGFloat horizontalImageRatio = image.size.height / image.size.width;
    
    // scale down proportionaly (to not have so big photos - lower side will be max 1024px)
    if (horizontalImageRatio <= 1) {
        CGSize scaledSize = CGSizeMake(maxDimension * image.size.width / image.size.height, maxDimension);
        image = [image scaleToFillSize:scaledSize];
    }
    
    else {
        CGSize scaledSize = CGSizeMake(maxDimension, maxDimension * image.size.height / image.size.width);
        image = [image scaleToFillSize:scaledSize];
    }
    
    return image;
}

- (UIImage *)generateThumbnail:(UIImage *)image  {
    return [image scaleToSize:_thumbnailSize usingMode:NYXResizeModeAspectFill];
}

- (NSURL *)temporaryMediaFileURLWithExtension:(NSString *)ext {
    // make sure bucket folder is created
    [self createBucketStoragePath];

    // create file URL
    NSURL *baseURL = [GIMediaProcessing bucketsStoragePath];
    NSString *fileName = [[[NSUUID UUID] UUIDString] stringByAppendingPathExtension:ext];
    NSString *path = [self.bucket stringByAppendingPathComponent:fileName];
    return [NSURL URLWithString:path relativeToURL:baseURL];
}

#pragma mark -
#pragma mark Getters

+ (NSURL *)bucketsStoragePath {
    // get documents path
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [documentPaths firstObject];
    NSString *uploadsDirectoryPath = [documentsDirectoryPath stringByAppendingPathComponent:@"uploads"];
    
    return [NSURL fileURLWithPath:uploadsDirectoryPath];
}

- (void)createBucketStoragePath {
    if (!_bucketURL) {
        NSURL *bucketURL = [[GIMediaProcessing bucketsStoragePath] URLByAppendingPathComponent:_bucket];
        
        // if folder doesn't exist, create it
        NSError *error = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:[bucketURL path] isDirectory:NULL]) {
            if (![fileManager createDirectoryAtURL:bucketURL withIntermediateDirectories:YES attributes:nil error:&error]) {
                NSAssert(@"Failed to create folder at path: %@", [bucketURL path]);
            }
        }
    }
}

@end
