//
//  AUMediaViewController.m
//  AUMediaNormalizer
//
//  Created by Krzysztof Kapitan on 03.07.2015.
//  Copyright (c) 2015 Krzysztof. All rights reserved.
//

#import "AUMediaViewController.h"

#import <MediaPlayer/MediaPlayer.h>

@interface AUMediaViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation AUMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:_mediaURL]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
