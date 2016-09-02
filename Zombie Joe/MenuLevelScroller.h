//
//  MenuLevelScroller.h
//  Zombie Joe
//
//  Created by Mac4user on 4/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ScrollingNode.h"

@interface MenuLevelScroller : CCNode {
    
    id admin;
    ScrollingNode *scrollingNode ;
    int LEVELNUMBER;
    
    UIScrollView *scrollView;
    
}

@property (nonatomic,retain) id admin;
//@property (assign) int LEVELNUMBER;

-(void)purchaseWasDone_RefreshButtons;
-(void)disableScroll:(BOOL)bool_;
-(id)initWithRect:(CGRect)rect;
-(void)goToGameLevel:(NSNumber*)lev;
-(void)openLockedLevelPopup:(NSNumber*)lev_;

-(int)nrOfLevels;

@end
