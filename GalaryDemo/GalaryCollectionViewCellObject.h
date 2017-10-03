//
//  GalaryCollectionViewCellObject.h
//  GalaryDemo
//
//  Created by Doan Van Vu on 10/1/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
#import "MediaItem.h"

@protocol GalaryCollectionViewCellObjectProtocol <NSObject>

@property (readonly, nonatomic, copy) NSString* identifier;
@property (readonly, nonatomic, assign) MediaType mediaType;
@property (readonly, nonatomic, assign) double videoDuration;

@end

@interface GalaryCollectionViewCellObject : NSObject <GalaryCollectionViewCellObjectProtocol>

@property (nonatomic) NSString* identifier;
@property (nonatomic) double videoDuration;
@property (nonatomic) MediaType mediaType;

- (void)getImageCacheForCell:(UICollectionViewCell *)cell;

@end
