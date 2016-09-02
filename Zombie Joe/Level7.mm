#import "Level7.h"
#import "cfg.h"
#import "Constants.h"
#import "constants_l7.h"
#import "SceneManager.h"
#import "BrainsBonus.h"
#import "Aligator.h"
#import "CCFollowDynamic.h"
#import "Tutorial.h"


#define LAYER_TAG 10101

#define TAG_FINISH_LINE 999

@implementation Level7
@synthesize CHARACTER_GO;

#pragma mark DELEGATE METHODS

-(id)getNode{
    
    return [Level7 node];
    
}

-(void)gameStateEnded{
    
  //  NSLog(@"level passed");
    
}

- (id)initWithHUD:(InGameButtons *)hud
{
    if ((self = [super init])) {
        _hud = hud;
        
        self.isTouchEnabled = YES;
        self.tag = LAYER_TAG;
        //add top buttons with delegates

    //    [self addBottom];

    //   [cfg addInGameButtonsFor:self];
        
        
        
        par = [CCNode node];
        [self addChild:par];
        
        [self addBG_forNode:par withCCZ:@"BG_level7" bg:@"background.jpg"];
        
        [self createSprites];
        
         [_hud preloadBlast_self:self brainNr:3 parent:par];
        
         [_hud BRAIN_:TAG_BRAIN_1 zOrder:10 parent:par];
         [_hud BRAIN_:TAG_BRAIN_2 zOrder:10 parent:par];
         [_hud BRAIN_:TAG_BRAIN_3 zOrder:10 parent:par];
        
        [self addRotateBlocks];
        
        [self addEnemies];
        
        [self charactertBorn];
     
        alive = YES;
        
      //  self.scale = 1.05f;
   
       // [self performSelector:@selector(canMoveSelf) withObject:nil afterDelay:3.f];
        
        if (_hud.tutorialSHOW)
        {
            PAUSED = YES;
            [self schedule:@selector(GAME_PAUSE) interval:0.1f];
        }
        
        [self schedule:@selector(update:)];
        
        
        
        float fix;
        
            if (IS_IPAD)
            {
                fix = 0;
            }
        else if (IS_IPHONE)
        {
          
        if (IS_IPHONE_5) fix = -110;
            
              else  if (IS_IPHONE)
              {
                    fix = 43;
              }
            
        }
                
        [par  runAction:[CCFollowDynamic actionWithTarget:CHARACTER_GO
                                            worldBoundary:CGRectMake(0,0,(ScreenSize.width*2)+(fix),ScreenSize.height) smoothingFactor:0.05f nodePlace:0.25f]];
        
        [self addFinishLineAtPos:ccp((ScreenSize.width*2)+(fix),ScreenSize.height/2)];
        

        if (![Combinations checkNSDEFAULTS_Bool_ForKey:C_TUTORIAL_(_hud.level)])
        {
            [cfg runSelectorTarget:self selector:@selector(showTut_7) object:nil afterDelay:1 sender:self];
        }
       
        
        //[self preloadBlast];
        
      //  [self runAction:[CCFollow actionWithTarget:CHARACTER_GO
        //                             worldBoundary:CGRectMake(0,0,ScreenSize.width*2.5f,ScreenSize.height)]];
     
	}
	return self;
}

-(void)showTut_7{
    
    Tutorial *tut = [[[Tutorial alloc]init]autorelease];
    tut.position = ccp(kWidthScreen/2, kHeightScreen/2);
    [_hud addChild:tut z:0 tag:3353];
    [tut TAP_TutorialRepeat:1 delay:0.3f runAfterDelay:1.4f];
    
}

//-(void)preloadBlast_self(CCNode*)self_ parent:(CCNode*)parent_{
//    
//    [self addChild:[[[JoeZombieController alloc]initBlastOnly_Parent:par]autorelease]z:100 tag:TAG_BLAST];
//    
//}
//
//-(void)makeBlastInPosFromSelf:(CCNode*)self_ position:(CGPoint)pos_{
//    
//    [(JoeZombieController*)[self_ getChildByTag:TAG_BLAST] showKillBlastEffectInPosition:CHARACTER_GO.position];
//    
//}

