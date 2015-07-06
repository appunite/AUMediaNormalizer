//
//  GIAmazonFile.h
//  KingsChat
//
//  Created by Emil Wojtaszek on 29/04/15.
//  Copyright (c) 2015 Appunite. All rights reserved.
//

#import "Mantle.h"
@interface KCAmazonFile : MTLModel <MTLJSONSerializing>

// unique idetifier of attachment file
@property (nonatomic, strong, readonly) NSString *attachmentId;

// attachment descriptor
@property (nonatomic, strong, readonly) NSString *kind;

// signed amazon file URL
@property (nonatomic, strong, readonly) NSURL *presignedURL;

// public access URL
@property (nonatomic, strong, readonly) NSURL *publicURL;

- (instancetype)initWithAttachmentId:(NSString *)uid publicURL:(NSURL *)url NS_DESIGNATED_INITIALIZER;

//
- (NSMutableURLRequest *)amazonRequest;
@end
