
//#import "CCSprite.h"
#import "cocos2d.h"

#define SWIPE_LEFT 1
#define SWIPE_RIGHT 2
#define SWIPE_UP 3
#define SWIPE_DOWN 4

@interface Tutorial : CCSprite
{
    

    
}

-(int)whatTagIsLegal;

-(BOOL)thereAreTutorialsRunning;

-(id)init;
-(void)createBaloon;
-(void)stopTutorials;
-(void)TAP_TutorialRepeat:(int)times_ delay:(float)delay_ runAfterDelay:(float)del_;
-(void)SWIPE_TutorialWithDirection:(int)direction times:(int)times_ delay:(float)delay_ runAfterDelay:(float)del_;
-(void)TILT_TrutorialRepaet:(int)times_ runAfterDelay:(float)del_ quadro:(BOOL)bool__;
-(void)ROTATE_TutorialRepeat:(int)times_ delay:(float)delay_ runAfterDelay:(float)del_;
-(void)TAP_Special_For_8LVL;
@end
