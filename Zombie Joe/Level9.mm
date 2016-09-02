//
//  Level9.mm
//  project_box2d
//
//  Created by Slavian on 2013-05-09.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "Level9.h"
#import "cfg.h"
#import "Constants.h"
#import "SConfig.h"
#import "Combinations.h"
#import "SCombinations.h"
#import "GB2ShapeCache.h"
#import "CCFollowDynamicS.h"
#import "Monsters_level9.h"
#import "Bird.h"
#import "MyContactListenerS.h"
#import "BrainsBonus.h"

#import "Tutorial.h"

#import "SimpleAudioEngine.h"

#define bgLayerTag 19
#define bgLayerTag2 300
#define bgLayerTag3 301
#define bgLayerTag4 302
#define BG1 20
#define BG2 21
#define BG3 22
#define BG_4 333
#define BGbatchNode 30
#define SPbatchNode 1
#define SPbatchNode2 2
#define MonsterClass 40
#define MonsterClass2 50
#define Zombie 99
#define kBird 100
#define finishLine 205
#define birdInfo 206

#define alpha 255

#define brain1 200
#define brain2 201

//#define iPad_rect CGRectMake(0,0,140,110)
//#define iPhone_rect CGRectMake(0,0,23,23)



@implementation Level9
//@synthesize motionManager;
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	Level9 *layer = [Level9 node];
	[scene addChild: layer];
	return scene;
}
-(float)MyRandomIntegerBetween:(int)min :(int)max {
    
    return ( (arc4random() % (max-min+1)) + min )/7*arc4random() % 3/ arc4random() %9;
}

-(void)kick
{
    b2Vec2 force = b2Vec2(30,30);
    _body->ApplyLinearImpulse(force, _body->GetPosition());
}

-(void)endOfTheGAME:(NSNumber*)num
{
    //  [motionManager stopDeviceMotionUpdates]
    // [motionManager stopMagnetometerUpdates];
    
    // stopGame = true;
    
    if ((num.integerValue == 1) && !kickAss) {
        [AUDIO playEffect:fx_winmusic];
        [_hud TIME_Stop];
        [self unscheduleUpdate];
        [self unschedule:@selector(tick)];
        
        [_hud runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.5f],[CCCallFuncO actionWithTarget:_hud selector:@selector(WINLevel)], nil]];
        
    }
    else if(num.integerValue == 2 && !kickAss){kickAss = true;
        self.isTouchEnabled = NO;[self fingerLost];
       // [joerobot showKillBlastEffectInPosition:joerobot.position];
        [[joerobot robot_]colorAllBodyPartsWithColor:ccc3(220, 72, 72)
                                                part:0
                                                 all:YES
                                             restore:YES
                                   restoreAfterDelay:0.15f];
        [_hud runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.f],[CCCallFuncO actionWithTarget:_hud selector:@selector(LOSTLevel)], nil]];
    }
}

-(void)addRocksUp
{
    CCSprite *sprite;
    NSString *string;
    float k =0;
    int count = 0;
    if (IS_IPAD) {count = 5;}else{count = 3;}
    
    for (int i = 10; i <= 15; i++) {
        
        switch (i) {
            case 10:sprite = [CCSprite spriteWithSpriteFrameName:@"rock0.png"];sprite.anchorPoint = ccp(0, 0);sprite.position = ccp(-sprite.contentSize.width/3, kHeightScreen+sprite.contentSize.height/count);sprite.flipX = YES;k = 0.8f;string = @"rock0flippedY";break;
                
            case 11:sprite = [CCSprite spriteWithSpriteFrameName:@"rock1.png"];sprite.anchorPoint = ccp(0, 0);sprite.position = ccp([spriteBatchNode2 getChildByTag:10].position.x + [spriteBatchNode2 getChildByTag:10].contentSize.width, kHeightScreen+sprite.contentSize.height/count);sprite.flipX = YES;k = 0.825f;string = @"rock1flippedY";break;
                
            case 12:sprite = [CCSprite spriteWithSpriteFrameName:@"rock2.png"];sprite.anchorPoint = ccp(0, 0);sprite.position = ccp([spriteBatchNode2 getChildByTag:11].position.x + [spriteBatchNode2 getChildByTag:11].contentSize.width, kHeightScreen+sprite.contentSize.height/count);k = 0.77f;string = @"rock2flippedYX";break;
                
            case 13:sprite = [CCSprite spriteWithSpriteFrameName:@"rock0.png"];sprite.anchorPoint = ccp(0, 0);sprite.position = ccp([spriteBatchNode2 getChildByTag:12].position.x + [spriteBatchNode2 getChildByTag:12].contentSize.width, kHeightScreen+sprite.contentSize.height/count);k = 0.8f;string = @"rock0flippedYX";break;
                
            case 14:sprite = [CCSprite spriteWithSpriteFrameName:@"rock1.png"];sprite.anchorPoint = ccp(0, 0);sprite.position = ccp([spriteBatchNode2 getChildByTag:13].position.x + [spriteBatchNode2 getChildByTag:13].contentSize.width, kHeightScreen+sprite.contentSize.height/count);sprite.flipX = YES;k = 0.825f;string = @"rock1flippedY";break;
                
            case 15:sprite = [CCSprite spriteWithSpriteFrameName:@"rock2.png"];sprite.anchorPoint = ccp(0, 0);sprite.position = ccp([spriteBatchNode2 getChildByTag:14].position.x + [spriteBatchNode2 getChildByTag:14].contentSize.width, kHeightScreen+sprite.contentSize.height/count);k = 0.77f;string = @"rock2flippedYX";break;
            default:break;
        }
        sprite.opacity = 255;
        sprite.flipY = YES;
        
        b2BodyDef bodyDef;
        bodyDef.type = b2_kinematicBody;
        
        bodyDef.position.Set(sprite.position.x/PTM_RATIO, sprite.position.y/PTM_RATIO-sprite.contentSize.height*k/PTM_RATIO);
        bodyDef.userData = sprite;
        b2Body *body = _world->CreateBody(&bodyDef);
        
        [[GB2ShapeCache sharedShapeCache]addFixturesToBody:body forShapeName:[NSString stringWithFormat:@"%@",string]];
        
        
        [spriteBatchNode2 addChild:sprite z:2 tag:i];
    }
}

-(void)addRocksDown
{
    [[GB2ShapeCache sharedShapeCache] addShapesWithFile:[NSString stringWithFormat:@"PE_Level9%@.plist",kDevice]];
    
    CCSprite *firstrock = [CCSprite spriteWithSpriteFrameName:@"rock3.png"];
    firstrock.anchorPoint = ccp(0, 0);
    firstrock.position = ccp(0, -firstrock.contentSize.height/5);
    firstrock.flipX = YES;
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_staticBody;
    bodyDef.position.Set(firstrock.position.x/PTM_RATIO, firstrock.position.y/PTM_RATIO-firstrock.contentSize.height*0.2f/PTM_RATIO);
    bodyDef.userData = firstrock;
    b2Body *body = _world->CreateBody(&bodyDef);
    
    [[GB2ShapeCache sharedShapeCache]addFixturesToBody:body forShapeName:@"rock3flippedX"];
    
    [spriteBatchNode2 addChild:firstrock z:4 tag:6];
    
    CCSprite *sprite;
    NSString *string;
    float k =0;
    float a = 0;
    for (int i = 0; i <= 5; i++) {
        
        switch (i) {
            case 0:if (IS_IPAD){a = 8;}else{a = 5;}
                sprite = [CCSprite spriteWithSpriteFrameName:@"rock0.png"];sprite.anchorPoint = ccp(0, 0);sprite.position = ccp([spriteBatchNode2 getChildByTag:6].contentSize.width,-sprite.contentSize.height/a);k = 0.09f;string = @"rock0";break;
                
            case 1:if (IS_IPAD){a = 10;}else{a = 7;}
                sprite = [CCSprite spriteWithSpriteFrameName:@"rock1.png"];sprite.anchorPoint = ccp(0, 0);sprite.position = ccp([spriteBatchNode2 getChildByTag:0].position.x + [spriteBatchNode2 getChildByTag:0].contentSize.width, -sprite.contentSize.height/a);k = 0.075f;string = @"rock1";break;
                
            case 2:if (IS_IPAD){a = 5;}else{a = 2;}
                sprite = [CCSprite spriteWithSpriteFrameName:@"rock2.png"];sprite.anchorPoint = ccp(0, 0);sprite.position = ccp([spriteBatchNode2 getChildByTag:1].position.x + [spriteBatchNode2 getChildByTag:1].contentSize.width, -sprite.contentSize.height/a);k = 0.13f;string = @"rock2";break;
                
            case 3:if (IS_IPAD){a = 8;}else{a = 5;}
                sprite = [CCSprite spriteWithSpriteFrameName:@"rock0.png"];sprite.anchorPoint = ccp(0, 0);sprite.position = ccp([spriteBatchNode2 getChildByTag:2].position.x + [spriteBatchNode2 getChildByTag:2].contentSize.width, -sprite.contentSize.height/a);sprite.flipX = YES;k = 0.09f;string = @"rock0flippedX";break;
                
            case 4:if (IS_IPAD){a = 10;}else{a = 7;}
                sprite = [CCSprite spriteWithSpriteFrameName:@"rock1.png"];sprite.anchorPoint = ccp(0, 0);sprite.position = ccp([spriteBatchNode2 getChildByTag:3].position.x + [spriteBatchNode2 getChildByTag:3].contentSize.width, -sprite.contentSize.height/a);sprite.flipX = YES;k = 0.075f;string = @"rock1flippedX";break;
                
            case 5:if (IS_IPAD){a = 5;}else{a = 2;}
                sprite = [CCSprite spriteWithSpriteFrameName:@"rock2.png"];sprite.anchorPoint = ccp(0, 0);sprite.position = ccp([spriteBatchNode2 getChildByTag:4].position.x + [spriteBatchNode2 getChildByTag:4].contentSize.width, -sprite.contentSize.height/a);sprite.flipX = YES;k = 0.13f;string = @"rock2flippedX";break;
            default:break;
        }
        sprite.opacity = 255;
        b2BodyDef bodyDef;
        bodyDef.type = b2_kinematicBody;
        
        bodyDef.position.Set(sprite.position.x/PTM_RATIO, sprite.position.y/PTM_RATIO-sprite.contentSize.height*k/PTM_RATIO);
        bodyDef.userData = sprite;
        b2Body *body = _world->CreateBody(&bodyDef);
        
        [[GB2ShapeCache sharedShapeCache]addFixturesToBody:body forShapeName:[NSString stringWithFormat:@"%@",string]];
        
        //body->GetFixtureList()->GetShape()->m_radius = 0.2/PTM_RATIO;
        
        [spriteBatchNode2 addChild:sprite z:4 tag:i];
    }
}

