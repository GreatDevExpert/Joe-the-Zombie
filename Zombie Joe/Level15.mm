//
//  HelloWorldLayer.mm
//  Level15
//
//  Created by macbook on 2013-06-30.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "Level15.h"
#import "cfg.h"
#import "Strings.h"
#import "Tutorial.h"

#import "LHSettings.h"
#import "LHTouchMgr.h"

#import "b6luxHelper.h"
#import "b6luxRobotSprite.h"

#import "TigerCat.h"

#define DEBUG_L15       NO
#define COLLISIONS_L5   YES

#define EGG                          [loader spriteWithUniqueName:@"EGG"]
#define ACTOR_MOM                    [loader spriteWithUniqueName:@"birdmum"]
#define ACTOR_ZOMBIE                 [loader spriteWithUniqueName:@"zombiePoint"]
#define ACTOR_DOOR                   [loader spriteWithUniqueName:@"door"]
#define ACTOR_BRAIN_ROCK             [loader spriteWithUniqueName:@"brainRock"]
#define ACTOR_POPUPRECT              [loader spriteWithUniqueName:@"PopupRect"]
#define ACTOR_BIRD_WIN_OBJ           [loader spriteWithUniqueName:@"birdwinpos"]
#define ACTOR_BIRD_MOM_WIN           [loader spriteWithUniqueName:@"momwinpos"]
#define ACTOR_FINISH_ZOMBIEPT        [loader spriteWithUniqueName:@"zombiefinish"]
#define ACTOR_FINISH_MOM             [loader spriteWithUniqueName:@"momfinish"]
#define ACTOR_BRAIN_1                [loader spriteWithUniqueName:@"brains_1"]
#define ACTOR_BRAIN_2                [loader spriteWithUniqueName:@"brains_2"]

#define LAYER_MAIN                   [loader layerWithUniqueName:@"MAIN_LAYER"]
#define ACTOR_BG                     [loader spriteWithUniqueName:@"background_full"] 


    
#define TAG_NOF_FALLOW_BODY 101001
#define TAG_BODY_REMOVE     101010
#define TAG_EGG             1
#define TAG_TUTORIAL_OFF    2
#define TAG_MOM             3
#define TAG_ENEMY_WALL      4
#define TAG_ENEMY_MONSTRS   5
#define TAG_ENEMY_HOLE      6
#define TAG_BRAINS          7
#define TAG_FLOWERS         8
#define TAG_WALL_DEFAULT    9
#define TAG_MAIN_LAYER     10
#define TAG_TEMP_CAT1      11
#define TAG_TEMP_CAT2      12
#define TAG_TEMP_CAT3      13
#define TAG_ENEMY_CAT_HOR  14

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO [LevelHelperLoader pointsToMeterRatio]

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};


// HelloWorldLayer implementation
@implementation Level15

-(void)addZombie{
    
    CHARACTER_GO = [[[GoinCharacter alloc]initWithRect:CGRectMake(0, 0, 0, 0) tag:999]autorelease];
    
    [LAYER_MAIN addChild:CHARACTER_GO z:1];
    
    [CHARACTER_GO hide_shadow:NO];
    CHARACTER_GO.position =ACTOR_ZOMBIE.position;
    [CHARACTER_GO Action_WALK_SetDelay:0.15f funForever:YES];
    [CHARACTER_GO ramaMoveBy];
    CHARACTER_GO.rotation = 270;
    CHARACTER_GO.scale = 0.75f;

}

-(void)flowersEffect{
    int del = 0;
    for (LHSprite *f in [loader allSprites])
    {
        if (f.tag == TAG_FLOWERS)
        {
            del++;
           // NSLog(@"f  !");
            f.anchorPoint = ccp(0.5f, 0.25f);
            
            [self runAction:[CCSequence actions:
                            [CCDelayTime actionWithDuration:(float)del/10],
                            [CCCallFuncO actionWithTarget:self selector:@selector(makeFlowersMove:) object:f], nil]];
            ;
        }
        
    }
    

}

