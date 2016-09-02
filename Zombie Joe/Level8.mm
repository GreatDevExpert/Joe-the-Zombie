#import "Level8.h"
#import "cfg.h"
#import "Constants.h"
#import "SceneManager.h"
#import "BrainsBonus.h"
#import "HatSpin.h"
#import "Tutorial.h"

#import "SimpleAudioEngine.h"
#import "SoundManager.h"

#define LAYER_TAG 10101
#define kStartPoint CGPointMake(0,0)

#define ANGLE_DOWN_RIGHT 45
#define ANGLE_UP_RIGHT  (-45)
#define ANGLE_UP_LEFT   (-135)
#define ANGLE_DOWN_LEFT (135)

#define TOP     0
#define RIGHT   1
#define DOWN    2
#define LEFT    3

#define kBlockFirst 100
#define kBlockLast  105

#define kBoxTag 100
#define kBoxTagVISIBLe 800

#define kBLOCK_TOP_WALL     400
#define kBLOCK_DOOR_TOP     401
#define kBLOCK_DOOR_BOTOOM  402
#define kCRYSTAL            403

#define kBRAIN_BLOCKTAG1 27
#define kBRAIN_BLOCKTAG2 11
#define kBRAIN_BLOCKTAG3 18

#define NOT_MOVABLE_1 21
#define NOT_MOVABLE_2 29

#define kDOORSPRITE         501

#define kLASER_TAG 601

#define DIAMONDS_NR (11+(1))

#define TEMP_DIAMOND    700

#define DIAMOND_SCALE 1.05f

#define FLY_ZOMBIE_TAG 889

#define TAG_PARTICLE_BLAST  3000

#define TAG_TUTORIAL 3030

//#define kBRAIN1             500
//#define kBRAIN2             501

@implementation Level8
//@synthesize BLOCKS;
@synthesize lightning;
@synthesize lightning2;
@synthesize pointsArr;
//@synthesize JOE;

#pragma mark DELEGATE METHODS

-(id)getNode{
    
    return [Level8 node];
    
}

-(void)gameStateEnded{
    
    NSLog(@"level passed");
    
}

- (void)draw{
    
//     NSLog(@"b1 b2 b2 %i %i %i",b1,b2,b3);
    
//        glEnable(GL_LINE_SMOOTH);
//        
//        glLineWidth(3.0f);
//        
//        glColor4f(0.8, 1.0, 0.76, 1.0);
    
 //   return;
    
//    if (dragging) {
//        return;
//    }
    
    if (success) {
        return;
    }

    
     if ([pointsArr count] > 1)
     {
       //  NSLog(@"draw line");
            [self removeAlllightinings];
            [self redrawLightinings];
     }
  
 //default debug draw
//    if ([pointsArr count] > 1) {
//   
//        for (int x = 0; x < [pointsArr count]-1; x++) {
//            ccDrawLine([[pointsArr objectAtIndex:x]CGPointValue], [[pointsArr objectAtIndex:x+1]CGPointValue]);
//        }
//    }

    
}

- (id)initWithHUD:(InGameButtons *)hud
{
    if ((self = [super init])) {
        _hud = hud;
        
        pointsArr = [[NSMutableArray alloc]init];
        [pointsArr addObject: [NSValue valueWithCGPoint:CGPointMake(ScreenSize.width/2, ScreenSize.height/2)]];
        
        self.isTouchEnabled = YES;
        self.tag = LAYER_TAG;
        
          CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);

        //add top buttons with delegates
        
        if (IS_IPAD) {
              [cfg addBG_forNode:self withCCZ:@"bg_level8" bg:@"background.jpg"];
        }
        else {
             [cfg addBG_forNode:self withCCZ:@"bg_level8" bg:@"background_iphone.jpg"];
            
        }
        [self spriteNode];
        
        [self addWallTop];
        [self addDoors];
        
     //   [cfg addInGameButtonsFor:self];

        parW = ScreenSize.width*0.925f;
        parH = ScreenSize.height*0.5f;
        
        if (IS_IPHONE_5)
        {
          parH =  ScreenSize.height*0.5f;
        }
        
        parX = ScreenSize.width/2-(parW/2);
        parY = ScreenSize.height/2-(parH/2);
   
      //  [self schedule:@selector(drawLines:) interval:0.25f];
        
        [_hud preloadBlast_self:self brainNr:3 parent:self];
        
        [self addBlockField];
        
        [self preloadParticles];
        
        [self addCharacter];
        
        [self addTempDiamond];
        
        [self addHatObj];
        
        [self drawLines];
        [self redrawLightinings];
        
        letDraw = YES;
        
        [self scheduleUpdate];
        
        
        if (!_hud.tutorialSHOW) {
            [_hud TIME_Pause];
        }
        
        if (_hud.tutorialSHOW)
        {
            PAUSED = YES;
            [self schedule:@selector(GAME_PAUSE) interval:0.1f];
        }
        
        if (![Combinations checkNSDEFAULTS_Bool_ForKey:C_TUTORIAL_(_hud.level)])
        {
        [self  moveOneBlockDemo];
        }
        else   [self letsPlay];//enableTouch = YES;
        
        [[SoundManager sharedManager]playSound:@"lvl14_lazerloop.mp3" looping:YES];
        
       // [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"levelsound3.mp3" loop:YES];
        
        
	}
	return self;
}

