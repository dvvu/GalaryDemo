//
//  GalaryCollectionViewCellObject.m
//  GalaryDemo
//
//  Created by Doan Van Vu on 10/1/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import "GalaryCollectionViewCellObject.h"
#import "GalaryCollectionViewCell.h"
#import <Photos/Photos.h>
#import "ImageCacher.h"

@implementation GalaryCollectionViewCellObject

#pragma mark - getImageCacheForCell

- (void)getImageCacheForCell:(UICollectionViewCell *)cell {
    
    [[ImageCacher sharedInstance] getImageForKey:_identifier completionWith:^(UIImage* image) {
        
        __weak GalaryCollectionViewCell* galaryCollectionViewCell = (GalaryCollectionViewCell *)cell;
        
        if (image) {
            
            if ([_identifier isEqualToString:galaryCollectionViewCell.identifier]) {
                
                dispatch_async(dispatch_get_main_queue(), ^ {
                    
                    galaryCollectionViewCell.galaryImageView.image = image;
                });
            }
        } else {
            
            [self requestImageFromAsset:_identifier completion:^(UIImage* image) {
                
                if (image) {
                    
                    galaryCollectionViewCell.galaryImageView.image = image;
                    [[ImageCacher sharedInstance] setImageForKey:image forKey:_identifier];
                }
            }];
        }
    }];
}

#pragma mark - requestImageFromAsset

- (void)requestImageFromAsset:(NSString *)localIdentifier completion:(void(^)(UIImage *))completion {
    
    PHFetchResult* savedAssets = [PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentifier] options:nil];
    
    [savedAssets enumerateObjectsUsingBlock:^(PHAsset* asset, NSUInteger idx, BOOL* stop) {
        
        PHImageRequestOptions* imageRequestOptions = [[PHImageRequestOptions alloc] init];
        imageRequestOptions.synchronous = NO;
        imageRequestOptions.deliveryMode = PHImageRequestOptionsResizeModeFast;
        imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
        imageRequestOptions.version = PHImageRequestOptionsVersionUnadjusted;
        
        [[PHImageManager defaultManager]requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:imageRequestOptions resultHandler:^(UIImage* _Nullable image, NSDictionary* _Nullable info) {
            
            NSLog(@"get image from result");
            image = [self resizeImage:image];
            
            if (completion) {
                
                completion(image);
            }
        }];
        
        imageRequestOptions = nil;
    }];
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
