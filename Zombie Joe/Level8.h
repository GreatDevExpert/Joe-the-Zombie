//
//  Level5.h
//  Zombie Joe
//
//  Created by Mac4user on 4/29/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "PauseMenu.h"
//#import "BlockField.h"

#import "InGameButtons.h"
#import "Lightning.h"
#import "JOE_C.h"
#import "HatSpin.h"

#import "JoeZombieController.h"

@interface Level8 : CCLayer<pauseDelegate>{
 
    CCRibbon *ribbon1;
    
    CGPoint pointBefore;
    int angleNext;
    
    NSMutableArray *pointsArr;

    CGPoint     whereTouch;
    
    int touchedTag;
    BOOL touchBegan;
    
    int diamondCaughtTag;
    
   // BlockField *BLOCKS;
    
    float parW;
    float parH;
    
    float parX;
    float parY;
    
    CCSpriteBatchNode *spritesBgNode;
    
    BOOL laserSTOP;
    
    BOOL success;
    InGameButtons * _hud;
    
    BOOL letDraw;
    
    BOOL reCALC;
    
    int LastplaceID;
    int notMovable;
    int notMovable2;
    
    JoeZombieController *JOE;
    
    BOOL dragging;
    
    HatSpin *HAT;
    
    BOOL enableTouch;
    
    BOOL b1;
    BOOL b2;
    BOOL b3;
    
    BOOL PAUSED;
    
    BOOL tutorial;
 
    
}
- (id)initWithHUD:(InGameButtons *)hud;

//@property (nonatomic,retain)    BlockField *BLOCKS;
@property (nonatomic,retain)     Lightning *lightning;
@property (nonatomic,retain)     Lightning *lightning2;
@property (nonatomic,retain)     NSMutableArray *pointsArr;
//@property (nonatomic,retain)    JoeZombieController *JOE;


@end