-(void)GAME_RESUME{
    
    PAUSED = YES;
    
    if (!tutorial) {
        [_hud TIME_Pause];
        tutorial = YES;
    }
    
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
    
    PAUSED = NO;
    
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

-(void)letsPlay{
    
    [_hud TIME_Resume];
    
    if (!tutorial) {
        tutorial = YES;
    }
    
    [self resetAllPartcilesPoints];
    [self drawLines];
    [self redrawLightinings];
    
    enableTouch = YES;
    
}

-(void)fallowFingerAfterBlock:(ccTime)dt{
    
    //finger.position = [self getChildByTag:3].position;
    
    
}

-(void)moveOneBlockDemo{
    ///move to 122
    /*
    CGPoint dest = [self getChildByTag:122].position;
    
    id move =        [CCMoveTo actionWithDuration:0.5f position:dest];
    
    id blockEnable = [CCCallFuncO actionWithTarget:self selector:@selector(letsPlay)];
    
    id seq =         [CCSequence actions:[CCDelayTime actionWithDuration:1.f],move,blockEnable, nil];
    
    [[self getChildByTag:3] runAction:seq].tag = TAG_TUTORIAL;
    */
    CGPoint dest = [self getChildByTag:122].position;
    
    Tutorial *tut = [[[Tutorial alloc]init]autorelease];
    tut.position = [self getChildByTag:3].position;
    [self addChild:tut z:10 tag:7733];
    
    
    id move =        [CCMoveTo actionWithDuration:0.5f position:dest];
    
    id blockEnable = [CCCallFuncO actionWithTarget:self selector:@selector(letsPlay)];
    
    id seq =         [CCSequence actions:[CCDelayTime actionWithDuration:2.f],move,blockEnable, nil];
    
    [[self getChildByTag:3] runAction:seq].tag = TAG_TUTORIAL;
    [[self getChildByTag:7733] runAction:[CCSequence actions:[CCCallBlock actionWithBlock:^{
        [tut TAP_Special_For_8LVL];
    }],[CCDelayTime actionWithDuration:2.f],[move copy],[CCDelayTime actionWithDuration:0.2f],[CCCallBlock actionWithBlock:^{
        [tut removeFromParentAndCleanup:YES];
    }], nil]];
}

-(void)addHatObj{
    
    HAT = [[HatSpin alloc]initWithRect:CGRectMake(0, 0, 100, 100)];
    [self addChild:HAT];
    HAT.rotation = 170;
    HAT.scale = 0.5f;
    if (IS_IPAD) {
           HAT.position = ccp(kWidthScreen*0.71f, kHeightScreen*0.7975f);
    }
    else if (IS_IPHONE) {
        
        if (IS_IPHONE_5)
        {
              HAT.position = ccp(kWidthScreen*0.68f, kHeightScreen*0.9f);
        }
        else
        HAT.position = ccp(kWidthScreen*0.715f, kHeightScreen*0.9f);
        
    }
 
    
   // [HAT spinHat:0.03f loop:YES];
    
}

-(void)addTempDiamond{
    
    NSString *name = @"diamond.png";
    if (IS_IPHONE) {
        name = @"diamond_iPhone.png";
    }

    CCSprite *sprite = [CCSprite spriteWithFile:name];
    sprite.position = ccp(-sprite.boundingBox.size.width,-sprite.boundingBox.size.height);
    [self addChild:sprite];
    sprite.tag = TEMP_DIAMOND;
    sprite.scale = DIAMOND_SCALE;//0.875;
    sprite.opacity = 125;
    if (![Combinations isRetina])
    {
        sprite.scale = sprite.scale/2;
    }
    
}

-(void)preloadLasers{
    
//    for (int x = 0; x < 30; x++) {
//
//        lightning = [Lightning lightningWithStrikePoint:ccp(0, 0)];
//        lightning.position = ccp(0, 0);
//        lightning.anchorPoint = ccp(0.5f, 0.5f);
//        lightning.color = ccRED;
//        lightning.minDisplacement = 90;
//        lightning.displacement = 100;
//        lightning.draw_ = YES;
//        lightning.tag = 5000+x;
//        [self addChild:lightning];
//    }

    
}

-(void)addCharacter{
    
//   JOE = [[[JOE_C alloc]initWithRect:CGRectMake(0, 0, 100, 100) tag:999]autorelease];
//    [self addChild:JOE];
//    JOE.tag = 999;
//    JOE.position = ccp(kWidthScreen*0.35f, kHeightScreen*0.15f);
//    [JOE Action_IDLE_Setdelay:0.2f funForever:YES];
    
    JOE = [[[JoeZombieController alloc]initWitPos:ccp(0, 0)
                                                     size:CGSizeMake(100,100)]autorelease];
    [self addChild:JOE];
     JOE.tag = 999;
    
    //   [playerImage showMyBox];
    
    JOE.scale = 0.4f;   // 0.5f
    float h = kHeightScreen*0.15f;
    if (IS_IPAD) {
        h = kHeightScreen*0.1285f;
    }
    JOE.position = ccp(kWidthScreen*0.35f, h);

    JOE.anchorPoint = ccp(0.5f, 0.5f);
    [JOE JOE_IDLE];
    
}

-(void)letDraw{
    
    letDraw = YES;
    
}

-(void)addDoors{
    /*
     #define kBLOCK_TOP_WALL     400
     #define kBLOCK_DOOR_TOP     401
     #define kBLOCK_DOOR_BOTOOM  402
     */
    CCSprite *door = [CCSprite spriteWithSpriteFrameName:@"door1.png"];
    door.position = ccp(ScreenSize.width/2,(door.boundingBox.size.height/2)+(door.boundingBox.size.height*0.03f));
    
    if (IS_IPAD && ![Combinations isRetina]) {
        door.position = ccp(ScreenSize.width/2-(door.boundingBox.size.width*0.1f),(door.boundingBox.size.height*0.2f));
    }
    
    if (IS_IPHONE)
    {
        if ([Combinations isRetina]) {
            door.position = ccp(ScreenSize.width/2,
                                (door.boundingBox.size.height/2)-(door.boundingBox.size.height*0.02f));
        }
        else door.position = ccp(ScreenSize.width/2,
                                 (door.boundingBox.size.height*0.22f));
    }
    
    door.tag = kDOORSPRITE;
    door.scale = kSCALE_FACTOR_FIX;
    [self addChild:door];
    
    //crystal
    CCSprite *crystal = [CCSprite spriteWithSpriteFrameName:@"gem0.png"];
    crystal.position = ccp(door.position.x+(door.boundingBox.size.width*0.485f), door.position.y-(crystal.boundingBox.size.height*0.15f));
    [self addChild:crystal];
    crystal.scale=kSCALE_FACTOR_FIX;
    crystal.tag = kCRYSTAL;
    
    
    
    CCSprite *doorBlockBottom = [[[CCSprite alloc]init]autorelease];
    [doorBlockBottom setTextureRect:CGRectMake(door.position.x, door.position.y, door.boundingBox.size.width*0.90f, door.boundingBox.size.height/2)];
    doorBlockBottom.anchorPoint = ccp(1.f, 0.f);
    doorBlockBottom.position = ccp(door.position.x+(door.boundingBox.size.width/2), door.position.y-(doorBlockBottom.boundingBox.size.height));
    [self addChild:doorBlockBottom];
    doorBlockBottom.tag = kBLOCK_DOOR_BOTOOM;
    doorBlockBottom.opacity = 0;
    doorBlockBottom.color = ccRED;
    
    CCSprite *doorBlockTop = [[[CCSprite alloc]init]autorelease];
    [doorBlockTop setTextureRect:CGRectMake(door.position.x, door.position.y, door.boundingBox.size.width*0.65f, door.boundingBox.size.height/2)];
    doorBlockTop.anchorPoint = ccp(1.f, 0.f);
    doorBlockTop.position = ccp(door.position.x+(door.boundingBox.size.width/2), doorBlockBottom.position.y+(doorBlockTop.boundingBox.size.height));
    [self addChild:doorBlockTop];
    doorBlockTop.opacity = 0;
    doorBlockTop.tag = kBLOCK_DOOR_TOP;
    doorBlockTop.color = ccRED;
    
}

-(void)addWallTop{
    
    CCSprite *wall = [CCSprite spriteWithSpriteFrameName:@"wall.png"];
    
    wall.position = ccp(ScreenSize.width/2+(wall.boundingBox.size.width*0.2f),
                        ScreenSize.height-(wall.boundingBox.size.height/2)+(wall.boundingBox.size.height*0.25f));
    
    if (IS_IPAD && ![Combinations isRetina]) {
        wall.position = ccp(ScreenSize.width/2,
                            ScreenSize.height-(wall.boundingBox.size.height/2)+(wall.boundingBox.size.height*0.30f));
    }
    
    if (IS_IPHONE) {
        if (IS_IPHONE_5) {
            wall.position = ccp(ScreenSize.width/2+(wall.boundingBox.size.width*0.2f),
                                ScreenSize.height-(wall.boundingBox.size.height/2)+(wall.boundingBox.size.height*0.4f));
        }
        else
            if ([Combinations isRetina]){ wall.position = ccp(ScreenSize.width/2+(wall.boundingBox.size.width*0.2f),
                                                              ScreenSize.height-(wall.boundingBox.size.height/2)+(wall.boundingBox.size.height*0.35f));}
            else
            wall.position =
                ccp(ScreenSize.width/2+(wall.boundingBox.size.width*0.2f),
                    ScreenSize.height-(wall.boundingBox.size.height/2)+(wall.boundingBox.size.height*0.5f));
    }
    
    
    wall.scale = kSCALE_FACTOR_FIX;
    [self addChild:wall];
    
    CCSprite *wallBlock = [[[CCSprite alloc]init]autorelease];
    [wallBlock setTextureRect:wall.boundingBox];
    wallBlock.anchorPoint = ccp(0.5f, 0.5f);
    wallBlock.position = wall.position;
    [self addChild:wallBlock];
    wallBlock.opacity = 0;
    wallBlock.color = ccRED;
    wallBlock.tag = kBLOCK_TOP_WALL;
   // wallBlock.scale = kSCALE_FACTOR_FIX;
}

-(void)spriteNode{
    
    NSString *spritesStr =      [NSString stringWithFormat:@"sprites_level8_iPhone"];
    if (IS_IPAD) spritesStr =   [NSString stringWithFormat:@"sprites_level8"];
    
    spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz",spritesStr]];
    [self addChild:spritesBgNode];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache]
     addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist",spritesStr]];
    
}

