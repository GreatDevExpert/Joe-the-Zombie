//
//  RootViewController.h
//  Zombie Joe
//
//  Created by Mac4user on 4/29/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RootViewController : UIViewController {
    UIDeviceOrientation *orientation;
    bool rotate;
}
-(void)setOrientation:(BOOL)bool_;
@end