-(void)GAME_RESUME{
    
    PAUSED = false;
    
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
    
    if (PAUSED) {
        return;
    }
    
    PAUSED = true;
    
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

-(void)addFinishLineAtPos:(CGPoint)pos_{
    
    CCSprite *blackBoard = [[[CCSprite alloc]init]autorelease];
    
    [blackBoard setTextureRect:CGRectMake(0, 0, 50,
                                          kHeightScreen)];
    blackBoard.position = pos_;
    blackBoard.opacity = 0;
    blackBoard.anchorPoint = ccp(0.5f,0.5f);
    [par addChild:blackBoard z:0 tag:999];
    blackBoard.color = ccRED;
    blackBoard.tag = 999;
    
}


-(void)canMoveSelf{
    
    moveSelf = YES;
    
}

-(void)createSprites{
    
    NSString *spritesStr =      [NSString stringWithFormat:@"sprites_level7_iPhone"];
    if (IS_IPAD) spritesStr =   [NSString stringWithFormat:@"sprites_level7"];
    
    spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz",spritesStr]];
    [par addChild:spritesBgNode z:1];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache]
     addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist",spritesStr]];
    
}

-(void)addBG_forNode:(CCNode*)node_ withCCZ:(NSString*)ccz_ bg:(NSString*)bg_{
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
    
    if (IS_IPHONE) {
        ccz_ = [NSString stringWithFormat:@"%@_iPhone",ccz_];
    }
    
    CCSpriteBatchNode *spritesBgNodeBG;
    
    spritesBgNodeBG = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz",ccz_]];//@"bg_level1.pvr.ccz"];
    [node_ addChild:spritesBgNodeBG];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist",ccz_]];

    background = [CCSprite spriteWithSpriteFrameName: bg_];
    background.position = ccp(0,0);
    
    background.scale = kSCALE_FACTOR_FIX;
    
//    if (IS_IPHONE) {
//        if (!IS_IPHONE_5) {
//            background.position = ccpAdd(background.position, ccp(-86,0));
//        }
//    }
    
    background.anchorPoint = ccp(0,0);
    [spritesBgNodeBG addChild:background z:0];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
}

-(void)moveAllObjectsLeft{
    
    for (CCSprite *sprites in [self children]) {
        
        // sprites.position=ccpAdd(self.position, ccp(self.position.x+100,self.position.y));
        if (sprites.tag !=kMENUBUTTONSTAG) {
                [sprites runAction:[CCMoveBy actionWithDuration:3 position:ccp(-100, self.position.y)]];
        }
    
        
    }
    
}

