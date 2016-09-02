
#import "Level5.h"
#import "cfg.h"
#import "Constants.h"
#import "constants_l5.h"
#import "BrainsBonus.h"
#import "SoundManager.h"    
#import "Tutorial.h"

@implementation Level5
//@synthesize CHARACTER_GO;

#define kJOE_Z 10
#define kSPYGLIAI 9
#define kSPYGLS_TAG 887
#define SLIDERS_Z 9

#define BRAIN_BONUS_TAGMINUS1 ((TAG_BRAIN_1)-(1))

#pragma mark DELEGATE METHODS

-(id)getNode{
    
    return [Level5 node];
    
}

-(void)gameStateEnded{
    
   // NSLog(@"level passed");
    
}

-(void)MANA_ON{
    
   // NSLog(@"Level 5 MANA ON");
    
    for (SliderPart *s in [self children])
    {
        if ([s isKindOfClass:[SliderPart class]]) {
            [s MANA_ON];
        }
    }
    
}

-(void)MANA_OFF{
    
    for (SliderPart *s in [self children])
    {
        if ([s isKindOfClass:[SliderPart class]]) {
            [s MANA_OFF];
        }
    }
    
}

- (id)initWithHUD:(InGameButtons *)hud
{
	if( (self=[super init])) {
        _hud = hud;
        
        self.isTouchEnabled = YES;

        [self addBottom];
        
        ONTRACK = col0;
        ONTRACK_Y = 0;
        
        [cfg addBG_forNode:self withCCZ:@"BG_level5" bg:@"background.jpg"];
        
        [_hud preloadBlast_self:self brainNr:3 parent:self];
        
       // [self addSprites];  //may delete later 
        [self addBGSliders];
        [self charactertBorn];
        

       [self addSpygls];

        alive = YES;
        trapped = NO;
        
        [self addBrainForSPygls];
        
       
        
        [self scheduleUpdate];//schedule:@selector(update:)];
        
        
        if (_hud.tutorialSHOW)
        {
            PAUSED = YES;
            [self schedule:@selector(GAME_PAUSE) interval:0.1f];
        }
        
    [cfg runSelectorTarget:self
                  selector:@selector(checkForTutorialInit)
                    object:nil
                afterDelay:0.15f sender:self];
    
    
	}
	return self;
}

-(void)checkForTutorialInit{
    
    if (![Combinations checkNSDEFAULTS_Bool_ForKey:C_TUTORIAL_([_hud level])])
    {
        savetut = YES;
        [cfg runSelectorTarget:self selector:@selector(showTut_5)
                        object:nil afterDelay:0.2f sender:self];
    }
    
}

-(void)showTut_5
{
    Tutorial*tut = [[[Tutorial alloc]init]autorelease];
    [_hud addChild:tut z:0 tag:3344];
    tut.position = ccp([self getChildByTag:col1].position.x, kHeightScreen/2);
    //ccp(kWidthScreen/5, kHeightScreen/2);
    [tut SWIPE_TutorialWithDirection:SWIPE_DOWN times:1 delay:0.5f runAfterDelay:0.2f];
    [cfg runSelectorTarget:self selector:@selector(showTUt_5_2) object:nil afterDelay:2.f sender:self];
    
    
}
-(void)showTUt_5_2
{
    if ([_hud getChildByTag:3344]) {
        [[_hud getChildByTag:3344]removeFromParentAndCleanup:YES];
    }
    Tutorial *tut = [[[Tutorial alloc]init]autorelease];
    [_hud addChild:tut z:0 tag:3345];
    tut.position = ccp([self getChildByTag:col1].position.x, kHeightScreen/2);
    //ccp(kWidthScreen/5, kHeightScreen/2);
    [tut SWIPE_TutorialWithDirection:SWIPE_UP times:1 delay:0.5f runAfterDelay:0.5f];
    
}


-(void)rockSlide:(ccTime)dt{
    
    [AUDIO playEffect:l8_rockSlide];
    
}

