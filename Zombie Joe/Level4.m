
#import "Level4.h"
#import "cfg.h"
#import "SConfig.h"
#import "Head.h"
#import "Cristal.h"
#import "Constants_Level4.h"
#import "BrainsBonus.h"
#import "SimpleAudioEngine.h"
#import "Tutorial.h"

#define kTut 828228
@implementation Level4

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	Level4 *layer = [Level4 node];
	[scene addChild: layer];
	return scene;
}

-(void)firstShow
{
    Head*bull = (Head*)[self getChildByTag:1];
    [bull addCristal];
    [bull doSomething];
    
    if (itsBrain) {

        Head *bull2 = (Head*)[self getChildByTag:2];
        [bull2 doSomething];
        
    }
    
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.5f],[CCCallFuncO actionWithTarget:self  selector:@selector(afterStart)], nil]];
}

-(NSInteger)MyRandomIntegerBetween:(int)min :(int)max {
    return ( (arc4random() % (max-min+1)) + min );
}
-(void)setEaysMoving:(NSNumber*)tag__
{
    Head*bull = (Head*)[self getChildByTag:tag__.integerValue];
    [bull eaysRunning];

}
-(void)loadMovingHeads
{
    Head*bull1 = (Head*)[self getChildByTag:[self MyRandomIntegerBetween:0 :2]];
    [bull1 movingHeads];
}
-(void)showTut
{
    canShowTut = NO;

    Tutorial *tut = [[[Tutorial alloc]init]autorelease];
    [self addChild:tut z:10 tag:kTut];
    tut.position = ((Head*)[self getChildByTag:1]).position;
    [tut TAP_TutorialRepeat:2 delay:0.5f runAfterDelay:.5f];
}

-(void)setAction:(CCSprite*)sprite_1:(CCSprite*)sprite_2:(CCSprite*)sprite_3:(int)number
{
    for (int i = 0;i<=2; i++) {
        //Head*bull = (Head*)[self getChildByTag:i];
        //[bull headGoDown];
    }
    count++;
    Head*bull = (Head*)[self getChildByTag:1];
    if ([sprite_1 numberOfRunningActions] == 0 && [sprite_2 numberOfRunningActions] == 0 && [sprite_3 numberOfRunningActions] == 0) {
        
       
        if (count >= 200) {
            [_hud TIME_Resume];
            for (int i = 0; i<2; i++) {
        
                [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:i],[CCCallFuncO actionWithTarget:self  selector:@selector(loadMovingHeads)], nil]];
            }
            m_state = STATE_NORMAL_;
            canTouchHEADS = YES;
            if (![Combinations checkNSDEFAULTS_Bool_ForKey:C_TUTORIAL_(_hud.level)])
            {
                if (canShowTut) {
                    [cfg runSelectorTarget:self selector:@selector(showTut) object:nil afterDelay:0.2f sender:self];
                }
            }
          //  self.isTouchEnabled = YES;
            [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.1f],[CCCallFuncO actionWithTarget:self  selector:@selector(setEaysMoving:)], nil]];
            
            return;
        }
        ///////MOVING HEADS
     
        [AUDIO playEffect:l3_monsterSlide];
  
        
        if (number == 0) {
            [sprite_1 runAction:[CCEaseInOut actionWithAction:[CCJumpTo actionWithDuration:speed position:sprite_2.position height:[bull returnInt:1] jumps:1] rate:2]];
            [sprite_2 runAction:[CCEaseInOut actionWithAction:[CCJumpTo actionWithDuration:speed position:sprite_1.position height:[bull returnInt:2] jumps:1] rate:2]];
        }
        else if (number == 1)
        {
            [sprite_1 runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:speed position:sprite_2.position] rate:2]];
            [sprite_2 runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:speed position:sprite_3.position] rate:2]];
            [sprite_3 runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:speed position:sprite_1.position] rate:2]];
        }
    }
}

-(CGRect)rectChoose
{
    if (IS_IPAD)return iPad_rect;return iPhone_rect;
}