-(void)backgroundAdd
{
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
    spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"BG_Level9%@.pvr.ccz",kDevice]];
    
    [[self getChildByTag:bgLayerTag] addChild:spriteBatchNode z:0 tag:BGbatchNode];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"BG_Level9%@.plist",kDevice]];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    spriteBatchNode2 = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"Level9%@.pvr.ccz",kDevice]];
    [self addChild:spriteBatchNode2 z:4 tag:SPbatchNode];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"Level9%@.plist",kDevice]];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    CCSpriteBatchNode *spriteBatchnode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"Level9_zombie%@.pvr.ccz",kDevice]];
    [self addChild:spriteBatchnode z:2 tag:SPbatchNode2];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"Level9_zombie%@.plist",kDevice]];
    
    
    for (int i = 0; i<3; i++) {
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"background.jpg"];
        sprite.opacity = alpha;
        sprite.anchorPoint = ccp(0, 0);
        
        switch (i) {
            case 0:sprite.position = [self convertToNodeSpace:ccp(0, 0)];break;
                
            case 1:sprite.position = [self convertToNodeSpace:ccp([[self getChildByTag:bgLayerTag] getChildByTag:BG1].contentSize.width, 0)];break;
                
            case 2:sprite.position = [self convertToNodeSpace:ccp([[self getChildByTag:bgLayerTag] getChildByTag:BG2].position.x + [[[self getChildByTag:bgLayerTag] getChildByTag:BG2] boundingBox].size.width, 0)]; break;
                
            default:break;
        }
        
        //[sprite runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCFadeTo actionWithDuration:1.5f opacity:190],[CCDelayTime actionWithDuration:4],[CCFadeTo actionWithDuration:1.5f opacity:255],[CCDelayTime actionWithDuration:2], nil]]];
        [[self getChildByTag:bgLayerTag] addChild:sprite z:0 tag:BG1+i];
    }
    
    for (int i = 1; i<=2; i++) {
        
        CCSprite *eye = [CCSprite spriteWithSpriteFrameName:@"eye.png"];
        eye.anchorPoint = ccp(0.5f, 0.5f);
        switch (i) {
            case 1:eye.position = ccp([[self getChildByTag:bgLayerTag] getChildByTag:BG1+i].contentSize.width/5, [[self getChildByTag:bgLayerTag] getChildByTag:BG1+i].contentSize.height/2);break;
            case 2:eye.position = ccp([[self getChildByTag:bgLayerTag] getChildByTag:BG1+i].contentSize.width/2, [[self getChildByTag:bgLayerTag] getChildByTag:BG1+i].contentSize.height/2);break;
            default:break;
        }
        
        [[[self getChildByTag:bgLayerTag] getChildByTag:BG1+i] addChild:eye z:1 tag:i];
        
        [[[[self getChildByTag:bgLayerTag] getChildByTag:BG1+i] getChildByTag:i]runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.5f],[CCBlink actionWithDuration:0.5f blinks:i], nil]]];
    }
    
    for (int i = 0; i<3; i++) {
        CCSprite *sprite_ = [CCSprite spriteWithSpriteFrameName:@"kolona_front.png"];
        switch (i) {
            case 0:sprite_.position = ccp(kWidthScreen*1.5f,0); break;
            case 1:sprite_.position = ccp([[self getChildByTag:bgLayerTag2] getChildByTag:0].position.x+kWidthScreen*1.3f,0);break;
            case 2:sprite_.position = ccp([[self getChildByTag:bgLayerTag2] getChildByTag:1].position.x+kWidthScreen*1.6f,0);break;
            default:break;
        }
        sprite_.anchorPoint = ccp(1.f, 0.5f);
        
        [[self getChildByTag:bgLayerTag2] addChild:sprite_ z:1 tag:i];
        
    }
    
    for (int i = 0; i<3; i++) {
        CCSprite *sprite_ = [CCSprite spriteWithSpriteFrameName:@"kolona_back.png"];
        switch (i) {
            case 0:sprite_.position = ccp(kWidthScreen*0.8f,0); break;
            case 1:sprite_.position = ccp([[self getChildByTag:bgLayerTag2] getChildByTag:0].position.x+kWidthScreen*0.7f,0);break;
            case 2:sprite_.position = ccp([[self getChildByTag:bgLayerTag2] getChildByTag:1].position.x+kWidthScreen*0.9f,0);break;
            default:break;
        }
        sprite_.anchorPoint = ccp(1.f, 0.5f);
        
        [[self getChildByTag:bgLayerTag3] addChild:sprite_ z:1 tag:i];
    }
    
    float a;
    for (int i = 0; i<6; i++) {
        CCSprite *sprite_ = [CCSprite spriteWithSpriteFrameName:@"rock_background.png"];
        switch (i) {
            case 0:if (IS_IPAD){a = 0;}else{a = -30;}
                sprite_.position = ccp(kWidthScreen*0.5f,a);sprite_.anchorPoint = ccp(0.5f, 0.2f); break;
            case 1:if (IS_IPAD){a = 0;}else{a = 30;}
                sprite_.position = ccp([[self getChildByTag:bgLayerTag4] getChildByTag:0].position.x+kWidthScreen*0.7f,kHeightScreen+a);sprite_.anchorPoint = ccp(0.5f, 0.8f);sprite_.flipY = true;break;
            case 2:if (IS_IPAD){a = 0;}else{a = -30;}
                sprite_.position = ccp([[self getChildByTag:bgLayerTag4] getChildByTag:1].position.x+kWidthScreen*0.5f,a);sprite_.anchorPoint = ccp(0.5f, 0.2f);break;
            case 3:if (IS_IPAD){a = 0;}else{a = -30;}
                sprite_.position = ccp([[self getChildByTag:bgLayerTag4] getChildByTag:2].position.x+kWidthScreen*0.75f,a);sprite_.anchorPoint = ccp(0.5f, 0.2f);break;
            case 4:if (IS_IPAD){a = 0;}else{a = 30;}
                sprite_.position = ccp([[self getChildByTag:bgLayerTag4] getChildByTag:3].position.x+kWidthScreen*0.9f,kHeightScreen+a);sprite_.anchorPoint = ccp(0.5f, 0.8f);sprite_.flipY = true;break;
            case 5:if (IS_IPAD){a = 0;}else{a = 30;}
                sprite_.position = ccp([[self getChildByTag:bgLayerTag4] getChildByTag:4].position.x+kWidthScreen*1.2f,kHeightScreen+a);sprite_.anchorPoint = ccp(0.5f, 0.8f);sprite_.flipY= true;break;
            default:break;
        }
        
        [[self getChildByTag:bgLayerTag4] addChild:sprite_ z:0 tag:i];
    }
    
}
-(void)addRoomWalls
{
    //********* GROUND ************
    b2BodyDef groundBoduDef;
    groundBoduDef.position.Set(0, -20/PTM_RATIO);
    b2Body *groundBody = _world->CreateBody(&groundBoduDef);
    b2PolygonShape groundShape;
    b2FixtureDef boxShapeDef;
    boxShapeDef.friction = 0;
    boxShapeDef.shape = &groundShape;
    groundShape.SetAsBox((kHeightScreen*21)/PTM_RATIO,0);
    groundBody->CreateFixture(&boxShapeDef);
    
    //********* LEFT WALL ************
    b2BodyDef wall_leftDef;
    wall_leftDef.position.Set(-10/PTM_RATIO, 10/PTM_RATIO);
    wall_left_Body = _world->CreateBody(&wall_leftDef);
    b2PolygonShape wall_left_shape;
    b2FixtureDef wall_left_fixture;
    wall_left_fixture.friction = 0;
    wall_left_fixture.shape = &wall_left_shape;
    wall_left_shape.SetAsBox(10/PTM_RATIO,kHeightScreen/PTM_RATIO);
    wall_left_Body->CreateFixture(&wall_left_fixture);
    
    //********* RIGHT WALL ************
    b2BodyDef wall_rightDef;
    wall_rightDef.position.Set(kHeightScreen*21/PTM_RATIO,0);
    wall_right_Body = _world->CreateBody(&wall_rightDef);
    b2PolygonShape wall_right_shape;
    b2FixtureDef wall_right_fixture;
    wall_right_fixture.shape = &wall_right_shape;
    wall_right_fixture.friction = 0;
    wall_right_shape.SetAsBox(10/PTM_RATIO,kHeightScreen/PTM_RATIO);
    wall_right_Body->CreateFixture(&wall_right_fixture);
    
    //********* TOP ************
    b2BodyDef wall_topDef;
    wall_topDef.position.Set(0, kHeightScreen+20/PTM_RATIO);
    b2Body *wall_top_Body = _world->CreateBody(&wall_topDef);
    b2PolygonShape wall_top_shape;
    b2FixtureDef wall_top_fixture;
    wall_top_fixture.friction = 0;
    wall_top_fixture.shape = &wall_top_shape;
    wall_top_shape.SetAsBox((kHeightScreen*21)/PTM_RATIO,0);
    wall_top_Body->CreateFixture(&wall_top_fixture);
    
}

-(void)addCCFallow
{
    float a;
    if (IS_IPAD) {a = 20.f;}else if (IS_IPHONE_5){a = 19.98f;}else if (IS_IPHONE){a = 20.f;}
    CGRect rect = CGRectMake(-self.position.x, 0, kWidthScreen*a + self.position.x, kHeightScreen);
    
    //    [self runAction:[CCFollowDynamicS actionWithTarget:joerobot worldBoundary:rect smoothingFactor:0.05f]].tag = 0;
    
    [self runAction:[CCFollowDynamicS actionWithTarget:joerobot worldBoundary:rect smoothingFactor:0.05f]].tag = 0;
    
}

-(void) draw
{
    /*
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
     */
     
}

-(void)repositionBodyByTag:(int)tag__:(b2Vec2)position{
    
    for (b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData()!=NULL) {
            CCSprite *rockData = (CCSprite *)b->GetUserData();
            if (rockData.tag==tag__) {
                b->SetTransform(position, 0);
            }
            rockData.position = ccp(b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
            rockData.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
        }
    }
    
}

