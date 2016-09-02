//
//  Level10.h
//  Level10_LH
//
//  Created by Eimio on 5/22/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

#import "LevelHelperLoader.h"


#import "PauseMenu.h"
#import "InGameButtons.h"

#import "BrainRobot.h"

#define PTM_RATIO [LevelHelperLoader pointsToMeterRatio]

// Level10
@interface Level10 : CCLayer<pauseDelegate>
{
    LevelHelperLoader* level10_loader;

    b2RevoluteJoint *carMotor;

    b2WheelJoint *M1_carMotor;

    LHJoint* myWheel;
    LHJoint* monster1Wheel;
    

    b2Vec2 force;
    
    LHParallaxNode* paralaxNode;
    
    LHSprite*   carCostume;
    b2Body*     carBody;
    
	b2World* world;
	GLESDebugDraw *m_debugDraw;
    
    float speed;
    float heightD;
    
    int secJump;
    
    bool pause;
    
    bool looseSnd;

    BOOL isJump;
    BOOL isOnGrid;
    BOOL isTouchMonster;
    BOOL isDead;
    BOOL isEngine;
    BOOL isFinish;
    BOOL isOnSlow;
    
    BOOL brain1;
    BOOL brain2;
    BOOL brain3;
    
    BOOL drawHUD;
    
    BOOL offTutorial;
    
    BrainRobot *BrainSprite1;
    BrainRobot *BrainSprite2;
    BrainRobot *BrainSprite3;
    
    InGameButtons * _hud;

}

-(void) retrieveRequiredObjects;

- (id)initWithHUD:(InGameButtons *)hud;

@end
