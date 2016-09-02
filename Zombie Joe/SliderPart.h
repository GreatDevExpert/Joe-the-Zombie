//
//  SliderPart.h
//  Zombie Joe
//
//  Created by Mac4user on 4/29/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SliderPart : CCSprite <CCTargetedTouchDelegate> {
    
        CGPoint     whereTouch;
        BOOL movable;
        BOOL touching;
        CCSprite *trackArea;
        CCSprite *trackAreaBrain;
        int collumnNr;
        BOOL moving;
   //     id<sliderDelegate> delegate;
        CCSpriteBatchNode *spritesBgNode;
        CCSpriteBatchNode *otherBatchnode;
        CCSprite *Slider;
        BOOL tint;
        BOOL moveUP;
        BOOL directionUP;
        float speed;
        float posMax;
        BOOL touchable;
    
}

-(void)MANA_ON;

-(void)MANA_OFF;

@property (assign) float speed;
@property (assign) BOOL touching;
@property (assign) BOOL movable;

@property (nonatomic,retain)  CCSprite *trackArea;
@property (nonatomic,retain)  CCSprite *trackAreaBrain;
//@property (nonatomic,retain) id delegate;
@property (nonatomic,retain) CCSpriteBatchNode *spritesBgNode;

-(id)initWithRect:(CGRect)rect tag:(int)_tag;

-(void)startMoving:(BOOL)slow :(BOOL)up_;

-(void)tintToRed;

-(void)closeTRAP;

@end