-(void)monster2Eat:(CGPoint)pos{
    _body->SetType(b2_kinematicBody);
    
    _body->SetTransform(b2Vec2(pos.x/PTM_RATIO,pos.y/PTM_RATIO), 0);
    //joerobot.position = ccp(pos.x, pos.y);
}

-(void)particles
{
    /*
     CCParticleSystemQuad *effect = [CCParticleSystemQuad particleWithFile:@"zombie_par.plist"];
     
     effect.position = ccp([[self getChildByTag:SPbatchNode2] getChildByTag:Zombie].position.x,[[self getChildByTag:SPbatchNode2] getChildByTag:Zombie].position.y);
     
     if (IS_IPHONE || IS_IPHONE_5) {effect.scale = 0.4f;}
     else{effect.scale = 0.7f;}
     
     [self addChild:effect z:5];
     
     effect.autoRemoveOnFinish = YES;
     */

        [_hud makeBlastInPosposition:ccp(joerobot.position.x,joerobot.position.y)];
   // NSLog(@"PATIKRINIMAS!!!!!!!!");
    
}

-(void)stateGAMEOVER
{
    if (!kickAss) {
        
        if (joerobot.position.x > kWidthScreen*3)
        {
            [Combinations saveNSDEFAULTS_Bool:YES forKey:C_TUTORIAL_([_hud level])];
        }
        
        
        [[joerobot robot_] ACTION_CLOSE_EYES_eyesTag:10];
        
    
        //[self particles];
        int heigth;
        if (IS_IPAD){heigth = 300;}else{heigth = 100;}
        
        
        id action = [CCEaseInOut actionWithAction:[CCJumpBy actionWithDuration:1.1f position:ccp(100, -kHeightScreen) height:heigth jumps:1] rate:2];
        
        [[[[self getChildByTag:SPbatchNode2] getChildByTag:Zombie] getChildByTag:0]runAction:action];
        [[[[self getChildByTag:SPbatchNode2] getChildByTag:Zombie] getChildByTag:1]runAction:[action copy]];
        
        //CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
       // [[[self getChildByTag:SPbatchNode2] getChildByTag:Zombie] runAction:[CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:[NSArray arrayWithObjects:/*[cache spriteFrameByName:@"hat3.png"],[cache spriteFrameByName:@"hat2.png"],*/[cache spriteFrameByName:@"death.png"], nil] /*delay:0.09f*/] restoreOriginalFrame:NO]];
        
        _body->ApplyLinearImpulse(b2Vec2(0,0), _body->GetPosition());
        _body->SetGravityScale(IS_IPAD ? 5 : 3);
        
        if([self getActionByTag:999])
        {
            [self stopActionByTag:999];
        }
        CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [propeller runAction:[CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:[NSArray arrayWithObjects:/*[cache spriteFrameByName:@"hat3.png"],[cache spriteFrameByName:@"hat2.png"],*/[cache spriteFrameByName:@"hat4.png"], nil] /*delay:0.09f*/] restoreOriginalFrame:NO]];
        
        [self reorderChild:joerobot z:1];
        joerobot.anchorPoint = ccp(0.5f, 1.f);
        
        [self stopActionByTag:0];
        
        // NSLog(@"222222222222");
        
        //joerobot.anchorPoint = ccp(0.5f, 0.5f);
        
        //[joerobot runAction:[CCEaseInOut actionWithAction:[CCJumpBy actionWithDuration:1.4f position:ccp(-100, -kHeightScreen) height:heigth jumps:1] rate:2]];
        
        self.isAccelerometerEnabled = NO;
    }
    
    // self.isTouchEnabled = NO;
}

-(void)destroyBrains:(NSNumber *)num{
    switch (num.intValue) {
        case 0:[[self getChildByTag:brain1] removeFromParentAndCleanup:YES];break;
        case 1:[[self getChildByTag:TAG_BRAIN_1] removeFromParentAndCleanup:YES];break;
        case 2:[[self getChildByTag:TAG_BRAIN_2] removeFromParentAndCleanup:YES];break;
            
        default:
            break;
    }
}

-(void) tick: (ccTime) dt
{
    if (!kickAss) {
        
        if ((CGRectIntersectsRect([joerobot boundingBox],[[spriteBatchNode2 getChildByTag:6]boundingBox])))
        {
            if (!iddle_s) {
                iddle_s = true;
                notIddle_s = false;
                [[joerobot robot_]JOE_IDLE_MENU];
                self.isAccelerometerEnabled = NO;
            }
        }
        else
        {
            if (!notIddle_s)
            {
//                [[joerobot robot_] ACTION_RemoveStateByID:0];
//                [[joerobot robot_] ACTION_RemoveStateByID:1];
//                [[joerobot robot_] ACTION_RemoveStateByID:4];
//                
                 [[joerobot robot_]  ACTION_StopAllPartsAnimations_Clean:YES];

                notIddle_s = true;
                iddle_s = false;
                self.isAccelerometerEnabled = YES;
            }
        
        }
    }
    
    
    for (int i = 0; i<=2; i++) {
        
        if ((CGRectIntersectsRect([joerobot boundingBox],[[self getChildByTag:brain1] boundingBox])) && !b_brain1 && !kickAss)
        {
            [cfg makeBrainActionForNode:[self getChildByTag:brain1] fakeBrainsNode:nil direction:90 pixelsToMove:50 time:0.2f parent:self removeBrainsAfter:YES makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
            b_brain1 = true;
            
        }
        if ((CGRectIntersectsRect([joerobot boundingBox],[[self getChildByTag:TAG_BRAIN_1] boundingBox])) && !b_brain2 && !kickAss)
        {
            [cfg makeBrainActionForNode:[self getChildByTag:TAG_BRAIN_1] fakeBrainsNode:nil direction:90 pixelsToMove:50 time:0 parent:self removeBrainsAfter:YES makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
            b_brain2 = true;
            
        }
        if ((CGRectIntersectsRect([joerobot boundingBox],[[self getChildByTag:TAG_BRAIN_2] boundingBox])) && !b_brain3 && !kickAss)
        {
            [cfg makeBrainActionForNode:[self getChildByTag:TAG_BRAIN_2] fakeBrainsNode:nil direction:90 pixelsToMove:50 time:0.f parent:self removeBrainsAfter:YES makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
            b_brain3 = true;
            
        }
    }
    
    if (!L9_COLLIDERS/* && -self.position.x + self.contentSize.width > kWidthScreen*3*/) {
        if(!endFlag){
            for (int i = 0; i < 3; i++) {
                
                CCSprite*l;
                    Monsters_level9*sp = (Monsters_level9*)[self getChildByTag:MonsterClass2+i];
                    l = (CCSprite*)[sp.spriteBatchNodeML getChildByTag:42];
                
                
//                CGRect f = [[self getChildByTag:MonsterClass2+i]boundingBox];
//                f.size.width = f.size.width*2;
//                f.size.height = f.size.height*7;
//                f.origin.x = f.origin.x - f.size.width/2;

                
//                CGRect g = [[self getChildByTag:MonsterClass+i]boundingBox];
//                g.size.width = g.size.width*2;
//                g.size.height = g.size.height*2;
//                g.origin.x = g.origin.x - g.size.width;
//                g.origin.y = g.origin.y - g.size.height/2;
                
                
                if ((CGRectIntersectsRect([joerobot boundingBox],[[self getChildByTag:MonsterClass2+i]boundingBox]))){
                    if (hitmonster) {
                        [self monster2Eat:ccp([self getChildByTag:MonsterClass2+i].position.x, [self getChildByTag:MonsterClass2+i].position.y + [self getChildByTag:MonsterClass2+i].contentSize.height/1.7f)];
                        
                        if (!propelerFakeFix) {
                            
                            CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
                            [propeller runAction:[CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:[NSArray arrayWithObjects:/*[cache spriteFrameByName:@"hat3.png"],[cache spriteFrameByName:@"hat2.png"],*/[cache spriteFrameByName:@"hat4.png"], nil] /*delay:0.09f*/] restoreOriginalFrame:NO]];
                            propelerFakeFix = true;
                        }
                    }
                    //NSLog(@"JOE POS: %f   POS: %f  ROTATE: %f",joerobot.position.y, [self getChildByTag:MonsterClass2+i].position.y +[[self getChildByTag:MonsterClass2+i]boundingBox].size.height/1.7f,l.rotation);
                    if ((joerobot.position.y >= [self getChildByTag:MonsterClass2+i].position.y +[[self getChildByTag:MonsterClass2+i]boundingBox].size.height/1.7f) && l.rotation > 1.f) {
                        if (!eatFlag) {
                            eatFlag = true;
                            if (!blast) {
                                blast = true;
                            [self particles];
                            }
                            //joerobot.anchorPoint = ccp(1.f, 0.5f);
                            
                            hitmonster = true;
                            _body->SetLinearVelocity(b2Vec2(0,0));
                            _body->SetAngularVelocity(0);
                            [joerobot stopAllActions];
                            
                            [self stopActionByTag:0];
                            
                          //  [joerobot runAction:[CCMoveTo actionWithDuration:0.2f position:[self getChildByTag:MonsterClass2+i].position]];
                            joerobot.anchorPoint = ccp(0.2f,0.4f);
                            [self reorderChild:joerobot z:1];
                            [joerobot runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.1f],[CCSpawn actions:[CCFadeTo actionWithDuration:0.2f opacity:220],[CCScaleTo actionWithDuration:0.1f scaleX:(IS_IPAD ? 0.25f : 0.23f) scaleY:(IS_IPAD ? 0.33f : 0.28f)], nil], nil]];
                            
                            [[self getChildByTag:MonsterClass2+i] stopAllActions];
                            
                            [[self getChildByTag:MonsterClass2+i] runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.5f],[CCMoveBy actionWithDuration:15.2f position:ccp(0, -[self getChildByTag:MonsterClass2].contentSize.height*8)], nil]];
                            
                            
                            //[self stateGAMEOVER];
                            
                            [self endOfTheGAME:[NSNumber numberWithInt:2]];
                            
                            
                            
                        }
                    }
                    else{
                        
                        if (!eatFlag) {
                            if (!blast) {
                                blast = true;
                            [self particles];
                            }
                            
//
//                            _body->SetActive(NO);
//                            _body->GetWorld()->DestroyBody(_body);
//                            
//                            
//                            [self stopActionByTag:0];
//                            eatFlag = true;
//                            
//                            int heigth;
//                            if (IS_IPAD){heigth = 200;}else{heigth = 150;}
//                            
//                            id action = [CCEaseInOut actionWithAction:[CCJumpBy actionWithDuration:1.1f position:ccp(100, -kHeightScreen/1.2) height:heigth jumps:1] rate:2];
//                            
//                            //[[[[self getChildByTag:SPbatchNode2] getChildByTag:Zombie] getChildByTag:0]runAction:action];
//                            [joerobot runAction:[action copy]];
//                            
//                           // CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
//                           // [[[self getChildByTag:SPbatchNode2] getChildByTag:Zombie] runAction:[CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:[NSArray arrayWithObjects:[cache spriteFrameByName:@"death.png"], nil]] restoreOriginalFrame:NO]];
//                            
//                          
//                            
//                            //NSLog(@"222222222222");
//                            
//                            //joerobot.anchorPoint = ccp(0.5f, 0.5f);
//                            
//                            [joerobot runAction:[CCEaseInOut actionWithAction:[CCJumpBy actionWithDuration:1.4f position:ccp(-100, -kHeightScreen/1.2f) height:heigth jumps:1] rate:2]];
                        
                            [self stateGAMEOVER];
                            
                            [self endOfTheGAME:[NSNumber numberWithInt:2]];
                               
                            
                        }
                    }
                    //self.isTouchEnabled = NO;
                    self.isAccelerometerEnabled = NO;
                }
                if ((CGRectIntersectsRect([joerobot boundingBox],[[self getChildByTag:MonsterClass+i]boundingBox]))){
                    if (!eatFlag) {
                        eatFlag = true;
                        hitmonster = false;
                        if (!blast) {
                            blast = true;
                        [self particles];
                        }
                        [self stateGAMEOVER];
                        [self endOfTheGAME:[NSNumber numberWithInt:2]];
  
                    }
                    //self.isTouchEnabled = NO;
                    self.isAccelerometerEnabled = NO;
                }
            }
        }
    }
    
    // _body ->SetTransform(_body->GetPosition(), -_acceleration/PTM_RATIO*7);
    
    currentPos = 0;
    if (moveBack) {
        [self stopActionByTag:0];
        m_moveForward = true;
        currentPos = -self.position.x;
        
    }
    
    if (m_moveForward && moveForward && joerobot.position.x >= self.contentSize.width/2) {
        if (joerobot.position.x > -self.position.x + self.contentSize.width/2) {
        }
        [self addCCFallow];
        m_moveForward = false;
    }
    
    if (moveForward) {
        
        [self getChildByTag:bgLayerTag].position = ccp(-self.position.x/3.f,0);
        [self getChildByTag:bgLayerTag2].position = ccp(self.position.x*0.7, kHeightScreen/2);
        [self getChildByTag:bgLayerTag3].position = ccp(-self.position.x/7, kHeightScreen/2);
        [self getChildByTag:bgLayerTag4].position = ccp(-self.position.x/4, 0);
        
        wall_left_Body->SetTransform(b2Vec2(-self.position.x/PTM_RATIO - 5/PTM_RATIO,10/PTM_RATIO), 0);
        wall_right_Body->SetTransform(b2Vec2(-self.position.x/PTM_RATIO + self.contentSize.width + [[self getChildByTag:SPbatchNode2] getChildByTag:Zombie].contentSize.width/PTM_RATIO + 5/PTM_RATIO,10/PTM_RATIO), 0);
    }
    
    
    _world->Step(dt, 8, 1);
    
    for (b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData()!=NULL) {
            
            CCSprite *node = (CCSprite*)b->GetUserData();
            node.opacity = alpha;
            if ([node.parent.parent isKindOfClass:[Monsters_level9 class]]) {
                
            }
            else if ([node.parent.parent isKindOfClass:[Level9 class]])
            {
                node.position = ccp(b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
                node.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
            }
            //  NSLog(@"TAG : %i",node.parent.parent.tag);
        }
    }
    
    switch (m_state) {
        case lvl9_STATE_NORMAL:
            break;
        case lvl9_STATE_JUMP:{
            float a;
            if (IS_IPAD) {a = 6;}else{a = 4;}
            //_body->ApplyLinearImpulse(force, _body->GetPosition());
            _body->SetLinearVelocity(b2Vec2(_body->GetLinearVelocity().x, a));
            break;}
        default:
            break;
    }
    
    // NSLog(@"%f",_acceleration);
    
    // b2Vec2 currentVelocity = _body->GetLinearVelocity();
    // float32 dot;
    // int int_;
    // if (IS_IPAD) {dot = currentVelocity.x;int_ = 12;}else{dot = currentVelocity.x*1.5;int_ = 8;}
    
    //if (dot < int_ || _acceleration <= 0) {
    //    b2Vec2 force = b2Vec2(_acceleration/1.5,0);
    //_body->ApplyLinearImpulse(force, _body->GetPosition());
    // NSLog(@"%f",_acceleration);
