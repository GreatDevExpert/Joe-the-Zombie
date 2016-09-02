
//  Created by Eimio on 5/22/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.

// Import the interfaces
#import "Level12.h"
        
#import "cfg.h"
#import "Combinations.h"
#import "Constants.h"
#import "CCFollowDynamic.h"
#import "Tutorial.h"
        
#define COCOS_BODY          [[level12_loader spriteWithUniqueName:@"cocos"]body]
#define COCOS_COSTUME       [level12_loader spriteWithUniqueName:@"cocos"]

#define BRAINS_BODY1        [[level12_loader spriteWithUniqueName:@"brains"]body]
#define BRAINS_COSTUME1     [level12_loader spriteWithUniqueName:@"brains"]
#define BRAINS_BODY2        [[level12_loader spriteWithUniqueName:@"brains2"]body]
#define BRAINS_COSTUME2     [level12_loader spriteWithUniqueName:@"brains2"]
#define BRAINS_BODY3        [[level12_loader spriteWithUniqueName:@"brains3"]body]
#define BRAINS_COSTUME3     [level12_loader spriteWithUniqueName:@"brains3"]

#define PLAYER_BODY         [[level12_loader spriteWithUniqueName:@"zombie"]body]
#define PLAYER_COSTUME      [level12_loader spriteWithUniqueName:@"zombie"]

#define PLAYER_HEAD_BODY    [[level12_loader spriteWithUniqueName:@"head"]body]
#define PLAYER_HEAD_COSTUME [level12_loader spriteWithUniqueName:@"head"]

#define BLOCK_BODY          [[level12_loader spriteWithUniqueName:@"block_slide"]body]
#define BLOCK_COSTUME       [level12_loader spriteWithUniqueName:@"block_slide"]

#define LAYER_MAIN          [level12_loader layerWithUniqueName:@"MAIN_LAYER"]

#define GAMEOVER_TAG 123
        
#define k_BG_1 10
#define k_BG_2 20

#define TAG_ACTION_FALLOW 750

#define SIDE_FALLOW_RIGHT 0.25f
#define SIDE_FALLOW_LEFT  0.65f

#define TAG_SELF_ZOOM_OUT 1
#define TAG_SELF_ZOOM_IN  2

////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////
        
@implementation Level12

-(NSString *)isIphone_or_ipad
{
    if (IS_IPAD) {return @"";}else return @"_iPhone";
}

-(void)fallowCameraSide:(float)side_ nodeToFallow:(CCNode*)node_
{
    [self runAction:[CCFollowDynamic actionWithTarget:node_ worldBoundary:CGRectMake(0,0,kWidthScreen*16.f,kHeightScreen*(-24.f)) smoothingFactor:0.25f nodePlace:side_]].tag = TAG_ACTION_FALLOW;
}

-(void)zoomOutSelf
{
//    if (![LAYER_MAIN getActionByTag:TAG_SELF_ZOOM_OUT])
//    {
//        id zoomOut = [CCScaleBy actionWithDuration:1.0 scale:0.9f];
//        id reversE = [zoomOut reverse];
//        id seq     = [CCSequence actions:zoomOut,reversE, nil];
//        [LAYER_MAIN runAction:seq].tag = TAG_SELF_ZOOM_OUT;
//    }
}

//////////////////////////////////////////////////////////// COLLISIONS /////////////////////////////////////////
-(void)move_right:(LHContactInfo*)contact
{
    if (contact.contactType == LH_BEGIN_CONTACT)
    {
        if (isOnGrid) return;
        isOnGrid    = true;
        
        speedUp     = false;
        speedDown   = false;
    }

    isMovingRight   = true;
    isMovingLeft    = false;


    if (isOnSecondPlatform)
    {
        [self stopActionByTag:TAG_ACTION_FALLOW];
        isOnFirstPlatform  = YES;
        isOnSecondPlatform = NO;
        if (![self getActionByTag:TAG_ACTION_FALLOW])
        {
            [self fallowCameraSide:SIDE_FALLOW_RIGHT nodeToFallow:cocRight];
        }
    }
    //[level12_loader cancelBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)7 andTagB:(enum LevelHelper_TAG)2];
}

