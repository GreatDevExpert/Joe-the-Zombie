//
//  Level1.m
//  Zombie Joe
//
//  Created by Mac4user on 4/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Level1.h"
#import "cfg.h"
#import "Constants.h"
#import "constants_l1.h"
#import "BrainsBonus.h"
#import "SimpleAudioEngine.h"
#import "SOUND_EFFECTS_BASE.h"
#import "Tutorial.h"

#define BONUS1 TAG_BRAIN_1//1111
#define BONUS2 TAG_BRAIN_2//1112
#define BONUS3 TAG_BRAIN_3//1113

#define TUT_BIRD    1
#define TUT_JOEHEAD 2
#define TUT_POPUP   3

@implementation Level1{
    
    Tutorial *tut;
    

    
}
//@synthesize FILL_CHAR;

//+(CCScene *) scene
//{
//	CCScene *scene = [CCScene node];
//	Level1 *layer = [Level1 node];
//    
////    InGameButtons *game = [[InGameButtons alloc]initWithParent:scene initWithRect:kInGameButtonViewRect];
////    [scene addChild:game];
//    
//	[scene addChild: layer];
//	return scene;
//}

#pragma mark DELEGATE METHODS

-(id)getNode{
    
    return [Level1 node];
    
}

-(void)gameStateEnded{
     [AUDIO playEffect:fx_winmusic];
  //  NSLog(@"level passed");
    [_hud WINLevel];
    
    
}

- (id)initWithHUD:(InGameButtons *)hud
{
	if( (self=[super init])) {
        _hud = hud;
        
        bonus = 0;
        bonus1_touched = 0;
        
      
        
        float iPhoneFixY =   (IS_IPHONE_5)  ? 5 : 0;
        YFIX =         (IS_IPAD)      ? 0 : iPhoneFixY;
        
        float iPhoneFixX =   (IS_IPHONE_5) ? (-80) : 0;
        XFIX =         (IS_IPAD)     ? 0 : iPhoneFixX;

        //add top buttons with delegates
     //   [cfg addInGameButtonsFor:self];
        
        [cfg addBG_forNode:self withCCZ:@"bg_level1" bg:@"bg.jpg"];
        
        [self addSprites];
        [self addTwoEyesInHoleBlink];
        [self addPlaustasAction];
        [self addTrunkAnimation];
        [self addBirdHeadAnimation];
        [self addHandsAnimation];
        [self addFILLCHARACTER];
        [self addSmokeTOHouse];

        [self schedule:@selector(update:)];
        
        [_hud preloadBlast_self:self brainNr:3 parent:self];
        
        [self addBrainBonuses];
        
        [self schedule:@selector(checkBrainWithWoodTick:)];
        
        [self schedule:@selector(particleFallow:)];
        
        if (_hud.tutorialSHOW)
        {
            pause = YES;
            [self schedule:@selector(GAME_PAUSE) interval:0.1f];
        }
    
      //  NSLog(@"brain counter %i",[db getBrainsCounter]);
        
        [self tutorailIngame];
        
        [cfg runSelectorTarget:self selector:@selector(runTut) object:nil afterDelay:0.1f sender:self];

        
	}
	return self;
}

-(void)runTut{
    
       T_SHOW_TUTORIAL = YES;
    
}

-(void)tutorailIngame{
    
    if (![Combinations checkNSDEFAULTS_Bool_ForKey:C_TUTORIAL_(_hud.level)])
    {
        tut = [[[Tutorial alloc]init]autorelease];
        [self addChild:tut z:10];
    }
    
    [self schedule:@selector(showTutorials:) interval:4.f];

}

-(void)tutorialSuccess:(int)type_{
    
    if (!T_SHOW_TUTORIAL) 
        return;
    
    [tut stopTutorials];
    
    if      (type_==TUT_BIRD)       T_BIRDTAP    = YES;
    else if (type_==TUT_JOEHEAD)    T_JOEHEADTAP = YES;
    else if (type_==TUT_POPUP)      T_POPUPMONEY = YES;
    
}

-(void)showTutorials:(ccTime)dt{
    
    if (!T_SHOW_TUTORIAL)
        return;
    
    if ([tut thereAreTutorialsRunning]) {
        return;
    }
    
    if (!T_JOEHEADTAP)
    {
        tut.position = [spritesBgNode getChildByTag:5].position;
        [tut TAP_TutorialRepeat:3 delay:1.f runAfterDelay:0];
    }
    
    else if (!T_BIRDTAP)
    {
        tut.position = [spritesBgNode getChildByTag:0].position;
        [tut TAP_TutorialRepeat:3 delay:1.f runAfterDelay:0];
    }
    
    else if (!T_POPUPMONEY){
//        tut.position = ccpAdd( [spritesBgNode getChildByTag:0].position,
//                              ccp([spritesBgNode getChildByTag:0].boundingBox.size.width/2,
//                                  -[spritesBgNode getChildByTag:0].boundingBox.size.width/2));
        [tut createBaloon];
        [self schedule:@selector(ballonFallow:)];
        T_POPUPMONEY = YES;
    }

    
}