-(void)brainActionForNode:(CCNode*)node_{
    
//    [cfg makeBrainActionForNode:node_ fakeBrainsNode:nil direction:270 pixelsToMove:100 parent:self removeBrainsAfter:YES makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
    [cfg makeBrainActionForNode:node_ fakeBrainsNode:nil direction:0 pixelsToMove:0.1f time:0.1f parent:self removeBrainsAfter:YES makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
    
}

-(void)openDoorAction{
    
    success = YES;
    
    [self resetAllPartcilesPoints];
    
    [self removeAlllightinings];
    
    [AUDIO playEffect:l14_dooropen];
    
    [[self getChildByTag:kDOORSPRITE] runAction:[CCMoveBy actionWithDuration:2.5f position:ccp(0,-[self getChildByTag:kDOORSPRITE].boundingBox.size.height)]];
    
    [[self getChildByTag:kCRYSTAL] runAction:[CCMoveBy actionWithDuration:2.5f position:ccp(0,-[self getChildByTag:kDOORSPRITE].boundingBox.size.height)]];
    
    //ALL BRAINS 
    
    CCSprite *brain1Spr = (CCSprite*)[self getChildByTag:TAG_BRAIN_1];
    CCSprite *brain2Spr = (CCSprite*)[self getChildByTag:TAG_BRAIN_2];
    CCSprite *brain3Spr = (CCSprite*)[self getChildByTag:TAG_BRAIN_3];
    
   // [brain1Spr removeAllChildrenWithCleanup:YES];
   // [brain2Spr removeAllChildrenWithCleanup:YES];
   // [brain3Spr removeAllChildrenWithCleanup:YES];
    
     CCSprite *brain1Spr_ = (CCSprite*)[self getChildByTag:kBoxTag+kBRAIN_BLOCKTAG1];
     CCSprite *brain2Spr_ = (CCSprite*)[self getChildByTag:kBoxTag+kBRAIN_BLOCKTAG2];
     CCSprite *brain3Spr_ = (CCSprite*)[self getChildByTag:kBoxTag+kBRAIN_BLOCKTAG3];
    
    

   // NSLog(@"b1 b2 b2 %i %i %i",b1,b2,b3);
    
    if (b2)
    {
        id sel = [CCCallFuncO actionWithTarget:self selector:@selector(brainActionForNode:) object:brain1Spr];
        id delay =[CCDelayTime actionWithDuration:0.3f];
        [self runAction:[CCSequence actions:delay,sel, nil]];
         //   [self performSelector:@selector(brainActionForNode:) withObject:brain1Spr afterDelay:0.3f];
    }else   [brain1Spr removeFromParentAndCleanup:YES];
    
    if (b1)
    {
        id sel = [CCCallFuncO actionWithTarget:self selector:@selector(brainActionForNode:) object:brain2Spr];
        id delay =[CCDelayTime actionWithDuration:0.6f];
        [self runAction:[CCSequence actions:delay,sel, nil]];
       // [self performSelector:@selector(brainActionForNode:) withObject:brain2Spr afterDelay:0.6f];
    }else   [brain2Spr removeFromParentAndCleanup:YES];
    
    if (b3)
    {
        id sel = [CCCallFuncO actionWithTarget:self selector:@selector(brainActionForNode:) object:brain3Spr];
        id delay =[CCDelayTime actionWithDuration:0.9f];
        [self runAction:[CCSequence actions:delay,sel, nil]];
       // [self performSelector:@selector(brainActionForNode:) withObject:brain3Spr afterDelay:0.9f];
    }else   [brain3Spr removeFromParentAndCleanup:YES];
    
     [brain1Spr_ removeFromParentAndCleanup:YES];
     [brain2Spr_ removeFromParentAndCleanup:YES];
     [brain3Spr_ removeFromParentAndCleanup:YES];
    
    
    
    [self getChildByTag:TEMP_DIAMOND].visible = NO;
    
    
   // id fadeOut = [CCFadeOut actionWithDuration:1.f];

    
        for (int x = 0; x < 40; x++)
        {
            CCSprite *boxTag = (CCSprite*)[self getChildByTag:kBoxTagVISIBLe+x];
            [boxTag removeFromParentAndCleanup:YES];
        }
    for (int x = 1; x < DIAMONDS_NR; x++)
    {
        CCSprite *boxTag = (CCSprite*)[self getChildByTag:x];
        [boxTag removeFromParentAndCleanup:YES];
    }
    
    [cfg runSelectorTarget:self selector:@selector(zombieWalkToFinish) object:nil afterDelay:1.5f sender:self];
   // [self performSelector:@selector(zombieWalkToFinish) withObject:nil afterDelay:1.5f];
    
}

-(void)zombieWalkToFinish{
    
    if (!success) {
        return;
    }
   
    [[JOE robot_] JOE_WALK_SPEED:2];
   // [JOE Action_WALK_SetDelay:0.2f funForever:YES];
    
    CGPoint zombiePosNext = ccp(kWidthScreen*0.65f, (IS_IPAD) ? kHeightScreen*0.11f : kHeightScreen*0.117f);
    float hatFix = 20;
    if (IS_IPHONE) {
        hatFix*=0.46f;
    }
    
    float hatFiy = 45;
    if (IS_IPHONE) {
        hatFiy*=0.46f;
    }
    
    id move = [CCMoveTo actionWithDuration:3.f position:zombiePosNext];
    id idle = [CCCallBlock actionWithBlock:^(void)
    {
        [JOE JOE_IDLE];
       // [JOE Action_IDLE_Setdelay:0.2f funForever:YES];
    }];
    
    id jump =[CCJumpBy actionWithDuration:2.f
                                 position:ccp(kWidthScreen*.75f, kHeightScreen*.2f)
                                   height:kHeightScreen*0.4f jumps:1];
    
    
       id hat_ =[CCRotateTo actionWithDuration:0.5f angle:0];
       id hat_move = [CCMoveTo actionWithDuration:0.5f
                                         position:ccpAdd(zombiePosNext, ccp(hatFix, hatFiy))];
    
    id hat_scale = [CCScaleTo actionWithDuration:0.5f scale:0.8f];

       id spawn_hat =[CCSpawn actions:hat_,hat_move,hat_scale, nil];
       
        [HAT runAction:[CCSequence actions:[CCDelayTime actionWithDuration:2.5f],spawn_hat, nil]];

        id spin = [CCCallBlock actionWithBlock:^(void)
               {
                   
                      [HAT spinHat:0.03f loop:YES];
                   
                     [[JOE robot_]makeOpacityForPart:9 opacity:0];  // hide hat
                     [[JOE robot_]makeOpacityForPart:12 opacity:0]; //hide propeller
                     [[JOE robot_]ACTION_StopAllPartsAnimations_Clean:YES];
                      [JOE JOE_HANGING_RIGHT];
                      [self schedule:@selector(hatFallowZombie:)];
                     
               }];
    
    id win = [CCCallBlock actionWithBlock:^(void)
               {
                   [AUDIO playEffect:fx_winmusic];
                   [_hud WINLevel];
               }];

    id seq = [CCSequence actions:move,idle,[CCDelayTime actionWithDuration:0.25f],spin,jump,win, nil];
    
    [JOE runAction:seq];
    
    //
    
}

-(void)hatFallowZombie:(ccTime)dt{
    
    float hatFix = 20;
    if (IS_IPHONE) {
        hatFix*=0.46f;
    }
    
    float hatFiy = 45;
    if (IS_IPHONE) {
        hatFiy*=0.46f;
    }
    
    HAT.position = ccp(JOE.position.x+hatFix,JOE.position.y+hatFiy);
    
}

-(void)addBlockField{
    
    /*
    BLOCKS = [[[BlockField alloc]initWithRect:CGRectMake(0, 0, ScreenSize.width*0.95f, ScreenSize.height*0.5)]autorelease];
    [self addChild:BLOCKS];
    BLOCKS.position = ccp(ScreenSize.width/2, ScreenSize.height*0.5f);
    */
    
    float buttonW = parW/11;
    
    int posx = 0;
    int posy = 0;
    
    int diamonds = 1;
    int brains  = 0;
    
    for (int x = 0; x < 40; x++)
    {
        if (x==5 || x == 15 || x == 25 || x == 35) {
            posx++;
        }
        
        if (x==10 || x == 20 || x == 30) {
            posy++;
        }
        
        CCSprite *blackBoard = [[[CCSprite alloc]init]autorelease];
        
        [blackBoard setTextureRect:CGRectMake(0, 0, buttonW,buttonW)];
        blackBoard.position = ccp(posx*buttonW+(buttonW/2)-(posy*(buttonW*11)), (posy*buttonW)+(buttonW/2));
        //fix
        blackBoard.position = ccpAdd(blackBoard.position, ccp(parX, parY));
        
        blackBoard.anchorPoint = ccp(0.5f, 0.5f);
        [self addChild:blackBoard z:0 tag:5];
        //blackBoard.color = ccBLACK;
        
        blackBoard.opacity = 0;
      //  blackBoard.scale = 0.9f;
        blackBoard.tag = kBoxTag+x;
        
        {
            
            CCSprite *blackBoard = [[[CCSprite alloc]init]autorelease];
            
            [blackBoard setTextureRect:CGRectMake(0, 0, buttonW,buttonW)];
            blackBoard.position = ccp(posx*buttonW+(buttonW/2)-(posy*(buttonW*11)), (posy*buttonW)+(buttonW/2));
            //fix
            blackBoard.position = ccpAdd(blackBoard.position, ccp(parX, parY));
            
            blackBoard.anchorPoint = ccp(0.5f, 0.5f);
            [self addChild:blackBoard z:0];
            blackBoard.color = ccBLACK;
            
            blackBoard.opacity = 50;
            blackBoard.scale = 0.9f;
            blackBoard.tag = kBoxTagVISIBLe+x;
          //  NSLog(@"box : %i",kBoxTagVISIBLe+x);
            
        }
        
        posx++;
        
        if (x==kBRAIN_BLOCKTAG1 || x == kBRAIN_BLOCKTAG2 || x == kBRAIN_BLOCKTAG3)
        {
               // BrainsBonus *BRAIN = [[BrainsBonus alloc]initWithRect:CGRectMake(100, 100, 100, 100)];
            CCSprite *BRAIN = (CCSprite*)[self getChildByTag:TAG_BRAIN_1+brains];
                BRAIN.position = blackBoard.position;
              //  BRAIN.tag = BRAIN_BONUS_TAG+brains;
              //  NSLog(@"brain bonus %i", BRAIN_BONUS_TAG+brains);
                brains++;
               // [self addChild:BRAIN];
              //  [BRAIN moveUpDown_particles:NO];
              //  BRAIN.scale = 1.1f;
                //BRAIN.color = ccRED;
            
        }
        
        if (x==     1  ||
            x ==    8  ||
            x ==    25 ||
            x==     30 ||
            x ==    29 ||
            x ==    NOT_MOVABLE_1 ||
            x ==    34 ||
            x ==    19 ||
            x ==    NOT_MOVABLE_2 ||
            x ==    12 ||
            x ==    16){ //23 static
            NSString *name = @"diamond.png";
            if (IS_IPHONE) {
                name = @"diamond_iPhone.png";
            }
            
            if (x==NOT_MOVABLE_1)
            {
                name = (IS_IPAD) ? @"diamond_gray.png" : @"diamond_iPhone_gray.png";    //not movable
                notMovable = diamonds;
            }
           else  if (x==NOT_MOVABLE_2)
            {
                name = (IS_IPAD) ? @"diamond_gray.png" : @"diamond_iPhone_gray.png";    //not movable
                notMovable2 = diamonds;
            }
            CCSprite *sprite = [CCSprite spriteWithFile:name];
            sprite.position = blackBoard.position;
            [self addChild:sprite];
            sprite.tag = diamonds;
            sprite.scale = DIAMOND_SCALE;//0.875;
            if (![Combinations isRetina])
            {
                sprite.scale = sprite.scale/2;
            }
           //23 not movable
            diamonds++;
          
           // NSLog(@"added diamond [TAG :%i]",diamonds);
        }
        
    }
    
}

-(void)removeAlllightinings{
    //
    
    //[self removeAllChildrenWithCleanup:YES];
    
  //  NSLog(@"array children %@",[self children]);
    
    if (!letDraw) {
        return;
    }
    
   // [self resetAllPartcilesPoints]; //reset partciles
    
    BOOL islightining = YES;
    
    while (islightining) {
        
        letDraw = NO;
        
        for (Lightning* childNode in self.children)
        {
       //     if (childNode.tag == kLASER_TAG) {
            if([childNode isKindOfClass:[Lightning class]])//[childNode isKindOfClass:[Lightning class]])
            {
        //     [childNode removeAllChildrenWithCleanup:YES];
             //   [childNode removeFromParentAndCleanup:YES];
          //      NSLog(@"removed");
                [self removeChild:childNode cleanup:NO];
           
            }
                 islightining = NO;
                letDraw = YES;
        }
        
        for (Lightning* childNode in self.children)
        {
            if([childNode isKindOfClass:[Lightning class]])
            {
               // NSLog(@"some left");
                islightining = YES;
               letDraw = NO;
            }
             
        }
    }
        
 //   NSLog(@"array children %@",[self children]);

}

-(void)redrawLightinings{
    
    if (success) {
        return;
    }

    if ([pointsArr count] > 1) {//1) {
        
//        for (int x = 0; x < [pointsArr count]-1; x++) {
//            ccDrawLine([[pointsArr objectAtIndex:x]CGPointValue], [[pointsArr objectAtIndex:x+1]CGPointValue]);
//        }
        
        for (int x = 0; x < [pointsArr count]-1; x++)
        {
//            if ((![pointsArr objectAtIndex:x+1])) {
//                NSLog(@"WARINING OBJECT IS NULLLLL!!! NOT READY");
//                return;
//            }

            int nextX = [[pointsArr objectAtIndex:x+1]CGPointValue].x-([[pointsArr objectAtIndex:x]CGPointValue].x);
            int nextY = [[pointsArr objectAtIndex:x+1]CGPointValue].y-([[pointsArr objectAtIndex:x]CGPointValue].y);
           
            lightning = [Lightning lightningWithStrikePoint:ccp(nextX, nextY)]; 
            lightning.position = [[pointsArr objectAtIndex:x]CGPointValue];
            lightning.anchorPoint = ccp(0.5f, 0.5f);
            lightning.color = ccRED;
            
            /*
            lightning.minDisplacement = 90;
            lightning.displacement = 100;
            */
            lightning.minDisplacement = 1;
            lightning.displacement = 1;
            
            lightning.draw_ = YES;
            //lightning.tag = kLASER_TAG;
            [self addChild:lightning];
            
        }
 
    }
    
}

-(void)drawLines{

    if (success) {
        return;
    }
    
//    for (BOOL drawn = YES; drawn==YES; drawn = [self drawLineWithStartPoint:pointBefore angle:angleNext]) {
//        
//    }
        
   // pointBefore = kStartPoint;//ccp(ScreenSize.width/2, ScreenSize.height/2);
    if (IS_IPAD) {
        pointBefore = ccp(kWidthScreen*0.078f+(30), kHeightScreen*0.775f);//kStartPoint;//ccp(ScreenSize.width/2, ScreenSize.height/2);

    }
    
   else  if (IS_IPHONE) {
        
        if (IS_IPHONE_5) {
            pointBefore = ccp(kWidthScreen*0.165f, kHeightScreen*0.875f);
        }
       
        else pointBefore = ccp(kWidthScreen*0.105f, kHeightScreen*0.875f);
    }
    
    angleNext = 45;//45;//ANGLE_DOWN_RIGHT;
    
    BOOL drawn = YES;
    
    //pointsArr = nil;
    [pointsArr removeAllObjects];

    [pointsArr addObject: [NSValue valueWithCGPoint:pointBefore]];//CGPointMake(ScreenSize.width/2, ScreenSize.height/2)]];
    
    b1 = NO;
    b2 = NO;
    b3 = NO;
    
        CCSprite *brain1Spr = (CCSprite*)[self getChildByTag:kBoxTag+kBRAIN_BLOCKTAG1];
        brain1Spr.color = ccGREEN;
        brain1Spr.opacity = 0;
      //  b1 = NO;
    
    
        CCSprite *brain2Spr = (CCSprite*)[self getChildByTag:kBoxTag+kBRAIN_BLOCKTAG2];
        brain2Spr.color = ccGREEN;
        brain2Spr.opacity = 0;
    //    b2 = NO;
    
        CCSprite *brain3Spr = (CCSprite*)[self getChildByTag:kBoxTag+kBRAIN_BLOCKTAG3];
        brain3Spr.color = ccGREEN;
        brain3Spr.opacity = 0;
     //   b3 =  NO;
    

    
    /*
     #define kBLOCK_TOP_WALL     400
     #define kBLOCK_DOOR_TOP     401
     #define kBLOCK_DOOR_BOTOOM  402
     */
    while (drawn)
    {
        CGPoint val = [self drawLineWithStartPoint:pointBefore angle:angleNext];
    //    NSLog(@"block door :%f %f,%f %f. VAL %f %f",[self getChildByTag:kBLOCK_DOOR_BOTOOM].position.x,[self getChildByTag:kBLOCK_DOOR_BOTOOM].position.y,[self getChildByTag:kBLOCK_DOOR_BOTOOM].boundingBox.size.width,[self getChildByTag:kBLOCK_DOOR_BOTOOM].boundingBox.size.height,val.x,val.y);
//NSLog(@"val %f %f",val.x,val.y);
        
       // [self drawParticlesInPosition:val];
        // DRAW PARTICLE IN POS
        
        [self drawParticlesInPosition:val];
        
        if (laserSTOP)
        {
            drawn = NO;
            [pointsArr addObject: [NSValue valueWithCGPoint:val]];
             reCALC = NO;
            return;
        }

        if (val.x > kWidthScreen || val.x < 0 || val.y < 0 || val.y > kHeightScreen)
        {
             drawn = NO;
             [pointsArr addObject: [NSValue valueWithCGPoint:val]];
             // NSLog(@"val x %f val y %f",val.x,val.x);
        }
                 
        else [pointsArr addObject: [NSValue valueWithCGPoint:val]];
    }
    
    reCALC = NO;
    
 //   NSLog(@"arr : %@",pointsArr);
    
}

-(void)preloadParticles{
    
    for (int x = 1; x < 20; x++) {
        
        CCParticleSystemQuad *effect = [CCParticleSystemQuad particleWithFile:[NSString stringWithFormat: @"laserblast.plist"]];
        effect.position = ccp(-100, -100);
        effect.scale = 0.5f;
        if (IS_IPAD) {
            effect.scale = 1.1f;
        }
        [self addChild:effect z:100];
        
        effect.tag = TAG_PARTICLE_BLAST+x;
       // [effect stopSystem];

        CCSprite *beam = [CCSprite spriteWithFile:@"beam.png"];
        
        if (IS_IPHONE) {
            beam.scale = 1.2f;
        }
        else if (IS_IPAD) {
            beam.scale = 1.8f;
        }
        [effect addChild:beam];
        [self addFlickerForNode:beam];
        
    }
    
}

-(void)addFlickerForNode:(CCNode*)n_{
    
    id visible = [CCFadeTo actionWithDuration:0.01f opacity:255];
    id not_ =   [CCFadeTo actionWithDuration:0.01f opacity:125.f];
    id seq_ = [CCSequence actions:visible,not_, nil];
    [n_ runAction:[CCRepeatForever actionWithAction:seq_]];
    
}

-(void)resetAllPartcilesPoints{
    
    for (int x = 1; x < 20; x++) {
            CCParticleSystemQuad *effect = (CCParticleSystemQuad*)[self getChildByTag:TAG_PARTICLE_BLAST+x];
            effect.position = ccp(-100,-100);
         ///   [effect stopSystem];
            effect.visible = NO;
    }
    
}

-(void)drawParticlesInPosition:(CGPoint)pos_{
    
    for (int x = 1; x < 20; x++) {
        if (ccpDistance([self getChildByTag:TAG_PARTICLE_BLAST+x].position, ccp(-100, -100))==0) {
            //it's free
           CCParticleSystemQuad *effect = (CCParticleSystemQuad*)[self getChildByTag:TAG_PARTICLE_BLAST+x];
            effect.position = pos_;
            effect.visible = YES;
            [effect resetSystem];
            return;
        }
    }
    
//    CCParticleSystemQuad *effect = [CCParticleSystemQuad particleWithFile:[NSString stringWithFormat: @"laserblast.plist"]];
//    effect.position = pos_;
//    effect.scale = 0.5f;
//    [self addChild:effect z:0];
//    //effect.autoRemoveOnFinish = YES;
    
}

-(CGPoint)drawLineWithStartPoint:(CGPoint)startPoint angle:(int)angle_{
    BOOL found = NO;
    CGPoint dest;
    
    BOOL brain1 = NO;
    BOOL brain2 = NO;
    BOOL brain3 = NO;
    
//    CCSprite *brain1Spr = (CCSprite*)[self getChildByTag:kBoxTag+kBRAIN_BLOCKTAG1];
//    brain1Spr.color = ccGREEN;
//    brain1Spr.opacity = 0;
//    brain1 = YES;
//    
//
//    CCSprite *brain2Spr = (CCSprite*)[self getChildByTag:kBoxTag+kBRAIN_BLOCKTAG2];
//    brain2Spr.color = ccGREEN;
//    brain2Spr.opacity = 0;
//    brain2 = YES;
//    
    int min = 30;
    if (IS_IPHONE) min = 10;
    
  //  int xxx= 0;
    
    for (int x = min; x < kHeightScreen*0.85f; x+=10) {     //10 px- accurancy - step of a laser
       
        CGPoint contact;
//        if (xxx==10) {
//            xxx=0;
//
//        }
//        else  {
//            xxx++;
//            continue;
//        }
        
        for (int y = 1; y < DIAMONDS_NR; y++)
        {
            dest = [self getDestinationPosBY:x angle:angle_];
            
            CGPoint point = ccpAdd(startPoint, dest);
            
        //    NSLog(@"dest %f %f",dest.x,dest.y);
            
            //kBoxTag+x;
            
            if (!brain1) {
                
                if (CGRectContainsPoint([self getChildByTag:kBoxTag+kBRAIN_BLOCKTAG1].boundingBox, point)){
                    CCSprite *brain1Spr = (CCSprite*)[self getChildByTag:kBoxTag+kBRAIN_BLOCKTAG1];
                    brain1Spr.color = ccGREEN;
                    brain1Spr.opacity = 100;
                    brain1 = YES;
                    b1 = YES;
                    //  NSLog(@"green");
                }
            }
  
            if (!brain2) {
                if (CGRectContainsPoint([self getChildByTag:kBoxTag+kBRAIN_BLOCKTAG2].boundingBox, point)){
                    CCSprite *brain2Spr = (CCSprite*)[self getChildByTag:kBoxTag+kBRAIN_BLOCKTAG2];
                    brain2Spr.color = ccGREEN;
                    brain2Spr.opacity = 100;
                    brain2 = YES;
                    b2=  YES;
                    //  NSLog(@"green");
                }
            }
            
            if (!brain3) {
                if (CGRectContainsPoint([self getChildByTag:kBoxTag+kBRAIN_BLOCKTAG3].boundingBox, point)){
                    CCSprite *brain3Spr = (CCSprite*)[self getChildByTag:kBoxTag+kBRAIN_BLOCKTAG3];
                    brain3Spr.color = ccGREEN;
                    brain3Spr.opacity = 100;
                    brain3 = YES;
                    b3= YES;
                    //  NSLog(@"green");
                }
            }

            
            if (CGRectContainsPoint([self getChildByTag:kCRYSTAL].boundingBox, point)){
                
                //*** point to center
                
                pointBefore = ccp([self getChildByTag:kCRYSTAL].position.x+([self getChildByTag:kCRYSTAL].boundingBox.size.width/2),[self getChildByTag:kCRYSTAL].position.y);
                
                // ****
              
                laserSTOP = YES;
                              
//                success = YES;
//                
//                [self removeAlllightinings];
//                [self redrawLightinings];
                
                // LAST REDRAW
                
                NSLog(@"success laser");
                
                [_hud TIME_Stop];
                
                enableTouch = NO;
   
                CCSprite *crystal = (CCSprite*)[self getChildByTag:kCRYSTAL];
                [crystal setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                       spriteFrameByName:@"gem1.png"]];
             
             //   [self unschedule:@selector(drawLines:)];
                [self performSelector:@selector(openDoorAction) withObject:nil afterDelay:2.f];
                return pointBefore;
            }
            
            if (CGRectContainsPoint([self getChildByTag:kBLOCK_DOOR_BOTOOM].boundingBox, point)||
                CGRectContainsPoint([self getChildByTag:kBLOCK_DOOR_TOP].boundingBox, point) ||
                CGRectContainsPoint([self getChildByTag:kBLOCK_TOP_WALL].boundingBox, point))
            {
                
             //   NSLog(@"pataike i uola");
                pointBefore = point;
                laserSTOP = YES;
                return pointBefore;
                
            }
            
         else   if (CGRectContainsPoint([self getChildByTag:y].boundingBox, point))
            {
                contact = ccpAdd(startPoint, dest);
                laserSTOP = NO;
                
                //                if (x == 0) {
                //                    return NO;
                //                }
                int side =  [self determineSideByContactPT:contact childTag:y];
                
                //     NSLog(@"SIDE :%i",side);
                contact = [self refixContactPointBySIDE:side child:y];
                
                angleNext = [self whatAngleWillbeNextFrom_Side:side angle:angle_];
                //      NSLog(@"next angle will be %f",angleNext);
                //NSLog(@"\n\nFound collision:\npixels %i. \nTag :%i. \nContact pt :%f %f \nSIDE: %i TOP,RIGHT,DOWN,LEFT\nMY ANGLE :%i  ||| NexT angle:%i",x,y,contact.x,contact.y,side,angle_,angleNext);
                
                found = YES;
                break;
            }
            
        }
        if (found) {
            //    NSLog(@"draw line to dest :%f %f",contact.x,contact.y);
            //  [ribbon1 addPointAt:contact width:10];
            pointBefore = contact;
            return pointBefore;
            //return YES;
            break;
        }
        
    }
    
    if (!found) {
        //NSLog(@"no other collisions found. angle before :%i. pos : %f %f",angleNext,dest.x,dest.y);
        pointBefore = ccpAdd(startPoint, dest);//dest;//ccp(0, 0);
       // [ribbon1 addPointAt:dest width:10];
        return pointBefore;
        //return NO;
    }
    
    return CGPointMake(-100, -100);
    
}