-(void)addSprite
{
    int z = 0;
    for (int x = 0; x <=2; x++) {
        Head * HEAD = [[[Head alloc]initWithRect:[self rectChoose]] autorelease];
        HEAD.anchorPoint = ccp(0.5f, 0.4f);
            switch (x) {
                case 0:HEAD.position = [HEAD returnValuePOS_:15];z = 2;break;
                case 1:HEAD.position = ccp([HEAD returnValuePOS_:16].x,[HEAD returnValuePOS_:16].y);z = 3; break;
                case 2:HEAD.position = [HEAD returnValuePOS_:17];z = 2;break;
                default:break;}
          [self addChild:HEAD z:z tag:x];
    }
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.f],[CCCallFuncO actionWithTarget:self  selector:@selector(firstShow)], nil]];
    
}

-(void)bull2CloseMouth{
    Head*bull2 = (Head*)[self getChildByTag:2];
    if ([bull2 openMouth]) {
        [bull2 actionReverse];
    }
}

-(void)preActionReverse
{
     Head*bull = (Head*)[self getChildByTag:1];
         
    if ([bull openMouth]) {
        [bull actionReverse];
    }
    
}

-(void)afterStart
{
    canTouchHEADS = NO;
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.2f],[CCCallFuncO actionWithTarget:self  selector:@selector(preActionReverse)], nil]];
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.5f],[CCCallFuncO actionWithTarget:self  selector:@selector(firstAction)], nil]];

}


-(void)addCristalFake2
{
    Head*bull = (Head*)[self getChildByTag:1];
    float delay;
    float delay2;

    delay = 1.5f;
    delay2 = 2.f;

    
    if (cristalCount < 9) {
        [bull addCristal];
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:delay],[CCCallFuncO actionWithTarget:self  selector:@selector(preActionReverse)], nil]];
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:delay2],[CCCallFuncO actionWithTarget:self  selector:@selector(firstAction)], nil]];
        
    }
    else
    {
        [bull closeMouth];
    }


}
-(void)addCristalFake
{
    Head*bull = (Head*)[self getChildByTag:1];
    float delay;
    float delay2;
//    if (itsBrain) {
//        delay = 1.2f;
//        delay2 = 1.5f;
//    }
//    else
//    {
        delay = 0.7f;
        delay2 = 1.f;
   // }
    
    if (cristalCount < 9) {
    [bull addCristal];
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:delay],[CCCallFuncO actionWithTarget:self  selector:@selector(preActionReverse)], nil]];
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:delay2],[CCCallFuncO actionWithTarget:self  selector:@selector(firstAction)], nil]];

    }
    else
    {
        [bull closeMouth];
    }
}

-(void)stopActions
{
    [[spriteBatchNode getChildByTag:11] stopAllActions];
    [[spriteBatchNode getChildByTag:12] stopAllActions];
    [[spriteBatchNode getChildByTag:15] stopAllActions];
    [[spriteBatchNode getChildByTag:13] stopAllActions];
    [[spriteBatchNode getChildByTag:14] stopAllActions];
    
   // [self runAction:[CCScaleTo actionWithDuration:0.5f scale:15]];
}

-(void)openTheDoors
{
    doorIsOpen = true;
    [_hud TIME_Stop];
    [AUDIO playEffect:l3_doorOpen];
    m_state = STATE_NORMAL_;
    [[spriteBatchNode getChildByTag:11] runAction:
     [CCRepeatForever actionWithAction:
      [CCRotateBy actionWithDuration:2 angle:-360]]];
    [[spriteBatchNode getChildByTag:12] runAction:
     [CCRepeatForever actionWithAction:
      [CCRotateBy actionWithDuration:1.5 angle:360]]];
    [[spriteBatchNode getChildByTag:15] runAction:
     [CCRepeatForever actionWithAction:
      [CCRotateBy actionWithDuration:2 angle:360]]];
    [[spriteBatchNode getChildByTag:13] runAction:
     [CCRepeatForever actionWithAction:
      [CCRotateBy actionWithDuration:1.5 angle:-360]]];
    [[spriteBatchNode getChildByTag:14] runAction:
     [CCSequence actions:
      [CCMoveBy actionWithDuration:1.5f position:ccp(0, [spriteBatchNode getChildByTag:14].contentSize.height/1.5/*+20*/)]/*,[CCMoveBy actionWithDuration:0.1f position:ccp(0, -5)]*/,[CCCallFuncO actionWithTarget:self selector:@selector(stopActions)], nil]];
   // self.isTouchEnabled = NO;
    
    [_hud runAction:[CCSequence actions:[CCDelayTime actionWithDuration:2.f],[CCCallFuncO actionWithTarget:_hud  selector:@selector(WINLevel)], nil]];
    [AUDIO playEffect:fx_winmusic];

   
}