-(void)makeFlowersMove:(id)id_{
    
    id Right =   [CCRotateTo actionWithDuration:0.75f angle:10];
    id Right_ =  [CCEaseInOut actionWithAction:Right rate:2.f];
    
    id Left =   [CCRotateTo actionWithDuration:0.75f angle:-10];
    id Left_ =  [CCEaseInOut actionWithAction:Left rate:2.f];
    
    id seq =   [CCSequence actions:Right_,Left_, nil];
    id fore_ = [CCRepeatForever actionWithAction:seq];
 
    [id_ runAction:fore_];
    
}

-(int)CountHowManyActorsByTag:(int)type_{
    
    int count = 0;
    
    for (LHSprite *s in [loader allSprites])
    {
        if (s.tag == type_)
        {
            count++;
        }
    }
    
    return count;
    
}

-(LHSprite*)getMonstrWithUniqID:(int)tagID_{
    
    return [loader spriteWithUniqueName:[NSString stringWithFormat:@"SP_%i",tagID_]];
    
}

-(void)update:(ccTime)dt{

    for (TigerCat *s in [LAYER_MAIN children])
    {

        if ([s isKindOfClass:[TigerCat class]])
        {
            LHSprite *f = [s myFallower];
            
            if (s.tag !=TAG_NOF_FALLOW_BODY) {
                
                s.position =     f.position;
            
                if (s.rotation !=f.rotation)
                {
                    s.rotation = f.rotation;
                }
            }
         
        }
        
        
        if ([s isKindOfClass:[BirdMom class]] && s.tag !=TAG_NOF_FALLOW_BODY)
        {
            s.position = [s myFallower].position;
          //  s.rotation = [s myFallower].rotation;
        }
        
        if ([s isKindOfClass:[MomPopup class]])
        {
            s.position = [s myFallower].position;
        }
        
    }
    
    if (CHARACTER_GO.tag !=TAG_NOF_FALLOW_BODY)
    {
         CHARACTER_GO.position = ACTOR_ZOMBIE.position;
    }
 
    if (!enableMoveBaby) {
        return;
    }
    
    baby.rotation+=bodyRotateFactor*7.5f;
    
    baby.position = EGG.position;
    
}

-(void)checkCatRotation:(CCNode*)c_{
    
   // NSLog(@"rotation : %f",c_.rotation);
    
    float angle = 0;
    
    if (c_.rotation == 270)
    {
        angle = 90;
    }
   else if (c_.rotation == 90)
    {
        angle = 270;
    }
    
    if (c_.rotation == -0 || c_.rotation == 0)
    {
       angle = 180;
    }
    else if (c_.rotation == 180)
    {
        angle = -0;
    }
    
    id move = [CCRotateTo actionWithDuration:0.2f angle:angle];
    [c_ runAction:move];
    
}

-(void)monsterHasEndedMovement:(NSNotification*) notification{

    [self checkCatRotation:(LHSprite*)notification.object];
    
}

-(void)addMonsters{
    
    int monstersNumber = [b6luxHelper CountActorsByTag:TAG_ENEMY_MONSTRS fromLoader:loader];
    int horizontal = [b6luxHelper CountActorsByTag:TAG_ENEMY_CAT_HOR fromLoader:loader];
    int sum = monstersNumber + horizontal;
    
    for (int x = 1;  x <= sum; x++)
    {
        LHSprite *f = [loader spriteWithUniqueName:[NSString stringWithFormat:@"SP_%i",x]];

        TigerCat *robot = [[[TigerCat alloc]loadRobotWithLoader:loader uniqNamePrefix:@"CAT" fallowNode:f]autorelease];
        [LAYER_MAIN addChild:robot z:f.zOrder];
            
        [robot createRobotWithStatesSum:3 robotPartsSum:9 mainState:0];
        
        [robot initContent];

        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(monsterHasEndedMovement:)
                                                     name:LHPathMovementHasEndedNotification
                                                   object:f];
        
    }
    
    [self scheduleUpdate];  //make monsters fallow their fallow-path-object

}

-(void)createBirdMom{
    
    MOM = [[[BirdMom alloc]initWithLoader:loader fallowNode:ACTOR_MOM]autorelease];
    [LAYER_MAIN addChild:MOM z:2];
    
}

