//
//  AUMediaCollectionViewCell.h
//  AUMediaNormalizer
//
//  Created by Krzysztof Kapitan on 03.07.2015.
//  Copyright (c) 2015 Krzysztof. All rights reserved.
//

#import <UIKit/UIKit.h>

/*! 
 This is a custom CollectionViewCell class responsible for displaying thumbnail images. 
 */

@interface AUMediaCollectionViewCell : UICollectionViewCell

///-----
///@name Fields
///-----

/*!
 UIImage that holds the thumbnail.
 */
@property (nonatomic,strong) UIImage *media;
@end
