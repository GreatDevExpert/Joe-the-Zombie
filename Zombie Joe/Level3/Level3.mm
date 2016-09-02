
#import "Level3.h"
#import "cfg.h"
#import "SConfig.h"
#import "JOE_C.h"
#import "BrainsBonus.h"
#import "SimpleAudioEngine.h"
#import "Tutorial.h"


#define tut1 292929
#define tut2 333442

@implementation Level3

-(NSInteger)MyRandomIntegerBetween:(int)min :(int)max {
    //NSLog(@"RANDOME VALUE: %u",(arc4random() % (max-min+1)) + min );
    return ( (arc4random() % (max-min+1)) + min );
}

-(CCSprite*)spritename:(CCNode*)parent :(int)tag
{
    return (CCSprite *)[parent getChildByTag:tag];
}

-(int)posiotionYByTag:(int)tag
{
    return [self spritename:spritesBgNode :tag].contentSize.height;
}

-(int)posiotionXByTag:(int)tag
{
    colon = (CCSprite*)[spritesBgNode getChildByTag:tag];
    if (tag == 4) {
        if (IS_IPAD){return colon.position.x - colon.contentSize.width/1.2;}
        else{return colon.position.x - colon.contentSize.width/2.5;}
        }
    if (tag == 0) {
        if (IS_IPAD) {return colon.position.x + colon.contentSize.width/6;}
        else{return colon.position.x + colon.contentSize.width/8;}
    }
    return colon.position.x - colon.contentSize.width/3;
}

-(void)addBackground
{
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
    CCSpriteBatchNode *spritesBG = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"BG_Level3%@.pvr.ccz",kDevice]];
    [self addChild:spritesBG z:0];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"BG_Level3%@.plist",kDevice]];
    
    CCSprite*backgroundImage = [CCSprite spriteWithSpriteFrameName:@"background.jpg"];
    backgroundImage.position = ccp(kWidthScreen/2, kHeightScreen/2);
    [spritesBG addChild:backgroundImage z:0];
}

-(void)addColons
{
    int objectPositionX = 0;
        for (int i = 0; i <= 4; i++) {
            colon = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"kolona%i.png",i]];
            
            switch (i) {
                case 0:objectPositionX  = 0;
                    if(IS_IPHONE_5)colon.anchorPoint = ccp(0, 0);
                    if(IS_IPAD)colon.anchorPoint = ccp(0, 0);
                    if(IS_IPHONE)colon.anchorPoint = ccp(0.5f, 0);
                    break;
                case 1:objectPositionX  = kWidthScreen/3.6;colon.anchorPoint = ccp(0.5f, 0);break;
                case 2:objectPositionX  = kWidthScreen/2;colon.anchorPoint = ccp(0.5f, 0);break;
                case 3:objectPositionX  = (kWidthScreen/3.6)*2.6;colon.anchorPoint = ccp(0.5f, 0);break;
                case 4:objectPositionX  = kWidthScreen;
                    if(IS_IPHONE_5)colon.anchorPoint = ccp(1.f, 0);
                    if(IS_IPAD)colon.anchorPoint = ccp(0.8f, 0);
                    if(IS_IPHONE)colon.anchorPoint = ccp(0.5f, 0);
                    break;
                default:break;
            }
            colon.position = ccp(objectPositionX,0);
            [spritesBgNode addChild:colon z:2 tag:i];
        }
}

-(void)addExit
{
    if (!exitArrow) {
    
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"exit.png"];
        sprite.anchorPoint = ccp(1.f, 0.5f);
        sprite.opacity = 0;
        sprite.position = ccp(kWidthScreen - sprite.contentSize.width/4.f, kHeightScreen/2);
        [self addChild:sprite z:9999 tag:9999];
        [sprite runAction:[CCFadeTo actionWithDuration:0.3f opacity:255]];
        
        [sprite runAction:
         [CCRepeatForever actionWithAction:
          [CCSequence actions:
           [CCSpawn actions:
            [CCEaseIn actionWithAction:
             [CCMoveBy actionWithDuration:0.4f position:ccp(sprite.contentSize.width/4.f, 0)] rate:2],
            [CCEaseIn actionWithAction:
             [CCScaleTo actionWithDuration:0.4f scaleX:0.95f scaleY:1.05f] rate:2], nil],
           [CCSpawn actions:
            [CCEaseOut actionWithAction:
             [CCMoveBy actionWithDuration:0.4f position:ccp(-sprite.contentSize.width/4.f, 0)]rate:2],
            [CCEaseOut actionWithAction:
             [CCScaleTo actionWithDuration:0.4f scaleX:1.0f scaleY:1.0f] rate:2], nil], nil]]];
        exitArrow = true;
    }
}

