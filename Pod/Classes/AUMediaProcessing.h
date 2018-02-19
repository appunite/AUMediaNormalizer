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
#import <SDAVAssetExportSession/SDAVAssetExportSession.h>
#import <AUMediaNormalizer/AUAttachmentFile.h>

/*!
 
 * @class AUMediaProcessing
 
 * @discussion This class is responsible for:
 *  - Creating thumbnail image based on the provided media.
 *  - Storing both thumbnail and the original content in the path specified by bucketStoragePath.
 *  - Exporting video media with audio and video settings specified by user.
 
 */

@interface AUMediaProcessing : NSObject

/*!
 * @property thumbnailSize
 * @abstract The desired size of a thumbnail image (set by default).
 */
@property (nonatomic, assign) CGSize thumbnailSize;

/*!
 * @property maxDimension
 * @abstract The desired max dimesion of a full size output image (default is 1024).
 */
@property (nonatomic, assign) CGFloat maxDimension;

/*!
 * @property quality
 * @abstract The desired quality of a full size output image (default is 0,95).
 * @abstract Takes values from 0 to 1.
 */
@property (nonatomic, assign) CGFloat quality;

/*!
 * @property bucket
 * @abstract File storage path.
 */
@property (nonatomic, strong, readonly) NSString *bucket;

/*!
 
 * Creates an instance of AUMediaProcessing class with file storage path specified by NSString.
 * @param bucket
 *     File storage path.
 * @result
 *     Returns freshly created instance of an AUMediaProcessing object.
 */

- (instancetype)initWithBucket:(NSString *)bucket;

/*!
 * Getter for the file storage directory.
 * @result
 *     Returns NSURL which points to the file storage directory.
 */

+ (NSURL *)bucketsStoragePath;

/*!
 * Creates and stores thumbnail based on the original image.
 * @param params
 *     NSDictionary with similar structure to the UIImagePickerController's info dictionary.
 *     The basic key-values needed to be supplied are:
 *      - UIImagePickerControllerMediaType -> type of the media being processed (image)
 *      - UIImagePickerControllerOriginalImage -> UIImage holding the original image
 * @param thumbnailBlock
 *     This block is executed right after the end of processing image.
 *     Parameters:
 *      - NSUUID process     - process unique id.
 *      - NSURL fileURL      - points to the original file.
 *      - CGSize size        - size of original image.
 *      - NSURL thumbnailURL - points to the created thumbnail.
 */
- (NSUUID *)processImageWithPickerParams:(NSDictionary *)params
                          thumbnailBlock:(void (^)(NSUUID *process, NSURL *fileURL, CGSize size, NSURL *thumbnailURL))block;

/*!
 * Creates and stores thumbnail based on the original image.
 * @param params
 *     NSDictionary with similar structure to the UIImagePickerController's info dictionary.
 *     The basic key-values needed to be supplied are:
 *      - UIImagePickerControllerMediaType -> type of the media being processed (image)
 *      - UIImagePickerControllerOriginalImage -> UIImage holding the original image
 * @param attachmentBlock
 *     This block is executed right after the end of processing image.
 *     Parameters:
 *      - AUAttachmentFile attachmentFile - object holding info about the original media and thumbnail image.
 
 */

- (NSUUID *)processImageWithPickerParams:(NSDictionary *)params
                         attachmentBlock:(void (^)(AUAttachmentFile *attachmentFile))block;

/*!
 * Creates and stores thumbnail based on the original video, exports video with default settings.
 * @param params
 *     NSDictionary with similar structure to the UIImagePickerController's info dictionary.
 *     The basic key-values needed to be supplied are:
 *      - UIImagePickerControllerMediaType -> type of the media being processed (video)
 *      - UIImagePickerControllerMediaURL -> URL pointing to the video
 * @param thumbnailBlock
 *     This block is executed right after the creation of thumbnail image.
 *     Parameters:
 *      - NSUUID process     - process unique id.
 *      - NSURL fileURL      - points to the original file.
 *      - CGSize size        - size of original image.
 *      - NSURL thumbnailURL - points to the created thumbnail.
 * @param completitionBlock
 *     This block is executed right after the end of exporting movie.
 *     Parameters:
 *      - NSUUID process                    - process unique id.
 *      - AVAssetExportSessionStatus status - status of the export session.
 *      - NSError error                     - the potential error, which may occur during the process.
 */

