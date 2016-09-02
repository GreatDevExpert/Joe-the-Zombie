// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "JOE_C.h"
#import "PauseMenu.h"

// Add to top of file
#import "MyContactListener.h"

#import "InGameButtons.h"
#import "JoeZombieController.h"

#import "BrainRobot.h"

// Level6
@interface Level6 : CCLayer<pauseDelegate>
{
    CGSize winSize;
    
    MyContactListener *_contactListener;
    
    //JOE_C *playerWalk;
    JoeZombieController *m_zombieCostume;
    
    CCSpriteBatchNode *items;
    
    CCSprite *backgroundBegin;
    CCSprite *backgroundCenter1;
    CCSprite *backgroundCenter2;
    CCSprite *backgroundFinal;
    
    CCSprite *lavaSp;
    CCSprite *lavaSp2;
    CCSprite *redBird1;
    CCSprite *redBird2;
    CCSprite *redBird3;
    CCSprite *redBird4;
    CCSprite *monster;
    CCSprite *birdGround;
    CCSprite *cloud0;
    CCSprite *cloud1;
    CCSprite *cloud2;
    CCSprite *cloud3;
    CCSprite *cloud4;
    CCSprite *cloud5;
    
    BrainRobot *brain1;
    BrainRobot *brain2;
    BrainRobot *brain3;
    
    
    // WORLD -------------------
	b2World* m_world;
    GLESDebugDraw *_debugDraw;
    
    // GROUND ------------------
    CCSprite *m_groundCostume;
    b2Body* m_groundBody;
    b2Fixture* m_groundFixture;
    b2BodyDef groundBodyDef;
    
    // LAVA --------------------
    CCSprite *m_lavaCostume;
    b2Body* m_lavaBody;
    b2Fixture* m_lavaFixture;
    b2BodyDef lavaBodyDef;
    
    // SIDE WALL ---------------
    b2Body* m_sideBody;
    b2Fixture* m_sideFixture;
    b2BodyDef sideBodyDef;
    
    // WIN Wall! ---------------
    b2Body* m_winBody;
    b2Fixture* m_winFixture;
    b2BodyDef winBodyDef;
    
    // PLAYER ------------------
    //CCSprite *m_zombieCostume;
    b2Body *m_zombieBody;
    b2Fixture *m_zombieFixture;
    b2BodyDef zombieBodyDef;
    
    // PLATFORMS ---------------
    CCSprite *m_platformCostume_;
    
    b2Body* m_platformBody_;
    b2BodyDef platformBodyDef_;
    
    CCSprite *m_platformCostume;
    b2Fixture* m_platformFixture_;
    b2FixtureDef* m_platformFixture_def;
    // --------------------------
    
    BOOL isContact;
    BOOL isJump;
    
    BOOL movingRight;
    BOOL movingLeft;
    
    BOOL moveToWin;
    BOOL isFinish;
    BOOL isGameOver;
    BOOL over;
    int onWalk;
    
    BOOL lavaActionDone;
    
    BOOL pause;
    
    BOOL brain1Taked;
    BOOL brain2Taked;
    BOOL brain3Taked;
    
    int hOnPlatform;
    
    int worldPosition;
    int objectsNumber;
    
    int monsterTouchNumber;
    int brainRealese;
    
    int GroundMoveDirectionX;
    int moveDirection;
    int moveDirection2;
    int moveDirection3;
    int moveDirection4;
    int moveDirection5;
    
    InGameButtons * _hud;
    
    Float32 backVel;
    
    BOOL pBounce;
    
    BOOL flipX;
    BOOL flipXxx;
    
    BOOL flipXleft;
    BOOL flipXright;
    
    BOOL velZero;
    BOOL runidle;
}

- (id)initWithHUD:(InGameButtons *)hud;

-(void) createWorldDetails;
-(void) createWorldBackgrounds;

@end
