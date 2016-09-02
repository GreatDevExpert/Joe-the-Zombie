//
//  Level5.h
//  Zombie Joe
//
//  Created by Mac4user on 4/29/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SliderPart.h"
#import "GoinCharacter.h"

#import "PauseMenu.h"
#import "InGameButtons.h"

@interface Level5 : CCLayer <pauseDelegate>{
 
    GoinCharacter *CHARACTER_GO;
    BOOL alive;
    CCSpriteBatchNode *spritesBgNode;
    
    CCSpriteBatchNode *spyglsBatch;
    CGPoint     whereTouch;
    int tagTouched;
    
    CCSpriteBatchNode *spriteBatchNode;
    InGameButtons * _hud;
    
    int ONTRACK;
    float ONTRACK_Y;
    
    BOOL trapped;
    
    BOOL WIN;
    
    BOOL brainMIDDLE;
    BOOL brainTOP;
    BOOL brainBOTOM;
    
    BOOL PAUSED;
    BOOL savetut;
    
}
- (id)initWithHUD:(InGameButtons *)hud;

-(void)GAME_PAUSE;

-(void)GAME_RESUME;

//@property (nonatomic,retain) GoinCharacter *CHARACTER_GO;

@end
