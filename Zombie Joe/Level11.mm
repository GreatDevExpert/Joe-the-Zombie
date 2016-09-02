//
//  Level11.m
//  project_box2d
//
//  Created by Slavian on 2013-06-10.
//
//
#import "Level11.h"
#import "cfg.h"
#import "Constants.h"
#import "SConfig.h"
#import "Combinations.h"
#import "SCombinations.h"
#import "GB2ShapeCache.h"
#import "CCFollowDynamic.h"
#import "MyContactListenerS.h"
#import "BrainsBonus.h"
#import "VRope.h"
#import "MonstersLVL11.h"
#import "SpeedBonus.h"
#import "Zombie_lvl11.h"
#import "SimpleAudioEngine.h"  
#import "Tutorial.h"

//#define PTM_RATIO 32.0

#define cc_to_b2Vec(x,y)   (b2Vec2((x)/PTM_RATIO, (y)/PTM_RATIO))

#define zombie 1
#define BCNode 20
#define BGBCNode 21
#define firstRock 50
#define alpha 255
#define BGL_1 31
#define BGL_2 32
#define BGL_3 33
#define BGL_4 34
#define BGL_5 35
#define BGL_6 36
#define Monster1 355
#define Monster2 455
#define Bonus 600
#define Temple 887
#define Spider 886
#define Brains 888
#define Bird 500
#define kTut11 11122223


@implementation Level11

-(int)MyRandomIntegerBetween:(int)min :(int)max{
    
    // int a  = kHeightScreen;
    //return  arc4random() %a;
    return ( (arc4random() % (max-min)) + min );
}


-(void)addRoomWalls
{
    //********* GROUND ************
    b2BodyDef groundBoduDef;
    groundBoduDef.position.Set(0, 0);
    groundBody = _world->CreateBody(&groundBoduDef);
    b2PolygonShape groundShape;
    b2FixtureDef boxShapeDef;
    boxShapeDef.shape = &groundShape;
    groundShape.SetAsBox((kWidthScreen*40)/PTM_RATIO,0);
    
    //    b2EdgeShape boxShapeDef;
    //    boxShapeDef.Set(b2Vec2(-kHeightScreen/PTM_RATIO,0), b2Vec2(2*kHeightScreen/PTM_RATIO,0));
    groundBody->CreateFixture(&boxShapeDef);
    
    //********* LEFT WALL ************
    b2BodyDef wall_leftDef;
    wall_leftDef.position.Set(-10/PTM_RATIO, 10/PTM_RATIO);
    wall_left_Body = _world->CreateBody(&wall_leftDef);
    b2PolygonShape wall_left_shape;
    b2FixtureDef wall_left_fixture;
    wall_left_fixture.shape = &wall_left_shape;
    wall_left_shape.SetAsBox(10/PTM_RATIO,kHeightScreen/PTM_RATIO);
    wall_left_Body->CreateFixture(&wall_left_fixture);
    
    //********* RIGHT WALL ************
    b2BodyDef wall_rightDef;
    wall_rightDef.position.Set(kWidthScreen*40/PTM_RATIO,-200/PTM_RATIO);
    wall_right_Body = _world->CreateBody(&wall_rightDef);
    b2PolygonShape wall_right_shape;
    b2FixtureDef wall_right_fixture;
    wall_right_Body->SetType(b2_kinematicBody);
    wall_right_fixture.shape = &wall_right_shape;
    wall_right_shape.SetAsBox(10/PTM_RATIO,kHeightScreen+200/PTM_RATIO);
    wall_right_Body->CreateFixture(&wall_right_fixture);
    
    //********* TOP ************
    b2BodyDef wall_topDef;
    wall_topDef.position.Set(0, kHeightScreen/PTM_RATIO);
    b2Body *wall_top_Body = _world->CreateBody(&wall_topDef);
    b2PolygonShape wall_top_shape;
    b2FixtureDef wall_top_fixture;
    wall_top_fixture.shape = &wall_top_shape;
    wall_top_shape.SetAsBox((kWidthScreen*40)/PTM_RATIO,0);
    wall_top_Body->CreateFixture(&wall_top_fixture);
    
}

-(void)showTutLVL11
{
    Tutorial*tut = [[[Tutorial alloc]init]autorelease];
    [_hud addChild:tut z:0 tag:kTut11];
    tut.position = ccp(kWidthScreen/2, kHeightScreen/2);
    [tut SWIPE_TutorialWithDirection:SWIPE_DOWN times:1 delay:0.5f runAfterDelay:0.2f];
    [cfg runSelectorTarget:self selector:@selector(showTUt2) object:nil afterDelay:2.f sender:self];
    
}
-(void)showTUt2
{
    if ([_hud getChildByTag:kTut11]) {
        [[_hud getChildByTag:kTut11]removeFromParentAndCleanup:YES];
    }
    Tutorial *tut = [[[Tutorial alloc]init]autorelease];
    [_hud addChild:tut z:0 tag:kTut11+1];
    tut.position = ccp(kWidthScreen/2, kHeightScreen/2);
    [tut SWIPE_TutorialWithDirection:SWIPE_UP times:1 delay:0.5f runAfterDelay:0.5f];


}

-(b2Body *) createCandyAt:(CGPoint)pt
{
    // Get the sprite from the sprite sheet
    //CCSprite *sprite = [CCSprite spriteWithFile:@"ball.png"];
    //[self addChild:sprite z:100];
    
    // Defines the body of our candy
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = b2Vec2(pt.x/PTM_RATIO, pt.y/PTM_RATIO);
    // bodyDef.userData = sprite;
    bodyDef.linearDamping = 0;
    bodyDef.fixedRotation = true;
    b2Body *body = _world->CreateBody(&bodyDef);
    
    // Define the fixture as a polygon
    b2FixtureDef fixtureDef;
    b2PolygonShape spriteShape;
    
    b2Vec2 verts[] = {
        
        b2Vec2(0.f / PTM_RATIO, -5.f / PTM_RATIO),
        b2Vec2(5.f / PTM_RATIO, 5.f / PTM_RATIO),
        b2Vec2(-5.f / PTM_RATIO, 5.f / PTM_RATIO),
        b2Vec2(-5.f / PTM_RATIO, -5.f / PTM_RATIO)
    };
    
    spriteShape.Set(verts, 4);
    fixtureDef.shape = &spriteShape;
    fixtureDef.density = 4.f;
    fixtureDef.filter.categoryBits = 0x01;
    fixtureDef.filter.maskBits = 0x01;
    body->CreateFixture(&fixtureDef);
    
    [candies addObject:[NSValue valueWithPointer:body]];
    
    return body;
}


-(void) createRopeWithBodyA:(b2Body*)bodyA anchorA:(b2Vec2)anchorA
                      bodyB:(b2Body*)bodyB anchorB:(b2Vec2)anchorB
                        sag:(float32)sag
{
    b2RopeJointDef jd;
    jd.bodyA = bodyA;
    jd.bodyB = bodyB;
    jd.localAnchorA = anchorA;
    jd.localAnchorB = anchorB;
    
    // Max length of joint = current distance between bodies * sag
    float32 ropeLength = (bodyA->GetWorldPoint(anchorA) - bodyB->GetWorldPoint(anchorB)).Length() * sag;
    //float32 ropeLength = 15;
    
    jd.maxLength = ropeLength;
    
    // Create joint
    b2RopeJoint *ropeJoint = (b2RopeJoint *)_world->CreateJoint(&jd);
    
    //VRope *newRope = [[VRope alloc] initWithRopeJoint:ropeJoint spriteSheet:ropeSpriteSheet];
    
    newRope = [[VRope alloc] initWithRopeJoint:ropeJoint spriteSheet:ropeSpriteSheet];
    
    [ropes addObject:newRope];
    [newRope release];
}


-(void) loadRope
{
    // Add the candy
    ropePT_2 = [self createCandyAt:CGPointMake(kWidthScreen/2, 0)];
    ropePT_1 = [self createCandyAt:CGPointMake(kWidthScreen/2, kHeightScreen)];
    
    // Change the linear dumping so it swings more
    //body2->SetLinearVelocity(b2Vec2(10, 0));
    
    // body2->SetLinearVelocity(b2Vec2(j, 0));
    
    //    [self createRopeWithBodyA:groundBody anchorA:cc_to_b2Vec(kWidthScreen/2,kHeightScreen/1.1)
    //                        bodyB:body2 anchorB:body2->GetLocalCenter()
    //                          sag:1.f];
    [self createRopeWithBodyA:ropePT_1 anchorA:ropePT_1->GetLocalCenter()
                        bodyB:ropePT_2 anchorB:ropePT_2->GetLocalCenter()
                          sag:1.1f];
    
}


-(void)addSpider
{
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"spider.png"];
    sprite.anchorPoint = ccp(0.5f, 0);
    sprite.position = ccp(kWidthScreen*5, kHeightScreen);
    [self addChild:sprite z:5 tag:Spider];

}

-(void)beeAnimation:(CCNode *)sprite
{
    
    if (sprite.position.x < -self.position.x - sprite.contentSize.width) {
        [sprite stopActionByTag:2];
    }
 
    if (sprite.numberOfRunningActions == 0) {
    
        if (-self.position.x > kWidthScreen*36) {
            return;
        }
        sprite.position = ccp(-self.position.x+self.contentSize.width*1.5f, [self MyRandomIntegerBetween:(int)kHeightScreen/5 :(int)kHeightScreen/1.1]);
        sprite.scale = 1.0f;
        
        [sprite runAction:[CCSpawn actions:[CCSequence actions:[CCDelayTime actionWithDuration:0.4f],[CCCallBlock actionWithBlock:^{
            if (!soundFX) {
                [AUDIO playEffect:l12_beeGo];
            }
        }], nil],[CCEaseIn actionWithAction:[CCMoveTo actionWithDuration:_beeMovDuration position:ccp(-self.position.x - sprite.contentSize.width*2, [self MyRandomIntegerBetween:(int)kHeightScreen/5 :(int)kHeightScreen/1.3])] rate:2],[CCScaleTo actionWithDuration:_beeMovDuration scaleX:1.3f scaleY:0.8f], nil]].tag = 2;
    }
    
}