-(void)move_left:(LHContactInfo*)contact
{
    if (contact.contactType == LH_BEGIN_CONTACT)
    {
        if (isOnGrid) return;
        isOnGrid    = true;
        
        speedUp     = false;
        speedDown   = false;
    }

    isMovingLeft    = true;
    isMovingRight   = false;
    
    if (isOnFirstPlatform)
    {
        [self stopActionByTag:TAG_ACTION_FALLOW];
        isOnFirstPlatform  = NO;
        isOnSecondPlatform = YES;
        if (![self getActionByTag:TAG_ACTION_FALLOW])
        {
            [self fallowCameraSide:SIDE_FALLOW_LEFT nodeToFallow:cocLeft];
        }
    }
}

-(void)game_over:(LHContactInfo*)contact
{
    if (isGameOver)
        return;
    
    isGameOver = true;
    headJumps  = true;
    
    [COCOS_COSTUME removeAllAttachedJoints];
    COCOS_BODY->GetFixtureList()->SetFriction(100);
    [cfg runSelectorTarget:self selector:@selector(GAME_OVER_FINAL) object:nil afterDelay:1.0f sender:self];
    [level12_loader cancelBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)7 andTagB:(enum LevelHelper_TAG)3];
}
-(void)game_over2:(LHContactInfo*)contact
{
    if (isGameOver)
        return;

    isGameOver = true;
    headJumps  = true;
    
    [COCOS_COSTUME removeAllAttachedJoints];
    COCOS_BODY->GetFixtureList()->SetFriction(100);
    [cfg runSelectorTarget:self selector:@selector(GAME_OVER_FINAL) object:nil afterDelay:1.0f sender:self];
    [level12_loader cancelBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)7 andTagB:(enum LevelHelper_TAG)8];
}
-(void)game_over3:(LHContactInfo*)contact
{
    if (isGameOver)
        return;
    
    if (getDown == false)
    {
        isGameOver = true;
        headStays  = true;
        
        COCOS_BODY->GetFixtureList()->SetFriction(100);
        [COCOS_COSTUME removeAllAttachedJoints];
        [cfg runSelectorTarget:self selector:@selector(GAME_OVER_FINAL) object:nil afterDelay:1.0f sender:self];
        [level12_loader cancelBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)9 andTagB:(enum LevelHelper_TAG)8];
    }
}

-(void)get_faster:(LHContactInfo*)contact
{
    isJump       = false;
    
    if (speedUp == false)
    {
        [AUDIO playEffect:l11_speedUp];
        speedUp = true;
        COCOS_BODY->SetLinearVelocity(b2Vec2(COCOS_BODY->GetLinearVelocity().x * 2.0f, COCOS_BODY->GetLinearVelocity().y));
    }
    
}

-(void)get_slower:(LHContactInfo*)contact
{
    isJump         = false;

    if (speedDown == false)
    {
        [AUDIO playEffect:l11_speedDown];
        speedDown = true;
        COCOS_BODY->SetLinearVelocity(b2Vec2(COCOS_BODY->GetLinearVelocity().x * 0.5f, COCOS_BODY->GetLinearVelocity().y));
    }
    
}

-(void)finish_ground:(LHContactInfo*)contact
{
    if (isGameOver == false)
    {
        [AUDIO playEffect:l11_brickHit];
        [AUDIO playEffect:fx_winmusic];
        
        [_hud WINLevel];
        [_hud TIME_Stop];
        isJump           = false;
        isMovingToFinish = true;
        isOnGrid         = true;
    }
    [level12_loader cancelBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)7 andTagB:(enum LevelHelper_TAG)6];
}

-(void)inc_Brain1:(LHContactInfo*)contact
{
    if (brain1) return;
    
    brain1 = true;
    [_hud increaseBRAINSNUMBER];
    
    [cfg makeBrainActionForNode:BRAINS_COSTUME1
                 fakeBrainsNode:nil direction:0
                   pixelsToMove:0.1f
                           time:0
                         parent:self
              removeBrainsAfter:NO
             makeActionAfterall:@selector(incBrains1)
                         target:self];
    
    BrainSprite1.visible = NO;

    [level12_loader cancelBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)7 andTagB:(enum LevelHelper_TAG)10];
    [level12_loader cancelBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)9 andTagB:(enum LevelHelper_TAG)10];
}

