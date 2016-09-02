#import "cocos2d.h"

#import "PauseMenu.h"
#import "InGameButtons.h"

@interface Level4 : CCLayer <pauseDelegate>
{
    float speed;
    int cristalCount;
    int brainCount;
    int count;
    enum{
        STATE_NORMAL_,
        STATE_JUMP_,
        STATE_GAMEOVER_
    }m_state;
    CCSpriteBatchNode *spriteBatchNode;
    InGameButtons * _hud;
    
    BOOL canTouchHEADS;
    bool itsBrain;
    bool gearHit;
    bool brain1IsTouched;
    bool brain2IsTouched;
    bool pause;
    BOOL tutorial;
    BOOL canShowTut;
    bool doorIsOpen;
    
}

- (id)initWithHUD:(InGameButtons *)hud;
-(void)GAME_RESUME;
-(void)GAME_PAUSE;
@end

