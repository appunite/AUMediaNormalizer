//
//  AUAttachmentFile.h
//  KingsChat
//
//  Created by Emil Wojtaszek on 19/05/15.
//  Copyright (c) 2015 Appunite. All rights reserved.
//

#import "Mantle.h"
//Models
#import "AUAmazonFile.h"

@interface AUAttachmentFile : MTLModel

@property (nonatomic, strong, readonly) NSUUID *uid;
@property (nonatomic, strong, readonly) NSString *MIMEtype;

// file size in bytes
@property (nonatomic, assign, readonly) long long fileSize;

// relative path to source file
@property (nonatomic, strong, readonly) NSString *sourcePath;
- (NSURL *)sourceURL;

// relative path to cover thumbnail image file
@property (nonatomic, strong, readonly) NSString *coverPath;
- (NSURL *)coverURL;

// describe attachment destination
@property (nonatomic, strong, readonly) AUAmazonFile *amazonDescriptor;

// describe attachment destination
@property (nonatomic, strong, readonly) NSDictionary *attributes;

// 
- (instancetype)initWithSourceURL:(NSURL *)sourceURL
                         MIMEType:(NSString *)mimetype
                         fileSize:(long long)fileSize
                         coverURL:(NSURL *)coverURL
                       attributes:(NSDictionary *)attributes
                       identifier:(NSUUID *)identifier;

// create attachment with image/jpeg MIME type and save image dimensions in attributes
- (instancetype)initWithImageSourceURL:(NSURL *)sourceURL
                              coverURL:(NSURL *)coverURL
                                  size:(CGSize)size
                            identifier:(NSUUID *)identifier;

// create attachment with image/mp4 MIME type and save video dimensions in attributes
- (instancetype)initWithVideoSourceURL:(NSURL *)sourceURL
                              coverURL:(NSURL *)coverURL
                                  size:(CGSize)size
                            identifier:(NSUUID *)identifier;


// create new instance of AUAttachmentFile extended by amazond descriptor
- (AUAttachmentFile *)attachmentFileWithAmazonDescriptor:(AUAmazonFile *)amazonFile;
@end