-(void)flowerAnimation:(CCNode *)sprite
{
    if (sprite.numberOfRunningActions == 0) {
        
        if (-self.position.x > kWidthScreen*36) {
            return;
        }
        [sprite runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCEaseInOut actionWithAction:[CCRotateBy actionWithDuration:1.f angle:-50] rate:2],[CCDelayTime actionWithDuration:0.2f],[CCSpawn actions:[CCSequence actions:[CCDelayTime actionWithDuration:0.5f],[CCCallBlock actionWithBlock:^{
            if (!soundFX) {
                [AUDIO playEffect:l12_flower];
            }
        }], nil],[CCEaseInOut actionWithAction:[CCRotateBy actionWithDuration:1.f angle:100] rate:2], nil],[CCEaseInOut actionWithAction:[CCRotateBy actionWithDuration:1.f angle:-50] rate:2], nil]]];
        
    }
}

-(void)particles
{
    
//    CCParticleSystemQuad *effect = [CCParticleSystemQuad particleWithFile:@"zombie_par.plist"];
//    
//    effect.position = ccp([self getChildByTag:zombie].position.x,[self getChildByTag:zombie].position.y);
//    
//    if (IS_IPHONE || IS_IPHONE_5) {effect.scale = 0.5f;}
//    
//    //else{effect.scale = 0.8f;}
//    
//    [self addChild:effect z:999];
//    
//    effect.autoRemoveOnFinish = YES;
    
    [_hud makeBlastInPosposition:[self getChildByTag:zombie].position];
    
}

-(void)gameOver
{
    if ([self getChildByTag:zombie].position.x > kWidthScreen*3)
    {
        [Combinations saveNSDEFAULTS_Bool:YES forKey:C_TUTORIAL_([_hud level])];
    }

    soundFX = true;
    [self stopActionByTag:0];
    Zombie_lvl11 *z = (Zombie_lvl11 *)[self getChildByTag:zombie];
    [z dead];
    [self unschedule:@selector(pos:)];
    [self particles];
    [[self getChildByTag:zombie] runAction:[CCSpawn actions:[CCEaseIn actionWithAction:[CCJumpTo actionWithDuration:1.f position:ccp(-self.position.x-[self getChildByTag:zombie].contentSize.width, -[self getChildByTag:zombie].contentSize.height) height:0 jumps:1] rate:2],[CCRotateBy actionWithDuration:1.f angle:360], nil]];
    [_hud TIME_Stop];
    
    [_hud runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.5f],[CCCallFuncO actionWithTarget:_hud selector:@selector(LOSTLevel)], nil]];
}

-(void)addMonsters
{
    int randomeValue = [self MyRandomIntegerBetween:0 :2];
    int oldRandome;
    
    //############ FLOWER
    for (int i = 0; i < 4; i++) {
        
        CGRect rect;
        if (IS_IPAD) {rect  = CGRectMake(0, 0, 120, 280);}else{rect  = CGRectMake(0, 0, 55.2, 128.8);}
        
        MonstersLVL11 *mlvl11 = [[[MonstersLVL11 alloc] initWithRect:rect] autorelease];
        mlvl11.anchorPoint = ccp(0.5f, 0);
        //mlvl11.rotation = 90;
        
        switch (i) {
            case 0:mlvl11.position = ccp(kWidthScreen*3, -mlvl11.contentSize.height/10);break;
            case 1:mlvl11.position = ccp(kWidthScreen*5, -mlvl11.contentSize.height/10);break;
            case 2:mlvl11.position = ccp(kWidthScreen*7, -mlvl11.contentSize.height/10);break;
            case 3:mlvl11.position = ccp(kWidthScreen*9, -mlvl11.contentSize.height/10);break;
            default:break;
        }
        // NSLog(@"HEIGHT    :%i",[self MyRandomIntegerBetween]);
        
        [self addChild:mlvl11 z:7 tag:Monster1+i];
        
        
        [mlvl11 createMonster:[NSNumber numberWithInt:1]];
        
          [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:[self MyRandomIntegerBetween:0 :2]],[CCCallFuncO actionWithTarget:self selector:@selector(flowerAnimation:) object:mlvl11], nil]];
    }
    
    
    //############ BEE
    for (int i = 0; i < 2; i++) {
        
        CGRect rect;
        if (IS_IPAD) {rect  = CGRectMake(0, 0, 100, 100);}else{rect  = CGRectMake(0, 0, 46, 46);}
        
        MonstersLVL11 *mlvl11 = [[[MonstersLVL11 alloc] initWithRect:rect] autorelease];
        mlvl11.anchorPoint = ccp(0, 0);
        mlvl11.position = ccp(0, 0);
        
        [self addChild:mlvl11 z:99 tag:Monster2+i];
        
        [mlvl11 createMonster:[NSNumber numberWithInt:2]];
        
        [self runAction:
         [CCRepeatForever actionWithAction:
          [CCSequence actions:
           [CCDelayTime actionWithDuration:randomeValue],
           [CCCallBlock actionWithBlock:^(void){
              
              [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1],[CCCallFuncO actionWithTarget:self selector:@selector(beeAnimation:) object:mlvl11], nil]];
              
          }], nil]]];
        
        oldRandome = randomeValue;
        while (randomeValue == oldRandome) {
            randomeValue = [self MyRandomIntegerBetween:0 :2];
        }
        //[mlvl11 runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCMoveBy actionWithDuration:0.2f position:ccp(0, 50)],[CCMoveBy actionWithDuration:0.2f position:ccp(0, -50)], nil]]];
    }
}


/*
 -(b2Body *) createRopeTipBody
 {
 b2BodyDef bodyDef;
 bodyDef.type = b2_dynamicBody;
 bodyDef.linearDamping = 0.5f;
 b2Body *body = _world->CreateBody(&bodyDef);
 
 b2FixtureDef circleDef;
 b2CircleShape circle;
 circle.m_radius = 1.0/PTM_RATIO;
 circleDef.shape = &circle;
 circleDef.density = 10.0f;
 
 // Since these tips don't have to collide with anything
 // set the mask bits to zero
 circleDef.filter.maskBits = 0;
 body->CreateFixture(&circleDef);
 
 return body;
 }
 */

-(void)addZombie{
    
    CGRect rect;
    if (IS_IPAD) {rect = CGRectMake(0, 0, 90, 101.5);}else {rect = CGRectMake(0, 0, 41.4, 46.7);}
    
    Zombie_lvl11 *sprite = [[[Zombie_lvl11 alloc]initWithRect:rect] autorelease];
    sprite.anchorPoint = ccp(0.9f, 0.75f);
    
    //sprite.scale = 0.8f;
    //sprite.flipX = YES;
    //sprite.flipY = YES;
    sprite.position = ccp(sprite.position.x, kHeightScreen/2);
    [self addChild:sprite z:7 tag:zombie];
    
    
    /*
     [[GB2ShapeCache sharedShapeCache] addShapesWithFile:[NSString stringWithFormat:@"PE_Level9%@.plist",kDevice]];
     b2BodyDef ballBodyDef;
     ballBodyDef.type = b2_dynamicBody;
     ballBodyDef.position.Set(kWidthScreen/10/PTM_RATIO, kHeightScreen/5/PTM_RATIO);
     ballBodyDef.userData = [self getChildByTag:zombie];
     _body = _world->CreateBody(&ballBodyDef);
     // _body->SetLinearVelocity(b2Vec2(2,0));
     _body->SetFixedRotation(true);
     
     [[GB2ShapeCache sharedShapeCache]addFixturesToBody:_body forShapeName:@"joefly"];*/
    
}
/*
-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY,
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	_world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
}*/

-(void)addbrains
{
    [_hud preloadBlast_self:self brainNr:1 parent:self];
    
    [_hud BRAIN_:TAG_BRAIN_1 position:ccp(kWidthScreen*18, kHeightScreen/1.15f) parent:self];
    
    [_hud BRAIN_:TAG_BRAIN_1 zOrder:5 parent:self];
    

}

-(void)birdTouched
{



}

-(void)moveBrains :(CCNode*)node
{
    [node runAction:[CCSequence actions:[CCSpawn actions:[CCMoveTo actionWithDuration:0.4f position:ccp([self getChildByTag:zombie].position.x, [self getChildByTag:zombie].position.y)],[CCFadeTo actionWithDuration:0.5f opacity:0], nil],[CCCallBlock actionWithBlock:^(void){[node removeFromParentAndCleanup:YES];}], nil]];
}



-(void)performCameraOFF
{
    [self stopActionByTag:0];
}

-(void)endOftheGame
{
    int height = 0;
    soundFX = true;
    self.isTouchEnabled = NO;
    if ([self getChildByTag:zombie].position.y < kHeightScreen/2) {if(IS_IPAD){ height = 500;}else{ height = 260;}}
    else if ([self getChildByTag:zombie].position.y > kHeightScreen/2) {if(IS_IPAD){ height = 200;}else{ height = 130;}}
    [self unschedule:@selector(pos:)];
    [self reorderChild:[self getChildByTag:zombie] z:10];
    [self getChildByTag:zombie].anchorPoint = ccp(0.5f, 0.5f);
     [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.3f],[CCCallFuncO actionWithTarget:self selector:@selector(performCameraOFF)], nil]];
    
    [[self getChildByTag:zombie] runAction:[CCSpawn actions:[CCJumpTo actionWithDuration:1.f position:ccp([self getChildByTag:Temple].position.x + [self getChildByTag:Temple].contentSize.width/1.5, -[self getChildByTag:zombie].contentSize.height*2) height:height jumps:1],[CCRotateBy actionWithDuration:1.f angle:500], nil]];
    
     [_hud runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.5f],[CCCallFuncO actionWithTarget:_hud selector:@selector(WINLevel)], nil]];
    [AUDIO playEffect:fx_winmusic];

    [_hud runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.5f],[CCCallFuncO actionWithTarget:_hud selector:@selector(TIME_Stop)], nil]];
}

