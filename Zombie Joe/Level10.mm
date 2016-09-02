//  Created by Eimio on 5/22/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.

// Import the interfaces
#import "Level10.h"

#import "cfg.h"
#import "Combinations.h"
#import "Constants.h"
#import "CCFollowDynamic.h"
#import "SimpleAudioEngine.h"
#import "Tutorial.h"

#import "LHSettings.h"

#define CAR_BODY            [[level10_loader spriteWithUniqueName:@"wheel0"]body]
#define CAR_COSTUME         [level10_loader spriteWithUniqueName:@"wheel0"]

#define CAR_BODY2           [[level10_loader spriteWithUniqueName:@"onewheeler_0"]body]
#define CAR_COSTUME2        [level10_loader spriteWithUniqueName:@"onewheeler_0"]

#define CAR_BODY3           [[level10_loader spriteWithUniqueName:@"onewheeler_1"]body]
#define CAR_COSTUME4        [level10_loader spriteWithUniqueName:@"onewheeler_1"]

#define kBRAINS             [[level10_loader spriteWithUniqueName:@"brains"]body]
#define kBRAINS_COSTUME     [level10_loader spriteWithUniqueName:@"brains"]

#define kBRAINS2            [[level10_loader spriteWithUniqueName:@"brains2"]body]
#define kBRAINS_COSTUME2    [level10_loader spriteWithUniqueName:@"brains2"]

#define kBRAINS3            [[level10_loader spriteWithUniqueName:@"brains3"]body]
#define kBRAINS_COSTUME3    [level10_loader spriteWithUniqueName:@"brains3"]

#define SLOW_BODY           [[level10_loader spriteWithUniqueName:@"slow"]body]
#define SLOW_COSTUME        [level10_loader spriteWithUniqueName:@"slow"]

#define MCAR1_BODY          [[level10_loader spriteWithUniqueName:@"monster2"]body]
#define MCAR1_COSTUME       [level10_loader spriteWithUniqueName:@"monster2"]

#define MCAR1LW_COSTUME     [level10_loader spriteWithUniqueName:@"wheel2"]
#define MCAR1RW_COSTUME     [level10_loader spriteWithUniqueName:@"wheel2_1"]
#define MCAR1C_COSTUME      [level10_loader spriteWithUniqueName:@"car1"]
 
#define k_BG_1 10
#define k_BG_2 20

#define FOLLOW_TAG  220

@implementation Level10

-(NSString *)isIphone_or_ipad
{
    if (IS_IPAD) {return @"";}else return @"_iPhone";
}

//////////////////////////////////////////////////////////// COLLISIONS /////////////////////////////////////////
-(void)playerGroundCollision:(LHContactInfo*)contact
{
    isDead = true;
}

-(void)playerMONSTERCollision:(LHContactInfo*)contact
{
    if (isTouchMonster) return;
    
    [_hud makeBlastInPosposition:ccp(CAR_COSTUME2.position.x + CAR_COSTUME2.boundingBox.size.width/2, CAR_COSTUME2.position.y)];
    
    //change sprite color
    id changeColor = [CCTintTo actionWithDuration:0.1f red:220 green:72 blue:72];
    id backColor = [CCTintTo actionWithDuration:0.1f red:255 green:255 blue:255];
    
    id sequance = [CCSequence actions:changeColor, backColor, nil];
    [CAR_COSTUME4 runAction:sequance];
    
    isTouchMonster = true;
    
    [AUDIO playEffect:l13_clap];
    
    b2Vec2 force3 = b2Vec2(0.f, 0.0f);
    CAR_BODY2->SetLinearVelocity(force3);
    CAR_BODY2->SetAngularVelocity(0.0f);
}

-(void)playerGridCollision:(LHContactInfo*)contact
{
    if (isOnGrid) return;

    if (contact.contactType == LH_BEGIN_CONTACT)
    {
        isOnGrid        = true;
        secJump         = 0;
        isJump          = false;
        
        [AUDIO playEffect:l13_hitRail2];
    }
}