-(CGPoint)getDestinationPosBY:(float)px angle:(float)angle{
    
    CGPoint destination  = ccp(px*(cos(-CC_DEGREES_TO_RADIANS(angle))),
                               px*(sin(-CC_DEGREES_TO_RADIANS(angle))));
    
    return destination;
}

-(float)whatAngleWillbeNextFrom_Side:(int)side_ angle:(float)angle_{
    
    if (side_==TOP) {
        if (angle_==ANGLE_DOWN_RIGHT) {
            return ANGLE_UP_RIGHT;
        }
        else if (angle_==ANGLE_DOWN_LEFT) {
            return ANGLE_UP_LEFT;
        }
    }
    
    else if (side_==LEFT) {
        if (angle_==ANGLE_UP_RIGHT) {
            return ANGLE_UP_LEFT;
        }
       else  if (angle_==ANGLE_DOWN_RIGHT) {
            return ANGLE_DOWN_LEFT;
        }
    }
    else if (side_==RIGHT) {
        if (angle_==ANGLE_UP_LEFT) {
            return ANGLE_UP_RIGHT;
        }
        else  if (angle_==ANGLE_DOWN_LEFT) {
            return ANGLE_DOWN_RIGHT;
        }
    }
    
    else if (side_==DOWN) {

        if (angle_==ANGLE_UP_RIGHT) {
            return ANGLE_DOWN_RIGHT;
        }
        else  if (angle_==ANGLE_UP_LEFT) {
            return ANGLE_DOWN_LEFT;
        }
    }
    
    return ANGLE_UP_RIGHT;
}