-(void)touchedOnBrainRock:(LHTouchInfo*)info{
    
//    NSLog(@"touch on brain rock");  // ADD brain nr 3!!!!!!!!!
    
    [ACTOR_BRAIN_ROCK removeTouchObserver];
     ACTOR_BRAIN_ROCK.tag = TAG_NOF_FALLOW_BODY;
    [ACTOR_BRAIN_ROCK setSensor:YES];
    
    [AUDIO playEffect:l1_itemclick];
    
    LHSprite *brains = [loader createSpriteWithName:@"brains"
                                          fromSheet:@"AllSpriteslvl14"
                                         fromSHFile:@"SpriteSheetsLevel14" parent:self];
    
    brains.position = info.sprite.position;
    
    [ACTOR_BRAIN_ROCK runAction:[CCFadeOut actionWithDuration:0.2f]];
    
    [cfg makeBrainActionForNode:brains fakeBrainsNode:nil direction:270 pixelsToMove:100 time:0.4f parent:self removeBrainsAfter:YES makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
    
}

-(void)brainRockSettings{
    
    [ACTOR_BRAIN_ROCK registerTouchBeganObserver:self selector:@selector(touchedOnBrainRock:)];

    
}

-(void)setBabyRotationWithX_Y:(float)x_ y:(float)y_{
    
    float rot = baby.rotation;
    
    float angleAim = 0;
    float angleAimX = 0;
    float angleAimY = 0;
    
    // LEFT - RIGHT
        if (y_ > 0)
        {
        //    NSLog(@"RIGHT");
            angleAimX = 90;
        }
        else if (y_ < 0)
        {
          //  NSLog(@"LEFT");
            angleAimX = 270;
        }
    
    //TOP - BOTTOM
    
    if (x_ > 0)
    {
     //   NSLog(@"UP");
        angleAimY = 180;
    }
    else if (x_ < 0)
    {
    //    NSLog(@"BOTTOM");
        angleAimY = 0;
    }
    
    if (x_ > y_)
    {
       // NSLog(@"X. [ %f %f ] Rotate to %f",x_,y_,angleAimX);
        if (y_ < 0) {
            angleAimX = 270;
        }
        if (y_ > 0) {
            angleAimY = 180;
        }
    }
    
    if (x_ < y_ && x_ > 0)
    {
        angleAim = 90;
       // NSLog(@"RIGHT");
    }
    
    else if (x_ < y_ && x_ < 0)
    {
        angleAim = 0;
      //  NSLog(@"TOP");
    }
    
    else if (x_ > y_ && y_ > 0)
    {
        angleAim = 180;
      //  NSLog(@"BOTTOM");
    }
    
    else if (x_ > y_ && y_ < 0)
    {
        angleAim = 270;
      //  NSLog(@"LEFT");
    }
    
  //  float bodyRotateFactor = 0;
    
    if (rot < angleAim)
    {
        bodyRotateFactor = 1;   //---- ADD
    }
    else if (rot > angleAim)
    {
        bodyRotateFactor = -1;  //---
    }
    
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
    if (!enableMoveBaby) {
        return;
    }
    
	static float prevX=0, prevY=0;
	
	//#define kFilterFactor 0.05f
#define kFilterFactor 1.0f	// don't use filter. the code is here just as an example
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
    
  //  NSLog(@"X Y %f %f",prevX,prevY);
    
    [self setBabyRotationWithX_Y:prevX y:prevY];
    
        // *** iOS 6 only
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        [EGG body]->SetLinearVelocity(b2Vec2(accelY * 10, -accelX * 10));
    }
    
    else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
    {
        [EGG body]->SetLinearVelocity(b2Vec2(-accelY * 10, accelX * 10));
    }
    
}

- (CGFloat) pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint) endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
    float bearingDegrees = bearingRadians * (180.0 / M_PI); // convert to degrees
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)); // correct discontinuity
    return bearingDegrees;
}

-(void)babyFallowBody:(ccTime)dt{
    
    if (!enableMoveBaby) {
        return;
    }
    
    baby.position = EGG.position;
    baby.rotation+=bodyRotateFactor*7.5f;
   // ACTOR_MOM.rotation = 90;
    
    //MOM FALLOW BABY
    
    if (momFallowBaby)
    {
        ACTOR_MOM.rotation = 90+(baby.rotation*0.05f);//(angle+90)+(baby.rotation*0.2f);   //baby.rotation*0.75f;
    }
    
}

