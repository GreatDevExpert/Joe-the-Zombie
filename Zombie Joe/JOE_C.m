//
//  JOE_C.m
//  Zombie Joe
//
//  Created by macbook on 2013-05-16.
//
//

#import "JOE_C.h"
#import "Combinations.h"
#import "cfg.h"
#import "Constants.h"

@implementation JOE_C
@synthesize body;

-(id)initWithRect:(CGRect)rect tag:(int)_tag{
    
    if((self = [super init]))
    {
        
        self.anchorPoint = ccp(0.5f,0.5f);
        self.contentSize = CGSizeMake(rect.size.width,
                                      rect.size.height);
        
        self.position = ccp(rect.origin.x, rect.origin.y);
        
        [self createBatchNodes];
        
     //     [cfg addTEMPBGCOLOR:self anchor:ccp(0.5f, 0.5f) color:ccBLUE];
        
      //  [self schedule:@selector(update:)];
        
        //by default run action for idle
        [self Action_IDLE_Setdelay:0.1f funForever:YES];

        
    }
    return self;
}

-(void)createBatchNodes{
    //JoeCharacter_iPhone-hd
    NSString *spritesStr =      [NSString stringWithFormat:@"JoeCharacter_iPhone"];
    if (IS_IPAD) spritesStr =   [NSString stringWithFormat:@"JoeCharacter"];
    
    spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz",spritesStr]];
    [self addChild:spritesBgNode];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache]
     addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist",spritesStr]];
    
    NSString *spriteName = @"zombie.png";
    if (IS_IPHONE) {
        spriteName = @"zombie_iPhone.png";
    }
    body = [CCSprite spriteWithFile:spriteName];
    
    self.contentSize = CGSizeMake(body.boundingBox.size.width,
                                  body.boundingBox.size.height);
    
    //[cfg addTEMPBGCOLOR:self anchor:ccp(0.5f, 0.5f) color:ccRED];
    body.anchorPoint = ccp(0.5f,0.f);
    body.scale = kSCALE_FACTOR_FIX;
    body.position = ccp(self.contentSize.width/2, self.contentSize.height/2-(body.boundingBox.size.height/2));
    
    if (![Combinations isRetina]) {
        body.position = ccp(self.contentSize.width/2, self.contentSize.height/2-(body.boundingBox.size.height));
    }
    
    //sprite.opacity = 100;
    [self addChild:body];
    
//
}

-(void)reset{
    
        [body stopAllActions];
    
    
}

-(void)Action_WALK_SetDelay:(float)delay_ funForever:(BOOL)forever_{
    
    if (delay_==-1) {
        delay_ = 0.2f;
    }
    
    [self reset];
    
    NSMutableArray *animFrames = [NSMutableArray array];
    for(int i = 1; i < 3; i++)
    {
        CCSpriteFrame *frame =
        [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"walk%d.png",i]];
        [animFrames addObject:frame];
    }
    
    
    CCAnimation *animation = [CCAnimation animationWithFrames:animFrames delay:delay_];
    if (forever_) {
        [body runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation restoreOriginalFrame:YES]]];
    }
    else if (!forever_){
        [body runAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:YES]];
    }
    
    
}

-(void)Action_DEAD_Setdelay:(float)delay_ funForever:(BOOL)forever_{
    
    if (delay_==-1) {
        delay_ = 0.2f;
    }
    
    [self reset];
    
    NSMutableArray *animFrames = [NSMutableArray array];
 
        CCSpriteFrame *frame =
        [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"death.png"]];
        [animFrames addObject:frame];
    
    
    
    CCAnimation *animation = [CCAnimation animationWithFrames:animFrames delay:delay_];
    if (forever_) {
        [body runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation restoreOriginalFrame:YES]]];
    }
    else if (!forever_){
        [body runAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:YES]];
    }
    
}

-(void)Action_JUMP_Setdelay:(float)delay_ funForever:(BOOL)forever_{
    
    if (delay_==-1) {
        delay_ = 0.2f;
    }
    
    [self reset];
    
    NSMutableArray *animFrames = [NSMutableArray array];
    for(int i = 1; i < 4; i++) {
        CCSpriteFrame *frame =
        [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"jump%d.png",i]];
        [animFrames addObject:frame];
    }
    
    
    CCAnimation *animation = [CCAnimation animationWithFrames:animFrames delay:delay_];
    id animationJump = [CCAnimate actionWithAnimation:animation restoreOriginalFrame:YES];
  
    if (forever_) {
        [body runAction:[CCRepeatForever actionWithAction:animationJump ]];
    }
    else if (!forever_){
        
        id deff =  [CCCallBlock actionWithBlock:^(void)
                    {
                        [self Action_IDLE_Setdelay:0.2f funForever:YES];
                        
                    }];
        id seq = [CCSequence actions:animationJump,deff, nil];

        
        [body runAction:seq];
    }

    
}

-(void)Action_IDLE_Setdelay:(float)delay_ funForever:(BOOL)forever_{
    
    if (delay_==-1) {
        delay_ = 0.2f;
    }
    
    [self reset];
    
    NSMutableArray *animFrames = [NSMutableArray array];
    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"idle1.png"]]];
       [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"default.png"]]];
       [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"idle2.png"]]];
       [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"default.png"]]];
    
    
    CCAnimation *animation = [CCAnimation animationWithFrames:animFrames delay:delay_];
    if (forever_) {
            [body runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO]]];
    }
    else if (!forever_){
            [body runAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO]];
    }
    
}

@end
