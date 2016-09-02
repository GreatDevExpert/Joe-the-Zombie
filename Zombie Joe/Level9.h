//
//  Level9.h
//  project_box2d
//
//  Created by Slavian on 2013-05-09.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import <CoreMotion/CoreMotion.h>
#import "MyContactListenerS.h"

#import "InGameButtons.h"
#import "PauseMenu.h"

#import "JoeZombieController.h"

#define PTM_RATIO 32.0
// Level9
@interface Level9 : CCLayer<pauseDelegate>
{
        InGameButtons * _hud;
    
    JoeZombieController *joerobot;
    
    MyContactListenerS *_contactListener;
    CCSpriteBatchNode *spriteBatchNode;
    CCSpriteBatchNode *spriteBatchNode2;
    int screenCount;
    float currentPos;
	b2World* _world;
	b2Body *_body;
    bool moveForward;
    bool moveBack;
    bool m_moveForward;
    bool endFlag;
    bool eatFlag;
    bool hitmonster;
    bool touchDisabled;
    bool brainTouched;
    bool brainFlag;
    bool brainFlag2;
    bool kickAss;
    bool b_brain1;
    bool b_brain2;
    bool b_brain3;
    bool pause;
    bool blast;
    bool iddle_s;
    bool notIddle_s;
    bool propelerFakeFix;
    
    float LINE_X;
    
    CCSprite *propeller;
    
    
   //bool stopGame;
    CCLabelTTF *label;
    b2Body *wall_left_Body;
    b2Body *wall_right_Body;
    float _acceleration;
    enum{
        lvl9_STATE_NORMAL,
        lvl9_STATE_JUMP
    }m_state;
    //CMMotionManager *motionManager;
    int orient;
}
//@property (nonatomic,retain) CMMotionManager *motionManager;
+(CCScene *) scene;

- (id)initWithHUD:(InGameButtons *)hud;

-(void) addNewSpriteWithCoords:(CGPoint)p;
-(void) kick;
-(void)endOfTheGAME:(NSNumber*)num;
-(void)GAME_RESUME;
-(void)GAME_PAUSE;
@end