-(void)GAME_RESUME{
    
    PAUSED = NO;

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
    
   // NSLog(@"PAUSE");
    
    if (PAUSED) {
        return;
    }
    
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

-(void)addBrainForSPygls{
    
    {
  //  BrainsBonus *BRAIN = [[BrainsBonus alloc]initWithRect:CGRectMake(0, 0, 100, 100)];
   // [self addChild:BRAIN z:30 tag:BRAIN_BONUS_TAGMINUS1+1];
    CCSprite *BRAIN =(CCSprite*)[self getChildByTag:BRAIN_BONUS_TAGMINUS1+1];
        [_hud BRAIN_:TAG_BRAIN_1 zOrder:10 parent:self];
     //    [self reorderChild:TAG_BRAIN_1 z:10];
    BRAIN.position = ccp(kWidthScreen*0.25f, kHeightScreen*0.9f);
   // [BRAIN moveUpDown_particles:NO];
    }
    
    {
  //  BrainsBonus *BRAIN = [[BrainsBonus alloc]initWithRect:CGRectMake(0, 0, 100, 100)];
    CCSprite *BRAIN =(CCSprite*)[self getChildByTag:BRAIN_BONUS_TAGMINUS1+2];
    BRAIN.position = ccp(kWidthScreen*0.45f, kHeightScreen*0.1f);
    [_hud BRAIN_:TAG_BRAIN_2 zOrder:10 parent:self];
        //  [BRAIN moveUpDown_particles:NO];
    }
    {
        //  BrainsBonus *BRAIN = [[BrainsBonus alloc]initWithRect:CGRectMake(0, 0, 100, 100)];
        CCSprite *BRAIN =(CCSprite*)[self getChildByTag:BRAIN_BONUS_TAGMINUS1+3];
        if (IS_IPAD) BRAIN.position = ccp(kWidthScreen*0.75f, kHeightScreen*0.8f);
        else BRAIN.position = ccp(kWidthScreen*0.75f, kHeightScreen*0.9f);
        [_hud BRAIN_:TAG_BRAIN_3 zOrder:10 parent:self];
        //  [BRAIN moveUpDown_particles:NO];
    }
    
}

-(void)addSpygls{
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    
    NSString *spritesStr =      [NSString stringWithFormat:@"Spikes_l5_iPhone"];
    if (IS_IPAD) spritesStr =   [NSString stringWithFormat:@"Spikes_l5"];
    
    spyglsBatch = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz",spritesStr]];
    [self addChild:spyglsBatch z:kSPYGLIAI];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache]
     addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist",spritesStr]];
    
    //NSString *name = (IS_IPAD) ? @"spikes.png" : @"spikes_iPhone.png";
    
    int nrOfSpygls = (IS_IPAD) ? 2: 2;
    
    //BOTTOM
    
    if (IS_IPAD)
    {
        for (int x = 0; x < nrOfSpygls; x++)
        {
            CCSprite *spike = [CCSprite spriteWithSpriteFrameName:@"spikes.png"];
            [spyglsBatch addChild:spike z:kSPYGLIAI];
            spike.flipY = YES;
            if (x==0) {
                spike.anchorPoint = ccp(1, 0);
                spike.position = ccp(kWidthScreen/2,0);
            }
            if (x==1) {
                spike.anchorPoint = ccp(0, 0);
                spike.position = ccp(kWidthScreen/2,0);
            }
            
            spike.tag = kSPYGLS_TAG;
        }
        
        //TOP
        for (int x = 0; x < nrOfSpygls; x++)
        {
            CCSprite *spike = [CCSprite spriteWithSpriteFrameName:@"spikes.png"];
            [spyglsBatch addChild:spike z:kSPYGLIAI];
            if (x==0) {
                spike.anchorPoint = ccp(1, 1);
                spike.position = ccp(kWidthScreen/2,kHeightScreen);
            }
            if (x==1) {
                spike.anchorPoint = ccp(0, 1);
                spike.position = ccp(kWidthScreen/2,kHeightScreen);
            }
            spike.tag = kSPYGLS_TAG;
        }
    }
    
    else if (IS_IPHONE){
        
        for (int x = 0; x < nrOfSpygls; x++)
        {
            CCSprite *spike = [CCSprite spriteWithSpriteFrameName:@"spikes_iphone.png"];
            
            [spyglsBatch addChild:spike z:kSPYGLIAI];
            
            if (x==0)
            {
                spike.anchorPoint = ccp(0.5f, 0);
                spike.position = ccp(kWidthScreen/2,0);
                spike.flipY = YES;
            }
            
            else if (x==1)
            {
                spike.anchorPoint = ccp(0.5f, 1);
                spike.position = ccp(kWidthScreen/2,kHeightScreen);
            }
            spike.tag = kSPYGLS_TAG;
        }
        
    }
 	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
}

