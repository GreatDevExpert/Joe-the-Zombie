//
//  FillCharacter.m
//  Zombie Joe
//
//  Created by macbook on 2013-04-28.
//
//


#import "FillCharacter.h"
#import "cfg.h"
#import "constants_l1.h"
#import "JOE_C.h"
#import "Level1.h"


@implementation FillCharacter
//@synthesize spritesBgNode;
@synthesize collected;
//@synthesize admin;

-(id)initWithRect:(CGRect)rect{
    
    if((self = [super init]))
    {

        self.anchorPoint = ccp(0.5f,0.5f);
        self.contentSize = CGSizeMake(rect.size.width,
                                      rect.size.height);
        
        self.position = ccp(rect.origin.x, rect.origin.y);
        [self addFillBatchNode];
        [self createJoe];
        
    }
    return self;
}

-(void)createJoe{
    
    playerImage = [[[JoeZombieController alloc]initWitPos:ccp(0, 0)
                                                     size:CGSizeMake(100,100)]autorelease];
    [self addChild:playerImage z:2 tag:9292];
    
    //   [playerImage showMyBox];
    
    playerImage.scale = 0.6f;
    if (IS_IPHONE) {
        playerImage.scale = 0.6f;
    }
    playerImage.position =[spritesBgNode getChildByTag:kEmptyBody].position;
    
    playerImage.anchorPoint = ccp(0.5f, 0.725f);
    if (IS_IPHONE) {
         playerImage.anchorPoint = ccp(0.5f, 0.575f);
    }
    [playerImage JOE_IDLE];
    
    playerImage.visible = NO;
    
}

-(BOOL)checkIfAllBodyPartsCollected{
    
    if (collected>=7) {
    //    NSLog(@"all body parts collected");
        //[spritesBgNode removeChildByTag:kEmptyBody cleanup:YES];
        
        [self.parent performSelector:@selector(_hudLevelPassed)];
        
        
        id fadeOut = [CCFadeOut actionWithDuration:0.1f];
        
        [[spritesBgNode getChildByTag:fill_eysclosed] runAction:[CCFadeOut actionWithDuration:0.1f]];
        
        [[spritesBgNode getChildByTag:kEmptyBody]runAction:fadeOut];
        
        for (CCNode *children in [spritesBgNode children])
        {
       //     [children runAction:[CCFadeOut actionWithDuration:0.5f]];
         //   [children runAction:[CCScaleTo actionWithDuration:0.3f]];
            children.visible = NO;
        }
        
        /*
        JOE_C *playerImage = [[[JOE_C alloc]initWithRect:CGRectMake(0, 0, 100, 100) tag:9292]autorelease];
        [self addChild:playerImage z:10];
        playerImage.scale = 1.2f;
        playerImage.position = [spritesBgNode getChildByTag:kEmptyBody].position;
        playerImage.tag = 9292;
        playerImage.anchorPoint = ccp(0.5f, 0.5f);
        [playerImage Action_IDLE_Setdelay:0.2f funForever:YES];
         */
        
        playerImage.visible = YES;
        
//        playerImage = [[[JoeZombieController alloc]initWitPos:ccp(0, 0)
//                                                         size:CGSizeMake(100,100)]autorelease];
//        [self addChild:playerImage z:2 tag:9292];
//        
//        //   [playerImage showMyBox];
//        
//        playerImage.scale = 1.f;
//        playerImage.position =[spritesBgNode getChildByTag:kEmptyBody].position;
//        
//        playerImage.anchorPoint = ccp(0.5f, 0.5f);
//        [playerImage JOE_IDLE];
        
     //   [AUDIO playEffect:fx_winmusic];
        
        [self.parent performSelector:@selector(stopTimer) withObject:nil];
        
        id seq = [CCSequence actions:[CCDelayTime actionWithDuration:1],
                  [CCCallBlock actionWithBlock:^(void){
            [self.parent missionCompleted];
            [self jumpJoe];
        }], nil];
        
        [self runAction:seq];
        
        return YES;
        
    }
    return NO;
}

-(void)jumpJoe{
    
  //  [self unschedule:@selector(jumpJoe)];
    
//    JOE_C *joe = (JOE_C*)[self getChildByTag:9292];
//    [joe Action_JUMP_Setdelay:0.1f funForever:NO];
  //  [playerImage runAction:[CCScaleTo actionWithDuration:0.9f scale:0.7f]];
    [playerImage JOE_JUMP_FORLevel:6];
    
}