-(void)addRotateBlocks{
    
    int brains = 0;
    
    for (int x = 0; x < kNrOfBlocks; x++) {
   //     NSLog(@"x :%i",x);
        CGPoint pos;
        
        switch (x) {
            case 0:
                pos = CGPointMake(kWidthScreen*0.1f, kHeightScreen*0.09f);
                break;
            case 1:
                if (IS_IPHONE_5){
                    
                    pos = CGPointMake(kWidthScreen*0.06f, kHeightScreen*0.8f);
                    
                }
               else pos = CGPointMake(kWidthScreen*0.114f, kHeightScreen*0.835f);  //brains #1
                
                break;
            case 2:
                if (IS_IPAD) {
                    pos = CGPointMake(kWidthScreen*0.3f, kHeightScreen*0.3f);
                }
                else if (IS_IPHONE)
                {
                    if (IS_IPHONE_5)
                    {
                        pos = CGPointMake(kWidthScreen*0.25f, kHeightScreen*0.35f);
                    }
                    else
                    pos = CGPointMake(kWidthScreen*0.325f, kHeightScreen*0.38f);
                    
                }

                break;
            case 3:
                pos = CGPointMake(-kWidthScreen, kHeightScreen*10);    //NOT USED ONE
                break;
            case 4:
                if (IS_IPHONE_5)
                {
                    pos = CGPointMake(kWidthScreen*0.45f, kWidthScreen*0.125f);
                }
                else {
                    pos = CGPointMake(kWidthScreen*0.55f, kWidthScreen*0.155f);
                }
                break;
            case 5:
                pos = CGPointMake(kWidthScreen*0.825f, kHeightScreen*0.875f);
                break;
            case 6:
                pos = CGPointMake(kWidthScreen*0.925f, kHeightScreen*0.3f);
                break;
            case 7:
                if (IS_IPAD) {
                    pos = CGPointMake(kWidthScreen*1.15f, kHeightScreen*0.5f);  //
                }
                else if (IS_IPHONE){
                    if  (IS_IPHONE_5) {
                        pos = CGPointMake(kWidthScreen*1.10f, kHeightScreen*0.5f);  //
                    }
                    else {
                        pos = CGPointMake(kWidthScreen*1.25f, kHeightScreen*0.5f);  //
                    }
                }
                
                break;
            case 8:
                
                if (IS_IPHONE_5) {
                     pos = CGPointMake(kWidthScreen*1.3f, kHeightScreen*0.5f);
                }
                else pos = CGPointMake(kWidthScreen*1.6f, kHeightScreen*0.5f);
                break;
            case 10:
                
                if (IS_IPHONE) {
                    if (IS_IPHONE_5) {
                        pos = CGPointMake(kWidthScreen*1.25f, kHeightScreen*0.1f);
                    }
                    else pos = CGPointMake(kWidthScreen*1.55f, kHeightScreen*0.1f);   //brains
                }
                else if (IS_IPAD){
                     pos = CGPointMake(kWidthScreen*1.515f, kHeightScreen*0.088f);   //brains
                }
             
                break;
                    
            default:
                pos = CGPointMake(-100, -100);
                break;
        }
        
        
        
        rotateBlock *block = [[rotateBlock alloc]
                              initWithRect:CGRectMake(pos.x,pos.y, kRotateBlockW, kRotateBlockH) tag:kBlockTag+x];
        

        
        if (IS_IPHONE) {
            if (IS_IPHONE_5) {
                block.position = ccpAdd(block.position, ccp(30, 5));
            }
            else pos = ccp(pos.x+86.f, pos.y);   //iphone
        }
        else if (IS_IPAD){
            
             block.position = ccpAdd(block.position, ccp(0, 0));

        }
      
        [par addChild:block z:1];
        
         [self addWaveForRock:block];
        
        if (x==1 || x == 10 || x == 2)
        {
         //   BrainsBonus *BRAIN = [[BrainsBonus alloc]initWithRect:CGRectMake(100, 100, 100, 100)];
            
            CCSprite *BRAIN = (CCSprite*)[par getChildByTag:TAG_BRAIN_1+brains];
             BRAIN.position = block.position;
            if (x==2) {
                if (IS_IPHONE) {
                    if (IS_IPHONE_5) {
                          BRAIN.position = ccp(kWidthScreen*1.6f, kHeightScreen*0.7f);
                    }
                    else   BRAIN.position = ccp(kWidthScreen*1.95f, kHeightScreen*0.7f);
                }
                else if (IS_IPAD)   BRAIN.position = ccp(kWidthScreen*1.8f, kHeightScreen*0.6f);
              
            }
           BRAIN.tag = TAG_BRAIN_1+brains;
            brains++;
         //   [par addChild:BRAIN z:1];
           // [BRAIN moveUpDown_particles:NO];
          //  BRAIN.scale = 1.25f;
           // NSLog(@"brains %i",brains);
        }
    }
}


