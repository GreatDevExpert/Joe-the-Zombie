//  Created by Eimio on 4/23/13.

#import "level2.h"
#import "cfg.h"
#import "Combinations.h"
#import "Constants.h"
#import "Tutorial.h"

#import "SimpleAudioEngine.h"

#define kGoodDrop_ 1001
#define kBadDrop_ 1002
#define kBrainDrop_ 1003

#define kBrainNr1 1
#define kBrainNr2 2
#define kBrainNr3 3

#define TAG_DROPLET 1005

enum
{
	kGlassSprite = 1004,
	kAngleBarSprite,
	kDialBezierAction,
	kBeerHeadSprite,
};

@implementation level2
@synthesize motionManager, zombie;

-(NSString*)prefix
{
    if (IS_IPAD)return @"";return @"_iPhone";
}
//////////////////////////////////////////////////////////////////////////
//------------------ RANDOM NUMBER FOR DROPLET POSITION -----------------
-(int) randomNumber
{
    if (moreBadDroplet == false)    { badNr = 65; }
    else                            { badNr = 45; }
    
    rand = (arc4random()%100) + 1;
    if      (rand <= badNr) {   rand2 = 1; }
    else if (rand >  badNr) {   rand2 = 2; }
    
    // This is random number from 1 to 10;
    randNumber = (arc4random()%10) + 1;
    
    switch (randNumber)
    {
        case  1: randPosition = kWidthScreen*0.12f; break;
        case  2: randPosition = kWidthScreen*0.15f; break;
        case  3: randPosition = kWidthScreen*0.25f; break;
        case  4: randPosition = kWidthScreen*0.35f; break;
        case  5: randPosition = kWidthScreen*0.45f; break;
        case  6: randPosition = kWidthScreen*0.55f; break;
        case  7: randPosition = kWidthScreen*0.65f; break;
        case  8: randPosition = kWidthScreen*0.75f; break;
        case  9: randPosition = kWidthScreen*0.80f; break;
        case 10: randPosition = kWidthScreen*0.88f; break;
        default:
            break;
    }
    return randPosition;
}
//////////////////////////////////////////////////////////////////////////
//------------------------- RAIN ANIMATIN --------------------------------
-(void) rain
{
    dropletNumber++;
    score = 50 - dropletNumber;
    
    if (dropletNumber == 1) { randPosition = 100; }
    
    drop = [[[droplet alloc]initWithPosition:ccp ([self randomNumber],kHeightScreen+30) withTyp:rand2]autorelease];
    [self addChild:drop z:36];
    
    if (rand2 == 1) { drop.tag = kGoodDrop_;   }
    if (rand2 == 2) { drop.tag = kBadDrop_;    }
}
//////////////////////////////////////////////////////////////////////////
//------------------------- ACCELEROMETER --------------------------------
- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    cupSpeedX = (acceleration.y * 16)  * orient;
    rotAngleNumber = (cupSpeedX * 1.f) * orient;
}
//////////////////////////////////////////////////////////////////////////
//------------------------- MOVEMENTS UPDATE -----------------------------
-(void) updateCupMovements
{
    float minX;
    float maxX;
    
    maxX = kWidthScreen * 0.93f - glasscup.contentSize.width/2;
    
    if (IS_IPHONE_5)    { minX = kWidthScreen * 0.15f - glasscup.contentSize.width/2; }
    else                { minX = kWidthScreen * 0.198f - glasscup.contentSize.width/2; }
    
   
    newX = glasscup.position.x + cupSpeedX;
    newX = MIN(MAX(newX, minX), maxX);
    
    zombie.position     = ccp(newX, kHeightScreen*0.202f);
    glasscup.position   = ccp(newX, kHeightScreen*0.056f);
    raft.position       = ccp(newX, kHeightScreen*0.045f);
    
    raft.rotation       =   rotAngleNumber * 1.0f * (-1) * orient;
    zombie.rotation     =   rotAngleNumber * 1.2f * (-1) * orient;
    glasscup.rotation   =   rotAngleNumber * 1.2f * orient;

}

-(void)GAME_RESUME
{
    pause = false;
    
    [self resumeSchedulerAndActions];
    
    for (CCNode *ch in [self children])
    {
        [ch resumeSchedulerAndActions];
        for (CCNode *c in [ch children])
        {
            [c resumeSchedulerAndActions];
            for (CCNode *c_ in [c children])
            {
                [c_ resumeSchedulerAndActions];
                
            }
        }
    }
}

