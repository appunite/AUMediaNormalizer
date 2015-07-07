//
//  AUMediaNormalizerTests.m
//  AUMediaNormalizerTests
//
//  Created by Krzysztof on 07/03/2015.
//  Copyright (c) 2015 Krzysztof. All rights reserved.
//

@import XCTest;

#import <AUMediaNormalizer/AUMediaProcessing.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface Tests : XCTestCase
@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testProcessingImage{
    AUMediaProcessing* mediaProcessing = [[AUMediaProcessing alloc] init];
    XCTAssertNotNil(mediaProcessing.bucket);
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"ImageExpectation"];
    
    UIImage *exampleImage = [UIImage imageNamed:@"example_image.jpg"];
    
    NSMutableDictionary *info = [NSMutableDictionary new];
    [info setObject:@"public.image" forKey:UIImagePickerControllerMediaType];
    [info setObject:exampleImage forKey:UIImagePickerControllerOriginalImage];
    
    [mediaProcessing processImageWithPickerParams:info completitionBlock:^(NSUUID *process, NSURL *fileURL, CGSize size, NSURL *thumbnailURL) {
        XCTAssertNotNil(fileURL);
        XCTAssertNotNil(thumbnailURL);
        
        UIImage* fullImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:fileURL]];
        UIImage* thumbnailImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:thumbnailURL]];
        
        XCTAssertNotNil(fullImage);
        XCTAssertNotNil(thumbnailImage);
        
        XCTAssertEqual(size.width, fullImage.size.width);
        XCTAssertEqual(size.height, fullImage.size.height);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)testProcessingVideo{
    
    AUMediaProcessing* mediaProcessing = [[AUMediaProcessing alloc] init];
    XCTAssertNotNil(mediaProcessing.bucket);

    XCTestExpectation *expectation = [self expectationWithDescription:@"VideoExpectation"];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"example_movie" ofType:@".mov"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSMutableDictionary *info = [NSMutableDictionary new];
    [info setObject:@"public.movie" forKey:UIImagePickerControllerMediaType];
    [info setObject:url forKey:UIImagePickerControllerMediaURL];
    [mediaProcessing processVideoWithPickerParams:info thumbnailBlock:^(NSUUID *process, NSURL *fileURL, CGSize size, NSURL *thumbnailURL) {
        
        XCTAssertNotNil(fileURL);
        XCTAssertNotNil(thumbnailURL);
        UIImage* thumbnailImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:thumbnailURL]];
        XCTAssertNotNil(thumbnailImage);
        
    } completitionBlock:^(NSUUID *process, AVAssetExportSessionStatus status, NSError *error) {
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end