//    float b;
//    if (IS_IPAD) {b = 25;}else{b = 12;}
//    
//    //  NSLog(@"%f",_acceleration*b);
//    _body->SetLinearVelocity(b2Vec2(_acceleration*b, _body->GetLinearVelocity().y));
    //}
    
    
    if (!L9_COLLIDERS) {
        if(!endFlag){
            std::vector<MyContactS>::iterator pos;
            for(pos = _contactListener->_contacts.begin();
                pos != _contactListener->_contacts.end(); ++pos) {
                
                MyContactS contact = *pos;
                
                for (b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
                    if (b->GetType() == b2_kinematicBody) {
                        for (b2Fixture *f = b->GetFixtureList(); f; f=f->GetNext()) {
                            
                            if (contact.fixtureB == f && !endFlag) {
                                endFlag = true;
                                eatFlag = true;
                                if (!blast) {
                                    blast = true;
                                [self particles];
                                }
                                [self stateGAMEOVER];
                                [self endOfTheGAME:[NSNumber numberWithInt:2]];
                                
                            }
                        }
                    }
                }
            }
        }
    }
    joerobot.position = ccp(_body->GetPosition().x*PTM_RATIO+(15*(kSCALEVALX)),
                            _body->GetPosition().y*PTM_RATIO+(35*(kSCALEVALY)));
    //    joerobot.position = [[self getChildByTag:SPbatchNode2] getChildByTag:Zombie].position;
    //    ;
    //}
}


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!pause) {
        
        UITouch* touch = [touches anyObject];
        CGPoint touchPos = [self convertTouchToNodeSpace:touch];
        
        //    CGRect f = [[self getChildByTag:brain1]boundingBox];
        //    f.size.width = f.size.width*2;
        //    f.size.height = f.size.height*2;
        //    f.origin.x = f.origin.x - f.size.width/3;
        //    f.origin.y = f.origin.y - f.size.height/3;
        
        
        if ((CGRectContainsPoint([[self getChildByTag:kBird]boundingBox], touchPos)) && !brainTouched && !kickAss)
        {
            brainTouched = true;
            
            [[self getChildByTag:kBird] runAction:[CCScaleTo actionWithDuration:0.2f scaleX:1.5f scaleY:1.f]];
            
            //[[self getChildByTag:brain1] runAction:[CCSequence actions:[CCJumpTo actionWithDuration:0.3f position:ccp([[self getChildByTag:SPbatchNode2] getChildByTag:Zombie].position.x+[[self getChildByTag:SPbatchNode2] getChildByTag:Zombie].contentSize.width/3, [[self getChildByTag:SPbatchNode2] getChildByTag:Zombie].position.y + [[self getChildByTag:SPbatchNode2] getChildByTag:Zombie].contentSize.height/3) height:100 jumps:1],[CCCallFuncO actionWithTarget:self selector:@selector(destroyBrains:) object:[NSNumber numberWithInt:0]], nil]];
            
            // [cfg makeBrainActionForNode:[self getChildByTag:brain1] fakeBrainsNode:nil direction:180 pixelsToMove:50 parent:self  removeBrainsAfter:YES makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
            [cfg makeBrainActionForNode:[self getChildByTag:brain1] fakeBrainsNode:nil direction:180 pixelsToMove:50 time:0.f parent:self removeBrainsAfter:YES makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
        }
        
        if (!eatFlag && !endFlag) {
            
            float a;
            float b;
            if (IS_IPAD) {a = 0.65f;b = 0.75f;}else{a = 0.5f;b = 0.6f;}
            m_state = lvl9_STATE_JUMP;
            //[joerobot runAction:[CCScaleTo actionWithDuration:0.2f scaleX:a scaleY:b]];
            
            if (!kickAss) {
                
            
                CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
                [propeller runAction:
                 [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:
                                                    [CCAnimation animationWithFrames:
                                                     [NSArray arrayWithObjects:
                                                      [cache spriteFrameByName:@"hat2.png"],[cache spriteFrameByName:@"hat3.png"],nil]delay:0.03f] restoreOriginalFrame:NO]]].tag = 999;
            }
            
            
            if (![self getActionByTag:828282]) {
                [self runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCCallBlock actionWithBlock:^{
                    [AUDIO playEffect:l15_fly];
                }],[CCDelayTime actionWithDuration:0.15f], nil]]].tag = 828282;
            }
            
        }
    }
}

-(void)fingerLost
{
    m_state = lvl9_STATE_NORMAL;
    
    if ([self getActionByTag:828282])
    {
        [self stopActionByTag:828282];
    }
    float a;
    if (IS_IPAD) {a = 0.65f;}else{a = 0.5f;}
    if (!eatFlag && !endFlag) {
        
        // [joerobot runAction:[CCScaleTo actionWithDuration:0.3f scaleX:a scaleY:a]];
    }
    [[self getChildByTag:kBird] runAction:[CCScaleTo actionWithDuration:0.2f scaleX:1.f scaleY:1.f]];
    
    [propeller stopActionByTag:999];
    
    if (!blast) {
    CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [propeller runAction:[CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:[NSArray arrayWithObjects:/*[cache spriteFrameByName:@"hat3.png"],[cache spriteFrameByName:@"hat2.png"],*/[cache spriteFrameByName:@"hat1.png"], nil] /*delay:0.09f*/] restoreOriginalFrame:NO]];
    }
    
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!pause) {
        [self fingerLost];
    }
}
-(void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!pause) {
        [self fingerLost];
    }
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
    b2Vec2 currentVelocity = _body->GetLinearVelocity();
    float32 dot = currentVelocity.x;

    
    _acceleration = acceleration.y*orient;
    
    
    float c = (IS_IPAD) ? 0.05f : 0.1f;
    
    if (_acceleration < -c)
    {
        [joerobot JOE_HANGING_LEFT];
    }
    else if (_acceleration > c)
    {
        [joerobot JOE_HANGING_RIGHT];
    }
    else
    {
        [[joerobot robot_] JOE_HANGING_DOWN_2];
    }

    
    float b;
    if (IS_IPAD) {b = 30;}else{b = 12;}
    
    _body->SetLinearVelocity(b2Vec2(_acceleration*b, _body->GetLinearVelocity().y));
    
    //NSLog(@"%f",_acceleration);
    
    if (dot >= 0) {
        moveForward = true;
        moveBack = false;
    }
    else if(dot < 0){
        moveForward = false;
        moveBack = true;
    }
}