-(void)SlowingSpeed:(LHContactInfo*)contact
{
    isOnGrid = true;
    CAR_BODY2->SetLinearVelocity(b2Vec2(CAR_BODY2->GetLinearVelocity().x * 0.35f, CAR_BODY2->GetLinearVelocity().y));
    
    b2Fixture *a = contact.bodyB->GetFixtureList();
    
    b2Filter filter = a->GetFilterData();
    filter.maskBits = 0;
    a->SetFilterData(filter);
    
    if (contact.contactType == LH_BEGIN_CONTACT)
    {
        [AUDIO playEffect:l13_speedDown];
    }
}

-(void)GetBrains:(LHContactInfo*)contact
{
    if (brain1)
    return;

    [cfg makeBrainActionForNode:BrainSprite1
                 fakeBrainsNode:nil
                      direction:350
                   pixelsToMove:1
                           time:0
                         parent:self
              removeBrainsAfter:YES
             makeActionAfterall:@selector(incBrains1)
                         target:self];

    
    BrainSprite1.visible = NO;
    kBRAINS->SetLinearVelocity(b2Vec2(-20, 10));
    kBRAINS_COSTUME.opacity = 0;
    brain1 = true;

    //[_hud increaseBRAINSNUMBER];
}
-(void)GetBrains2:(LHContactInfo*)contact
{
    if (brain2)
        return;
    
    [cfg makeBrainActionForNode:BrainSprite2
                 fakeBrainsNode:nil
                      direction:350
                   pixelsToMove:1
                           time:0
                         parent:self
              removeBrainsAfter:YES
             makeActionAfterall:@selector(incBrains1)
                         target:self];
    
    BrainSprite2.visible = NO;
    kBRAINS2->SetLinearVelocity(b2Vec2(-20, 10));
    kBRAINS_COSTUME2.opacity = 0;
    brain2 = true;
    //[_hud increaseBRAINSNUMBER];
}
-(void)GetBrains3:(LHContactInfo*)contact
{
    if (brain3)
        return;
    
    [cfg makeBrainActionForNode:BrainSprite3
                 fakeBrainsNode:nil
                      direction:350
                   pixelsToMove:1
                           time:0
                         parent:self
              removeBrainsAfter:YES
             makeActionAfterall:@selector(incBrains1)
                         target:self];
    
    BrainSprite3.visible        = NO;
    kBRAINS_COSTUME3.visible    = NO;
    kBRAINS3->SetLinearVelocity(b2Vec2(-40, 10));
    //kBRAINS_COSTUME3.opacity = 0;
    brain3 = true;
    
    //[_hud increaseBRAINSNUMBER];
}

-(void) incBrains1
{
    [_hud increaseBRAINSNUMBER];
}

-(void)FinishM:(LHContactInfo*)contact
{
    if (isFinish) {
        return;
    }
    isFinish = true;
    
    [AUDIO playEffect:fx_winmusic];
    
    CAR_COSTUME2.visible = NO;
    CAR_COSTUME4.visible = NO;

    [_hud WINLevel];
    [_hud TIME_Stop];
    
    [level10_loader cancelPreCollisionCallbackBetweenTagA:CAR andTagB:FINISH];
}

-(void)endGridCollision:(LHContactInfo*)contact
{
    if (contact.contactType == LH_BEGIN_CONTACT)
    {
        isOnGrid = false;
        isJump   = true;
    }
}

-(void)monsterSound:(LHContactInfo*)contact
{
    if (contact.contactType == LH_BEGIN_CONTACT)
    {
        [AUDIO playEffect:l13_monster];
    }
}

-(void)monsterSound2:(LHContactInfo*)contact
{
    if (contact.contactType == LH_BEGIN_CONTACT)
    {
        [AUDIO playEffect:l13_monster2];
    }
}

-(void)finishLine:(LHContactInfo*)c_{
    
    if (c_.contactType == LH_BEGIN_CONTACT)
    {
        [self stopActionByTag:FOLLOW_TAG];
    }
    
}