-(void)inc_Brain2:(LHContactInfo*)contact
{
    if (brain2) return;
    
    brain2 = true;
    [_hud increaseBRAINSNUMBER];
    
    [cfg makeBrainActionForNode:BRAINS_COSTUME2
                 fakeBrainsNode:nil direction:0
                   pixelsToMove:0.1f
                           time:0
                         parent:self
              removeBrainsAfter:NO
             makeActionAfterall:@selector(incBrains2)
                         target:self];
    
    BrainSprite2.visible = NO;
    
    [level12_loader cancelBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)7 andTagB:(enum LevelHelper_TAG)11];
    [level12_loader cancelBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)9 andTagB:(enum LevelHelper_TAG)11];
}

-(void)inc_Brain3:(LHContactInfo*)contact
{
    if (brain3) return;
    
    brain3 = true;
    [_hud increaseBRAINSNUMBER];
    
    [cfg makeBrainActionForNode:BRAINS_COSTUME3
                 fakeBrainsNode:nil direction:0
                   pixelsToMove:0.1f
                           time:0
                         parent:self
              removeBrainsAfter:NO
             makeActionAfterall:@selector(incBrains3)
                         target:self];
    
    BrainSprite3.visible = NO;
    
    [level12_loader cancelBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)7 andTagB:(enum LevelHelper_TAG)12];
    [level12_loader cancelBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)9 andTagB:(enum LevelHelper_TAG)12];
}

-(void)hitBricks:(LHContactInfo*)contact
{
    if (contact.contactType == LH_BEGIN_CONTACT)
    {
        if (bricksHit == false)
        {
            [AUDIO playEffect:l11_brickHit];
            bricksHit = true;
            COCOS_BODY->GetFixtureList()->SetFriction(1000);
        }
        
    }
}