-(void)addlava{
    
    CCSprite * lava = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"lavalight.png"]];
    lava.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    //sprite.opacity = 100;
    lava.scale = 2;
    [spritesBgNode addChild:lava];
    
    id fadeOut =  [CCFadeOut actionWithDuration:1];
    id fadeIn = [fadeOut reverse];
    
    [lava runAction:[CCRepeatForever actionWithAction:[CCSequence actions:fadeIn,fadeOut, nil]]];
    
}

-(void)addBottom{
    
    CCSprite *bottom = [[[CCSprite alloc]init]autorelease];
    
    [bottom setTextureRect:CGRectMake(0, 0, ScreenSize.width,
                                            ScreenSize.height)];
    bottom.position = ccp(ScreenSize.width/2,ScreenSize.height/2);
    bottom.anchorPoint = ccp(0.5f, 0.5f);
    [self addChild:bottom z:0 tag:kBottom];
    bottom.color = ccGREEN;
    
}

-(void)charactertBorn{
    
    CHARACTER_GO = [[GoinCharacter alloc]initWithRect:CGRectMake(10, 0,
                                         characterW, characterH) tag:kCHARACTERTAG];
    
    [self addChild:CHARACTER_GO z:kJOE_Z];
    
    CHARACTER_GO.position =ccp([self getChildByTag:col0].position.x-(characterW),
                               [self getChildByTag:col0].position.y);
    if (IS_IPHONE)
    {
        CHARACTER_GO.position =ccp([self getChildByTag:col0].position.x-(characterW),
                                   [self getChildByTag:col0].position.y+(characterH/2));
    }
    else if (IS_IPHONE_5) {
        
        CHARACTER_GO.position =ccp([self getChildByTag:col0].position.x+(characterW),
                                   [self getChildByTag:col0].position.y+(characterH/2));
        
    }
    
    [CHARACTER_GO Action_WALK_SetDelay:0.15f funForever:YES];
    [CHARACTER_GO ramaMove];
    
}

-(void)addSprites{
    
    NSString *spritesStr =      [NSString stringWithFormat:@"sprites_level5_iPhone"];
    if (IS_IPAD) spritesStr =   [NSString stringWithFormat:@"sprites_level5"];
    
    spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz",spritesStr]];
    [self addChild:spritesBgNode];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache]
     addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist",spritesStr]];

    
}