-(void)GAME_PAUSE
{
    if (pause)
        return;
    
    pause = true;
    
    [self unschedule:@selector(GAME_PAUSE)];
    
    [self pauseSchedulerAndActions];

    for (CCNode *ch in [self children])
    {
        [ch pauseSchedulerAndActions];
        for (CCNode *c in [ch children])
        {
            [c pauseSchedulerAndActions];
            for (CCNode *c_ in [c children])
            {
                [c_ pauseSchedulerAndActions];
            }
        }
    }
}

-(void) update:(ccTime)dt
{
    pause = NO;
    
    switch (m_status) {
            
        case STATUS_NORMAL:
        {
            
            
        break; }
            
        case STATUS_LOAD:
        {
            [self schedule:@selector(rain) interval:1.2f];
            m_status = STATUS_START;
            
        break;}
            
        case STATUS_START:
        {
            [self worldDetailsUpdate];
            [self updateCupMovements];
            
            [self chekingProgres];
            [self chekingBoundingBoxes];
            
        break;}
            
        case STATUS_FINISH:
        {
            [self unschedule:@selector(rain)];
            [self unscheduleUpdate];
            [self fadeOutAllActiveDroplets];
            [cfg runSelectorTarget:_hud selector:@selector(WINLevel) object:nil afterDelay:1.f sender:self];
            [_hud TIME_Stop];
        
        break;}
            
        default:
            break;
    }
}

-(void)fadeOutAllActiveDroplets{

    for (CCSprite *d in [self children]) {
        if (d.tag == kGoodDrop_ || d.tag == kBadDrop_) {
            for (CCNode *n in [d children]) {
                for (CCSprite *n_ in [n children]) {
                    [n_ runAction:[CCFadeTo actionWithDuration:0.5f opacity:0]];
                }
            }
        }
    }
}

//////////////////////////////////////////////////////////////////////////
//------------------------- DROPLET SPLASH ANIMATION ---------------------
-(void) dropletAnimation:(CCSprite*)spr_
{
    if ([spr_ getActionByTag:1001]) return;
    
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
    
    CCAnimation *animation = [CCAnimation animationWithFrames:animFrames delay:0.03f];

    id animat = [CCAnimate actionWithAnimation:animation
                          restoreOriginalFrame:NO];
    id rem = [CCCallBlock actionWithBlock:^(void)
    {
        [spr_ removeFromParentAndCleanup:YES];
        dropAnim = false;
    }];
    
    [spr_ runAction:[CCSequence actions:animat,rem, nil]].tag = 1001;
    spr_.scale = 0.5f;
}
-(void)removeDroplets2:(CCSprite*)spr_
{
    [spr_ removeFromParentAndCleanup:YES];
    dropAnim = false;
}
//////////////////////////////////////////////////////////////////////////
//------------------------- PROGRES -------------------------------------
-(void) backLblColor
{
    LblScore.color  = ccc3(24,37,38);
    LblPercnt.color = ccc3(24,37,38);
    LblScore.scale  = 1.f;
    LblPercnt.scale = 1.f;
}
-(void) chekingBoundingBoxes
{
    for (CCSprite *sprite_ in [self children])
    {
        droplet *sprite = (droplet*)sprite_;
        
        if (![sprite isKindOfClass:[droplet class]] )//&& !sprite.killed)
        {
            continue;
        }
        
        if (sprite.tag == kGoodDrop_ && !sprite.killed)
        {
            if (CGRectIntersectsRect([glasscup boundingBox], [sprite boundingBox]))
            {
                [AUDIO playEffect:l2_dropletglass];
                
                [sprite removeAllChildrenWithCleanup:YES];
                [sprite unscheduleAllSelectors];
                [self dropletAnimation:sprite];
                dropletCounter++;
                [self addScore];
                sprite.killed = YES;
                
                LblScore.color  = ccc3(255,215,0);
                LblPercnt.color = ccc3(255,215,0);
                LblScore.scale  = 1.3f;
                LblPercnt.scale = 1.3f;
//                [self performSelector:@selector(backLblColor) withObject:nil afterDelay:0.2f];
                [cfg runSelectorTarget:self selector:@selector(backLblColor) object:nil afterDelay:0.2f sender:self];
                
            }
        }
        else if (sprite.tag == kBadDrop_ && !sprite.killed) {
            if (CGRectIntersectsRect([glasscup boundingBox], [sprite boundingBox]))
            {
                [AUDIO playEffect:l2_baddroplet];
                
                [self shake_Animation];
                [sprite removeAllChildrenWithCleanup:YES];
                [sprite unscheduleAllSelectors];
                [self dropletAnimation:sprite];
                dropAnim = true;
                dropletCounter = dropletCounter - 1;
                [self addScore];
                sprite.killed = YES;
                
                LblScore.color  = ccc3(178,34,34);
                LblPercnt.color = ccc3(178,34,34);
                LblScore.scale  = 0.7f;
                LblPercnt.scale = 0.7f;
                //[self performSelector:@selector(backLblColor) withObject:nil afterDelay:0.2f];
                [cfg runSelectorTarget:self selector:@selector(backLblColor) object:nil afterDelay:0.2f sender:self];
            }
        }
    }
    
    if (brain_1)
    {}
    else
    {
        if (CGRectIntersectsRect([glasscup boundingBox], [[self getChildByTag:TAG_BRAIN_1] boundingBox]))
        {
            brain_1 = true;
            
            [cfg makeBrainActionForNode:BrainSprite1
                         fakeBrainsNode:nil
                              direction:270
                           pixelsToMove:1
                                 parent:self
                      removeBrainsAfter:NO
                     makeActionAfterall:@selector(incBrains1)
                                 target:self];
        }
    }
    
    if (brain_2)
    {}
    else
    {
        if (CGRectIntersectsRect([glasscup boundingBox], [[self getChildByTag:TAG_BRAIN_2] boundingBox]))
        {
            brain_2 = true;
            
            [cfg makeBrainActionForNode:BrainSprite2
                         fakeBrainsNode:nil
                              direction:270
                           pixelsToMove:1
                                 parent:self
                      removeBrainsAfter:NO
                     makeActionAfterall:@selector(incBrains2)
                                 target:self];
        }
    }
    
    if (brain_3) 
    {}
    else
    {
        if (CGRectIntersectsRect([glasscup boundingBox], [[self getChildByTag:TAG_BRAIN_3] boundingBox]))
        {
            brain_3 = true;
            
            [cfg makeBrainActionForNode:BrainSprite3
                         fakeBrainsNode:nil
                              direction:270
                           pixelsToMove:1
                                 parent:self
                      removeBrainsAfter:NO
                     makeActionAfterall:@selector(incBrains3)
                                 target:self];
        }
    }
    
}

