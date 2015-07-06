//
//  AUViewController.m
//  AUMediaNormalizer
//
//  Created by Krzysztof on 07/03/2015.
//  Copyright (c) 2015 Krzysztof. All rights reserved.
//

//Controllers
#import "AUViewController.h"
#import "AUMediaViewController.h"

//Views
#import "AUMediaCollectionViewCell.h"

//Others
#import <AUMediaNormalizer/AUMediaProcessing.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MBProgressHUD.h"

@interface AUViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong,nonatomic) NSMutableArray *mediaURLs;
@property (strong,nonatomic) NSMutableArray *mediaThumbs;
@property (strong,nonatomic) NSMutableArray *isMovie;
@property (strong,nonatomic) UIImagePickerController *imagePicker;
@property (strong,nonatomic) AUMediaProcessing *mediaProcessing;

@property (nonatomic,copy) void (^thumbnailBlock)(NSUUID *process, NSURL *fileURL, CGSize size, NSURL *thumbnailURL);
@end

@implementation AUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _mediaURLs = [NSMutableArray new];
    _mediaThumbs = [NSMutableArray new];
    _isMovie = [NSMutableArray new];
    
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    _mediaProcessing = [[AUMediaProcessing alloc] init];
    
    __weak AUViewController* _self = self;
    _thumbnailBlock = ^(NSUUID *process, NSURL *fileURL, CGSize size, NSURL *thumbnailURL) {
        UIImage *imageThumb = [UIImage imageWithData:[NSData dataWithContentsOfURL:thumbnailURL]];
        [_self.mediaURLs addObject:fileURL];
        [_self.mediaThumbs addObject:imageThumb];
        [_self.collectionView reloadData];
    };
}
- (IBAction)addMedia:(id)sender {
    [self presentViewController:_imagePicker animated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    BOOL movie = CFStringCompare((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo;
    [_isMovie addObject:[NSNumber numberWithBool:movie]];

    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if(!movie){
        [_mediaProcessing processImageWithPickerParams:info completitionBlock:_thumbnailBlock];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [_mediaProcessing processVideoWithPickerParams:info thumbnailBlock:_thumbnailBlock
         completitionBlock:^(NSUUID *process, AVAssetExportSessionStatus status, NSError *error) {
            [hud hide:YES];
        }];
        
    }
    //[_mediaURLs addObject:info[UIImagePickerControllerMediaURL]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _mediaThumbs.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"mediaCellReuseIdentifier";
    
    AUMediaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.media = _mediaThumbs[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([_isMovie[indexPath.row] boolValue]){
        MPMoviePlayerViewController *MPVC = [[MPMoviePlayerViewController alloc] initWithContentURL:_mediaURLs[indexPath.row]];
        [MPVC.moviePlayer prepareToPlay];
        [MPVC.moviePlayer play];
        [self presentViewController:MPVC animated:YES completion:nil];
    }else{
        [self performSegueWithIdentifier:@"showMediaSegue" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"showMediaSegue"]){
        AUMediaViewController* dVC = segue.destinationViewController;
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
        dVC.mediaURL = _mediaURLs[indexPath.row];
    }
}
@end