///////////////////////////////////////////////////////////// LOAD COLLISIONS //////////////////////////////////////
-(void) setupCollisionHandling
{
    [level10_loader registerBeginOrEndCollisionCallbackBetweenTagA:CAR        andTagB:GROUND        idListener:self selListener:@selector(playerGroundCollision:)];
    [level10_loader registerBeginOrEndCollisionCallbackBetweenTagA:CAR        andTagB:MONSTER       idListener:self selListener:@selector(playerMONSTERCollision:)];
    [level10_loader registerBeginOrEndCollisionCallbackBetweenTagA:CAR        andTagB:GRID          idListener:self selListener:@selector(playerGridCollision:)];
    [level10_loader registerBeginOrEndCollisionCallbackBetweenTagA:CAR        andTagB:SLOW          idListener:self selListener:@selector(SlowingSpeed:)];
    [level10_loader registerBeginOrEndCollisionCallbackBetweenTagA:CAR        andTagB:BRAINS        idListener:self selListener:@selector(GetBrains:)];
    [level10_loader registerBeginOrEndCollisionCallbackBetweenTagA:CAR        andTagB:BRAINS2       idListener:self selListener:@selector(GetBrains2:)];
    [level10_loader registerBeginOrEndCollisionCallbackBetweenTagA:CAR        andTagB:BRAINS3       idListener:self selListener:@selector(GetBrains3:)];
    [level10_loader registerBeginOrEndCollisionCallbackBetweenTagA:CAR        andTagB:FINISH        idListener:self selListener:@selector(FinishM:)];
    [level10_loader registerBeginOrEndCollisionCallbackBetweenTagA:CAR        andTagB:ENDGRID       idListener:self selListener:@selector(endGridCollision:)];
    [level10_loader registerBeginOrEndCollisionCallbackBetweenTagA:CAR        andTagB:MSOUND        idListener:self selListener:@selector(monsterSound:)];
    [level10_loader registerBeginOrEndCollisionCallbackBetweenTagA:CAR        andTagB:MSOUND2       idListener:self selListener:@selector(monsterSound2:)];
    
    [level10_loader registerBeginOrEndCollisionCallbackBetweenTagA:CAR        andTagB:(enum LevelHelper_TAG)22       idListener:self selListener:@selector(finishLine:)];
    
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)addBGSprites
{
    for (int i = 0; i<=2; i++)
    {
        CCSprite *sprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"background1%@.jpg",[self isIphone_or_ipad]]];
        CCSprite *sprite2 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"kolona_front%@.png",[self isIphone_or_ipad]]];
        sprite.anchorPoint = ccp(0.5f, 0.5f);
        sprite2.anchorPoint = ccp(0.5f, 0);
        sprite.scale = kSCALE_FACTOR_FIX;
        sprite2.scale = kSCALE_FACTOR_FIX;
        if (IS_IPHONE_5)
        {
            sprite.scaleX   = 1.2;
        }
        switch (i)
        {
            case 0: sprite.position  = ccp(0, kHeightScreen/2);
                    sprite2.position = ccp(kWidthScreen*1.5f,0); break;
                
            case 1: sprite.position  = ccp([[self getChildByTag:k_BG_1] getChildByTag:0].position.x+[[self getChildByTag:k_BG_1] getChildByTag:0].contentSize.width/2, kHeightScreen/2);
                    sprite2.position = ccp([[self getChildByTag:k_BG_2] getChildByTag:0].position.x+kWidthScreen*1.3f,0); break;
                
            case 2: sprite.position  = ccp([[self getChildByTag:k_BG_1] getChildByTag:1].position.x+[[self getChildByTag:k_BG_1] getChildByTag:1].contentSize.width/2, kHeightScreen/2);
                    sprite2.position = ccp([[self getChildByTag:k_BG_2] getChildByTag:1].position.x+kWidthScreen*1.6f,0);break;
                
            default:break;
        }
        [[self getChildByTag:k_BG_1]addChild:sprite z:0 tag:i];
        [[self getChildByTag:k_BG_2]addChild:sprite2 z:0 tag:i];
    }
}

