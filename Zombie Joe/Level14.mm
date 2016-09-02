//
//  HelloWorldLayer.mm
//  Level 14
//
//  Created by macbook on 2013-06-17.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import "Level14.h"
#import "RedBlueMonster.h"
#import "constants_14.h"
#import "CCFollowDynamic.h"
#import "cfg.h"
#import "Constants.h"
#import "SimpleAudioEngine.h"
#import "b6luxParallaxBg.h"
#import "Tutorial.h"

#define DEBUG_LEVEL14     NO
#define COLLISIONS_ENEMY  YES

#define TAG_ENEMY       4
#define TAG_ENEMY_RED   2
#define TAG_ENEMY_BLUE  3

#define COUNT_MONSTERS_RED   2
#define COUNT_MONSTERS_BLUE  2

#define TAG_PLAYER 5
#define TAG_ROPE   6
#define TAG_PLAYER_ZOMBIE 7
#define TAG_WALL_LEFT 8
#define TAG_WALL_RIGHT 9
#define TAG_BRAIN 10
#define TAG_BRAIN1 11
#define TAG_BRAIN2 12
#define TAG_FINISH 13


#define BITS_ROPE 65533
#define BITS_ZOMBIE 65531

#define ENEMY_RED_TAGGY 100
#define ENEMY_BLUE_TAGGY 200

#define JUMP_IMPULSE_Y (IS_IPAD) ? 18.f : 18.f
#define PITCH_KOEFF (IS_IPAD) ? 30.f : 15.f

#define MONSTER_DEALLOC_DISTANCE ((kHeightScreen)*(1.f))

#define IMPULSE_LINEAR_DONW (IS_IPAD) ? (-20.f) : (-0.5f)
#define IMPUSE_DOWN_DEFAULT (IS_IPAD) ? (-10.f) : (-0.5f)

#define GRAVITY_DEF_X   (IS_IPAD) ? (0.f) : (0.f)
#define GRAVITY_DEF_Y   (IS_IPAD) ? (-10.0f) : (-10.f) //(-150.0f) : (-80.f)

#define ACTION_TAG_FALLOW 1001

#define ACTOR_PLAYER                    [loader spriteWithUniqueName:@"PLAYER"]
#define ACTOR_PLAYER_ZOMBIE             [loader spriteWithUniqueName:@"PLAYER_ZOMBIE"]

#define ACTOR_GIRAFE_POS_X              [loader spriteWithUniqueName:@"GIRAFE_MAX_POS_X"]
#define ACTOR_GIRAFE                    [loader spriteWithUniqueName:@"giraffe_1"]

#define ACTOR_FINIS_ZOMBIE_PLACE         [loader spriteWithUniqueName:@"zp"]
#define ACTOR_FINIS_ZOMBIE_FP           [loader spriteWithUniqueName:@"zfp"]    //
#define ACTOR_CAMERA_OFF_CHP           [loader spriteWithUniqueName:@"cameraOff"]    //

#define ACTOR_BRAINS_GIRAFFE            [loader spriteWithUniqueName:@"brains_giraffe"]  //brains_giraffe

#define LAYER_MAIN                      [loader layerWithUniqueName:@"MAIN_LAYER"]

#define ACTOR_BRAIN1                    [loader layerWithUniqueName:@"brains_1"]
#define ACTOR_BRAIN2                    [loader layerWithUniqueName:@"brains_2"]

#define TAG_NOF_FALLOW_BODY 101001

//giraffe

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.

#define PTM_RATIO [LevelHelperLoader pointsToMeterRatio]  //32 ???????? WHY 2.222

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};

// HelloWorldLayer implementation
@implementation Level14


-(void)setLayerActorsOpacityTo:(float)val_{
    
    for (LHSprite *s in [loader allSprites])
    {
        
        if (s.tag == TAG_PLAYER) {
            continue;
        }
        [s runAction:[CCFadeTo actionWithDuration:1.5f opacity:val_]];
    }
    
}

-(void) draw
{
    if (!DEBUG_LEVEL14) {
        return;
    }
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY,
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
}

