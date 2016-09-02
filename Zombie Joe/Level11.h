//
//  Level11.h
//  project_box2d
//
//  Created by Slavian on 2013-06-10.
//
//

#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import <CoreMotion/CoreMotion.h>
#import "MyContactListenerS.h"
#import "VRope.h"

#import "InGameButtons.h"
#import "PauseMenu.h"

@interface Level11 : CCLayer<pauseDelegate,CCTargetedTouchDelegate>
{
    
        InGameButtons * _hud;
    MyContactListenerS *_contactListener;
    b2World* _world;
    b2Body * _body;
    
    int segmentNum;
    CGPoint whereTouch;
    CGPoint touchB;
    
    float _beeMovDuration;
    int _delay;
    
    bool gameOver;
    bool endOfTheGame;
    bool spiderGoOn;
    bool spiderTouched;
    bool bonusBrains;
    bool birdTouched;
    bool watchUp;
    bool watchUp1;
    bool watchUp2;
    bool pause;
    bool canTut;
    bool soundFX;
    
    b2Body *wall_left_Body;
    b2Body *wall_right_Body;
    b2Body* groundBody;
    b2Body *ropePT_1;
    b2Body *ropePT_2;
    
    VRope *newRope;
    
    NSMutableArray *ropes;
    NSMutableArray *candies;
    
    CCSpriteBatchNode *ropeSpriteSheet;

    b2MouseJoint *mouseJoint;
    b2Body* referenceBody;
    
        BOOL CAN_TOUCH;
}

- (id)initWithHUD:(InGameButtons *)hud;

+(CCScene *) scene;

-(void)GAME_RESUME;
-(void)GAME_PAUSE;
@end


