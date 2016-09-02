//
//  JoeZombieRobot.m
//  Zombie Joe
//
//  Created by macbook on 2013-07-18.
//
//

#define TAG_ROBOT_TEMP  1

#import "JoeZombieController.h"
#import "JoeZombieRobot.h"
#import "cfg.h"
#import "BrainRobot.h"

@implementation JoeZombieController

-(id)initBlastOnly_Parent:(CCNode*)par_ brainsNumber:(int)bnum_{
    
    if((self = [super init]))
    {
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        
        // self.anchorPoint = ccp(0.5f,0.5f);
        self.position = ccp(-100, 1000);
        
        [LevelHelperLoader dontStretchArt];
        loader = [[LevelHelperLoader alloc]initWithContentOfFile:@"ZombieJoePartsLH"];
        [loader addSpritesToLayer:(CCLayer*)self];
        
        [self preloadKillPinkBlast:par_];
        [self addBrainsWithCount_forParent:par_ count:bnum_];
        
        [self CLEAN_UP];
        
    }
    return self;
    
}

-(void)addBrainsWithCount_forParent:(CCNode*)p_ count:(int)sum_{
    
    for (int x =  0; x < sum_; x++)
    {
        BrainRobot  *brain = [[[BrainRobot alloc]loadRobotWithLoader:loader uniqNamePrefix:@"B" fallowNode:nil]autorelease];
        [p_ addChild:brain z:1 tag:TAG_BRAIN_1+x];
        
      //  brain.position = ccp(50*x,50*x);
        
        [brain createRobotWithStatesSum:1 robotPartsSum:7 mainState:0];
        
        [brain initContent];
    }
    
}

-(id)initWitPos:(CGPoint)pos size:(CGSize)size_ sender:(CCNode*)par_ brains:(int)sum_{
    
    if((self = [super init]))
    {
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        
        // self.anchorPoint = ccp(0.5f,0.5f);
        self.position = pos;
        self.contentSize = CGSizeMake(size_.width, size_.height);
        
        [self INIT_:par_];
        
        [self addBrainsWithCount_forParent:par_ count:sum_];
        
        /* Do cleanup for Joe Robots (clean temp sprites, unload loader, etc.) */
        
        [self CLEAN_UP];
        
    }
    return self;
}

-(id)initWitPos:(CGPoint)pos size:(CGSize)size_ sender:(CCNode*)par_{
    
    if((self = [super init]))
    {
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        
        // self.anchorPoint = ccp(0.5f,0.5f);
        self.position = pos;
        self.contentSize = CGSizeMake(size_.width, size_.height);
        
        [self INIT_:par_];
        
        /* Do cleanup for Joe Robots (clean temp sprites, unload loader, etc.) */
        
        [self CLEAN_UP];
        
    }
    return self;
}

-(void)INIT_:(CCNode*)par_{
    
    /* LevelHelper settings */
    
    [[SimpleAudioEngine sharedEngine]preloadEffect:joe_s_jump];
    
    [LevelHelperLoader dontStretchArt];
    loader = [[LevelHelperLoader alloc]initWithContentOfFile:@"ZombieJoePartsLH"];
    [loader addSpritesToLayer:(CCLayer*)self];
    
    if (par_!=nil) {
        [self preloadKillPinkBlast:par_];
    }
    
    /* Robot settings for super class */
    
    robot = [[[JoeZombieRobot alloc]loadRobotWithLoader:loader uniqNamePrefix:@"Z" fallowNode:nil]autorelease];
    [self addChild:robot];
    robot.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    
    /*  Robot settings for animations states */
    
    [robot createRobotWithStatesSum:10 robotPartsSum:20 mainState:0];
    
    /* Robot initialization (induviduidual) */
    [robot initContent];
    
    
}

-(id)initWitPos:(CGPoint)pos size:(CGSize)size_{
    
    if((self = [super init]))
    {
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        
       // self.anchorPoint = ccp(0.5f,0.5f);
        self.position = pos;
        self.contentSize = CGSizeMake(size_.width, size_.height);        
        
        [self INIT_:nil];
        
        /* Do cleanup for Joe Robots (clean temp sprites, unload loader, etc.) */
        
        [self CLEAN_UP];
        
    }
    return self;
}


-(void)showKillBlastEffectInPosition:(CGPoint)pos_{
    
    blast.opacity = 255;
    blast2.opacity = 255;
    blast3.opacity = 255;
    
    blast.position = pos_;
    blast2.position = pos_;
    blast3.position = pos_;
    
    [blast runAction: [self blastEffectWithScale:1.5f duration:0.1f]];
    [blast2 runAction:[self blastEffectWithScale:2.f duration:0.15f]];
    [blast3 runAction:[self blastEffectWithScale:1.f duration:0.1f]];
    
    [AUDIO playEffect:joe_s_hitSpikes];
    
}