-(void)BG_Layeradd
{
    CCSprite *BG = [[[CCSprite alloc] init] autorelease];
    BG.anchorPoint = ccp(0.5f, 0.5f);
    [self addChild:BG z:0 tag:bgLayerTag];
    
    CCSprite *BG_1 = [[[CCSprite alloc] init] autorelease];
    BG_1.anchorPoint = ccp(0.5f, 0.5f);
    BG_1.position = ccp(0, kHeightScreen/2);
    [self addChild:BG_1 z:9999 tag:bgLayerTag2];
    
    CCSprite *BG_2 = [[[CCSprite alloc] init] autorelease];
    BG_2.anchorPoint = ccp(0.5f, 0.5f);
    BG_2.position = ccp(0, kHeightScreen/2);
    [self addChild:BG_2 z:2 tag:bgLayerTag3];
    
    CCSprite *BG_3 = [[[CCSprite alloc] init] autorelease];
    BG_3.anchorPoint = ccp(0, 0);
    BG_3.position = ccp(0,0);
    [self addChild:BG_3 z:1 tag:bgLayerTag4];
    
}

-(void)callAnimation:(NSNumber*)num
{
    [(Monsters_level9*)[self getChildByTag:num.integerValue] animationOf2];
}
-(void)monster2Action:(NSNumber*)tag__
{
    float count = 6.35;
    if (tag__.integerValue == 50) {count = 4.5;}
    else if (tag__.integerValue == 52){count = 7;}
    id action = [CCMoveBy actionWithDuration:1.f position:ccp(0, [self getChildByTag:MonsterClass2].contentSize.height*count)];
    
    id action2 = [CCMoveBy actionWithDuration:2.5f position:ccp(0, -[self getChildByTag:MonsterClass2].contentSize.height*count)];
    
    [(Monsters_level9*)[self getChildByTag:tag__.integerValue]runAction:
     [CCRepeatForever actionWithAction:
      [CCSequence actions:[CCDelayTime actionWithDuration:0.1f],[CCSpawn actions:[CCCallBlock actionWithBlock:^{
         [AUDIO playEffect:l15_flower];
     }],[CCEaseInOut actionWithAction:action rate:10], nil]
       ,
       [CCDelayTime actionWithDuration:0.4f],
       [CCEaseInOut actionWithAction:action2 rate:3],
       [CCCallFuncO actionWithTarget:self selector:@selector(callAnimation:) object:tag__], nil]]];
}

-(void)monster1Action:(NSNumber*)tag__
{
    id jump = [CCJumpBy actionWithDuration:1.2f position:ccp([self getChildByTag:MonsterClass+tag__.integerValue].position.x, -[self getChildByTag:tag__.integerValue].contentSize.height*2.3) height:50 jumps:1];
    
    [(Monsters_level9*)[self getChildByTag:tag__.integerValue] runAction:
     [CCRepeatForever actionWithAction:
      [CCSequence actions:
       [CCSpawn actions:[CCCallBlock actionWithBlock:^{
          //[AUDIO playEffect:l15_bee];
      }],[CCScaleTo actionWithDuration:1.2f scaleX:0.8f scaleY:0.9f],
        [CCEaseInOut actionWithAction:jump rate:2],
        [CCRotateBy actionWithDuration:0.3f angle:-10], nil],
       [CCRotateBy actionWithDuration:0.2f angle:10],[CCDelayTime actionWithDuration:0.5f],
       [CCSpawn actions:[CCCallBlock actionWithBlock:^{
         // [AUDIO playEffect:l15_bee];
      }],[CCScaleTo actionWithDuration:1.2f scaleX:0.8f scaleY:0.8f],
        [CCEaseInOut actionWithAction:[jump reverse] rate:2],
        [CCRotateBy actionWithDuration:0.5f angle:10], nil],[CCRotateBy actionWithDuration:0.3f angle:-10],[CCDelayTime actionWithDuration:0.5f], nil]]];
}
-(void)getMonster2
{
    for (int i = 0; i < 3; i++) {
        [(Monsters_level9*)[self getChildByTag:MonsterClass2+i] setMonsterByNR:[NSNumber numberWithInt:2]  :_world];
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:arc4random()%5*0.75],[CCCallFuncO actionWithTarget:self selector:@selector(monster2Action:) object:[NSNumber numberWithInt:MonsterClass2+i]], nil]];
    }
}

-(void)getMonster1
{
    for (int i = 0; i < 3; i++) {
        [(Monsters_level9*)[self getChildByTag:MonsterClass+i] setMonsterByNR:[NSNumber numberWithInt:1]:_world];
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:arc4random()%7*0.75],[CCCallFuncO actionWithTarget:self selector:@selector(monster1Action:) object:[NSNumber numberWithInt:MonsterClass+i]], nil]];
    }
}

-(void)addMonster2
{
    CGRect rect;
    // FLOWER
    for (int i = 0; i<3; i++) {
        if (IS_IPAD) {rect = CGRectMake(0,0,90,350);}else{rect = CGRectMake(0,0,40,165);}
        Monsters_level9 *monster = [[[Monsters_level9 alloc]initWithRect:rect] autorelease];
        monster.scale = 0.8f;
        
        
        switch (i) {
            case 0:monster.position = ccp([spriteBatchNode2 getChildByTag:1].position.x+[spriteBatchNode2 getChildByTag:1].contentSize.width/2.5, -monster.contentSize.height*4);
                // [cfg addTEMPBGCOLOR:monster anchor:monster.anchorPoint color:ccBLUE];
                break;
            case 1:monster.position = ccp([spriteBatchNode2 getChildByTag:3].position.x+[spriteBatchNode2 getChildByTag:3].contentSize.width/2.6, -monster.contentSize.height*6);
                 //[cfg addTEMPBGCOLOR:monster anchor:monster.anchorPoint color:ccRED];
                break;
            case 2:monster.position = ccp([spriteBatchNode2 getChildByTag:5].position.x + [spriteBatchNode2 getChildByTag:5].contentSize.width/2.7, -monster.contentSize.height*7);
                 //[cfg addTEMPBGCOLOR:monster anchor:monster.anchorPoint color:ccGREEN];break;
            default:break;
        }
        [self addChild:monster z:2 tag:MonsterClass2+i];
    }
}


-(void)addMonster1
{
    CGRect rect;
    // BEE
    for (int i = 0; i<3; i++) {
        if (IS_IPAD) {rect = CGRectMake(0,0,130,110);}else{rect = CGRectMake(0,0,55,45);}
        Monsters_level9 *monster = [[[Monsters_level9 alloc]initWithRect:rect] autorelease];
        monster.scale = 0.8f;
       // [cfg addTEMPBGCOLOR:monster anchor:monster.anchorPoint color:ccRED];
        switch (i) {
            case 0:monster.position =  ccp([spriteBatchNode2 getChildByTag:11].position.x + [spriteBatchNode2 getChildByTag:11].contentSize.width, kHeightScreen/1.2); break;
            case 1:monster.position = ccp([spriteBatchNode2 getChildByTag:13].position.x + [spriteBatchNode2 getChildByTag:13].contentSize.width, kHeightScreen/1.2); break;
            case 2:monster.position = ccp([spriteBatchNode2 getChildByTag:15].position.x + [spriteBatchNode2 getChildByTag:15].contentSize.width, kHeightScreen/1.2); break;
            default:break;
        }
        
        [self addChild:monster z:999 tag:MonsterClass+i];
    }
}

-(void)createTheJOE
{
    joerobot = [[[JoeZombieController alloc]initWitPos:ccp(0, 0) size:CGSizeMake(20,20) sender:self]autorelease];
    [self addChild:joerobot z:10];
    joerobot.scale = IS_IPAD ? 0.40f : 0.35f;
    joerobot.opacity = alpha;
    joerobot.anchorPoint = ccp(0.4f,IS_IPAD ? 0.45f  : 0.5f);
    CGSize s;
    if (IS_IPAD) {s = CGSizeMake(200, 225);}else{s = CGSizeMake(90, 100);}
    
    [joerobot ACTION_SetContentSize:s];
    
    [[joerobot robot_]JOE_HANGING_DOWN_2];
    [[joerobot robot_]makeOpacityForPart:9 opacity:0];
    [[joerobot robot_]makeOpacityForPart:12 opacity:0];
    
    [[joerobot robot_] reorderChild:[[joerobot robot_]getChildByTag:12] z:100];
    
    // [self getChildByTag:SPbatchNode2];
    propeller = [CCSprite spriteWithSpriteFrameName:@"hat1.png"];
    propeller.scale = 1.4f;
    
    CCSprite *cap = [CCSprite spriteWithSpriteFrameName:@"hat0.png"];
    cap.scale = 1.6f;
    cap.rotation = -10;
    
    CCSprite *capRobot = (CCSprite*)[[joerobot robot_]getChildByTag:12];
    
    [[[joerobot robot_]getChildByTag:12]addChild:cap];
    [[[joerobot robot_]getChildByTag:12]addChild:propeller];
    
    cap.position = ccpAdd(cap.position,
                          ccp(capRobot.boundingBox.size.width*0.50f,
                              capRobot.boundingBox.size.height*0.60f));
    
    propeller.position = ccpAdd(propeller.position,
                                ccp(capRobot.boundingBox.size.width*0.45f,
                                    capRobot.boundingBox.size.height*1.55f));
    
    
  //  [joerobot showMyBox];
//    [[joerobot robot_]ACTION_SetContentSize:CGSizeMake(200, 200)];
//    [[joerobot robot_]ACTION_ShowContentSize];
 //   [[joerobot robot_]makeOpacityOfAllParts:alpha];

    
    
    
    /*
     
     CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"joefly.png"];
     sprite.position = ccp(0, 0);
     sprite.anchorPoint = ccp(0, 0);
     sprite.opacity = 255;
     if (IS_IPAD) {sprite.scale = 0.65f;}else{sprite.scale = 0.5f;}
     
     
     
     [[self getChildByTag:SPbatchNode2] addChild:sprite z:1 tag:Zombie];
     
     for (int i = 0; i<2; i++) {
     CCSprite *sprite2 = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"hat%i.png",i]];
     switch (i) {
     case 0: sprite2.anchorPoint = ccp(0, 0);sprite2.position = ccp(sprite.position.x+sprite2.contentSize.width/3, sprite.contentSize.height-sprite2.contentSize.height/1.2);break;
     case 1:sprite2.anchorPoint = ccp(0.5f, 0.5f);sprite2.position = ccp(sprite.position.x+sprite.contentSize.width/1.32, sprite.contentSize.height+sprite2.contentSize.height/3);break;
     default:break;
     }
     [joerobotaddChild:sprite2 z:1 tag:i];
     
     }
     */
    
    [[GB2ShapeCache sharedShapeCache] addShapesWithFile:[NSString stringWithFormat:@"PE_Level9%@.plist",kDevice]];
    
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;
    ballBodyDef.position.Set(kWidthScreen/10/PTM_RATIO, kHeightScreen/5/PTM_RATIO);
    ballBodyDef.userData = nil;
    _body = _world->CreateBody(&ballBodyDef);
    _body->SetFixedRotation(true);
    
    [[GB2ShapeCache sharedShapeCache]addFixturesToBody:_body forShapeName:@"joefly"];
}