-(void)ballonFallow:(ccTime)dt{
    
    if (![tut thereAreTutorialsRunning])
    {
        [self unschedule:@selector(ballonFallow:)];
        return;
    }
    tut.position = ccpAdd( [spritesBgNode getChildByTag:0].position,
                          ccp([spritesBgNode getChildByTag:0].boundingBox.size.width/2,
                              -[spritesBgNode getChildByTag:0].boundingBox.size.width/2));
    
}

-(void)GAME_RESUME{
    
    pause = false;
    
    [self resumeSchedulerAndActions];
    
    for (CCNode *ch in [self children]) {
        [ch resumeSchedulerAndActions];
        for (CCNode *c in [ch children]) {
            [c resumeSchedulerAndActions];
            for (CCNode *c_ in [c children]) {
                [c_ resumeSchedulerAndActions];
                
            }
        }
    }
}

-(void)GAME_PAUSE{
    
    if (pause) {
        return;
    }
    
    pause = true;
    
    [self unschedule:@selector(GAME_PAUSE)];
    
    [self pauseSchedulerAndActions];
    
    
    
    for (CCNode *ch in [self children]) {
        [ch pauseSchedulerAndActions];
        for (CCNode *c in [ch children]) {
            [c pauseSchedulerAndActions];
            for (CCNode *c_ in [c children]) {
                [c_ pauseSchedulerAndActions];
                
            }
        }
    }
}


-(void)addSmokeTOHouse{
    
    CCParticleSystemQuad *effect = [CCParticleSystemQuad particleWithFile:[NSString stringWithFormat:@"smoke_1.plist"]];
    effect.position = ccp(935*(kSCALEVALX),             477*(kSCALEVALY));
    if (IS_IPHONE || IS_IPHONE_5) {effect.scale = 0.175f;}
    else{
        effect.scale = 0.3f;}
    [self addChild:effect z:10];
    effect.autoRemoveOnFinish = YES;
    

    
//    {
//    //water
//    CCParticleSystemQuad *effect = [CCParticleSystemQuad particleWithFile:[NSString stringWithFormat:@"water_3.plist"]];
//    effect.position = ccp(935*(kSCALEVALX),            80*(kSCALEVALY));
//    if (IS_IPHONE || IS_IPHONE_5) {effect.scale = 0.2f;}
//    else{
//        effect.scale = 0.15f;}
//    [self addChild:effect z:10];
//    effect.autoRemoveOnFinish = YES;
//        effect.rotation = 70;
//    }
    
//    {
//        
//        CCParticleSystemQuad *effect = [CCParticleSystemQuad particleWithFile:[NSString stringWithFormat:@"smoke_1.plist"]];
//        effect.position = ccp(860*(kSCALEVALX),             440*(kSCALEVALY));
//        if (IS_IPHONE || IS_IPHONE_5) {effect.scale = 0.175f;}
//        else{
//            effect.scale = 0.3f;}
//        [self addChild:effect z:10];
//        effect.autoRemoveOnFinish = YES;
//        
//    }
    
}

-(void)addHandsAnimation{

    id rotate  = [CCRotateBy actionWithDuration:3 angle:10];
    id move_rotate_ease = [CCEaseSineInOut actionWithAction:[[rotate copy] autorelease]];
    id rotate_rev = [move_rotate_ease reverse];

    id seq2 = [CCSequence actions:move_rotate_ease,rotate_rev,[CCDelayTime actionWithDuration:0.1f], nil];
    
    [[spritesBgNode getChildByTag:s_hand0] runAction:[CCRepeatForever actionWithAction:   seq2]];
    
    {
        
        
        id rotate  = [CCRotateBy actionWithDuration:3.5f angle:-10];
        id move_rotate_ease = [CCEaseSineInOut actionWithAction:[[rotate copy] autorelease]];
        id rotate_rev = [move_rotate_ease reverse];
        
        id seq2 = [CCSequence actions:move_rotate_ease,rotate_rev,[CCDelayTime actionWithDuration:0.1f], nil];
        
        [[spritesBgNode getChildByTag:s_hand1] runAction:[CCRepeatForever actionWithAction:   seq2]];

    }
    
}
-(void)addBrainBonuses{
    
    for (int x = 0 ; x < 3; x ++)
    {
        //BrainsBonus *BRAIN = //[[BrainsBonus alloc]initWithRect:CGRectMake(0, 0, 0, 0)];
        CCSprite *BRAIN =(CCSprite*)[self getChildByTag:TAG_BRAIN_1+x];
     //   BRAIN.tag = BONUS1+x;
        BRAIN.position = ccp(100*x, 100*x);
        
        if (BRAIN.tag == TAG_BRAIN_1)
        {
            CGPoint bird = BRAIN.position = [spritesBgNode getChildByTag:s_birdhead].position;
            BRAIN.position = ccp(bird.x-(BRAIN.boundingBox.size.width/2), bird.y-(BRAIN.boundingBox.size.height));
            BRAIN.visible = NO;
            
          //  BRAIN.brain.opacity = 0;

         //   BRAIN.brain.scale = 0.5f;
        }
        else if (BRAIN.tag == TAG_BRAIN_2)
        {
            CGPoint pos = BRAIN.position = ccp(ScreenSize.width*0.825f, ScreenSize.height * 0.42f);
            BRAIN.position = pos;

           // [BRAIN moveUpDown_particles:YES ];
        }
        else if (BRAIN.tag == TAG_BRAIN_3)
        {
            CGPoint pos = BRAIN.position = ccp(ScreenSize.width*0.1f, ScreenSize.height * 0.1f);
            BRAIN.position = pos;

          //  [BRAIN moveUpDown_particles:YES ];
        }
        
      //  [self addChild:BRAIN];
    }

}