-(void)createBabyBird{
    
    baby = [[[BabyBirdC alloc]initWithRect:CGRectMake(0, 0, 0, 0) withLoader:loader]autorelease];
    [LAYER_MAIN addChild:baby];
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        baby.scaleY = baby.scaleY;
    }
    
    else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
    {
        baby.scaleY = -baby.scaleY;;
    }
    
    ACTOR_MOM.flipY = YES;
    ACTOR_MOM.rotation = 180;
    enableMoveBaby = YES;
    
    
  //  [self schedule:@selector(babyFallowBody:)];

}

-(void)addPopupMom{
    
    POP =[[[MomPopup alloc]initWithLoader:loader fallowNode:ACTOR_POPUPRECT]autorelease];
    [LAYER_MAIN addChild:POP z:3];
    
    
}

-(void)wallSettings{
    
    [self WallSettingsForBody:[loader bottomPhysicBoundary]];
    [self WallSettingsForBody:[loader topPhysicBoundary]];
    [self WallSettingsForBody:[loader rightPhysicBoundary]];
    [self WallSettingsForBody:[loader leftPhysicBoundary]];
    
}

-(void)WallSettingsForBody:(b2Body*)body_{
    
    body_->GetFixtureList()->SetFriction(0);
    body_->GetFixtureList()->SetDensity(0);
    body_->GetFixtureList()->SetRestitution(0);
    
}



-(void)collisionCheckpoint:(LHContactInfo*)c_{
    
    if (c_.contactType == LH_END_CONTACT)
    {
        //DISABLE TUTORIAL
        [Combinations saveNSDEFAULTS_Bool:YES forKey:C_TUTORIAL_([_hud level])];
        [loader cancelBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_EGG
                                                     andTagB:(enum LevelHelper_TAG)TAG_TUTORIAL_OFF];
    }
    
}

-(void)collisionEnemyWall:(LHContactInfo*)c_{
    
    if (c_.contactType == LH_BEGIN_CONTACT)
    {
         [loader cancelBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_EGG
                                                      andTagB:(enum LevelHelper_TAG)TAG_ENEMY_WALL];
        
        [self CollisionsForObject:c_.bodyA Turn:NO];
        
      //  [AUDIO playEffect:l5_hitobstacle];
        
        c_.spriteA.tag   =TAG_NOF_FALLOW_BODY;
        
        enableMoveBaby = NO;
        
     //   [c_ bodyA]->SetActive(NO);
      //  [c_ bodyB]->SetActive(NO);
        
        removeWorld  = YES;
        
        [baby closeEyes];
        
        [_hud makeBlastInPosposition:c_.contactPoint];//baby.position];
        
        [_hud Lost_STATE_AFTERDELAY:1.f];
        
    }
    
}

-(void)collisionEnemyHole:(LHContactInfo*)c_{
    
    if (c_.contactType == LH_BEGIN_CONTACT)
    {
        //[_hud LOSTLevel];
        
        [AUDIO playEffect:l5_falldown];
        
        [self CollisionsForObject:c_.bodyA Turn:NO];
        [self CollisionsForObject:c_.bodyB Turn:NO];

        [loader cancelBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_EGG
                                                     andTagB:(enum LevelHelper_TAG)TAG_ENEMY_HOLE];
        c_.spriteA.tag   =TAG_NOF_FALLOW_BODY;

       // c_.spriteB.tag = TAG_BODY_REMOVE;
       // [[LHSettings sharedInstance]markSpriteForRemoval:c_.spriteB];
        
        enableMoveBaby = NO;
        
        removeWorld  = YES;
                
        [self intheHoleActionForBody:baby position:c_.spriteB.position];
    
    }
    
}