-(void) incBrains1 { [_hud increaseBRAINSNUMBER]; }

-(void) incBrains2 { [_hud increaseBRAINSNUMBER]; }

-(void) incBrains3 { [_hud increaseBRAINSNUMBER]; }


-(void) chekingProgres
{
    if (dropletCounter < 0)
    {
        dropletCounter = 0;
        [self addScore];
    }
    
    if (dropletCounter < 1)
    {
        water_0.opacity = 0;
        water_1.opacity = 0;
        water_2.opacity = 0;
        water_3.opacity = 0;
        water_4.opacity = 0; 
    }
    else if (dropletCounter >= 1 && dropletCounter < 8)
    {
        water_0.opacity = 255;
        water_1.opacity = 0;
        water_2.opacity = 0;
        water_3.opacity = 0;
        water_4.opacity = 0;
    }
    else if (dropletCounter >= 8 && dropletCounter < 12)
    {
        water_0.opacity = 0;
        water_1.opacity = 255;
        water_2.opacity = 0;
        water_3.opacity = 0;
        water_4.opacity = 0;

        [self brain1_Animation];
        
        moreBadDroplet = true;
        [self schedule:@selector(rain) interval:0.6f];
    }
    else if (dropletCounter >= 12 && dropletCounter < 14)
    {
        water_0.opacity = 0;
        water_1.opacity = 0;
        water_2.opacity = 255;
        water_3.opacity = 0;
        water_4.opacity = 0;
        
    }
    else if (dropletCounter >= 14 && dropletCounter < 16)
    {
        water_0.opacity = 0;
        water_1.opacity = 0;
        water_2.opacity = 0;
        water_3.opacity = 255;
        water_4.opacity = 0;
        
        [self brain2_Animation];
    }
    else if (dropletCounter >= 20)
    {
        m_status = STATUS_FINISH;
        
        [AUDIO playEffect:fx_winmusic];
        
        water_0.opacity = 0;
        water_1.opacity = 0;
        water_2.opacity = 0;
        water_3.opacity = 0;
        water_4.opacity = 255;
    }
    

}
//////////////////////////////////////////////////////////////////////////
//------------------------- TOUCHES -------------------------------------
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint touchPos = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
    if (CGRectContainsPoint(monster.boundingBox, touchPos) && !monsterGavedBrain)
    {
        [AUDIO playEffect:l2_monster2];
        
        [self brain3_Animation];
        monsterGavedBrain = YES;
        [self monsterDie_Animation];
    }
}
//////////////////////////////////////////////////////////////////////////
//------------------------- WORLD DETAILS --------------------------------
-(void) worldDetailsUpdate
{
    if (IS_IPAD)
    {
        world_2.position    = ccp(kWidthScreen / 2  + kWidthScreen*0.1f - newX/5.5f,    kHeightScreen * 0.04f);
        world_3.position    = ccp(kWidthScreen / 2  - newX/3.5,                         kHeightScreen * 0.001f);
    }
    clouds_1.position   = ccp(kWidthScreen * 0.2f   - newX/4,                           kHeightScreen * 0.92f);
    clouds_2.position   = ccp(kWidthScreen / 1.8    - newX/4.2,                         kHeightScreen * 0.94f);
    clouds_3.position   = ccp(kWidthScreen * 0.8f   - newX/5,                           kHeightScreen * 0.96f);
    clouds_4.position   = ccp(kWidthScreen * 1.1f   - newX/4.5,                         kHeightScreen * 0.96f);
    clouds_5.position   = ccp(kWidthScreen * 0.2f   - newX/6,                           kHeightScreen * 0.95f);
}