-(void)update:(ccTime)dt{
    
    pause = NO;
    
    if (!fallow) {
        return;
    }
    
   CGPoint velocity = CGPointMake(-CCRANDOM_0_1(), -1.f); // Move left
   
    [spritesBgNode getChildByTag:s_plaustas].position = ccpAdd([spritesBgNode getChildByTag:s_plaustas].position, velocity);
    
    float h = [[FILL_CHAR spriteBatch] getChildByTag:kEmptyBody].boundingBox.size.height*0.5f;  //0.5f
    
    if (IS_IPHONE) {
        h = [[FILL_CHAR spriteBatch] getChildByTag:kEmptyBody].boundingBox.size.height*0.5f;

    }
    float x = [spritesBgNode getChildByTag:s_plaustas].position.x;
    float y = [spritesBgNode getChildByTag:s_plaustas].position.y+h;

   // [spritesBgNode getChildByTag:s_birdhead].position = ccp(x, y);
    
    FILL_CHAR.position = ccp(x, y);
    
   // NSLog(@"fill char pos y :%f",h);
    
    if (FILL_CHAR.position.y < 
        -h*1.1){
        fallow = NO;
        [self gameStateEnded];
    }
    
}


-(void)_hudLevelPassed{
    
     [_hud LEVEL_PASSED:YES];
    
}

-(void)missionCompleted{
    
    [tut stopTutorials];
    [self unschedule:@selector(showTutorials)];
    T_SHOW_TUTORIAL = NO;

    //NSLog(@"mission completed");
    [self reorderChild:FILL_CHAR z:999];
    
    float h = [[FILL_CHAR spriteBatch] getChildByTag:kEmptyBody].boundingBox.size.height*0.5f;
    if (IS_IPHONE) {
       h =  [[FILL_CHAR spriteBatch] getChildByTag:kEmptyBody].boundingBox.size.height*0.5f;
    }
    // NSLog(@"H : %f",h);
    float x = ((CCSprite *)[spritesBgNode getChildByTag:s_plaustas]).position.x;
    float y = ((CCSprite *)[spritesBgNode getChildByTag:s_plaustas]).position.y+h;
    
    id jumpOnPlot = [CCJumpTo actionWithDuration:0.5f position:ccp(x, y) height:h/3 jumps:1];
    
    //  id delay = [CCDelayTime actionWithDuration:0.5f];
    
    id flip =  [CCCallBlock actionWithBlock:^(void)
                {
                    FILL_CHAR.scaleX=-1;
                    //  [self swimToOffSide];
                }];
    
    id fallow_ =  [CCCallBlock actionWithBlock:^(void)
                   {
                       [self enableFallow];
                       
                   }];
    
    id seq =     [CCSequence actions:flip,jumpOnPlot,fallow_, nil];
    
    [FILL_CHAR runAction:seq];
    
  
}

-(void)enableFallow{
    
    [[spritesBgNode getChildByTag:s_plaustas]stopAllActions];
    fallow = YES;
    
}

-(void)addParticles{
    
    CCParticleSystem* particle1 = [CCParticleSystemQuad particleWithFile: @"dumai_level1_small.plist"];
    [self addChild:particle1 z:10 tag:1];
    particle1.autoRemoveOnFinish = YES;
    particle1.position = ccp(ScreenSize.width/2, ScreenSize.height/2);
    
}

-(void)moveBodyPartByTagToFILLCHAR:(int)tag__{
 
    int filltag_ = 0;
    if      (tag__==s_head)                       filltag_=fill_head;
    else if (tag__==s_brains)                     filltag_=fill_brains;
    else if (tag__==s_hand1 || tag__==s_hand0)    filltag_=fill_hands;
    else if (tag__==s_hat)                        filltag_=fill_hat;
    else if (tag__==s_legs)                       filltag_=fill_legs;
    else if (tag__==s_tshirt)                     filltag_=fill_tshirt;
    
    [self makeFoundAction_withTAG:tag__ fillTag:filltag_];
    
    fallowEffect = tag__;
 
    [self getChildByTag:fallowEffect+100].visible = YES;
    
    int anotherHand = 0;
    
    
    
    if (filltag_==fill_hands)
    {
        if (tag__==s_hand0)
        {
            anotherHand=s_hand1;
        }
        else anotherHand=s_hand0;
        
        [self makeFoundAction_withTAG:anotherHand fillTag:filltag_];
     
    }

}