-(void)intheHoleActionForBody:(CCSprite*)b_ position:(CGPoint)pos_{
    
    id fade =   [CCFadeTo actionWithDuration:0.5f opacity:0];
    id rotate = [CCRotateBy actionWithDuration:0.75f angle:180];
    id scale =  [CCScaleTo actionWithDuration:1 scale:0];
    id move =   [CCMoveTo actionWithDuration:0.3f  position:pos_];

    id fadeSprites =   [CCCallBlock actionWithBlock:^(void)
    {
        for (CCNode *s in b_.children)
        {
            [s runAction:[fade copy]];
        }
    }];
    
    id spawn =  [CCSpawn actions:rotate,scale,move,[CCSequence actions:[CCDelayTime actionWithDuration:0.5f],fadeSprites, nil], nil];
    
    id seq = [CCSequence actions:spawn,[CCCallFuncO actionWithTarget:_hud selector:@selector(LOSTLevel)], nil];
    [b_ runAction:seq];
    
}

-(TigerCat*)getCatRobotByFallower:(LHSprite*)f_{
    
    for (TigerCat *s in [LAYER_MAIN children])
    {
        if ([s isKindOfClass:[TigerCat class]])
        {
            if ([s myFallower] == f_)
            {
                return s;
            }
            
        }
    }

    return nil;
}

-(void)collisionMonsters:(LHContactInfo*)c_{
    
  //  [_hud LOSTLevel];
    
    [loader cancelBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_EGG
                                                 andTagB:(enum LevelHelper_TAG)TAG_ENEMY_MONSTRS];
    
    [self CollisionsForObject:c_.bodyA Turn:NO];
    
    TigerCat *cat = [self getCatRobotByFallower:c_.spriteB];
    
    if (cat != nil)
    {
        [cat ACTION_StopAllPartsAnimations_Clean:YES];
        [[cat myFallower] pausePathMovement];
        
        [_hud makeBlastInPosposition:baby.position];
        
    //    [AUDIO playEffect:l5_catcatch];
        
        [cat killedZombieAction];
        
        enableMoveBaby = NO;
        
        removeWorld  = YES;

        c_.spriteA.tag   =TAG_NOF_FALLOW_BODY;
        c_.spriteB.tag   =TAG_NOF_FALLOW_BODY;
        cat.tag          =TAG_NOF_FALLOW_BODY;
        
        float angle = [cat RotateRobotToPoint:baby.position];

        [cat runAction:[CCRotateTo actionWithDuration:0.05f angle:angle]];
        [cat runAction:[CCMoveTo actionWithDuration:0.1f position:baby.position]];
        
        [baby runAction:[CCScaleTo actionWithDuration:0.5f scale:0.7f]];
        
        id delayBlock = [CCCallFuncO actionWithTarget:_hud selector:@selector(LOSTLevel)];
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.5f],delayBlock, nil]];
        
    }

}

-(void)collisionMoM:(LHContactInfo*)c_{
    
    if (c_.contactType == LH_BEGIN_CONTACT)
    {
        [loader cancelBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_EGG
                                                     andTagB:(enum LevelHelper_TAG)TAG_MOM];
        
        [self CollisionsForObject:c_.bodyA Turn:NO];
        [self CollisionsForObject:c_.bodyB Turn:NO];
        
        removeWorld  = YES;
        
        MOM.tag = TAG_NOF_FALLOW_BODY;
        
        [baby runAction:[CCMoveTo actionWithDuration:0.5f position:ACTOR_BIRD_WIN_OBJ.position]];
        
        [ACTOR_MOM stopPathMovement];
        [ACTOR_POPUPRECT stopPathMovement];
        
        [MOM stopAllActions];
        [MOM unscheduleAllSelectors];
        
        [POP hideAllPopups];
        [POP stopAllActions];
        [POP unscheduleAllSelectors];
        
        enableMoveBaby = NO;
        
        [self makeLastCatFreeze];
        [self MomGoToDoors];
        
        [_hud TIME_Stop];
    
    }
}