-(CGPoint)refixContactPointBySIDE:(int)side child:(int)tag__{
    
    CGPoint point;
    if (side==TOP) {
        point = ccp([self getChildByTag:tag__].position.x,
                    [self getChildByTag:tag__].position.y+[self getChildByTag:tag__].boundingBox.size.height/2);
    }
    else if (side==DOWN) {
        point = ccp([self getChildByTag:tag__].position.x,
                    [self getChildByTag:tag__].position.y-[self getChildByTag:tag__].boundingBox.size.height/2-(1));
    }
    else if (side==LEFT) {
        point = ccp([self getChildByTag:tag__].position.x-[self getChildByTag:tag__].boundingBox.size.width/2,
                    [self getChildByTag:tag__].position.y);
    }
    else if (side==RIGHT) {
        point = ccp([self getChildByTag:tag__].position.x+[self getChildByTag:tag__].boundingBox.size.width/2,
                    [self getChildByTag:tag__].position.y);
    }
    
    
    return point;
}

-(int)determineSideByContactPT:(CGPoint)point_ childTag:(int)tagg{
//#define UP      0
//#define RIGHT   1
//#define DOWN    2
//#define LEFT    3
    int side = LEFT;

    if (!CGRectContainsPoint([self getChildByTag:tagg].boundingBox, ccpAdd(point_, ccp(0, 10))))
    {
        side = TOP;
    }
    else if (!CGRectContainsPoint([self getChildByTag:tagg].boundingBox, ccpAdd(point_, ccp(0, -10))))
    {
        side = DOWN;
    }
    else if (!CGRectContainsPoint([self getChildByTag:tagg].boundingBox, ccpAdd(point_, ccp(10, 0))))
    {
        side = RIGHT;
    }
    else if (!CGRectContainsPoint([self getChildByTag:tagg].boundingBox, ccpAdd(point_, ccp(10, 0))))
    {
        side = LEFT;
    }
    
    return side;
}