-(void) tick: (ccTime) dt
{
    pause = NO;
    
	int32 velocityIterations = 8;  //10 //8
	int32 positionIterations = 1;    //8   //1
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
    
	
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL)
        {
			CCSprite *myActor = (CCSprite*)b->GetUserData();
            
            if (myActor.tag == TAG_NOF_FALLOW_BODY)
            {
                continue;
            }
            
			myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
            
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}
	}
    
    if (enableFliersFallowBody)
    {
        jNf.position = ccpAdd(ACTOR_PLAYER.position, ccp(0, -ACTOR_PLAYER.boundingBox.size.height*0.1f));
       // jNf.position = ACTOR_PLAYER.position;
    }
   
    if (!removeWorld) {
        [ACTOR_PLAYER_ZOMBIE body]
        ->SetTransform(b2Vec2(jNf.position.x/PTM_RATIO,
                              jNf.position.y/PTM_RATIO-ACTOR_PLAYER_ZOMBIE.boundingBox.size.height/PTM_RATIO), 0);
    }

    
    if (enableZombieFollowFliers)
    {
        zombiebody.position = 
                ccp(jNf.position.x-(ACTOR_PLAYER_ZOMBIE.boundingBox.size.width*0.5f),
                                  jNf.position.y-
                                  (ACTOR_PLAYER_ZOMBIE.boundingBox.size.height*0.975f));
    }
    
    if (ACTOR_PLAYER.position.y > ACTOR_CAMERA_OFF_CHP.position.y && [self getActionByTag:ACTION_TAG_FALLOW])
    {
        [self stopActionByTag:ACTION_TAG_FALLOW];
    }
    
    if (dead || removeWorld)   return;
    
    [self chekfIffFallingWithSensorOff];
    
    [self monstersPositionsRotations];
    
    if (removeWorld)
    {
        [loader removeAllPhysics];
    }

}

-(LHSprite*)getBirdPositionByUNIQUENAME:(int)tagID_ type:(int)type_{
    
    NSString *typeName = @"EVILRED_";
    
    if (type_==TYPE_MONSTER_BLUE)
    {
        typeName = @"EVILBLUE_";
    }
    
    return [loader spriteWithUniqueName:[NSString stringWithFormat:@"%@%i",typeName,tagID_]];
    
}

-(void)addMonsters_NROFMONSTERS:(int)count type:(int)type_{
    
    for (int x = 1; x <= count; x++)
    {
        
        RedBlueMonster *monstr = [[[RedBlueMonster alloc]initWithRect:CGRectMake(0, 0, 0, 0)
                                                           withLoader:loader
                                                                 TYPE:type_
                                                                   ID:x]autorelease];
        [self addChild:monstr];
        
        monstr.position = [self getBirdPositionByUNIQUENAME:x type:type_].position;
        
    }
    
}