-(void)MomGoToDoors{
    
    id move =   [CCMoveTo actionWithDuration:  0.5f position:ACTOR_BIRD_MOM_WIN.position];
    id rotate = [CCRotateTo actionWithDuration:0.5f angle:0];
    id spawn1 = [CCSpawn actions:move,rotate, nil];
    
    id open =     [CCRotateTo actionWithDuration:  0.15f angle:90];
    id moveopen = [CCMoveTo actionWithDuration:     0.3f position:ACTOR_FINISH_MOM.position];
  //  id spawn2 = [CCSpawn actions:open,moveopen, nil];
    [MOM runAction:[CCSequence actions:spawn1,open,moveopen, nil]];
    
    id spawnopen =  [CCSpawn actions:[CCRotateBy actionWithDuration:0.15f angle:-90],
                     [CCCallBlock actionWithBlock:^(void){[AUDIO playEffect:l5_doorOpen];}], nil];
    
    [ACTOR_DOOR runAction: [CCSequence actions:
                           [CCDelayTime actionWithDuration:0.5f],
                           spawnopen,
                           [CCCallFuncO actionWithTarget:self selector:@selector(makeZombieGoToFinish)],nil]];
}

-(void)makeZombieGoToFinish{
    win = YES;
    [ACTOR_ZOMBIE stopPathMovement];
    CHARACTER_GO.tag = TAG_NOF_FALLOW_BODY;
    
    [AUDIO playEffect:fx_winmusic];
    

    id moveToBird = [CCMoveTo actionWithDuration:2.f
                                        position:ccp(CHARACTER_GO.position.x, MOM.position.y+(ACTOR_MOM.boundingBox.size.width*0.2f))];
    
    id rotate1 = [CCRotateBy actionWithDuration:0.15f angle:-25];
    id rotate2 = [CCRotateBy actionWithDuration:0.1f angle:60];
    id rotate3 = [CCRotateTo actionWithDuration:0.15f angle:90];
    
    id playSound = [CCCallBlock actionWithBlock:^() {[AUDIO playEffect:l5_momPushjoe];}];
    id soundrot2 = [CCSpawn actions:rotate2,playSound, nil];
    
    id seq = [CCSequence actions:[CCDelayTime actionWithDuration:2.f],rotate1,soundrot2,rotate3, nil];
    [MOM runAction:seq];
    
    id move = [CCMoveTo actionWithDuration:1.f position:ACTOR_FINISH_ZOMBIEPT.position];
    [CHARACTER_GO runAction:[CCSequence actions:moveToBird,[CCDelayTime actionWithDuration:0.15f],move,[CCCallFuncO actionWithTarget:self selector:@selector(zombiePassedTheFinishLine)], nil]];
    
}

-(void)zombiePassedTheFinishLine{
    
    [_hud WINLevel];
    
}

-(void)makeLastCatFreeze{
    
    LHSprite *s = [loader spriteWithUniqueName:@"SP_4"];
    [s stopPathMovement];
    TigerCat *cat = [self getCatRobotByFallower:s];
    [cat ACTION_StopAllPartsAnimations_Clean:YES];
    
}

-(void)collisionBrains:(LHContactInfo*)c_{
    
    int tag = 9000;
    
    if (c_.contactType == LH_BEGIN_CONTACT)
    {
        float direct = 0;
        if (c_.spriteB.position.y < kHeightScreen/2)
        {
            direct = 270;
          //  [LAYER_MAIN getChildByTag:TAG_BRAIN_1].visible = NO;
            tag = TAG_BRAIN_1;
        }
        else if (c_.spriteB.position.y > kHeightScreen/2) {
            
           // [LAYER_MAIN getChildByTag:TAG_BRAIN_2].visible = NO;
            direct = 90;
            tag = TAG_BRAIN_2;
        }
        
        [self CollisionsForObject:c_.bodyB Turn:NO];
        
//        LHSprite *brains = [loader createSpriteWithName:@"brains"
//                                              fromSheet:@"AllSpriteslvl14"
//                                             fromSHFile:@"SpriteSheetsLevel14" parent:self];
//        
//        brains.position = c_.spriteB.position;
        
        [cfg makeBrainActionForNode:[LAYER_MAIN getChildByTag:tag]
                     fakeBrainsNode:nil//[LAYER_MAIN getChildByTag:tag]//brains
                          direction:direct
                       pixelsToMove:1
                             parent:self
                  removeBrainsAfter:NO
                 makeActionAfterall:@selector(increaseBRAINSNUMBER)
                             target:_hud];
    }
    
}

