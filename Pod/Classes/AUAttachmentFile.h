//
//  AUAttachmentFile.h
//  KingsChat
//
//  Created by Emil Wojtaszek on 19/05/15.
//  Copyright (c) 2015 Appunite. All rights reserved.
//

#import "Mantle.h"
//Models

/*!
 
 * @class AUAttachmentFile
 
 * @discussion This class is responsible for storing information about thumbnail image and the original content.

 */

@interface AUAttachmentFile : MTLModel

/*!
 
 * @property uid
 
 * @abstract unique id of the attachment file.
 
 */

@property (nonatomic, strong, readonly) NSUUID *uid;

/*!
 
 * @property MIMEtype
 
 * @abstract type of the attachment file (image/video).
 
 */

@property (nonatomic, strong, readonly) NSString *MIMEtype;

/*!
 
 * @property fileSize
 
 * @abstract file size in bytes.
 
 */

@property (nonatomic, assign, readonly) long long fileSize;

/*!
 
 * @property sourcePath
 
 * @abstract relative path to source file.
 
 */

@property (nonatomic, strong, readonly) NSString *sourcePath;

/*! 
 
 * Getter for URL to source file.
 
 * @result
 *     Returns URL to source file.
 
*/

- (NSURL *)sourceURL;

/*!
 
 * @property coverPath
 
 * @abstract relative path to thumbnail file.
 
 */

@property (nonatomic, strong, readonly) NSString *coverPath;

/*!
 
 * Getter for URL to cover file.
 
 * @result
 *     Returns URL to cover file.
 
 */

- (NSURL *)coverURL;

/*!
 
 * @property attributes
 
 * @abstract additional information about source media.
 * @discussion 
 *        Keys:
 *          - width  - width of attachment.
 *          - height - height of attachment.
 
 */


@property (nonatomic, strong, readonly) NSDictionary *attributes;

/*!
 
 * Creates new AUAttachmentFile.
 
 * @param sourceURL
 *     URL which points to the source file.
 
 * @param mimetype
 *     Type of media (image/video).
 
 * @param fileSize
 *     Size of the source file in bytes.
 
 * @param coverURL
 *     URL which points to the thumbnail file.
 
 * @param attributes
 *     Dictionary with additional information about source media.
 
 * @param identifier
 *     ID of the attachment file.
 
 * @result 
 *     Returns freshly created AUAttachmentFile.
 
 */

- (instancetype)initWithSourceURL:(NSURL *)sourceURL
                         MIMEType:(NSString *)mimetype
                         fileSize:(long long)fileSize
                         coverURL:(NSURL *)coverURL
                       attributes:(NSDictionary *)attributes
                       identifier:(NSUUID *)identifier;

/*!
 
 * Creates new AUAttachmentFile with image/jpeg MIME type and saves image dimensions in attributes dictionary.
 
 * @param sourceURL
 *     URL which points to the source file.
 
 * @param coverURL
 *     URL which points to the thumbnail file.
 
 * @param size
 *     Size (dimentions) of the source media.
 
 * @param identifier
 *     ID of the attachment file.
 
 * @result
 *     Returns freshly created AUAttachmentFile.
 
 */

- (instancetype)initWithImageSourceURL:(NSURL *)sourceURL
                              coverURL:(NSURL *)coverURL
                                  size:(CGSize)size
                            identifier:(NSUUID *)identifier;

/*!
 
 * Creates new AUAttachmentFile with image/mp4 MIME type and saves video dimensions in attributes dictionary.
 
 * @param sourceURL
 *     URL which points to the source file.
 
 * @param coverURL
 *     URL which points to the thumbnail file.
 
 * @param size
 *     Size (dimentions) of the source media.
 
 * @param identifier
 *     ID of the attachment file.
 
 * @result
 *     Returns freshly created AUAttachmentFile.
 
 */

- (instancetype)initWithVideoSourceURL:(NSURL *)sourceURL
                              coverURL:(NSURL *)coverURL
                                  size:(CGSize)size
                            identifier:(NSUUID *)identifier;

@end
