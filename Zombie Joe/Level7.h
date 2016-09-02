//
//  Level5.h
//  Zombie Joe
//
//  Created by Mac4user on 4/29/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GoinCharacter.h"
#import "rotateBlock.h"

#import "PauseMenu.h"
#import "InGameButtons.h"

@interface Level7 : CCLayer <pauseDelegate>{
 
    GoinCharacter *CHARACTER_GO;
    BOOL alive;
    CCSpriteBatchNode *spritesBgNode;
    CGPoint     whereTouch;
    BOOL jumping;
    int onBlockTag;
    BOOL repositionScreen;
    CGPoint *startPoint;
    BOOL wasInCenter;
    float movedLeft;
    int lastBlock;
    BOOL moveSelf;
    CCSprite *background;
    CCNode *par;
    
    int BRAINS_COLLECTED;
    InGameButtons * _hud;
    
    BOOL firstJump;
    
    BOOL brain1;
    BOOL brain2;
    BOOL brain3;
    
    BOOL moveToBlock;
    
    BOOL enableJUMP;
    
    BOOL WINLEVEL;
    
    BOOL PAUSED;
    
    BOOL aligatorSound;

   // JoeZombieController *joeController;
    
}
- (id)initWithHUD:(InGameButtons *)hud;

@property (nonatomic,retain) GoinCharacter *CHARACTER_GO;

@end