-(void)registerCollisions{
    
    [loader useLevelHelperCollisionHandling];
    
    if (!COLLISIONS_L5)
    {
        [loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_EGG
                                                       andTagB:(enum LevelHelper_TAG)TAG_MOM
                                                    idListener:self selListener:@selector(collisionMoM:)];
        return;
    }
    
    [loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_EGG
                                                   andTagB:(enum LevelHelper_TAG)TAG_ENEMY_WALL
                                                idListener:self selListener:@selector(collisionEnemyWall:)];
    
    [loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_EGG
                                                   andTagB:(enum LevelHelper_TAG)TAG_ENEMY_HOLE
                                                idListener:self selListener:@selector(collisionEnemyHole:)];
    
    [loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_EGG
                                                   andTagB:(enum LevelHelper_TAG)TAG_BRAINS
                                                idListener:self selListener:@selector(collisionBrains:)];
    
    [loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_EGG
                                                   andTagB:(enum LevelHelper_TAG)TAG_MOM
                                                idListener:self selListener:@selector(collisionMoM:)];
    
    [loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_EGG
                                                   andTagB:(enum LevelHelper_TAG)TAG_ENEMY_MONSTRS
                                                idListener:self selListener:@selector(collisionMonsters:)];
    
    [loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_EGG
                                                   andTagB:(enum LevelHelper_TAG)TAG_TUTORIAL_OFF
                                                idListener:self selListener:@selector(collisionCheckpoint:)];
    
    
}

-(void)CollisionsForObject:(b2Body*)object Turn:(BOOL)on_{
    
    int bits = 0;
    
    if (on_)
    {
        bits = 65535;
    }
    
        b2Fixture *a = object->GetFixtureList();
        
        b2Filter filter = a->GetFilterData();
        filter.maskBits =     bits;
        a->SetFilterData(filter);

}

-(void)setLayerActorsOpacityTo:(float)val_{
    
    for (LHSprite *s in [loader allSprites])
    {
        if (s.tag == TAG_ENEMY_WALL || s.tag == TAG_WALL_DEFAULT) {
            continue;
        }
        [s runAction:[CCFadeTo actionWithDuration:1.5f opacity:val_]];
    }
    
}

-(void) draw
{
    if (!DEBUG_L15) {
        return;
    }
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    if (world == NULL)
        return;
    
	world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);

}

-(void) tick: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
    

   // m_world->Step((float)deltasec, _iters);
    
    pause = NO;
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;

	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
    
	world->Step(dt, velocityIterations, positionIterations);

   // b2Body *dead =

	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			CCSprite *myActor = (CCSprite*)b->GetUserData();
            if (myActor.tag == TAG_NOF_FALLOW_BODY)
            {
                continue;
            }

			myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}	
	}
    
    if (removeWorld) {
        [loader removeAllPhysics];
    }
    
   // [[LHSettings sharedInstance] removeMarkedSprites];
    
}

-(void)CLEAN_TEMP{
    
    //*** remove temporary used data
    
    for (LHSprite *s in [loader allSprites])
    {
        if (s.tag == TAG_TEMP_CAT1 || s.tag == TAG_TEMP_CAT2 || s.tag == TAG_TEMP_CAT3)
        {
            [s removeSelf];
        }
    }
    
}