-(NSString *)name
{
    if (cristalCount>=1 && cristalCount <4) {return @"gem0.png";}
    else if (cristalCount>=4 && cristalCount <7){return @"gem1.png";}
    else if (cristalCount>=7 && cristalCount <=9){return @"gem2.png";}
    return @"";
}

-(CGPoint)setPos
{
    Head*bull = (Head*)[self getChildByTag:1];
    switch (cristalCount) {
        case 1:return [bull returnValuePOS_:1];break;
        case 2:return [bull returnValuePOS_:2];break;
        case 3:return [bull returnValuePOS_:3];break;
        case 4:return [bull returnValuePOS_:4];break;
        case 5:return [bull returnValuePOS_:5];break;
        case 6:return [bull returnValuePOS_:6];break;
        case 7:return [bull returnValuePOS_:7];break;
        case 8:return [bull returnValuePOS_:8];break;
        case 9:return [bull returnValuePOS_:9];break;
        default:break;
    }
    return CP1_ipad;
}

-(void)preCallCristal
{
    Cristal*criss = (Cristal*)[self getChildByTag:55];
    Head*bull = (Head*)[self getChildByTag:1];
    [criss addCristal:[self name] :[NSNumber numberWithInt:cristalCount]];
    [criss setCristalPos:[self setPos] :[NSNumber numberWithInt:cristalCount]];
    if ([self setPos].x == [bull returnValuePOS_:9].x && [self setPos].y == [bull returnValuePOS_:9].y) {
        [self openTheDoors];
    }
}

-(void)preGO
{
    Head*bull = (Head*)[self getChildByTag:1];
    [bull cristalGo:[self setPos]];
    
   
    
}

-(void)gearAnimation
{
    
    CCSprite *sprite = (CCSprite*)[spriteBatchNode getChildByTag:13];
    
    if (sprite.numberOfRunningActions == 0) {
    [sprite runAction:[CCSequence actions:/*[CCSpawn actions:[CCMoveBy actionWithDuration:0.1f position:ccp(sprite.contentSize.width/30, 0)],*/[CCRotateBy actionWithDuration:0.1f angle:15]/*,nil]*/,/*[CCSpawn actions:[CCMoveBy actionWithDuration:0.1f position:ccp(-sprite.contentSize.width/30, 0)],*/[CCRotateBy actionWithDuration:0.1f angle:-15]/*,nil]*/, nil]];
    }
}
-(void)removeBrain:(CCNode*)node
{
    CCSprite *sp = (CCSprite *)node;
    [sp removeFromParentAndCleanup:YES];
    [_hud increaseBRAINSNUMBER];
    
}
-(void)randomeBrains
{
    Head*bull2 = (Head*)[self getChildByTag:2];
    [bull2 doSomething];
    // [bull2 removeBrain];
    [bull2 addBrain];

}

