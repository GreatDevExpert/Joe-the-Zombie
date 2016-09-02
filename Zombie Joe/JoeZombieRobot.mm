//
//  JoeZombieController.m
//  Zombie Joe
//
//  Created by macbook on 2013-07-18.
//
//

#define TAG_HEAD            0
#define TAG_EYE_LEFT        1
#define TAG_EYE_RIGHT       2
#define TAG_HAND_LEFT       3
#define TAG_HAND_RIGHT      4
#define TAG_SHOE_LEFT       5
#define TAG_SHOE_RIGHT      6
#define TAG_TSHIRT          7
#define TAG_PANTS           8
#define TAG_PROPELLER       9
#define TAG_EYES_CLOSED     10
#define TAG_NECK            11
#define TAG_HAT             12
#define TAG_LEG_LEFT        13
#define TAG_LEG_RIGHT       14
#define TAG_ARM_LEFT        15
#define TAG_ARM_RIGHT       16
#define TAG_TOOTH           17
#define TAG_EYE_REFLE_LEFT  18
#define TAG_EYE_REFLE_RIGHT 19

#define STATE_IDLE_1         0
#define STATE_JUMP_1         1
#define STATE_JUMP_2         2
#define STATE_JUMP_3         3
#define STATE_IDLE_2         4
#define STATE_WALK_1         5
#define STATE_WALK_2         6
#define STATE_HANG_LEFT      7
#define STATE_HANG_RIGHT     8
#define STATE_HANG_STRAIGHT  9


#import "JoeZombieRobot.h"
#import "cfg.h"

@implementation JoeZombieRobot

-(void)initContent{
    
    [self ACTION_EyesBlink_WithObject:PART(TAG_EYES_CLOSED)
                           openedTime:3.5f closedTime:0.15f
                           startRandomly:YES
                           durationOpen:0.05f durationClose:0.05f blinkTimes:2];

   // [self JOE_WALK];
}

-(void)JOE_WALK_SPEED:(float)speed_{
    // ** flip shoe
    
    CCSprite *shoeL = PART(TAG_SHOE_LEFT);
    shoeL.flipX = -1;
    
    [self ACTION_StopAllPartsAnimations_Clean:YES];
    
    
    [self ACTION_SetAnimationState:STATE_WALK_1    priority:0 duration:0.25f/speed_];
    [self ACTION_SetAnimationState:STATE_WALK_2    priority:1 duration:0.35f/speed_];
    [self ACTION_SetAnimationState:STATE_IDLE_1    priority:2 duration:0.25f/speed_];
    
    [self ACTION_PlayAnimation_Repeat:YES];
    
}

-(void)JOE_WALK{
    // ** flip shoe
    
    CCSprite *shoeL = PART(TAG_SHOE_LEFT);
    shoeL.flipX = -1;
    
    [self ACTION_StopAllPartsAnimations_Clean:YES];
    

    [self ACTION_SetAnimationState:STATE_WALK_1    priority:0 duration:0.25f];
    [self ACTION_SetAnimationState:STATE_WALK_2    priority:1 duration:0.35f];
    [self ACTION_SetAnimationState:STATE_IDLE_1    priority:2 duration:0.25f];
    
    [self ACTION_PlayAnimation_Repeat:YES];
    
}

-(void)JOE_JUMP_MENU_TOUCH{
    
    
    
}

-(void)JOE_IDLE_MENU{
    
    [self ACTION_RemoveStateByID:3];
    
    [self ACTION_SetAnimationState:STATE_IDLE_1    priority:0 duration:0.10f];
    [self ACTION_SetAnimationState:STATE_IDLE_2    priority:1 duration:0.75f];
    [self ACTION_SetAnimationState:STATE_IDLE_1    priority:2 duration:0.55f];
    
    [self ACTION_PlayAnimation_Repeat:YES];
    
}

-(void)JOE_JUMP_MENU:(int)speed_{
    
    [self ACTION_SetAnimationState:STATE_JUMP_1    priority:0 duration:0.1f*speed_];
    [self ACTION_SetAnimationState:STATE_JUMP_2    priority:1 duration:0.3f*speed_];
    [self ACTION_SetAnimationState:STATE_JUMP_1    priority:2 duration:0.125f*speed_];
    [self ACTION_SetAnimationState:STATE_JUMP_3    priority:3 duration:0.1f*speed_];
    
    [self ACTION_PlayAnimation_Repeat:NO];
    
}

-(void)JOE_IDLE{
    
    [self ACTION_SetAnimationState:STATE_IDLE_1    priority:0 duration:0.65f];
    [self ACTION_SetAnimationState:STATE_IDLE_2    priority:1 duration:0.75f];
    
    [self ACTION_PlayAnimation_Repeat:YES];

}

-(void)JOE_JUMP_LEVEL_6{
    
    [self ACTION_SetAnimationState:STATE_JUMP_1    priority:0 duration:0.1f];
    [self ACTION_SetAnimationState:STATE_JUMP_2    priority:1 duration:0.3f];
    [self ACTION_SetAnimationState:STATE_JUMP_1    priority:2 duration:0.125f];
    [self ACTION_SetAnimationState:STATE_JUMP_3    priority:3 duration:0.1f];
    [self ACTION_SetAnimationState:STATE_IDLE_1    priority:4 duration:0.1f];
    
    [self ACTION_PlayAnimation_Repeat:NO];
    
}

