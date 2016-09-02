//
//  Level1.h
//  Zombie Joe
//
//  Created by Mac4user on 4/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "FillCharacter.h"


//add headers
#import "PauseMenu.h"
#import "InGameButtons.h"


@interface Level1 : CCLayer <pauseDelegate,CCTargetedTouchDelegate> {
    
     InGameButtons * _hud;
    
    BOOL T_BIRDTAP;
    BOOL T_JOEHEADTAP;
    BOOL T_POPUPMONEY;
    BOOL T_SHOW_TUTORIAL;
    
    float YFIX;
    float XFIX;
    BOOL pause;
    
    CCSpriteBatchNode *spritesBgNode;
    FillCharacter *FILL_CHAR;
    CCParticleSystemQuad *effectBorn;
    
    
    float bodX;
    float bodY;
    
    BOOL fallow;
    
    int bonus;
    int bonus1_touched;

    BOOL brainOnWood;
    CGPoint     whereTouch;
    
    int fallowEffect;
    
    BOOL birdBrain;
    BOOL brainLeft;
    BOOL brainRIght;
    
}

//@property (nonatomic,retain) FillCharacter *FILL_CHAR;

-(void)_hudLevelPassed;

-(void)missionCompleted;

- (id)initWithHUD:(InGameButtons *)hud;

@end
