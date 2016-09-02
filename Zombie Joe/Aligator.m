//
//  Aligator.m
//  Zombie Joe
//
//  Created by macbook on 2013-05-07.
//
//

#import "Aligator.h"
#import "cocos2d.h"
#import "constants_l7.h"
#import "cfg.h"

#define ACTION_IDLE 1
#define ACTION_OPEN_MOUTH  2
#define Z_MONSTER 5
#define Z_WAVE    4

@implementation Aligator

-(id)initWithRect:(CGRect)rect{
    
    if((self = [super init]))
    {
    //    self.tag = kAligator;
        
        self.anchorPoint = ccp(0.5f,0.5f);
        
        self.contentSize = CGSizeMake(rect.size.width,
                                      rect.size.height);
        
        self.position = ccp(rect.origin.x, rect.origin.y);
        
        [self addBrainBatchNodeWithSprite];
        
        [self addMonsterSprite];
        

        
        self.contentSize = CGSizeMake(monster.boundingBox.size.width/2, monster.boundingBox.size.height/2); //monster box /2 to detect collisions
        
        monster.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
        

        [self swimIdleAcTion];
        
        [self addWaveEffect];

      //  [cfg addTEMPBGCOLOR:self anchor:ccp(0.5f, 0.5f) color:ccBLUE];
        
    }
    return self;
}

-(void)swimIdleAcTion{
    
    CGPoint p = self.position;
    
    int pos =[cfg MyRandomIntegerBetween:3 :5];
    int h = [cfg MyRandomIntegerBetween:3 :5];
    
    id jump1 =[CCJumpBy actionWithDuration:3.f position:ccp(pos, 0) height:h jumps:1];
    
    id jump2 =[CCJumpBy actionWithDuration:3.f position:ccp(-pos, 0) height:h jumps:1];
    
    id ease1 = [CCEaseIn actionWithAction:jump1 rate:3];
    
    id ease2 = [CCEaseIn actionWithAction:jump2 rate:3];
    
    
    id seq = [CCSequence actions:ease1,ease2,nil];
    
    [self runAction:[CCRepeatForever actionWithAction:seq]];
    
}

-(void)addWaveEffect{
    
    for (int x = 0; x < 3; x++)
    {
        CCSprite *wave = [CCSprite spriteWithSpriteFrameName:@"wave.png"];
        [spritesBgNode addChild:wave z:Z_WAVE];
        wave.position = ccp(self.contentSize.width/2-10,self.contentSize.height/2-10);
        wave.scale = 0;
        
        int f = [cfg MyRandomIntegerBetween:1 :3];
        
        id scaleUP =[CCScaleTo actionWithDuration:f scale:1.5f];
        
        id fadeOut =[CCFadeTo actionWithDuration:f opacity:0];
        
        id scaleDOWN=[CCScaleTo actionWithDuration:0.f scale:0];
        id fadeIn =[CCFadeTo actionWithDuration:0.f opacity:255];
        
        id sp1 = [CCSpawn actions:scaleUP,fadeOut, nil];
        id sp2 = [CCSpawn actions:scaleDOWN,fadeIn, nil];
        
        id seq = [CCSequence actions:sp1,sp2, nil];
        id fr = [CCRepeatForever actionWithAction:seq];
        
        [wave runAction:fr];
    }
        
}

-(void)swallowedZombie{

         
         CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"idle_3.png"]];
                                 
         [monster setDisplayFrame:frame];
         
    [[monster getActionByTag:ACTION_OPEN_MOUTH]stop];
    swallowZombie = YES;
    [self chillAction];;
    
    
}

-(void)closeMoutH{
    
//    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"idle_0.png"];
//    [monster setDisplayFrame:frame];
//
  //  NSLog(@"close mouth");
 //   [monster stopAllActions];
    
    aligatorSound = NO;
    
    [self chillAction];
    
   // [self performSelector:@selector(chillAction) withObject:nil afterDelay:(float)((self.tag)/10)];
    
}