-(void)addBGSliders{

    

    
    float w = ((kWidthScreen)/(l5_nr_ofSliders));
    
    if (!IS_IPHONE_5)
    {
        for (int x = 0;  x < l5_nr_ofSliders; x++)
        {
            
            SliderPart *SL = [[[SliderPart alloc]initWithRect:
                              CGRectMake((x)*(w)+(w/2),
                                         ScreenSize.height/2,
                                         w,
                                         kSliderH)
                                                         tag:x+(col_Tag)]autorelease];
            [self addChild:SL z:SLIDERS_Z];
        }
    }
    
    
    ////
    else {  // IP5 only
        
        for (int x = 0;  x < l5_nr_ofSliders; x++)
        {
         float fix = 0;
            
            CGRect rect = CGRectMake((x)*(w)+(w/2)-fix,
                                     ScreenSize.height/2,
                                     w,
                                     kSliderH);
            
            if (x != 0 && x != 7)
            {
                fix = 7.3f;
                w= ((480)/(l5_nr_ofSliders));
                rect = CGRectMake((x)*(w)+(((kWidthScreen)/(l5_nr_ofSliders))*1.15f)-fix,
                                  ScreenSize.height/2,
                                  w,
                                  kSliderH);
            }
            if (x == 0) {
                rect = CGRectMake(75,
                                         ScreenSize.height/2,
                                         w,
                                         kSliderH);
            }
            if (x== 7){
                rect = CGRectMake((x)*(w)+(w/2)+40,
                                  ScreenSize.height/2,
                                  w,
                                  kSliderH);
                
            }

            
            SliderPart *SL = [[[SliderPart alloc]initWithRect:rect tag:x+(col_Tag)]autorelease];
            [self addChild:SL z:SLIDERS_Z];
        }
        
    }
    

 
}