-(void)touchEND
{
   // m_state = l11_STATE_NORMAL;
    CAN_TOUCH = YES;
    
}

//- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
    {
        if (!pause) {
        if (!CAN_TOUCH) return NO;
        
    //    CGPoint location = [touch locationInView: [touch view]];
        CGPoint touchPos = [self convertTouchToNodeSpace:touch];//[[CCDirector sharedDirector] convertToGL: location];
    
// //   UITouch* touch = [touches anyObject];
//        CGPoint location = [touch locationInView: [touch view]];
//     //   location = [[CCDirector sharedDirector] convertToGL: location];
//    CGPoint touchPos = [self convertTouchToNodeSpace:touch];
    
    touchB = touchPos;
    
    whereTouch = ccpSub(ccp(0, [self getChildByTag:zombie].position.y), ccp(0, touchPos.y));
    
    CGRect q = CGRectMake([self getChildByTag:Spider].position.x - [self getChildByTag:Spider].contentSize.width, [self getChildByTag:Spider].position.y - [self getChildByTag:Spider].contentSize.height, [self getChildByTag:Spider].contentSize.width*3, [self getChildByTag:Spider].contentSize.height*3);
    
    
    
    if ((CGRectContainsPoint(q, touchPos)) && !spiderTouched)
    {
        
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"brains.png"];
        sprite.anchorPoint = ccp(0, 0);
        sprite.position = ccp([self getChildByTag:Spider].position.x, [self getChildByTag:Spider].position.y);
        [self addChild:sprite z:6 tag:444];
        //[cfg makeBrainActionForNode:sprite fakeBrainsNode:nil direction:45 pixelsToMove:50 parent:self removeBrainsAfter:NO makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
        [cfg makeBrainActionForNode:sprite fakeBrainsNode:nil direction:45 pixelsToMove:50 time:0.3f parent:self removeBrainsAfter:NO makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
        //[self moveBrains:sprite];
        
        spiderTouched = true;
    }
    
    
    CGRect r = CGRectMake([[[self getChildByTag:BGL_5] getChildByTag:Bird+2]boundingBox].origin.x + -self.position.x/7.5f - [[[self getChildByTag:BGL_5] getChildByTag:Bird+2]boundingBox].size.width, [[[self getChildByTag:BGL_5] getChildByTag:Bird+2]boundingBox].origin.y - [[[self getChildByTag:BGL_5] getChildByTag:Bird+2]boundingBox].size.height, [[[self getChildByTag:BGL_5] getChildByTag:Bird+2]boundingBox].size.width*3, [[[self getChildByTag:BGL_5] getChildByTag:Bird+2]boundingBox].size.height*3);
    
    
    //NSLog(@"POS: %f  ,%f  ,%f  ,%f",r.origin.x,r.origin.y,touchPos.x,touchPos.y);
    
    if ((CGRectContainsPoint(r, touchPos)) && !birdTouched)
    {
        
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"brains.png"];
        sprite.anchorPoint = ccp(0, 0);
        sprite.position = ccp([[self getChildByTag:BGL_5] getChildByTag:Bird+2].position.x + -self.position.x/7.5f, [[self getChildByTag:BGL_5] getChildByTag:Bird+2].position.y);
        [self addChild:sprite z:6 tag:445];
        //[cfg makeBrainActionForNode:sprite fakeBrainsNode:nil direction:90 pixelsToMove:100 parent:self removeBrainsAfter:NO makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
        [cfg makeBrainActionForNode:sprite fakeBrainsNode:nil direction:90 pixelsToMove:50 time:0.3f parent:self removeBrainsAfter:NO makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
        //[self moveBrains:sprite];
        
        birdTouched = true;
    }
    
    CGRect o = CGRectMake([[self getChildByTag:TAG_BRAIN_1]boundingBox].origin.x - [[self getChildByTag:TAG_BRAIN_1]boundingBox].size.width, [[self getChildByTag:TAG_BRAIN_1]boundingBox].origin.y - [[self getChildByTag:TAG_BRAIN_1]boundingBox].size.height, [[self getChildByTag:TAG_BRAIN_1]boundingBox].size.width*3, [[self getChildByTag:TAG_BRAIN_1]boundingBox].size.height*3);
    
    if ((CGRectContainsPoint(o, touchPos)) && !bonusBrains)
    {
        //[cfg makeBrainActionForNode:[self getChildByTag:Brains] fakeBrainsNode:nil direction:75 pixelsToMove:100 parent:self removeBrainsAfter:NO makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
        [cfg makeBrainActionForNode:[self getChildByTag:TAG_BRAIN_1] fakeBrainsNode:nil direction:75 pixelsToMove:50 time:0.3f parent:self removeBrainsAfter:NO makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
        
        bonusBrains = true;
    }
    
    // m_state = l11_STATE_JUMP;
    
    //Zombie_lvl11 *z = (Zombie_lvl11 *)[self getChildByTag:zombie];
    //[z rotateHead:[NSNumber numberWithInt:1]];
    
    
    // NSLog(@"POS: %g  %g",touchB.x,touchB.y);
    CAN_TOUCH = NO;
 
        }
    return YES;
        
}

//- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event;
//- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
//-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!pause) {

     CGPoint touchPos = [self convertTouchToNodeSpace:touch];
    
   // CGPoint location = [touch locationInView: [touch view]];
   // CGPoint touchPos = [[CCDirector sharedDirector] convertToGL: location];
    
  //  UITouch* touch = [touches anyObject];
   // CGPoint touchPos = [self convertTouchToNodeSpace:touch];
    
    
    [self getChildByTag:zombie].position = ccpAdd(whereTouch, ccp([self getChildByTag:zombie].position.x, touchPos.y));
    }
}

//-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
{
    if (!pause) {
    [self touchEND];
    }
   
}

-(void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!pause) {
    [self touchEND];
    }
}

-(void)speedUP
{
    float s;
    if (IS_IPAD) {s = 0.2f;}else{s = 0.1f;}
    ropePT_1->ApplyLinearImpulse(b2Vec2(s,0), ropePT_1->GetPosition());
    ropePT_2->ApplyLinearImpulse(b2Vec2(s,0), ropePT_2->GetPosition());

}

-(void)speedUP2
{
    float s;
    if (IS_IPAD) {s = 0.06f;}else{s = 0.04f;}
    ropePT_1->ApplyLinearImpulse(b2Vec2(s,0), ropePT_1->GetPosition());
    ropePT_2->ApplyLinearImpulse(b2Vec2(s,0), ropePT_2->GetPosition());

}

-(void) pos: (ccTime) dt
{
    int x = ([self getChildByTag:zombie].position.y * 100)/kHeightScreen;
    
    if (x>0 && x<90) {
        if (IS_IPAD) {segmentNum = (32 * x)/100;}else {segmentNum = (27 * x)/100;}
    }
    
   // NSLog(@"SEGMENT : %i",segmentNum);
    CCSprite*s = (CCSprite*)[newRope._ropeSprites objectAtIndex:segmentNum];
    [self getChildByTag:zombie].position = ccp(s.position.x, [self getChildByTag:zombie].position.y);
    
    [self getChildByTag:zombie].rotation = -s.rotation;
    
    
    //IF ZOMBIE IS UNDER ROPE
    if ([self getChildByTag:zombie].position.y > kHeightScreen-[self getChildByTag:zombie].contentSize.height) {
        [self getChildByTag:zombie].position = ccp([self getChildByTag:zombie].position.x, kHeightScreen-[self getChildByTag:zombie].contentSize.height);
    }
    
    //IF ZOMBIE IS AFTER ROPE
    if ([self getChildByTag:zombie].position.y < [self getChildByTag:zombie].contentSize.height/4) {
        [self getChildByTag:zombie].position = ccp([self getChildByTag:zombie].position.x, [self getChildByTag:zombie].contentSize.height/4);
    }

    
}

-(void)impuls
{
    float a;
    if (IS_IPAD) {a = -3.f;}else{a = -1.5f;}
    ropePT_1->ApplyLinearImpulse(b2Vec2(a,0), ropePT_1->GetPosition());
    ropePT_2->ApplyLinearImpulse(b2Vec2(a,0), ropePT_2->GetPosition());
}