-(void)addFirstBlock{
   
 //   NSLog(@"add block");
    return;
    for (int x = 0; x < DIAMONDS_NR; x ++) {
        CCSprite *block = [CCSprite spriteWithFile:@"Icon.png"];
        block.position = ccp(10,200);
        [self addChild:block z:1 tag:x];
        block.tag = x;
        block.opacity = 200;
      //  if (x==2) block.position = ccpAdd(block.position, ccp(-20, 0));
    }

    
}

-(void)update:(ccTime)dt{
    
    PAUSED = NO;

    
//    [ribbon1 addPointAt:ccp(CCRANDOM_0_1() * 480,CCRANDOM_0_1() * 320) width:32];
//	  [ribbon1 update:dt];
    
}


-(CGRect)getItemRect:(int)x{
    
    float rectOffsetW = [[self getChildByTag:x]boundingBox].size.width;
    float rectOffsetH = [[self getChildByTag:x]boundingBox].size.height;

    
    CGRect itemBoundingBox = [[self getChildByTag:x] boundingBox];
    
    CGRect itemRect = CGRectMake(itemBoundingBox.origin.x-rectOffsetW/2, itemBoundingBox.origin.y-rectOffsetH/2,
                                 itemBoundingBox.size.width+rectOffsetW, itemBoundingBox.size.height+rectOffsetH);
    
    return itemRect;
}

