//
//  GalaryViewController.m
//  GalaryDemo
//
//  Created by Doan Van Vu on 9/30/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import "GalaryCollectionViewDataSource.h"
#import "GalaryViewController.h"
#import "MediaLoader.h"
#import "MediaItem.h"
#import "Constants.h"
#import "Masonry.h"

@interface GalaryViewController () <UIAlertViewDelegate>

@property (nonatomic) GalaryCollectionViewDataSource* galaryImageDataSource;
@property (nonatomic) UICollectionView* galaryCollectionView;
@property (nonatomic) UICollectionViewFlowLayout* layout;

@end

@implementation GalaryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupCollectionView];
}

#pragma mark - viewWillAppear

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDidRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark - viewWillDisappear

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if ([[UIDevice currentDevice] isGeneratingDeviceOrientationNotifications]) {
        
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    }
}

#pragma mark - setupCollectionView

- (void)setupCollectionView {
    
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing = 3;
    _layout.itemSize = CGSizeMake((self.view.bounds.size.width-12)/3, (self.view.bounds.size.width-12)/3);
    [_layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _galaryCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    [_galaryCollectionView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_galaryCollectionView];
    
    [_galaryCollectionView mas_makeConstraints:^(MASConstraintMaker* make) {
    
        make.edges.equalTo(self.view).offset(0);
    }];
    
    [_galaryCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"GalaryCollectionViewCell"];
    _galaryImageDataSource = [[GalaryCollectionViewDataSource alloc] initWithCollectionView:_galaryCollectionView];
   
    UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc] init];
    [activity setBackgroundColor:[UIColor clearColor]];
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activity];
    
    [activity mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.center.equalTo(self.view);
        make.width.and.height.equalTo(@40);
    }];
    
    [activity startAnimating];
    
    [[MediaLoader sharedInstance] checkPhotoPermission:^(NSString* error) {
        
        if (error) {
            
            [self showMessage:@"Please! Enable to use" withTitle:error];
        } else {
            
            [[MediaLoader sharedInstance] getListMediaFromAsset:^(ThreadSafeForMutableArray* mediaItems) {
                
                [_galaryImageDataSource setupData:mediaItems];
              
                [activity stopAnimating];
                [activity removeFromSuperview];
            }];
        }
    }];
}

#pragma mark - deviceDidRotate

- (void)deviceDidRotate:(NSNotification *)notification {

    UIDeviceOrientation currentOrientation = [[UIDevice currentDevice] orientation];
    
    // Ignore changes in device orientation if unknown, face up, or face down.
    if (!UIDeviceOrientationIsValidInterfaceOrientation(currentOrientation)) {
      
        return;
    }
    _layout.itemSize = CGSizeMake((self.view.bounds.size.width-12)/3, (self.view.bounds.size.width-12)/3);
    [_galaryCollectionView setCollectionViewLayout:_layout];
    
    NSLog(@"%f", self.view.bounds.size.width);
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // goto setting
    if (buttonIndex == 1) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark - showMessage

- (void)showMessage:(NSString *)message withTitle:(NSString *)title {
    
    if ([UIAlertController class]) {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* settingButton = [UIAlertAction actionWithTitle:@"GO TO SETTING" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        
        UIAlertAction* closeButton = [UIAlertAction actionWithTitle:@"CLOSE" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:settingButton];
        [alert addAction:closeButton];
        
        UIViewController* vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        [vc presentViewController:alert animated:YES completion:nil];
    } else {
        
        [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"CLOSE" otherButtonTitles:@"GO TO SETTING", nil] show];
    }
}

@end