-(void)showMonsterBlocks:(BOOL)yes_{
    
    for (LHSprite *s in [loader allSprites])
    {
        if (s.tag == TAG_ENEMY_BLUE || s.tag == TAG_ENEMY_RED)
        {
            s.visible = yes_;
            // [s removeSelf];
        }
    }
    
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


-(void)setBodyToSensor_byTag:(int)objTag_ :(BOOL)on_{
    
    for (LHSprite *s in [loader allSprites])
    {
        if (s.tag == objTag_)
        {
            b2Fixture *a = [s body]->GetFixtureList();
            a->SetSensor(on_);
        }
        
    }
    
}

-(void)CollisionsForObject:(int)objectTAG Turn:(BOOL)on_{
    
    int bits = 0;
    
    if (on_)
    {
        if (objectTAG==TAG_ROPE)
        {
            bits = BITS_ROPE;
        }
        else if (objectTAG == TAG_PLAYER_ZOMBIE)
        {
            bits = BITS_ZOMBIE;
        }
        else
        {
            bits = 65535;
        }
    }
    
    for (LHSprite *s in [loader allSprites])
    {
        if (s.tag == objectTAG)
        {
            b2Fixture *a = [s body]->GetFixtureList();
            
            b2Filter filter = a->GetFilterData();
            filter.maskBits =     bits;
            a->SetFilterData(filter);
        }
        
    }
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{

	static float prevX=0, prevY=0;
	
	//#define kFilterFactor 0.05f
#define kFilterFactor 1.0f	// don't use filter. the code is here just as an example
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
    
    if (removeWorld ) return;
    
    
    
     float linVelX = [ACTOR_PLAYER body]->GetLinearVelocity().x;
     float linVelY = [ACTOR_PLAYER body]->GetLinearVelocity().y;
   
 
    /*
    float acc1;
    
    if (accelY > 0) {
        acc1 = accelY*100;
        [[zombiebody robot_]ACTION_UPDATE_ANIMATION_Between_State1:2 State2_:8 percent:acc1*2];
    }
    else if (accelY < 0){
        acc1 = -(accelY*100);
         [[zombiebody robot_]ACTION_UPDATE_ANIMATION_Between_State1:2 State2_:7 percent:acc1*2];
       
    }
     */
    
     //  NSLog(@"line x %f",accelY);
    
    
    if (enableAccelerometer)
    {
        if (accelY < -0.10f)// LINE_X-0.5f)// && enableJUMP)
        {
            [zombiebody JOE_HANGING_LEFT];
            // [[jNf returnJoe]JOE_HANGING_LEFT];// [zombiebody JOE_HANGING_LEFT];
        }
        else if (accelY > 0.10f)//>= LINE_X+0.5f)// && enableJUMP)
        {
            [zombiebody JOE_HANGING_RIGHT];
            // [[jNf returnJoe]JOE_HANGING_RIGHT];   // [zombiebody JOE_HANGING_RIGHT];
        }
        else
        {
            [[zombiebody robot_] JOE_HANGING_DOWN_2];
            // [[jNf returnJoe]JOE_HANGING_RIGHT];   // [zombiebody JOE_HANGING_RIGHT];
        }
        
        LINE_X = accelY;
        
        [jNf rotateHandsBy:linVelX];
    }
    
    
 
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        [ACTOR_PLAYER body]->SetLinearVelocity(b2Vec2(accelY * 30,linVelY));
    }
    
    else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
    {
        [ACTOR_PLAYER body]->SetLinearVelocity(b2Vec2(-accelY * 30,linVelY));
    }
    
}

-(BOOL)permissionToJUMP{
    
    if (dead)
    {
        return NO;
    }
    
    if (!enableJUMP)
    {
        return NO;
    }
    
    if  ([ACTOR_PLAYER body]->GetLinearVelocity().y > 15.f || [ACTOR_PLAYER body]->GetLinearVelocity().y < -15.f)
    {
        return NO;
    }
    
    if (!ropeBeginContact)
    {
        return NO;
    }
    
    return YES;
    
}

-(void)brainIncrease{
    
   // NSLog(@"increase brain");
    [_hud increaseBRAINSNUMBER];
    
}

-(void)chekfIffFallingWithSensorOff{
    
    float linVelY = [ACTOR_PLAYER body]->GetLinearVelocity().y;
    
   // BOOL sensor =  ([ACTOR_PLAYER body]->GetFixtureList()->IsSensor());
    
    if (linVelY < -5 && !enableJUMP && !ropeBeginContact)
    {
        [self setBodyToSensor_byTag:TAG_ROPE :NO];
        //enableJUMP = YES;
    }
    
}

-(void)ropePOSTPlayerCollision:(LHContactInfo*)contact{
    
    ropeBeginContact = YES;
    enableJUMP = YES;
    
}

-(void)ropePlayerCollision:(LHContactInfo*)contact{
    
// *** BEGIN ROPE CONTACT
    
   // NSLog(@"VELOCITY %f",contact.bodyA->GetLinearVelocity().y);
    
    if (contact.contactType == LH_BEGIN_CONTACT)
    {
        
        if      (contact.bodyA->GetLinearVelocity().y < -0.1f) {
//* PLAYER UPPER ROPE
            enableJUMP = YES;
        }
        else if (contact.bodyA->GetLinearVelocity().y > 1) {
//* PLAYER UNDER THE ROPE BEGIN CONTACT
        }
        enterRopeVelocityY = contact.bodyA->GetLinearVelocity().y;
    }
    
    
// *** END ROPE CONTACT
    
    else if (contact.contactType == LH_END_CONTACT)
    {
        
        ropeBeginContact = NO;
        
// * Jump on the rope helper
        if (enterRopeVelocityY > 0 && !enableJUMP && (contact.spriteA.position.y >
           (contact.spriteB.position.y+contact.spriteB.boundingBox.size.height*0.5f)))
        {
            [self setBodyToSensor_byTag:TAG_ROPE :NO];
            [ACTOR_PLAYER body]->SetLinearVelocity(
                        b2Vec2([ACTOR_PLAYER body]->GetLinearVelocity().x,
                        5.f));
            
            //ApplyForceToCenter(b2Vec2(contact.spriteA.position.x/PTM_RATIO, contact.contactPoint.y+30/PTM_RATIO));
            

        }
        
// * When on the hill just a small auto-jumpin glitch
        else if (contact.bodyA->GetLinearVelocity().y < 10)
        {
            enableJUMP = NO;
        }
        
// * It's a jump from bottom!
       else  if (contact.bodyA->GetLinearVelocity().y >= 10)
        {
         //   [[jNf returnJoe]JOE_HANGING_DOWN];
            
            exitRopeVelocityY = contact.bodyA->GetLinearVelocity().y;
            [self setBodyToSensor_byTag:TAG_ROPE :YES];
            enableJUMP = NO;
        }

    }
    
    return;
    if (contact.contactType == LH_BEGIN_CONTACT)
    {
        enterRopeVelocityY = contact.bodyA->GetLinearVelocity().y;
        ropeBeginContact = YES;
    }
    
    else  if (contact.contactType == LH_END_CONTACT && !enableJUMP)
    {
        ropeBeginContact = NO;
        
        exitRopeVelocityY = contact.bodyA->GetLinearVelocity().y;
        if (enterRopeVelocityY > 0)
        {
            [self setBodyToSensor_byTag:TAG_ROPE :NO];
            [ACTOR_PLAYER body]->SetLinearVelocity(b2Vec2([ACTOR_PLAYER body]->GetLinearVelocity().x, 3));
            enableJUMP = YES;
        }
    }
    
}

-(void)sensorOnRope{
    
    [self setBodyToSensor_byTag:TAG_ROPE :NO];
    
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!canTouch) {
        return NO;
    }
    CGPoint location = [LAYER_MAIN convertTouchToNodeSpace:touch];
    
    if(CGRectContainsPoint([ACTOR_GIRAFE boundingBox],location) && !giraffeTouched)
    {
    //    NSLog(@"touched on giraffe");
        [AUDIO playEffect:l7_giraffeclick];
        
        giraffeTouched = YES;
        ACTOR_BRAINS_GIRAFFE.position = ACTOR_GIRAFE.position;
        
        [cfg makeBrainActionForNode:ACTOR_BRAINS_GIRAFFE
                     fakeBrainsNode:nil
                          direction:180
                       pixelsToMove:0
                             parent:self
                  removeBrainsAfter:YES
                 makeActionAfterall:@selector(brainIncrease)
                             target:self];

        return NO;
    }
    
    if (!enableJUMP)       return NO;
    
  //  if (!ropeBeginContact) return NO;
    
    [ACTOR_PLAYER body]->SetLinearVelocity(b2Vec2(0,JUMP_IMPULSE_Y));
    
    [AUDIO playEffect:joe_s_jump];
    
   
    
    return NO;
}

