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

@interface Level5 : CCLayer <pauseDelegate,sliderDelegate>{
 
    GoinCharacter *CHARACTER_GO;
    BOOL alive;
    CCSpriteBatchNode *spritesBgNode;
    CGPoint     whereTouch;
    int tagTouched;
    
}

+(CCScene *) scene;

@property (nonatomic,retain) GoinCharacter *CHARACTER_GO;

@end