-(void)birdFly
{
    //[[self getChildByTag:kBird] runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCMoveBy actionWithDuration:0.5f position:ccp(0,-[self getChildByTag:kBird].contentSize.height)],[CCMoveBy actionWithDuration:0.5f position:ccp(0,[self getChildByTag:kBird].contentSize.height)], nil]]];
    
    [[self getChildByTag:kBird] runAction:[CCMoveTo actionWithDuration:50 position:ccp(-[self getChildByTag:kBird].contentSize.width, kHeightScreen/2)]];
    
    
}

-(void)createBird
{
    Bird *bird = [[[Bird alloc]initWithRect:CGRectMake(0, 0, 50, 50)] autorelease];
    bird.position = ccp(kWidthScreen*10, kHeightScreen/2);
    [self addChild:bird z:5 tag:kBird];
    [self birdFly];
}

-(void)addBrains
{
    CGRect rect;
    if (IS_IPAD) {rect = CGRectMake(0, 0, 100, 100);}else {rect = CGRectMake(0, 0, 50, 50);}
    
    BrainsBonus * BRAINS = [[[BrainsBonus alloc] initWithRect:CGRectMake(0, 0, rect.size.width, rect.size.height)] autorelease];
    BRAINS.position = ccp(-1000, -1000);
    BRAINS.rotation = -20;
    
    [self addChild:BRAINS z:4 tag:brain1];
    
    
    [_hud preloadBlast_self:self brainNr:2 parent:self];
    
    [_hud BRAIN_:TAG_BRAIN_1 position:ccp(-1000, -1000) parent:self];
    
    [_hud BRAIN_:TAG_BRAIN_1 zOrder:1 parent:self];
    
    [_hud BRAIN_:TAG_BRAIN_2 position:ccp(-1000, -1000) parent:self];
    
    [_hud BRAIN_:TAG_BRAIN_2 zOrder:4 parent:self];
    
    
    
    [[self getChildByTag:brain1+0] runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.25f scaleX:0.9f scaleY:1.3f],[CCScaleTo actionWithDuration:0.45f scaleX:1.f scaleY:1.f], nil]]];
}

-(void)addFinishLine{
    
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"finish_line.png"];
    sprite.anchorPoint = ccp(0.5f, 0.5f);
    sprite.position = ccp(kWidthScreen*20 - sprite.contentSize.width*1.2, kHeightScreen/2);
    [self addChild:sprite z:1 tag:finishLine];
    
}

-(void)addBirdsInfo
{
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"bird_table.png"];
    sprite.anchorPoint = ccp(0.5f, 0);
    sprite.position = ccp(kWidthScreen*21, kHeightScreen/2);
    int fontSize;
    
    if (IS_IPAD) {fontSize = 36;}else {fontSize = 17;}
    
    // CCLabelTTF *label = [[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"Level"] dimensions:
    //  alignment:UITextAlignmentCenter fontName:@"Arial" fontSize:20] autorelease];
    label = [CCLabelTTF labelWithString:@"25% Done!" fontName:@"StartlingFont" fontSize:fontSize];
    label.position = ccp(label.contentSize.width/1.35, label.contentSize.height*3.2);
    label.color = ccc3(37,41,20);
    
    [self addChild:sprite z:3 tag:birdInfo];
    [[self getChildByTag:birdInfo] addChild:label z:1 tag:1];
    id action = [CCRotateBy actionWithDuration:0.5f angle:10];
    
    [[self getChildByTag:birdInfo] runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[ CCEaseOut actionWithAction:action rate:2],[action reverse],[action reverse],[ CCEaseIn actionWithAction:action rate:2], nil]]];
    
}

-(BOOL)isRetina{
    
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && [[UIScreen mainScreen] scale] == 2.0f);
    
}


//88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
//888888888888888888888888888888888888   FUCking  HARDcode    88888888888888888888888888888888888888888
//88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888


