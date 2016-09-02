
//  Created by Eimio on 6/19/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

#import "LevelHelperLoader.h"


#import "PauseMenu.h"
#import "InGameButtons.h"
#import "JoeZombieController.h"
#import "BrainRobot.h"

#define PTM_RATIO [LevelHelperLoader pointsToMeterRatio]



// Level10
@interface Level12 : CCLayer <pauseDelegate>
{
    LevelHelperLoader* level12_loader;
    
    b2World* world;
    GLESDebugDraw *m_debugDraw;
    
    LHParallaxNode* paralaxNode;
    
    LHJoint* zombieCocos;
    
    JoeZombieController *m_zombieCostume;
    
    BOOL brain1;
    BOOL brain2;
    BOOL brain3;
    BOOL drawHUD;
    BOOL isMovingLeft;
    BOOL isMovingRight;
    BOOL isMovingToFinish;
    BOOL isGameOver;
    BOOL isFinish;
    BOOL isGetFaster;
    BOOL isGetSlower;
    BOOL isJump;
    BOOL isOnGrid;
    
    BOOL isOnFirstPlatform;
    BOOL isOnSecondPlatform;
    
    BOOL getDown;
    BOOL isTouch;
    
    BOOL headStays;
    BOOL headJumps;
    
    BOOL alreadyDead;
    
    BOOL touchEnded;
    
    BOOL pause;
    
    BOOL flipX;
    BOOL flip;
    
    BOOL speedUp;
    BOOL speedDown;
    
    BOOL bricksHit;
    
    CGFloat Fdistance;
    
    BOOL offTutorial;
    
    CCSprite *cocRight;
    CCSprite *cocLeft;
    
    CGPoint touchBeg;
    CGPoint touchEnd;
    
    BrainRobot *BrainSprite1;
    BrainRobot *BrainSprite2;
    BrainRobot *BrainSprite3;
    
    InGameButtons * _hud;
    
}

// returns a CCScene that contains the Level10 as the only child
-(void) retrieveRequiredObjects;

- (id)initWithHUD:(InGameButtons *)hud;

@end

