//
//  HelloWorldLayer.h
//  Level 14
//
//  Created by macbook on 2013-06-17.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "LevelHelperLoader.h"
#import "JoeAndFlyiers.h"
#import "JoeZombieController.h"
#import "b6luxParallaxBg.h"

#import <CoreMotion/CoreMotion.h>

#import "PauseMenu.h"
#import "InGameButtons.h"

@interface Level14 : CCLayer<CCTargetedTouchDelegate,pauseDelegate>
{
    InGameButtons * _hud;
    
	b2World* world;
	GLESDebugDraw *m_debugDraw;
    
    LevelHelperLoader *loader;
    
    float oldVelocityY;
  
    float PITCH;
    
    BOOL enableJUMP;
    
    BOOL dead;
    
    BOOL pause;
    
    JoeZombieController *zombiebody;
    
    b6luxParallaxBg *bgParalaxxx;
    
    int wallsCollided;
    
    JoeAndFlyiers *jNf;
    
    float ropeBeginYPoint;
    float ropeEndYPoint;
    
    float enterRopeVelocityY;
    float exitRopeVelocityY;
    
    BOOL ropeBeginContact;
    
    float fistScaleYDist;
    
    BOOL giraffeTouched;
    
    BOOL removeWorld;
    
    BOOL enableFliersFallowBody;
    BOOL enableZombieFollowFliers;
    
    BOOL enableAccelerometer;
    
    float LINE_X;
    
    CGPoint pt_;
    
    BOOL birdSound;
    
    BOOL death;
    
    BOOL canTouch;
}

- (id)initWithHUD:(InGameButtons *)hud;

@end