-(CCSpriteBatchNode*)giveBatch{
    
    return spritesBgNode;
    
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

-(CGRect) positionRect: (CCSprite*)sprite {
	CGSize contentSize = [sprite contentSize];
	CGPoint contentPosition = [sprite position];
	CGRect result = CGRectOffset(CGRectMake(0, 0, contentSize.width, contentSize.height), contentPosition.x-contentSize.width/2, contentPosition.y-contentSize.height/2);
	return result;
}

-(void)dropSlider{
    
    
    
}

-(void)checkIfBrainCollected{
    
    if ([self rect:CHARACTER_GO.boundingBox collisionWithRect:[self getChildByTag:BRAIN_BONUS_TAGMINUS1+1].boundingBox] && !brainTOP)
    {
       // NSLog(@"brain !");
       // NSLog(@"BRAIN GOT");
      //  [[self getChildByTag:BRAIN_BONUS_TAGMINUS1+1] removeFromParentAndCleanup:YES];
        brainTOP = YES;
        [cfg makeBrainActionForNode:[self getChildByTag:BRAIN_BONUS_TAGMINUS1+1] fakeBrainsNode:nil direction:45 pixelsToMove:100 time:0.3f parent:self removeBrainsAfter:YES makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
       // [_hud increaseBRAINSNUMBER];
    }
    else if ([self rect:CHARACTER_GO.boundingBox collisionWithRect:[self getChildByTag:BRAIN_BONUS_TAGMINUS1+2].boundingBox] && !brainBOTOM)
    {
 //       NSLog(@"brain !");
   //     NSLog(@"BRAIN GOT");
        brainBOTOM   = YES;
             [cfg makeBrainActionForNode:[self getChildByTag:BRAIN_BONUS_TAGMINUS1+2] fakeBrainsNode:nil direction:180 pixelsToMove:100 time:0.3f parent:self removeBrainsAfter:YES makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
       // [[self getChildByTag:BRAIN_BONUS_TAGMINUS1+2] removeFromParentAndCleanup:YES];
      //  [_hud increaseBRAINSNUMBER];
    }
    
    if ([self rect:[self getChildByTag:BRAIN_BONUS_TAGMINUS1+3].boundingBox collisionWithRect:CHARACTER_GO.boundingBox] && !brainMIDDLE) {
        brainMIDDLE = YES;
        //   [sprite removeFromParentAndCleanup:YES];
        // [_hud increaseBRAINSNUMBER];
        [cfg makeBrainActionForNode:[self getChildByTag:BRAIN_BONUS_TAGMINUS1+3] fakeBrainsNode:nil direction:0 pixelsToMove:100 time:0.4f parent:self removeBrainsAfter:NO makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
    }
    

    
}

-(void)updateSlidersPositions{
    
    
    
}


-(void)update:(ccTime)dt{
    
  //  [self updateSlidersPositions];
    
    if (IS_IPHONE)
    [self getChildByTag:BRAIN_BONUS_TAGMINUS1+3].position = ccp([self getChildByTag:col_Tag+5].position.x,
                                                               [self getChildByTag:col_Tag+5].position.y+ kHeightScreen*0.25f);
    else [self getChildByTag:BRAIN_BONUS_TAGMINUS1+3].position = ccp([self getChildByTag:col_Tag+5].position.x,
                                                                     [self getChildByTag:col_Tag+5].position.y+ kHeightScreen*0.225f);
    
    PAUSED = NO;
    
    if (WIN) {
        
        CHARACTER_GO.position = ccpAdd(CHARACTER_GO.position, ccp(SPEED_BLUE, 0));
        return;
    }
    
    if (!alive) {
        return;
    }
    
    if (!trapped) {
        if ([self ifCHarOverBoard]) {
            return;
        }
    }
    
    
 
    
    [self checkIfBrainCollected];
    
    int slide = 0;
    
    float speedX = SPEED_LOW;
  //  float YPOS = CHARACTER_GO.position.y;
    
    if ([self rect:CHARACTER_GO.boundingBox collisionWithRect:[self getChildByTag:kBottom].boundingBox])
    {
        
       // NSLog(@"on the bottom");
        BOOL stick = NO;
     
        for (int x = col0; x < col7+1; x++) {
            
            float w_s = [self getChildByTag:x].boundingBox.size.width*1.1f;
            float h_s = [self getChildByTag:x].boundingBox.size.height/2;   //in col 5,6 smaller
            
            if (x==col5 || x==col6)
            {
                h_s = [self getChildByTag:x].boundingBox.size.height*0.45f;
            }
            
            CGRect stickBox = CGRectMake(
                                         [self getChildByTag:x].boundingBox.origin.x,
                                         [self getChildByTag:x].boundingBox.origin.y+(h_s/2),
                                         w_s,
                                         h_s
                                         
                                         );
            
         //    if ([self rect:CHARACTER_GO.boundingBox collisionWithRect:stickBox]) {
          //  if ([self rect:CHARACTER_GO.boundingBox collisionWithRect:[self getChildByTag:x].boundingBox])
             if (CGRectContainsPoint(stickBox, CHARACTER_GO.position)) {
                 slide = x;
                 stick = YES;
                
                if (x==col0) {
                    speedX = SPEED_YELLOW;
                
                    continue;
                }
                 if (x==col3 && savetut)
                 {
                          [Combinations saveNSDEFAULTS_Bool:YES forKey:C_TUTORIAL_([_hud level])];
                 }
                 
                 if (x==col7) {
                  //   NSLog(@"GAME PASSED PLATFORM !!!!");
                     [AUDIO playEffect:fx_winmusic];
                     WIN = YES;
                     [_hud TIME_Stop];
                     [_hud WINLevel];
                 }
                 
                 if (ONTRACK != x) {
                     whereTouch = ccpSub(CHARACTER_GO.position, [self getChildByTag:x].position);

                   //   NSLog(@"new platform");
                     
                     //MAKE BLOCK NOT TO MOVE WHEN JOE ON IT:
//                      SliderPart *block = (SliderPart*)[self getChildByTag:x];
//                      block.movable = NO;
                     
                  //   block.touching = YYS
                    

                     ONTRACK = x;
                 }
                
             //   NSLog(@"collided with stick nr :%i",x);
                
                BOOL kill = NO; //if on the platform - live ! just control the speed by the zone
                
                for (CCSprite *sprite in [[self getChildByTag:x] children])
                {
                    if (sprite.tag == SliderTrackAreaTagYELLOW    ||
                        sprite.tag==  SliderTrackAreaTagGREEN     ||
                        sprite.tag == SliderTrackAreaTagBLUE      ||
                        sprite.tag == SliderTrackAreaTagTRAP      ||
                        sprite.tag == BRAIN_BONUS_TAGMINUS1)
                    {
                        
           
                        
                        CGPoint loc =[[self getChildByTag:x] convertToWorldSpace:sprite.position];
                        float w = sprite.boundingBox.size.width*1.25f;
                        float h = sprite.boundingBox.size.height*1.25f;
                        CGRect trackBox = CGRectMake(loc.x-w/2,
                                                     loc.y-h/2,
                                                     w,
                                                     h);

                  //      if ([self rect:CHARACTER_GO.boundingBox collisionWithRect:trackBox])
                             if (CGRectContainsPoint(trackBox, CHARACTER_GO.position)) {
                        
                                 kill = NO;
                      //       NSLog(@"collided with sppeed track %i",sprite.tag);
                                speedX = [self calcSpeedByGroundType:sprite.tag];
                                 
                                 /*
                                 if (sprite.tag == BRAIN_BONUS_TAGMINUS1 && !brainMIDDLE)
                                 {
                                     NSLog(@"BRAIN GOT");
                                    // sprite.tag = 0;
                                     brainMIDDLE = YES;
                                  //   [sprite removeFromParentAndCleanup:YES];
                                    // [_hud increaseBRAINSNUMBER];
                                     [cfg makeBrainActionForNode:sprite fakeBrainsNode:nil direction:0 pixelsToMove:100 time:0.4f parent:self removeBrainsAfter:YES makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
                                   //  [sprite removeFromParentAndCleanup:YES];
                                 }
                                 */
                                 
                                 if (sprite.tag==SliderTrackAreaTagTRAP && !trapped)
                                 {
                                     SliderPart *block = (SliderPart*)[self getChildByTag:x];
                                     [block closeTRAP];
                                     [_hud Lost_STATE_AFTERDELAY:0.5f];//probably trapped
                                     [CHARACTER_GO.body stopAllActions];
                                  //    [self unschedule:@selector(update:)];
                                     [CHARACTER_GO stopAllActions];
                                     trapped = YES;
                                     
                                    [_hud makeBlastInPosposition:CHARACTER_GO.position];
                                    [CHARACTER_GO colorAllBodyPartsWithColor:ccc3(220, 72, 72) restore:YES restoreAfterDelay:0.15f];
                                     
                                 }
                            
                        }
                        
                    }
                    
                    
          
    
                }
                
                if (kill) {
                    
     
                    
                    alive = NO;
                }

            }
        }
        

 
        if (!stick && CHARACTER_GO.position.x < kWidthScreen) {   // if not on the platform - die anmation scale down to hole
            
          //  NSLog(@"STOP ! collision with hole");
            alive = NO;
            [AUDIO playEffect:l5_falldown];
            [CHARACTER_GO stopAllActions];
            [CHARACTER_GO inlavaAction];
            [self reorderChild:CHARACTER_GO z:SLIDERS_Z-1];
            [_hud Lost_STATE_AFTERDELAY:2.f];
            return;
        }

  
    }
    
    //set X pos
    if (trapped) {
        speedX = 0;
    }

    
    CGPoint velocity = CGPointMake(speedX,0);    // Move right
    
    CHARACTER_GO.position = ccpAdd(CHARACTER_GO.position, velocity);
    
    //set Y pos
    
    CGPoint newY = ccpAdd([self getChildByTag:slide].position, whereTouch);
    
    CHARACTER_GO.position = ccp(CHARACTER_GO.position.x, newY.y);
    

}

-(BOOL)ifCHarOverBoard{
    
    

    
    float max = kHeightScreen;
    
//    if (IS_IPAD)
//    {
//        max = kHeightScreen;
//    }
    
    if (CHARACTER_GO.position.y >= max) {
        
   //     NSLog(@"loose");
        alive = NO;
        
        [_hud makeBlastInPosposition:CHARACTER_GO.position];
        [CHARACTER_GO colorAllBodyPartsWithColor:ccc3(220, 72, 72) restore:YES restoreAfterDelay:0.15f];
        
        [CHARACTER_GO stopAllActions];
        [CHARACTER_GO.body stopAllActions];
        //   [CHARACTER_GO inlavaAction];
        [_hud Lost_STATE_AFTERDELAY:0.5f];
       // [self unscheduleUpdate];
        [self unschedule:@selector(update:)];
        return YES;
        
        // CHARACTER_GO.position = ccp(CHARACTER_GO.position.x, (kHeightScreen));
        
    }
    
    float max_ = 0;

    
    if (CHARACTER_GO.position.y <= max_) {
        
     //   NSLog(@"loose");
        alive = NO;
        [CHARACTER_GO stopAllActions];
        [CHARACTER_GO.body stopAllActions];
        [_hud Lost_STATE_AFTERDELAY:0.5f];
        
        [_hud makeBlastInPosposition:CHARACTER_GO.position];
        [CHARACTER_GO colorAllBodyPartsWithColor:ccc3(220, 72, 72) restore:YES restoreAfterDelay:0.15f];
        
        [self unschedule:@selector(update:)];
        return YES;
        //  CHARACTER_GO.position = ccp(CHARACTER_GO.position.x, 0);
        
    }
    
    return NO;
}

-(float)calcSpeedByGroundType:(int)ground_{
    
    float speed = 1/3;
    
    switch (ground_) {
        case SliderTrackAreaTagYELLOW:
            speed = SPEED_YELLOW;
            break;
        case SliderTrackAreaTagGREEN:
            speed = SPEED_GREEN;
            break;
        case SliderTrackAreaTagBLUE:
            speed = SPEED_BLUE;
            break;
        
            
        default:
            break;
    }
    
    return speed;
    
}

-(CGRect)getItemRect:(int)x{
    
    float rectOffsetW = [[self getChildByTag:x]boundingBox].size.width;
    float rectOffsetH = [[self getChildByTag:x]boundingBox].size.height;

    
    CGRect itemBoundingBox = [[self getChildByTag:x] boundingBox];
    
    CGRect itemRect = CGRectMake(itemBoundingBox.origin.x-rectOffsetW/2, itemBoundingBox.origin.y-rectOffsetH/2,
                                 itemBoundingBox.size.width+rectOffsetW, itemBoundingBox.size.height+rectOffsetH);
    
    return itemRect;
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{return NO;}
//    
//    CGPoint location = [touch locationInView:[touch view]];
//    
//    location = [[CCDirector sharedDirector] convertToGL:location];
//    
//    whereTouch=ccpSub(self.position, location);
//    
//    for (int x = 200; x < 208; x++){
//        
//        if (CGRectContainsPoint([self getChildByTag:x].boundingBox, location)){
//            tagTouched = x;
//            [[self getChildByTag:tagTouched]stopAllActions];
//          //  [self getChildByTag:x].position = ccp([self getChildByTag:x].position.x, location.y);
//        }
//    }
//    
//    return YES;
//    
//}
//
//-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
//    
//    CGPoint location = [touch locationInView:[touch view]];
//    
//    location = [[CCDirector sharedDirector] convertToGL:location];
//    
//    [self getChildByTag:tagTouched].position=ccpAdd(ccp([self getChildByTag:tagTouched].position.x, location.y),ccp(0, whereTouch.y));
//    
//}

- (void) dealloc
{
//    [CHARACTER_GO release];
//    CHARACTER_GO = nil;
	[super dealloc];
}

- (void)onEnter{
    
   [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-2 swallowsTouches:YES];
    [super onEnter];
}


- (void)onExit{
    
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [self removeAllChildrenWithCleanup:YES];
    [super onExit];
}

@end