-(void)brainJump
{
//    int b;
//    if (IS_IPAD) {b = 150;}else{b = 250;}
    
    BrainsBonus *brain =  [[BrainsBonus alloc]initWithRect:CGRectMake(0, 0, 100, 100)];
    brain.anchorPoint = ccp(0.5f, 0.5f);
   // brain.brain.opacity = 0;
    brain.visible = NO;
    brain.position = ccp([spriteBatchNode getChildByTag:14].position.x + [spriteBatchNode getChildByTag:14].contentSize.width/2, [spriteBatchNode getChildByTag:14].position.y + brain.contentSize.height/2);
    [self addChild:brain z:1 tag:998];
    
    [_hud BRAIN_:TAG_BRAIN_2 position:brain.position parent:self];
    
    //[_hud BRAIN_:TAG_BRAIN_2 zOrder:0 parent:self];
    
//    int a;
//    if (IS_IPAD) {a = 400;}else{a = 200;}
//    [brain runAction:
//     [CCSpawn actions:
//      [CCCallBlock actionWithBlock:^(void){[brain.brain runAction:
//                                            [CCFadeTo actionWithDuration:0.1f opacity:255]];}],
//      [CCEaseInOut actionWithAction:[CCJumpTo actionWithDuration:2.f position:ccp(kWidthScreen*1.1f, 0) height:a jumps:1] rate:2], nil]];
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!pause) {
    UITouch* touch = [touches anyObject];
    CGPoint touchPos = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    CCSprite *c = (CCSprite*)[self getChildByTag:3];
    Head*bull = (Head*)[self getChildByTag:1];
    Head*bull2 = (Head*)[self getChildByTag:2];
        
        CGRect f0 = [[self getChildByTag:999] boundingBox];
        float f0r = 4;
        f0.size.width = f0.size.width*f0r;
        f0.size.height = f0.size.height*f0r;
        f0.origin.x = f0.origin.x - f0.size.width/2;
        f0.origin.y = f0.origin.y - f0.size.height/2;
    
    if (CGRectContainsPoint(f0, touchPos))
    {
        if (!brain1IsTouched) {
            brain1IsTouched = true;
            [_hud BRAIN_:TAG_BRAIN_1 position:ccp(-100, -100) parent:self];//Brain behind rocks
            [cfg makeBrainActionForNode:[self getChildByTag:999] fakeBrainsNode:nil direction:0 pixelsToMove:1 time:0 parent:self removeBrainsAfter:YES makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
            
        }
    }
    CGRect f = [[self getChildByTag:998] boundingBox];
    f.size.width = f.size.width*4;
    f.size.height = f.size.height*4;
    f.origin.x = f.origin.x - f.size.width/2;
    f.origin.y = f.origin.y - f.size.height/2;
    
    if (CGRectContainsPoint(f, touchPos))
    {
        if (!brain2IsTouched && doorIsOpen) {
            brain2IsTouched = true;
            [_hud BRAIN_:TAG_BRAIN_2 position:ccp(-100, -100) parent:self];//Brain behind doors
            [cfg makeBrainActionForNode:[self getChildByTag:998] fakeBrainsNode:nil direction:0 pixelsToMove:1 time:0 parent:self removeBrainsAfter:YES makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
        }
    }

    
    if (CGRectContainsPoint([spriteBatchNode getChildByTag:13].boundingBox, touchPos))
    {
        [self gearAnimation];
        [AUDIO playEffect:l3_gearSpund];
        if (!gearHit) {
            gearHit = true;
            BrainsBonus *brain =  [[BrainsBonus alloc]initWithRect:CGRectMake(0, 0, 0, 0)];
            brain.anchorPoint = ccp(0.5f, 0.5f);
            brain.position = [spriteBatchNode getChildByTag:13].position;
            [self addChild:brain z:5 tag:89];
            //[[self getChildByTag:89] runAction:[CCSequence actions:[CCMoveTo actionWithDuration:0.3f position:ccp(kWidthScreen - kWidthScreen/5, kHeightScreen - kHeightScreen/12)],[CCCallFuncO actionWithTarget:self selector:@selector(removeBrain:) object:[self getChildByTag:89]], nil]];
           
            //[_hud BRAIN_:TAG_BRAIN_1 position:ccp(-100, -100) parent:self];//Gear Brain
            [cfg makeBrainActionForNode:[self getChildByTag:89] fakeBrainsNode:nil direction:270 pixelsToMove:IS_IPAD ? 100 : 20 time:0.4f parent:self removeBrainsAfter:YES makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];

        }
    }
    
    if ((CGRectContainsPoint(((Head*)[self getChildByTag:1]).boundingBox, touchPos)) && canTouchHEADS)
        {
            if ([self getChildByTag:kTut]) {
                [[self getChildByTag:kTut] removeFromParentAndCleanup:YES];
            }
            
            //self.isTouchEnabled = NO;
            canTouchHEADS = NO;
            cristalCount++;
            brainCount++;
           // [self randomeBrains];
//            if (cristalCount == 5 || cristalCount == 8) {
//                //itsBrain = YES;
//            }
//            else {
//                itsBrain = NO;}
            
            [bull pliusCristals];
            [bull eaysStartPos];
            [bull addCristal];
            [bull doSomething];
            
//            if (itsBrain) {
//                [bull2 doSomething];
//               // [bull2 removeBrain];
//                [bull2 addBrain];
//            }
            
            if (cristalCount == 4)
            {
                [Combinations saveNSDEFAULTS_Bool:YES forKey:C_TUTORIAL_([_hud level])];
            }
            
             [_hud TIME_Pause];
            
            //if(cristalCount == 9){[self brainJump];}
            
            [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.9f],[CCCallFuncO actionWithTarget:self  selector:@selector(preGO)], nil]];
            
            speed -= 0.015;
            
            count = 0;
            c.position = [self getChildByTag:1].position;
             [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.5f],[CCCallFuncO actionWithTarget:self  selector:@selector(preCallCristal)], nil]];
             [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.5f],[CCCallFuncO actionWithTarget:self  selector:@selector(addCristalFake)], nil]];
            
        }
        else if ((CGRectContainsPoint(((Head*)[self getChildByTag:0]).boundingBox, touchPos)&& canTouchHEADS))
       {
           if ([self getChildByTag:kTut]) {
               [[self getChildByTag:kTut] removeFromParentAndCleanup:YES];
           }

           if (!itsBrain) {
            canTouchHEADS = NO;
            [bull eaysStartPos];
            [bull gameOver];
               
            [_hud TIME_Stop];
               
            Head *bull1 = (Head*)[self getChildByTag:0];
            [bull1 gameOverSmile];
            [bull2 gameOverSmile];
           }
//           else
//           {
//               canTouchHEADS = NO;
//               [bull eaysStartPos];
//               
//               [_hud TIME_Pause];
//               
//               [bull gameOver];
//               Head *bull1 = (Head*)[self getChildByTag:0];
//               [bull1 gameOverSmile];
//               [bull2 doSomething];
//               [bull2 addBrain];
//           
//           }
           
           [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.5f],[CCCallFuncO actionWithTarget:self  selector:@selector(setStateGameOver)], nil]];
       }
    
        else if ((CGRectContainsPoint(((Head*)[self getChildByTag:2]).boundingBox, touchPos) && canTouchHEADS))
        {
            if ([self getChildByTag:kTut]) {
                [[self getChildByTag:kTut] removeFromParentAndCleanup:YES];
            }
            if (!itsBrain) {
                
                canTouchHEADS = NO;
                [bull eaysStartPos];
                
                [_hud TIME_Stop];
                
                [bull gameOver];
                Head *bull1 = (Head*)[self getChildByTag:0];
                [bull1 gameOverSmile];
                [bull2 gameOverSmile];
            
                [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.5f],[CCCallFuncO actionWithTarget:self  selector:@selector(setStateGameOver)], nil]];
            }
