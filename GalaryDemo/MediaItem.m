//
//  MediaItem.m
//  GalaryDemo
//
//  Created by Doan Van Vu on 10/2/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import "ImageCacher.h"
#import "MediaItem.h"

@implementation MediaItem

#pragma mark - initWithPHAsset

- (void)initWithPHAsset:(PHAsset *)asset completion:(void(^)(MediaItem *))completion {
    
    PHImageRequestOptions* imageRequestOptions = [[PHImageRequestOptions alloc] init];
    PHVideoRequestOptions* videoRequestOptions = [[PHVideoRequestOptions alloc] init];
    
    if (asset.mediaType == PHAssetMediaTypeImage) {
        
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:imageRequestOptions resultHandler:^(NSData* imageData, NSString* dataUTI, UIImageOrientation orientation, NSDictionary* info) {
            
            if ([info objectForKey:@"PHImageFileURLKey"]) {

                _inputType = AssetInput;
                _imageUrl = [info objectForKey:@"PHImageFileURLKey"];
                _identifier = asset.localIdentifier;
                _mediaType = MediaImageType;
                
                UIImage* image = [UIImage imageWithData:imageData];
                
                if(image) {
                    
                    [[ImageCacher sharedInstance] setImageForKey:[self resizeImage:image] forKey:asset.localIdentifier];
                }
            }
            
            if (completion) {
                
                completion(self);
            }
        }];
        
        imageRequestOptions = nil;
    } else {
        
        [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:videoRequestOptions resultHandler:^(AVAsset* _Nullable assetVideo, AVAudioMix* _Nullable audioMix, NSDictionary* _Nullable info) {
            
            AVURLAsset* playerAsset = (AVURLAsset*)assetVideo;
            
            _inputType = AssetInput;
            _videoUrl = [playerAsset URL];
            _identifier = asset.localIdentifier;
            _mediaType = MediaVideoType;
            _urlAsset = playerAsset;
            _videoDuration = ceil(playerAsset.duration.value/playerAsset.duration.timescale);
            
            if (completion) {
                
                completion(self);
            }
        }];
        
        videoRequestOptions = nil;
    }
}

#pragma mark - resize image

- (UIImage *)resizeImage:(UIImage *)image {
    
    CGAffineTransform scaleTransform;
    CGPoint origin;
    CGFloat edgeSquare = 200;
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    if (imageWidth > imageHeight) {
        
        CGFloat scaleRatio = edgeSquare / imageHeight;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        origin = CGPointMake(-(imageWidth - imageHeight) / 2, 0);
    } else {
        
        CGFloat scaleRatio = edgeSquare / imageWidth;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        origin = CGPointMake(0, -(imageHeight - imageWidth) / 2);
    }
    
    CGSize size = CGSizeMake(edgeSquare, edgeSquare);
    
    // Begin ImageContext
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, scaleTransform);
    [image drawAtPoint:origin];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
