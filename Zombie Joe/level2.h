//  Created by Eimio on 4/23/13.

#import "cocos2d.h"
#import <Foundation/Foundation.h>
#import "droplet.h"
#import "PauseMenu.h"
#import "InGameButtons.h"
#import "JOE_C.h"
#import "JoeZombieController.h"
#import "BrainRobot.h"

#import <CoreMotion/CoreMotion.h>

@interface level2 : CCLayer<pauseDelegate>
{
    
    CCSpriteBatchNode *items;
    
    CMMotionManager *motionManager;
    
    CCLabelBMFont *LblScore;
    CCLabelBMFont *LblPercnt;
    
    JoeZombieController *zombie;
    
    droplet *drop;

    CCSprite *glasscup;
    CCSprite *raft;
    CCSprite *bgSp;

    CCSprite *world_2;
    CCSprite *world_3;
    CCSprite *clouds_1;
    CCSprite *clouds_2;
    CCSprite *clouds_3;
    CCSprite *clouds_4;
    CCSprite *clouds_5;
    
    CCSprite *wave_1;
    CCSprite *wave_2;
    
    CCSprite *kolona_1;
    CCSprite *kolona_2;
    
    CCSprite *monster;
    CCSprite *monsterLeft;
    CCSprite *monsterRight;
    CCSprite *bottle;
    
    BrainRobot *BrainSprite1;
    BrainRobot *BrainSprite2;
    BrainRobot *BrainSprite3;
    
    CCSprite *water_0;
    CCSprite *water_1;
    CCSprite *water_2;
    CCSprite *water_3;
    CCSprite *water_4;
    
    CCLabelTTF *dropletLabel;
    CCLabelTTF *scoreLabel;
    CCLabelTTF *scoreLabelCount;
    
    CCRepeatForever *MactionsRepeat;
    CCRepeatForever *MactionsRepeat2;
    CCRepeatForever *MactionsRepeat22;
    
    float intervalWas;
    float intervalMine;

    BOOL moreBadDroplet;
    int badNr;

    float cupSpeedX;
    float newX;
    
    float rotAngleNumber;
    
    int rotationAngle;
    int angle;
    
    float roll;
    float pitch2;
    
    int monsterTouchNumber;
    
    int BrainTime;
    
    int orient;
    
    int dropletPercent;
    int dropletNumber;
    int dropletCounter;
    int randNumber;
    int randPosition;
    int rand;
    int rand2;
    int score;
    
    int brainRealese;

    int finalBrainNumber;
    bool finalGameState;
    bool finalSecretItem;
    
    bool dropAnim;
    
    bool monsterDead;
    
    bool pause;

    bool brain_1;
    bool brain_2;
    bool brain_3;
    
    bool b1;
    bool b2;
    
    bool side;

    bool isFinish;
    bool DevLeft;
    bool DevRight;
    
    BOOL monsterGavedBrain;
    
    enum
    {
        STATUS_NORMAL = 0,
        STATUS_LOAD,
        STATUS_START,
        STATUS_FINISH,
        
    }m_status;
    
    InGameButtons * _hud;
}

@property (nonatomic,retain) CMMotionManager *motionManager;
@property (nonatomic,retain) JoeZombieController *zombie;

- (id)initWithHUD:(InGameButtons *)hud;

-(void) worldDetailsUpdate;
-(void) LoadWorldDetails;
-(void) chekingProgres;
-(void) chekingBoundingBoxes;

-(void)GAME_RESUME;
-(void)GAME_PAUSE;

+(CCScene *) scene;

@end
