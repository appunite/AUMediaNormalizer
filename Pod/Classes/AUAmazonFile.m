//
//  AUAmazonFile.m
//  KingsChat
//
//  Created by Emil Wojtaszek on 29/04/15.
//  Copyright (c) 2015 Appunite. All rights reserved.
//

#import "AUAmazonFile.h"
#import "MTLJSONAdapter.h"
@implementation AUAmazonFile

- (instancetype)initWithAttachmentId:(NSString *)uid publicURL:(NSURL *)url {
    self = [super init];
    if (self) {
        _attachmentId = uid;
        _publicURL = url;
    }
    return self;
}

- (NSMutableURLRequest *)amazonRequest {
    // create request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_presignedURL];
    request.HTTPMethod = @"PUT";
    
    return request;
}

#pragma mark -
#pragma mark Value transformers

+ (NSValueTransformer *)presignedURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)publicURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

#pragma mark -
#pragma mark Mappings

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"attachmentId": @"id",
        @"kind": @"kind",
        @"presignedURL": @"presigned_url",
        @"publicURL": @"public_url",
        @"fileURL": @"url"
    };
}

@end