-(void)setZorderMax:(int)tag{
    
    NSInteger item_z =  [self getChildByTag:tag].zOrder;
    [self reorderChild:[self getChildByTag:tag] z:item_z+50];
    
}

-(void)setZorderDef:(int)tag{
    NSInteger item_z =  [self getChildByTag:tag].zOrder;
    [self reorderChild:[self getChildByTag:tag] z:item_z-50];
    
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    if (success || dragging || !enableTouch)
    {
        return NO;
    }
    
    CGPoint location = [touch locationInView:[touch view]];
    
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    for (int x = 1 ; x < DIAMONDS_NR; x++)
    {

        if (CGRectContainsPoint([self getChildByTag:x].boundingBox, location)){
            
            if (x==notMovable || x == notMovable2)
            {    // NOT MOVABLE
                return  NO;
            }
            
            //NSLog(@"touched on diamond %i",x);
            
            [AUDIO playEffect:l14_diamondpick];

            dragging = YES;
            
            //[pointsArr removeAllObjects];
            
             [self resetAllPartcilesPoints]; //reset partciles
            
         //   [self removeAlllightinings];
            
              whereTouch=ccpSub([self getChildByTag:x].position, location);
                diamondCaughtTag = x;
                [self setZorderMax:diamondCaughtTag];
                        LastplaceID = [self whatIsThePlceID_BYDIAMOND:x];
            
                [self getChildByTag:TEMP_DIAMOND].visible = YES;
                [self getChildByTag:TEMP_DIAMOND].position = [self getChildByTag:LastplaceID].position;
            
             // NSLog(@"the place id is %i",LastplaceID);
            
             return YES;
        }
    }

    return NO;
}