///////////////////////////////////////////////////////////// LOAD COLLISIONS //////////////////////////////////////
-(void) setupCollisionHandling
{
    [level12_loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)7 andTagB:(enum LevelHelper_TAG)2 idListener:self selListener:@selector(move_right:)];
    [level12_loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)7 andTagB:(enum LevelHelper_TAG)1 idListener:self selListener:@selector(move_left:)];
    [level12_loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)7 andTagB:(enum LevelHelper_TAG)3 idListener:self selListener:@selector(game_over:)];
    [level12_loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)7 andTagB:(enum LevelHelper_TAG)4 idListener:self selListener:@selector(get_faster:)];
    [level12_loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)7 andTagB:(enum LevelHelper_TAG)5 idListener:self selListener:@selector(get_slower:)];
    [level12_loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)7 andTagB:(enum LevelHelper_TAG)6 idListener:self selListener:@selector(finish_ground:)];
    [level12_loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)7 andTagB:(enum LevelHelper_TAG)8 idListener:self selListener:@selector(game_over2:)];
    [level12_loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)9 andTagB:(enum LevelHelper_TAG)8 idListener:self selListener:@selector(game_over3:)];
    
    [level12_loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)7 andTagB:(enum LevelHelper_TAG)10 idListener:self selListener:@selector(inc_Brain1:)];
    [level12_loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)9 andTagB:(enum LevelHelper_TAG)10 idListener:self selListener:@selector(inc_Brain1:)];
    
    [level12_loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)7 andTagB:(enum LevelHelper_TAG)11 idListener:self selListener:@selector(inc_Brain2:)];
    [level12_loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)9 andTagB:(enum LevelHelper_TAG)11 idListener:self selListener:@selector(inc_Brain2:)];
    
    [level12_loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)7 andTagB:(enum LevelHelper_TAG)12 idListener:self selListener:@selector(inc_Brain3:)];
    [level12_loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)9 andTagB:(enum LevelHelper_TAG)12 idListener:self selListener:@selector(inc_Brain3:)];
    [level12_loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)7 andTagB:(enum LevelHelper_TAG)13 idListener:self selListener:@selector(hitBricks:)];
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) GAME_OVER_FINAL
{
    [_hud TIME_Stop];
    [_hud LOSTLevel];
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

-(void)showTutLVL12
{
    Tutorial*tut = [[[Tutorial alloc]init]autorelease];
    [_hud addChild:tut z:0 tag:3334];
    tut.position = ccp(kWidthScreen/2, kHeightScreen/2);
    [tut SWIPE_TutorialWithDirection:SWIPE_UP times:1 delay:0.5f runAfterDelay:0.2f];
    [cfg runSelectorTarget:self selector:@selector(showTUt_12_2) object:nil afterDelay:2.f sender:self];
    
}
-(void)showTUt_12_2
{
    if ([_hud getChildByTag:3334]) {
        [[_hud getChildByTag:3334]removeFromParentAndCleanup:YES];
    }
    Tutorial *tut = [[[Tutorial alloc]init]autorelease];
    [_hud addChild:tut z:0 tag:3332];
    tut.position = ccp(kWidthScreen/2, kHeightScreen/2);
    [tut SWIPE_TutorialWithDirection:SWIPE_DOWN times:1 delay:0.5f runAfterDelay:0.5f];
    
    
}


- (id)initWithHUD:(InGameButtons *)hud
{
	if( (self=[super init]))
    {
         _hud = hud;
        
		// enable touches
		self.isTouchEnabled = YES;
		
		b2Vec2 gravity;
		gravity.Set(0.0f, -30.0f);
        
        world = new b2World(gravity);
        world->SetAllowSleeping(true);
        world->SetContinuousPhysics(true);
        world->SetAutoClearForces(false);
        
		// Debug Draw functions
//		m_debugDraw = new GLESDebugDraw( PTM_RATIO * CC_CONTENT_SCALE_FACTOR()); //* CC_CONTENT_SCALE_FACTOR()
//		world->SetDebugDraw(m_debugDraw);
        
//		uint32 flags = 0;
//		flags += GLESDebugDraw::e_shapeBit;
//		flags += GLESDebugDraw::e_jointBit;
//        //		flags += GLESDebugDraw::e_aabbBit;
//        //		flags += GLESDebugDraw::e_pairBit;
//        //		flags += GLESDebugDraw::e_centerOfMassBit;
//		m_debugDraw->SetFlags(flags);
		
        if (IS_IPHONE_5 || IS_IPAD) { [LevelHelperLoader dontStretchArt];}  //iphone 5 fix
//----
    
//        if (IS_IPAD)    { level12_loader = [[LevelHelperLoader alloc] initWithContentOfFile:@"Level12"]; }
//        else            { level12_loader = [[LevelHelperLoader alloc] initWithContentOfFile:@"Level12_iPhone"]; }
        
        level12_loader = [[LevelHelperLoader alloc] initWithContentOfFile:@"Level12"];
        
        [level12_loader addObjectsToWorld:world cocos2dLayer:self];
        [level12_loader createPhysicBoundaries:world];
//----
        [level12_loader useLevelHelperCollisionHandling];
//----        
        zombieCocos = [level12_loader jointWithUniqueName:@"Joint1"];
//----      
        cocRight = [[[CCSprite alloc]init]autorelease];
        [self addChild:cocRight];
//----        
        cocLeft = [[[CCSprite alloc]init]autorelease];
        [self addChild:cocLeft];
//----
        
        // Retrieve all objects after we’ve loaded the level
        [self retrieveRequiredObjects];
//----
        //[self schedule:@selector(update:) interval:1/300];
        //[self schedule:@selector(tick:) interval:1/60];
        [self schedule:@selector(tick:)];

        [self schedule:@selector(cocFallowZombie:)];
        [self schedule:@selector(cocFallowZombie2:)];
        
        /////////////////////////////////////////////////////// NEW BRAINS /////////////////////////
        [_hud preloadBlast_self:self brainNr:3 parent:self];
        
        BrainSprite1 = (BrainRobot*)[self getChildByTag:TAG_BRAIN_1];
        BrainSprite2 = (BrainRobot*)[self getChildByTag:TAG_BRAIN_2];
        BrainSprite3 = (BrainRobot*)[self getChildByTag:TAG_BRAIN_3];
        
        BRAINS_COSTUME1.visible = NO;
        BRAINS_COSTUME2.visible = NO;
        BRAINS_COSTUME3.visible = NO;
        
        // *** set brain positions
        [_hud BRAIN_:TAG_BRAIN_1 position:BRAINS_COSTUME1.position parent:self];
        //[_hud BRAIN_:TAG_BRAIN_1 zOrder:120 parent:self];
        
        [_hud BRAIN_:TAG_BRAIN_2 position:BRAINS_COSTUME2.position parent:self];
        //[_hud BRAIN_:TAG_BRAIN_2 zOrder:120 parent:self];
        
        [_hud BRAIN_:TAG_BRAIN_3 position:BRAINS_COSTUME3.position parent:self];
        //[_hud BRAIN_:TAG_BRAIN_3 zOrder:120 parent:self];
        ////////////////////////////////////////////////////////////////////////////////////////////
		
        [self setupCollisionHandling];
        [self createPlayerCostume];
//----
        brain1              = false;
        brain2              = false;
        brain3              = false;
        getDown             = false;
        bricksHit           = false;
        touchEnded          = YES;
        isOnSecondPlatform  = YES;
//----
        self.scale = 0.8f;
        
        [self fallowCameraSide:0.5f nodeToFallow:COCOS_COSTUME];
        
        if (_hud.tutorialSHOW)
        {
            pause = YES;
            [self schedule:@selector(GAME_PAUSE) interval:0.1f];
        }        
//        // Getting all sprites with tag "GAMEOVER"
//        NSArray* allSpritesWithTag = [level12_loader spritesWithTag:GAMEOVER];
//        
//        for(LHSprite* mySprite in allSpritesWithTag)
//        {
//            NSLog(@"------------------ GAMEOVER BODIES --------------------");
//        }
         if (![Combinations checkNSDEFAULTS_Bool_ForKey:C_TUTORIAL_(_hud.level)]){
        [cfg runSelectorTarget:self selector:@selector(showTutLVL12) object:nil afterDelay:1 sender:self];
         }
        
	}
	return self;
}

-(void)cocFallowZombie:(ccTime)dt
{
    cocRight.position = ccp(COCOS_COSTUME.position.x + kWidthScreen*0.35f, COCOS_COSTUME.position.y - kHeightScreen*0.4f);
}

-(void)cocFallowZombie2:(ccTime)dt
{
    cocLeft.position  = ccp(COCOS_COSTUME.position.x - kWidthScreen*0.20f, COCOS_COSTUME.position.y + kHeightScreen*0.1f);
}

////////////////////////////////////////////////////////////////////////////////
-(void) draw
{
    	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
    	// Needed states:  GL_VERTEX_ARRAY,
    	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
//    	glDisable(GL_TEXTURE_2D);
//    	glDisableClientState(GL_COLOR_ARRAY);
//    	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
//    
//    	world->DrawDebugData();
//    
//    	// restore default GL states
//    	glEnable(GL_TEXTURE_2D);
//    	glEnableClientState(GL_COLOR_ARRAY);
//    	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}

-(void) createPlayerCostume
{
    /////////////////////////////////////////////////////////////
    CGRect rect;
    if (IS_IPAD) {rect = CGRectMake(0, 0, 175, 230);}else{rect = CGRectMake(0, 0, 100, 125);}
    
    m_zombieCostume = [[[JoeZombieController alloc]initWitPos:ccp(0, 0) size:CGSizeMake(rect.size.width,rect.size.height)]autorelease];
    [LAYER_MAIN addChild:m_zombieCostume z:1 tag:999];
    
    m_zombieCostume.scale        = 0.35f;
    m_zombieCostume.anchorPoint  = ccp(0.5f, 0.5f);
    [m_zombieCostume JOE_IDLE];
    
    [m_zombieCostume JOE_HIDE:3 opacity:0];
    [m_zombieCostume JOE_HIDE:4 opacity:0];
    [m_zombieCostume JOE_HIDE:5 opacity:0];
    [m_zombieCostume JOE_HIDE:6 opacity:0];
    [m_zombieCostume JOE_HIDE:7 opacity:0];
    [m_zombieCostume JOE_HIDE:8 opacity:0];
    [m_zombieCostume JOE_HIDE:13 opacity:0];
    [m_zombieCostume JOE_HIDE:14 opacity:0];
    [m_zombieCostume JOE_HIDE:15 opacity:0];
    [m_zombieCostume JOE_HIDE:16 opacity:0];
    /////////////////////////////////////////////////////////////
}

-(void) tick: (ccTime) dt
{
    pause = NO;
    
    float timeStep = 1.0f / 60.0f;
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
    
	world->Step(timeStep, velocityIterations, positionIterations);

	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL)
        {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			CCSprite *myActor = (CCSprite*)b->GetUserData();
			myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}
	}

    // Set max velocity speed for PLAYER
    const b2Vec2 velocity = COCOS_BODY->GetLinearVelocity();
    const float32 speed = velocity.Length();
    const float32 maxSpeed = 22.0f;
    
    if (speed >= maxSpeed)
    {
        COCOS_BODY->SetLinearDamping(0.5f);
    }
//    if (speed >= 1)
//    {
//        [paralaxNode setPaused:false];
//        float parallaxSpeed;
//        parallaxSpeed = speed * 1.2f;
//        
//        [paralaxNode setSpeed:parallaxSpeed];
//    }
//    else { [paralaxNode setPaused:true];//pass false to unpause }

    if (isMovingLeft)
    {
        COCOS_BODY->SetAngularVelocity(0);
        COCOS_BODY->SetTransform( COCOS_BODY->GetPosition(),   45 );
        //[m_zombieCostume JOE_flipX:YES];
        m_zombieCostume.rotation = -30;
        
        if (flip == false)
        {
            [self flipZombie];
            flip = true;
        }
    }
    else if (isMovingRight)
    {
        COCOS_BODY->SetAngularVelocity(0);
        COCOS_BODY->SetTransform( COCOS_BODY->GetPosition(),   0 );
        //[m_zombieCostume JOE_flipX:NO];
        m_zombieCostume.rotation = 30;
        
        if (flip == true)
        {
            [self flipZombie];
            flip = false;
        }
    }
    else if (isMovingToFinish)
    {
        COCOS_BODY->SetAngularVelocity(0);
        COCOS_BODY->SetTransform( COCOS_BODY->GetPosition(), -22 );
    }
    
    if (isGameOver == false)
    {
        if (getDown)
        {
            if (isMovingRight)
            {
                if (IS_IPAD) { m_zombieCostume.position = ccp(COCOS_COSTUME.position.x, COCOS_COSTUME.position.y + 10); }
                else         { m_zombieCostume.position = ccp(COCOS_COSTUME.position.x, COCOS_COSTUME.position.y + 5); }
            }
            else
            {
                if (IS_IPAD) { m_zombieCostume.position = ccp(COCOS_COSTUME.position.x - 10, COCOS_COSTUME.position.y + 10); }
                else         { m_zombieCostume.position = ccp(COCOS_COSTUME.position.x - 5 , COCOS_COSTUME.position.y + 5); }
            }
        }
        else
        {
            if (isMovingRight)
            {
                if (IS_IPAD) { m_zombieCostume.position = ccp(COCOS_COSTUME.position.x, COCOS_COSTUME.position.y + 30); }
                else         { m_zombieCostume.position = ccp(COCOS_COSTUME.position.x, COCOS_COSTUME.position.y + 15); }
            }
            else
            {
                if (IS_IPAD) { m_zombieCostume.position = ccp(COCOS_COSTUME.position.x - 10, COCOS_COSTUME.position.y + 30); }
                else         { m_zombieCostume.position = ccp(COCOS_COSTUME.position.x - 5 , COCOS_COSTUME.position.y + 15); }
            }
        }
    }
    else
    {
        m_zombieCostume.position = PLAYER_HEAD_COSTUME.position;
        
        if (alreadyDead)
            return;
        
        [_hud makeBlastInPosposition:ccp(m_zombieCostume.position.x, m_zombieCostume.position.y)];
        
        [[m_zombieCostume robot_] colorAllBodyPartsWithColor:ccc3(220, 72, 72)
                                                        part:0
                                                         all:YES
                                                     restore:YES
                                           restoreAfterDelay:0.15f];

        [AUDIO playEffect:l11_clap];

        alreadyDead = true;
        
        [m_zombieCostume JOE_HIDE:3  opacity:255];
        [m_zombieCostume JOE_HIDE:4  opacity:255];
        [m_zombieCostume JOE_HIDE:5  opacity:255];
        [m_zombieCostume JOE_HIDE:6  opacity:255];
        [m_zombieCostume JOE_HIDE:7  opacity:255];
        [m_zombieCostume JOE_HIDE:8  opacity:255];
        [m_zombieCostume JOE_HIDE:13 opacity:255];
        [m_zombieCostume JOE_HIDE:14 opacity:255];
        [m_zombieCostume JOE_HIDE:15 opacity:255];
        [m_zombieCostume JOE_HIDE:16 opacity:255];
        
         if (isMovingRight)
         {
             if (headJumps)
             {
                 headJumps = false;
                 PLAYER_HEAD_BODY->SetLinearVelocity(b2Vec2( PLAYER_HEAD_BODY->GetLinearVelocity().x / 2,  15 ));
             }
             if (headStays)
             {
                 headStays = false;
                 PLAYER_HEAD_BODY->SetLinearVelocity(b2Vec2( 0,  0 ));
             }
         }
        else
        {
            //fullZ.flipX = YES;
            
            if (headJumps)
            {
                headJumps = false;
                PLAYER_HEAD_BODY->SetLinearVelocity(b2Vec2( PLAYER_HEAD_BODY->GetLinearVelocity().x / 2,  15 ));
            }
            if (headStays)
            {
                headStays = false;
                PLAYER_HEAD_BODY->SetLinearVelocity(b2Vec2( 0,  0 ));
            }
        }
    }
    
    if (PLAYER_COSTUME.position.x >= kWidthScreen * 3.f)
    {
        if (offTutorial == false)
        {
            // Turn off tutorial
            [Combinations saveNSDEFAULTS_Bool:YES forKey:C_TUTORIAL_(_hud.level)];
        }
        offTutorial = true;
    }
 
}

