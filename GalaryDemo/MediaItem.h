//
//  MediaItem.h
//  GalaryDemo
//
//  Created by Doan Van Vu on 10/2/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "Constants.h"

@interface MediaItem : NSObject

@property (nonatomic) AVURLAsset* urlAsset;
@property (nonatomic) double videoDuration;
@property (nonatomic) NSString* identifier;
@property (nonatomic) MediaType mediaType;
@property (nonatomic) InputType inputType;
@property (nonatomic) NSURL* thumbailUrl;
@property (nonatomic) NSURL* imageUrl;
@property (nonatomic) NSURL* videoUrl;
@property (nonatomic) NSString* desc;

#pragma mark - initWithPHAsset
- (void)initWithPHAsset:(PHAsset *)asset completion:(void(^)(MediaItem *))completion;

@end