-(void)addPlayer
{
//    playerImage = [CCSprite spriteWithFile:[NSString stringWithFormat:@"zombie%@.png",kDevice]];
//    playerImage.anchorPoint = ccp(0.f, 0.15f);
//    playerImage.scale = 0.8f;
//    playerImage.position = ccp(0, [self posiotionYByTag:0]);
//    [self addChild:playerImage z:2];
    
    CGRect rect;
    if (IS_IPAD) {rect = CGRectMake(0, 0, 175, 230);}else{rect = CGRectMake(0, 0, 100, 125);}
    
    //playerImage = [[[JOE_C alloc]initWithRect:rect tag:999]autorelease];
    playerImage = [[[JoeZombieController alloc]initWitPos:ccp(0, 0)
                                                     size:CGSizeMake(rect.size.width,rect.size.height)]autorelease];
    [self addChild:playerImage z:2 tag:999];
    
 //   [playerImage showMyBox];
    
    playerImage.scale = 0.4f;
    playerImage.position = ccp([self posiotionXByTag:0], [self posiotionYByTag:0]);
    playerImage.anchorPoint = ccp(0, 0.2f);
    [playerImage JOE_IDLE];
  //  [playerImage Action_IDLE_Setdelay:0.2f funForever:YES];
    
    
}
-(void)particles:(CCSprite*)sprite_
{
   
    CCParticleSystemQuad *effect = [CCParticleSystemQuad particleWithFile:[NSString stringWithFormat: @"fish_particles.plist"/*,kDevice*/]];
    effect.position = ccp(sprite_.position.x,-30);
    effect.scale = IS_IPAD ? 0.7f : 0.4f;
    [self addChild:effect z:0];
    effect.autoRemoveOnFinish = YES;
}

-(void)jumpingStyle:(CCSprite*)name
{
    CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    
    [name runAction:
     [CCRepeatForever actionWithAction:
      [CCAnimate actionWithAnimation:
       [CCAnimation animationWithFrames:
        [NSArray arrayWithObjects:
         [cache spriteFrameByName:[NSString stringWithFormat:@"fish0.png"]],
         [cache spriteFrameByName:[NSString stringWithFormat:@"fish1.png"]], nil] delay:0.2f] restoreOriginalFrame:NO]]];
    
    [name runAction:
     [CCRepeatForever actionWithAction:
      [CCSequence actions:
       [CCDelayTime actionWithDuration:0.4],
       [CCCallBlock actionWithBlock:^{
          [self particles:name];
          if (!soundFX) {
              [AUDIO playEffect:l6_fushSplash];
          }
          
      }],
       [CCSpawn actions:
        [CCJumpBy actionWithDuration:1 position:ccp(0, 0) height:kHeightScreen/1.2 jumps:1],
        [CCSequence actions:
         [CCDelayTime actionWithDuration:0.2],
         [CCRotateBy actionWithDuration:0.3 angle:angle], nil], nil],
       [CCCallFuncO actionWithTarget:self selector:@selector(particles:) object:name],
       [CCDelayTime actionWithDuration:0.3],
       [CCRotateBy actionWithDuration:0 angle:180], nil]]];
}

-(CCAction*)brainDropAnimation
{
    
    
    return [CCSequence actions:
            [CCDelayTime actionWithDuration:0.5f],
            [CCMoveTo actionWithDuration:0.5f position:ccp([self posiotionXByTag:0]+[self getChildByTag:TAG_BRAIN_1].contentSize.width/2, [self posiotionYByTag:0])],
            [CCMoveBy actionWithDuration:0.1f position:ccp(0, kHeightScreen*0.05f)],
            [CCMoveTo actionWithDuration:0.2f position:ccp([self posiotionXByTag:0]+[self getChildByTag:TAG_BRAIN_1].contentSize.width/2, [self posiotionYByTag:0])], nil];
}