-(void)addWaveForRock:(CCNode*)node_{
    
    CCSprite *wave = [CCSprite spriteWithSpriteFrameName:@"wave.png"];
    [par addChild:wave z:0];
    wave.position = node_.position;
    wave.scale = 0;
    
    int f = [cfg MyRandomIntegerBetween:1 :3];
    
    id scaleUP =[CCScaleTo actionWithDuration:f scale:1.5f*(kSCALE_FACTOR_FIX)];
    
    id fadeOut =[CCFadeTo actionWithDuration:f opacity:0];
    
    id scaleDOWN=[CCScaleTo actionWithDuration:0.f scale:0];
    id fadeIn =[CCFadeTo actionWithDuration:0.f opacity:255];
    
    id sp1 = [CCSpawn actions:scaleUP,fadeOut, nil];
    id sp2 = [CCSpawn actions:scaleDOWN,fadeIn, nil];
    
    id seq = [CCSequence actions:sp1,sp2, nil];
    id fr = [CCRepeatForever actionWithAction:seq];
    
    [wave runAction:fr];
    
}

-(void)enemmyFallow{
    
    for (int x = 0; x <= maxCrocodiles; x++)
    {
        
        CGPoint p1 = [par getChildByTag:kAligator+x].position;
        CGPoint p2 = CHARACTER_GO.position;
        
        CGFloat f = [self pointPairToBearingDegrees:p1 secondPoint:p2];
        
        
        [par getChildByTag:kAligator+x].rotation=270-f;
        
//        if ([par getChildByTag:kAligator+x].rotation == 180-f) {
//            [par getChildByTag:kAligator+x].rotation = 180-f;
//        }
        
    }

    
}

-(void)addEnemies{
    int max = maxCrocodiles;
    for (int x = 0;x <=max; x++) //6 enemies
    {
            Aligator *enemy = [[Aligator alloc]initWithRect:CGRectMake(100, 100, 0, 0)];
        
        if       (x == 0) {
            enemy.position =  CGPointMake(kWidthScreen*0.8f, kHeightScreen*0.55f);
        }
        else if  (x == 1){
            enemy.position =  CGPointMake(kWidthScreen*0.5f, kHeightScreen*0.7f);
        }
        else  if (x == 2){
            if (IS_IPHONE_5) {
                 enemy.position =  CGPointMake(kWidthScreen*1.05f, kHeightScreen*0.85f);
            }
            else
            enemy.position =  CGPointMake(kWidthScreen*1.15f, kHeightScreen*0.9f);
            
            if (IS_IPAD) {
                 enemy.position =  CGPointMake(kWidthScreen*1.1f, kHeightScreen*0.85f);
            }
        }
        else  if (x == 3){
            if (IS_IPHONE) {
                if (IS_IPHONE_5) {
                    enemy.position  = CGPointMake(kWidthScreen*1.15f, kHeightScreen*0.225f);
                }
                else enemy.position  = CGPointMake(kWidthScreen*1.2f, kHeightScreen*0.225f);
            }
      
         else if(IS_IPAD) enemy.position  = CGPointMake(kWidthScreen*1.3f, kHeightScreen*0.23f);
            
            
        }
        else  if (x == 4){
            if (IS_IPHONE) {
                if (IS_IPHONE_5) {
                    enemy.position  = CGPointMake(kWidthScreen*1.525f, kHeightScreen*0.275f);
                }
                else enemy.position  = CGPointMake(kWidthScreen*1.75f, kHeightScreen*0.3f);
                
            }
            else if (IS_IPAD) {
                     enemy.position  = CGPointMake(kWidthScreen*1.8f, kHeightScreen*0.275f);  //not visible on ip5
                }
           
        }
        else  if (x == 5){
            if (IS_IPHONE) {
                if (IS_IPHONE_5) {
                    enemy.position  = CGPointMake(kWidthScreen*1.4f, kHeightScreen*0.75f);
                }
                else enemy.position  = CGPointMake(kWidthScreen*1.5f, kHeightScreen*0.7f);
            }
            else
                if (IS_IPAD) {
                     enemy.position  = CGPointMake(kWidthScreen*1.5f, kHeightScreen*0.7f);
                }
           
        }
            enemy.tag = kAligator+x;
           // NSLog(@"aligator tag %i",enemy.tag);
//        if (IS_IPHONE_5 && x== 4) {
//            continue;
//        }
            [par addChild:enemy];
        
      
        
        if (IS_IPHONE) {
            if (IS_IPHONE_5) {
                enemy.position = ccpAdd(enemy.position, ccp(20, 0));
            }
            else   enemy.position = ccp(enemy.position.x+86.f, enemy.position.y);   //iphone
        }
        else if (IS_IPAD){
            
            enemy.position = ccpAdd(enemy.position, ccp(0, 0));
            
        }
        
        if (IS_IPHONE)
        {
            enemy.scale = 0.8f;
            if (![Combinations isRetina]) {
                enemy.scale = 0.55f;
            }
        }
        else if (IS_IPAD) {
            enemy.scale = kSCALE_FACTOR_FIX;
        }
        
     [enemy chillAction];
            
        
//        [enemy runAction:[CCRotateTo actionWithDuration:1.f angle:180-f]];
//        
//       // enemy.rotation = f;
//        
//        NSLog(@"angle %f",f);
        
    }
    
  //  [self schedule:@selector(enemmyFallow:)];

    
}


