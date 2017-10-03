//
//  GalaryCollectionViewCell.h
//  GalaryDemo
//
//  Created by Doan Van Vu on 10/1/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GalaryCollectionViewCellObject.h"

@interface GalaryCollectionViewCell : UICollectionViewCell

@property (nonatomic) id<GalaryCollectionViewCellObjectProtocol> model;
@property (nonatomic) UIImageView* galaryImageView;
@property (nonatomic) NSString* identifier;

@end
