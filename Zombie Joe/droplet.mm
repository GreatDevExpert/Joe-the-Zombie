//  Created by Eimio on 4/23/13.

#import "droplet.h"
#import "level2.h"
#import "SimpleAudioEngine.h"
#import "cfg.h"
#import "Combinations.h"
#import "Constants.h"

@implementation droplet

@synthesize killed;

-(NSString*)prefix
{
    if (IS_IPAD)return @"";return @"_iPhone";
}

-(id)initWithPosition:(CGPoint)pos withTyp:(int)type_{
    
    if((self = [super init]))
    {
        
        killed = NO;
        //[[SimpleAudioEngine sharedEngine] preloadEffect:@"dropletEndSound.mp3"];
        
        self.position = ccp(pos.x,pos.y);

     //   [self scheduleUpdate];
        [self schedule:@selector(update:) interval:0.5f];
        
        //NSLog(@"TYPE :%i",type_);
        
        dropletsItem = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"Level2%@.pvr.ccz", [self prefix]]];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"Level2%@.plist", [self prefix]]];
        [self addChild:dropletsItem z:41];

        // This is random times for droplets.
        fallingTime  = (float)[cfg MyRandomIntegerBetween:4 :8];
        fallingTime2 = (float)[cfg MyRandomIntegerBetween:3 :7];
        
        if (type_ == 1) { [self goodDroplets];  id fall = [CCMoveTo actionWithDuration:fallingTime position:ccp(self.position.x, -dropletSp.boundingBox.size.height*0.5f)];   [self runAction:fall]; }
        if (type_ == 2) { [self badDroplets];   id fall = [CCMoveTo actionWithDuration:fallingTime2 position:ccp(self.position.x, -dropletSp.boundingBox.size.height*0.5f)];  [self runAction:fall]; }
        

        id scaleNorm    = [CCScaleTo actionWithDuration:0.5f scaleX:1.f scaleY:1.f];
        id scaleDown2   = [CCScaleTo actionWithDuration:0.5f scaleX:0.9f scaleY:1.2f];
        id scaleDown2_  = [CCEaseElasticInOut actionWithAction:scaleDown2 period:1.f];
        
        id seq = [CCSequence actions:scaleDown2_,scaleNorm, nil];
        id repeatForev  = [CCRepeatForever actionWithAction:seq];
        [self runAction:repeatForev];
        
      //  [self dropFadeOut];
        
    }
    return self;
}


-(void)dropFadeOut{
    
    [self unscheduleAllSelectors];
    [dropletSp runAction:[CCFadeTo actionWithDuration:0.5f opacity:0]];
}

-(void)update:(ccTime)dt
{
    
    if (self.position.y <= kHeightScreen * 0.05f)
    {
   //     if ([dropletSp getActionByTag:1001]) return;
        
       // [self unscheduleAllSelectors];
        
        
        [self unschedule:@selector(update:)];
         [self unscheduleAllSelectors];
        
        NSMutableArray *animFrames = [NSMutableArray array];
        
        [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"splash0.png"]]];
        [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"splash1.png"]]];
        [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"splash2.png"]]];
        [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"splash3.png"]]];
        [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"splash4.png"]]];
        [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"splash5.png"]]];
        [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"splash6.png"]]];
        [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"splash7.png"]]];
        [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"splash8.png"]]];
        
        [AUDIO playEffect:l2_dropletwater];
        
        CCAnimation *animation = [CCAnimation animationWithFrames:animFrames delay:0.03f];
        
        id animat = [CCAnimate actionWithAnimation:animation
                              restoreOriginalFrame:NO];
        
    
        id rem = [CCCallBlock actionWithBlock:^(void)
                  {
                      [dropletSp removeFromParentAndCleanup:YES];
                      [self stopAllActions];
                      [self removeAllChildrenWithCleanup:YES];
                      [self removeFromParentAndCleanup:YES];
//                      
//                     

                  }];
        
        [dropletSp runAction:[CCSequence actions:animat,rem, nil]].tag = 1001;

//        
//        [dropletSp runAction:[CCRepeatForever actionWithAction:
//                             [CCAnimate actionWithAnimation:animation
//                                       restoreOriginalFrame:NO]]].tag = 1001;
        
        
        dropletSp.position = ccp(dropletSp.position.x, kHeightScreen*0.05f);
        
         
        
      //  [self schedule:@selector(removeDroplets) interval:1.f];
    }
}

-(void) removeDroplets
{
    [self removeFromParentAndCleanup:YES];
}

-(void) goodDroplets
{
    dropletSp = [CCSprite spriteWithSpriteFrameName:@"dropgood.png"];
    dropletSp.position = ccp(0, 0);
    [dropletsItem addChild:dropletSp];
}

-(void) badDroplets
{
    dropletSp = [CCSprite spriteWithSpriteFrameName:@"dropbad.png"];
    dropletSp.position = ccp(0, 0);
    [dropletsItem addChild:dropletSp];
}

-(void)dealloc{
    
   // killed = nil;
    
    [super dealloc];
}

@end