-(int)whatIsThePlceID_BYDIAMOND:(int)d_id{
    
    for (int x = kBoxTag; x < kBoxTag+40; x++)
    {
        if (CGRectContainsPoint([self getChildByTag:x].boundingBox, [self getChildByTag:d_id].position))
        {
            return x;
        }
    }
    return kBoxTag;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
    CGPoint location = [touch locationInView:[touch view]];
    
    location = [[CCDirector sharedDirector] convertToGL:location];
    
 //   [self recheckLimmits];
    
    [self getChildByTag:diamondCaughtTag].position=ccpAdd(location,whereTouch);
    
    if (success) {
        return;
    }
    
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{
    
    CGPoint location = [self convertTouchToNodeSpace:touch];
    [self TOUCH_END_CANCEL:location];
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint location = [self convertTouchToNodeSpace:touch];
    [self TOUCH_END_CANCEL:location];
}

-(void)TOUCH_END_CANCEL:(CGPoint)location{
    
    if (success) {
        return;
    }
    
    [self getChildByTag:TEMP_DIAMOND].visible = NO;
    
    BOOL EFFECT = YES;
    
    BOOL foundNewPlace =  NO;
    
    //    [self recheckLimmits];
    
    
    id refresh = [CCCallBlock actionWithBlock:^(void){
        
        [self RE_DRAW_ALL];
        
        dragging = NO;
        
        
    }];
    
    
    
    
    for (int x = kBoxTag; x < kBoxTag+40; x++)
    {
        if (CGRectContainsPoint([self getChildByTag:x].boundingBox, [self getChildByTag:diamondCaughtTag].position))
        {
            //must check if there are other diamonds there ?
            if ([self ifThereAre_NO_DiamondsInBOX:x])
            {
                
                if (EFFECT) {
                    
                    //[AUDIO playEffect:l14_laserhit];
                    
                    [AUDIO playEffect:l14_diamonddrop];
                    
                    id move = [CCMoveTo actionWithDuration:0.15f position:[self getChildByTag:x].position];
                    id seq = [CCSequence actions:move,refresh, nil];
                    
                    [[self getChildByTag:diamondCaughtTag] runAction:seq];
                }
                else
                    [self getChildByTag:diamondCaughtTag].position = [self getChildByTag:x].position;
                
                foundNewPlace = YES;
            }
            
            else {  //find another nearest place || just bring to old place
                // int newPlace =  [self findTheNearesetPlaceAvailble_BOXID:x];
                
                
                if (EFFECT) {
                    id move = [CCMoveTo actionWithDuration:0.15f position:[self getChildByTag:LastplaceID].position];
                    id seq = [CCSequence actions:move,refresh, nil];
                    [[self getChildByTag:diamondCaughtTag] runAction:seq];
                }
                else {
                    [self getChildByTag:diamondCaughtTag].position = [self getChildByTag:LastplaceID].position;
                }
                
                
                foundNewPlace = YES;
            }
            
        }
        
        // [self RE_DRAW_ALL];
        
    }
    
    if (!foundNewPlace)
    {   //
        foundNewPlace = YES;
        
        if (EFFECT) {
            id move = [CCMoveTo actionWithDuration:0.1f position:[self getChildByTag:LastplaceID].position];
            id seq =  [CCSequence actions:move,refresh, nil];
            [[self getChildByTag:diamondCaughtTag] runAction:seq];
        }
        else {
            [self getChildByTag:diamondCaughtTag].position = [self getChildByTag:LastplaceID].position;
        }
        
        
    }
    
    //  [self setZorderDef:diamondCaughtTag];
    
    diamondCaughtTag = 0;
    LastplaceID=0;
    
    // dragging = NO;
    //  dragging = NO;
    
    
    //   [self RE_DRAW_ALL];
    
    
    // [self performSelector:@selector(RE_DRAW_ALL) withObject:nil afterDelay:0.2f];

    
}



-(int)findTheNearesetPlaceAvailble_BOXID:(int)boxTag{
 //   NSLog(@"REPLACE");
    //just place to old place
    return 0;
}

-(BOOL)ifThereAre_NO_DiamondsInBOX:(int)id_{
    
    for (int x = 1; x < DIAMONDS_NR; x++)
    { //7 - > SET DEFINED NR OF DIAMONDS
        if (   [self getChildByTag:x].position.x ==    [self getChildByTag:id_].position.x
            && [self getChildByTag:x].position.y ==    [self getChildByTag:id_].position.y)
        {
    //        NSLog(@"BOX %@ IS NOT AVAILABLE",[self getChildByTag:id_]);
            return NO;
        }
    }
    
    //recheck if it's not a brain
    NSArray *brains =[NSArray arrayWithObjects:[NSNumber numberWithInt:8003],
                                               [NSNumber numberWithInt:8004],
                                               [NSNumber numberWithInt:8005],
                      nil];
    
    for (int x = 0; x < [brains count]; x++)
    {
         if (CGRectContainsPoint([self getChildByTag:[[brains objectAtIndex:x]intValue]].boundingBox, [self getChildByTag:id_].position))
//        if (    [self getChildByTag:[[brains objectAtIndex:x]intValue]].position.x == [self getChildByTag:id_].position.x
//            &&  [self getChildByTag:[[brains objectAtIndex:x]intValue]].position.y == [self getChildByTag:id_].position.y)
//        {
         {
        //    NSLog(@"ITS A BRAIN FIELD");
            return NO;
        }
    }
    
    
    return YES;
}

-(void)RE_DRAW_ALL{
    
    reCALC = YES;

  //  [self performSelectorInBackground:@selector(drawLines) withObject:nil];
    
    [self drawLines];
    
    [self redrawLightinings];
    
//    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//        
//        [self drawLines];
//        [self redrawLightinings];
//        
//    });
//

//    id r1 = [CCCallBlock actionWithBlock:^(void){
//       
//         [self drawLines];
//        
//    }];
//    
//    id r2 = [CCCallBlock actionWithBlock:^(void){
//        
//        [self redrawLightinings];
//        
//    }];
//    
//    [self runAction:[CCSequence actions:r1,r2, nil]];
  
        
}

-(void)recheckLimmits{
    
    //x
    if ([self getChildByTag:diamondCaughtTag].position.x
        <= [self getChildByTag:diamondCaughtTag].boundingBox.size.width/2+(parX))
    {
        [self getChildByTag:diamondCaughtTag].position =
        ccp([self getChildByTag:diamondCaughtTag].boundingBox.size.width/2+(parX), [self getChildByTag:diamondCaughtTag].position.y);
    }
    if ([self getChildByTag:diamondCaughtTag].position.x > self.contentSize.width-([self getChildByTag:diamondCaughtTag].boundingBox.size.width/2)-(parX)) {
        [self getChildByTag:diamondCaughtTag].position =
        ccp(self.contentSize.width-([self getChildByTag:diamondCaughtTag].boundingBox.size.width/2)-(parX), [self getChildByTag:diamondCaughtTag].position.y);
    }
    //y
    if ([self getChildByTag:diamondCaughtTag].position.y <= [self getChildByTag:diamondCaughtTag].boundingBox.size.width/2) {
        [self getChildByTag:diamondCaughtTag].position =
        ccp([self getChildByTag:diamondCaughtTag].position.x,[self getChildByTag:diamondCaughtTag].boundingBox.size.width/2);
    }
    if ([self getChildByTag:diamondCaughtTag].position.y >= self.contentSize.height-([self getChildByTag:diamondCaughtTag].boundingBox.size.height/2)) {
        [self getChildByTag:diamondCaughtTag].position =
        ccp([self getChildByTag:diamondCaughtTag].position.x,self.contentSize.height - [self getChildByTag:diamondCaughtTag].boundingBox.size.height/2);
    }
    
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

- (void)onEnter{
    
   [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-2 swallowsTouches:YES];
    [super onEnter];
}

- (void) dealloc
{
  //  [BLOCKS release];
 //   [JOE release];
    [lightning release];
    [lightning2 release];
    [pointsArr release];
	// don't forget to call "super dealloc"
	[super dealloc];
}

- (void)onExit{
    
    [[SoundManager sharedManager]stopSound:@"lvl14_lazerloop.mp3" fadeOut:NO];
    
    [self removeAllChildrenWithCleanup:YES];
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [super onExit];
}

@end