- (CGFloat) pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint) endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
    float bearingDegrees = bearingRadians * (180.0 / M_PI); // convert to degrees
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)); // correct discontinuity
    return bearingDegrees;
}

-(void)charactertBorn{
    
    CHARACTER_GO = [[GoinCharacter alloc]initWithRect:CGRectMake(0, 0,
                                         characterW*0.1f, characterH*0.05f)
                                                  tag:kCHARACTERTAG];
    
    [par addChild:CHARACTER_GO z:2];
    
    [CHARACTER_GO hide_shadow:NO];
     CHARACTER_GO.position =[par getChildByTag:kBlockTag].position;
    [CHARACTER_GO Action_IDLE_SetDelay:0.3f funForever:YES];
    [CHARACTER_GO drawForwardArrow];
  
}

-(CGRect)getItemRect:(int)x{
    
    float rectOffsetW = [[par getChildByTag:x]boundingBox].size.width;
    float rectOffsetH = [[par getChildByTag:x]boundingBox].size.height;

    
    CGRect itemBoundingBox = [[par getChildByTag:x] boundingBox];
    
    CGRect itemRect = CGRectMake(itemBoundingBox.origin.x-rectOffsetW/2, itemBoundingBox.origin.y-rectOffsetH/2,
                                 itemBoundingBox.size.width-rectOffsetW, itemBoundingBox.size.height-rectOffsetH);
    
    return itemRect;
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (jumping) {
        return NO;
    }
    
    if (!alive || WINLEVEL)
    {
        return NO;
    }
    
    if (!enableJUMP) {
        return NO;
    }
    
    [AUDIO playEffect:joe_s_jump];
    [self jump];
   
    firstJump = YES;
    
   // moveSelf = YES;
    return YES;
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

-(CGRect)ifTouchedONSIZEDRECT:(CCNode*)node_ resizedTimes:(float)times{
    
    CGRect f = [node_ boundingBox];
    f.size.width = f.size.width*times;
    f.size.height = f.size.height*times;
    f.origin.x = f.origin.x - f.size.width/2;
    f.origin.y = f.origin.y - f.size.height/2;
    return f;
    
}

-(void)checkForBrainCollision{
    
    if ([self rect:[par getChildByTag:TAG_BRAIN_1].boundingBox collisionWithRect:CHARACTER_GO.boundingBox] && !brain1)
    {
        brain1 = YES;
        [cfg makeBrainActionForNode:[par getChildByTag:TAG_BRAIN_1] fakeBrainsNode:nil direction:0 pixelsToMove:100 time:0.4f parent:par removeBrainsAfter:YES makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
    }
   else if ([self rect:[par getChildByTag:TAG_BRAIN_1+1].boundingBox collisionWithRect:CHARACTER_GO.boundingBox] && !brain2 )
    {
         brain2 = YES;
         [cfg makeBrainActionForNode:[par getChildByTag:TAG_BRAIN_1+1] fakeBrainsNode:nil direction:270 pixelsToMove:100 time:0.4f parent:par removeBrainsAfter:YES makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
    }
   else if ([self rect:[par getChildByTag:TAG_BRAIN_1+2].boundingBox collisionWithRect:CHARACTER_GO.boundingBox] && !brain3)//(CGRectContainsPoint([par getChildByTag:TAG_BRAIN_1+2].boundingBox, CHARACTER_GO.position) && !brain3)
    {
        brain3 = YES;
         [cfg makeBrainActionForNode:[par getChildByTag:TAG_BRAIN_1+2] fakeBrainsNode:nil direction:180 pixelsToMove:100 time:0.4f parent:par removeBrainsAfter:YES makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
    }
    
  //  }
    
}

-(float)giveRotationAngleByTheRockOnNow:(int)x_{
    
     rotateBlock *rot = (rotateBlock*)[par getChildByTag:x_];
    
    float rotation = CHARACTER_GO.rotation;
    
    int rotDirection = [rot directionToRotate];
    float speed =      [rot giveSpeedOfRotation];
    
    if (rotDirection==-1)
    {
        rotation-=speed;
        
        if (rotation <0)
        {
            rotation = 360;
        }
        
    }
    if (rotDirection==1)
    {
        rotation+=speed;
        
        if (rotation >=360)
        {
            rotation = 0;
        }
        
    }

    return rotation;
    
}

-(void)jumpOnRockAction_rockTag:(int)x_{
    
    float originalScale = [par getChildByTag:x_].scale;
    
    id rockScale = [CCScaleTo actionWithDuration:0.05f scale:originalScale-0.15f];
    
    id r_reScale = [CCScaleTo actionWithDuration:0.1f scale:originalScale];
    
    id ease= [CCEaseInOut actionWithAction:r_reScale rate:3];
    
    id seq = [CCSequence actions:rockScale,ease, nil];
    
    [[par getChildByTag:x_] runAction:seq];
    
    [CHARACTER_GO runAction: [CCSequence actions:
                              [CCScaleTo actionWithDuration:0.1f scale:CHARACTER_GO.scale-0.4f],
                              [CCScaleTo actionWithDuration:0.05f scale:1], nil]].tag = 111;
    
}

-(void)finishLineCheck{
    
    
    
}

-(void)update:(ccTime)dt{
    
    PAUSED = NO;
    
    if (!alive || WINLEVEL)
    {
        return;
    }
    
       [self checkForBrainCollision];
    
    if (CGRectContainsPoint([[par getChildByTag:TAG_FINISH_LINE] boundingBox],CHARACTER_GO.position) && !WINLEVEL)
    {
        WINLEVEL = YES;
         [AUDIO playEffect:fx_winmusic];
        
        for (int x = kAligator; x <= kAligator+maxCrocodiles; x++)
        {
            Aligator *aligator = (Aligator*)[par getChildByTag:x];
            [aligator chillAction];
            [aligator swallowedZombie];
        }
       // [_hud performSelector:@selector(WINLevel) withObject:nil afterDelay:1.f];
        [cfg runSelectorTarget:_hud selector:@selector(WINLevel) object:nil afterDelay:1.f sender:self];
       // [_hud WINLevel];
        [_hud TIME_Stop];
        [CHARACTER_GO hideArrows];
    }
    
 
    
    
    for (int x = kBlockTag; x < kBlockTag+kNrOfBlocks; x++)
    {

       // if (CGRectContainsPoint([[par getChildByTag:x] boundingBox],CHARACTER_GO.position) && !moveToBlock)
        //if (CGRectContainsPoint([self getItemRect:x],CHARACTER_GO.position) && !moveToBlock)
        if (ccpDistance([par getChildByTag:x].position, CHARACTER_GO.position) <= [par getChildByTag:x].boundingBox.size.width*0.5)
        {

            if (x !=onBlockTag) //**** if not the same block Joe is standing now
            {   
                jumping = NO;
                [CHARACTER_GO stopAllActions];
                if (!moveToBlock)
                {
                    moveToBlock = YES;
                    enableJUMP = NO;
                    
                    if (CHARACTER_GO.position.x > kWidthScreen/2)
                    {
                        [Combinations saveNSDEFAULTS_Bool:YES forKey:C_TUTORIAL_(_hud.level)];
                    }
                    
                    id move = [CCMoveTo actionWithDuration:0.125f position:[par getChildByTag:x].position];
                 //   id move_ = [CCEaseSineInOut actionWithAction:move];
                    id enableMove = [CCCallBlock actionWithBlock:^(void){moveToBlock = NO;}];
                    id jumpOn = [CCCallBlock actionWithBlock:^(void) {
                        [self jumpOnRockAction_rockTag:x];
                        enableJUMP = YES;
                    }];
                    id seq = [CCSequence actions:move,jumpOn,enableMove, nil];
                    [CHARACTER_GO runAction:seq].tag = 1114;
                    
                   // return;
                }
            }
            
             onBlockTag = x;
            
            if (!jumping)
            {
                CHARACTER_GO.rotation = [self giveRotationAngleByTheRockOnNow:x];
                
                if (!moveToBlock)
                {
                    CHARACTER_GO.position = [par getChildByTag:x].position;
                }
                
            }
    
        }
    }
    
    //***** Enemy
    
    [self enemmyFallow];
    
        for (int x = kAligator; x <= kAligator+maxCrocodiles; x++)
        {
            Aligator *aligator = (Aligator*)[par getChildByTag:x];
            
            if (jumping && alive)
            {
                if (ccpDistance(CHARACTER_GO.position, aligator.position) < kWidthScreen*0.2f) {
                    [aligator openMouth];
                }
    
                
                [CHARACTER_GO hideArrows];
            }
            
            else if (!jumping)
            {
              //  aligatorSound = NO;
                [aligator closeMoutH];
                [CHARACTER_GO showArrows];
            }
            
            if (CGRectContainsPoint([par getChildByTag:x].boundingBox, CHARACTER_GO.position))
            {
   
                [_hud makeBlastInPosposition:CHARACTER_GO.position];
                [CHARACTER_GO colorAllBodyPartsWithColor:ccc3(220, 72, 72) restore:YES restoreAfterDelay:0.15f];
                alive = NO;
                [aligator swallowedZombie];
                [self deadhActionWithCroco:aligator];
                [aligator closeMoutH];
                [CHARACTER_GO hideArrows];
                
            }
            
        }
}

-(void)deadhActionWithCroco:(Aligator*)aligator{
    
   
    //alligator caught zombie
    [CHARACTER_GO stopAllActions];
//    [self unschedule:@selector(enemmyFallow:)];
   // [aligator closeMoutH];
    
    [aligator chillAction];
    [CHARACTER_GO stopHatAction];
    jumping = NO;
    [par reorderChild:CHARACTER_GO z:0];
    [par reorderChild:aligator z:1];
    
    id scaleCroc = [CCScaleTo actionWithDuration:0.1f scale:aligator.scale + 0.1f];
    [aligator runAction:scaleCroc];
    
    [self killedByCroco:aligator];
    alive = NO;
       [CHARACTER_GO hideArrows];
    [cfg runSelectorTarget:_hud selector:@selector(LOSTLevel) object:nil afterDelay:0.5f sender:self];
    
    for (int x = kAligator; x <= kAligator+maxCrocodiles; x++)
    {
        Aligator *aligator = (Aligator*)[par getChildByTag:x];
        [aligator chillAction];
        [aligator swallowedZombie];
    }
    
  //  [_hud performSelector:@selector(LOSTLevel) withObject:nil afterDelay:0.5f];
    
}

-(void)killedByCroco:(Aligator*)ali_{

    [self unscheduleAllSelectors];
        
    id scaleDown = [CCScaleBy actionWithDuration:0.2f scale:0];
    id move =[CCMoveTo actionWithDuration:0.2f position:ali_.position];
    id move_ease = [CCEaseSineIn actionWithAction:[[move copy] autorelease]];
    //id move_ease_rev = [CCEaseSineInOut actionWithAction:[[scaleUp copy] autorelease]];
    id seq = [CCSequence actions:scaleDown,move_ease, nil];
    
    [CHARACTER_GO runAction:seq];
    [ali_ chillAction];
    
}

-(void)checkIfISurvived{
    
    if (WINLEVEL) {
        return;
    }
    
    BOOL living = NO;
    


    
    for (int x = kBlockTag; x < kBlockTag+kNrOfBlocks; x++)
    {
        if (CGRectContainsPoint([self getChildByTag:x].boundingBox, CHARACTER_GO.position)){
            
            living = YES;
            break;
            
        }
    }
    
    

    
     if (CHARACTER_GO.position.y > kHeightScreen || CHARACTER_GO.position.y < 0) {
        //  [_hud LOSTLevel];
        living = NO;
    }
    else if (CHARACTER_GO.position.x < 0) {
        living = NO;
        //   [_hud LOSTLevel];
    }
   // return;
    
    if (living) {
    //    NSLog(@"alive");
    }
    else {
     //   NSLog(@"PROBABLY dead");
         living = NO;
        [_hud LOSTLevel];
      //  [SceneManager restartLevel:[Level7 node]];
    }
    
}

-(void)jump{
    
    repositionScreen = NO;
    
    int distance = kWidthScreen*1.f;
    
    CGPoint destination  = ccp(distance*(cos(-CC_DEGREES_TO_RADIANS(CHARACTER_GO.rotation))),
                               distance*(sin(-CC_DEGREES_TO_RADIANS(CHARACTER_GO.rotation))));
    
    //

    id block =  [CCCallBlock actionWithBlock:^(void)
                 {
                     jumping = YES;
                 }];
    
    id jump =     [CCMoveBy actionWithDuration:1.25f position:destination];
    
    id jump_ = [CCEaseElastic actionWithAction:jump period:1.f];
    
    id scaleUp = [CCScaleTo actionWithDuration:0.2f scale:1.5f];
    
    //id easeJump = [CCEaseInOut actionWithAction:jump rate:1.f];
    
    id scaleDown = [CCScaleTo actionWithDuration:1.f scale:0.9f];
    
    id scaleSeq = [CCSequence actions:scaleUp,scaleDown, nil];
    
     id sp = [CCSpawn actions:jump_,scaleSeq, nil];
    

    
    id unblock =  [CCCallBlock actionWithBlock:^(void)
                   {
                       jumping = NO;
                       [self checkIfISurvived];
                      
                   }];
    
    id seq =     [CCSequence actions:block,
                  
                  sp,
                  
                  unblock, nil];
    
    [CHARACTER_GO runAction: seq];
    
}

- (void) dealloc
{
    [CHARACTER_GO release];
    CHARACTER_GO = nil;
	[super dealloc];
}


- (void)onEnter{
    
   [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-2 swallowsTouches:YES];
    [super onEnter];
}


- (void)onExit{
    
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [super onExit];
}

@end
