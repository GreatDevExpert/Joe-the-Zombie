//
//  ScrollingNode.h
//  Cocos2dScrolling
//
//  Created by Tony Ngo on 11/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ScrollingNode : CCNode<UIScrollViewDelegate,CCTargetedTouchDelegate> {
    
   CCSpriteBatchNode *spritesBgNode;
    NSTimer *timer_ ;
    id admin;
    int LEVELS_NR;
    BOOL canTouch;

}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic,retain) id admin;
@property (assign) int LEVELS_NR;


@end