-(void) tick: (ccTime) dt
{
    //NSLog(@"POS: %f", -self.position.x/kWidthScreen);
    //Segment number
    
       
    pause = NO;
    

    
    _world->Step(dt, 8, 1);
    

          
    //wall_left_Body->SetTransform(b2Vec2(-self.position.x/PTM_RATIO - 5/PTM_RATIO,10/PTM_RATIO), 0);
    // wall_right_Body->SetTransform(b2Vec2(-self.position.x/PTM_RATIO + self.contentSize.width + [[self getChildByTag:SPbatchNode2] getChildByTag:Zombie].contentSize.width/PTM_RATIO + 5/PTM_RATIO,10/PTM_RATIO), 0);
    
    
    for (b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData()!=NULL) {
            
            CCSprite *node = (CCSprite*)b->GetUserData();
            
            //            if ([node.parent.parent isKindOfClass:[Monsters_level9 class]]) {
            //
            //            }
            //else if ([node.parent.parent isKindOfClass:[Level9 class]])
            // {
            node.position = ccp(b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
            node.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
            // }
            //  NSLog(@"TAG : %i",node.parent.parent.tag);
        }
    }
    
    
       
    b2Vec2 currentVelocity = ropePT_1->GetLinearVelocity();
    float32 dot;
    
    // int int_;
    if (IS_IPAD) {dot = currentVelocity.x;}else{dot = currentVelocity.x*1.8f;}
    
    b2Vec2 force;
    if (IS_IPAD) {force = b2Vec2(0.2f,0);}else{force = b2Vec2(0.2f,0);}
    
    if (dot < 15) {
        ropePT_1->ApplyLinearImpulse(force, ropePT_1->GetPosition());
        ropePT_2->ApplyLinearImpulse(force, ropePT_2->GetPosition());
    }
    
      
    for (VRope *rope in ropes)
    {
        [rope update:dt];
        [rope updateSprites];
    }
    
    
    /*
     
     b2Vec2 currentVelocity = _body->GetLinearVelocity();
     float32 dot;
     int int_;
     if (IS_IPAD) {dot = currentVelocity.x;int_ = 12;}else{dot = currentVelocity.x*1.5;int_ = 8;}
     
     if (dot < int_ || _acceleration <= 0) {
     b2Vec2 force = b2Vec2(_acceleration/1.5,0);
     _body->ApplyLinearImpulse(force, _body->GetPosition());
     }*/
    
    if (!endOfTheGame) {
        
        std::vector<MyContactS>::iterator pos;
        for(pos = _contactListener->_contacts.begin();
            pos != _contactListener->_contacts.end(); ++pos) {
     
            MyContactS contact = *pos;
     
            b2Fixture *f = wall_right_Body->GetFixtureList();
            if ((contact.fixtureB == f && contact.fixtureA == ropePT_1->GetFixtureList()) || (contact.fixtureA == f && contact.fixtureB == ropePT_1->GetFixtureList())) {
                
                [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.15f],[CCCallFuncO actionWithTarget:self selector:@selector(endOftheGame)], nil]];
          
                endOfTheGame = true;
            }
        }
    }
    
    
    
    for (int i = 0; i<4; i++) {
        if (CGRectIntersectsRect([[self getChildByTag:zombie]boundingBox],[[self getChildByTag:Bonus+i] boundingBox]))
        {
            [self speedUP];
            if (![self getActionByTag:1112223]) {
            [self runAction:[CCSequence actions:[CCCallBlock actionWithBlock:^{
                if (!soundFX) {
                    [AUDIO playEffect:l12_speedUp];
                }
            }],[CCDelayTime actionWithDuration:1.5f], nil]].tag = 1112223;
            }
        }
    }
    

    if ((CGRectIntersectsRect([[self getChildByTag:zombie]boundingBox],[[self getChildByTag:Spider] boundingBox])) && !spiderTouched)
    {
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"brains.png"];
        sprite.anchorPoint = ccp(0, 0);
        sprite.position = ccp([self getChildByTag:Spider].position.x, [self getChildByTag:Spider].position.y);
        [self addChild:sprite z:6 tag:433];
        [cfg makeBrainActionForNode:sprite fakeBrainsNode:nil direction:0 pixelsToMove:50 time:0.3f parent:self removeBrainsAfter:NO makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
        
       spiderTouched = true;
    }

    if ((CGRectIntersectsRect([[self getChildByTag:zombie]boundingBox],[[self getChildByTag:TAG_BRAIN_1] boundingBox])) && !bonusBrains)
    {
        
        [cfg makeBrainActionForNode:[self getChildByTag:TAG_BRAIN_1] fakeBrainsNode:nil direction:45 pixelsToMove:0 time:0 parent:self removeBrainsAfter:NO makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
        
        bonusBrains = true;
    }
    
    for (int i = 0; i<4; i++) {
        if ((CGRectIntersectsRect([[self getChildByTag:zombie]boundingBox],[[self getChildByTag:Monster1+i] boundingBox])) && !gameOver)
        {
            [self gameOver];
            gameOver = true;
        }
    }
    for (int i = 0; i<2; i++) {
        if ((CGRectIntersectsRect([[self getChildByTag:zombie]boundingBox],[[self getChildByTag:Monster2+i] boundingBox])) && !gameOver)
        {
            [self gameOver];
            gameOver = true;
        }
    }
    
    
    // [self getChildByTag:zombie].position = ccp([self getChildByTag:zombie].position.x, [self getChildByTag:zombie].position.y - 1.f);
    if ((-self.position.x + self.contentSize.width >= [self getChildByTag:Spider].position.x) && !watchUp2) {
        Zombie_lvl11 *zomb = (Zombie_lvl11 *)[self getChildByTag:zombie];
        [zomb rotateHead:[NSNumber numberWithInt:1]];
        watchUp2 = true;
    }
    
    if ((-self.position.x + self.contentSize.width >= [[self getChildByTag:BGL_5] getChildByTag:Bird+2].position.x + -self.position.x/7.5f) && !watchUp1) {
        Zombie_lvl11 *zomb = (Zombie_lvl11 *)[self getChildByTag:zombie];
        [zomb rotateHead:[NSNumber numberWithInt:1]];
        watchUp1 = true;
    }
    
    
    if ((-self.position.x + self.contentSize.width >= [self getChildByTag:TAG_BRAIN_1].position.x) && !watchUp) {
        Zombie_lvl11 *zomb = (Zombie_lvl11 *)[self getChildByTag:zombie];
        [zomb rotateHead:[NSNumber numberWithInt:1]];
        watchUp = true;
    }
    if ((-self.position.x+self.contentSize.width > kWidthScreen*5) && !spiderGoOn) {
        [[self getChildByTag:Spider] runAction:[CCEaseInOut actionWithAction:[CCMoveBy actionWithDuration:0.2f position:ccp(0, -[self getChildByTag:Spider].contentSize.height*(IS_IPAD ? 1.5f : 1.0f))] rate:2]];
        //NSLog(@"POS: %f,%f",[self getChildByTag:Spider].position.x,[self getChildByTag:Spider].position.y);
        spiderGoOn = true;
    }
    //####################################  BACKGROUNDS MOVING #########################################//
    
    float a;
    
    if (IS_IPAD) {a = 0;}else{a = 0;}
    [self getChildByTag:BGL_1].position = ccp(-self.position.x/3.f,a);
    
    if (IS_IPAD) {a = -100;}else{a = -100;}
    [self getChildByTag:BGL_2].position = ccp(-self.position.x/4.5f,a);
    
    if (IS_IPAD) {a = 50;}else{a =0;}
    [self getChildByTag:BGL_4].position = ccp(-self.position.x/7.f,a);
    
    if (IS_IPAD) {a = 50;}else{a = 0;}
    [self getChildByTag:BGL_3].position = ccp(-self.position.x/6.5f,a);
    
    if (IS_IPAD) {a = 0;}else{a = 0;}
    [self getChildByTag:BGL_5].position = ccp(-self.position.x/7.5f,a);
    
    if (IS_IPAD) {a = -50;}else{a = 0;}
    [self getChildByTag:BGL_6].position = ccp(-self.position.x/12.f,a);
    
    
    if(-self.position.x > kWidthScreen*5 && -self.position.x < kWidthScreen*20){_beeMovDuration = 4.5f;}
    else if(-self.position.x > kWidthScreen*8 && -self.position.x < kWidthScreen*30){_beeMovDuration = 3.f;}
    else if(-self.position.x > kWidthScreen*15 && -self.position.x < kWidthScreen*40){_beeMovDuration = 2.5f;}
    else if(-self.position.x > kWidthScreen*25 && -self.position.x < kWidthScreen*50){_beeMovDuration = 2.f;}
    //else if(-self.position.x > kWidthScreen*50 && -self.position.x < kWidthScreen*60){_beeMovDuration = 2;}
    
    //NSLog(@"BEE SPEED: %f",_beeMovDuration);
    
    
    
    
    //###################################### FLOWERS POSITION #############################################
    
    if (-self.position.x + self.contentSize.width < kWidthScreen *36) {
        
        if (-self.position.x + self.contentSize.width/2 >= [self getChildByTag:Monster1].position.x) {
            
            [self getChildByTag:Monster1+2].position = ccp([self getChildByTag:Monster1+1].position.x +kWidthScreen*2, [self getChildByTag:Monster1+2].position.y);
            
        }
        
        if (-self.position.x + self.contentSize.width/2 >= [self getChildByTag:Monster1+1].position.x) {
            
            [self getChildByTag:Monster1+3].position = ccp([self getChildByTag:Monster1+2].position.x +kWidthScreen*2, [self getChildByTag:Monster1+3].position.y);
            
        }
        
        if (-self.position.x + self.contentSize.width/2 >= [self getChildByTag:Monster1+2].position.x) {
            
            [self getChildByTag:Monster1].position = ccp([self getChildByTag:Monster1+3].position.x +kWidthScreen*2, [self getChildByTag:Monster1].position.y);
            
        }
        
        if (-self.position.x + self.contentSize.width/2 >= [self getChildByTag:Monster1+3].position.x) {
            
            [self getChildByTag:Monster1+1].position = ccp([self getChildByTag:Monster1].position.x +kWidthScreen*2, [self getChildByTag:Monster1+1].position.y);
            
        }
    }
    else
    {
        [self speedUP2];
        soundFX = YES;
        //  [self endOftheGame];
    }
    
    
    
    //####################################  BACKGROUND 1 #########################################//
    
    
    
    if (-self.position.x + self.contentSize.width >= [[self getChildByTag:BGL_1] getChildByTag:1].position.x + [[[self getChildByTag:BGL_1] getChildByTag:1] boundingBox].size.width/2-self.position.x/3.f) {
        
        [[self getChildByTag:BGL_1] getChildByTag:2].position = ccp([[self getChildByTag:BGL_1] getChildByTag:1].position.x+[[[self getChildByTag:BGL_1] getChildByTag:1] boundingBox].size.width, [[self getChildByTag:BGL_1] getChildByTag:1].position.y);
    }
    
    if (-self.position.x + self.contentSize.width >= [[self getChildByTag:BGL_1] getChildByTag:2].position.x + [[[self getChildByTag:BGL_1] getChildByTag:2] boundingBox].size.width/2-self.position.x/3.f) {
        
        [[self getChildByTag:BGL_1] getChildByTag:0].position = ccp([[self getChildByTag:BGL_1] getChildByTag:2].position.x+[[[self getChildByTag:BGL_1] getChildByTag:2] boundingBox].size.width, [[self getChildByTag:BGL_1] getChildByTag:2].position.y);
    }
    
    if (-self.position.x + self.contentSize.width >=[[self getChildByTag:BGL_1] getChildByTag:0].position.x + [[[self getChildByTag:BGL_1] getChildByTag:0] boundingBox].size.width/2-self.position.x/3.f) {
        
        [[self getChildByTag:BGL_1] getChildByTag:1].position = ccp([[self getChildByTag:BGL_1] getChildByTag:0].position.x+[[[self getChildByTag:BGL_1] getChildByTag:0] boundingBox].size.width, [[self getChildByTag:BGL_1] getChildByTag:0].position.y);
    }
    
    
    
    //####################################  BACKGROUND 2 #########################################//
    
    
    if (IS_IPAD) {
    
    if (-self.position.x + self.contentSize.width >= [[self getChildByTag:BGL_2] getChildByTag:1].position.x + [[[self getChildByTag:BGL_2] getChildByTag:1] boundingBox].size.width/2-self.position.x/4.5f) {
        
        [[self getChildByTag:BGL_2] getChildByTag:2].position = ccp([[self getChildByTag:BGL_2] getChildByTag:1].position.x-10+[[[self getChildByTag:BGL_2] getChildByTag:1] boundingBox].size.width, [[self getChildByTag:BGL_2] getChildByTag:1].position.y);
    }
    
    if (-self.position.x + self.contentSize.width >= [[self getChildByTag:BGL_2] getChildByTag:2].position.x + [[[self getChildByTag:BGL_2] getChildByTag:2] boundingBox].size.width/2-self.position.x/4.5f) {
        
        [[self getChildByTag:BGL_2] getChildByTag:0].position = ccp([[self getChildByTag:BGL_2] getChildByTag:2].position.x-10+[[[self getChildByTag:BGL_2] getChildByTag:2] boundingBox].size.width, [[self getChildByTag:BGL_2] getChildByTag:2].position.y);
    }
    
    if (-self.position.x + self.contentSize.width >=[[self getChildByTag:BGL_2] getChildByTag:0].position.x + [[[self getChildByTag:BGL_2] getChildByTag:0] boundingBox].size.width/2-self.position.x/4.5f) {
        
        [[self getChildByTag:BGL_2] getChildByTag:1].position = ccp([[self getChildByTag:BGL_2] getChildByTag:0].position.x-10+[[[self getChildByTag:BGL_2] getChildByTag:0] boundingBox].size.width, [[self getChildByTag:BGL_2] getChildByTag:0].position.y);
    }
    
    
    }
    //####################################### PALM BACK ############################################
    
    if (-self.position.x + self.contentSize.width >=[[self getChildByTag:BGL_3] getChildByTag:0].position.x + [[[self getChildByTag:BGL_3] getChildByTag:0] boundingBox].size.width/2-self.position.x/6.5f) {
        
        [[self getChildByTag:BGL_3] getChildByTag:3].position = ccp([[self getChildByTag:BGL_3] getChildByTag:2].position.x+[[[self getChildByTag:BGL_3] getChildByTag:2] boundingBox].size.width/1.5f, [[self getChildByTag:BGL_3] getChildByTag:3].position.y);
    }
    
    if (-self.position.x + self.contentSize.width >=[[self getChildByTag:BGL_3] getChildByTag:1].position.x + [[[self getChildByTag:BGL_3] getChildByTag:1] boundingBox].size.width/2-self.position.x/6.5f) {
        
        [[self getChildByTag:BGL_3] getChildByTag:4].position = ccp([[self getChildByTag:BGL_3] getChildByTag:3].position.x+[[[self getChildByTag:BGL_3] getChildByTag:3] boundingBox].size.width/1.5f, [[self getChildByTag:BGL_3] getChildByTag:4].position.y);
    }
    
    if (-self.position.x + self.contentSize.width >= [[self getChildByTag:BGL_3] getChildByTag:2].position.x + [[[self getChildByTag:BGL_3] getChildByTag:2] boundingBox].size.width/2-self.position.x/6.5f) {
        
        [[self getChildByTag:BGL_3] getChildByTag:5].position = ccp([[self getChildByTag:BGL_3] getChildByTag:4].position.x+[[[self getChildByTag:BGL_3] getChildByTag:4] boundingBox].size.width/1.5f, [[self getChildByTag:BGL_3] getChildByTag:5].position.y);
    }
    
    if (-self.position.x + self.contentSize.width >= [[self getChildByTag:BGL_3] getChildByTag:3].position.x + [[[self getChildByTag:BGL_3] getChildByTag:3] boundingBox].size.width/2-self.position.x/6.5f) {
        
        [[self getChildByTag:BGL_3] getChildByTag:6].position = ccp([[self getChildByTag:BGL_3] getChildByTag:5].position.x+[[[self getChildByTag:BGL_3] getChildByTag:5] boundingBox].size.width/1.5f, [[self getChildByTag:BGL_3] getChildByTag:6].position.y);
    }
    
    if (-self.position.x + self.contentSize.width >=[[self getChildByTag:BGL_3] getChildByTag:4].position.x + [[[self getChildByTag:BGL_3] getChildByTag:4] boundingBox].size.width/2-self.position.x/6.5f) {
        
        [[self getChildByTag:BGL_3] getChildByTag:7].position = ccp([[self getChildByTag:BGL_3] getChildByTag:6].position.x+[[[self getChildByTag:BGL_3] getChildByTag:6] boundingBox].size.width/1.5f, [[self getChildByTag:BGL_3] getChildByTag:7].position.y);
    }
    
    if (-self.position.x + self.contentSize.width >=[[self getChildByTag:BGL_3] getChildByTag:5].position.x + [[[self getChildByTag:BGL_3] getChildByTag:5] boundingBox].size.width/2-self.position.x/6.5f) {
        
        [[self getChildByTag:BGL_3] getChildByTag:0].position = ccp([[self getChildByTag:BGL_3] getChildByTag:7].position.x+[[[self getChildByTag:BGL_3] getChildByTag:7] boundingBox].size.width/1.5f, [[self getChildByTag:BGL_3] getChildByTag:0].position.y);
    }
    
    if (-self.position.x + self.contentSize.width >=[[self getChildByTag:BGL_3] getChildByTag:6].position.x + [[[self getChildByTag:BGL_3] getChildByTag:6] boundingBox].size.width/2-self.position.x/6.5f) {
        
        [[self getChildByTag:BGL_3] getChildByTag:1].position = ccp([[self getChildByTag:BGL_3] getChildByTag:0].position.x+[[[self getChildByTag:BGL_3] getChildByTag:0] boundingBox].size.width/1.5f, [[self getChildByTag:BGL_3] getChildByTag:1].position.y);
    }
    
    if (-self.position.x + self.contentSize.width >=[[self getChildByTag:BGL_3] getChildByTag:7].position.x + [[[self getChildByTag:BGL_3] getChildByTag:7] boundingBox].size.width/2-self.position.x/6.5f) {
        
        [[self getChildByTag:BGL_3] getChildByTag:2].position = ccp([[self getChildByTag:BGL_3] getChildByTag:1].position.x+[[[self getChildByTag:BGL_3] getChildByTag:1] boundingBox].size.width/1.5f, [[self getChildByTag:BGL_3] getChildByTag:2].position.y);
    }
    
    
    
    
    //####################################### PALM FRONT ############################################
    
    if (-self.position.x + self.contentSize.width >=[[self getChildByTag:BGL_4] getChildByTag:0].position.x + [[[self getChildByTag:BGL_4] getChildByTag:0] boundingBox].size.width/2-self.position.x/7.f) {
        
        [[self getChildByTag:BGL_4] getChildByTag:3].position = ccp([[self getChildByTag:BGL_4] getChildByTag:2].position.x+[[[self getChildByTag:BGL_4] getChildByTag:2] boundingBox].size.width/1.5f, [[self getChildByTag:BGL_4] getChildByTag:3].position.y);
    }
    
    if (-self.position.x + self.contentSize.width >=[[self getChildByTag:BGL_4] getChildByTag:1].position.x + [[[self getChildByTag:BGL_4] getChildByTag:1] boundingBox].size.width/2-self.position.x/7.f) {
        
        [[self getChildByTag:BGL_4] getChildByTag:4].position = ccp([[self getChildByTag:BGL_4] getChildByTag:3].position.x+[[[self getChildByTag:BGL_4] getChildByTag:3] boundingBox].size.width/1.5f, [[self getChildByTag:BGL_4] getChildByTag:4].position.y);
    }
    
    if (-self.position.x + self.contentSize.width >= [[self getChildByTag:BGL_4] getChildByTag:2].position.x + [[[self getChildByTag:BGL_4] getChildByTag:2] boundingBox].size.width/2-self.position.x/7.f) {
        
        [[self getChildByTag:BGL_4] getChildByTag:5].position = ccp([[self getChildByTag:BGL_4] getChildByTag:4].position.x+[[[self getChildByTag:BGL_4] getChildByTag:4] boundingBox].size.width/1.5f, [[self getChildByTag:BGL_4] getChildByTag:5].position.y);
    }
    
    if (-self.position.x + self.contentSize.width >= [[self getChildByTag:BGL_4] getChildByTag:3].position.x + [[[self getChildByTag:BGL_4] getChildByTag:3] boundingBox].size.width/2-self.position.x/7.f) {
        
        [[self getChildByTag:BGL_4] getChildByTag:6].position = ccp([[self getChildByTag:BGL_4] getChildByTag:5].position.x+[[[self getChildByTag:BGL_4] getChildByTag:5] boundingBox].size.width/1.5f, [[self getChildByTag:BGL_4] getChildByTag:6].position.y);
    }
    
    if (-self.position.x + self.contentSize.width >=[[self getChildByTag:BGL_4] getChildByTag:4].position.x + [[[self getChildByTag:BGL_4] getChildByTag:4] boundingBox].size.width/2-self.position.x/7.f) {
        
        [[self getChildByTag:BGL_4] getChildByTag:7].position = ccp([[self getChildByTag:BGL_4] getChildByTag:6].position.x+[[[self getChildByTag:BGL_4] getChildByTag:6] boundingBox].size.width/1.5f, [[self getChildByTag:BGL_4] getChildByTag:7].position.y);
    }
    
    if (-self.position.x + self.contentSize.width >=[[self getChildByTag:BGL_4] getChildByTag:5].position.x + [[[self getChildByTag:BGL_4] getChildByTag:5] boundingBox].size.width/2-self.position.x/7.f) {
        
        [[self getChildByTag:BGL_4] getChildByTag:0].position = ccp([[self getChildByTag:BGL_4] getChildByTag:7].position.x+[[[self getChildByTag:BGL_4] getChildByTag:7] boundingBox].size.width/1.5f, [[self getChildByTag:BGL_4] getChildByTag:0].position.y);
    }
    
    if (-self.position.x + self.contentSize.width >=[[self getChildByTag:BGL_4] getChildByTag:6].position.x + [[[self getChildByTag:BGL_4] getChildByTag:6] boundingBox].size.width/2-self.position.x/7.f) {
        
        [[self getChildByTag:BGL_4] getChildByTag:1].position = ccp([[self getChildByTag:BGL_4] getChildByTag:0].position.x+[[[self getChildByTag:BGL_4] getChildByTag:0] boundingBox].size.width/1.5f, [[self getChildByTag:BGL_4] getChildByTag:1].position.y);
    }
    
    if (-self.position.x + self.contentSize.width >=[[self getChildByTag:BGL_4] getChildByTag:7].position.x + [[[self getChildByTag:BGL_4] getChildByTag:7] boundingBox].size.width/2-self.position.x/7.f) {
        
        [[self getChildByTag:BGL_4] getChildByTag:2].position = ccp([[self getChildByTag:BGL_4] getChildByTag:1].position.x+[[[self getChildByTag:BGL_4] getChildByTag:1] boundingBox].size.width/1.5f, [[self getChildByTag:BGL_4] getChildByTag:2].position.y);
    }
    
    
    
    //####################################### PLANT ##################################################
    
    
    if (-self.position.x + self.contentSize.width/2 >=[[self getChildByTag:BGL_6] getChildByTag:10].position.x + [[[self getChildByTag:BGL_6] getChildByTag:10] boundingBox].size.width/2-self.position.x/12.f) {
        
        [[self getChildByTag:BGL_6] getChildByTag:13].position = ccp([[self getChildByTag:BGL_6] getChildByTag:12].position.x+[[[self getChildByTag:BGL_6] getChildByTag:12] boundingBox].size.width/1.3, [[self getChildByTag:BGL_6] getChildByTag:13].position.y);
    }
    
    if (-self.position.x + self.contentSize.width/2 >=[[self getChildByTag:BGL_6] getChildByTag:11].position.x + [[[self getChildByTag:BGL_6] getChildByTag:11] boundingBox].size.width/2-self.position.x/12.f) {
        
        [[self getChildByTag:BGL_6] getChildByTag:14].position = ccp([[self getChildByTag:BGL_6] getChildByTag:13].position.x+[[[self getChildByTag:BGL_6] getChildByTag:13] boundingBox].size.width/1.3, [[self getChildByTag:BGL_6] getChildByTag:14].position.y);
    }
    
    if (-self.position.x + self.contentSize.width/2 >= [[self getChildByTag:BGL_6] getChildByTag:12].position.x + [[[self getChildByTag:BGL_6] getChildByTag:12] boundingBox].size.width/2-self.position.x/12.f) {
        
        [[self getChildByTag:BGL_6] getChildByTag:15].position = ccp([[self getChildByTag:BGL_6] getChildByTag:14].position.x+[[[self getChildByTag:BGL_6] getChildByTag:14] boundingBox].size.width/1.3, [[self getChildByTag:BGL_6] getChildByTag:15].position.y);
    }
    
    if (-self.position.x + self.contentSize.width/2 >= [[self getChildByTag:BGL_6] getChildByTag:13].position.x + [[[self getChildByTag:BGL_6] getChildByTag:13] boundingBox].size.width/2-self.position.x/12.f) {
        
        [[self getChildByTag:BGL_6] getChildByTag:10].position = ccp([[self getChildByTag:BGL_6] getChildByTag:15].position.x+[[[self getChildByTag:BGL_6] getChildByTag:15] boundingBox].size.width/1.3, [[self getChildByTag:BGL_6] getChildByTag:10].position.y);
    }
    
    if (-self.position.x + self.contentSize.width/2 >=[[self getChildByTag:BGL_6] getChildByTag:14].position.x + [[[self getChildByTag:BGL_6] getChildByTag:14] boundingBox].size.width/2-self.position.x/12.f) {
        
        [[self getChildByTag:BGL_6] getChildByTag:11].position = ccp([[self getChildByTag:BGL_6] getChildByTag:10].position.x+[[[self getChildByTag:BGL_6] getChildByTag:10] boundingBox].size.width/1.3, [[self getChildByTag:BGL_6] getChildByTag:11].position.y);
    }
    
    if (-self.position.x + self.contentSize.width/2 >=[[self getChildByTag:BGL_6] getChildByTag:15].position.x + [[[self getChildByTag:BGL_6] getChildByTag:15] boundingBox].size.width/2-self.position.x/12.f) {
        
        [[self getChildByTag:BGL_6] getChildByTag:12].position = ccp([[self getChildByTag:BGL_6] getChildByTag:11].position.x+[[[self getChildByTag:BGL_6] getChildByTag:11] boundingBox].size.width/1.3, [[self getChildByTag:BGL_6] getChildByTag:12].position.y);
    }
    
    
    
    
    
    //####################################### TREES ##################################################
    
    
    if (-self.position.x + self.contentSize.width/2 >=[[self getChildByTag:BGL_5] getChildByTag:0].position.x + [[[self getChildByTag:BGL_5] getChildByTag:0] boundingBox].size.width/2-self.position.x/7.5f) {
        
        [[self getChildByTag:BGL_5] getChildByTag:3].position = ccp([[self getChildByTag:BGL_5] getChildByTag:2].position.x+[[[self getChildByTag:BGL_5] getChildByTag:2] boundingBox].size.width*2.f, [[self getChildByTag:BGL_5] getChildByTag:3].position.y);
    }
    
    if (-self.position.x + self.contentSize.width/2 >=[[self getChildByTag:BGL_5] getChildByTag:1].position.x + [[[self getChildByTag:BGL_5] getChildByTag:1] boundingBox].size.width/2-self.position.x/7.5f) {
        
        [[self getChildByTag:BGL_5] getChildByTag:4].position = ccp([[self getChildByTag:BGL_5] getChildByTag:3].position.x+[[[self getChildByTag:BGL_5] getChildByTag:3] boundingBox].size.width*3.5f, [[self getChildByTag:BGL_5] getChildByTag:4].position.y);
    }
    
    if (-self.position.x + self.contentSize.width/2 >= [[self getChildByTag:BGL_5] getChildByTag:2].position.x + [[[self getChildByTag:BGL_5] getChildByTag:2] boundingBox].size.width/2-self.position.x/7.5f) {
        
        [[self getChildByTag:BGL_5] getChildByTag:5].position = ccp([[self getChildByTag:BGL_5] getChildByTag:4].position.x+[[[self getChildByTag:BGL_5] getChildByTag:4] boundingBox].size.width*1.5f, [[self getChildByTag:BGL_5] getChildByTag:5].position.y);
    }
    
    if (-self.position.x + self.contentSize.width/2 >= [[self getChildByTag:BGL_5] getChildByTag:3].position.x + [[[self getChildByTag:BGL_5] getChildByTag:3] boundingBox].size.width/2-self.position.x/7.5f) {
        
        [[self getChildByTag:BGL_5] getChildByTag:0].position = ccp([[self getChildByTag:BGL_5] getChildByTag:5].position.x+[[[self getChildByTag:BGL_5] getChildByTag:5] boundingBox].size.width, [[self getChildByTag:BGL_5] getChildByTag:0].position.y);
    }
    
    if (-self.position.x + self.contentSize.width/2 >=[[self getChildByTag:BGL_5] getChildByTag:4].position.x + [[[self getChildByTag:BGL_5] getChildByTag:4] boundingBox].size.width/2-self.position.x/7.5f) {
        
        [[self getChildByTag:BGL_5] getChildByTag:1].position = ccp([[self getChildByTag:BGL_5] getChildByTag:0].position.x+[[[self getChildByTag:BGL_5] getChildByTag:0] boundingBox].size.width*3.f, [[self getChildByTag:BGL_5] getChildByTag:1].position.y);
    }
    
    if (-self.position.x + self.contentSize.width/2 >=[[self getChildByTag:BGL_5] getChildByTag:5].position.x + [[[self getChildByTag:BGL_5] getChildByTag:5] boundingBox].size.width/2-self.position.x/7.5f) {
        
        [[self getChildByTag:BGL_5] getChildByTag:2].position = ccp([[self getChildByTag:BGL_5] getChildByTag:1].position.x+[[[self getChildByTag:BGL_5] getChildByTag:1] boundingBox].size.width*2.3f, [[self getChildByTag:BGL_5] getChildByTag:2].position.y);
    }
     
}