-(void)openMouth{
    
    if (swallowZombie) {
        return;
    }
    
    if (!aligatorSound) {
        [AUDIO playEffect:l9_monster];
        aligatorSound = YES;
    }

    if ([monster getActionByTag:ACTION_OPEN_MOUTH])
    {
        return;
    }
    
     [[monster getActionByTag:ACTION_IDLE]stop];
    
    [monster stopAllActions];
    
    monster.scale = 1;
    
    monster.scaleY = 1.15f;
    
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"action_1.png"];
    [monster setDisplayFrame:frame];
    
}

-(void)chillAction{
    
    monster.scaleY = 1.f;
    
    if ([monster getActionByTag:ACTION_IDLE])
    {
        return;
    }

    [monster stopAllActions];
    
    float scaleTo = (float)[cfg MyRandomIntegerBetween:1 :2]/100;
    
    id scaleDown =      [CCScaleTo actionWithDuration:0.5f scale:1      +scaleTo];
    id scaleUp =        [CCScaleTo actionWithDuration:0.5f scale:1     - scaleTo];
    id move_ease =      [CCEaseSineIn actionWithAction:[[scaleDown copy] autorelease]];
    id move_ease_rev =  [CCEaseSineInOut actionWithAction:[[scaleUp copy] autorelease]];
    
    id seq = [CCSequence actions:move_ease,move_ease_rev,[CCDelayTime actionWithDuration:0.2f], nil];

    [monster runAction:[CCRepeatForever actionWithAction:seq]];
    
    //idle_0 1 2 3 2 1

    
    NSMutableArray *animFrames = [NSMutableArray array];
    
    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"idle_3.png"]]];
    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"idle_2.png"]]];
    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"idle_1.png"]]];
    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"idle_0.png"]]];
    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"idle_1.png"]]];
    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"idle_2.png"]]];
    
    
    CCAnimation *animation = [CCAnimation animationWithFrames:animFrames delay:0.2f];
    id ani = [CCAnimate actionWithAnimation:animation
                       restoreOriginalFrame:NO];
    
    id del_ = [CCDelayTime actionWithDuration:(float)([cfg MyRandomIntegerBetween:5 :10]/10)];
    
    id s_ =[CCSequence actions:del_,ani,nil];
    
    id anim = [CCRepeatForever actionWithAction:s_];
    
    [monster runAction:anim].tag = ACTION_IDLE;

  
}

-(void)caughtZombieAction:(CCNode*)deadBody{
    //NSLog(@"shake zombie");
    id rotate = [CCRotateBy actionWithDuration:0.1f angle:33];
    id rot_rev = [CCRotateBy actionWithDuration:0.1f angle:-33];
    id scale_down = [CCScaleTo actionWithDuration:0.5f scale:0];
    
    id seqRot =[CCSequence actions:rotate,rot_rev,rotate,rot_rev,rotate,rot_rev, nil];
    id spawn = [CCSpawn actions:scale_down,seqRot,[CCFadeOut actionWithDuration:0.5f], nil];
    
    //id forev_rot = [CCRepeatForever actionWithAction:seqRot];
    
    [self runAction:spawn];
    
    //  [deadBody runAction:spawn];
}

-(void)addMonsterSprite{
    
    monster = [CCSprite spriteWithSpriteFrameName:@"idle_0.png"];
    monster.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    [spritesBgNode addChild:monster z:Z_MONSTER];
    
}

-(void)addBrainBatchNodeWithSprite{
    
    NSString *spritesStr =      [NSString stringWithFormat:@"sprites_level7_iPhone"];
    if (IS_IPAD) spritesStr =   [NSString stringWithFormat:@"sprites_level7"];
    
    spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz",spritesStr]];
    [self addChild:spritesBgNode];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache]
     addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist",spritesStr]];
    
}

@end