-(void)addEnemy:(int)tag
{
    int objectPositionX = 0;
    if (tag == 1) {
        for (int i = 5; i <= 8; i++) {
            float a;
            switch (i) {
                case 5:objectPositionX += kWidthScreen/9*1.6;a = 1;break;
                case 6:objectPositionX += kWidthScreen/9*1.9;a = 1.3f;break;
                case 7:objectPositionX += kWidthScreen/9*2; a = 0.8f;break;
                case 8:objectPositionX += kWidthScreen/9*1.85; a = 0.5f;break;
                default:break;
            }
            CCSprite *enemyImage = [CCSprite spriteWithSpriteFrameName:@"fish0.png"];
            enemyImage.scale = 0.7f;
            enemyImage.position = ccp(objectPositionX,-enemyImage.contentSize.height);
            [spritesBgNode addChild:enemyImage z:3 tag:i];
            angle = 180;
            //float a = ((float)i /[self MyRandomIntegerBetween:[self MyRandomIntegerBetween:1 :4] :[self MyRandomIntegerBetween:3 :7]])/1.7;
            
            [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:a],[CCCallFuncO actionWithTarget:self selector:@selector(jumpingStyle:) object:enemyImage], nil]];
            
        }
    }
    else if(tag == 2)
    {
        for (int i = 15; i <= 18; i++) {
            float a;
            switch (i) {
                case 15:objectPositionX += kWidthScreen/9*1.55; a = 0.8; break;
                case 16:objectPositionX += kWidthScreen/9*1.95; a = 1.f;break;
                case 17:objectPositionX += kWidthScreen/9*2.05; a = 0.5f;break;
                case 18:objectPositionX += kWidthScreen/9*1.9; a = 0.3;break;
                default:break;
            }
            CCSprite *enemyImage = [CCSprite spriteWithSpriteFrameName:@"fish1.png"];
            enemyImage.scale = 0.8f;
            enemyImage.position = ccp(objectPositionX,-enemyImage.contentSize.height);
            [spritesBgNode addChild:enemyImage z:3 tag:i];
            angle = -180;
            //float a = ((float)i /[self MyRandomIntegerBetween:[self MyRandomIntegerBetween:1 :3] :[self MyRandomIntegerBetween:4 :7]])/2.1;
            
            [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:a],[CCCallFuncO actionWithTarget:self selector:@selector(jumpingStyle:) object:enemyImage], nil]];
            
        }
    }
}