-(void)createSBonus
{
    CGRect rect;
    if (IS_IPAD){rect = CGRectMake(0, 0, 327, 94.5);}else{rect = CGRectMake(0, 0, 153.5, 44.5);}
    
    for (int i = 0; i<4; i++) {
        
        SpeedBonus*spBonus = [[[SpeedBonus alloc]initWithRect:rect] autorelease];
        
        switch (i) {
            case 0:spBonus.position = ccp(kWidthScreen*6, [self MyRandomIntegerBetween:(int)kHeightScreen/3 :(int)kHeightScreen/1.3]);break;
            case 1:spBonus.position = ccp(kWidthScreen*10, [self MyRandomIntegerBetween:(int)kHeightScreen/3 :(int)kHeightScreen/1.3]);break;
            case 2:spBonus.position = ccp(kWidthScreen*20, [self MyRandomIntegerBetween:(int)kHeightScreen/3 :(int)kHeightScreen/1.3]);break;
            case 3:spBonus.position = ccp(kWidthScreen*29, [self MyRandomIntegerBetween:(int)kHeightScreen/3 :(int)kHeightScreen/1.3]);break;
            default:break;
        }
        
        spBonus.anchorPoint = ccp(0, 0);
        [self addChild:spBonus z:6 tag:Bonus+i];
        
    }
}