-(void)addMainPlayer{
    
    jNf =[[[JoeAndFlyiers alloc]initWithRect:CGRectMake(0, 0, 0, 0) withLoader:loader parent:self]autorelease];
    [self addChild:jNf];
    
    enableFliersFallowBody = YES;
    
}

-(void)killedAction{
    
    enableJUMP = NO;
    dead = YES;
    
}

-(void)BrainCollision_1:(LHContactInfo*)contact{
  //  NSLog(@"brain collision");
    
    //SNAP TOP
    LHSprite *brains = [loader createSpriteWithName:@"brains"
                                          fromSheet:@"AllSpriteslvl14"
                                         fromSHFile:@"SpriteSheetsLevel14" parent:self];
    
    brains.position = contact.spriteB.position;
    
    
    [cfg makeBrainActionForNode:contact.spriteB
                 fakeBrainsNode:brains
                      direction:270
                   pixelsToMove:0
                         parent:self
              removeBrainsAfter:NO
             makeActionAfterall:@selector(brainIncrease)
                         target:self];
    
    
    [loader cancelBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_PLAYER andTagB:(enum LevelHelper_TAG)TAG_BRAIN1];
    
}

-(void)BrainCollision_2:(LHContactInfo*)contact{
    //NSLog(@"brain collision");
    
    LHSprite *brains = [loader createSpriteWithName:@"brains"
                                          fromSheet:@"AllSpriteslvl14"
                                         fromSHFile:@"SpriteSheetsLevel14" parent:self];
    
    brains.position = contact.spriteB.position;
    
    
    [cfg makeBrainActionForNode:contact.spriteB
                 fakeBrainsNode:brains
                      direction:90
                   pixelsToMove:0
                         parent:self
              removeBrainsAfter:NO
             makeActionAfterall:@selector(brainIncrease)
                         target:self];
    
    [loader cancelBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_PLAYER andTagB:(enum LevelHelper_TAG)TAG_BRAIN2];
}

-(void)EnemyPlayerCollision:(LHContactInfo*)contact{
    
   // NSLog(@"contact point %f %f",contact.contactPoint.x,contact.contactPoint.y);
    if (death) {
        return;
    }
    
    if (contact.contactType == LH_BEGIN_CONTACT)
    {
      //  removeWorld = YES;
        death = YES;
        
        canTouch= NO;
        
        [[zombiebody robot_] ACTION_CLOSE_EYES_eyesTag:10];
        
        [self killedAction];
        pt_ = contact.spriteA.position;
        
        [zombiebody showKillBlastEffectInPosition:contact.spriteA.position];
        
        [loader cancelBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_PLAYER
                                                     andTagB:(enum LevelHelper_TAG)TAG_ROPE];
        
        [loader cancelBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_PLAYER_ZOMBIE
                                                     andTagB:(enum LevelHelper_TAG)TAG_ROPE];
        
                                          
        
        [[zombiebody robot_] colorAllBodyPartsWithColor:ccc3(220, 72, 72)
                                              part:0
                                               all:YES
                                           restore:YES
                                 restoreAfterDelay:0.15f];

        [_hud Lost_STATE_AFTERDELAY:0.5f];
        
        if (ACTOR_PLAYER.position.y > kHeightScreen*3)
        {
            [Combinations saveNSDEFAULTS_Bool:YES forKey:C_TUTORIAL_([_hud level])];
           // return;
        }
    }
    
  //  contact.spriteA.tag = TAG_NOF_FALLOW_BODY;
    
    [self CollisionsForObject:TAG_ROPE Turn:NO];
    [self CollisionsForObject:TAG_PLAYER Turn:NO];
    [self CollisionsForObject:TAG_PLAYER_ZOMBIE Turn:NO];
    
    removeWorld = YES;
    
  //   [self setBodyToSensor_byTag:TAG_PLAYER_ZOMBIE :YES];
  
    // [self setBodyToSensor_byTag:TAG_PLAYER :YES];
    
    
  //  b2Body *b = contact.bodyB;
    
   // b->SetType(b2_dynamicBody);
    
    
  
    
    for(LHJoint* myJoint in [ACTOR_PLAYER_ZOMBIE jointList])
    {
        //do something with myJoint variable
        [myJoint removeSelf];
    }
    
    {
        for(LHJoint* myJoint in [ACTOR_PLAYER jointList])
        {
            //do something with myJoint variable
            [myJoint removeSelf];
        }
    }
    
    [ACTOR_PLAYER body]->ApplyLinearImpulse(b2Vec2(-0.1f   , 0), [ACTOR_PLAYER body]->GetPosition());
   // [ACTOR_PLAYER_ZOMBIE body]->ApplyLinearImpulse(b2Vec2(0.1f   , 0), [ACTOR_PLAYER_ZOMBIE body]->GetPosition());
    
}

