//
//  JoeZombieController.m
//  Zombie Joe
//
//  Created by macbook on 2013-07-18.
//
//

#define TAG_BRAIN_MEET            0
#define TAG_BRAIN_STROKE          1
#define TAG_BRAIN_BLUR            2
#define TAG_STAR                  3

#define TAG_BLINK_POS_1           4
#define TAG_BLINK_POS_2           5
#define TAG_BLINK_POS_3           6

#define STATE_IDLE_1              0

#define TAG_ACTION_BLINK          1

#import "BrainRobot.h"
#import "cfg.h"


@implementation BrainRobot

-(void)initContent{
    
    [self ACTION_SetContentSize:CGSizeMake(PART_S(TAG_BRAIN_BLUR).boundingBox.size.width,
                                           PART_S(TAG_BRAIN_BLUR).boundingBox.size.height)];
    
  //  [self ACTION_ShowContentSize];
    
    [self strokeScale];
    [self meatScale];
    [self blurEffect];

    [self makeOpacityForPart:TAG_STAR        opacity:0];
    [self makeOpacityForPart:TAG_BLINK_POS_1 opacity:0];
    [self makeOpacityForPart:TAG_BLINK_POS_2 opacity:0];
    [self makeOpacityForPart:TAG_BLINK_POS_3 opacity:0];

    [self schedule:@selector(blinkStar:) interval:5];
    
   // [self ACTION_SetContentSize:CGSizeMake(self.contentSize.width*2, self.contentSize.height*2)];

}

-(NSInteger)MyRandomIntegerBetween:(int)min :(int)max {
    return ( (arc4random() % (max-min+1)) + min );
}

-(CGPoint)getRandomBlinkPos{
    
    int pos = [self MyRandomIntegerBetween:1 :3];
    
    return [self getChildByTag:3+pos].position;
    
}

-(void)blinkStar:(ccTime)dt{
    
    PART_S(TAG_STAR).position = [self getRandomBlinkPos];
    
    if (![PART(TAG_STAR) getActionByTag:TAG_ACTION_BLINK]) {
        
        [PART(TAG_STAR) runAction:[CCSpawn actions:[CCSequence actions:[CCFadeTo actionWithDuration:0.3 opacity:255],[CCDelayTime actionWithDuration:0.05f],[CCFadeTo actionWithDuration:0.3f opacity:0], nil],[CCRotateTo actionWithDuration:3.f angle:6000],[CCSequence actions:[CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:0.3f scale:1.4f] rate:2],[CCScaleTo actionWithDuration:0.3f scale:0.9f], nil], nil]].tag = TAG_ACTION_BLINK;
    }
    
}

-(void)blurEffect{

    CCSprite* s = PART(TAG_BRAIN_BLUR);
    
    s.scale = 0.75f;
    s.opacity = 255;
    
    id scaleTo =  [CCScaleTo actionWithDuration:0.75f scale:1.2f];
    id scaleOut = [CCScaleTo actionWithDuration:0.25f scale:0.75f];
    id fadein =   [CCFadeTo actionWithDuration:0.75f opacity:0];
    id fadeOut =  [CCFadeTo actionWithDuration:0.25f opacity:255];
    id fadeseq =  [CCSequence actions:fadein,fadeOut,nil];
    id sp =       [CCSpawn actions:[CCSequence actions:scaleTo,scaleOut,nil],fadeseq, nil];
    id seq =      [CCRepeatForever actionWithAction:sp];
    [PART(TAG_BRAIN_BLUR) runAction:seq];
    
}

-(void)strokeScale{

    CCSprite* s = PART(TAG_BRAIN_STROKE);
    
    s.scale = 0.75f;
    s.opacity = 0;
    
    id scaleTo =  [CCScaleTo actionWithDuration:1.f scale:1.25f];
    id scaleOut = [CCScaleTo actionWithDuration:0 scale:0.75f];
    id fadein =   [CCFadeTo actionWithDuration:0.75f opacity:150];
    id fadeOut =  [CCFadeTo actionWithDuration:0.25f opacity:0];
    id fadeseq =  [CCSequence actions:fadein,fadeOut,nil];
    id sp =       [CCSpawn actions:[CCSequence actions:scaleTo,scaleOut,nil],fadeseq, nil];
    id seq =      [CCRepeatForever actionWithAction:sp];
    [PART(TAG_BRAIN_STROKE) runAction:seq];
    
}

-(void)meatScale{
    
   // PART(TAG_BRAIN_MEET).visible = NO;
    
    id scaleTo = [CCScaleTo actionWithDuration:0.5f scale:0.8f];
    id scaleBack = [CCScaleTo actionWithDuration:0.5f scale:1.f];
    
    id seq = [CCSequence actions:scaleTo,scaleBack, nil];
    [PART(TAG_BRAIN_MEET) runAction:[CCRepeatForever actionWithAction:seq]];
    
}

- (void) dealloc
{
	[super dealloc];
}

@end
