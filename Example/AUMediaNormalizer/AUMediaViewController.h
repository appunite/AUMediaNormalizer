//
//  AUMediaViewController.h
//  AUMediaNormalizer
//
//  Created by Krzysztof Kapitan on 03.07.2015.
//  Copyright (c) 2015 Krzysztof. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 This View Controller is responsible for displaying original image based on the tapped thumbnail.
 */

@interface AUMediaViewController : UIViewController

///-----
///@name Fields
///-----

/*!
 NSURL holding url to the original image. 
 */

@property(nonatomic,strong) NSURL *mediaURL;
@end