-(void)stopTimer{
    
    [_hud TIME_Stop];
    
}

-(void)makeFoundAction_withTAG:(int)tag__ fillTag:(int)filltag{

    //id move_scale =    [CCMoveTo actionWithDuration:0.40f position:FILL_CHAR.position
    
    id move = [CCMoveTo actionWithDuration:0.4f position:FILL_CHAR.position];
      id move_ =  [CCEaseElasticInOut actionWithAction:move period:1.f];
    id rot = [CCRotateBy actionWithDuration:0.4f angle:360];
    id move_spawn = [CCSpawn actions:move_,rot, nil];
	//id move_back = [move reverse];
//	id move_ease = [CCEaseSineInOut actionWithAction:[[move copy] autorelease]];
    id move_ease = [CCEaseElastic actionWithAction:move_spawn period:1.f];
	//id move_ease_back = [move_ease reverse];
    
	id seq1 = [CCSequence actions: move_ease, nil];
    
    id unlock =  [CCCallBlock actionWithBlock:^(void)
                  {
                      [FILL_CHAR enableBodyPartByTag:filltag];
                  }];
    
    id delete_ =     [CCCallBlock actionWithBlock:^(void)
                     {
                         [spritesBgNode removeChildByTag:tag__ cleanup:YES];
                         FILL_CHAR.collected++;
                        [FILL_CHAR checkIfAllBodyPartsCollected];
                         fallowEffect = 999;
                         [self removeEffectParticle:tag__];
                         
                         [AUDIO playEffect:l1_item_got];    //sound 1
                         
                     }];
    
    id seq_ =     [CCSequence actions:seq1,unlock,delete_, nil];
    
    [[spritesBgNode getChildByTag:tag__] runAction:seq_];
    
}

-(void)removeEffectParticle:(int)tag__{
 //   NSLog(@"remove particle %i",tag__);
    CCParticleSystemQuad *effect = (CCParticleSystemQuad*)[self getChildByTag:100+tag__];
   // [self removeChild:effect cleanup:YES];
    effect.duration = 0;
    
    
    
   // [self removeChildByTag:100+tag__ cleanup:YES];
    
}

-(void)addFILLCHARACTER{
    
    CGRect pos;
    if (IS_IPHONE_5)
    {
        pos= CGRectMake(660*(kSCALEVALX),155*(kSCALEVALY), 0, 0);
    }
    else
    pos= CGRectMake(790*(kSCALEVALX),155*(kSCALEVALY), 0, 0);
    
    FILL_CHAR = [[[FillCharacter alloc]initWithRect:pos]autorelease];
    [self addChild:FILL_CHAR];
 //   FILL_CHAR.admin  = self;
    
}

-(void)addBirdHeadAnimation{
    
    id move = [CCMoveBy actionWithDuration:0.5f position:ccp(2.5f, -3*(kSCALEVALY))];//[CCRotateBy actionWithDuration:1 angle:4];
	//id move_back = [move reverse];
    id rotate  = [CCRotateBy actionWithDuration:1 angle:2];
    id move_rotate_ease = [CCEaseSineInOut actionWithAction:[[rotate copy] autorelease]];
	id move_ease = [CCEaseSineInOut actionWithAction:[[move copy] autorelease]];
    id rotate_rev = [move_rotate_ease reverse];
	id move_ease_back = [CCMoveBy actionWithDuration:0.3f position:ccp(-2.5f, +3*(kSCALEVALY))];//[move_ease reverse];
   // id delay = [CCDelayTime actionWithDuration:0.3f];
    
	id seq1 = [CCSequence actions: move_ease, move_ease_back, nil];
    id seq2 = [CCSequence actions:move_rotate_ease,rotate_rev, nil];
    
    [[spritesBgNode getChildByTag:s_birdhead] runAction:[CCRepeatForever actionWithAction:   seq1]];
    [[spritesBgNode getChildByTag:s_birdhead] runAction:[CCRepeatForever actionWithAction:   seq2]];
    
    return;
    id actionSequenceRotate =      [CCSequence actions:
                                   [CCMoveBy actionWithDuration:0.25f position:ccp(-1, -1)],
                                   [CCDelayTime actionWithDuration:3.f],
                                   [CCMoveBy actionWithDuration:0.25f position:ccp(1, 1)],
                                   [CCDelayTime actionWithDuration:3.f],nil];

    [[spritesBgNode getChildByTag:s_birdhead] runAction:[CCRepeatForever actionWithAction:   actionSequenceRotate]];
    
}