-(void) CreateZombie
{
    /////////////////////////////////////////////////////////////
    
    CGRect rect;
    if (IS_IPAD) {rect = CGRectMake(0, 0, 175, 230);}else{rect = CGRectMake(0, 0, 100, 125);}

    zombie = [[[JoeZombieController alloc]initWitPos:ccp(0, 0) size:CGSizeMake(rect.size.width,rect.size.height)]autorelease];
    [self addChild:zombie z:2 tag:999];

    zombie.scale        = 0.6f;
    zombie.position     = ccp(kWidthScreen * 0.2f,      kHeightScreen * 0.3f);
    zombie.anchorPoint  = ccp(0.5f, 0.5f);
    [zombie JOE_IDLE];
    
    [zombie JOE_HIDE:3 opacity:0];
    [zombie JOE_HIDE:4 opacity:0];
    [zombie JOE_HIDE:5 opacity:0];
    [zombie JOE_HIDE:6 opacity:0];
    [zombie JOE_HIDE:15 opacity:0];
    [zombie JOE_HIDE:16 opacity:0];
    
    /////////////////////////////////////////////////////////////
}
-(void) LoadWorldDetails
{
    glasscup = [CCSprite spriteWithSpriteFrameName:@"jar.png"];
    glasscup.position       = ccp(kWidthScreen * 0.2f,      kHeightScreen * 0.12f);
    glasscup.anchorPoint    = ccp(0.5, 0);
    [self addChild:glasscup z:35];

    [self CreateZombie];
    
    CCSprite * reflect = [CCSprite spriteWithSpriteFrameName:@"reflector.png"];
    reflect.position        = ccp(glasscup.contentSize.width/2.1, glasscup.contentSize.height/4.4f);
    reflect.anchorPoint     = ccp(0.5, 0);
    [glasscup addChild:reflect z:40];
    
    raft = [CCSprite spriteWithSpriteFrameName:@"plaustas.png"];
    raft.position           = ccp(kWidthScreen * 0.2f,      kHeightScreen * 0.2f);
    raft.scale              = 0.8;
    [items addChild:raft z:34];
    
    
    water_0 = [CCSprite spriteWithSpriteFrameName:@"water0.png"];
    water_0.position        = ccp(glasscup.contentSize.width/2, glasscup.contentSize.height*0.09);
    water_0.anchorPoint     = ccp(0.5, 0);
    water_0.scale           = 0.75;
    water_0.opacity = 255;
    [glasscup addChild:water_0 z:36];
    
    water_1 = [CCSprite spriteWithSpriteFrameName:@"water1.png"];
    water_1.position        = ccp(glasscup.contentSize.width/2, glasscup.contentSize.height*0.09);
    water_1.anchorPoint     = ccp(0.5, 0);
    water_1.scale           = 0.75;
    water_1.opacity         = 0;
    [glasscup addChild:water_1 z:36];
    
    water_2 = [CCSprite spriteWithSpriteFrameName:@"water2.png"];
    water_2.position        = ccp(glasscup.contentSize.width/2, glasscup.contentSize.height*0.09);
    water_2.anchorPoint     = ccp(0.5, 0);
    water_2.scale           = 0.75;
    water_2.opacity         = 0;
    [glasscup addChild:water_2 z:36];
    
    water_3 = [CCSprite spriteWithSpriteFrameName:@"water3.png"];
    water_3.position        = ccp(glasscup.contentSize.width/2, glasscup.contentSize.height*0.09);
    water_3.anchorPoint     = ccp(0.5, 0);
    water_3.scale           = 0.75;
    water_3.opacity         = 0;
    [glasscup addChild:water_3 z:36];
    
    water_4 = [CCSprite spriteWithSpriteFrameName:@"water4.png"];
    water_4.position        = ccp(glasscup.contentSize.width/2, glasscup.contentSize.height*0.09);
    water_4.anchorPoint     = ccp(0.5, 0);
    water_4.scale            = 0.75;
    water_4.opacity         = 0;
    [glasscup addChild:water_4 z:36];

    if (IS_IPAD)
    {
        world_2 = [CCSprite spriteWithSpriteFrameName:@"bg1.png"];
        world_2.position        = ccp(kWidthScreen / 2 + kWidthScreen * 0.1f,   kHeightScreen * 0.04f);
        world_2.anchorPoint     = ccp(0.5,0);
        world_2.scale           = 1.5f;
        [items addChild:world_2 z:20];
        
        world_3 = [CCSprite spriteWithSpriteFrameName:@"bg2.png"];
        world_3.position        = ccp(kWidthScreen / 2,                         kHeightScreen * 0.001f);
        world_3.anchorPoint     = ccp(0.5,0);
        [items addChild:world_3 z:22];
    }
    
    clouds_1 = [CCSprite spriteWithSpriteFrameName:@"cloud0.png"];
    clouds_1.position       = ccp(kWidthScreen * 0.2f,                      kHeightScreen * 0.98f);
    [items addChild:clouds_1 z:4];
    
    clouds_2 = [CCSprite spriteWithSpriteFrameName:@"cloud1.png"];
    clouds_2.position       = ccp(kWidthScreen / 2,                         kHeightScreen * 0.94f);
    [items addChild:clouds_2 z:6];
    
    clouds_3 = [CCSprite spriteWithSpriteFrameName:@"cloud2.png"];
    clouds_3.position       = ccp(kWidthScreen * 0.8f,                      kHeightScreen * 0.96f);
    [items addChild:clouds_3 z:5];
    
    clouds_4 = [CCSprite spriteWithSpriteFrameName:@"cloud3.png"];
    clouds_4.position       = ccp(kWidthScreen * 1.1f,                      kHeightScreen * 0.96f);
    [items addChild:clouds_4 z:6];
    
    clouds_5 = [CCSprite spriteWithSpriteFrameName:@"cloud4.png"];
    clouds_5.position       = ccp(kWidthScreen * 0.2f,                      kHeightScreen* 0.94f);
    clouds_5.scale = 2.0f;
    [items addChild:clouds_5 z:2];
    
    
    monster = [CCSprite spriteWithSpriteFrameName:@"monster_2.png"];
    monster.position        = ccp(kWidthScreen * 0.8f,                      kHeightScreen * 0.035f);
    monster.scale = 0.8f;
    [items addChild:monster z:26];
    
    CCMoveTo *monsterAnim1 = [CCMoveTo actionWithDuration:2.0f position:ccp(kWidthScreen * 0.8f, kHeightScreen * 0.035f)];
    CCMoveTo *monsterAnim2 = [CCMoveTo actionWithDuration:2.0f position:ccp(kWidthScreen * 0.8f, kHeightScreen * 0.002f)];
    CCSequence *actionMonsterRun = [CCSequence actions:monsterAnim1, monsterAnim2, nil];
    MactionsRepeat = [CCRepeatForever actionWithAction:actionMonsterRun];
    [monster runAction:MactionsRepeat];
    
    
    monsterLeft = [CCSprite spriteWithSpriteFrameName:@"monster_0.png"];
    monsterLeft.position        = ccp(kWidthScreen * 0.755f,                       kHeightScreen * 0.1f);
    //monsterLeft.scale = 0.8f;
    [items addChild:monsterLeft z:25];
    
    monsterRight = [CCSprite spriteWithSpriteFrameName:@"monster_1.png"];
    monsterRight.position        = ccp(kWidthScreen * 0.845f,                      kHeightScreen * 0.1f);
    //monsterRight.scale = 0.8f;
    [items addChild:monsterRight z:25];
    
    CCMoveTo *monsterA1 = [CCMoveTo actionWithDuration:2.0f position:ccp(kWidthScreen * 0.755f, kHeightScreen * 0.1f)];
    CCMoveTo *monsterA2 = [CCMoveTo actionWithDuration:2.0f position:ccp(kWidthScreen * 0.755f, kHeightScreen * 0.067f)];
    CCSequence *actionMonster = [CCSequence actions:monsterA1, monsterA2, nil];
    MactionsRepeat2 = [CCRepeatForever actionWithAction:actionMonster];
    [monsterLeft runAction:MactionsRepeat2];
    
    CCMoveTo *monsterA3 = [CCMoveTo actionWithDuration:2.0f position:ccp(kWidthScreen * 0.845f, kHeightScreen * 0.1f)];
    CCMoveTo *monsterA4 = [CCMoveTo actionWithDuration:2.0f position:ccp(kWidthScreen * 0.845f, kHeightScreen * 0.067f)];
    CCSequence *actionMonster2 = [CCSequence actions:monsterA3, monsterA4, nil];
    MactionsRepeat22 = [CCRepeatForever actionWithAction:actionMonster2];
    [monsterRight runAction:MactionsRepeat22];
    
    
    
    bottle = [CCSprite spriteWithSpriteFrameName:@"bottle.png"];
    bottle.position    = ccp(kWidthScreen * 0.2f,                      kHeightScreen * 0.02f);
    bottle.scale = 0.8f;
    [items addChild:bottle z:26];
    
    CCMoveTo *bottleAnim1 = [CCMoveTo actionWithDuration:1.5f position:ccp(kWidthScreen * 0.2f,     kHeightScreen * 0.035f)];
    CCMoveTo *bottleAnim2 = [CCMoveTo actionWithDuration:1.5f position:ccp(kWidthScreen * 0.23f,    kHeightScreen * 0.02f)];
    CCMoveTo *bottleAnim3 = [CCMoveTo actionWithDuration:1.5f position:ccp(kWidthScreen * 0.26f,    kHeightScreen * 0.035f)];
    CCSequence *actionBottle = [CCSequence actions:bottleAnim1, bottleAnim2, bottleAnim3, nil];
    CCRepeatForever *BactionsRepeat = [CCRepeatForever actionWithAction:actionBottle];
    [bottle runAction:BactionsRepeat];
    
    
    wave_1 = [CCSprite spriteWithSpriteFrameName:@"wave0.png"];
    wave_1.position     = ccp(kWidthScreen / 2,                         kHeightScreen * 0.022f);
    wave_1.scaleX       = 1.5f;
    [items addChild:wave_1 z:40];
    
    wave_2 = [CCSprite spriteWithSpriteFrameName:@"wave1.png"];
    wave_2.position     = ccp(kWidthScreen / 2,                         kHeightScreen * 0.022f);
    wave_2.scaleX       = 1.5f;
    [items addChild:wave_2 z:24];
    
    CCMoveTo *waveAnim1 = [CCMoveTo actionWithDuration:2.5f position:ccp(kWidthScreen / 2.5f,   kHeightScreen * 0.022f)];
    CCMoveTo *waveAnim2 = [CCMoveTo actionWithDuration:2.5f position:ccp(kWidthScreen / 2,      kHeightScreen * 0.022f)];
    CCSequence *actionRun = [CCSequence actions:waveAnim1, waveAnim2, nil];
    CCRepeatForever *actionsRepeat = [CCRepeatForever actionWithAction:actionRun];
    [wave_1 runAction:actionsRepeat];
    
    CCMoveTo *waveAnim3 = [CCMoveTo actionWithDuration:4.0f position:ccp(kWidthScreen / 2.5f,   kHeightScreen * 0.022f)];
    CCMoveTo *waveAnim4 = [CCMoveTo actionWithDuration:4.0f position:ccp(kWidthScreen / 2,      kHeightScreen * 0.022f)];
    CCSequence *actionRun2 = [CCSequence actions:waveAnim3, waveAnim4, nil];
    CCRepeatForever *actionsRepeat2 = [CCRepeatForever actionWithAction:actionRun2];
    [wave_2 runAction:actionsRepeat2];
    
    
    kolona_1 = [CCSprite spriteWithSpriteFrameName:@"kolona0.png"];
    if (IS_IPHONE) {
        kolona_1.position       = ccp(kWidthScreen - kWidthScreen * 0.98f - kolona_1.contentSize.width/2,       kHeightScreen * 0.002f);
    }else {
        kolona_1.position       = ccp(kWidthScreen * 0.001f,                                                    kHeightScreen * 0.002f);
    }
    kolona_1.anchorPoint        = ccp(0,0);
    [items addChild:kolona_1 z:36];
    
    kolona_2 = [CCSprite spriteWithSpriteFrameName:@"kolona1.png"];
    if (IS_IPHONE) {
        kolona_2.position       = ccp(kWidthScreen * 0.98f + kolona_2.contentSize.width/2,      kHeightScreen * 0.002f);
    }else {
        kolona_2.position       = ccp(kWidthScreen * 1.0f,                                      kHeightScreen * 0.002f);
    }
    kolona_2.anchorPoint        = ccp(1,0);
    [items addChild:kolona_2 z:36];
}