//            else{
//              
//                canTouchHEADS = NO;
//                [_hud TIME_Pause];
//                [bull doSomething];
//                if (itsBrain) {
//                    [bull2 doSomething];
//                 
//                }
//             
//                count = 0;
//                c.position = [self getChildByTag:1].position;
//                [self addCristalFake2];
//
//                
//                BrainsBonus *brain =  [[BrainsBonus alloc]initWithRect:CGRectMake(0, 0, 0, 0)];
//                brain.anchorPoint = ccp(0.5f, 0.5f);
//                brain.position = [self getChildByTag:2].position;
//                [self addChild:brain z:5 tag:99];
//                [[self getChildByTag:99] runAction:[CCSequence actions:/*[CCDelayTime actionWithDuration:0.1f],*/[CCEaseOut actionWithAction:[CCMoveTo actionWithDuration:0.5f position:ccp(kWidthScreen - kWidthScreen/5, kHeightScreen - kHeightScreen/12)] rate:2],[CCCallFuncO actionWithTarget:self selector:@selector(removeBrain:) object:[self getChildByTag:99]], nil]];
//                
//                    itsBrain = NO;
//            
           }
        }
}

-(void)reorderChild
{
    Head*bull = (Head*)[self getChildByTag:1];
    for (int i = 0; i<=2; i++) {
        if ([self getChildByTag:i].position.y < [bull returnValuePOS_:15].y) {
            [self reorderChild:[self getChildByTag:i] z:3];
        }
        if ([self getChildByTag:i].position.y  == [bull returnValuePOS_:15].y) {
            [self reorderChild:[self getChildByTag:i] z:2];
        }
        if ([self getChildByTag:i].position.y == [bull returnValuePOS_:16].y) {
            [self reorderChild:[self getChildByTag:i] z:4];
        }
    }
}