-(void)addTrunkAnimation{
    
    [spritesBgNode getChildByTag:s_trunk].position = ccp([spritesBgNode getChildByTag:s_trunk].position.x,
                                                         [spritesBgNode getChildByTag:s_trunk].position.y+([spritesBgNode getChildByTag:s_trunk].boundingBox.size.height/2));
    
    [spritesBgNode getChildByTag:s_trunk].anchorPoint = ccp(0.5f,1);
    [spritesBgNode getChildByTag:s_trunk].rotation = 1;
    
    id move = [CCRotateBy actionWithDuration:1 angle:4];
	//id move_back = [move reverse];
	id move_ease = [CCEaseSineInOut actionWithAction:[[move copy] autorelease]];
	id move_ease_back = [move_ease reverse];
    
	id seq1 = [CCSequence actions: move_ease, move_ease_back, nil];
    [[spritesBgNode getChildByTag:s_trunk] runAction:[CCRepeatForever actionWithAction:   seq1]];

}

-(void)addPlaustasAction{
    
    CGSize s = [spritesBgNode getChildByTag:s_plaustas].boundingBox.size;
    
    id actionSequenceMove =    [CCSequence actions:
                           [CCMoveBy actionWithDuration:10.f position:ccp(s.width/4.5f,-s.height/20)],
                           [CCMoveBy actionWithDuration:10.f position:ccp(-s.width/4.5f,s.height/20)],nil];
                            
    [[spritesBgNode getChildByTag:s_plaustas] runAction:[CCRepeatForever actionWithAction:   actionSequenceMove]];
    
    id actionSequenceRotate =    [CCSequence actions:
                                 [CCRotateBy actionWithDuration:8 angle:3],
                                 [CCRotateBy actionWithDuration:8 angle:-3],nil];


    id move = [CCMoveBy actionWithDuration:1 position:ccp(0,3)];
	//id move_back = [move reverse];
	id move_ease = [CCEaseSineInOut actionWithAction:[[move copy] autorelease]];
	id move_ease_back = [move_ease reverse];
    
	id seq1 = [CCSequence actions: move_ease, move_ease_back, nil];
    id spawn = [CCSpawn actions:seq1,actionSequenceRotate, nil];
    
   // [[spritesBgNode getChildByTag:s_plaustas] runAction:[CCRepeatForever actionWithAction:   spawn]];
    
   [[spritesBgNode getChildByTag:s_plaustas] runAction:[CCRepeatForever actionWithAction:   seq1]];

}

-(void)addTwoEyesInHoleBlink{
    
    for (int x = s_blinkEyestop; x < s_blinkEyestop+2; x++)
    {
        CCSprite *blackBoard = [[[CCSprite alloc]init]autorelease];
        
        if (x==s_blinkEyestop)
        {
            float h =  (IS_IPAD) ? 13.5f : 8.f;
            float posXfix = (IS_IPHONE_5) ? 77.5f : 0.f;
            [blackBoard setTextureRect:CGRectMake(0, 0, h,h*0.725f)];
             blackBoard.position = ccp(777*(kSCALEVALX), 420*(kSCALEVALY));
            if (IS_IPHONE_5)
            {
                blackBoard.position = ccp(777*(kSCALEVALX)-(posXfix), 420*(kSCALEVALY));
            }
        }
        
        else if (x==s_blinkEyesbottom)
        {
            float w =  (IS_IPAD) ? 14.25f :7.5f;
            float h =  (IS_IPAD) ? w*0.775f :6.f;
            float posXfix = (IS_IPHONE_5) ? 80.f : 0.f;
            [blackBoard setTextureRect:CGRectMake(0, 0, w,h)];
            blackBoard.position = ccp(789.5f*(kSCALEVALX),   251.5f*(kSCALEVALY));
            if (IS_IPHONE_5)
            {
                blackBoard.position = ccp(789.5f*(kSCALEVALX)-(posXfix), 251.5f*(kSCALEVALY));
            }
        }
        
        blackBoard.anchorPoint = ccp(0.5f, 0.5f);
        [self addChild:blackBoard z:0 tag:x];
        blackBoard.color = ccc3(10, 10, 10);
    }
    
    [self CCBlink0:0.4f blinks:2 delay:2 delay:2 delay:2 who:s_blinkEyestop];
    [self CCBlink0:0.5f blinks:2 delay:2 delay:2 delay:1 who:s_blinkEyesbottom];

}

-(void)CCBlink0:(float)duration blinks:(int)times delay:(int)first delay:(int)second delay:(int)third who:(int)tag{
    
    CCBlink *action1=[CCBlink actionWithDuration:duration       blinks:times];
    id actionSequence =    [CCSequence actions:
                           [CCDelayTime actionWithDuration: first],     action1,
                           [CCDelayTime actionWithDuration:second],     action1,
                           [CCDelayTime actionWithDuration: third],        nil];
    id repeatforever =     [CCRepeatForever actionWithAction:   actionSequence];
    
   [[self getChildByTag:tag]          runAction:repeatforever];
    
}

-(void)AddAnimations{
    
    
    
}