-(void)birdGiveMeBrain
{
    
    
//    BrainsBonus* brain2 =  [[BrainsBonus alloc]initWithRect:CGRectMake(0, 0, 0, 0)];//[CCSprite spriteWithSpriteFrameName:@"brains.png"];
//    brain2.anchorPoint = ccp(0.2f,0.7f);
//    brain2.position = ccp(bird.position.x, bird.position.y - brain.contentSize.height);
//    [self addChild:brain2 z:0 tag:22];
    
    [self getChildByTag:TAG_BRAIN_3].position = ccp(bird.position.x, bird.position.y - brain.contentSize.height);
    
    CGPoint pos = ccp(bird.position.x+bird.contentSize.width/2+[self getChildByTag:TAG_BRAIN_1].contentSize.width/2,[self posiotionYByTag:4]);
    
    if (IS_IPHONE_5)
    {
        pos = ccpAdd(pos, ccp(10, 0));
    }
    
    [[self getChildByTag:TAG_BRAIN_3] runAction:[CCSequence actions:[CCMoveTo actionWithDuration:0.4f position:pos],
                       [CCMoveBy actionWithDuration:0.1f position:ccp(0, brain.contentSize.height)],
                       [CCMoveTo actionWithDuration:0.1f position:pos],[CCCallBlock actionWithBlock:^(void)
    {
                       [self reorderChild:[self getChildByTag:TAG_BRAIN_3] z:25];
        
                       }],nil]];
    
    //[brain moveUpDown];
    
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    if (!pause) {
 //   UITouch* touch = [touch anyObject];
    CGPoint touchPos = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
    x = touchPos.x;
    y = touchPos.y;
    if (CGRectContainsPoint(bird.boundingBox, touchPos))
    {
        CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [bird runAction:
         [CCAnimate actionWithAnimation:
          [CCAnimation animationWithFrames:
           [NSArray arrayWithObjects:
            [cache spriteFrameByName:[NSString stringWithFormat:@"bird1.png"]],nil]] restoreOriginalFrame:NO]];
        [AUDIO playEffect:l6_birdSound];
    
        if(!b_birdTap){
            [self birdGiveMeBrain];
            b_birdTap = true;
        }
        
        return YES;
    }
    if ([self getChildByTag:9999] && tagOfSprite == 4) {
        if (CGRectContainsPoint([[self getChildByTag:9999]boundingBox], touchPos))
        {
            if ([self getChildByTag:9999]) {
                [[self getChildByTag:9999] runAction:[CCFadeTo actionWithDuration:0.3f opacity:0]];}
         //   [playerImage Action_WALK_SetDelay:0.1f funForever:YES];
            [playerImage JOE_WALK];
            [playerImage runAction:
             [CCMoveBy actionWithDuration:13.f position:ccp(playerImage.contentSize.width*5, 0)]];
            
            [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.1f],[CCCallFuncO actionWithTarget:self  selector:@selector(unscheduleUpdate)], nil]];
            
            [_hud runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.2f],[CCCallFuncO actionWithTarget:_hud  selector:@selector(WINLevel)], nil]];
            soundFX = YES;
            [AUDIO playEffect:fx_winmusic];
            [AUDIO playEffect:l6_finishButton];
            
            [_hud TIME_Stop];
            return NO;
        }
    }

    }
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if (!pause) {
   // UITouch *touch = [touches anyObject];
    CGPoint touchPos = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
    CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [bird runAction:
     [CCAnimate actionWithAnimation:
      [CCAnimation animationWithFrames:
       [NSArray arrayWithObjects:
        [cache spriteFrameByName:[NSString stringWithFormat:@"bird0.png"]],nil]] restoreOriginalFrame:NO]];
    
    if (x+10 < touchPos.x && playerImage.numberOfRunningActions == 0)
    {m_state = STATE_JUMP;tagOfSprite++;
        [playerImage JOE_flipX:NO];
        
        if ([self getChildByTag:tut2]) {
            [self getChildByTag:tut2].visible = NO;
            [[self getChildByTag:tut2] removeFromParentAndCleanup:YES];
        }
        else if ([self getChildByTag:tut1]) {
            [self getChildByTag:tut1].visible = NO;
            [[self getChildByTag:tut1] removeFromParentAndCleanup:YES];
            Tutorial *tut2_ = [[[Tutorial alloc]init]autorelease];
            [self addChild:tut2_ z:10 tag:tut2];
            tut2_.position = ccp(kWidthScreen/2, kHeightScreen/2);
            [tut2_ SWIPE_TutorialWithDirection:SWIPE_RIGHT times:2 delay:0.5f runAfterDelay:1.f];
        }
       

     //   playerImage.body.flipX = NO;
      //  [playerImage Action_JUMP_Setdelay:0.1f funForever:NO];
       // [playerImage JOE_JUMP_FORLevel:6];
        if (tagOfSprite == 5)
        {
            [playerImage JOE_WALK];
        }
        else if (tagOfSprite == 6) {
            tagOfSprite = 5;
            [playerImage JOE_WALK];
        }
        
        else if (tagOfSprite < 5){  [playerImage JOE_JUMP_FORLevel:6];}
    }
        
    else if (x-10 > touchPos.x && playerImage.numberOfRunningActions == 0)
    {m_state = STATE_JUMP;tagOfSprite--;
        [playerImage JOE_JUMP_FORLevel:6];
        [playerImage JOE_flipX:YES];
        
        if ([self getChildByTag:tut1]) {
            [self getChildByTag:tut1].visible = NO;
            [[self getChildByTag:tut1] removeFromParentAndCleanup:YES];
        }
        else if ([self getChildByTag:tut2]) {
            [self getChildByTag:tut2].visible = NO;
            [[self getChildByTag:tut2] removeFromParentAndCleanup:YES];
        }
        
   //     [playerImage Action_JUMP_Setdelay:0.1f funForever:NO];
   //     playerImage.body.flipX = YES;
        if (tagOfSprite == -1) {
            tagOfSprite = 0;
        }}
    }
}
/*
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint touchPos = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
    x = touchPos.x;
    y = touchPos.y;
    if (CGRectContainsPoint(bird.boundingBox, touchPos))
    {
        CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [bird runAction:
         [CCAnimate actionWithAnimation:
          [CCAnimation animationWithFrames:
           [NSArray arrayWithObjects:
            [cache spriteFrameByName:[NSString stringWithFormat:@"bird1.png"]],nil]] restoreOriginalFrame:NO]];
        
        tapOfbird++;
        if (tapOfbird == 2) {
            [self birdGiveMeBrain];
        }
    }
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPos = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
  
        CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [bird runAction:
         [CCAnimate actionWithAnimation:
          [CCAnimation animationWithFrames:
           [NSArray arrayWithObjects:
            [cache spriteFrameByName:[NSString stringWithFormat:@"bird0.png"]],nil]] restoreOriginalFrame:NO]];
    
    if (x+playerImage.contentSize.width < touchPos.x && playerImage.numberOfRunningActions == 0){m_state = STATE_JUMP;tagOfSprite++;
        playerImage.flipX = NO;
        if (tagOfSprite == 5) {
            tagOfSprite = 4;
        }}
    else if (x-playerImage.contentSize.width > touchPos.x && playerImage.numberOfRunningActions == 0){m_state = STATE_JUMP;tagOfSprite--;
        playerImage.flipX = YES;
        if (tagOfSprite == -1) {
            tagOfSprite = 0;
        }}
}
*/
-(void)restart
{
    m_state = STATE_GAMEOVER;
}

-(void)thirdBrains
{
    //[self getChildByTag:24].position = ccp([spritesBgNode getChildByTag:6].position.x-[self getChildByTag:24].contentSize.width, -[self getChildByTag:24].contentSize.height*2);
    
    [self getChildByTag:TAG_BRAIN_2].position = ccp([spritesBgNode getChildByTag:6].position.x-[self getChildByTag:24].contentSize.width, -[self getChildByTag:24].contentSize.height*2);
    
    
    id jump = [CCJumpBy actionWithDuration:1.f position:ccp([self getChildByTag:24].contentSize.width*(IS_IPHONE_5 ? 7.0f : 6.0f),0) height:kHeightScreen/1.2 jumps:1];

   // [[self getChildByTag:24] runAction:[CCRepeatForever actionWithAction:[CCSequence actions:jump,[CCDelayTime actionWithDuration:0.2f],[jump reverse], nil]]];
    
    [[self getChildByTag:TAG_BRAIN_2] runAction:[CCRepeatForever actionWithAction:[CCSequence actions:jump,[CCDelayTime actionWithDuration:0.2f],[jump reverse], nil]]];
    
   // NSLog(@"asdasdasdasdasdasd");
}