-(void)addCCFallow
{
    CGRect rect = CGRectMake(-self.position.x, 0, kWidthScreen*45 + self.position.x, kHeightScreen);
    
    float a;
    if (IS_IPAD) {a = 0.f;}else if (IS_IPHONE_5){a = 0.f;} else if (IS_IPHONE){a = -0.1f;}
    
    [self runAction:[CCFollowDynamic actionWithTarget:[self getChildByTag:zombie] worldBoundary:rect smoothingFactor:0.05f nodePlace:a]].tag = 0;
}


-(void)addBackground{
    
    //#################################### FIRST ROCK #################################################
    
    
    //[[GB2ShapeCache sharedShapeCache] addShapesWithFile:[NSString stringWithFormat:@"PE_Level11%@.plist",kDevice]];
    /*
     CCSprite *spriteRock = [CCSprite spriteWithSpriteFrameName:@"ground_start.png"];
     spriteRock.anchorPoint = ccp(0, 0);
     spriteRock.position = ccp(0, 0);
     spriteRock.opacity = alpha;
     [[self getChildByTag:BGL_4] addChild:spriteRock z:0 tag:20];
     */
    /*
     b2BodyDef firstR;
     firstR.type = b2_kinematicBody;
     firstR.position.Set(0/PTM_RATIO, 0/PTM_RATIO);
     firstR.userData = spriteRock;
     b2Body*FR = _world->CreateBody(&firstR);
     FR->SetFixedRotation(true);
     
     [[GB2ShapeCache sharedShapeCache]addFixturesToBody:FR forShapeName:@"ground_start"];
     
     */
    
    //#################################### BACKGROUND #################################################
    
    
    
    for (int i = 0; i <= 2; i++) {
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"background.jpg"];
        sprite.anchorPoint = ccp(0.5f, 0.5f);
        sprite.opacity = alpha;
        switch (i) {
            case 0:sprite.position = [self convertToNodeSpace:ccp(0, kHeightScreen/2)];break;
                
            case 1:sprite.position = [self convertToNodeSpace:ccp([[self getChildByTag:BGL_1] getChildByTag:0].contentSize.width, kHeightScreen/2)];break;
                
            case 2:sprite.position = [self convertToNodeSpace:ccp([[self getChildByTag:BGL_1] getChildByTag:1].position.x + [[[self getChildByTag:BGL_1] getChildByTag:1] boundingBox].size.width, kHeightScreen/2)]; break;
            default:break;
        }
        [[self getChildByTag:BGL_1] addChild:sprite z:0 tag:i];
    }
    
    
    //#################################### BACKGROUND 1 #################################################
    
    if (IS_IPAD) {
           
    for (int i = 0; i <= 2; i++) {
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"background_1.png"];
        sprite.anchorPoint = ccp(0.5f, 0);
        sprite.opacity = alpha;
        switch (i) {
            case 0:sprite.position = [self convertToNodeSpace:ccp(0, 0)];break;
                
            case 1:sprite.position = [self convertToNodeSpace:ccp([[self getChildByTag:BGL_2] getChildByTag:0].contentSize.width-2, 0)];break;
                
            case 2:sprite.position = [self convertToNodeSpace:ccp([[self getChildByTag:BGL_2] getChildByTag:1].position.x + [[[self getChildByTag:BGL_2] getChildByTag:1] boundingBox].size.width-2, 0)]; break;
            default:break;
        }
        [[self getChildByTag:BGL_2] addChild:sprite z:0 tag:i];
    }
    }

    //#################################### PALM BACK  #########################################
    
    
    for (int i = 0; i < 8; i++) {
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"palm_0.png"];
        sprite.anchorPoint = ccp(0.5f, 0);
        sprite.opacity = alpha;
        switch (i) {
            case 0:sprite.position = ccp(0, kHeightScreen-sprite.contentSize.height);break;
                
            case 1:sprite.position = ccp([[self getChildByTag:BGL_3] getChildByTag:0].contentSize.width/1.5, kHeightScreen-sprite.contentSize.height);sprite.flipX = YES; break;
                
            case 2:sprite.position = ccp([[self getChildByTag:BGL_3] getChildByTag:1].position.x + [[[self getChildByTag:BGL_3] getChildByTag:1] boundingBox].size.width/1.5, kHeightScreen-sprite.contentSize.height); break;
                
            case 3:sprite.position = ccp([[self getChildByTag:BGL_3] getChildByTag:2].position.x + [[[self getChildByTag:BGL_3] getChildByTag:2] boundingBox].size.width/1.5, kHeightScreen-sprite.contentSize.height); break;
                
            case 4:sprite.position = ccp([[self getChildByTag:BGL_3] getChildByTag:3].position.x + [[[self getChildByTag:BGL_3] getChildByTag:3] boundingBox].size.width/1.5, kHeightScreen-sprite.contentSize.height);sprite.flipX = YES; break;
                
            case 5:sprite.position = ccp([[self getChildByTag:BGL_3] getChildByTag:4].position.x + [[[self getChildByTag:BGL_3] getChildByTag:4] boundingBox].size.width/1.5, kHeightScreen-sprite.contentSize.height);sprite.flipX = YES; break;
                
            case 6:sprite.position = ccp([[self getChildByTag:BGL_3] getChildByTag:5].position.x + [[[self getChildByTag:BGL_3] getChildByTag:5] boundingBox].size.width/1.5, kHeightScreen-sprite.contentSize.height); break;
                
            case 7:sprite.position = ccp([[self getChildByTag:BGL_3] getChildByTag:6].position.x + [[[self getChildByTag:BGL_3] getChildByTag:6] boundingBox].size.width/1.5, kHeightScreen-sprite.contentSize.height);sprite.flipX = YES; break;
                
            default:break;
        }
        [[self getChildByTag:BGL_3] addChild:sprite z:0 tag:i];
    }
    
    
    
    //#################################### PALM FRONT #########################################
    
    
    
    
    for (int i = 0; i < 8; i++) {
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"palm_2.png"];
        sprite.anchorPoint = ccp(0.5f, 0);
        sprite.opacity = alpha;
        switch (i) {
                
            case 0:sprite.position = [self convertToNodeSpace:ccp(0, kHeightScreen-sprite.contentSize.height)];break;
                
            case 1:sprite.position = [self convertToNodeSpace:ccp([[self getChildByTag:BGL_4] getChildByTag:0].contentSize.width/1.5, kHeightScreen-sprite.contentSize.height)];sprite.flipX = YES; break;
                
            case 2:sprite.position = [self convertToNodeSpace:ccp([[self getChildByTag:BGL_4] getChildByTag:1].position.x + [[[self getChildByTag:BGL_4] getChildByTag:1] boundingBox].size.width/1.5, kHeightScreen-sprite.contentSize.height)]; break;
                
            case 3:sprite.position = [self convertToNodeSpace:ccp([[self getChildByTag:BGL_4] getChildByTag:2].position.x + [[[self getChildByTag:BGL_4] getChildByTag:2] boundingBox].size.width/1.5, kHeightScreen-sprite.contentSize.height)]; break;
                
            case 4:sprite.position = [self convertToNodeSpace:ccp([[self getChildByTag:BGL_4] getChildByTag:3].position.x + [[[self getChildByTag:BGL_4] getChildByTag:3] boundingBox].size.width/1.5, kHeightScreen-sprite.contentSize.height)];sprite.flipX = YES; break;
                
            case 5:sprite.position = [self convertToNodeSpace:ccp([[self getChildByTag:BGL_4] getChildByTag:4].position.x + [[[self getChildByTag:BGL_4] getChildByTag:4] boundingBox].size.width/1.5, kHeightScreen-sprite.contentSize.height)];sprite.flipX = YES; break;
                
            case 6:sprite.position = [self convertToNodeSpace:ccp([[self getChildByTag:BGL_4] getChildByTag:5].position.x + [[[self getChildByTag:BGL_4] getChildByTag:5] boundingBox].size.width/1.5, kHeightScreen-sprite.contentSize.height)]; break;
            case 7:sprite.position = [self convertToNodeSpace:ccp([[self getChildByTag:BGL_4] getChildByTag:6].position.x + [[[self getChildByTag:BGL_4] getChildByTag:6] boundingBox].size.width/1.5, kHeightScreen-sprite.contentSize.height)];sprite.flipX = YES; break;
                
            default:break;
        }
        [[self getChildByTag:BGL_4] addChild:sprite z:0 tag:i];
    }
    
    
    //#################################### GRASS ##########################################
    
    
    for (int i = 0; i <= 5; i++) {
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"plant_front.png"];
        sprite.anchorPoint = ccp(0.5f, 0);
        sprite.opacity = alpha;
        switch (i) {
            case 0:sprite.position = ccp(0+sprite.contentSize.width, 0);break;
                
            case 1:sprite.position = ccp([[self getChildByTag:BGL_6] getChildByTag:10].position.x+[[self getChildByTag:BGL_6] getChildByTag:10].contentSize.width/1.3, 0);sprite.flipX = YES; break;
                
            case 2:sprite.position = ccp([[self getChildByTag:BGL_6] getChildByTag:11].position.x + [[[self getChildByTag:BGL_6] getChildByTag:11] boundingBox].size.width/1.3, 0); break;
                
            case 3:sprite.position = ccp([[self getChildByTag:BGL_6] getChildByTag:12].position.x + [[[self getChildByTag:BGL_6] getChildByTag:12] boundingBox].size.width/1.3, 0); break;
                
            case 4:sprite.position = ccp([[self getChildByTag:BGL_6] getChildByTag:13].position.x + [[[self getChildByTag:BGL_6] getChildByTag:13] boundingBox].size.width/1.3, 0);sprite.flipX = YES; break;
                
            case 5:sprite.position = ccp([[self getChildByTag:BGL_6] getChildByTag:14].position.x + [[[self getChildByTag:BGL_6] getChildByTag:14] boundingBox].size.width/1.3, 0);sprite.flipX = YES; break;
                
            default:break;
        }
        [[self getChildByTag:BGL_6] addChild:sprite z:6 tag:10+i];
    }
    
    
    //###################################### TREES #############################################
    
    
    
    for (int i = 0; i <= 5; i++) {
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"palm_1.png"];
        sprite.anchorPoint = ccp(0.5f, 0);
        sprite.opacity = alpha;
        switch (i) {
            case 0:sprite.position = ccp(0+sprite.contentSize.width, 0);sprite.rotation = 13; break;
                
            case 1:sprite.position = ccp([[self getChildByTag:BGL_5] getChildByTag:0].position.x + [[self getChildByTag:BGL_5] getChildByTag:0].contentSize.width*3.f, 0);sprite.flipX = YES; break;
                
            case 2:sprite.position = ccp([[self getChildByTag:BGL_5] getChildByTag:1].position.x + [[[self getChildByTag:BGL_5] getChildByTag:1] boundingBox].size.width*2.3f, 0);sprite.rotation = -7; break;
                
            case 3:sprite.position = ccp([[self getChildByTag:BGL_5] getChildByTag:2].position.x + [[[self getChildByTag:BGL_5] getChildByTag:2] boundingBox].size.width*2.f, 0);sprite.rotation = 6; break;
                
            case 4:sprite.position = ccp([[self getChildByTag:BGL_5] getChildByTag:3].position.x + [[[self getChildByTag:BGL_5] getChildByTag:3] boundingBox].size.width*3.5f, 0);sprite.flipX = YES; sprite.rotation = 16; break;
                
            case 5:sprite.position = ccp([[self getChildByTag:BGL_5] getChildByTag:4].position.x + [[[self getChildByTag:BGL_5] getChildByTag:4] boundingBox].size.width*1.5f, 0);sprite.flipX = YES;sprite.rotation = -12; break;
                
            default:break;
        }
        [[self getChildByTag:BGL_5] addChild:sprite z:0 tag:i];
    }
    
    CCSprite *sprite_ = [CCSprite spriteWithSpriteFrameName:@"temple.png"];
    sprite_.anchorPoint = ccp(0, 0);
   
    sprite_.position = ccp(kWidthScreen*40.35f, 0);
    sprite_.scale = 1.2f;
    [self addChild:sprite_ z:9 tag:Temple];
    
}