-(void)update:(ccTime)dt
{
    
    pause = NO;
    
    switch (m_state) {
        case STATE_NORMAL_:
            break;
            
        case STATE_JUMP_:{
         
            CCSprite *c = (CCSprite*)[self getChildByTag:3];
            c.opacity = 0;
            int randomeNum = [self MyRandomIntegerBetween:0 :5];
            switch (randomeNum) {
                case 0:
                    [self setAction:(CCSprite*)[self getChildByTag:0]:(CCSprite*)[self getChildByTag:1]:nil:0];break;
                case 1:
                    [self setAction:(CCSprite*)[self getChildByTag:1]:(CCSprite*)[self getChildByTag:0]:nil:0];break;
                case 2:
                    [self setAction:(CCSprite*)[self getChildByTag:1]:(CCSprite*)[self getChildByTag:2]:nil:0];break;
                case 3:
                    [self setAction:(CCSprite*)[self getChildByTag:2]:(CCSprite*)[self getChildByTag:1]:nil:0];break;
                case 4:
                    [self setAction:(CCSprite*)[self getChildByTag:0]:(CCSprite*)[self getChildByTag:1]:(CCSprite*)[self getChildByTag:2]:1];break;
                case 5:
                    [self setAction:(CCSprite*)[self getChildByTag:2]:(CCSprite*)[self getChildByTag:1]:(CCSprite*)[self getChildByTag:0]:1];break;
                default:
                    break;
            }
        }
            break;
            
        case STATE_GAMEOVER_:{
            
            [_hud Lost_STATE_AFTERDELAY:0];
            
            m_state = STATE_NORMAL_;
        }
            break;
        
        default:
            break;
    }
}

-(void)setStateGameOver
{
    m_state = STATE_GAMEOVER_;
}

-(void)firstAction
{
    if (cristalCount < 9) {
    m_state = STATE_JUMP_;
        [_hud TIME_Pause];
    }
}

-(void)cristalConstructor
{


}

-(void)cloudsAnimation:(CCSprite*)sprite
{
    [sprite runAction:
     [CCRepeatForever actionWithAction:
      [CCSequence actions:
       [CCMoveBy actionWithDuration:30.f position:ccp(-kWidthScreen-sprite.contentSize.width*2, 0)],
       [CCMoveTo actionWithDuration:0 position:ccp(kWidthScreen+sprite.contentSize.width,sprite.position.y)], nil]]];
}

//-(void)addBall
//{
//    CCSprite *sprite = [CCSprite spriteWithFile:@"kvadrat.png"];
//    sprite.anchorPoint = ccp(0.5f,0.5f);
//    sprite.position = ccp([self getChildByTag:1].position.x,[self getChildByTag:1].position.y - [self getChildByTag:1].contentSize.height);
//    [self addChild:sprite z:1 tag:3];
//}

