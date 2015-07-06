//
//  AUMediaCollectionViewCell.m
//  AUMediaNormalizer
//
//  Created by Krzysztof Kapitan on 03.07.2015.
//  Copyright (c) 2015 Krzysztof. All rights reserved.
//

#import "AUMediaCollectionViewCell.h"

@interface AUMediaCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation AUMediaCollectionViewCell

-(void)setMedia:(UIImage *)media{
    _media = media;
    _imageView.image = media;
}

@end