-(void)WallCollisionRight:(LHContactInfo*)contact{
    
    if (contact.contactType == LH_BEGIN_CONTACT)
    {
   //     NSLog(@"collided with wall RIGHT");
        
        contact.bodyB->GetFixtureList()->SetFriction(0);
        contact.bodyB->GetFixtureList()->SetDensity(0);
        contact.bodyB->GetFixtureList()->SetRestitution(0);
        
    }
    
    [loader cancelBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_PLAYER
                                                 andTagB:(enum LevelHelper_TAG)TAG_WALL_RIGHT];
    
}

-(void)WallCollisionLeft:(LHContactInfo*)contact{
    
    // NSLog(@"rope and player collision");
    if (contact.contactType == LH_BEGIN_CONTACT)
    {
   //     NSLog(@"collided with wall LEFT");
        
        contact.bodyB->GetFixtureList()->SetFriction(0);
        contact.bodyB->GetFixtureList()->SetDensity(0);
        contact.bodyB->GetFixtureList()->SetRestitution(0);
        
    }
    
    [loader cancelBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_PLAYER
                                                 andTagB:(enum LevelHelper_TAG)TAG_WALL_LEFT];
    
}

-(void)finishAchieved:(LHContactInfo*)contact{
    
    if (contact.contactType == LH_END_CONTACT && contact.bodyA->GetPosition().y > contact.bodyB->GetPosition().y)
    {
     //   NSLog(@"finished");
        [loader cancelBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_PLAYER_ZOMBIE
                                                     andTagB:(enum LevelHelper_TAG)TAG_FINISH];
        
        [self setBodyToSensor_byTag:TAG_FINISH :NO];
        //[self CollisionsForObject:TAG_FINISH Turn:YES];
        
        [self setBodyToSensor_byTag:TAG_PLAYER_ZOMBIE :YES];
        [self CollisionsForObject:TAG_PLAYER_ZOMBIE Turn:YES];
        
        [self setBodyToSensor_byTag:TAG_PLAYER :YES];
        
        
        
        enableZombieFollowFliers = NO;
        
        enableAccelerometer = NO;
        
       //  [self stopActionByTag:ACTION_TAG_FALLOW];
        
        [loader cancelBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_PLAYER andTagB:(enum LevelHelper_TAG)TAG_ENEMY];
                [loader cancelBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_PLAYER andTagB:(enum LevelHelper_TAG)TAG_ENEMY_BLUE];
                        [loader cancelBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_PLAYER andTagB:(enum LevelHelper_TAG)TAG_ENEMY_RED];
        
        [_hud TIME_Stop];
        
        //[zombiebody JOE_WALK];
        
        [[zombiebody robot_] JOE_WALK_SPEED:2];
        
        removeWorld = YES;
        
         birdSound = YES;
        
        [AUDIO playEffect:fx_winmusic];
        
        id jumpBy = [CCJumpTo actionWithDuration:0.5f
                                        position:ACTOR_FINIS_ZOMBIE_PLACE.position
                                          height:ACTOR_PLAYER_ZOMBIE.boundingBox.size.height jumps:1];
        
        id move = [CCMoveTo actionWithDuration:4 position:ACTOR_FINIS_ZOMBIE_FP.position];
        id anim= [CCCallBlock actionWithBlock:^(void){[[zombiebody robot_] JOE_WALK_SPEED:2];}];
        id win = [CCCallBlock actionWithBlock:^(void){[_hud WINLevel];}];
        id seq = [CCSequence actions:jumpBy,anim,move,win, nil];
        [zombiebody runAction:seq];
        //zombiebody.position= ACTOR_FINIS_ZOMBIE_PLACE.position;
        
       // 
       // 
        
      //  [self stopActionByTag:ACTION_TAG_FALLOW];
        
        //[ACTOR_PLAYER body]->ApplyLinearImpulse(b2Vec2(-5   , 0), [ACTOR_PLAYER body]->GetPosition());
    //    [ACTOR_PLAYER_ZOMBIE body]->ApplyLinearImpulse(b2Vec2(20   , 20), [ACTOR_PLAYER_ZOMBIE body]->GetPosition());
        
    }
}