-(void)addBatchNode
{
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
    CCSpriteBatchNode* spriteBatchNode_ = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"BG_Level4_2%@.pvr.ccz",kDevice]];
    [self addChild:spriteBatchNode_ z:0 tag:5];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"BG_Level4_2%@.plist",kDevice]];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    CCSpriteBatchNode* spriteBatchNode__ = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"BG_Level4_1%@.pvr.ccz",kDevice]];
    [self addChild:spriteBatchNode__ z:1 tag:6];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"BG_Level4_1%@.plist",kDevice]];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"Level4%@.pvr.ccz",kDevice]];
    [self addChild:spriteBatchNode z:2 tag:6];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"Level4%@.plist",kDevice]];

    
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"background0.jpg"];
    sprite.anchorPoint = ccp(0, 1.0f);
    sprite.position = ccp(0, kHeightScreen);
    [spriteBatchNode_ addChild:sprite z:0 tag:1];
    
    CCSprite *sprite1 = [CCSprite spriteWithSpriteFrameName:@"background1.png"];
    sprite1.anchorPoint = ccp(0.5f,0);
    sprite1.position = ccp(kWidthScreen/2, 0);
    [spriteBatchNode__ addChild:sprite1 z:2 tag:2];
    
    
    for (int i = 0; i<3; i++) {
    CCSprite *sprite2 = [CCSprite spriteWithSpriteFrameName:@"cloud0.png"];
    sprite2.anchorPoint = ccp(0.5f,0);
        switch (i) {
            case 0:sprite2.position = ccp(kWidthScreen+sprite2.contentSize.width, kHeightScreen - sprite2.contentSize.height/2);break;
            case 1:sprite2.position = ccp(kWidthScreen+sprite2.contentSize.width, kHeightScreen - sprite2.contentSize.height/3);break;
            case 2:sprite2.position = ccp(kWidthScreen+sprite2.contentSize.width, kHeightScreen - sprite2.contentSize.height/1.2);break;
            default:break;
        }
    [spriteBatchNode__ addChild:sprite2 z:1 tag:3];
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:i + 1.5f],[CCCallFuncO actionWithTarget:self selector:@selector(cloudsAnimation:) object:sprite2], nil]];
    }
    
    for (int i = 0; i<3; i++) {
        CCSprite *sprite2 = [CCSprite spriteWithSpriteFrameName:@"cloud1.png"];
        sprite2.anchorPoint = ccp(0.5f,0);
        switch (i) {
            case 0:sprite2.position = ccp(kWidthScreen+sprite2.contentSize.width, kHeightScreen - sprite2.contentSize.height*3);break;
            case 1:sprite2.position = ccp(kWidthScreen+sprite2.contentSize.width, kHeightScreen - sprite2.contentSize.height*2);break;
            case 2:sprite2.position = ccp(kWidthScreen+sprite2.contentSize.width, kHeightScreen - sprite2.contentSize.height/1.2);break;
            default:break;
        }
        [spriteBatchNode__ addChild:sprite2 z:1 tag:3];
        
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:i+8.5f],[CCCallFuncO actionWithTarget:self selector:@selector(cloudsAnimation:) object:sprite2], nil]];
    }
}

-(void)addDoorsGears
{
    Head*bull = (Head*)[self getChildByTag:1];
    int tagP = 10;
    for (int i = 1; i<=3; i++) {
        tagP++;
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"gear%i.png",i]];
        sprite.anchorPoint = ccp(0.5f, 0.5f);
        switch (i) {
            case 1:
                sprite.position = [bull returnValuePOS_:11];
                break;
            case 2:
                sprite.position = [bull returnValuePOS_:12];
                break;
            case 3:
                sprite.position = [bull returnValuePOS_:13];
                break;
                
            default:
                break;
        }
        [spriteBatchNode addChild:sprite z:1 tag:tagP];
    }
    CCSprite*s = [CCSprite spriteWithSpriteFrameName:@"gear1.png"];
    s.anchorPoint = ccp(0.5f, 0.5f);
    s.position = [bull returnValuePOS_:14];
    [spriteBatchNode addChild:s z:1 tag:15];
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"door.png"];
    sprite.anchorPoint = ccp(0, 0);
    sprite.position = [bull returnValuePOS_:10];
    [spriteBatchNode addChild:sprite z:3 tag:14];
}
-(void)addBrains
{
    BrainsBonus *brain =  [[BrainsBonus alloc]initWithRect:CGRectMake(0, 0, 100, 100)];
    brain.anchorPoint = ccp(0.5f, 0.5f);
    CGPoint p;
    if (IS_IPAD) {p = ccp(brain.contentSize.width*1.5f, kHeightScreen/1.5f);}else if(IS_IPHONE_5){p = ccp(brain.contentSize.width*3.5f, kHeightScreen/1.3f);}else if(IS_IPHONE){p = ccp(brain.contentSize.width*1.5f, kHeightScreen/1.3f);}
    brain.position = p;
    brain.visible = NO;
    [self addChild:brain z:0 tag:999];
    
    [_hud preloadBlast_self:self brainNr:2 parent:self];
    
    [_hud BRAIN_:TAG_BRAIN_1 position:brain.position parent:self];
    
    [_hud BRAIN_:TAG_BRAIN_1 zOrder:0 parent:self];
    
    [_hud BRAIN_:TAG_BRAIN_2 position:ccp(-100, -100) parent:self];
    
    [_hud BRAIN_:TAG_BRAIN_2 zOrder:1 parent:self];
}

