

#import "cocos2d.h"
#import "PauseMenu.h"
#import "InGameButtons.h"
#import "JOE_C.h"
#import "BrainsBonus.h"
#import "JoeZombieController.h"

@interface Level3 : CCLayer <pauseDelegate,CCTargetedTouchDelegate>
{
    JoeZombieController *playerImage;
    CCSprite *colon;
    CCSprite *badFish;
    BrainsBonus *brain;
    CCSprite *bird;
    CCSpriteBatchNode *spritesBgNode;
    float x;
    float y;
    float angle;
    int brainCount;
    int tagOfSprite;
    enum{
        STATE_NORMAL,
        STATE_JUMP,
        STATE_GAMEOVER,
        STATE_BRAIN_TAKED,
        STATE_BRAIN_TAKED2,
        STATE_BRAIN_TAKED3
    }m_state;
    
    bool brainWasTaked;
    bool brainWasTaked3;
    bool brainWasTaked2;
    bool getPlayer;
    bool secretItem;
    bool gameState;
    bool on3;
    bool b_birdTap;
    bool exitArrow;
    bool pause;
    bool tutorialWasShowed;
    bool soundFX;
    
    InGameButtons * _hud;
    
}

- (id)initWithHUD:(InGameButtons *)hud;
-(void)GAME_RESUME;
-(void)GAME_PAUSE;

@end