-(void)update:(ccTime *)dt
{
    //   if (!stopGame) {
    //    if (brainTouched) {
    //        brainTouched = false;
    //
    //    }
    
    pause = NO;
    
    
    if ((-self.position.x >= kWidthScreen*11) && !brainFlag) {
        [self getChildByTag:TAG_BRAIN_1].position = ccp([spriteBatchNode2 getChildByTag:14].position.x+[spriteBatchNode2 getChildByTag:14].contentSize.width, kHeightScreen/1.05);
        brainFlag = true;
    }
    if ((-self.position.x >= kWidthScreen*18) && !brainFlag2) {
        [self getChildByTag:TAG_BRAIN_2].position = ccp([self getChildByTag:finishLine].position.x, kHeightScreen/1.25);
        brainFlag2 = true;
    }
    
    ///////////////////////////////////////////// BRAINS ///////////////////////////////////////////
    if (!brainTouched) {
        
        [self getChildByTag:brain1].position = ccp([self getChildByTag:kBird].position.x + [self getChildByTag:brain1].contentSize.width/2.7,[self getChildByTag:kBird].position.y + -[self getChildByTag:brain1].contentSize.height/6);
    }
    
    /////////////////////////////////////////// BACKGROUND //////////////////////////////////////////
    
    if (-self.position.x + self.contentSize.width >= [[self getChildByTag:bgLayerTag] getChildByTag:BG2].position.x + [[[self getChildByTag:bgLayerTag] getChildByTag:BG2] boundingBox].size.width/2-self.position.x/3.f) {
        
        [[self getChildByTag:bgLayerTag] getChildByTag:22].position = ccp([[self getChildByTag:bgLayerTag] getChildByTag:BG2].position.x+[[[self getChildByTag:bgLayerTag] getChildByTag:BG2] boundingBox].size.width, [[self getChildByTag:bgLayerTag] getChildByTag:BG2].position.y);
    }
    
    if (-self.position.x + self.contentSize.width >= [[self getChildByTag:bgLayerTag] getChildByTag:BG3].position.x + [[[self getChildByTag:bgLayerTag] getChildByTag:BG3] boundingBox].size.width/2-self.position.x/3.f) {
        
        [[self getChildByTag:bgLayerTag] getChildByTag:BG1].position = ccp([[self getChildByTag:bgLayerTag] getChildByTag:BG3].position.x+[[[self getChildByTag:bgLayerTag] getChildByTag:BG3] boundingBox].size.width, [[self getChildByTag:bgLayerTag] getChildByTag:BG3].position.y);
    }
    
    if (-self.position.x + self.contentSize.width >=[[self getChildByTag:bgLayerTag] getChildByTag:BG1].position.x + [[[self getChildByTag:bgLayerTag] getChildByTag:BG1] boundingBox].size.width/2-self.position.x/3.f) {
        
        [[self getChildByTag:bgLayerTag] getChildByTag:BG2].position = ccp([[self getChildByTag:bgLayerTag] getChildByTag:BG1].position.x+[[[self getChildByTag:bgLayerTag] getChildByTag:BG1] boundingBox].size.width, [[self getChildByTag:bgLayerTag] getChildByTag:BG1].position.y);
    }
    
    //////////////////////////////////////////// BIRD INFO ////////////////////////////////////////////
    
    //// 25%
    if ((-self.position.x + self.contentSize.width*1.5f >= kWidthScreen*3.5)&&(-self.position.x < kWidthScreen*4.1)){
        label = [CCLabelTTF labelWithString:@"50% Done!" fontName:@"StartlingFont" fontSize:36];
        
        [self getChildByTag:birdInfo].position = ccp([spriteBatchNode2 getChildByTag:2].position.x+[spriteBatchNode2 getChildByTag:2].contentSize.width/1.7,[spriteBatchNode2 getChildByTag:2].position.y+[spriteBatchNode2 getChildByTag:2].contentSize.height/1.6);
    }
    else
    {
        [self getChildByTag:birdInfo].position = ccp(kWidthScreen*21,0);
        
    }
    
    
    //// 50%
    if ((-self.position.x + self.contentSize.width >= kWidthScreen*8.8)&&(-self.position.x < kWidthScreen*10)){
        [(CCLabelTTF*)[[self getChildByTag:birdInfo] getChildByTag:1] setString:@"50% Done!"];
        
        [self getChildByTag:birdInfo].position = ccp([spriteBatchNode2 getChildByTag:2].position.x+[spriteBatchNode2 getChildByTag:2].contentSize.width/1.7,[spriteBatchNode2 getChildByTag:2].position.y+[spriteBatchNode2 getChildByTag:2].contentSize.height/1.6);
    }
    
    
    //// 75%
    if ((-self.position.x + self.contentSize.width >= kWidthScreen*13.8)&&(-self.position.x < kWidthScreen*15)){
        [(CCLabelTTF*)[[self getChildByTag:birdInfo] getChildByTag:1] setString:@"75% Done!"];
        
        [self getChildByTag:birdInfo].position = ccp([spriteBatchNode2 getChildByTag:2].position.x+[spriteBatchNode2 getChildByTag:2].contentSize.width/1.7,[spriteBatchNode2 getChildByTag:2].position.y+[spriteBatchNode2 getChildByTag:2].contentSize.height/1.6);
    }
    
    //// 100%
    if ((-self.position.x + self.contentSize.width >= kWidthScreen*18.8)&&(-self.position.x < kWidthScreen*21)){
        [(CCLabelTTF*)[[self getChildByTag:birdInfo] getChildByTag:1] setString:@"FINISH!"];
        int a;
        if (IS_IPAD) {a = 3;}else if (IS_IPHONE_5){a = 5;}else if (IS_IPHONE){a = 3;}
        [self getChildByTag:birdInfo].position = ccp([spriteBatchNode2 getChildByTag:a].position.x+[spriteBatchNode2 getChildByTag:a].contentSize.width,-[self getChildByTag:birdInfo].contentSize.height/10);
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    
    if (-self.position.x > [self getChildByTag:birdInfo].position.x+[self getChildByTag:birdInfo].contentSize.width) {
        
    }
    
    
    if ((-self.position.x > [self getChildByTag:kBird].position.x) && !brainTouched) {
        
    }
    
    //////////////////////////////////////////// LEVEL IS DONE!   ///////////////////////////////////////
    
    
    if (joerobot.position.x + joerobot.contentSize.width/2 > [self getChildByTag:finishLine].position.x + [self getChildByTag:finishLine].contentSize.width/2)
    {
        if (!endFlag) {
            //_body->SetActive(NO);
            
            //b2Fixture *a = _body->GetFixtureList();
            //a->SetSensor(true);
            
            
            //            b2Filter filter = a->GetFilterData();
            //            filter.maskBits = 0;
            //            filter.categoryBits = 5;
            //            a->SetFilterData(filter);
            
            [self endOfTheGAME:[NSNumber numberWithInt:1]];
            endFlag = true;
        }
    }
    
    
    
    /////////////////////////////////////////// ROCK DOWN POSITION /////////////////////////////////
    if (moveForward) {
        //0
        //////////********************** DAWN **********************///////////
        if (joerobot.position.x >= [spriteBatchNode2 getChildByTag:0].position.x +[[spriteBatchNode2 getChildByTag:0] boundingBox].size.width/2) {
            [self repositionBodyByTag:3 :b2Vec2([spriteBatchNode2 getChildByTag:2].position.x/PTM_RATIO + [spriteBatchNode2 getChildByTag:2].contentSize.width/PTM_RATIO, [spriteBatchNode2 getChildByTag:0].position.y/PTM_RATIO)];
        }
        //1
        if (joerobot.position.x >= [spriteBatchNode2 getChildByTag:1].position.x +[[spriteBatchNode2 getChildByTag:1] boundingBox].size.width/2) {
            [self repositionBodyByTag:4 :b2Vec2([spriteBatchNode2 getChildByTag:3].position.x/PTM_RATIO + [spriteBatchNode2 getChildByTag:3].contentSize.width/PTM_RATIO, [spriteBatchNode2 getChildByTag:1].position.y/PTM_RATIO)];
        }
        //2
        if (joerobot.position.x >= [spriteBatchNode2 getChildByTag:2].position.x +[[spriteBatchNode2 getChildByTag:2] boundingBox].size.width/2) {
            [self repositionBodyByTag:5 :b2Vec2([spriteBatchNode2 getChildByTag:4].position.x/PTM_RATIO + [spriteBatchNode2 getChildByTag:4].contentSize.width/PTM_RATIO, [spriteBatchNode2 getChildByTag:2].position.y/PTM_RATIO)];
        }
        //3
        if (joerobot.position.x >= [spriteBatchNode2 getChildByTag:3].position.x +[[spriteBatchNode2 getChildByTag:3] boundingBox].size.width/2) {
            [self repositionBodyByTag:0 :b2Vec2([spriteBatchNode2 getChildByTag:5].position.x/PTM_RATIO + [spriteBatchNode2 getChildByTag:5].contentSize.width/PTM_RATIO, [spriteBatchNode2 getChildByTag:3].position.y/PTM_RATIO)];
        }
        //4
        if (joerobot.position.x >= [spriteBatchNode2 getChildByTag:4].position.x +[[spriteBatchNode2 getChildByTag:4] boundingBox].size.width/2) {
            [self repositionBodyByTag:1 :b2Vec2([spriteBatchNode2 getChildByTag:0].position.x/PTM_RATIO + [spriteBatchNode2 getChildByTag:0].contentSize.width/PTM_RATIO, [spriteBatchNode2 getChildByTag:4].position.y/PTM_RATIO)];
        }
        //5
        if (joerobot.position.x >= [spriteBatchNode2 getChildByTag:5].position.x +[[spriteBatchNode2 getChildByTag:5] boundingBox].size.width/2) {
            [self repositionBodyByTag:2 :b2Vec2([spriteBatchNode2 getChildByTag:1].position.x/PTM_RATIO + [spriteBatchNode2 getChildByTag:1].contentSize.width/PTM_RATIO, [spriteBatchNode2 getChildByTag:5].position.y/PTM_RATIO)];
        }
        
        ////////////////////////////////////////////// ROCK UP POSITION ////////////////////////////////////
        
        //////////********************** UP **********************///////////
        
        if (joerobot.position.x >= [spriteBatchNode2 getChildByTag:10].position.x +[[spriteBatchNode2 getChildByTag:10] boundingBox].size.width/2) {
            [self repositionBodyByTag:13 :b2Vec2([spriteBatchNode2 getChildByTag:12].position.x/PTM_RATIO + [spriteBatchNode2 getChildByTag:12].contentSize.width/PTM_RATIO, [spriteBatchNode2 getChildByTag:10].position.y/PTM_RATIO)];
        }
        
        if (joerobot.position.x >= [spriteBatchNode2 getChildByTag:11].position.x +[[spriteBatchNode2 getChildByTag:11] boundingBox].size.width/2) {
            [self repositionBodyByTag:14 :b2Vec2([spriteBatchNode2 getChildByTag:13].position.x/PTM_RATIO + [spriteBatchNode2 getChildByTag:13].contentSize.width/PTM_RATIO, [spriteBatchNode2 getChildByTag:11].position.y/PTM_RATIO)];
        }
        
        if (joerobot.position.x >= [spriteBatchNode2 getChildByTag:12].position.x +[[spriteBatchNode2 getChildByTag:12] boundingBox].size.width/2) {
            [self repositionBodyByTag:15 :b2Vec2([spriteBatchNode2 getChildByTag:14].position.x/PTM_RATIO + [spriteBatchNode2 getChildByTag:14].contentSize.width/PTM_RATIO, [spriteBatchNode2 getChildByTag:12].position.y/PTM_RATIO)];
        }
        
        if (joerobot.position.x >= [spriteBatchNode2 getChildByTag:13].position.x +[[spriteBatchNode2 getChildByTag:13] boundingBox].size.width/2) {
            [self repositionBodyByTag:10 :b2Vec2([spriteBatchNode2 getChildByTag:15].position.x/PTM_RATIO + [spriteBatchNode2 getChildByTag:15].contentSize.width/PTM_RATIO, [spriteBatchNode2 getChildByTag:13].position.y/PTM_RATIO)];
        }
        
        if (joerobot.position.x >= [spriteBatchNode2 getChildByTag:14].position.x +[[spriteBatchNode2 getChildByTag:14] boundingBox].size.width/2) {
            [self repositionBodyByTag:11 :b2Vec2([spriteBatchNode2 getChildByTag:10].position.x/PTM_RATIO + [spriteBatchNode2 getChildByTag:10].contentSize.width/PTM_RATIO, [spriteBatchNode2 getChildByTag:14].position.y/PTM_RATIO)];
        }
        
        if (joerobot.position.x >= [spriteBatchNode2 getChildByTag:15].position.x +[[spriteBatchNode2 getChildByTag:15] boundingBox].size.width/2) {
            [self repositionBodyByTag:12 :b2Vec2([spriteBatchNode2 getChildByTag:11].position.x/PTM_RATIO + [spriteBatchNode2 getChildByTag:11].contentSize.width/PTM_RATIO, [spriteBatchNode2 getChildByTag:15].position.y/PTM_RATIO)];
        }
        
        ///////////////////////////////////////// MONSTER 1 POSITION ///////////////////////////////////////////
        //  a
        //********************************* MONSTERS1 ************************************//
        //  if (-self.position.x+self.contentSize.width >= kWidthScreen*2) {
        float a;
        if (IS_IPAD) {a = 1.f;}else if (IS_IPHONE_5){a = 2;}else if (IS_IPHONE){a = 1;}
        
        if (-self.position.x + self.contentSize.width*a >= [self getChildByTag:MonsterClass+0].position.x) {
            
            [self getChildByTag:MonsterClass+2].position = ccp([spriteBatchNode2 getChildByTag:15].position.x + [spriteBatchNode2 getChildByTag:15].contentSize.width, [self getChildByTag:MonsterClass+2].position.y);
        }
        if (-self.position.x + self.contentSize.width*a >= [self getChildByTag:MonsterClass+1].position.x) {
            
            [self getChildByTag:MonsterClass+0].position = ccp([spriteBatchNode2 getChildByTag:11].position.x + [spriteBatchNode2 getChildByTag:11].contentSize.width, [self getChildByTag:MonsterClass+0].position.y);
        }
        if (-self.position.x + self.contentSize.width*a >= [self getChildByTag:MonsterClass+2].position.x) {
            
            [self getChildByTag:MonsterClass+1].position = ccp([spriteBatchNode2 getChildByTag:13].position.x + [spriteBatchNode2 getChildByTag:13].contentSize.width, [self getChildByTag:MonsterClass+1].position.y);
        }
        // }
        
        //////////////////////////////////////////// MONSTER 2 POSITION ///////////////////////////////////////
        
        //********************************* MONSTERS2 ************************************//
        
        if (-self.position.x + self.contentSize.width/2 >= [self getChildByTag:MonsterClass2+0].position.x) {
            
            [self getChildByTag:MonsterClass2+2].position = ccp([spriteBatchNode2 getChildByTag:5].position.x + [spriteBatchNode2 getChildByTag:5].contentSize.width/2.7, [self getChildByTag:MonsterClass2+2].position.y);
            
        }
        if (-self.position.x + self.contentSize.width/2 >= [self getChildByTag:MonsterClass2+1].position.x) {
            
            [self getChildByTag:MonsterClass2+0].position = ccp([spriteBatchNode2 getChildByTag:1].position.x+[spriteBatchNode2 getChildByTag:1].contentSize.width/2.5, [self getChildByTag:MonsterClass2+0].position.y);
            
        }
        if (-self.position.x + self.contentSize.width/2 >= [self getChildByTag:MonsterClass2+2].position.x) {
            
            [self getChildByTag:MonsterClass2+1].position = ccp([spriteBatchNode2 getChildByTag:3].position.x+[spriteBatchNode2 getChildByTag:3].contentSize.width/2.6, [self getChildByTag:MonsterClass2+1].position.y);
            
        }
        
        //}
    }
    
    ////////////////////////////////////////// COLONOS FRONT POSITIN //////////////////////////////////////
    
    if (-self.position.x > [[self getChildByTag:bgLayerTag2]getChildByTag:0].position.x + self.position.x*0.7) {
        
        [[self getChildByTag:bgLayerTag2]getChildByTag:2].position = ccp([[self getChildByTag:bgLayerTag2] getChildByTag:1].position.x+kWidthScreen*1.7f,[[self getChildByTag:bgLayerTag2]getChildByTag:2].position.y);
        // NSLog(@"Pos 222 : %g %g",[[self getChildByTag:bgLayerTag2]getChildByTag:2].position.x,[[self getChildByTag:bgLayerTag2]getChildByTag:2].position.y);
    }
    if (-self.position.x > [[self getChildByTag:bgLayerTag2]getChildByTag:1].position.x + self.position.x*0.7) {
        
        [[self getChildByTag:bgLayerTag2]getChildByTag:0].position = ccp([[self getChildByTag:bgLayerTag2] getChildByTag:2].position.x+kWidthScreen*2.f,[[self getChildByTag:bgLayerTag2]getChildByTag:0].position.y);
        //NSLog(@"Pos 000 : %g %g",[[self getChildByTag:bgLayerTag2]getChildByTag:0].position.x,[[self getChildByTag:bgLayerTag2]getChildByTag:0].position.y);
    }
    
    if (-self.position.x > [[self getChildByTag:bgLayerTag2]getChildByTag:2].position.x + self.position.x*0.7) {
        
        [[self getChildByTag:bgLayerTag2]getChildByTag:1].position = ccp([[self getChildByTag:bgLayerTag2] getChildByTag:0].position.x+kWidthScreen*2.5f,[[self getChildByTag:bgLayerTag2]getChildByTag:1].position.y);
        //NSLog(@"Pos 111 : %g %g",[[self getChildByTag:bgLayerTag2]getChildByTag:1].position.x,[[self getChildByTag:bgLayerTag2]getChildByTag:1].position.y);
    }
    
    ///////////////////////////////////////////// COLONOS BACK POSITIN //////////////////////////////////
    
    if (-self.position.x > [[self getChildByTag:bgLayerTag3]getChildByTag:0].position.x -self.position.x/7) {
        
        [[self getChildByTag:bgLayerTag3]getChildByTag:2].position = ccp([[self getChildByTag:bgLayerTag3] getChildByTag:1].position.x+kWidthScreen*1.7f,[[self getChildByTag:bgLayerTag3]getChildByTag:2].position.y);
        // NSLog(@"Pos 222 : %g %g",[[self getChildByTag:bgLayerTag2]getChildByTag:2].position.x,[[self getChildByTag:bgLayerTag2]getChildByTag:2].position.y);
    }
    if (-self.position.x > [[self getChildByTag:bgLayerTag3]getChildByTag:1].position.x -self.position.x/7) {
        
        [[self getChildByTag:bgLayerTag3]getChildByTag:0].position = ccp([[self getChildByTag:bgLayerTag3] getChildByTag:2].position.x+kWidthScreen*2.f,[[self getChildByTag:bgLayerTag3]getChildByTag:0].position.y);
        //NSLog(@"Pos 000 : %g %g",[[self getChildByTag:bgLayerTag2]getChildByTag:0].position.x,[[self getChildByTag:bgLayerTag2]getChildByTag:0].position.y);
    }
    
    if (-self.position.x > [[self getChildByTag:bgLayerTag3]getChildByTag:2].position.x -self.position.x/7) {
        
        [[self getChildByTag:bgLayerTag3]getChildByTag:1].position = ccp([[self getChildByTag:bgLayerTag3] getChildByTag:0].position.x+kWidthScreen*2.5f,[[self getChildByTag:bgLayerTag3]getChildByTag:1].position.y);
        //NSLog(@"Pos 111 : %g %g",[[self getChildByTag:bgLayerTag2]getChildByTag:1].position.x,[[self getChildByTag:bgLayerTag2]getChildByTag:1].position.y);
    }
    
    //////////////////////////////////////////// BACKGROUND ROCKS /////////////////////////////////////
    
    if (-self.position.x > [[self getChildByTag:bgLayerTag4]getChildByTag:0].position.x -self.position.x/4) {
        
        [[self getChildByTag:bgLayerTag4]getChildByTag:3].position = ccp([[self getChildByTag:bgLayerTag4] getChildByTag:2].position.x+kWidthScreen*0.5f,[[self getChildByTag:bgLayerTag4]getChildByTag:3].position.y);
        
    }
    if (-self.position.x > [[self getChildByTag:bgLayerTag4]getChildByTag:1].position.x -self.position.x/4) {
        
        [[self getChildByTag:bgLayerTag4]getChildByTag:4].position = ccp([[self getChildByTag:bgLayerTag4] getChildByTag:3].position.x+kWidthScreen*0.7f,[[self getChildByTag:bgLayerTag4]getChildByTag:4].position.y);
        
    }
    
    if (-self.position.x > [[self getChildByTag:bgLayerTag4]getChildByTag:2].position.x -self.position.x/4) {
        
        [[self getChildByTag:bgLayerTag4]getChildByTag:5].position = ccp([[self getChildByTag:bgLayerTag4] getChildByTag:4].position.x+kWidthScreen*0.8f,[[self getChildByTag:bgLayerTag4]getChildByTag:5].position.y);
    }
    if (-self.position.x > [[self getChildByTag:bgLayerTag4]getChildByTag:3].position.x -self.position.x/4) {
        
        [[self getChildByTag:bgLayerTag4]getChildByTag:0].position = ccp([[self getChildByTag:bgLayerTag4] getChildByTag:5].position.x+kWidthScreen*0.4f,[[self getChildByTag:bgLayerTag4]getChildByTag:0].position.y);
        
    }
    if (-self.position.x > [[self getChildByTag:bgLayerTag4]getChildByTag:4].position.x -self.position.x/4) {
        
        [[self getChildByTag:bgLayerTag4]getChildByTag:1].position = ccp([[self getChildByTag:bgLayerTag4] getChildByTag:0].position.x+kWidthScreen*0.7f,[[self getChildByTag:bgLayerTag4]getChildByTag:1].position.y);
        
    }
    
    if (-self.position.x > [[self getChildByTag:bgLayerTag4]getChildByTag:5].position.x -self.position.x/4) {
        
        [[self getChildByTag:bgLayerTag4]getChildByTag:2].position = ccp([[self getChildByTag:bgLayerTag4] getChildByTag:1].position.x+kWidthScreen*1.f,[[self getChildByTag:bgLayerTag4]getChildByTag:2].position.y);
        
    }
    
    //}
    
}

//88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
//888888888888888888888888888888888888   FUCking  HARDcode END   88888888888888888888888888888888888888
//88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888



-(void)GAME_RESUME{
    
    [self resumeSchedulerAndActions];
    pause = false;
     self.isAccelerometerEnabled = YES;
    
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
    self.isAccelerometerEnabled = NO;
    
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

- (id)initWithHUD:(InGameButtons *)hud
{
	if( (self=[super init])) {
        _hud = hud;
        
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) {orient = 1;}else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight){orient = -1;}
        
        //        self.motionManager = [[[CMMotionManager alloc]init]autorelease];
        //        motionManager.deviceMotionUpdateInterval = 1.0/60.0;
        //        if(motionManager.isDeviceMotionAvailable)
        //            [motionManager startDeviceMotionUpdates];
        
        screenCount = 1;
        m_moveForward = false;
        endFlag = false;
        eatFlag = false;
        brainTouched = false;
        brainFlag = false;
        brainFlag2 = false;
        kickAss = false;
        b_brain1 = false;
        b_brain2 = false;
        b_brain3 = false;
        hitmonster = false;
        //stopGame = false;
		// enable touches
		self.isTouchEnabled = YES;
        self.isAccelerometerEnabled = YES;
        
        
        [self BG_Layeradd];
        
        [self backgroundAdd];
        
        //Create world
        b2Vec2 gravity;
        if (IS_IPAD) {gravity = b2Vec2(0.0f, -12.0f);}else{gravity = b2Vec2(0.0f, -10.0f);}
        
        
        _world = new b2World(gravity);
        
        [self createTheJOE];
        [self addRocksDown];
        [self addRocksUp];
        [self addMonster1];
        [self addMonster2];
        [self getMonster1];
        [self getMonster2];
        
        //        int32 count = 2;
        //        b2Vec2 vecb2[3];
        //        vecb2[0].Set(0, -1.0);
        //        vecb2[1].Set(-1.0, 10.0);
        //        vecb2[2].Set(10.0, 10.0);
        //        vecb2[3].Set(-1.0, 10.0);
        
        
        [self addRoomWalls];
        [self addBrains];
        [self schedule:@selector(tick:)];
        [self scheduleUpdate];
        [self addCCFallow];
        [self createBird];
        [self addFinishLine];
        [self addBirdsInfo];
        
        b2Fixture *a = _body->GetFixtureList();
        a->SetSensor(true);
        
        
        _contactListener = new MyContactListenerS();
        _world->SetContactListener(_contactListener);
        
        if (_hud.tutorialSHOW)
        {
            pause = YES;
            [self schedule:@selector(GAME_PAUSE) interval:0.1f];
        }
        
        if (![Combinations checkNSDEFAULTS_Bool_ForKey:C_TUTORIAL_(_hud.level)])
        {
            [cfg runSelectorTarget:self selector:@selector(showTut_9) object:nil afterDelay:1 sender:self];
        }
        
        // [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"levelsound2.mp3" loop:YES];
        
        //GLESDebugDraw *debugDraw = new GLESDebugDraw(PTM_RATIO*CC_CONTENT_SCALE_FACTOR());
        //debugDraw->SetFlags(GLESDebugDraw::e_shapeBit);
        //_world->SetDebugDraw(debugDraw);
        
        //NSLog(@"___%g %g___",kWidthScreen,kHeightScreen);
        // NSLog(@"%f %f",self.contentSize.width,self.contentSize.height);
        
	}
	return self;
}

-(void)showTut_9
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

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	delete _world;
    delete _contactListener;
	_world = NULL;
    _body = NULL;
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