-(void)addSprites{
    
    
    
    NSString *spritesStr =      [NSString stringWithFormat:@"sprites_level1_iPhone"];
    if (IS_IPAD) spritesStr =   [NSString stringWithFormat:@"sprites_level1"];
    
    spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz",spritesStr]];
    [self addChild:spritesBgNode z:2];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache]
     addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist",spritesStr]];
    
    NSArray *positionsArray = [NSArray arrayWithArray:[self getDelautPositionsInteractiveItems]];
    
    NSArray *items = [NSArray arrayWithObjects:     @"birdhead.png",        //0
                                                    @"brains.png",          //1
                                                    @"hand0.png",           //2
                                                    @"hand1.png",           //3
                                                    @"hat.png",             //4
                                                    @"head.png",            //5
                                                    @"legs.png",            //6
                                                    @"plaustas.png",        //7
                                                    @"trunk.png",           //8
                                                    @"tshirt.png",nil];     //9
    
    for (int x  = 0; x < [items count]; x++) {
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:[items objectAtIndex:x]];
        sprite.tag = x;
        sprite.position = [[positionsArray objectAtIndex:x]CGPointValue];
        [spritesBgNode addChild:sprite];
        
        sprite.scale = kSCALE_FACTOR_FIX;

        if (sprite.tag == s_hand1 || sprite.tag == s_hand0)
        {
            sprite.anchorPoint = ccp(0.5f, 1.f);
            sprite.position = ccpAdd(sprite.position, ccp(0, sprite.boundingBox.size.height/2));
        }
        
        if (x == 1 || x == 2 || x==3 || x==4 || x == 5 || x == 6 || x == 9)
        {
            CCParticleSystemQuad *effect = [CCParticleSystemQuad particleWithFile:[NSString stringWithFormat: @"fallow_effect.plist"/*,kDevice*/]];
            effect.position = sprite.position;
            if (IS_IPHONE || IS_IPHONE_5) {effect.scale = 0.4f;}
            else{
                effect.scale = 0.7f;}
            effect.autoRemoveOnFinish = YES;
            [self addChild:effect z:1];
            effect.tag = 100+x;
            effect.visible = NO;
            effect.autoRemoveOnFinish = YES;
        }
   
            
    }
 
}

-(void)particleFallow:(ccTime)dt{
    
    if (fallowEffect!=999)
    
    {

        
        [self getChildByTag:fallowEffect+100].position
    = [spritesBgNode getChildByTag:fallowEffect].position;
    }
    
    //[self getChildByTag:100+6].position =  [spritesBgNode getChildByTag:6].position;
    
}

-(CGRect)getItemRect:(int)x{
    
    float rectOffsetW = [[self getChildByTag:x]boundingBox].size.width;
    float rectOffsetH = [[self getChildByTag:x]boundingBox].size.height;
    
    
    CGRect itemBoundingBox = [[self getChildByTag:x] boundingBox];
    
    CGRect itemRect = CGRectMake(itemBoundingBox.origin.x-rectOffsetW/2, itemBoundingBox.origin.y-rectOffsetH/2,
                                 itemBoundingBox.size.width+rectOffsetW, itemBoundingBox.size.height+rectOffsetH);
    
    return itemRect;
}
- (BOOL) rect:(CGRect) rect collisionWithRect:(CGRect) rectTwo
{
    float rect_x1 = rect.origin.x;
    float rect_x2 = rect_x1+rect.size.width;
    
    float rect_y1 = rect.origin.y;
    float rect_y2 = rect_y1+rect.size.height;
    
    float rect2_x1 = rectTwo.origin.x;
    float rect2_x2 = rect2_x1+rectTwo.size.width;
    
    float rect2_y1 = rectTwo.origin.y;
    float rect2_y2 = rect2_y1+rectTwo.size.height;
    
    if((rect_x2 > rect2_x1 && rect_x1 < rect2_x2) &&(rect_y2 > rect2_y1 && rect_y1 < rect2_y2))
        return YES;
    
    return NO;
}

