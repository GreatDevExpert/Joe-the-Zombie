//
//  MonstrBubble.m
//  Zombie Joe
//
//  Created by macbook on 2013-07-01.
//
//

#import "TigerCat.h"

// **** TAGS OF PARTS

#define TAG_HEAD            0
#define TAG_ASS             1
#define TAG_LEFT_FRONT_LEG  2
#define TAG_RIGHT_FRONT_LEG 3
#define TAG_LEFT_BACK_LEG   4
#define TAG_RIGHT_BACK_LEG  5
#define TAG_TAIL            6
#define TAG_EYES            7
#define TAG_SHADOW          8

#define STATE_CAT_DEFAULT   0
#define STATE_CAT_JUMP      1
#define STATE_CAT_SIT       2

@implementation TigerCat

// **** this method below is where to load all the contents . Like -(id)init{}

-(void)initContent{
    
    [self ACTION_EyesBlink_WithObject:[self PART:TAG_EYES] openedTime:1.5f closedTime:0.15f startRandomly:YES durationOpen:0.1f durationClose:0.1f blinkTimes:1];

    [self addTailAnimationAndSettings];
    
    // *** ACTIONS for animation
    
    [self makeDefaultRunAnimation];
    
}

-(void)killedZombieAction{
    
    [self PART:TAG_EYES].visible = NO;
    [self HeadAnimation];
    
    [self ACTION_SetAnimationState:STATE_CAT_SIT    priority:0 duration:3.f];
    [self ACTION_PlayAnimation_Repeat:YES];
    
    id delayBlock = [CCCallFuncO actionWithTarget:self selector:@selector(HasEatenEgg)];
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.f],delayBlock, nil]];
    
}

-(void)HeadAnimation{
    
    [[self PART:TAG_HEAD] prepareAnimationNamed:@"headOpen" fromSHScene:@"Level15SH"];
    [[self PART:TAG_HEAD] playAnimation];
    
}

-(void)flipShadow{
    
    int scale = PART_S(TAG_SHADOW).scaleX;
    
    if (scale == 1)
    {
           PART_S(TAG_SHADOW).scaleX = -1;
    }
    
    else    PART_S(TAG_SHADOW).scaleX = 1;
    
}

-(void)HasEatenEgg{
    
    [[self PART:TAG_HEAD] stopAnimationAndRestoreOriginalFrame:YES];

    [self PART:TAG_EYES].visible = YES;
    
    [self HeadRightLeftAnimation];
    
}

-(void)HeadRightLeftAnimation{
    
    [self ACTION_StopAnimationForPart:TAG_HEAD];
    
    id rot_right = [CCRotateTo actionWithDuration:10];
    id rot_left = [CCRotateTo actionWithDuration:-10];
    id rot_center = [CCRotateTo actionWithDuration:0];
    id seq = [CCSequence actions:rot_right,
              [CCDelayTime actionWithDuration:1.f],
              rot_center,
              [CCDelayTime actionWithDuration:1.f],
              rot_left, nil];
    [[self PART:TAG_HEAD] runAction:seq];
    
}

-(float)speedForCatWithID:(int)id_{
    

   int speed =  NodeToFallow.pathMovementSpeed;
 //   NSLog(@"speed is %i",speed);
    return speed/10;

}

-(void)makeSitAction{
    
    [self ACTION_SetAnimationState:STATE_CAT_SIT     priority:0 duration:0.2f];
    [self ACTION_SetAnimationState:STATE_CAT_SIT     priority:1 duration:0.2f];
    [self ACTION_SetAnimationState:STATE_CAT_SIT     priority:2 duration:0.2f];
    
    [self ACTION_PlayAnimation_Repeat:YES];
    
}

-(void)makeDefaultRunAnimation{
    
    float speed =  NodeToFallow.pathMovementSpeed;
    
    float a = 0.15f   * (speed/3.5f);
    float b = 0.175f  * (speed/3.5f);
    float c = 0.15f   * (speed/3.5f);

    [self ACTION_SetAnimationState:STATE_CAT_DEFAULT priority:0 duration:a];
    [self ACTION_SetAnimationState:STATE_CAT_JUMP    priority:1 duration:b];
    [self ACTION_SetAnimationState:STATE_CAT_SIT     priority:2 duration:c];
    
    [self ACTION_PlayAnimation_Repeat:YES];
    
}

-(void)addTailAnimationAndSettings{
    
    [[self PART:TAG_TAIL] prepareAnimationNamed:@"tailAnim" fromSHScene:@"Level15SH"];
    
    [[self PART:TAG_TAIL] playAnimation];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(animationOnTailHasEnded:)
                                                 name:LHAnimationHasEndedNotification
                                               object:[self PART:TAG_TAIL]];
    
}

-(void)animationOnTailHasEnded:(NSNotification*) notif{
    
    int  sx= [self getChildByTag:TAG_TAIL].scaleX ;
    
    if (sx==1)
    {
        [self getChildByTag:TAG_TAIL].scaleX = -1;
    }
    else if (sx==-1)
    {
        [self getChildByTag:TAG_TAIL].scaleX = 1;
    }
    
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
	[super dealloc];
}

@end