-(void)createBGLayers{
    
    CCSprite *sprite = [[[CCSprite alloc] init] autorelease];
    sprite.anchorPoint = ccp(0, 0);
    sprite.position = ccp(0, 0);
    [self addChild:sprite z:0 tag:BGL_1];//Back BACKGROUND
    
    CCSprite *sprite2 = [[[CCSprite alloc] init] autorelease];
    sprite2.anchorPoint = ccp(0, 0);
    float a;
    if (IS_IPAD) {a = -kHeightScreen/11;}else{a = 0;}
    sprite2.position = ccp(0, a);
    [self addChild:sprite2 z:1 tag:BGL_2];//Middle BACKGROUND
    
    CCSprite *sprite3 = [[[CCSprite alloc] init] autorelease];
    sprite3.anchorPoint = ccp(0, 0);
    sprite3.position = ccp(0, 0);
    [self addChild:sprite3 z:4 tag:BGL_3];//Back PALM
    
    CCSprite *sprite4 = [[[CCSprite alloc] init] autorelease];
    sprite4.anchorPoint = ccp(0, 0);
    sprite4.position = ccp(0, 0);
    [self addChild:sprite4 z:8 tag:BGL_4];//Front PALM
    
    CCSprite *sprite5 = [[[CCSprite alloc] init] autorelease];
    sprite5.anchorPoint = ccp(0, 0);
    sprite5.position = ccp(0, 0);
    [self addChild:sprite5 z:5 tag:BGL_5];//TREES
    
    CCSprite *sprite6 = [[[CCSprite alloc] init] autorelease];
    sprite6.anchorPoint = ccp(0, 0);
    sprite6.position = ccp(0, 0);
    [self addChild:sprite6 z:8 tag:BGL_6];//GRASS
    
}