-(void)particles
{
//    CCParticleSystemQuad *effect = [CCParticleSystemQuad particleWithFile:@"zombie_par.plist"];
//    
//    effect.position = ccp(badFish.position.x,badFish.position.y);
//    
//    if (IS_IPHONE || IS_IPHONE_5) {effect.scale = 0.3f;}
//    if (IS_IPAD) { effect.scale = 0.5f;}
//    
//    //else{effect.scale = 0.8f;}
//    
//    [self addChild:effect z:999];
//    
//    effect.autoRemoveOnFinish = YES;
    
    [_hud makeBlastInPosposition:playerImage.position];
    
    [[playerImage robot_] colorAllBodyPartsWithColor:ccc3(220, 72, 72)
                                               part:0
                                                all:YES
                                            restore:YES
                                  restoreAfterDelay:0.15f];
}

-(void)setPos:(ccTime *)dt
{
    
    if (playerImage.position.y< 0) {
        playerImage.visible = NO;
    }
    playerImage.anchorPoint = ccp(0.5f, 0.2f);
    playerImage.position = badFish.position;
    playerImage.rotation = badFish.rotation;

}

-(void)getPlayerDown:(CCSprite*)sprite
{
    if (!getPlayer) {
      //  [playerImage Action_DEAD_Setdelay:0.1f funForever:YES];
        //[sprite stopAllActions];
        [playerImage stopAllActions];

        
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.05f],[CCCallFuncO actionWithTarget:self  selector:@selector(particles)], nil]];
        
        badFish = sprite;
        self.isTouchEnabled = NO;
        [self reorderChild:playerImage z:2];
        [self schedule:@selector(setPos:) interval:0.005f];
        
        //[playerImage runAction:[CCSpawn actions:[CCMoveTo actionWithDuration:0.1f position:sprite.position],[CCJumpTo actionWithDuration:0.6f position:ccp(playerImage.position.x, -playerImage.contentSize.height) height:playerImage.contentSize.height*2 jumps:1], nil]];
      
        //[sprite runAction:[CCJumpTo actionWithDuration:0.6f position:ccp(sprite.position.x, -playerImage.contentSize.height) height:playerImage.contentSize.height*2 jumps:1]];
        getPlayer = true;
    }
}

