//
//  AppDelegate.h
//  GalaryDemo
//
//  Created by Doan Van Vu on 9/30/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