-(void)registerCollisions{
    
    [loader useLevelHelperCollisionHandling];
    
    
    //-----ROPE
    [loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_PLAYER
                                                   andTagB:(enum LevelHelper_TAG)TAG_ROPE
                                                idListener:self selListener:@selector(ropePlayerCollision:)];
    
    [loader registerPostCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_PLAYER
                                             andTagB:(enum LevelHelper_TAG)TAG_ROPE
                                                idListener:self selListener:@selector(ropePOSTPlayerCollision:)];
    
    //-----ENEMY
    if (COLLISIONS_ENEMY)
    {
        
        [loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_PLAYER
                                                       andTagB:(enum LevelHelper_TAG)TAG_ENEMY
                                                    idListener:self selListener:@selector(EnemyPlayerCollision:)];
        
        [loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_PLAYER_ZOMBIE
                                                       andTagB:(enum LevelHelper_TAG)TAG_ENEMY
                                                    idListener:self selListener:@selector(EnemyPlayerCollision:)];
        
        [loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_PLAYER_ZOMBIE
                                                       andTagB:(enum LevelHelper_TAG)TAG_ENEMY_BLUE
                                                    idListener:self selListener:@selector(EnemyPlayerCollision:)];
        
        [loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_PLAYER_ZOMBIE
                                                       andTagB:(enum LevelHelper_TAG)TAG_ENEMY_RED
                                                    idListener:self selListener:@selector(EnemyPlayerCollision:)];
        
        [loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_PLAYER
                                                       andTagB:(enum LevelHelper_TAG)TAG_ENEMY_BLUE
                                                    idListener:self selListener:@selector(EnemyPlayerCollision:)];
        
        [loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_PLAYER
                                                       andTagB:(enum LevelHelper_TAG)TAG_ENEMY_RED
                                                    idListener:self selListener:@selector(EnemyPlayerCollision:)];
        
    }

    //----brains
    [loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_PLAYER
                                                   andTagB:(enum LevelHelper_TAG)TAG_BRAIN1
                                                idListener:self selListener:@selector(BrainCollision_1:)];
    
    [loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_PLAYER
                                                   andTagB:(enum LevelHelper_TAG)TAG_BRAIN2
                                                idListener:self selListener:@selector(BrainCollision_2:)];
    
    // finish
    [loader registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)TAG_PLAYER_ZOMBIE
                                                   andTagB:(enum LevelHelper_TAG)TAG_FINISH
                                                idListener:self selListener:@selector(finishAchieved:)];
    
}




-(void)zombieFallowHisBlock{
    
    zombiebody = [[[JoeZombieController alloc]initWitPos:ccp(0, 0) size:CGSizeMake(20, 20) sender:self brains:3]autorelease];
    [self addChild:zombiebody];
    zombiebody.scale = 0.4f;
    zombiebody.anchorPoint= ccp(0.5f, 1.f);
    [zombiebody JOE_HANGING_DOWN];
    
   // [self schedule:@selector(zombieFallow:)];
    
    enableZombieFollowFliers = YES;
    
}