- (id)initWithHUD:(InGameButtons *)hud
{
    if ((self = [super init])) {
        _hud = hud;
        
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
        
		b2Vec2 gravity;
		gravity.Set(0.0f, 0.0f);
        
        world = new b2World(gravity);
        world->SetAllowSleeping(true);
		world->SetContinuousPhysics(true);
        
        if (DEBUG_L15)
        {

            m_debugDraw = new GLESDebugDraw(PTM_RATIO * CC_CONTENT_SCALE_FACTOR());
            world->SetDebugDraw(m_debugDraw);
            
            uint32 flags = 0;
            flags += GLESDebugDraw::e_shapeBit;
            flags += GLESDebugDraw::e_jointBit;
            //		flags += b2DebugDraw::e_aabbBit;
            //		flags += b2DebugDraw::e_pairBit;
            //		flags += b2DebugDraw::e_centerOfMassBit;
            m_debugDraw->SetFlags(flags);
            
        }
        
        if (IS_IPHONE_5)
        {
           // [[LHSettings sharedInstance] setStretchArt:false];
            
            [LevelHelperLoader dontStretchArt];
            
           // NSLog(@"stretchArt %i",[LHSettings sharedInstance].stretchArt);
        }
        
//        else {
//            [[LHSettings sharedInstance] setStretchArt:true];
//            
//            NSLog(@"stretchArt %i",[LHSettings sharedInstance].stretchArt);
//        }
        
        // *** IPAD FIX
        
        /*
        
        if (IS_IPAD)
        {
            CGPoint a = [LHSettings sharedInstance].possitionOffset;
            //NSLog(@"a %f %f",a.x,a.y);
            
         //   [LevelHelperLoader dontStretchArt];
            [LevelHelperLoader loadLevelsWithOffset:CGPointMake(0,-(a.y))];
        }
         
         */
        
        loader = [[LevelHelperLoader alloc]initWithContentOfFile:@"Level15LHP"];
        
        [loader addObjectsToWorld:world cocos2dLayer:self];
        
        [loader createPhysicBoundaries:world];
        
        
        [self registerCollisions];
        
        [self wallSettings];
        
        [self createBabyBird];
        
        [self addZombie];
        
        [self flowersEffect];
        
        [self addMonsters];
        
        [self brainRockSettings];
        
        [self createBirdMom];
        
        [self addPopupMom];
        
        if (DEBUG_L15)
        {
            [self setLayerActorsOpacityTo:150];
        }
        
		[self schedule: @selector(tick:)];
        
        [self CLEAN_TEMP];
        
        
        
        // *** preload brains and blast effect ( PARENT - >>>!!! remenber it, because to access it you need to write)
        
        [_hud preloadBlast_self:self brainNr:2 parent:LAYER_MAIN];
        
        // *** set brain positions
        
        [_hud BRAIN_:TAG_BRAIN_1 position:ACTOR_BRAIN_1.position parent:LAYER_MAIN];
        
        [_hud BRAIN_:TAG_BRAIN_1 zOrder:0 parent:LAYER_MAIN];
        
        [_hud BRAIN_:TAG_BRAIN_2 position:ACTOR_BRAIN_2.position parent:LAYER_MAIN];
        
        [_hud BRAIN_:TAG_BRAIN_2 zOrder:0 parent:LAYER_MAIN];
        
        ACTOR_BRAIN_1.visible = NO;
        ACTOR_BRAIN_2.visible = NO;
    
        [self schedule:@selector(babybirdSoundRandom:) interval:5];
        
        if (_hud.tutorialSHOW)
        {
            pause = YES;
            [self schedule:@selector(GAME_PAUSE) interval:0.1f];
        }
        
        if (![Combinations checkNSDEFAULTS_Bool_ForKey:C_TUTORIAL_(_hud.level)])
        {
            [cfg runSelectorTarget:self selector:@selector(showTut_15) object:nil afterDelay:1 sender:self];
        }

	}
	return self;
}

-(void)showTut_15
{
    Tutorial *tut = [[[Tutorial alloc]init]autorelease];
    tut.position = ccp(kWidthScreen/2, kHeightScreen/2);
    [self addChild:tut z:999 tag:9938];
    [tut TILT_TrutorialRepaet:1 runAfterDelay:0.5f quadro:YES];
    
}

-(void)babybirdSoundRandom:(ccTime)dt{
    
    if (!pause && !win) {
        [AUDIO playEffect:l5_babybirdrandom];
    }
    
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


- (void)onExit
{
    [ACTOR_BRAIN_ROCK removeTouchObserver];
    [self unscheduleAllSelectors];
    [self stopAllActions];
     
 //   [self removeAllChildrenWithCleanup:YES];
    
  //  [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    
   // [[CCTextureCache sharedTextureCache] removeUnusedTextures];
   
    [super onExit];
    
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [self unscheduleUpdate];
    
   // [[LHSettings sharedInstance]removeMarkedSprites];
    
    if(loader != nil) { [loader release]; loader = nil; }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

	// in case you have something to dealloc, do it in this method
	delete world;
  	world = NULL;
	
	delete m_debugDraw;


    
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