-(id)blastEffectWithScale:(float)scale_ duration:(float)dur_{
    
    id s_ =      [CCScaleTo actionWithDuration:dur_ scale:scale_];
    id fade_ =   [CCFadeOut actionWithDuration:0.1f];
    id rescale = [CCScaleTo actionWithDuration:0 scale:0];
    id seq =     [CCSequence actions:s_,fade_,rescale, nil];
    return seq;
    
}

-(void)preloadKillPinkBlast:(CCNode*)p_{
    
    blast = [loader createSpriteWithName:@"die_particle"
                               fromSheet:@"blastEffect"
                              fromSHFile:@"ZombieJoeParts" parent:p_];
    blast.position =ccp(-1000, 1000);
    blast.opacity = 255;
    blast.scale = 0.2f;
    
    blast2 = [loader createSpriteWithName:@"die_particle1"
                               fromSheet:@"blastEffect"
                              fromSHFile:@"ZombieJoeParts" parent:p_];
    blast2.position =ccp(-1000, 1000);
    blast2.opacity = 255;
    blast2.scale = 0.2f;
    
    blast3 = [loader createSpriteWithName:@"die_particle2"
                                fromSheet:@"blastEffect"
                               fromSHFile:@"ZombieJoeParts" parent:p_];
    blast3.position =ccp(-1000, 1000);
    blast3.opacity = 255;
    blast3.scale = 0.2f;
    
    [p_ reorderChild:blast  z:100];
    [p_ reorderChild:blast2 z:100];
    [p_ reorderChild:blast3 z:100];
    
}

-(void)JOE_flipX:(BOOL)fli_{
    
    if (fli_) {
        [robot ACTION_FlipRobot_X:YES Y:NO duration:0.f];
    }
    else if (!fli_) {
        [robot ACTION_FlipRobot_X:NO Y:NO duration:0.f];
    }
    
}

-(void)CLEAN_UP{
    
    if(loader != nil) { [loader release]; loader = nil; }
    
    for (LHSprite *s in [loader allSprites])
    {
        if (s.tag == TAG_ROBOT_TEMP)
        {
            [s removeSelf];
        }
    }
    
}

-(void)showMyBox{
    
    [cfg addTEMPBGCOLOR:self anchor:ccp(self.anchorPoint.x,self.anchorPoint.y) color:ccYELLOW];
    
}

-(void)JOE_JUMP_FORLevel:(int)level_{
    
    [AUDIO playEffect:joe_s_jump];
  //  [[SimpleAudioEngine sharedEngine]playEffect:joe_s_jump];
    
    switch (level_) {
        case 4:
            [robot JOE_JUMP_LEVEL_4];
            break;
        case 6:
            [robot JOE_JUMP_LEVEL_6];
            break;
            
        default:
            break;
    }
    
}

-(void)ACTION_SetContentSize:(CGSize)size_{
    
    
    self.contentSize = size_;
    
    for (CCNode *n in [self children]) {
        n.position= ccpAdd(n.position,ccp(self.contentSize.width/2, self.contentSize.height/2));
    }
    
}

-(JoeZombieRobot*)robot_{
    
    return robot;
    
}

-(void)JOE_HIDE:(int)x_ opacity:(float)op_{
    
    [robot makeOpacityForPart:x_ opacity:op_];

}

-(void)JOE_HANGING_RIGHT{
    
    [robot JOE_HANGING_RIGHT];
    
}

-(void)JOE_HANGING_LEFT{
    
    [robot JOE_HANGING_LEFT];
    
}

-(void)JOE_HANGING_DOWN{
    
    [robot JOE_HANGING_DOWN];
    
}

-(void)JOE_WALK{
    
    [robot JOE_WALK];
    
}

-(void)JOE_JUMP_UP{
    
    [robot JOE_JUMP_UP];
    
}
-(void)JOE_JUMP_DOWN{
    
    [robot JOE_JUMP_DOWN];
    
}

-(void)JOE_IDLE{
    
    [robot JOE_IDLE];
}

-(void) dealloc
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	//[robot release];
  //  robot = nil;
    
    if(loader != nil) {
        [loader release];
         loader = nil;
    }

	// in case you have something to dealloc, do it in this method

    
	[super dealloc];
}

@end