-(void)update:(ccTime)dt
{
    pause = NO;
    
    
        BrainsBonus* brainFind = (BrainsBonus *)[self getChildByTag:TAG_BRAIN_1];
        BrainsBonus* brainFind2 = (BrainsBonus *)[self getChildByTag:TAG_BRAIN_3];
        BrainsBonus* brainFind3 = (BrainsBonus *)[self getChildByTag:TAG_BRAIN_2];
    
    if (CGRectIntersectsRect([brainFind boundingBox],[playerImage boundingBox]))
    {
            m_state = STATE_BRAIN_TAKED;
    }
    
    if (CGRectIntersectsRect([brainFind3 boundingBox],[playerImage boundingBox]))
    {
            m_state = STATE_BRAIN_TAKED3;
    
    }
    if (CGRectIntersectsRect([brainFind2 boundingBox],[playerImage boundingBox]))
    {
            m_state = STATE_BRAIN_TAKED2;
    }
    
    if (L3_COLLIDERS) {
        
    //if (brainWasTaked && (CCSprite *)[spritesBgNode getChildByTag:15]) {
        for (int i = 15; i <= 18; i++) {
            CCSprite *sprite = (CCSprite *)[spritesBgNode getChildByTag:i];
            
            CGRect f = [sprite boundingBox];
            f.size.width = f.size.width/4;
            f.size.height = f.size.height/4;
            f.origin.x = f.origin.x + f.size.width/2.f;
            f.origin.y = f.origin.y + f.size.height/2.f;

            
            if(CGRectIntersectsRect(f,[playerImage boundingBox])&& ccpDistance(playerImage.position,ccp(f.origin.x, f.origin.y)))
            {
                [self getPlayerDown:sprite];
                //[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.3f],[CCCallFunc actionWithTarget:self selector:@selector(restart)], nil]];
                [self restart];
            }
        }
    //}
    for (int i = 5; i <= 8; i++) {
    CCSprite *sprite = (CCSprite *)[spritesBgNode getChildByTag:i];
        
            CGRect f = [sprite boundingBox];
            f.size.width = f.size.width/4;
            f.size.height = f.size.height/4;
            f.origin.x = f.origin.x + f.size.width/2.f;
            f.origin.y = f.origin.y + f.size.height/2.f;
        
       
        if(CGRectIntersectsRect(f,[playerImage boundingBox]))
        {
            [self getPlayerDown:sprite];
            //[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.3f],[CCCallFunc actionWithTarget:self selector:@selector(restart)], nil]];
            [self restart];
            }
        }
    }
    
    switch (m_state) {
        case STATE_NORMAL:
            //[self reorderChild:[self getChildByTag:999] z:2];
            break;
        case STATE_JUMP:{
            if (playerImage.numberOfRunningActions == 0) {
               // [self reorderChild:[self getChildByTag:999] z:1];
                if(tagOfSprite >=0 && tagOfSprite<5)
                {
                [playerImage runAction:
                 [CCJumpTo actionWithDuration:0.5 position:ccp([self posiotionXByTag:tagOfSprite], [self posiotionYByTag:tagOfSprite]) height:IS_IPAD ? 100 : 55 jumps:1]];
                }
                else if (tagOfSprite > 4)
                {
                    [playerImage runAction:
                     [CCMoveBy actionWithDuration:13.f position:ccp(playerImage.contentSize.width*5, 0)]];
                
                }
                if (tagOfSprite == 0) {
                    playerImage.anchorPoint = ccp(0.1f, 0.16f);
                }
                else if (tagOfSprite == 1) {
                    playerImage.anchorPoint = ccp(0.1f, 0.1f);
                }
                else if (tagOfSprite == 2) {
                    playerImage.anchorPoint = ccp(0.1f, 0.1f);
                }
                else if (tagOfSprite == 3)
                {
                    if ([self getChildByTag:9999]) {
                        [[self getChildByTag:9999] runAction:[CCFadeTo actionWithDuration:0.3f opacity:0]];}
                    playerImage.anchorPoint = ccp(0.1f, 0.1f);
                   
                    if (!brainWasTaked) {
                    [brainFind runAction:[self brainDropAnimation]];
                    }
                    if (!on3) {
                        on3 = true;
                    [self addEnemy:2];
                    }
                }
                else if (tagOfSprite == 4) {
                    if ([self getChildByTag:9999]) {
                        [[self getChildByTag:9999] runAction:[CCFadeTo actionWithDuration:0.3f opacity:255]];}
                    if (IS_IPAD) {playerImage.anchorPoint = ccp(-0.3f, 0.3f);}
                    else if(IS_IPHONE || IS_IPHONE_5){playerImage.anchorPoint = ccp(-0.12f, 0.2f);}

                    [self addExit];
                    
                }
                else if (tagOfSprite == 5) {
                    if ([self getChildByTag:9999]) {
                        [[self getChildByTag:9999] runAction:[CCFadeTo actionWithDuration:0.3f opacity:0]];}
              //      [playerImage Action_WALK_SetDelay:0.1f funForever:YES];
                    
                   // [playerImage JOE_WALK];
                    
                    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.1f],[CCCallFuncO actionWithTarget:self  selector:@selector(unscheduleUpdate)], nil]];
                    soundFX = YES;
                    [_hud runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.2f],[CCCallFuncO actionWithTarget:_hud  selector:@selector(WINLevel)], nil]];
                    [AUDIO playEffect:fx_winmusic];
                   
                    [_hud TIME_Stop];
                }
                m_state = STATE_NORMAL;
            }
            break;
        }
        case STATE_GAMEOVER:{
            //NSLog(@"game over");
            [[playerImage robot_] ACTION_CLOSE_EYES_eyesTag:10];
            [_hud Lost_STATE_AFTERDELAY:1.f];
            [self unscheduleUpdate];
            m_state = STATE_NORMAL;
            return;

            
            
            break;
        }
        case STATE_BRAIN_TAKED:{
            if (!brainWasTaked) {
                
            brainCount++;
            brainWasTaked = true;
            brainFind.opacity = 0;
//           // brainFind.position = ccp(kWidthScreen, -brain.contentSize.height);
//            if (!brainWasTaked2) {
//            //[self addEnemy:2];
//           // brainWasTaked2 = true;
//            }
            m_state = STATE_NORMAL;
           // [cfg makeBrainActionForNode:brainFind fakeBrainsNode:nil direction:0 pixelsToMove:1 parent:self  removeBrainsAfter:YES makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
                
               
                [cfg makeBrainActionForNode:brainFind fakeBrainsNode:nil direction:0 pixelsToMove:1 time:0 parent:self removeBrainsAfter:YES makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
                [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.f],[CCCallFuncO actionWithTarget:self  selector:@selector(thirdBrains)], nil]];
           
            }
            break;
        }
        case STATE_BRAIN_TAKED2:
        {
            if (!brainWasTaked2) {
            
            brainCount++;
            brainWasTaked2 = true;
            brainFind2.opacity = 0;
            //brainFind2.position = ccp(kWidthScreen, -brain.contentSize.height);
//            if (!brainWasTaked2) {
//            //[self addEnemy:2];
//            brainWasTaked2 = true;
//            }
            m_state = STATE_NORMAL;
           [cfg makeBrainActionForNode:brainFind2 fakeBrainsNode:nil direction:0 pixelsToMove:1 time:0 parent:self removeBrainsAfter:YES makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
            }
            break;
        }
        case STATE_BRAIN_TAKED3:
        {
            if (!brainWasTaked3) {
                
            brainCount++;
            brainWasTaked3 = true;
            [brainFind3 stopAllActions];
            brainFind3.opacity = 0;
           // brainFind3.position = ccp(kWidthScreen, -brain.contentSize.height);
            m_state = STATE_NORMAL;
            
            [cfg makeBrainActionForNode:brainFind3 fakeBrainsNode:nil direction:0 pixelsToMove:1 time:0 parent:self removeBrainsAfter:YES makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
            
            break;
            }

        }
        default:
            break;
    }
    
    
}
-(void)createBatchNode
{
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"Level3%@.pvr.ccz",kDevice]];
    [self addChild:spritesBgNode z:2];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"Level3%@.plist",kDevice]];
}