-(void)checkBrainWithWoodTick:(ccTime)dt{
    
//    NSLog(@"%f %f",[self getChildByTag:BONUS1].position.x,[self getChildByTag:BONUS1].position.y);
//     NSLog(@"%f %f",[spritesBgNode getChildByTag:s_trunk].position.x,[spritesBgNode getChildByTag:s_trunk].position.y);


//    if (brainOnWood) {
//        [self getChildByTag:BONUS1].rotation = [spritesBgNode getChildByTag:s_trunk].rotation;
//        [self getChildByTag:BONUS1].position=ccpAdd([spritesBgNode getChildByTag:s_trunk].position,whereTouch);
//       // NSLog(@"brain loc touch : %f %f",[spritesBgNode getChildByTag:s_trunk].position.x,[spritesBgNode getChildByTag:s_trunk].position.y);
//        return;
//    }
    
    CGRect wood = [spritesBgNode getChildByTag:s_trunk].boundingBox;
    wood.size.height = wood.size.height/2;
    
    if ([self rect:[self getChildByTag:BONUS1].boundingBox collisionWithRect:wood])
    {
       // NSLog(@"trunk");
        [self unschedule:@selector(checkBrainWithWoodTick:)];
        //   [self getChildByTag:BONUS1].position = [spritesBgNode getChildByTag:s_trunk].position;
            [[self getChildByTag:BONUS1] stopAllActions];
        
        //    BrainsBonus *brain = (BrainsBonus*)[self getChildByTag:BONUS1];
        
            id jump = [CCJumpBy actionWithDuration:0.5f position:ccp(-kWidthScreen*0.05f, -(kHeightScreen*0.25f)) height:kHeightScreen*0.05f jumps:1];
            id ease = [CCEaseIn actionWithAction:jump rate:3.f];
            id scale = [CCScaleTo actionWithDuration:0.1f scaleX:1.f scaleY:1.f];
            id scale_ = [CCScaleTo actionWithDuration:0.1f scale:1];
            id spawn = [CCSpawn actions:ease,scale, nil];
            id seq = [CCSequence actions:spawn,scale_, nil];
        
            id action = [CCEaseElastic actionWithAction:seq];
        
            [[self getChildByTag:BONUS1] runAction:action];
        
//        CCSprite *blackBoard = [[[CCSprite alloc]init]autorelease];
//        
//        [blackBoard setTextureRect:wood];
//        blackBoard.position = ccp(wood.origin.x+(wood.size.width/2), wood.origin.y+wood.size.height*0.6f);
//        [self addChild:blackBoard z:0 tag:5];
//        blackBoard.color = ccRED;
//        blackBoard.opacity = 150;
        
        //
        brainOnWood = YES;
        
        whereTouch=ccpSub([self getChildByTag:BONUS1].position, [spritesBgNode getChildByTag:s_trunk].position);
   //     NSLog(@"where touch : %f %f",whereTouch.x,whereTouch.y);
        
    }
    
//        if (CGRectContainsRect([self getChildByTag:BONUS1].boundingBox, [spritesBgNode getChildByTag:s_trunk].boundingBox))
//        {
//        NSLog(@"trunk");
//
//        [self getChildByTag:BONUS1].position = [spritesBgNode getChildByTag:s_trunk].position;
//        [self getChildByTag:BONUS1].rotation = [spritesBgNode getChildByTag:s_trunk].rotation;
//        
//        
//    }
    
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    
    CGPoint location = [touch locationInView:[touch view]];
    
//    //TEST ONLY
//    [_hud WINLevel];
    
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    for (int x = 0; x < 11  ; x++)
    {
        //**** touched on objects
        int resizeTimes = (IS_IPHONE) ? 2 : 2;
        if (CGRectContainsPoint( [self ifTouchedONSIZEDRECT:[spritesBgNode getChildByTag:x] resizedTimes:resizeTimes], location))
        {
            
            [self tutorialSuccess:TUT_JOEHEAD];
            
            if (x == s_birdhead || x==s_plaustas || x==s_trunk) {   //could
                break;
            }
            
            [AUDIO playEffect:l1_itemclick];
            
            [self moveBodyPartByTagToFILLCHAR:x];
            
//            if (x == 5) {   // joe head
//                [self tutorialSuccess:TUT_JOEHEAD];
//            }
        }
    }
    
    if (CGRectContainsPoint( [self ifTouchedONSIZEDRECT:[self getChildByTag:BONUS1] resizedTimes:3], location)
        ||
        CGRectContainsPoint([self ifTouchedONSIZEDRECT:[spritesBgNode getChildByTag:s_birdhead] resizedTimes:3], location))
    {
     //   NSLog(@"touched on BIRD");
     //   bonus1_touched++;
        
         [self tutorialSuccess:TUT_BIRD];
        
        if (!birdBrain)
        {
            birdBrain = YES;
            [AUDIO playEffect:l1_bird_tapped];
          //  NSLog(@"show bonus");
            CCSprite    *brain = (CCSprite*)[self getChildByTag:BONUS1];
            brain.visible = YES;
          //  brain.brain.opacity = 255;
            brain.scale = 1;
            
            [cfg makeBrainActionForNode:brain
                         fakeBrainsNode:nil direction:357.5f
                           pixelsToMove:kWidthScreen*0.55f time:1.5f parent:self
                      removeBrainsAfter:YES makeActionAfterall:@selector(increaseBRAINSNUMBER)
                                 target:_hud];
           
        }
        

    }
    if (CGRectContainsPoint([self ifTouchedONSIZEDRECT:[self getChildByTag:BONUS2] resizedTimes:3], location) && !brainLeft)
    {
     //   NSLog(@"bonus 2");
      //  [self collectedBonus:[self getChildByTag:BONUS2]];
        [cfg makeBrainActionForNode:[self getChildByTag:BONUS2]
                     fakeBrainsNode:nil direction:270
                       pixelsToMove:kWidthScreen*0.3f time:1.f parent:self
                  removeBrainsAfter:YES makeActionAfterall:@selector(increaseBRAINSNUMBER)
                             target:_hud];
        brainLeft = YES;
        [AUDIO playEffect:l1_itemclick];
    }
    
    if (CGRectContainsPoint([self ifTouchedONSIZEDRECT:[self getChildByTag:BONUS3] resizedTimes:3], location) && !brainRIght)
    {
    //    NSLog(@"bonus 3");
        //  [self collectedBonus:[self getChildByTag:BONUS2]];
        [cfg makeBrainActionForNode:[self getChildByTag:BONUS3]
                     fakeBrainsNode:nil direction:320
                       pixelsToMove:kWidthScreen*0.85f time:1.f parent:self
                  removeBrainsAfter:YES makeActionAfterall:@selector(increaseBRAINSNUMBER)
                             target:_hud];
        brainRIght = YES;
        [AUDIO playEffect:l1_itemclick];
    }
    
    return NO;
    
}