-(id)getNode
{    
    return [level2 node];
}

-(void)shotTut_2
{
    Tutorial *tut = [[[Tutorial alloc]init]autorelease];
    tut.position = ccp(kWidthScreen/2, kHeightScreen/2);
    [self addChild:tut z:999 tag:9992];
    [tut ROTATE_TutorialRepeat:1 delay:1 runAfterDelay:1];
    
}

//////////////////////////////////////////////////////////////////////////
//------------------------------ INIT ------------------------------------
- (id)initWithHUD:(InGameButtons *)hud
{
    if ((self = [super init])) {
        _hud = hud;
        
      //  [cfg addInGameButtonsFor:self];
        
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft)
        {
            orient = 1;
        }
        else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
        {
            orient = -1;
        }
        
        self.motionManager = [[[CMMotionManager alloc]init]autorelease];
        motionManager.deviceMotionUpdateInterval = 1.0/60.0;
        if(motionManager.isDeviceMotionAvailable)
        [motionManager startDeviceMotionUpdates];
        
        CCSpriteBatchNode *bg =       [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"BG_Level2%@.pvr.ccz",[self prefix]]];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"BG_Level2%@.plist",[self prefix]]];
        [self addChild:bg z:0];
        if (IS_IPAD) { bgSp = [CCSprite spriteWithSpriteFrameName:@"bg.jpg"]; }
        else { bgSp         = [CCSprite spriteWithSpriteFrameName:@"bg_iphone.jpg"]; }
        bgSp.anchorPoint    = ccp(0,0);
        bgSp.position       = ccp(0,0);
        [bg addChild:bgSp];
        
        items =                         [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"Level2%@.pvr.ccz",[self prefix]]];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"Level2%@.plist",  [self prefix]]];
        [self addChild:items z:2];
        
        self.isAccelerometerEnabled = YES;
        intervalWas =  [[UIAccelerometer sharedAccelerometer]updateInterval];
        intervalMine = 1/60.f;
        [[UIAccelerometer sharedAccelerometer] setUpdateInterval:intervalMine];
        
        
        self.isTouchEnabled         = YES;
        
        
        [self LoadWorldDetails];
        [self scoresLabel];
        
        m_status = STATUS_LOAD;
        
        brain_1 = false;
        brain_2 = false;
        brain_3 = false;
        
        
        [_hud preloadBlast_self:self brainNr:3 parent:self];
        
        // *** set brain positions
        
        [_hud BRAIN_:TAG_BRAIN_1 position:BrainSprite1.position parent:self];
        [_hud BRAIN_:TAG_BRAIN_1 zOrder:120 parent:self];
        
        [_hud BRAIN_:TAG_BRAIN_2 position:BrainSprite2.position parent:BrainSprite2];
        [_hud BRAIN_:TAG_BRAIN_2 zOrder:120 parent:self];
        
        [_hud BRAIN_:TAG_BRAIN_3 position:BrainSprite3.position parent:BrainSprite3];
        [_hud BRAIN_:TAG_BRAIN_3 zOrder:120 parent:self];
        
        if (_hud.tutorialSHOW)
        {
            pause = YES;
            [self schedule:@selector(GAME_PAUSE) interval:0.1f];
        }
        
        moreBadDroplet = false;
        
        brainRealese        = 0;
        monsterTouchNumber  = 0;
        

        [self createBrains];
        [self scheduleUpdate];
        if (![Combinations checkNSDEFAULTS_Bool_ForKey:C_TUTORIAL_(_hud.level)]){
        [cfg runSelectorTarget:self selector:@selector(shotTut_2) object:nil afterDelay:1 sender:self];
        }
        
	}
	return self;
}

