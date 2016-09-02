//
//  HelloWorldLayer.h
//  Level13
//
//  Created by macbook on 2013-06-15.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

#import "LevelHelperLoader.h"

#import "PauseMenu.h"
#import "InGameButtons.h"

#import "GoinCharacter.h"


// HelloWorldLayer
@interface Level13 : CCLayer <CCTargetedTouchDelegate,pauseDelegate>
{
    
    InGameButtons * _hud;
    
	b2World* world;
	GLESDebugDraw *m_debugDraw;
    
    LevelHelperLoader *loader;
    int newLegalDirection;
    int lastLegalDirecton;
    BOOL canMove;
    
    BOOL snakeBrain;
    BOOL brain1;
    BOOL brain2;
    
    CGPoint     whereTouch;
    CGPoint     lastDirection;
    CGPoint      firstTouch;
    
    CGPoint limmitBoxPos;
    
    int directionForSprite;
    int touchedTAG;
    LHSprite* touchedNode;
    
    CGSize screenSize;
    
    GoinCharacter *JOE;
    
    BOOL questionFallowBox;
    
    
    BOOL canTouch;
    
    BOOL wasMoved;
    
    BOOL canMakeSoundMove;
    

    
}

- (id)initWithHUD:(InGameButtons *)hud;

// returns a CCScene that contains the HelloWorldLayer as the only child
//+(CCScene *) scene;


@end
