//
//  AppDelegate.h
//  Zombie Joe
//
//  Created by Mac4user on 4/29/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    BOOL minimized;
}

@property (nonatomic, retain) UIWindow *window;
@property (assign) BOOL minimized;
-(void)setOrientationLandscape:(BOOL)bool_;

@end