-(void) scoresLabel
{
    dropletPercent = 0;

    LblScore = [CCLabelBMFont labelWithString:@"000" fntFile:kFONT_LARGE];
    LblScore.anchorPoint    = ccp(0.5f, 0.5f);
    LblScore.position       = ccp(glasscup.contentSize.width/2.2f, glasscup.contentSize.height/2);
    LblScore.color          = ccc3(24,37,38);
    
    [LblScore setString: @"0"];
    
  
    LblPercnt = [CCLabelBMFont labelWithString:@"00" fntFile:kFONT_LARGE];
    LblPercnt.anchorPoint    = ccp(0.5f, 0.5f);
    LblPercnt.position       = ccp(LblScore.position.x+LblScore.contentSize.width, glasscup.contentSize.height/2);
    LblPercnt.color          = ccc3(24,37,38);
    
    [LblPercnt setString: @" %"];
    
    [glasscup addChild:LblScore  z:39];
    [glasscup addChild:LblPercnt z:39];
}

-(void) addScore
{
    dropletPercent = dropletCounter * 5;
    
    [LblScore setString: [NSString stringWithFormat:@"%d",dropletPercent]];
    [LblPercnt setString: @" %"]; 
}
//////////////////////////////////////////////////////////////////////////
//------------------------- BRAIN MOVEMENTS -----------------------------
-(void) createBrains
{
    BrainSprite1 = (BrainRobot*)[self getChildByTag:TAG_BRAIN_1];
    BrainSprite2 = (BrainRobot*)[self getChildByTag:TAG_BRAIN_2];
    BrainSprite3 = (BrainRobot*)[self getChildByTag:TAG_BRAIN_3];
    
    
    BrainSprite1.position = ccp(kWidthScreen*0.3f, kHeightScreen + 100);
    BrainSprite2.position = ccp(kWidthScreen*0.8f, kHeightScreen + 100);
    BrainSprite3.position = ccp(kWidthScreen*0.8f, kHeightScreen - kHeightScreen * 1.1f);
}