-(void)addBGLayears
{
    CCSprite *BG_1 = [[[CCSprite alloc]init]autorelease];
    BG_1.anchorPoint = ccp(0, 0);
    BG_1.position = ccp(0, 0);
    [self addChild:BG_1 z:-1 tag:k_BG_1];
    
    CCSprite *BG_2 = [[[CCSprite alloc]init]autorelease];
    BG_2.anchorPoint = ccp(0, 0);
    BG_2.position = ccp(0, 0);
    [self addChild:BG_2 z:999 tag:k_BG_2];

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

-(void)showTut_10
{
    Tutorial *tut = [[[Tutorial alloc]init]autorelease];
    tut.position = ccp(kWidthScreen/2,kHeightScreen/2);
    [_hud addChild:tut z:0 tag:3336];
    [tut TAP_TutorialRepeat:1 delay:0.3f runAfterDelay:0];
    
}

- (id)initWithHUD:(InGameButtons *)hud
{
	if( (self=[super init])) {
        _hud = hud;
        
		// enable touches
		self.isTouchEnabled = YES;
		
		b2Vec2 gravity;
		gravity.Set(0.0f, -30.0f);

        world = new b2World(gravity);
        
        world->SetAllowSleeping(true);

        world->SetContinuousPhysics(true);
        world->SetAutoClearForces(false);
        
        //[[LHSettings sharedInstance] setStretchArt:YES];

//		// Debug Draw functions
//		m_debugDraw = new GLESDebugDraw( PTM_RATIO * CC_CONTENT_SCALE_FACTOR()); //* CC_CONTENT_SCALE_FACTOR()
//		world->SetDebugDraw(m_debugDraw);
//        
//		uint32 flags = 0;
//		flags += GLESDebugDraw::e_shapeBit;
//		flags += GLESDebugDraw::e_jointBit;
////		flags += GLESDebugDraw::e_aabbBit;
////		flags += GLESDebugDraw::e_pairBit;
////		flags += GLESDebugDraw::e_centerOfMassBit;
//		m_debugDraw->SetFlags(flags);		
        
        if (IS_IPAD)
        {
            [LevelHelperLoader dontStretchArt];
        }

        level10_loader = [[LevelHelperLoader alloc] initWithContentOfFile:@"Level10_3"];
        [level10_loader addObjectsToWorld:world cocos2dLayer:self];
        [level10_loader createPhysicBoundaries:world];
        
        [level10_loader useLevelHelperCollisionHandling];

        //////////////////////// SET JOINTS ///////////////////////////////////
        myWheel  = [level10_loader jointWithUniqueName:@"Wheel_inWheel"];
        carMotor = (b2RevoluteJoint*)myWheel.joint;
        
        monster1Wheel = [level10_loader jointWithUniqueName:@"MCAR1_FRONT"];
        M1_carMotor   = (b2WheelJoint*)monster1Wheel.joint;
        
        /////////////////////// MAKE BRAINS FLY /////////////////////////////
        kBRAINS->ApplyForce(  b2Vec2( 0.0, 30.0*kBRAINS->GetMass()), kBRAINS->GetWorldCenter() );
        kBRAINS2->ApplyForce( b2Vec2( 0.0, 30.0*kBRAINS2->GetMass()),kBRAINS2->GetWorldCenter() );
        kBRAINS3->ApplyForce( b2Vec2( 0.0, 30.0*kBRAINS3->GetMass()),kBRAINS3->GetWorldCenter() );

        
        ////////////////////// MAKE CAMERA FOLLOW PLAYER ///////////////////
        if (IS_IPAD)        { [self runAction:[CCFollowDynamic actionWithTarget:CAR_COSTUME2 worldBoundary:CGRectMake(0,0,kWidthScreen * 56.3f,kHeightScreen) smoothingFactor:1.f nodePlace:0.1f]].tag = FOLLOW_TAG; }
        if (IS_IPHONE_5)    { [self runAction:[CCFollowDynamic actionWithTarget:CAR_COSTUME2 worldBoundary:CGRectMake(0,0,kWidthScreen * 50.7f,kHeightScreen) smoothingFactor:1.f nodePlace:0.1f]].tag = FOLLOW_TAG; }
        else                { [self runAction:[CCFollowDynamic actionWithTarget:CAR_COSTUME2 worldBoundary:CGRectMake(0,0,kWidthScreen * 60.0f,kHeightScreen) smoothingFactor:1.f nodePlace:0.1f]].tag = FOLLOW_TAG; }
        
        
        
        [_hud preloadBlast_self:self brainNr:3 parent:self];
        
        BrainSprite1 = (BrainRobot*)[self getChildByTag:TAG_BRAIN_1];
        BrainSprite2 = (BrainRobot*)[self getChildByTag:TAG_BRAIN_2];
        BrainSprite3 = (BrainRobot*)[self getChildByTag:TAG_BRAIN_3];
        
        kBRAINS_COSTUME.visible  = NO;
        kBRAINS_COSTUME2.visible = NO;
        kBRAINS_COSTUME3.visible = NO;
		
        [self setupCollisionHandling];
		[self schedule: @selector(tick:)];
        [self addBGLayears];
        [self addBGSprites];
        
        if (_hud.tutorialSHOW)
        {
            pause = YES;
            [self schedule:@selector(GAME_PAUSE) interval:0.1f];
        }
        
        heightD = kHeightScreen*0.2f;
        secJump = 0;

        isEngine    = false;
        brain1      = false;
        brain2      = false;
        brain3      = false;
        
        looseSnd    = true;
        
        //[[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"level3.mp3" loop:YES];
        if (![Combinations checkNSDEFAULTS_Bool_ForKey:C_TUTORIAL_(_hud.level)]){
        [cfg runSelectorTarget:self  selector:@selector(showTut_10) object:nil afterDelay:1 sender:self];
        }
        
	}
	return self;
}
////////////////////////////////////////////////////////////////////////////////
//-(void) draw
//{
//	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
//	// Needed states:  GL_VERTEX_ARRAY, 
//	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
//	glDisable(GL_TEXTURE_2D);
//	glDisableClientState(GL_COLOR_ARRAY);
//	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
//	
//	world->DrawDebugData();
//	
//	// restore default GL states
//	glEnable(GL_TEXTURE_2D);
//	glEnableClientState(GL_COLOR_ARRAY);
//	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
//}

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
		if (b->GetUserData() != NULL) {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			CCSprite *myActor = (CCSprite*)b->GetUserData();
			myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}	
	}

    if (isTouchMonster)
    {
        [myWheel removeSelf];
        myWheel = nil;
        
        b2Vec2 force3 = b2Vec2(0.f, 0.0f);
        CAR_BODY2->SetLinearVelocity(force3);
        CAR_BODY2->SetAngularVelocity(0.0f);
        CAR_BODY3->SetLinearVelocity(force3);
        CAR_BODY3->SetAngularVelocity(0.0f);
        
        heightD -= 6;
        
        b2Vec2 force5 = b2Vec2(kWidthScreen*0.10f, heightD);
        b2Vec2 point4 = CAR_BODY2->GetWorldCenter();
        CAR_BODY2->SetTransform(b2Vec2(CAR_BODY2->GetPosition().x, CAR_BODY2->GetPosition().y), 0);
        CAR_BODY3->ApplyLinearImpulse(force5, point4);
        
        carMotor->SetMotorSpeed(0);
        
        CAR_BODY3->GetFixtureList()->SetSensor(true);

        [cfg runSelectorTarget:self selector:@selector(gameOvr) object:nil afterDelay:1.0f sender:self];
    }
    
    if (CAR_COSTUME2.position.x >= kWidthScreen * 3.f)
    {
        if (offTutorial == false)
        {
            // Turn off tutorial
            [Combinations saveNSDEFAULTS_Bool:YES forKey:C_TUTORIAL_(_hud.level)];
        }
        offTutorial = true;
    }

    
    if (isDead)
    {
        if (!drawHUD)
        {
            
            [_hud TIME_Stop];
            [_hud LOSTLevel];
            drawHUD = YES;
            [self stopAllActions];
        }
    }

    /////////////////////// if player speed too slow give him force /////////////////
    if (CAR_BODY2->GetLinearVelocity().Length() <= 10)
    {
        
        b2Vec2 force2 = b2Vec2(10.f, 0.0f);
        b2Vec2 point = CAR_BODY2->GetWorldCenter();
        
        CAR_BODY2->ApplyLinearImpulse(force2, point);
    }

    //////////////////////////// BACKGROUNDS ////////////////////////////////////////
    [self getChildByTag:k_BG_1].position = ccp(-self.position.x / 3.f, 0);
    [self getChildByTag:k_BG_2].position = ccp(self.position.x * 0.7f, 0);
    
    //-------------------------------------
    if (-self.position.x + self.contentSize.width >=[[self getChildByTag:k_BG_1] getChildByTag:0].position.x + [[[self getChildByTag:k_BG_1] getChildByTag:0] boundingBox].size.width/2-self.position.x/3.f)
    {
        [[self getChildByTag:k_BG_1] getChildByTag:2].position =
        ccp([[self getChildByTag:k_BG_1] getChildByTag:1].position.x+[[[self getChildByTag:k_BG_1] getChildByTag:1] boundingBox].size.width, [[self getChildByTag:k_BG_1] getChildByTag:1].position.y);
    }
    if (-self.position.x + self.contentSize.width >= [[self getChildByTag:k_BG_1] getChildByTag:1].position.x + [[[self getChildByTag:k_BG_1] getChildByTag:1] boundingBox].size.width/2-self.position.x/3.f)
    {
        [[self getChildByTag:k_BG_1] getChildByTag:1].position =
        ccp([[self getChildByTag:k_BG_1] getChildByTag:0].position.x+[[[self getChildByTag:k_BG_1] getChildByTag:0] boundingBox].size.width, [[self getChildByTag:k_BG_1] getChildByTag:0].position.y);
    }
    
    if (-self.position.x + self.contentSize.width >= [[self getChildByTag:k_BG_1] getChildByTag:2].position.x + [[[self getChildByTag:k_BG_1] getChildByTag:2] boundingBox].size.width/2-self.position.x/3.f)
    {
        [[self getChildByTag:k_BG_1] getChildByTag:0].position =
        ccp([[self getChildByTag:k_BG_1] getChildByTag:2].position.x+[[[self getChildByTag:k_BG_1] getChildByTag:2] boundingBox].size.width, [[self getChildByTag:k_BG_1] getChildByTag:2].position.y);
    }
    
    
    
    //-------------------------------------
    if (-self.position.x > [[self getChildByTag:k_BG_2]getChildByTag:0].position.x + self.position.x*0.7)
    {
        [[self getChildByTag:k_BG_2]getChildByTag:2].position = ccp([[self getChildByTag:k_BG_2] getChildByTag:1].position.x+kWidthScreen*1.7f,[[self getChildByTag:k_BG_2]getChildByTag:2].position.y);
    }
    
    if (-self.position.x > [[self getChildByTag:k_BG_2]getChildByTag:1].position.x + self.position.x*0.7)
    {
        [[self getChildByTag:k_BG_2]getChildByTag:0].position = ccp([[self getChildByTag:k_BG_2] getChildByTag:2].position.x+kWidthScreen*2.f,[[self getChildByTag:k_BG_2]getChildByTag:0].position.y);
    }
    
    if (-self.position.x > [[self getChildByTag:k_BG_2]getChildByTag:2].position.x + self.position.x*0.7)
    {
        [[self getChildByTag:k_BG_2]getChildByTag:1].position = ccp([[self getChildByTag:k_BG_2] getChildByTag:0].position.x+kWidthScreen*2.5f,[[self getChildByTag:k_BG_2]getChildByTag:1].position.y);
    }
    
    
    if (CAR_COSTUME2.position.x >= kWidthScreen * 29.f)
    {
       // M1_carMotor->SetMotorSpeed(10);
    }

    // *** set brain positions
    
    [_hud BRAIN_:TAG_BRAIN_1 position:kBRAINS_COSTUME.position parent:self];
    //[_hud BRAIN_:TAG_BRAIN_1 zOrder:120 parent:self];
    
    [_hud BRAIN_:TAG_BRAIN_2 position:kBRAINS_COSTUME2.position parent:self];
    //[_hud BRAIN_:TAG_BRAIN_2 zOrder:120 parent:self];
    
    [_hud BRAIN_:TAG_BRAIN_3 position:kBRAINS_COSTUME3.position parent:self];
    //[_hud BRAIN_:TAG_BRAIN_3 zOrder:120 parent:self];

}

-(void) gameOvr
{
    isDead = true;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{  
    secJump++;
    
    if (secJump <=2 && isDead == false)
    {
        if (secJump == 1) {
            CAR_BODY2->ApplyLinearImpulse(b2Vec2( 0,  1000 ), CAR_BODY2->GetWorldCenter());
        }
        else if (secJump == 2) {
            CAR_BODY2->ApplyLinearImpulse(b2Vec2( 0,  600 ), CAR_BODY2->GetWorldCenter());
        }
        
        [AUDIO playEffect:l13_jump];
        
        isOnGrid = false;
        isJump = true;
    }
}

- (void) dealloc
{
	if(nil != level10_loader) { [level10_loader release]; level10_loader = nil; }
    
	delete world;
	world = NULL;
	
	delete m_debugDraw;

	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