-(CCAction *)waveAction:(CCSprite *)sprite :(int)number_
{
    float a = [sprite boundingBox].size.width/12;
    if (number_ == 1) {
        return[CCRepeatForever actionWithAction:
               [CCSequence actions:
                [CCMoveBy actionWithDuration:3 position:ccp(a, 0)],
                [CCMoveBy actionWithDuration:3 position:ccp(-a, 0)], nil]];
    }
    if (number_ == 2) {
        return[CCRepeatForever actionWithAction:
               [CCSequence actions:
                [CCMoveBy actionWithDuration:2 position:ccp(a, 0)],
                [CCMoveBy actionWithDuration:2 position:ccp(-a, 0)], nil]];
    }
    return 0;
}

-(void)tree_waveAdd
{
    CCSprite *wave2 = [CCSprite spriteWithSpriteFrameName:@"wave1.png"];
    wave2.anchorPoint = ccp(0, 0);
    wave2.position = ccp(0,0);
    wave2.opacity = 120;
    [spritesBgNode addChild:wave2 z:1];
    [wave2 runAction:[self waveAction:wave2 :1]];
    
    CCSprite *wave1 = [CCSprite spriteWithSpriteFrameName:@"wave0.png"];
    wave1.anchorPoint = ccp(0.1, 0);
    wave1.position = ccp(0,0);
    wave1.scaleX = 1.2f;
    [spritesBgNode addChild:wave1 z:4];
    [wave1 runAction:[self waveAction:wave1 :2]];
    
    CCSprite *tree = [CCSprite spriteWithSpriteFrameName:@"tree.png"];
    tree.anchorPoint = ccp(0, 0);
    if (IS_IPHONE_5) {tree.position = ccp(kWidthScreen/1.25,kHeightScreen/4);}
    else{tree.position = ccp(kWidthScreen/1.3,kHeightScreen/4);}
    [spritesBgNode addChild:tree z:1];

}
-(void)inWaterAnimation
{
    CCSprite *bottle = [CCSprite spriteWithSpriteFrameName:@"bottle.png"];
    CCSprite *wheel = [CCSprite spriteWithSpriteFrameName:@"wheel.png"];
    
    bottle.anchorPoint = ccp(0, 0);
    wheel.anchorPoint = ccp(0, 0);
    
    bottle.position = ccp(kWidthScreen/2,0);
    wheel.position = ccp(kWidthScreen/1.5,0);
    
    [spritesBgNode addChild:bottle z:3];
    [spritesBgNode addChild:wheel z:3];
    
    float a = [bottle boundingBox].size.width;
    
    [bottle runAction:
     [CCRepeatForever actionWithAction:
      [CCSequence actions:
       [CCJumpBy actionWithDuration:1.5f position:ccp(a, 0) height:5 jumps:2],
       [CCJumpBy actionWithDuration:1.5f position:ccp(-a, 0) height:5 jumps:2], nil]]];
    
    [wheel runAction:
     [CCRepeatForever actionWithAction:
      [CCSequence actions:
       [CCJumpBy actionWithDuration:2.5f position:ccp(0, 0) height:5 jumps:2],
       [CCJumpBy actionWithDuration:2.5f position:ccp(0, 0) height:5 jumps:2], nil]]];
}

