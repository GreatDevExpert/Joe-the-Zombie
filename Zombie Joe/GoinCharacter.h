//
//  GoinCharacter.h
//  Zombie Joe
//
//  Created by Mac4user on 4/29/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cfg.h" 
#import "Constants.h"

@interface GoinCharacter : CCSprite <CCTargetedTouchDelegate> {
    
    CCSpriteBatchNode *spritesBgNode;
    CCSprite *body;
    CCSprite *hat;
    CCSprite *shadow;
    
    BOOL arrow;
}

-(void)hideArrows;
-(void)showArrows;

-(void)drawForwardArrow;

-(void)inlavaAction;
-(id)initWithRect:(CGRect)rect tag:(int)_tag;
-(CGPoint)getArrowHead;
-(void)scaleForever;
-(void)stopHatAction;

-(void)scaleUpDown;

-(void)spinPropeller_Default:(BOOL)default_;

-(void)ramaMove;

-(void)ramaMoveBy;

-(void)colorAllBodyPartsWithColor:(ccColor3B)c_ restore:(BOOL)restore_ restoreAfterDelay:(float)delay_;

-(void)ACtion_WalkToSceneAndBack:(float)delay_ pos:(CGPoint)pos_;

-(void)Action_WALK_SetDelay:(float)delay_ funForever:(BOOL)forever_;

-(void)Action_IDLE_SetDelay:(float)delay_ funForever:(BOOL)forever_;

-(void)hide_shadow:(BOOL)yes_;

@property (nonatomic,retain) CCSprite *body;
@end
