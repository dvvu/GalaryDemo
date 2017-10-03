//
//  MediaLoader.m
//  GalaryDemo
//
//  Created by Doan Van Vu on 10/2/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import "ImageCacher.h"
#import "MediaLoader.h"
#import "MediaItem.h"

@interface MediaLoader ()

@property (nonatomic) ThreadSafeForMutableArray* mediaArray;
@property (nonatomic) dispatch_queue_t photoPermissionQueue;
@property (nonatomic) dispatch_queue_t mediaLoaderQueue;
@property (nonatomic) int maxloaderItems;

@end

@implementation MediaLoader

+ (instancetype)sharedInstance {
    
    static MediaLoader* sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[MediaLoader alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - init

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        _maxloaderItems = 70;
        _mediaArray = [[ThreadSafeForMutableArray alloc] init];
        _mediaLoaderQueue = dispatch_queue_create("MEDIA_LOADER_QUEUE", DISPATCH_QUEUE_SERIAL);
        _photoPermissionQueue = dispatch_queue_create("PHOTO_PERMISSION_QUEUE", DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

#pragma mark - getListMediaFromAsset

- (void)getListMediaFromAsset:(void(^)(ThreadSafeForMutableArray *))completion {
    
    dispatch_async(_mediaLoaderQueue,^{
     
        PHFetchOptions* options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        PHFetchResult* assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
        
        if (_maxloaderItems > assetsFetchResults.count) {
            
            _maxloaderItems = (int)assetsFetchResults.count;
        }
        
        for (int i = 0; i < _maxloaderItems; i++) {
            
            PHAsset* asset = assetsFetchResults[i];

            [[MediaItem alloc] initWithPHAsset:asset completion:^(MediaItem* mediaItem) {
                
                if (!mediaItem) {
                    
                    _maxloaderItems--;
                } else {
                    
                    [_mediaArray addObject:mediaItem];
                }
                
                if (_maxloaderItems == _mediaArray.count) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        
                        if (completion) {
                            
                            completion(_mediaArray);
                        }
                    });
                }
            }];
        }
    });
}

#pragma mark - checkPermissionPhoto

- (void)checkPhotoPermission:(void(^)(NSString *))completion {
    
    dispatch_async(_photoPermissionQueue, ^ {
        
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        
        if (status == PHAuthorizationStatusAuthorized) {
            
            // Access has been granted.
            if (completion) {
                
                dispatch_async(dispatch_get_main_queue(), ^ {
                    
                    completion(nil);
                });
            }
        } else if (status == PHAuthorizationStatusDenied) {
            
            // Access has been denied.
            if (completion) {
                
                dispatch_async(dispatch_get_main_queue(), ^ {
                    
                    completion(@"PHAuthorizationStatusDenied");
                });
            }
        } else if (status == PHAuthorizationStatusNotDetermined) {
            
            // Access has not been determined.
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
                if (status == PHAuthorizationStatusAuthorized) {
                    // Access has been granted.
                    if (completion) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^ {
                            
                            completion(nil);
                        });
                    }
                } else {
                    // Access has been denied.
                    if (completion) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^ {
                            
                            completion(@"PHAuthorizationStatusDenied");
                        });
                    }
                }
            }];
        } else if (status == PHAuthorizationStatusRestricted) {
            
            if (completion) {
                
                dispatch_async(dispatch_get_main_queue(), ^ {
                    
                    completion(@"PHAuthorizationStatusRestricted");
                });
            }
        }
    });
}

@end
