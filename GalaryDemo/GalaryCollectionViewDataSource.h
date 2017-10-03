//
//  GalaryCollectionViewDataSource.h
//  GalaryDemo
//
//  Created by Doan Van Vu on 10/1/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import "GalaryCollectionViewCellObject.h"
#import "ThreadSafeForMutableArray.h"
#import "Foundation/Foundation.h"
#import <UIKit/UIKit.h>
#import "MediaItem.h"

@interface GalaryCollectionViewDataSource : NSObject

#pragma mark - initWithCollectionView
- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;

#pragma mark - setupData
- (void)setupData:(ThreadSafeForMutableArray *)mediaItems;

@end