-(void)addFillBatchNode{
    
    NSString *spritesStr =      [NSString stringWithFormat:@"sprites_level1_iPhone"];
    if (IS_IPAD) spritesStr =   [NSString stringWithFormat:@"sprites_level1"];
    
    spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz",spritesStr]];
    [self addChild:spritesBgNode];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache]
     addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist",spritesStr]];
    
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"zombieEmpty.png"];
    sprite.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
    sprite.tag = kEmptyBody;
    [spritesBgNode addChild:sprite];
    
    sprite.scale = kSCALE_FACTOR_FIX;
    
    NSArray *positionsArray = [NSArray arrayWithArray:[self getDelautPositionsInteractiveItems]];
    
    NSArray *items = [NSArray arrayWithObjects:         
                      @"brains_fill.png",                               //0
                      @"hands_fill.png",                                //1
                      @"hat_fill.png",                                  //2
                      @"head_fill.png",                                 //3
                      @"legs_fill.png",                                 //4
                      @"tshirt_fill.png",                               //5
                      @"eyes_closed.png",                               //6
                      nil]; 
    
    for (int x  = 0; x < 7; x++)
    {
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:[items objectAtIndex:x]];
        sprite.tag = x;
        sprite.position = [[positionsArray objectAtIndex:x]CGPointValue];
        [spritesBgNode addChild:sprite];
        sprite.opacity = 0;
        sprite.scale = kSCALE_FACTOR_FIX;
    }
    
  //  [spritesBgNode removeChildByTag:3 cleanup:YES];
    
}

-(void)enableBodyPartByTag:(int)tag__{
    
  // ((CCSprite *)[spritesBgNode getChildByTag:tag__]).opacity = 255.f;
    
    id fadeIn = [CCFadeIn actionWithDuration:0.1f];
    
    if (tag__==fill_head) {
        ((CCSprite *)[spritesBgNode getChildByTag:fill_eysclosed]).opacity = 255.f;
        //[[spritesBgNode getChildByTag:6] runAction:fadeIn];
    }
    
    [[spritesBgNode getChildByTag:tag__] runAction:fadeIn];
    
    
}

-(NSArray*)getDelautPositionsInteractiveItems{
    
    
    if (IS_IPHONE_5) {
        NSArray *points =   [NSArray arrayWithObjects:
                            [NSValue valueWithCGPoint:CGPointMake(-36*(kSCALEVALX),          21*(kSCALEVALY))],          //brain
                            [NSValue valueWithCGPoint:CGPointMake(-9*(kSCALEVALX),         -61*(kSCALEVALY))],          //hands
                            [NSValue valueWithCGPoint:CGPointMake(13*(kSCALEVALX),           60*(kSCALEVALY))],          //hat
                            [NSValue valueWithCGPoint:CGPointMake(0*(kSCALEVALX),             0*(kSCALEVALY))],          //head
                            [NSValue valueWithCGPoint:CGPointMake(-8.5f*(kSCALEVALX),      -80*(kSCALEVALY))],          //legs
                            [NSValue valueWithCGPoint:CGPointMake(-6*(kSCALEVALX),         -57*(kSCALEVALY))],          //tshirt
                            [NSValue valueWithCGPoint:CGPointMake(13*(kSCALEVALX),             0*(kSCALEVALY))],          //eyes closed
                            
                            nil];
        return points;
    }
    
    
    NSArray *points =  [NSArray arrayWithObjects:
                       [NSValue valueWithCGPoint:CGPointMake(-48*(kSCALEVALX),          21*(kSCALEVALY))],          //brain
                       [NSValue valueWithCGPoint:CGPointMake(-12*(kSCALEVALX),         -61*(kSCALEVALY))],          //hands
                       [NSValue valueWithCGPoint:CGPointMake(18*(kSCALEVALX),           60*(kSCALEVALY))],          //hat
                       [NSValue valueWithCGPoint:CGPointMake(0*(kSCALEVALX),             0*(kSCALEVALY))],          //head
                       [NSValue valueWithCGPoint:CGPointMake(-11.5f*(kSCALEVALX),      -80*(kSCALEVALY))],          //legs
                       [NSValue valueWithCGPoint:CGPointMake(-9*(kSCALEVALX),         -57*(kSCALEVALY))],          //tshirt
                       [NSValue valueWithCGPoint:CGPointMake(17*(kSCALEVALX),             0*(kSCALEVALY))],          //eyes closed

                       nil];
    
    // CGPoint pos = [[points objectAtIndex:id_]CGPointValue];
    return points;
}

-(void)onEnter{
    
    [super onEnter];
    
}

-(CCSpriteBatchNode*)spriteBatch{
    
    return spritesBgNode;
    
}

-(void)onExit{
    
    [self removeAllChildrenWithCleanup:YES];
    [super onExit];
    
}

- (void) dealloc
{
    
//    if (spritesBgNode!=nil) {
//        [spritesBgNode release];
//        spritesBgNode = nil;
//    }
//    if (admin!=nil) {
//        [admin release];
//        admin = nil;
//    }

    
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