-(void)createBatchNode{
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
    CCSpriteBatchNode * spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"BG_Level11%@.pvr.ccz",kDevice]];
    
    [self addChild:spriteBatchNode z:0 tag:BGBCNode];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"BG_Level11%@.plist",kDevice]];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    CCSpriteBatchNode* spriteBatchNode2 = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"Level11%@.pvr.ccz",kDevice]];
    [self addChild:spriteBatchNode2 z:5 tag:BCNode];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"Level11%@.plist",kDevice]];
}


-(void)addBird
{
    for (int i = 0; i<=3; i++) {
        CCSprite *sprite;
        float a;
        if (IS_IPAD) {a = 1.5f;}else{a = 1.35f;}
        switch (i) {
            case 0:sprite = [CCSprite spriteWithSpriteFrameName:@"palm_1a.png"];sprite.anchorPoint = ccp(0.5f, 0);sprite.position = ccp(kWidthScreen*25, kHeightScreen/a); break;
                
            case 1:sprite = [CCSprite spriteWithSpriteFrameName:@"palm_1b.png"];sprite.anchorPoint = ccp(0.5f, 0);sprite.position = ccp([[self getChildByTag:BGL_5] getChildByTag:Bird].position.x+sprite.contentSize.width/2, kHeightScreen/a); break;
                
            case 2:sprite = [CCSprite spriteWithSpriteFrameName:@"bird_0.png"];sprite.anchorPoint = ccp(0.5f, 0); sprite.position = [[self getChildByTag:BGL_5] getChildByTag:Bird].position; break;
                
            case 3:sprite = [CCSprite spriteWithSpriteFrameName:@"bird_1.png"];sprite.anchorPoint = ccp(0.75f, 0.55f);sprite.position = ccp([[self getChildByTag:BGL_5] getChildByTag:Bird+2].position.x, [[self getChildByTag:BGL_5] getChildByTag:Bird+2].position.y+[[self getChildByTag:BGL_5] getChildByTag:Bird+2].contentSize.height/1.1);
                
                [sprite runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCEaseInOut actionWithAction:[CCRotateBy actionWithDuration:0.5f angle:-15] rate:2],[CCEaseInOut actionWithAction:[CCRotateBy actionWithDuration:0.5f angle:15] rate:2],[CCDelayTime actionWithDuration:0.2f], nil]]]; break;
            default:break;
        }
        [[self getChildByTag:BGL_5] addChild:sprite z:7 tag:Bird+i];
    }
}

-(void)GAME_RESUME{
    
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
    
    if (pause) {
        return;
    }
    
    pause = true;
    
    [self unschedule:@selector(GAME_PAUSE)];
    
    
    
    [self pauseSchedulerAndActions];
    pause = true;
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

- (id)initWithHUD:(InGameButtons *)hud
{
    if ((self = [super init])) {
        _hud = hud;
        
        self.isTouchEnabled = YES;
        
        segmentNum = 15;
        
        _beeMovDuration = 10;
        _delay = 2;
        
        gameOver = false;
        endOfTheGame = false;
        spiderTouched = false;
        bonusBrains = false;
        birdTouched = false;
        watchUp = false;
        watchUp1 = false;
        watchUp2 = false;
        
        CAN_TOUCH = YES;
        
        ropes = [[NSMutableArray alloc] init];
        candies = [[NSMutableArray alloc] init];
        ropeSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"rope%@.png",kDevice]];
        [self addChild:ropeSpriteSheet z:6];
        
        b2Vec2 gravity;
        if (IS_IPAD) {gravity = b2Vec2(0.0f, -20.0f);}else{gravity = b2Vec2(0.0f, -10.0f);}
        
        _world = new b2World(gravity);
        
        _world->SetAllowSleeping(true);
        
        _world->SetContinuousPhysics(true);
        
        
        [self createBatchNode];
        [self createBGLayers];
        [self addBackground];
        [self addMonsters];
        [self createSBonus];
        [self addSpider];
        [self addbrains];
        [self addBird];
        
        
        [self addRoomWalls];
        [self addZombie];
        
        [self loadRope];
        [self schedule:@selector(tick:)];
        [self schedule:@selector(pos:) interval:0.005f];
        
        self.position = ccpAdd(self.position, ccp(-kWidthScreen*0.275f,0));

        [self addCCFallow];
        
        //groundBody = _world->CreateBody(&groundBodyDef);
        
       /*
        uint32 flags = 0;
        flags += GLESDebugDraw::e_shapeBit;
        flags += GLESDebugDraw::e_jointBit;
        flags += GLESDebugDraw::e_aabbBit;
        flags += GLESDebugDraw::e_pairBit;
        flags += GLESDebugDraw::e_centerOfMassBit;
        
        GLESDebugDraw *debugDraw = new GLESDebugDraw(PTM_RATIO);
        debugDraw->SetFlags(flags);
        _world->SetDebugDraw(debugDraw);*/
        
        if (_hud.tutorialSHOW)
        {
            pause = YES;
            [self schedule:@selector(GAME_PAUSE) interval:0.1f];
        }
        
        _contactListener = new MyContactListenerS();
        _world->SetContactListener(_contactListener);
        [self schedule:@selector(impuls) interval:4];
        
        
        if (![Combinations checkNSDEFAULTS_Bool_ForKey:C_TUTORIAL_(_hud.level)]) {
        
            [cfg runSelectorTarget:self selector:@selector(showTutLVL11) object:nil afterDelay:0.2f sender:self];
            
        }
        
        //[[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"soundmain7.1.mp3" loop:YES];
        
	}
	return self;
}

- (void)onEnter{
    
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [super onEnter];
}


- (void)onExit{
   // [self removeAllChildrenWithCleanup:YES];
    
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [super onExit];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    delete _world;
  //  delete _contactListener;
	_world = NULL;
    _body = NULL;
    [ropes release];
    [candies release];
	[super dealloc];
}


@end
