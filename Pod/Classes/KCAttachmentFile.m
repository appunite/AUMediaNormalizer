//
//  KCAttachmentFile.m
//  KingsChat
//
//  Created by Emil Wojtaszek on 19/05/15.
//  Copyright (c) 2015 Appunite. All rights reserved.
//

#import "KCAttachmentFile.h"

//Others
#import "GIMediaProcessing.h"

@interface KCAttachmentFile ()
@property (nonatomic, strong, readwrite) KCAmazonFile *amazonDescriptor;
@end

@implementation KCAttachmentFile

- (instancetype)initWithSourceURL:(NSURL *)sourceURL MIMEType:(NSString *)mimetype fileSize:(long long)fileSize coverURL:(NSURL *)coverURL attributes:(NSDictionary *)attributes identifier:(NSUUID *)identifier {
    self = [super init];
    if (self) {
        _uid = identifier ?: [NSUUID UUID];
        _MIMEtype = mimetype;
        _sourcePath = [sourceURL relativePath];
        _coverPath = [coverURL relativePath];
        _fileSize = fileSize;
        _attributes = [attributes copy];

        // read file size if no info
        if (_fileSize == 0) {
            // get information about source file
            NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[sourceURL path] error:nil];
            // update file size
            _fileSize = [[fileAttributes objectForKey:NSFileSize] longLongValue];
        }
    }
    return self;
}

- (instancetype)initWithImageSourceURL:(NSURL *)sourceURL coverURL:(NSURL *)coverURL size:(CGSize)size identifier:(NSUUID *)identifier {
    return [self initWithSourceURL:sourceURL MIMEType:@"image/jpeg" fileSize:0 coverURL:coverURL attributes:@{@"width": @(size.width), @"height": @(size.height)} identifier:identifier];
}

- (instancetype)initWithVideoSourceURL:(NSURL *)sourceURL coverURL:(NSURL *)coverURL size:(CGSize)size identifier:(NSUUID *)identifier {
    return [self initWithSourceURL:sourceURL MIMEType:@"video/mp4" fileSize:0 coverURL:coverURL attributes:@{@"width": @(size.width), @"height": @(size.height)} identifier:identifier];
}

#pragma mark -
#pragma mark URLs

- (NSURL *)sourceURL {
    return [NSURL URLWithString:_sourcePath relativeToURL:[GIMediaProcessing bucketsStoragePath]];
}

- (NSURL *)coverURL {
    return [NSURL URLWithString:_coverPath relativeToURL:[GIMediaProcessing bucketsStoragePath]];
}

#pragma mark -
#pragma mark Helpers

- (KCAttachmentFile *)attachmentFileWithAmazonDescriptor:(KCAmazonFile *)amazonFile {
    // create copy of attachment
    KCAttachmentFile *attachment = [[KCAttachmentFile alloc] initWithSourceURL:self.sourceURL MIMEType:self.MIMEtype fileSize:self.fileSize coverURL:self.coverURL attributes:self.attributes identifier:self.uid];
    // assign amazon descriptor
    attachment.amazonDescriptor = amazonFile;
    return attachment;
}

@end