-(void)GAME_RESUME{
    
    if (tutorial) {
    [_hud TIME_Pause];
    }
    
    [self resumeSchedulerAndActions];
    
    pause = false;
    
    for (CCNode *ch in [self children]) {
        [ch resumeSchedulerAndActions];
        for (CCNode *c in [ch children]) {
            [c resumeSchedulerAndActions];
            for (CCNode *c_ in [c children]) {
                [c_ resumeSchedulerAndActions];
                for (CCNode *c__ in [c_ children]) {
                    [c__ resumeSchedulerAndActions];
                    for (CCNode *c___ in [c__ children]) {
                        [c___ resumeSchedulerAndActions];
                        
                    }
                    
                }
                
            }
        }
    }
    
    
}

-(void)GAME_PAUSE{
    
// PAUSE 
    
    if (pause) {
        return;
    }
    
    pause = true;
    
    [self unschedule:@selector(GAME_PAUSE)];

//
    
    
    [self pauseSchedulerAndActions];

    for (CCNode *ch in [self children]) {
        [ch pauseSchedulerAndActions];
        for (CCNode *c in [ch children]) {
            [c pauseSchedulerAndActions];
            for (CCNode *c_ in [c children]) {
                [c_ pauseSchedulerAndActions];
                for (CCNode *c__ in [c_ children]) {
                    [c__ pauseSchedulerAndActions];
                    for (CCNode *c___ in [c__ children]) {
                        [c___ pauseSchedulerAndActions];
                        
                    }
                    
                }

                
            }
        }
    }
    
    
}

-(void)letsPlay
{
    tutorial = NO;
}

- (id)initWithHUD:(InGameButtons *)hud
{
	if( (self=[super init])) {
        _hud = hud;
        
        Cristal*cris = [[[Cristal alloc] initWithRect:CGRectMake(0, 0, kWidthScreen, kHeightScreen)] autorelease];
        
        cris.anchorPoint = ccp(0,0);
        cris.position = [self convertToNodeSpace:ccp(0, 0)];
        [self addChild:cris z:2 tag:55];

        [self addBatchNode];
        cristalCount = 0;
        brainCount = 0;
        speed = 0.35f;
        count = 0;
        m_state = STATE_NORMAL_;
        
        doorIsOpen = false;
        canShowTut = YES;
        canTouchHEADS = NO;
        gearHit = false;
        itsBrain = NO;
        brain1IsTouched = false;
        brain2IsTouched = false;
        
        [self addSprite];
        [self addBrains];
        [self scheduleUpdate];
        [self schedule:@selector(reorderChild) interval:0.005f];
        self.isTouchEnabled = YES;
        //[self addBall];
        [self addDoorsGears];
        tutorial = YES;
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.5f],[CCCallFunc actionWithTarget:self selector:@selector(letsPlay)], nil]];
        if (_hud.tutorialSHOW)
        {
            pause = YES;
            [self schedule:@selector(GAME_PAUSE) interval:0.1f];
        }
        [self brainJump];
        [_hud TIME_Pause];
    }
	return self;
}

-(id)getNode{
    
    return [Level4 node];
    
}

- (void) dealloc
{
	[super dealloc];
}

@end