-(void) brain1_Animation
{
    if (b1) return;
    else
    {
        b1 = true;
        
        id fallB1 = [CCMoveTo actionWithDuration:3.5f position:ccp(kWidthScreen*0.3f, -100)];
        id doneAction1 = [CCCallFuncN actionWithTarget:self selector:@selector(B1ActionDone)];
        CCSequence *a1 = [CCSequence actions:fallB1, doneAction1, nil];
        [BrainSprite1 runAction:a1];
    }
}
-(void) B1ActionDone { [BrainSprite1 removeFromParentAndCleanup:YES]; brain_1 = true; }

-(void) brain2_Animation
{
    if (b2) return;
    else
    {
        b2 = true;
        
        id fallB2 = [CCMoveTo actionWithDuration:3.5f position:ccp(kWidthScreen*0.8f, -100)];
        id doneAction2 = [CCCallFuncN actionWithTarget:self selector:@selector(B2ActionDone)];
        CCSequence *a2= [CCSequence actions:fallB2, doneAction2, nil];
        [BrainSprite2 runAction:a2];
    }
}
-(void) B2ActionDone { [BrainSprite2 removeFromParentAndCleanup:YES]; brain_2 = true; }

-(void) brain3_Animation
{
    id brain3Anim1 = [CCJumpTo actionWithDuration:2.5f position:ccp(kWidthScreen * 0.2f, -100) height:kHeightScreen * 0.6f jumps:1];
    id doneAction3 = [CCCallFuncN actionWithTarget:self selector:@selector(B3ActionDone)];
    CCSequence *a3 = [CCSequence actions:brain3Anim1, doneAction3, nil];
    [BrainSprite3 runAction:a3];
}
-(void) B3ActionDone { [BrainSprite3 removeFromParentAndCleanup:YES]; brain_3 = true; }

