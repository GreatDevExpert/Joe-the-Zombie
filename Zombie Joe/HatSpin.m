//
//  HatSpin.m
//  Zombie Joe
//
//  Created by Mac4user on 6/5/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "HatSpin.h"
#import "cfg.h"

@implementation HatSpin

-(id)initWithRect:(CGRect)rect{
    
    if((self = [super init]))
    {
        
        self.anchorPoint = ccp(0.5f,0.5f);
        
        self.contentSize = CGSizeMake(rect.size.width,
                                      rect.size.height);
        
        self.position = ccp(rect.origin.x, rect.origin.y);
        
     //   [cfg addTEMPBGCOLOR:self anchor:ccp(0.5f, 0.5f) color:ccBLUE];
        
        [self hatBatchNode];
        [self addHat];
        [self propeller];
        
    }
    return self;
}

-(void)propeller{
    float xfix = (IS_IPAD) ? 5 : 3;
    prop = [CCSprite spriteWithSpriteFrameName:@"hat1.png"];
    prop.position = ccp(hat_.position.x+xfix,hat_.position.y+hat_.boundingBox.size.height/2);
    [zombieFlyBatch addChild:prop];
    
}

-(void)spinHat:(float)delay_ loop:(BOOL)yes_{
    
    NSMutableArray *animFrames = [NSMutableArray array];
    
    
    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hat2.png"]];
    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hat3.png"]];
    //    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"top_idle.png"]];
    //    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"top_2.png"]];
    
    
    
    CCAnimation *animation = [CCAnimation animationWithFrames:animFrames delay:delay_];
    if (yes_) {
        [prop runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation restoreOriginalFrame:YES]]];
    }
    else if (!yes_){
        [prop runAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:YES]];
    }
    
    
}

-(void)addHat{
    
    hat_ = [CCSprite spriteWithSpriteFrameName:@"hat0.png"];
    hat_.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    [zombieFlyBatch addChild:hat_];
    
}

-(void)hatBatchNode{
    
    //Level9_zombie
    NSString *spritesStr =      [NSString stringWithFormat:@"Level9_zombie_iPhone"];
    if (IS_IPAD) spritesStr =   [NSString stringWithFormat:@"Level9_zombie"];
    
    zombieFlyBatch =
    [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz",spritesStr]];
    [self addChild:zombieFlyBatch z:10];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache]
     addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist",spritesStr]];
    
}


@end
