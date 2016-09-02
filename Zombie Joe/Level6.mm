// Import the interfaces
#import "Level6.h"
#import "b2ContactManager.h"
#import "cfg.h"
#import "Combinations.h"
#import "Constants.h"
#import "BrainsBonus.h"
#import "constants_l5.h"
#import "Tutorial.h"
#import "SimpleAudioEngine.h" 

#import "CCFollowDynamic.h"

#define PTM_RATIO       32   // 32 pixels equals 1 meter
#define kSpriteTag      1000
#define kWorldGravity   -100.0
#define kJumpImpulse    -6.8 * kWorldGravity
#define kPlayerMass      10.0

#define kJOE_Z 22

@implementation Level6
//@synthesize playerWalk;

-(NSString*)prefix
{
    if (IS_IPAD)return @"";return @"_iPhone";
}

-(void) createWorld
{
    b2Vec2 gravity;
    gravity.Set(0.0f, kWorldGravity);
    m_world = new b2World(gravity);
    m_world->SetAllowSleeping(true);
}

-(void) createRoom
{
    // define a body and set the needed parameters
    b2BodyDef roomDef;
    roomDef.position.Set(0, 0);
    
    // create the body ant attach it to the world
    b2Body *roomBody = m_world->CreateBody(&roomDef);
    
    // define the floor fixture and set the needed parameters
    b2PolygonShape edge;
    edge.SetAsBox(0, 0, b2Vec2(kWidthScreen/PTM_RATIO, kHeightScreen/PTM_RATIO), 0);
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &edge;
    
    // create the fixture and attach it to the body
    roomBody->CreateFixture(&fixtureDef);
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//----------------------------------------- CREATE PLAYER --------------
-(void)playerBorn
{
//    playerWalk = [[[JOE_C alloc]initWithRect:CGRectMake(0, 0, 100, 100) tag:999]autorelease];
//    [self addChild:playerWalk z:22];
//    playerWalk.tag = 999;
//    playerWalk.scale = 0.8f;
//    playerWalk.position = ccp(kWidthScreen/2, kHeightScreen*3.66f);
//    playerWalk.scale = 0.001f;
//    playerWalk.opacity = 0;
}
-(void) createPlayerBody:(CGPoint)point
{
    // Create player body
    zombieBodyDef.type = b2_dynamicBody;
    zombieBodyDef.userData = m_zombieCostume;
    zombieBodyDef.fixedRotation = true;
    zombieBodyDef.position.Set(kWidthScreen/2/PTM_RATIO, kHeightScreen*0.2f/PTM_RATIO);
    m_zombieBody = m_world->CreateBody(&zombieBodyDef);
    
    // create a shape
    b2PolygonShape player;
    player.SetAsBox(0.5, 0.8); //these two are the width and height
    
    // Create shape definition and add to body
    b2FixtureDef zombieShapeDef;
    zombieShapeDef.shape        = &player;
    zombieShapeDef.density      = kPlayerMass;  // Tankis
    //zombieShapeDef.density    = 0.05f;
    zombieShapeDef.friction     = 100.0f;       // Trintis


    m_zombieFixture = m_zombieBody->CreateFixture(&zombieShapeDef);
}

-(void) createPlayerCostume:(CGPoint)point
{
    /////////////////////////////////////////////////////////////
    CGRect rect;
    if (IS_IPAD) {rect = CGRectMake(0, 0, 175, 230);}else{rect = CGRectMake(0, 0, 100, 125);}
    
    m_zombieCostume = [[[JoeZombieController alloc]initWitPos:ccp(0, 0) size:CGSizeMake(rect.size.width,rect.size.height)]autorelease];
    [self addChild:m_zombieCostume z:22 tag:999];
    
    m_zombieCostume.scale        = 0.45f;
    m_zombieCostume.position     = ccp(point.x, point.y);
    m_zombieCostume.anchorPoint  = ccp(0.5f, 0.5f);
    [m_zombieCostume JOE_IDLE];
    /////////////////////////////////////////////////////////////
}

-(void) createNewBall
{
    [self createPlayerCostume:        ccp(kWidthScreen / 2 / PTM_RATIO, kHeightScreen / 2 / PTM_RATIO)];
    [self createPlayerBody:           ccp(kWidthScreen / 2 / PTM_RATIO, kHeightScreen / 2 / PTM_RATIO)];
}

-(BOOL)isRetina
{
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && [[UIScreen mainScreen] scale] == 2.0f);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//----------------------------------------- CREATE PLATFORM -------------
-(void) createPlatformBody:(CGPoint)point
{
    for (int x = 0 ; x < 11; x++)
    {
        b2PolygonShape polygonShape_;
        b2Vec2 verts[5];
        
        float x_ = 1.8f;
        float y_ = 0.5f;
        
        if (IS_IPHONE)
        {
            x_ = 0.8f;  y_ = 0.2f;
        }
        
        verts[0].Set(  0, -0.75);
        verts[1].Set( x_, -y_ );
        verts[2].Set( x_,  y_ );
        verts[3].Set(-x_,  y_ );
        verts[4].Set(-x_, -y_);
        polygonShape_.Set( verts, 5 );
        
        platformBodyDef_.type = b2_kinematicBody;
        platformBodyDef_.position.Set(0, ((x+1)*kHeightScreen*0.3f + 40)/PTM_RATIO);
        
        CCSprite *sprite = (CCSprite*)[items getChildByTag:kSpriteTag+x];
        sprite.position  = ccp(((x+1)*10),((x+1)*kHeightScreen*0.3f));
         
        platformBodyDef_.userData = sprite;
        m_platformBody_ = m_world->CreateBody(&platformBodyDef_);
        m_platformFixture_ = m_platformBody_->CreateFixture( &polygonShape_, 0 );
    }
}
-(void) createPlatformCostume:(CGPoint)point
{
    for (int x = 0 ; x < 11; x++)
    {
        m_platformCostume_     = [CCSprite spriteWithSpriteFrameName:@"ground.png"];
        m_platformCostume_.anchorPoint   = ccp(0.5,0.5);
        m_platformCostume_.position      = ccp(0, kHeightScreen/2/PTM_RATIO);
        //m_platformCostume_.opacity       = 100;
        m_platformCostume_.tag = kSpriteTag + x;
        [items addChild:m_platformCostume_ z:20];
    }
}

-(void) createGroundBody:(CGPoint)point
{
    float x_ = 6.0f;
    float y_ = 0.5f;
    
    if (IS_IPHONE)
    {
        x_ = 2.5f;
        y_ = 0.5f;
    }
    
    //setup ground shape
    b2PolygonShape polygonGroundShape;
    b2Vec2 vertsG[5];
    vertsG[0].Set(   0, -0.75 );
    vertsG[1].Set(  x_/2, -y_  );
    vertsG[2].Set(  x_/2,  y_  );
    vertsG[3].Set( -x_/2,  y_  );
    vertsG[4].Set( -x_/2, -y_  );
    polygonGroundShape.Set( vertsG, 5 );
    
    // create a shape for lava
    b2PolygonShape lava;
    lava.SetAsBox(kWidthScreen, 0.6f);
    
    // create a shape for left/right grounds
    b2PolygonShape groundsShape;
    groundsShape.SetAsBox(x_, 0.8f);
    
    b2PolygonShape sideGroundShape;
    sideGroundShape.SetAsBox(x_, 0.4f);
    
    // WIN shape
    b2PolygonShape winGroundShape;
    winGroundShape.SetAsBox(x_ * 4.5f, 0.4f);
    
    
    // Create shape definition and add to bodies
    b2FixtureDef platformShapeDef;
    platformShapeDef.shape      = &polygonGroundShape;
    platformShapeDef.density    = 10.0f;                 // Tankis
    platformShapeDef.friction   = 1.0f;                  // Trintis
    
    
    // CREATE CENTER_GROUND
    {   
        groundBodyDef.type = b2_staticBody;
        if (IS_IPAD) {  groundBodyDef.position.Set(                     kWidthScreen/2/PTM_RATIO,                               kHeightScreen * 0.10f/PTM_RATIO); }
        else {          groundBodyDef.position.Set(                     kWidthScreen/2/PTM_RATIO,                               kHeightScreen * 0.05f/PTM_RATIO); }
        m_groundBody = m_world->CreateBody(&groundBodyDef);
        m_groundFixture = m_groundBody->CreateFixture( &polygonGroundShape, 0 );
        m_groundFixture->SetUserData((void*)1); //anything non-zero
    }
    
    // CREATE LAVA
    {   
        lavaBodyDef.type = b2_staticBody;
        //groundBodyDef.userData = m_lavaCostume;
        lavaBodyDef.position.Set(                       kWidthScreen/2/PTM_RATIO,                               kHeightScreen * 0.03f/PTM_RATIO);
        m_lavaBody = m_world->CreateBody(&lavaBodyDef);
        m_lavaFixture = m_lavaBody->CreateFixture( &lava, 0 );
        m_lavaFixture->SetUserData((void*)1); //anything non-zero
    }
    
    // CREATE WIN_GROUND
    {
        winBodyDef.type = b2_staticBody;
        if (IS_IPHONE)  { winBodyDef.position.Set(  kWidthScreen/2/PTM_RATIO,   kHeightScreen * 3.78f/PTM_RATIO); }
        else            { winBodyDef.position.Set(  kWidthScreen/2/PTM_RATIO,   kHeightScreen * 3.76f/PTM_RATIO); }
        
        m_winBody = m_world->CreateBody(&winBodyDef);
        m_winFixture = m_winBody->CreateFixture( &winGroundShape, 0 );
    }
}
-(void) createNewPlatform
{
    [self createGroundBody:             ccp(0, 0)];
    [self createPlatformCostume:        ccp(kWidthScreen / 2 / PTM_RATIO, kHeightScreen / 2 / PTM_RATIO)];
    [self createPlatformBody:           ccp(kWidthScreen / 2 / PTM_RATIO, kHeightScreen / 2 / PTM_RATIO)];
}

-(void)setPlatBounce:(b2Body *)body
{
 
}

-(void)backPbounce
{
    pBounce = false;
}

-(void) flipZombie
{
        if (flipXxx)
        {
            [m_zombieCostume JOE_flipX: YES];
            flipXxx = false;
        }
        else
        {
            [m_zombieCostume JOE_flipX: NO];
            flipXxx = true;
        }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//----------------------------------------- UPDATE ----------------------
-(void) update:(ccTime)dt
{
    pause = NO;
    
    float timeStep = 1.0f / 60.0f;
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
    
	m_world->Step(timeStep, velocityIterations, positionIterations);
    
    // Check if lava rise action is done
    if (lavaActionDone)
    {
        lavaActionDone = false;
        m_lavaBody->SetTransform(b2Vec2(kWidthScreen/2/PTM_RATIO, kHeightScreen*0.14f/PTM_RATIO), 0);
        m_groundBody->GetWorld()->DestroyBody(m_groundBody);
    }

    if (m_zombieBody->GetLinearVelocity().y == 0)
    {
        isJump = false;
    }
    else if (m_zombieBody->GetLinearVelocity().y < 0 || m_zombieBody->GetLinearVelocity().y > 0)
    {
        isJump = true;
    }
    
    // Check if player is moving up or moving down (make body solid or non-solid)
    if (!isGameOver && over == true)
    {
        if (m_zombieBody->GetLinearVelocity().y > 1)    {   m_zombieFixture->SetSensor(true); isJump = true; }
        else                                            {   m_zombieFixture->SetSensor(false); }
    }
    
    // If player fall under ground or out of screen..and reset his position
    if (m_zombieBody->GetTransform().p.y < 0)
    {
        m_zombieBody->SetLinearVelocity(b2Vec2(0, 0));
        m_zombieBody->SetAngularVelocity(0);
        m_zombieBody->ApplyLinearImpulse(b2Vec2( 0,  600 ), m_zombieBody->GetWorldCenter());
    }
    
    if (m_zombieBody->GetTransform().p.y < kHeightScreen*0.1f/PTM_RATIO && over == true)
    {
        isGameOver = true;
    }
    
    if (!moveToWin)
    {
        // Checking player position and flip him to opositive side
        if (m_zombieBody->GetPosition().x <  kWidthScreen/2/PTM_RATIO)
        {
            if (flipX == false)
            {
                [self flipZombie];
                flipX = true;
            }
        }
        if (m_zombieBody->GetPosition().x >= kWidthScreen/2/PTM_RATIO)
        {
            if (flipX == true)
            {
                [self flipZombie];
                flipX = false;
            }
        }
    }

    if (isGameOver && over)
    {
        onWalk = 1;
        zombieBodyDef.userData = nil;
        
        m_zombieFixture->SetSensor(true);
        m_lavaFixture->SetSensor(true);
        m_platformFixture_->SetSensor(true);
        
        [_hud makeBlastInPosposition:ccp(m_zombieCostume.position.x, m_zombieCostume.position.y - [[m_zombieCostume robot_]getChildByTag:0].boundingBox.size.height/2)];
        
        [[m_zombieCostume robot_] colorAllBodyPartsWithColor:ccc3(220, 72, 72)
                                                        part:0
                                                         all:YES
                                                     restore:YES
                                           restoreAfterDelay:0.15f];
        
        id moveZombieToDead = [CCMoveTo actionWithDuration:0.5f position:ccp(m_zombieCostume.position.x, kHeightScreen - kHeightScreen*1.1f)];
        [m_zombieCostume runAction:moveZombieToDead];
        
        over = false;
        [AUDIO playEffect:l4_clap];
        
        [cfg runSelectorTarget:self selector:@selector(GMover) object:nil afterDelay:0.5f sender:self];
    }
    
    int bodies = 0;
    for(b2Body *b = m_world->GetBodyList(); b; b=b->GetNext())
    {
        
        if (bodies >=0 && bodies <= 11)
        {
            float velo = 4;
            
            if (IS_IPHONE_5)
            {
                if (bodies ==  0)  { velo = (float)[cfg MyRandomIntegerBetween:11  :13]; }
                if (bodies ==  1)  { velo = (float)[cfg MyRandomIntegerBetween: 9  :11]; }
                if (bodies ==  2)  { velo = (float)[cfg MyRandomIntegerBetween:10  :11]; }
                if (bodies ==  3)  { velo = 11; }
                if (bodies ==  4)  { velo = 10; }
                if (bodies ==  5)  { velo = 8; }
                if (bodies ==  6)  { velo = 9; }
                if (bodies ==  7)  { velo = 7; }
                if (bodies ==  8)  { velo = 8; }
                if (bodies ==  9)  { velo = 4; }
                if (bodies == 10)  { velo = 5; }
                if (bodies == 11)  { velo = 3; }
            }
            else
            {
                if (bodies ==  0)  { velo = (float)[cfg MyRandomIntegerBetween:10  :12]; }
                if (bodies ==  1)  { velo = (float)[cfg MyRandomIntegerBetween: 8  :10]; }
                if (bodies ==  2)  { velo = (float)[cfg MyRandomIntegerBetween: 9  :10]; }
                if (bodies ==  3)  { velo = 10; }
                if (bodies ==  4)  { velo = 9; }
                if (bodies ==  5)  { velo = 7; }
                if (bodies ==  6)  { velo = 8; }
                if (bodies ==  7)  { velo = 6; }
                if (bodies ==  8)  { velo = 7; }
                if (bodies ==  9)  { velo = 3; }
                if (bodies == 10)  { velo = 4; }
                if (bodies == 11)  { velo = 2; }
            }
            
            if (      b->GetTransform().p.x <= kWidthScreen * 0.08f / PTM_RATIO)
            {
                if (IS_IPHONE) { b->SetLinearVelocity(b2Vec2(  velo/2,     0  )); }
                else {           b->SetLinearVelocity(b2Vec2(  velo,       b->GetLinearVelocity().y)); }
            }
            
            else if ( b->GetTransform().p.x >= kWidthScreen * 0.92f / PTM_RATIO)
            {
                if (IS_IPHONE) { b->SetLinearVelocity(b2Vec2(  (-velo-(1))/2,   0  )); }
                else {           b->SetLinearVelocity(b2Vec2(  -velo-(1),   b->GetLinearVelocity().y  )); }
            }
             

            // ----- checking contact between objects ------
            std::vector<b2Body *>toDestroy;
            std::vector<MyContact>::iterator pos;
            for (pos=_contactListener->_contacts.begin();pos != _contactListener->_contacts.end(); ++pos)
            {
                MyContact contact = *pos;
                
                // Checking if player touch any platform
                if ((contact.fixtureA == b->GetFixtureList() && contact.fixtureB == m_zombieFixture) ||
                    (contact.fixtureA == m_zombieFixture && contact.fixtureB == b->GetFixtureList()))
                {
//                    if (isJump && m_zombieBody->GetLinearVelocity().y < 1)
//                    {
//                        
//                    }
                    
                    if (m_zombieBody->GetLinearVelocity().y == 0)
                    {
                        if (velZero == false)
                        {
                            [AUDIO playEffect:l4_fall];
                        }
                        velZero = true;
                        
                        if (runidle ==false)
                        {
                            [[m_zombieCostume robot_]ACTION_StopAllPartsAnimations_Clean:YES];
                            [[m_zombieCostume robot_]JOE_IDLE_MENU];
                            runidle = true;
                        }
                    }

                }
            }
        }
        
        CCSprite *sprite = (CCSprite*)[items getChildByTag:kSpriteTag + bodies];
        if (IS_IPHONE)  { sprite.position = ccp(b->GetTransform().p.x*PTM_RATIO,b->GetTransform().p.y*PTM_RATIO + kHeightScreen*0.01f); }
        else            { sprite.position = ccp(b->GetTransform().p.x*PTM_RATIO,b->GetTransform().p.y*PTM_RATIO - kHeightScreen*0.06f); }
        bodies ++;

    }

    // ----- checking contact between objects ------
    std::vector<b2Body *>toDestroy;
    std::vector<MyContact>::iterator pos;
    for (pos=_contactListener->_contacts.begin();pos != _contactListener->_contacts.end(); ++pos)
    {
        MyContact contact = *pos;
        
        // Checking if player touch any platform
        if ((contact.fixtureA == m_platformFixture_ && contact.fixtureB == m_zombieFixture) ||
            (contact.fixtureA == m_zombieFixture && contact.fixtureB == m_platformFixture_))
        {
            isContact   = YES;
            break;
        }
        
        //Checking is player fall in lava - gameOver
        if ((contact.fixtureA == m_lavaFixture && contact.fixtureB == m_zombieFixture) ||
            (contact.fixtureA == m_zombieFixture && contact.fixtureB == m_lavaFixture))
        {
            isGameOver = true;
            break;
        }

        if (m_zombieBody->GetTransform().p.y < m_winBody->GetTransform().p.y)
        {
            m_winFixture->SetSensor(false);
        }
        else
        {
                if (velZero == false)
                {
                    [AUDIO playEffect:fx_winmusic];
                }
                velZero = true;
 
            ////////// IF WIN /////////
            isFinish = true;

            runidle   = true;
            moveToWin = true;
            isContact = YES;
            
            
            
        }

        // Checking conect with ground
        if ((contact.fixtureA == m_groundFixture && contact.fixtureB == m_zombieFixture) ||
            (contact.fixtureA == m_zombieFixture && contact.fixtureB == m_groundFixture))
        {
            
            if (m_zombieBody->GetLinearVelocity().y == 0)
            {
                if (velZero == false)
                {
                    [AUDIO playEffect:l4_fall];
                }
                velZero = true;
                
                if (runidle ==false)
                {
                    [[m_zombieCostume robot_]ACTION_StopAllPartsAnimations_Clean:YES];
                    [[m_zombieCostume robot_]JOE_IDLE_MENU];
                    runidle = true;
                }
            }
            
            movingRight = false;
            movingLeft  = false;
            isContact   = YES;
            break;
        }
    }
    // checking brains and player contact
    if (CGRectIntersectsRect([m_zombieCostume boundingBox], [[self getChildByTag:TAG_BRAIN_1] boundingBox]))
    {
        if (!brain1Taked)
        {
            [cfg makeBrainActionForNode:brain1
                         fakeBrainsNode:nil
                              direction:270
                           pixelsToMove:100
                                 parent:self
                      removeBrainsAfter:YES
                     makeActionAfterall:@selector(incBrains1)
                                 target:self];

            brain1Taked = true;
        }
        
    }
    if (CGRectIntersectsRect([m_zombieCostume boundingBox], [[self getChildByTag:TAG_BRAIN_2] boundingBox]))
    {
  
        if (!brain2Taked)
        {
            [cfg makeBrainActionForNode:brain2
                         fakeBrainsNode:nil
                              direction:270
                           pixelsToMove:100
                                 parent:self
                      removeBrainsAfter:YES
                     makeActionAfterall:@selector(incBrains1)
                                 target:self];
            
            brain2Taked = true;
        }
        
    }
    if (CGRectIntersectsRect([m_zombieCostume boundingBox], [[self getChildByTag:TAG_BRAIN_3] boundingBox]))
    {
        if (!brain3Taked)
        {
            [cfg makeBrainActionForNode:brain3
                         fakeBrainsNode:nil
                              direction:270
                           pixelsToMove:100
                                 parent:self
                      removeBrainsAfter:YES
                     makeActionAfterall:@selector(incBrains1)
                                 target:self];
            
            brain3Taked = true;
        }
    }
    
    
    // buvo 1
    if (isFinish == true)
    {
        if (onWalk == 0)
        {
            onWalk = 1;
            //[[m_zombieCostume robot_]ACTION_StopAllPartsAnimations_Clean:YES];
            
            if (m_zombieCostume.position.x > kWidthScreen*0.85f)
            {
                [m_zombieCostume JOE_flipX:YES];
            }
            else
            {
                [m_zombieCostume JOE_flipX:NO];
            }
            
            ////////////////////////////////////////////////////////
            float walkTime;
            float distanceA;
            float distanceX;
            float perc;
            float finalTime;
            
            walkTime    = 5.0f;
            
            distanceA   = kWidthScreen * 0.85f;
            distanceX   = m_zombieCostume.position.x;
            
            perc        = (distanceX * 100) / distanceA;
            finalTime   = ((100 - perc) * walkTime) / 100;
            
            if (finalTime < 0) {
                finalTime = 0.15f;
            }
            
            if (m_zombieCostume.position.x >= kWidthScreen * 0.88f)
            {
                finalTime = 0.05f;//0.3f;
            }
      
            [[m_zombieCostume robot_]JOE_WALK_SPEED:(100-perc)/20];
            /////////////////////////////////////////////////////
            
            if (IS_IPHONE)
            {
                m_zombieCostume.position = ccp(m_zombieCostume.position.x, kHeightScreen*3.78f);
                CGPoint zombiePosNext = ccp(kWidthScreen*0.85f, kHeightScreen*3.78f);
                id move = [CCMoveTo actionWithDuration:finalTime position:zombiePosNext];
                id win = [CCCallBlock actionWithBlock:^(void) { [_hud WINLevel]; [_hud TIME_Stop];[[m_zombieCostume robot_]ACTION_StopAllPartsAnimations_Clean:YES]; m_zombieCostume.scale = 0.001f; }];
                id sequance = [CCSequence actions:move,win, nil];
                [m_zombieCostume runAction:sequance];
            }
            else
            {
                m_zombieCostume.position = ccp(m_zombieCostume.position.x, kHeightScreen*3.69f);
                CGPoint zombiePosNext = ccp(kWidthScreen*0.85f, kHeightScreen*3.69f);
                id move = [CCMoveTo actionWithDuration:finalTime position:zombiePosNext];
                id win = [CCCallBlock actionWithBlock:^(void) { [_hud WINLevel]; [_hud TIME_Stop];[[m_zombieCostume robot_]ACTION_StopAllPartsAnimations_Clean:YES]; m_zombieCostume.scale = 0.001f; }];
                id sequance = [CCSequence actions:move,win, nil];
                [m_zombieCostume runAction:sequance];
            }  
            
        }
    }
    if (IS_IPHONE)
    {
        hOnPlatform = 11.5f;
    }
    else if (IS_IPAD)
    {
        hOnPlatform = kHeightScreen * hOnPlatform;
    }
    
    if (onWalk == 0 && isGameOver == false)
    {
        m_zombieCostume.position = ccp(m_zombieBody->GetTransform().p.x*PTM_RATIO,
                                       m_zombieBody->GetTransform().p.y*PTM_RATIO + hOnPlatform);
    }
}

-(void) GMover
{
    [_hud TIME_Stop];
    [_hud LOSTLevel];
}

-(void) incBrains1
{
    [_hud increaseBRAINSNUMBER];
}

-(id)getNode
{
    return [Level6 node];
}

-(void) actionDone
{
    lavaActionDone = true;
}
-(void) createWorldBackgrounds
{
    // BACKGROUND0 ------------------
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
    CCSpriteBatchNode *bg =         [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"BG_Level6%@.pvr.ccz", [self prefix]]];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"BG_Level6%@.plist",   [self prefix]]];
    [self addChild:bg z:10];
    
    backgroundBegin = [CCSprite spriteWithSpriteFrameName:@"background0.jpg"];
    backgroundBegin.anchorPoint     = ccp(0.5,0);
    backgroundBegin.position        = ccp(kWidthScreen/2,   0);
    //backgroundBegin.opacity         = 100;
    [bg addChild:backgroundBegin];
    
    
    // BACKGROUND1 ------------------
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
    CCSpriteBatchNode *bg1 =         [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"BG1_Level6%@.pvr.ccz", [self prefix]]];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"BG1_Level6%@.plist",    [self prefix]]];
    [self addChild:bg1 z:10];
    
    backgroundCenter1 = [CCSprite spriteWithSpriteFrameName:@"background1.jpg"];
    backgroundCenter1.anchorPoint   = ccp(0.5,0);
    backgroundCenter1.position      = ccp(kWidthScreen/2,   kHeightScreen - kHeightScreen * 0.006f);
    //backgroundCenter1.opacity       = 100;
    [bg1 addChild:backgroundCenter1];
    
    
    //NSLog(@"BG CENTER SIZES :%f %f",backgroundCenter1.contentSize.width,backgroundCenter1.contentSize.height);
    
    
    backgroundCenter2 = [CCSprite spriteWithSpriteFrameName:@"background1.jpg"];
    backgroundCenter2.anchorPoint   = ccp(0.5,0);
    backgroundCenter2.position      = ccp(kWidthScreen/2,   (kHeightScreen * 2) - kHeightScreen * 0.006f);
    //backgroundCenter2.opacity       = 100;
    [bg1 addChild:backgroundCenter2];
    
    
    // BACKGROUND2 ------------------
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
    CCSpriteBatchNode *bg2 =         [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"BG2_Level6%@.pvr.ccz", [self prefix]]];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"BG2_Level6%@.plist",   [self prefix]]];
    [self addChild:bg2 z:10];
    
    backgroundFinal = [CCSprite spriteWithSpriteFrameName:@"background2.jpg"];
    backgroundFinal.anchorPoint     = ccp(0.5,0);
    backgroundFinal.position        = ccp(kWidthScreen/2,   (kHeightScreen * 3) - kHeightScreen * 0.006f);
    //backgroundFinal.opacity         = 100;
    [bg2 addChild:backgroundFinal];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
}
-(void) createBrains
{
    // Create brain_1 sprite -----------------------
    //brain1 = [CCSprite spriteWithSpriteFrameName:@"brains.png"];
    brain1 = (BrainRobot*)[self getChildByTag:TAG_BRAIN_1];
    brain1.anchorPoint = ccp(0.5, 0.5);
    if (IS_IPHONE)
    {
        brain1.position = ccp(kWidthScreen * 0.25f, kHeightScreen*0.42f);
        
        CCMoveTo *brain1Anim1            = [CCMoveTo actionWithDuration:10.f position:ccp(kWidthScreen * 0.25f,      kHeightScreen * 2.12)];
        CCMoveTo *brain1Anim2            = [CCMoveTo actionWithDuration:8.f position:ccp(kWidthScreen * 0.65f,      kHeightScreen * 3.12)];
        CCSequence *actionRunbrain1             = [CCSequence actions:brain1Anim1, brain1Anim2, nil];
        CCRepeatForever *actionsRepeatbrain1    = [CCRepeatForever actionWithAction:actionRunbrain1];
        [brain1 runAction:actionsRepeatbrain1];
    }
    else
    {
        brain1.position = ccp(kWidthScreen * 0.25f, kHeightScreen*0.50f);
    
        CCMoveTo *brain1Anim1            = [CCMoveTo actionWithDuration:10.5f position:ccp(kWidthScreen * 0.25f,      kHeightScreen * 2.10f)];
        CCMoveTo *brain1Anim2            = [CCMoveTo actionWithDuration:8.5f position:ccp(kWidthScreen * 0.65f,      kHeightScreen * 3.10f)];
        CCSequence *actionRunbrain1             = [CCSequence actions:brain1Anim1, brain1Anim2, nil];
        CCRepeatForever *actionsRepeatbrain1    = [CCRepeatForever actionWithAction:actionRunbrain1];
        [brain1 runAction:actionsRepeatbrain1];
    }
    
    //[self addChild:brain1 z:21];
    
    
    // Create brain_2 sprite -----------------------
    brain2 = (BrainRobot*)[self getChildByTag:TAG_BRAIN_2]; //[CCSprite spriteWithSpriteFrameName:@"brains.png"];
    
    brain2.anchorPoint = ccp(0.5, 0.5);
    if (IS_IPHONE)
    {
        brain2.position = ccp(kWidthScreen*0.8f, kHeightScreen*1.92f);
        
        CCMoveTo *brain2Anim1            = [CCMoveTo actionWithDuration:3.0f position:ccp(kWidthScreen*0.86f,        kHeightScreen*2.02f)];
        CCMoveTo *brain2Anim2            = [CCMoveTo actionWithDuration:3.0f position:ccp(kWidthScreen*0.90f,        kHeightScreen*2.02f)];
        CCSequence *actionRunbrain2             = [CCSequence actions:brain2Anim1, brain2Anim2, nil];
        CCRepeatForever *actionsRepeatbrain2    = [CCRepeatForever actionWithAction:actionRunbrain2];
        [brain2 runAction:actionsRepeatbrain2];
        
    }
    else
    {
        brain2.position = ccp(kWidthScreen*0.8f, kHeightScreen*1.80f);
        
        CCMoveTo *brain2Anim1            = [CCMoveTo actionWithDuration:3.0f position:ccp(kWidthScreen*0.86f,        kHeightScreen*1.92f)];
        CCMoveTo *brain2Anim2            = [CCMoveTo actionWithDuration:3.0f position:ccp(kWidthScreen*0.90f,        kHeightScreen*1.92f)];
        CCSequence *actionRunbrain2             = [CCSequence actions:brain2Anim1, brain2Anim2, nil];
        CCRepeatForever *actionsRepeatbrain2    = [CCRepeatForever actionWithAction:actionRunbrain2];
        [brain2 runAction:actionsRepeatbrain2];
    }
    //[self addChild:brain2 z:21];
    

    // Create brain_3 sprite -----------------------
    brain3 = (BrainRobot*)[self getChildByTag:TAG_BRAIN_3];// [CCSprite spriteWithSpriteFrameName:@"brains.png"];
    brain3.anchorPoint = ccp(0.5, 0.5);
    if (IS_IPHONE)
    {
        brain3.position = ccp(kWidthScreen/4, kHeightScreen * 3.38f);
        
        CCMoveTo *brain3Anim1            = [CCMoveTo actionWithDuration:2.0f position:ccp(kWidthScreen/4,        kHeightScreen*3.34f)];
        CCMoveTo *brain3Anim2            = [CCMoveTo actionWithDuration:4.0f position:ccp(kWidthScreen/2.5,      kHeightScreen*3.34f)];
        CCSequence *actionRunbrain3             = [CCSequence actions:brain3Anim1, brain3Anim2, nil];
        CCRepeatForever *actionsRepeatbrain3    = [CCRepeatForever actionWithAction:actionRunbrain3];
        [brain3 runAction:actionsRepeatbrain3];
    }
    else
    {
        brain3.position = ccp(kWidthScreen/4, kHeightScreen * 3.3f);
    
        CCMoveTo *brain3Anim1            = [CCMoveTo actionWithDuration:2.0f position:ccp(kWidthScreen/4,        kHeightScreen*3.19f)];
        CCMoveTo *brain3Anim2            = [CCMoveTo actionWithDuration:4.0f position:ccp(kWidthScreen/2.5,      kHeightScreen*3.19f)];
        CCSequence *actionRunbrain3             = [CCSequence actions:brain3Anim1, brain3Anim2, nil];
        CCRepeatForever *actionsRepeatbrain3    = [CCRepeatForever actionWithAction:actionRunbrain3];
        [brain3 runAction:actionsRepeatbrain3];
    }
    //[self addChild:brain3 z:21];
}
-(void) createWorldDetails
{
    // Create lava sprite -----------------------
    lavaSp = [CCSprite spriteWithSpriteFrameName:@"water.png"];
    lavaSp.anchorPoint = ccp(0.5, 0);
    //lavaSp.opacity = 100;
    lavaSp.scaleX = 2.4f;
    if (IS_IPHONE)  { lavaSp.position = ccp(kWidthScreen/2/PTM_RATIO, kHeightScreen - kHeightScreen*1.34f); }
    else            { lavaSp.position = ccp(kWidthScreen/2/PTM_RATIO, kHeightScreen - kHeightScreen*1.34f); }
    [self addChild:lavaSp z:95];
    
    // Create lava sprite -----------------------
    lavaSp2 = [CCSprite spriteWithSpriteFrameName:@"water.png"];
    lavaSp2.anchorPoint = ccp(0.5, 0);
    lavaSp2.scaleX = 2.4f;
    lavaSp2.opacity = 240;
    if (IS_IPHONE)  { lavaSp2.position = ccp(kWidthScreen/2/PTM_RATIO, kHeightScreen - kHeightScreen*1.32f); }
    else            { lavaSp2.position = ccp(kWidthScreen/2/PTM_RATIO, kHeightScreen - kHeightScreen*1.30f); }
    [self addChild:lavaSp2 z:95];
    
    if (IS_IPHONE) {
        CCMoveTo *waveAnim1 = [CCMoveTo actionWithDuration:8.5f position:ccp    (kWidthScreen / 2.5f,       kHeightScreen - kHeightScreen*1.26f)];
        CCMoveTo *waveAnim2 = [CCMoveTo actionWithDuration:6.5f position:ccp    (kWidthScreen / 2.0f,       kHeightScreen - kHeightScreen*1.24)];
        CCSequence *actionRun = [CCSequence actions:waveAnim1, waveAnim2, nil];
        CCRepeatForever *actionsRepeat = [CCRepeatForever actionWithAction:actionRun];
        [lavaSp runAction:actionsRepeat];
    }else {
        CCMoveTo *waveAnim1 = [CCMoveTo actionWithDuration:8.5f position:ccp    (kWidthScreen / 2.5f,       kHeightScreen - kHeightScreen*1.28f)];
        CCMoveTo *waveAnim2 = [CCMoveTo actionWithDuration:6.5f position:ccp    (kWidthScreen / 2.0f,       kHeightScreen - kHeightScreen*1.26f)];
        CCSequence *actionRun = [CCSequence actions:waveAnim1, waveAnim2, nil];
        CCRepeatForever *actionsRepeat = [CCRepeatForever actionWithAction:actionRun];
        [lavaSp runAction:actionsRepeat];
    }
    
    if (IS_IPHONE) {
        id waveAnim3 = [CCMoveTo actionWithDuration:10.0f position:ccp          (kWidthScreen / 2.0f,       kHeightScreen - kHeightScreen*1.20f)];
        id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(actionDone)];
        CCSequence *actionRunning = [CCSequence actions:waveAnim3, actionMoveDone, nil];
        [lavaSp2 runAction:actionRunning];
    }else {
        id waveAnim3 = [CCMoveTo actionWithDuration:10.0f position:ccp          (kWidthScreen / 2.0f,       kHeightScreen - kHeightScreen*1.22f)];
        id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(actionDone)];
        CCSequence *actionRunning = [CCSequence actions:waveAnim3, actionMoveDone, nil];
        [lavaSp2 runAction:actionRunning];
    }
    
    // Create redBird1 sprite --------------------
    redBird1 = [CCSprite spriteWithSpriteFrameName:@"bird.png"];
    redBird1.anchorPoint = ccp(0.5,0);
    if (IS_IPHONE)  { redBird1.position = ccp(kWidthScreen*0.68f, kHeightScreen*0.35f); }
    else            { redBird1.position = ccp(kWidthScreen*0.68f, kHeightScreen*0.30f);  }
    redBird1.scale = 0.6f;
    //redBird1.opacity = 100;
    [items addChild:redBird1 z:10];
    
    // Create redBird2 sprite --------------------
    redBird2 = [CCSprite spriteWithSpriteFrameName:@"bird.png"];
    redBird2.anchorPoint = ccp(0.5,0);
    redBird2.position = ccp(kWidthScreen*0.07f, kHeightScreen*0.14f);
    redBird2.scale = 0.8f;
    redBird2.flipX = true;
    //redBird2.opacity = 100;
    [items addChild:redBird2 z:10];
    
    // Create redBird3 sprite --------------------
    redBird3 = [CCSprite spriteWithSpriteFrameName:@"bird.png"];
    redBird3.anchorPoint = ccp(0.5,0);
    if (IS_IPHONE)
    {
        if (IS_IPHONE_5 )   { redBird3.position = ccp(kWidthScreen*0.86f, kHeightScreen*1.99f); }
        else                { redBird3.position = ccp(kWidthScreen*0.82f, kHeightScreen*1.99f); }
    }
    else                    { redBird3.position = ccp(kWidthScreen*0.77f, kHeightScreen*1.89f); }
    //redBird3.opacity = 100;
    [items addChild:redBird3 z:10];
    
    // Create moster sprite ---------------------
    monster = [CCSprite spriteWithSpriteFrameName:@"monster.png"];
    monster.anchorPoint = ccp(0.5,0);
    if (IS_IPHONE)
    {
        if (IS_IPHONE_5 )   { monster.position = ccp(kWidthScreen*0.22f, kHeightScreen*0.44f); }
        else                { monster.position = ccp(kWidthScreen*0.16f, kHeightScreen*0.44f); }
    }
    else                    { monster.position = ccp(kWidthScreen*0.16f, kHeightScreen*0.39f); }
    monster.scale = 0.4f;
    //monster.opacity = 100;
    [items addChild:monster z:10];
    
    // Create side wall sprite ---------------------
    birdGround = [CCSprite spriteWithSpriteFrameName:@"sideground.png"];
    birdGround.anchorPoint = ccp(1,0);
    if (IS_IPHONE)  { birdGround.position = ccp(kWidthScreen, kHeightScreen*1.92f); }
    else            { birdGround.position = ccp(kWidthScreen, kHeightScreen*1.8f);  }
    birdGround.scale = 0.8f;
    //birdGround.opacity = 100;
    [items addChild:birdGround z:9];
    
    
    CCMoveTo *monsterAnim1                  = [CCJumpBy actionWithDuration:4 position:ccp(0, 0) height: 0 jumps:1];
    CCMoveTo *monsterAnim2                  = [CCJumpBy actionWithDuration:1 position:ccp(0, 0) height:10 jumps:2];
    CCSequence *actionRunMonster            = [CCSequence actions:monsterAnim1, monsterAnim2, nil];
    CCRepeatForever *actionsRepeatM         = [CCRepeatForever actionWithAction:actionRunMonster];
    [monster runAction:actionsRepeatM];
    
    
    CCMoveTo *birdAnim1                     = [CCRotateBy actionWithDuration:1 angle: 5];
    CCMoveTo *birdAnim2                     = [CCRotateBy actionWithDuration:1 angle:-5];
    CCSequence *actionRunBird               = [CCSequence actions:birdAnim1, birdAnim2, nil];
    CCRepeatForever *actionsRepeatB         = [CCRepeatForever actionWithAction:actionRunBird];
    [redBird1 runAction:actionsRepeatB];
    
    CCMoveTo *birdAnim3                     = [CCRotateBy actionWithDuration:2     angle: 5];
    CCMoveTo *birdAnim4                     = [CCRotateBy actionWithDuration:2.5   angle:-5];
    CCSequence *actionRunBird2              = [CCSequence actions:birdAnim3, birdAnim4, nil];
    CCRepeatForever *actionsRepeatB2        = [CCRepeatForever actionWithAction:actionRunBird2];
    [redBird2 runAction:actionsRepeatB2];
    
    CCMoveTo *birdAnim5                     = [CCRotateBy actionWithDuration:2.5     angle: 5];
    CCMoveTo *birdAnim6                     = [CCJumpBy actionWithDuration:0.2 position:ccp(0, 0) height:10 jumps:1];
    CCMoveTo *birdAnim7                     = [CCRotateBy actionWithDuration:2       angle:-5];
    CCSequence *actionRunBird3              = [CCSequence actions:birdAnim5, birdAnim6, birdAnim7, nil];
    CCRepeatForever *actionsRepeatB3        = [CCRepeatForever actionWithAction:actionRunBird3];
    [redBird3 runAction:actionsRepeatB3];
    
    
    // Create clouds sprite ---------------------
    cloud0 = [CCSprite spriteWithSpriteFrameName:@"cloud0.png"];
    cloud0.anchorPoint = ccp(0.5,0);
    cloud0.position = ccp(kWidthScreen/2, kHeightScreen*0.95f);
    //cloud0.opacity = 100;
    [items addChild:cloud0 z:8];
    
    cloud1 = [CCSprite spriteWithSpriteFrameName:@"cloud1.png"];
    cloud1.anchorPoint = ccp(0.5,0);
    cloud1.position = ccp(kWidthScreen*0.6f, kHeightScreen*1.4f);
    //cloud1.opacity = 100;
    [items addChild:cloud1 z:8];
    
    cloud2 = [CCSprite spriteWithSpriteFrameName:@"cloud2.png"];
    cloud2.anchorPoint = ccp(0.5,0);
    cloud2.position = ccp(kWidthScreen*0.4f, kHeightScreen*1.95f);
    //cloud2.opacity = 100;
    [items addChild:cloud2 z:8];
    
    cloud3 = [CCSprite spriteWithSpriteFrameName:@"cloud0.png"];
    cloud3.anchorPoint = ccp(0.5,0);
    cloud3.position = ccp(kWidthScreen/2, kHeightScreen*2.95f);
    //cloud3.opacity = 100;
    [items addChild:cloud3 z:8];
    
    cloud4 = [CCSprite spriteWithSpriteFrameName:@"cloud1.png"];
    cloud4.anchorPoint = ccp(0.5,0);
    cloud4.position = ccp(kWidthScreen*0.6f, kHeightScreen*2.4f);
    //cloud4.opacity = 100;
    [items addChild:cloud4];
    
    cloud5 = [CCSprite spriteWithSpriteFrameName:@"cloud2.png"];
    cloud5.anchorPoint = ccp(0.5,0);
    cloud5.position = ccp(kWidthScreen*0.4f, kHeightScreen*3.2f);
    //cloud5.opacity = 100;
    [items addChild:cloud5 z:8];
    
    
    CCMoveTo *cloudAnim1            = [CCMoveTo actionWithDuration:85.0f position:ccp(kWidthScreen * 1.60f,                         kHeightScreen*0.94f)];
    CCMoveTo *cloudAnim2            = [CCMoveTo actionWithDuration: 0.0f position:ccp(kWidthScreen - kWidthScreen * 1.60f,          kHeightScreen*0.98f)];
    CCSequence *actionRuncloud1             = [CCSequence actions:cloudAnim1, cloudAnim2, nil];
    CCRepeatForever *actionsRepeatcloud1    = [CCRepeatForever actionWithAction:actionRuncloud1];
    [cloud0 runAction:actionsRepeatcloud1];
    
    CCMoveTo *cloudAnim3            = [CCMoveTo actionWithDuration:50.0f position:ccp(kWidthScreen * 1.40f,                         kHeightScreen*1.42f)];
    CCMoveTo *cloudAnim4            = [CCMoveTo actionWithDuration: 0.0f position:ccp(kWidthScreen - kWidthScreen * 1.40f,          kHeightScreen*1.35f)];
    CCSequence *actionRuncloud2             = [CCSequence actions:cloudAnim3, cloudAnim4, nil];
    CCRepeatForever *actionsRepeatcloud2    = [CCRepeatForever actionWithAction:actionRuncloud2];
    [cloud1 runAction:actionsRepeatcloud2];
    
    CCMoveTo *cloudAnim5            = [CCMoveTo actionWithDuration:65.0f position:ccp(kWidthScreen * 1.40f,                         kHeightScreen*1.95f)];
    CCMoveTo *cloudAnim6            = [CCMoveTo actionWithDuration: 0.0f position:ccp(kWidthScreen - kWidthScreen * 1.40f,          kHeightScreen*1.95f)];
    CCSequence *actionRuncloud3             = [CCSequence actions:cloudAnim5, cloudAnim6, nil];
    CCRepeatForever *actionsRepeatcloud3    = [CCRepeatForever actionWithAction:actionRuncloud3];
    [cloud2 runAction:actionsRepeatcloud3];
    
    CCMoveTo *cloudAnim7            = [CCMoveTo actionWithDuration:90.0f position:ccp(kWidthScreen * 1.60f,                         kHeightScreen*2.95f)];
    CCMoveTo *cloudAnim8            = [CCMoveTo actionWithDuration: 0.0f position:ccp(kWidthScreen - kWidthScreen * 1.60f,          kHeightScreen*2.93f)];
    CCSequence *actionRuncloud4             = [CCSequence actions:cloudAnim7, cloudAnim8, nil];
    CCRepeatForever *actionsRepeatcloud4    = [CCRepeatForever actionWithAction:actionRuncloud4];
    [cloud3 runAction:actionsRepeatcloud4];
    
    CCMoveTo *cloudAnim9            = [CCMoveTo actionWithDuration:50.0f position:ccp(kWidthScreen * 1.40f,                         kHeightScreen*2.45f)];
    CCMoveTo *cloudAnim10            = [CCMoveTo actionWithDuration: 0.0f position:ccp(kWidthScreen - kWidthScreen * 1.40f,         kHeightScreen*2.4f)];
    CCSequence *actionRuncloud5             = [CCSequence actions:cloudAnim9, cloudAnim10, nil];
    CCRepeatForever *actionsRepeatcloud5    = [CCRepeatForever actionWithAction:actionRuncloud5];
    [cloud4 runAction:actionsRepeatcloud5];
    
    CCMoveTo *cloudAnim11            = [CCMoveTo actionWithDuration:65.0f position:ccp(kWidthScreen * 1.40f,                         kHeightScreen*3.22f)];
    CCMoveTo *cloudAnim12            = [CCMoveTo actionWithDuration: 0.0f position:ccp(kWidthScreen - kWidthScreen * 1.40f,          kHeightScreen*3.16f)];
    CCSequence *actionRuncloud6             = [CCSequence actions:cloudAnim11, cloudAnim12, nil];
    CCRepeatForever *actionsRepeatcloud6    = [CCRepeatForever actionWithAction:actionRuncloud6];
    [cloud5 runAction:actionsRepeatcloud6];
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//----------------------------------------- DEBUG DRAW ------------------
-(void) draw
{
//	glDisable(GL_TEXTURE_2D);
//	glDisableClientState(GL_COLOR_ARRAY);
//	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
//    
//	m_world->DrawDebugData();
//    
//	glEnable(GL_TEXTURE_2D);
//	glEnableClientState(GL_COLOR_ARRAY);
//	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}
/////////////////////////////////////////////////////////////////////////
//----------------------------------------- TOUCHES ---------------------
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{ 
    if (!isJump && moveToWin == false)
    {
        m_zombieBody->SetLinearVelocity(b2Vec2(0, 0));
        m_zombieBody->SetAngularVelocity(0);
        
        [AUDIO playEffect:l4_jump];
        
        velZero = false;
        
        runidle = false;
        
        // apply linear impulse to make my zombie jump
        if (IS_IPHONE)  { m_zombieBody->ApplyLinearImpulse(b2Vec2(0.0f, kJumpImpulse/1.5), m_zombieBody->GetWorldCenter()); }
        else            { m_zombieBody->ApplyLinearImpulse(b2Vec2(0.0f, kJumpImpulse), m_zombieBody->GetWorldCenter()); }
    
         [[m_zombieCostume robot_]ACTION_StopAllPartsAnimations_Clean:YES];
        [m_zombieCostume JOE_JUMP_FORLevel:4];
    }
}

-(void)GAME_RESUME
{
    pause = false;
    
    [self resumeSchedulerAndActions];
    
    for (CCNode *ch in [self children])
    {
        [ch resumeSchedulerAndActions];
        for (CCNode *c in [ch children])
        {
            [c resumeSchedulerAndActions];
            for (CCNode *c_ in [c children])
            {
                [c_ resumeSchedulerAndActions];
                
            }
        }
    }
}

-(void)GAME_PAUSE
{
    if (pause)
        return;
    
    pause = true;
    
    [self unschedule:@selector(GAME_PAUSE)];
    
    [self pauseSchedulerAndActions];
    
    for (CCNode *ch in [self children])
    {
        [ch pauseSchedulerAndActions];
        for (CCNode *c in [ch children])
        {
            [c pauseSchedulerAndActions];
            for (CCNode *c_ in [c children])
            {
                [c_ pauseSchedulerAndActions];
                
            }
        }
    }
}

-(void)showTut_6
{
    Tutorial *tut = [[[Tutorial alloc]init]autorelease];
    tut.position = ccp(kWidthScreen/2, kHeightScreen/2);
    [_hud addChild:tut z:0 tag:9934];
    [tut TAP_TutorialRepeat:1 delay:0.5f runAfterDelay:1.5f];
}

- (id)initWithHUD:(InGameButtons *)hud
{
    if ((self = [super init])) {
        _hud = hud;
        
        CCLOG(@"%@: %@.", NSStringFromSelector(_cmd), self);
    
        //  [cfg addInGameButtonsFor:self];
        
        // ITEMS -----------------------
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
        items =                         [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"Level6%@.pvr.ccz",    [self prefix]]];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"Level6%@.plist",      [self prefix]]];
        [self addChild:items z:20];
        
        
		// enable touches
		self.isTouchEnabled = YES;
        
        [self createWorld];
        [self createRoom];
        [self createWorldBackgrounds];
        [self createNewBall];
        [self createNewPlatform];
        [self createWorldDetails];
        [self playerBorn];
        
        
        [_hud preloadBlast_self:self brainNr:3 parent:self];
        
        
        // *** set brain positions
        
        [_hud BRAIN_:TAG_BRAIN_1 position:brain1.position parent:self];
        [_hud BRAIN_:TAG_BRAIN_1 zOrder:120 parent:self];
        
        [_hud BRAIN_:TAG_BRAIN_2 position:brain2.position parent:self];
        [_hud BRAIN_:TAG_BRAIN_2 zOrder:120 parent:self];
        
        [_hud BRAIN_:TAG_BRAIN_3 position:brain3.position parent:self];
        [_hud BRAIN_:TAG_BRAIN_3 zOrder:120 parent:self];
        
        
        [self createBrains];
        [self scheduleUpdate];
        
       // [self runAction:[CCFollow actionWithTarget: m_zombieCostume worldBoundary:CGRectMake(0,0,kWidthScreen,kHeightScreen*4)]];
        [self runAction:[CCFollowDynamic actionWithTarget:m_zombieCostume worldBoundary:CGRectMake(0,0,kWidthScreen,kHeightScreen*4) smoothingFactor:0.1 nodePlace:0.5f]];
        
        if (_hud.tutorialSHOW)
        {
            pause = YES;
            [self schedule:@selector(GAME_PAUSE) interval:0.1f];
        }
        
        over = true;
        
        pBounce = -5;
        
        pBounce = false;
        
        [m_zombieCostume JOE_flipX: YES];
        
        // Create contact listener -------------------
        _contactListener = new MyContactListener();
        m_world->SetContactListener(_contactListener);
        
        if (![Combinations checkNSDEFAULTS_Bool_ForKey:C_TUTORIAL_(_hud.level)]){
        [cfg runSelectorTarget:self selector:@selector(showTut_6) object:nil afterDelay:1 sender:self];
        }
        
    
        /*
        // Enable debug draw -------------------------
        _debugDraw = new GLESDebugDraw( PTM_RATIO );
        m_world->SetDebugDraw(_debugDraw);
        
        uint32 flags = 0;
        flags += GLESDebugDraw::e_shapeBit;
        _debugDraw->SetFlags(flags);
        // -------------------------------------------
         */
  
      //  [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"level3.mp3" loop:YES];
    }
	return self;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//----------------------------------------- DEALLOC ---------------------

-(void)onEnter{
    
    [super onEnter];
    
}

-(void)onExit{
    
    [super onExit];
    
}

- (void) dealloc
{
	delete m_world;
  //  delete _debugDraw;
    delete _contactListener;
    
	m_world = NULL;

	[super dealloc];
}
@end