-(void)JOE_JUMP_UP{
    
    [self ACTION_SetAnimationState:STATE_IDLE_1    priority:0 duration:0.1f];
    [self ACTION_SetAnimationState:STATE_JUMP_1    priority:1 duration:0.1f];
    [self ACTION_SetAnimationState:STATE_JUMP_2    priority:2 duration:0.2f];
    [self ACTION_SetAnimationState:STATE_JUMP_1    priority:3 duration:0.1f];
    [self ACTION_SetAnimationState:STATE_JUMP_3    priority:4 duration:0.11f];
    
    [self ACTION_PlayAnimation_Repeat:NO];
    
}

-(void)JOE_HIDE:(int)x_{
    
    
    
}

-(void)JOE_JUMP_LEVEL_4
{
    if (IS_IPAD)
    {
        [self ACTION_SetAnimationState:STATE_JUMP_1    priority:0 duration: 0.10f];
        [self ACTION_SetAnimationState:STATE_JUMP_2    priority:1 duration: 0.20f];
        [self ACTION_SetAnimationState:STATE_JUMP_1    priority:2 duration: 0.20f];
        [self ACTION_SetAnimationState:STATE_JUMP_3    priority:3 duration: 0.10f];
        [self ACTION_SetAnimationState:STATE_IDLE_1    priority:4 duration: 0.10f];
        
        [self ACTION_PlayAnimation_Repeat:NO];
    }
    else
    {
        [self ACTION_StopAllPartsAnimations_Clean:YES];
        
        [self ACTION_SetAnimationState:STATE_JUMP_1    priority:0 duration: 0.10f];
        [self ACTION_SetAnimationState:STATE_JUMP_2    priority:1 duration: 0.20f];
        [self ACTION_SetAnimationState:STATE_JUMP_1    priority:2 duration: 0.10f];
        [self ACTION_SetAnimationState:STATE_JUMP_3    priority:3 duration: 0.02f];
        [self ACTION_SetAnimationState:STATE_IDLE_1    priority:4 duration: 0.05f];
        
        [self ACTION_PlayAnimation_Repeat:NO];
    }
}

-(void)JOE_IDLE_CUSTOM:(float)speed_{
    
    [self ACTION_SetAnimationState:STATE_IDLE_1    priority:0 duration:0.65f*speed_];
    [self ACTION_SetAnimationState:STATE_IDLE_2    priority:1 duration:0.75f*speed_];
    
    [self ACTION_PlayAnimation_Repeat:NO];
    
}

-(void)JOE_HANGING_RIGHT{

    if(
       [self ACTION_SetAnimationState:STATE_HANG_RIGHT     priority:0 duration:0.25f]
       )
    {
        [self ACTION_StopAllPartsAnimations_Clean:YES];
        [self ACTION_SetAnimationState:STATE_HANG_RIGHT     priority:0 duration:0.25f];
        [self ACTION_PlayAnimation_Repeat:NO];
    }
    
}

-(void)JOE_HANGING_LEFT{

    
    if(
       [self ACTION_SetAnimationState:STATE_HANG_LEFT      priority:0 duration:0.25f]
       )
    {
        [self ACTION_StopAllPartsAnimations_Clean:YES];
        [self ACTION_SetAnimationState:STATE_HANG_LEFT      priority:0 duration:0.25f];
        [self ACTION_PlayAnimation_Repeat:NO];
    }
    
}

-(void)JOE_HANGING_DOWN_2{
    
    if(
       [self ACTION_SetAnimationState:STATE_HANG_STRAIGHT      priority:0 duration:0.25f]
       )
    {
        [self ACTION_StopAllPartsAnimations_Clean:YES];
        [self ACTION_SetAnimationState:STATE_HANG_STRAIGHT      priority:0 duration:0.25f];
        [self ACTION_PlayAnimation_Repeat:NO];
    }
    
}

-(void)JOE_HANGING_DOWN{
    
     [self ACTION_StopAllPartsAnimations_Clean:YES];
    
    //if(
    //[self ACTION_SetAnimationState:STATE_IDLE_1      priority:0 duration:0.2f];
    [self ACTION_SetAnimationState:STATE_JUMP_2      priority:0 duration:0.3f];
      // )
   // {
     [self ACTION_PlayAnimation_Repeat:NO];
 //   }
    
}

-(void)JOE_JUMP_DOWN{
    
    [self ACTION_StopAllPartsAnimations_Clean:YES];
    [self ACTION_SetAnimationState:STATE_JUMP_3    priority:0 duration:0.25f];
    [self ACTION_PlayAnimation_Repeat:NO];
    
}

-(void)toothOff{
    
    [self ACTION_StopAnimationForPart:TAG_TOOTH];
    
    [PART(TAG_TOOTH) runAction:[CCMoveBy actionWithDuration:0.3 position:ccp(0, -100)]];
    
}


- (void) dealloc
{
	[super dealloc];
}

@end