-(void)zombieFallow:(ccTime)dt{
    
    /*
    zombiebody.position = ccp(ACTOR_PLAYER_ZOMBIE.position.x-(ACTOR_PLAYER_ZOMBIE.boundingBox.size.width*0.5f),
                              ACTOR_PLAYER_ZOMBIE.position.y +
                              (ACTOR_PLAYER_ZOMBIE.boundingBox.size.height*0.25f));
     */
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

-(NSInteger)MyRandomIntegerBetween:(int)min :(int)max {
    return ( (arc4random() % (max-min+1)) + min );
}

-(CGPoint)giraffePosVisible{
    
    return ccp(ACTOR_GIRAFE_POS_X.position.x
               -(ACTOR_GIRAFE.boundingBox.size.width/2),
               ACTOR_PLAYER.position.y+(kHeightScreen*((float)[self MyRandomIntegerBetween:2 :5]/10)));
    
}

-(CGPoint)giraffePosHidden{
    
    return ccp( ACTOR_GIRAFE_POS_X.position.x+
               (ACTOR_GIRAFE.boundingBox.size.width),
               ACTOR_PLAYER.position.y);
    
}

-(void)GiraffeSettings{
    
    //  ACTOR_GIRAFE.position = [self giraffePosVisible];
    
    giraffeTouched = NO;
    
    [self schedule:@selector(changeGirafePosition:) interval:[self MyRandomIntegerBetween:10 :15]];
    
}

-(void)changeGirafePosition:(ccTime)dt{
    
 //   NSLog(@"giraffe pos %f %f",ACTOR_GIRAFE.position.x,ACTOR_GIRAFE.position.y);
    if (ACTOR_PLAYER.position.y > ACTOR_CAMERA_OFF_CHP.position.y) return;
    
    if (!giraffeTouched)
    {
        CGPoint willShowPos = [self giraffePosHidden];
        
        //hide and show
        ACTOR_GIRAFE.position = ccp(willShowPos.x + ACTOR_GIRAFE.boundingBox.size.width*2, willShowPos.y);
        
        id hide =  [CCEaseElasticInOut actionWithAction:
                    [CCMoveTo actionWithDuration:0.3f position:willShowPos] period:1.f];
        id show =  [CCEaseElasticInOut actionWithAction:
                    [CCMoveTo actionWithDuration:0.3f position:[self giraffePosVisible]]period:1.f];
        id seq =   [CCSequence actions:show,[CCDelayTime actionWithDuration:1],hide, nil];
        [ACTOR_GIRAFE runAction:seq];
        
        [AUDIO playEffect:l7_giraffeshow];
    }
    
    else if (giraffeTouched)
    {
        id hide =  [CCEaseElasticInOut actionWithAction:
                    [CCMoveTo actionWithDuration:0.3f position:ccp(ACTOR_GIRAFE.position.x + kWidthScreen*2,ACTOR_GIRAFE.position.y)] period:1.f];
        [ACTOR_GIRAFE runAction:hide];
        [self unschedule:@selector(changeGirafePosition:)];
    }
    
  //  NSLog(@"giraffe pos %f %f",ACTOR_GIRAFE.position.x,ACTOR_GIRAFE.position.y);
    
}

-(void)checkForMonstersToCreateWithType{
    
    int Count = [self CountHowManyActorsByTag:TAG_ENEMY_BLUE];
    int type = TYPE_MONSTER_BLUE;
    //   int redCount =  [self CountHowManyActorsByTag:TAG_ENEMY_RED];
    int typesChecked = 1;
    int taggy = ENEMY_BLUE_TAGGY;
    
    for (int x = 1; x <= Count; x++)
    {
        CGPoint pos;
        pos = [self getBirdPositionByUNIQUENAME:x type:type].position;
        
        if (jNf.position.y > pos.y-(MONSTER_DEALLOC_DISTANCE)
            && ![self getChildByTag:x+(taggy)]
            && ccpDistance(pos, jNf.position) < MONSTER_DEALLOC_DISTANCE)
            
        {
            //    NSLog(@"need to create monstr with TAG %i",x+taggy);
            
            RedBlueMonster *monstr = [[[RedBlueMonster alloc]initWithRect:CGRectMake(0, 0, 0, 0)
                                                               withLoader:loader
                                                                     TYPE:type
                                                                       ID:x]autorelease];
            
            monstr.position = pos;
            monstr.tag = x+(taggy);
            
            monstr.ID_ = x;
            monstr.type_ = type;
            
            [self addChild:monstr];
            
          
            
            
        }
        
        if (x == Count && type==TYPE_MONSTER_BLUE && typesChecked == 1)
        {
            x = 0;
            typesChecked++;
            type =TYPE_MONSTER_RED;
            Count = [self CountHowManyActorsByTag:TAG_ENEMY_RED];
            taggy = ENEMY_RED_TAGGY;
            
        }
        
    }
    
    
    [self monstersDealloc]; //check monster for deallocing

}

-(void)monstersPositionsRotations{
    
    for (RedBlueMonster *mon in [self children])
    {
        if (
            [mon isKindOfClass:[RedBlueMonster class]])
        {
            [mon updateMonster];
        }
    }
    
}

-(void)monstersDealloc{
    
    for (RedBlueMonster *mon in [self children])
    {
        if (mon.position.y <
            jNf.position.y-(MONSTER_DEALLOC_DISTANCE)
            &&
            [mon isKindOfClass:[RedBlueMonster class]]
            && [mon children].count > 0)
        {
            //    NSLog(@"remove monster with id %i type :%i",mon.ID_,mon.type_);
            //      [[self getBirdPositionByUNIQUENAME:mon.ID_ type:mon.type_] removeSelf];
            //    NSLog(@"delete %@. Children there are %i",mon,[mon children].count);
            
            [mon stopAllActions];
            [mon unscheduleAllSelectors];
            [mon removeAllChildrenWithCleanup:YES];
        }
    }

    
}

-(void)birdSound:(ccTime)dt{
    if (birdSound == YES) {
        return;
    }
     [AUDIO playEffect:l7_birdClap];
     [self unschedule:@selector(birdSound:)];
    
    [cfg runSelectorTarget:self selector:@selector(restartBirdSound) object:nil afterDelay:[cfg MyRandomIntegerBetween:1 :5] sender:self];
    
}

-(void)restartBirdSound{
    
    [self schedule:@selector(birdSound:) interval:1.f];
    
}

- (id)initWithHUD:(InGameButtons *)hud
{
    if ((self = [super init])) {
        _hud = hud;
		
		// enable touches
	//	self.isTouchEnabled = YES;
        self.isAccelerometerEnabled = YES;
		enableAccelerometer = YES;
	//	screenSize = [CCDirector sharedDirector].winSize;
        
        b2Vec2 gravity;
		gravity.Set(0.0f, GRAVITY_DEF_Y);
        
        world = new b2World(gravity);
        
        world->SetAllowSleeping(true);
        
        world->SetContinuousPhysics(true);
        
        [self schedule:@selector(birdSound:) interval:3];
        
        // world->SetAutoClearForces(false);
        
        if (DEBUG_LEVEL14)
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
        
        ropeBeginYPoint = 0;
        ropeEndYPoint   = 0;
        
        fistScaleYDist = 0;
        
        if (IS_IPHONE_5 && IS_IPAD)
        {
            [LevelHelperLoader dontStretchArt];  //iphone 5 fix
        }
        
     //   [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1/50.f];
        
        loader = [[LevelHelperLoader alloc]initWithContentOfFile:@"Level14"];
        
        [loader addObjectsToWorld:world cocos2dLayer:self];
        
        [loader createPhysicBoundaries:world];
        
        dead = NO;
        
        [self addMainPlayer];
        
        [self zombieFallowHisBlock];
        
        /// *** BRAINS NOT SEEN ????!
        [self reorderChild:[self getChildByTag:TAG_BRAIN_1] z:10];
        [self getChildByTag:TAG_BRAIN_1].position = zombiebody.position;
        
        
        [self GiraffeSettings];
		
		[self schedule: @selector(tick:)];
        
        //DEBUG
        
        [self showMonsterBlocks:NO];
        
        if (DEBUG_LEVEL14)
        {
            [self setLayerActorsOpacityTo:150];
        }
        
        [self registerCollisions];
        
        [self wallSettings];
        
       // [self addParaluxbackgrounds];
        
        [self schedule:@selector(checkForMonstersToCreateWithType) interval:0.25f];
       // [self schedule:@selector(monstersDealloc) interval:1.f];
        
        enableJUMP =YES;
        
        
        [self  runAction:[CCFollowDynamic actionWithTarget:ACTOR_PLAYER
                                             worldBoundary:CGRectMake(0,0,kWidthScreen,kHeightScreen*13.85f)
                                           smoothingFactor:0.08f
                                                 nodePlace:0.33f]].tag = ACTION_TAG_FALLOW;
        
        if (_hud.tutorialSHOW)
        {
            pause = YES;
            [self schedule:@selector(GAME_PAUSE) interval:0.1f];
        }
        
        if (![Combinations checkNSDEFAULTS_Bool_ForKey:C_TUTORIAL_(_hud.level)])
        {
        [cfg runSelectorTarget:self selector:@selector(showTut_14) object:nil afterDelay:1 sender:self];
     //   [cfg runSelectorTarget:self selector:@selector(showTut_14) object:nil afterDelay:5 sender:self];
        }
        
        [[zombiebody robot_] ACTION_StopAllPartsAnimations_Clean:NO];
        
        canTouch = YES;
        
	}
	return self;
}

-(void)showTut_14
{
    Tutorial *tut = [[[Tutorial alloc]init]autorelease];
    tut.position = ccp(kWidthScreen/2, kHeightScreen/2.f);
    [_hud addChild:tut z:0 tag:9923];
    [tut TILT_TrutorialRepaet:1 runAfterDelay:0.f quadro:NO];
    // [tut TAP_TutorialRepeat:1 delay:0.3f runAfterDelay:0.f];
    
    Tutorial *tut2 = [[[Tutorial alloc]init]autorelease];
    tut2.position = ccp(kWidthScreen/2, kHeightScreen/2.1f);
    [_hud addChild:tut2 z:0 tag:9924];
    [tut2 TAP_TutorialRepeat:2 delay:0.3f runAfterDelay:0.f];
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

-(void)addParaluxbackgrounds{
    
    bgParalaxxx = [[[[b6luxParallaxBg alloc]init]loadParallaxBackgroundWithLoader:loader
                                                                             fallowedNode:zombiebody
                                                                                direction:bg_direction_UP_DOWN]autorelease];
    [LAYER_MAIN addChild:bgParalaxxx];
    
    [bgParalaxxx addBgWithUniqeName:@"bg"speed:1];
    
    //bgParalaxxx.enableMoveY = YES;
    
}

- (void)onEnter{
    
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [super onEnter];
}

- (void)onExit{

    //[self removeAllChildrenWithCleanup:YES];
   
//    [self unscheduleAllSelectors];
//    [self stopAllActions];
    
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [super onExit];
}

- (void) dealloc
{
   // [motionManager release];
   // motionManager = nil;
    [loader removeAllPhysics];
    
    if(loader != nil) { [loader release]; loader = nil; }
    
	delete world;
	world = NULL;
	
	delete m_debugDraw;
    
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
