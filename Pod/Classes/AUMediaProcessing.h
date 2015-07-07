//
//  AUMediaProcessing.h
//  KingsChat
//
//  Created by Emil Wojtaszek on 21/04/15.
//  Copyright (c) 2015 Appunite. All rights reserved.
//

//Frameworks
#import <ImageIO/ImageIO.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

@interface AUMediaProcessing : NSObject
// default generated thumbnail size
@property (nonatomic, assign) CGSize thumbnailSize;

// file storage path
@property (nonatomic, strong, readonly) NSString *bucket;

// Creates an instance of AUMediaProcessing class with file storage path specified by NSString.
- (instancetype)initWithBucket:(NSString *)bucket;

// Returns NSURL which points to the file storage directory.
+ (NSURL *)bucketsStoragePath;

/*!
 This method is responsible mainly for creating thumbnail image, based on the provided media, and storing both thumbnail and the original content in the path specified by bucketStoragePath.
 
 It takes as an input NSDictionary with similar structure to the UIImagePickerController's info dictionary.
 The basic key-values needed to be supplied are: 
 - UIImagePickerControllerMediaType -> type of the media being processed (image)
 - UIImagePickerControllerOriginalImage -> UIImage holding the original image
 
 completionBlock is executed right after the end of processing image. The NSUUID variable holds the process unique id. The NSURL fileURL points to the original file, CGSize is the size of original image and NSURL thumbnailURL points to the created thumbnail.
 
 */
- (NSUUID *)processImageWithPickerParams:(NSDictionary *)params
                   completitionBlock:(void (^)(NSUUID *process, NSURL *fileURL, CGSize size, NSURL *thumbnailURL))block;
/*!
 This method is responsible mainly for creating thumbnail image, based on the provided media, and storing both thumbnail and the original content in the path specified by bucketStoragePath.
 
 It takes as an input NSDictionary with similar structure to the UIImagePickerController's info dictionary.
 The basic key-values needed to be supplied are:
 - UIImagePickerControllerMediaType -> type of the media being processed (video)
 - UIImagePickerControllerMediaURL -> URL pointing to the video
 
 thumbnailBlock is executed right after the end of creating thumbnail. The NSUUID variable holds the process unique id. The NSURL fileURL points to the original file, CGSize is the size of original image and NSURL thumbnailURL points to the created thumbnail.
 
 Then, after the end of processing video, the completionBlock is fired. The NSUUID variable holds the process unique id. The AVAssetExportSessionStatus holds the status of the encoding process, while NSError is the potential error, which may occur during the process. 
 
 */
- (NSUUID *)processVideoWithPickerParams:(NSDictionary *)params
                      thumbnailBlock:(void (^)(NSUUID *process, NSURL *fileURL, CGSize size, NSURL *thumbnailURL))thumbnailBlock
                   completitionBlock:(void (^)(NSUUID *process, AVAssetExportSessionStatus status, NSError *error))processingBlock;

@end