-(void) monsterDie_Animation
{
    monsterDead = true;
    
    [monster stopAction:  MactionsRepeat];
    [monster stopAction: MactionsRepeat2];
    [monster stopAction:MactionsRepeat22];
    
    id monsterMoveDown  = [CCMoveTo actionWithDuration:4.5f position:ccp(monster.position.x, -200)];
    id monsterMoveDown2 = [CCMoveTo actionWithDuration:4.5f position:ccp(monster.position.x, -200)];
    id monsterMoveDown3 = [CCMoveTo actionWithDuration:4.5f position:ccp(monster.position.x, -200)];

    [monster        runAction:monsterMoveDown];
    [monsterLeft    runAction:monsterMoveDown2];
    [monsterRight   runAction:monsterMoveDown3];
}

-(void) shake_Animation
{
    id shakeL1  = [CCMoveTo actionWithDuration:0.05f position:ccp(zombie.position.x+zombie.contentSize.width*0.1f, zombie.position.y)];
    id shakeR1  = [CCMoveTo actionWithDuration:0.05f position:ccp(zombie.position.x-zombie.contentSize.width*0.1f, zombie.position.y)];
    id shakeL11 = [CCMoveTo actionWithDuration:0.05f position:ccp(zombie.position.x+zombie.contentSize.width*0.1f, zombie.position.y)];
    CCSequence *a4 = [CCSequence actions:shakeL1, shakeR1, shakeL11, nil];
    
    id shakeL2  = [CCMoveTo actionWithDuration:0.05f position:ccp(glasscup.position.x+glasscup.contentSize.width*0.1f, glasscup.position.y)];
    id shakeR2  = [CCMoveTo actionWithDuration:0.05f position:ccp(glasscup.position.x-glasscup.contentSize.width*0.1f, glasscup.position.y)];
    id shakeL22 = [CCMoveTo actionWithDuration:0.05f position:ccp(glasscup.position.x+glasscup.contentSize.width*0.1f, glasscup.position.y)];
    CCSequence *a5 = [CCSequence actions:shakeL2, shakeR2, shakeL22, nil];
    
    [zombie     runAction:a4];
    [glasscup   runAction:a5];
}

- (void)onEnter{

    [super onEnter];
}

-(void) onExit{
    
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:intervalWas];
    [self removeAllChildrenWithCleanup:YES];
        
    [super onExit];
}

- (void) dealloc
{
    [motionManager release];
    motionManager = nil;
	[super dealloc];
}
@end
