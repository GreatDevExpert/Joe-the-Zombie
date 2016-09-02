//
//  BrainsBonus.m
//  Zombie Joe
//
//  Created by macbook on 2013-05-06.
//
//

#import "BrainsBonus.h"
#import "cocos2d.h"
#import "cfg.h"
#import "Constants.h"

@implementation BrainsBonus
@synthesize brain;

-(id)initWithRect:(CGRect)rect{
    
    if((self = [super init]))
    {
        //self.tag = BRAIN_BONUS_TAG;
        
        self.anchorPoint = ccp(0.5f,0.5f);
        self.contentSize = CGSizeMake(rect.size.width,
                                      rect.size.height);
        
        self.position = ccp(rect.origin.x, rect.origin.y);
        
        [self addBrainBatchNodeWithSprite];
        
       // [cfg addTEMPBGCOLOR:self anchor:ccp(0.5f, 0.5f) color:ccRED];
        
    }
    return self;
}

-(void)moveUpDown_particles:(BOOL)yes_{
    
    float moveDist = self.contentSize.height*0.05f;
    
    id moveUp = [CCMoveTo actionWithDuration:0.5f position:ccpAdd(self.position, ccp(0,moveDist))];
    id move_ease = [CCEaseSineInOut actionWithAction:[[moveUp copy] autorelease]];
    id rev =    [CCMoveTo actionWithDuration:0.5f position:ccpAdd(self.position, ccp(0,-moveDist))];
    id move_ease_rev = [CCEaseSineInOut actionWithAction:[[rev copy] autorelease]];
    id seq = [CCSequence actions:move_ease,move_ease_rev, nil];
    [self runAction:[CCRepeatForever actionWithAction:seq]];
    
    if (yes_) {
           [self upDownParticles];
    }

    
}



-(void)upDownParticles{
    
    CCParticleSystemQuad *effect = [CCParticleSystemQuad particleWithFile:[NSString stringWithFormat: @"brain_bonus_1.plist"/*,kDevice*/]];
    effect.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    if (IS_IPHONE || IS_IPHONE_5) {effect.scale = 0.4f;}
    else{
        effect.scale = 0.7f;}
    [self addChild:effect z:-5];
    effect.autoRemoveOnFinish = YES;
    
}

-(void)addBrainBatchNodeWithSprite{
    
    
    NSString *spritesStr =      [NSString stringWithFormat:@"Brains_iPhone"];
    if (IS_IPAD) spritesStr =   [NSString stringWithFormat:@"Brains"];
    
   CCSpriteBatchNode* spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz",spritesStr]];
    [self addChild:spritesBgNode];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache]
     addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist",spritesStr]];
    
    
    
    NSString *imgName = (IS_IPAD) ? @"brains.png" : @"brains.png";
    
    brain = [CCSprite spriteWithSpriteFrameName:imgName];
    self.contentSize = CGSizeMake(brain.boundingBox.size.width, brain.boundingBox.size.height);
    brain.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    //sprite.opacity = 100;
    [spritesBgNode addChild:brain];
    
}

@end