-(void)showTutorial_
{
    Tutorial *tut = [[[Tutorial alloc]init]autorelease];
    [self addChild:tut z:10 tag:tut1];
    tut.position = ccp(kWidthScreen/2, kHeightScreen/2);
    [tut SWIPE_TutorialWithDirection:SWIPE_LEFT times:2 delay:0.5f runAfterDelay:1.f];

}

-(void)birdAdd
{
    bird = [CCSprite spriteWithSpriteFrameName:@"bird0.png"];
    bird.anchorPoint = ccp(0.1, 0);
    if (IS_IPHONE_5) {bird.position = ccp(kWidthScreen/1.2,kHeightScreen/1.67);}
    else{bird.position = ccp(kWidthScreen/1.22,kHeightScreen/1.67);}
    [spritesBgNode addChild:bird z:0];
    
    [bird runAction:
     [CCRepeatForever actionWithAction:
      [CCSequence actions:
       [CCRotateBy actionWithDuration:0.5 angle:5],
       [CCDelayTime actionWithDuration:0.5],
       [CCRotateBy actionWithDuration:0.5 angle:-5], nil]]];
}

-(void)brainAdd
{
    brain = [[BrainsBonus alloc]initWithRect:CGRectMake(0, 0, 0, 0)];
    //BRAIN.tag = BONUS1+x;
   // brain = [CCSprite spriteWithSpriteFrameName:@"brains.png"];
    brain.anchorPoint = ccp(0.5f,0.5f);
    brain.visible = NO;
    brain.position = ccp([self posiotionXByTag:0], kHeightScreen+brain.contentSize.height);
    [self addChild:brain z:3 tag:21];
    
    BrainsBonus* brain3 =  [[BrainsBonus alloc]initWithRect:CGRectMake(0, 0, 0, 0)];//[CCSprite spriteWithSpriteFrameName:@"brains.png"];
    brain3.anchorPoint = ccp(0.5f,0.5f);
    brain3.visible = NO;
    brain3.position = ccp([spritesBgNode getChildByTag:6].position.x, - brain3.contentSize.height*2);
    [self addChild:brain3 z:2 tag:24];
    
    
    [_hud preloadBlast_self:self brainNr:3 parent:self];
    
    [_hud BRAIN_:TAG_BRAIN_1 position:ccp([self posiotionXByTag:0], kHeightScreen+brain.contentSize.height) parent:self];
    
    [_hud BRAIN_:TAG_BRAIN_1 zOrder:2 parent:self];
    
    [_hud BRAIN_:TAG_BRAIN_2 position:ccp(-100, -100) parent:self];
    
    [_hud BRAIN_:TAG_BRAIN_2 zOrder:1 parent:self];
    
    [_hud BRAIN_:TAG_BRAIN_3 position:ccp(-100, -100) parent:self];
    
    [_hud BRAIN_:TAG_BRAIN_3 zOrder:1 parent:self];
    
    
    
//    brain = [CCSprite spriteWithSpriteFrameName:@"brains.png"];
//    brain.anchorPoint = ccp(0.2f,0.7f);
//    brain.position = ccp([self posiotionXByTag:0], kHeightScreen+brain.contentSize.height);
//    [spritesBgNode addChild:brain z:3 tag:21];
    
    
    
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


- (id)initWithHUD:(InGameButtons *)hud
{
	if( (self=[super init])) {
        
        
        _hud = hud;
    
        tagOfSprite = 0;
        brainWasTaked = false;
        brainWasTaked2 = false;
        brainWasTaked3 = false;
        getPlayer = false;
        exitArrow = false;
        on3 = false;
        b_birdTap = false;
        brainCount = 1;
        
        [self addBackground];
        [self createBatchNode];
        [self brainAdd];
        [self tree_waveAdd];
        [self birdAdd];
        [self inWaterAnimation];
        [self scheduleUpdate];
        [self addColons];
        [self addPlayer];
        [self addEnemy:1];
        self.isTouchEnabled = YES;
        
        if (_hud.tutorialSHOW)
        {
            pause = YES;
            [self schedule:@selector(GAME_PAUSE) interval:0.1f];
        }
     
        if (![Combinations checkNSDEFAULTS_Bool_ForKey:C_TUTORIAL_(_hud.level)])
        {
        [cfg runSelectorTarget:self selector:@selector(showTutorial_) object:nil afterDelay:0.2f sender:self];
        }

      //  [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"level3.mp3" loop:YES];
            
	}
	return self;
}


-(id)getNode{
    
    return [Level3 node];
    
}


- (void)onEnter{
    
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-2 swallowsTouches:YES];
    [super onEnter];
}


- (void)onExit{
    
    [self unscheduleAllSelectors];
    [self removeAllChildrenWithCleanup:YES];
    [self stopAllActions];
    
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [super onExit];
}

- (void) dealloc
{
	[super dealloc];
}
@end
