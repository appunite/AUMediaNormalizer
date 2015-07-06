//
//  GIMediaProcessing.h
//  KingsChat
//
//  Created by Emil Wojtaszek on 21/04/15.
//  Copyright (c) 2015 Appunite. All rights reserved.
//

//Frameworks
#import <ImageIO/ImageIO.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

@interface GIMediaProcessing : NSObject
// default generated thumbnail size
@property (nonatomic, assign) CGSize thumbnailSize;

// file storage path
@property (nonatomic, strong, readonly) NSString *bucket;

//
- (instancetype)initWithBucket:(NSString *)bucket;

//
+ (NSURL *)bucketsStoragePath;

//
- (NSUUID *)processImageWithPickerParams:(NSDictionary *)params
                   completitionBlock:(void (^)(NSUUID *process, NSURL *fileURL, CGSize size, NSURL *thumbnailURL))block;

- (NSUUID *)processVideoWithPickerParams:(NSDictionary *)params
                      thumbnailBlock:(void (^)(NSUUID *process, NSURL *fileURL, CGSize size, NSURL *thumbnailURL))thumbnailBlock
                   completitionBlock:(void (^)(NSUUID *process, AVAssetExportSessionStatus status, NSError *error))processingBlock;

@end