- (NSUUID *)processVideoWithPickerParams:(NSDictionary *)params
                          thumbnailBlock:(void (^)(NSUUID *process, NSURL *fileURL, CGSize size, NSURL *thumbnailURL))thumbnailBlock
                       completitionBlock:(void (^)(NSUUID *process, AVAssetExportSessionStatus status, NSError *error))processingBlock;

/*!
 
 * Creates and stores thumbnail based on the original video, exports video with custom settings.
 * @param params
 *     NSDictionary with similar structure to the UIImagePickerController's info dictionary.
 *     The basic key-values needed to be supplied are:
 *      - UIImagePickerControllerMediaType -> type of the media being processed (video)
 *      - UIImagePickerControllerMediaURL -> URL pointing to the video
 * @param thumbnailBlock
 *     This block is executed right after the creation of thumbnail image.
 *     Parameters:
 *      - NSUUID process     - process unique id.
 *      - NSURL fileURL      - points to the original file.
 *      - CGSize size        - size of original image.
 *      - NSURL thumbnailURL - points to the created thumbnail.
 * @param encoderSettingsBlock
 *     This block is executed right before the begining of exporting movie.
 *     Parameters:
 *      - SDAVAssetExportSession encoder - fully customizable encoder used to export movie.
 * @param completitionBlock
 *     This block is executed right after the end of exporting movie.
 *     Parameters:
 *      - NSUUID process                    - process unique id.
 *      - AVAssetExportSessionStatus status - status of the export session.
 *      - NSError error                     - the potential error, which may occur during the process.
 */

- (NSUUID *)processVideoWithPickerParams:(NSDictionary *)params
                          thumbnailBlock:(void (^)(NSUUID *process, NSURL *fileURL, CGSize size, NSURL *thumbnailURL))thumbnailBlock
                    encoderSettingsBlock:(void (^)(SDAVAssetExportSession *encoder))settingsBlock
                       completitionBlock:(void (^)(NSUUID *process, AVAssetExportSessionStatus status, NSError *error))processingBlock;

/*!
 * Creates and stores thumbnail based on the original video, exports video with custom settings.
 * @param params
 *     NSDictionary with similar structure to the UIImagePickerController's info dictionary.
 *     The basic key-values needed to be supplied are:
 *      - UIImagePickerControllerMediaType -> type of the media being processed (video)
 *      - UIImagePickerControllerMediaURL -> URL pointing to the video
 * @param attachmentBlock
 *     This block is executed right after the creation of thumbnail image.
 *     Parameters:
 *      - AUAttachmentFile attachmentFile - object holding info about the original media and thumbnail image.
 * @param encoderSettingsBlock
 *     This block is executed right before the begining of exporting movie.
 *     Parameters:
 *      - SDAVAssetExportSession encoder - fully customizable encoder used to export movie.
 * @param completitionBlock
 *     This block is executed right after the end of exporting movie.
 *     Parameters:
 *      - NSUUID process                    - process unique id.
 *      - AVAssetExportSessionStatus status - status of the export session.
 *      - NSError error                     - the potential error, which may occur during the process.
 */


- (NSUUID *)processVideoWithPickerParams:(NSDictionary *)params
                         attachmentBlock:(void (^)(AUAttachmentFile *attachmentFile))block
                    encoderSettingsBlock:(void (^)(SDAVAssetExportSession *encoder))settingsBlock
                       completitionBlock:(void (^)(NSUUID *process, AVAssetExportSessionStatus status, NSError *error))processingBlock;

/*!
 
 * Creates and stores thumbnail based on the original video, exports video with default settings.
 * @param params
 *     NSDictionary with similar structure to the UIImagePickerController's info dictionary.
 *     The basic key-values needed to be supplied are:
 *      - UIImagePickerControllerMediaType -> type of the media being processed (video)
 *      - UIImagePickerControllerMediaURL -> URL pointing to the video
 * @param attachmentBlock
 *     This block is executed right after the creation of thumbnail image.
 *     Parameters:
 *      - AUAttachmentFile attachmentFile - object holding info about the original media and thumbnail image.
 * @param completitionBlock
 *     This block is executed right after the end of exporting movie.
 *     Parameters:
 *      - NSUUID process                    - process unique id.
 *      - AVAssetExportSessionStatus status - status of the export session.
 *      - NSError error                     - the potential error, which may occur during the process.
 */

- (NSUUID *)processVideoWithPickerParams:(NSDictionary *)params
                         attachmentBlock:(void (^)(AUAttachmentFile *attachmentFile))block
                       completitionBlock:(void (^)(NSUUID *process, AVAssetExportSessionStatus status, NSError *error))processingBlock;



@end