-(void) flipZombie
{
    if (flipX)
    {
        [m_zombieCostume JOE_flipX: NO];
        flipX = false;
    }
    else
    {
        [m_zombieCostume JOE_flipX: YES];
        flipX = true;
    }
}

-(void) incBrains1 { [BRAINS_COSTUME1 removeSelf]; }
-(void) incBrains2 { [BRAINS_COSTUME2 removeSelf]; }
-(void) incBrains3 { [BRAINS_COSTUME3 removeSelf]; }

-(void) retrieveRequiredObjects
{
    //Retrieve pointers to parallax node and player sprite.
    paralaxNode = [level12_loader parallaxNodeWithUniqueName:@"Parallax_1"];
    NSAssert(paralaxNode!=nil, @"Couldn't find the parallax!");
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    touchBeg = location;
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    touchEnd = ccpSub(location, touchBeg);
    Fdistance = touchEnd.y;
    

    if (Fdistance >= 20)
    {
        if (isOnGrid == true && alreadyDead == false)
        {
            [AUDIO playEffect:l11_jump];
            
            if (IS_IPAD) { COCOS_BODY->SetLinearVelocity(b2Vec2( COCOS_BODY->GetLinearVelocity().x,  15 )); }
            else         { COCOS_BODY->SetLinearVelocity(b2Vec2( COCOS_BODY->GetLinearVelocity().x,  15 )); }
            
            isJump          = true;
            isOnGrid        = false;
            
            [self zoomOutSelf];
        }
    }
    else if (Fdistance <= -20 && alreadyDead == false)
    {
        if (touchEnded == false)
            return;
        touchEnded = false;
        
        if (getDown == false)
        {
            getDown = true;
            
            [AUDIO playEffect:l11_fall];
            
            [cfg runSelectorTarget:self selector:@selector(getUp) object:nil afterDelay:1.0f sender:self];
        }
    }
}

-(void)getUp
{
    getDown = false;
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    touchEnded = YES;
}

//-(void)onEnter{
//    
//    [super onEnter];
//    
//}
//
//-(void)onExit{
//    
//    //[self removeAllChildrenWithCleanup:YES];
//    [super onExit];
//    
//}

- (void) dealloc
{
    //[[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
   // [level12_loader removeParallaxNode:paralaxNode];
    
	if(nil != level12_loader) { [level12_loader release]; level12_loader = nil; }
    
	delete world;
	world = NULL;
	
	//delete m_debugDraw;
    
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