-(CGRect)ifTouchedONSIZEDRECT:(CCNode*)node_ resizedTimes:(int)times{
    
    CGRect f = [node_ boundingBox];
    f.size.width = f.size.width*times;
    f.size.height = f.size.height*times;
    f.origin.x = f.origin.x - f.size.width/2;
    f.origin.y = f.origin.y - f.size.height/2;
    return f;
    
}

-(void)startMoving{
    
    BrainsBonus *brain = (BrainsBonus*)[self getChildByTag:BONUS1];
    brain.scale = 1;
    [brain moveUpDown_particles:NO];
    
}

-(void)collectedBonus:(CCNode*)brain_{
    
   // [brain_ removeAllChildrenWithCleanup:YES];
    
   // [_hud increaseBRAINSNUMBER];
    
}

-(NSArray*)getDelautPositionsInteractiveItems{
    
    if (IS_IPHONE_5) {
        NSArray *points = [NSArray arrayWithObjects:
           [NSValue valueWithCGPoint:CGPointMake(282.f*(kSCALEVALX),           640*(kSCALEVALY))],          //birdhead
           [NSValue valueWithCGPoint:CGPointMake(220.f*(kSCALEVALX),           179.5f*(kSCALEVALY))],       //brains
           [NSValue valueWithCGPoint:CGPointMake(683.f*(kSCALEVALX)-(65),             461*(kSCALEVALY))],     //hand 0
           [NSValue valueWithCGPoint:CGPointMake(625.f*(kSCALEVALX)-(55),             464*(kSCALEVALY))],     //hand 1
           [NSValue valueWithCGPoint:CGPointMake(93*(kSCALEVALX)+30,              355*(kSCALEVALY))],          //hat
           [NSValue valueWithCGPoint:CGPointMake(530*(kSCALEVALX)-37,             235*(kSCALEVALY))],          //head
           [NSValue valueWithCGPoint:CGPointMake(975*(kSCALEVALX)-90,             205*(kSCALEVALY))],          //legs
           [NSValue valueWithCGPoint:CGPointMake(750*(kSCALEVALX)-80,             10*(kSCALEVALY))],    //plaustas
           [NSValue valueWithCGPoint:CGPointMake(280*(kSCALEVALX),             460*(kSCALEVALY)+2.25f)],     //trunk
           [NSValue valueWithCGPoint:CGPointMake(905*(kSCALEVALX)-100,             400*(kSCALEVALY))],   //tshirt
           nil];
        return points;
    }
    
    NSArray *points = [NSArray arrayWithObjects:
        [NSValue valueWithCGPoint:CGPointMake(283.f*(kSCALEVALX),           640*(kSCALEVALY))],          //birdhead
        [NSValue valueWithCGPoint:CGPointMake(220.f*(kSCALEVALX),           179.5f*(kSCALEVALY))],       //brains
        [NSValue valueWithCGPoint:CGPointMake(683.f*(kSCALEVALX),             461*(kSCALEVALY))],     //hand 0
        [NSValue valueWithCGPoint:CGPointMake(625.f*(kSCALEVALX),             464*(kSCALEVALY))],     //hand 1
        [NSValue valueWithCGPoint:CGPointMake(93*(kSCALEVALX),              355*(kSCALEVALY))],          //hat
        [NSValue valueWithCGPoint:CGPointMake(530*(kSCALEVALX),             235*(kSCALEVALY))],          //head
        [NSValue valueWithCGPoint:CGPointMake(975*(kSCALEVALX),             205*(kSCALEVALY))],          //legs
        [NSValue valueWithCGPoint:CGPointMake(750*(kSCALEVALX),             10*(kSCALEVALY))],    //plaustas
        [NSValue valueWithCGPoint:CGPointMake(280*(kSCALEVALX),             460*(kSCALEVALY)+2.25f)],     //trunk
        [NSValue valueWithCGPoint:CGPointMake(905*(kSCALEVALX),             400*(kSCALEVALY))],   //tshirt
                      nil];
    
    // CGPoint pos = [[points objectAtIndex:id_]CGPointValue];
    return points;
}


- (void)onEnter{
    
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [super onEnter];
    
}

- (void)onExit
{
    
    [self removeAllChildrenWithCleanup:YES];
    
    [[CCTouchDispatcher sharedDispatcher]removeDelegate:self];
    
  //  [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    
   // [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    [super onExit];
    
}

- (void) dealloc
{

	[super dealloc];
}

@end
