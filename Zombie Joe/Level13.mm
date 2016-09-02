//
//  HelloWorldLayer.mm
//  Level13
//
//  Created by macbook on 2013-06-15.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "Level13.h"
#import "cfg.h"
#import "constants_l7.h"  
#import "BrainsBonus.h"
#import "LHSettings.h"
#import "Tutorial.h"

#import "SimpleAudioEngine.h"

#define UP_DOWN     1
#define RIGHT_LEFT  2

#define UP 10
#define DOWN 11
#define RIGHT 12
#define LEFT 13

#define TAG_BG      12
#define TAG_RECT    14
#define TAG_EXIT    15
#define TAG_SNAKE   16
#define TAG_BRAIN1  17
#define TAG_BRAIN2  18
#define TAG_BRAIN3  19

#define TAG_MAGNET  20

#define TAG_NOF_FALLOW_BODY 101001

#define WAY_1 1
#define WAY_2 2

#define LAUNCH_CENTER  1
#define LAUNCH_LEFT    2
#define LAUNCH_RIGHT   3
#define LAUNCH_UP      4
#define LAUNCH_DOWN    5

#define BLOCK_MAX 11

#define dragBODYTYPE NO

#define ACTOR_BLOCK_MAIN         [loader spriteWithUniqueName:@"BLOCK_MAIN"]
#define ACTOR_BLOCK_TEST         [loader spriteWithUniqueName:@"B2"]
#define ACTOR_BLOCK_RECT         [loader spriteWithUniqueName:@"rect"]
#define ACTOR_EXIT               [loader spriteWithUniqueName:@"exit"]
#define ACTOR_BLOCK_JOE          [loader spriteWithUniqueName:@"B1"]
#define ACTOR_ZOMBIE             [loader spriteWithUniqueName:@"zombie"]
#define ACTOR_SNAKE              [loader spriteWithUniqueName:@"snake"]
#define ACTOR_BRAIN1             [loader spriteWithUniqueName:@"BRAIN_1"]
#define ACTOR_BRAIN2             [loader spriteWithUniqueName:@"BRAIN_2"]
#define ACTOR_BRAIN3             [loader spriteWithUniqueName:@"BRAIN_3"]
#define ACTOR_QUEST_BOX          [loader spriteWithUniqueName:@"BLOCK_QUEST"]

#define LAYER_MAIN                 [loader layerWithUniqueName:@"MAIN_LAYER"]

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO [LevelHelperLoader pointsToMeterRatio]//32

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};


// HelloWorldLayer implementation
@implementation Level13

//+(CCScene *) scene
//{
//    
//	// 'scene' is an autorelease object.
//	CCScene *scene = [CCScene node];
//	
//	// 'layer' is an autorelease object.
//	HelloWorldLayer *layer = [HelloWorldLayer node];
//	
//	// add layer as a child to scene
//	[scene addChild: layer];
//	
//	// return the scene
//	return scene;
//}

// on "init" you need to initialize your instance


-(NSInteger)MyRandomIntegerBetween:(int)min :(int)max {
    return ( (arc4random() % (max-min+1)) + min );
}


-(void)QUEST_MAIN:(LHContactInfo*)contact
{
  //  NSLog(@"collided QUEST WITH MAIN");
    if (contact.contactType == LH_BEGIN_CONTACT)
    {
  //      NSLog(@"begin contact");
    }

}

-(void) draw
{
    return;
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
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);

	
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
}

-(int)legalMoveForActor:(CCNode*)actor_{
    
    if      (actor_.tag==1) //main block with zombie    //B1
        return RIGHT_LEFT;
   else if (actor_.tag==2)      //B2
        return UP_DOWN;
   else if (actor_.tag==3)      //B3
       return RIGHT_LEFT;
   else if (actor_.tag==4)      //B4
       return UP_DOWN;
   else if (actor_.tag==5)      //B5
       return UP_DOWN;
   else if (actor_.tag==6)      //B6
       return RIGHT_LEFT;
   else if (actor_.tag==7)      //B7
       return RIGHT_LEFT;
   else if (actor_.tag==8)      //B8
       return UP_DOWN;
   else if (actor_.tag==9)      //B9
       return RIGHT_LEFT;
   else if (actor_.tag==10)     //B10
       return UP_DOWN;
   else if (actor_.tag==11)     //B11
       return UP_DOWN;
    
    return 0;
}



-(CGPoint)newPositionByActor:(LHSprite*)actor_ location:(CGPoint)location_ direction_:(int)direction{
    int ptm = 1;
    
    if (dragBODYTYPE)
    {
        ptm = PTM_RATIO;
    }
    
    if   (direction==RIGHT_LEFT)
    {
        return          ccpAdd(CGPointMake( location_.x/ptm,   actor_.position.y/ptm),
                               CGPointMake( whereTouch.x/ptm,  0));
    }
    
    else if (direction==UP_DOWN)
    {
        return          ccpAdd(CGPointMake(actor_.position.x/ptm,   location_.y/ptm),
                               CGPointMake(0,                             whereTouch.y/ptm));
    }
    
    return CGPointMake(0, 0);
}

-(int)WhatWasTheLastDirection:(CGPoint)before_ now:(CGPoint)now_ legasMoveSides:(int)legalSides_{
    
   // CGPoint sub = ccpSub(before_, now_);
    
    if (legalSides_ == RIGHT_LEFT) {
        
        if (before_.x < now_.x)
        {
            return RIGHT;
        }
        else if (before_.x > now_.x)
        {
            return LEFT;
        }
    }
    
    else if (legalSides_ == UP_DOWN){
        if (before_.y < now_.y)
        {
            return UP;
        }
        if (before_.y > now_.y)
        {
            return DOWN;
        }
        
    }
    
    return 0;
}

-(CGPoint)checkMainBoundary:(CGPoint)newP{
    
    float left = ACTOR_BLOCK_RECT.position.x-(ACTOR_BLOCK_RECT.boundingBox.size.width/2)+(touchedNode.boundingBox.size.width/2);
    if (newP.x < left)      {
        newP.x = left;
    }

    float right = ACTOR_BLOCK_RECT.position.x+(ACTOR_BLOCK_RECT.boundingBox.size.width/2)-(touchedNode.boundingBox.size.width/2);
    if (newP.x > right)     {
        newP.x = right;
    }

    float top = ACTOR_BLOCK_RECT.position.y+(ACTOR_BLOCK_RECT.boundingBox.size.height/2)-(touchedNode.boundingBox.size.height/2);
    if (newP.y > top)       {
        newP.y = top;
    }

    float bottom = ACTOR_BLOCK_RECT.position.y-(ACTOR_BLOCK_RECT.boundingBox.size.height/2)+(touchedNode.boundingBox.size.height/2);
    if (newP.y < bottom)    {
        newP.y = bottom;
    }
    return newP;
}


-(float)addHaflofnodeByTag:(CCNode*)c_{
    
//    int side = [self legalMoveForActor:c_];
//    float wh = 0;
    if (directionForSprite == RIGHT_LEFT)
    {
        if (c_.position.x < touchedNode.position.x)
        {
            return touchedNode.boundingBox.size.width/2;
        }
        else if (c_.position.x > touchedNode.position.x)
        {
            return -(touchedNode.boundingBox.size.width/2);
        }
    }
    
   else if (directionForSprite == UP_DOWN)
    {
        if (c_.position.y > touchedNode.position.y)
        {
            return -(touchedNode.boundingBox.size.height/2);
        }
        else if (c_.position.y < touchedNode.position.y)
        {
            return (touchedNode.boundingBox.size.height/2);
        }
    }
    
    //minus or plus
    return 0;
    
}

-(float)checkSideDistanceWith_WAY:(int)way_ startPos:(CGPoint)workPoint dir:(int)dir_ launchSide:(int)launch coeff:(float)coef_{
    
    CGPoint startPoint = workPoint;
    
    float p = 0;
    
    float V_COEEFF = coef_;//3;//5;
    
    CGPoint vec = ccp(0, 0);
    
    CGPoint vec1 = ccp(0, 0);
    CGPoint vec2 = ccp(0, 0);
    
    if (dir_==RIGHT_LEFT)
    {
        vec1 = ccp(V_COEEFF, 0);
        vec2 = ccp(-V_COEEFF, 0);
    }
    
    else if (dir_==UP_DOWN)
    {
        vec1 = ccp(0, V_COEEFF);
        vec2 = ccp(0, -V_COEEFF);
    }
    
    if (way_ == WAY_1)
    {
        vec = vec1;
    }
    else if (way_ == WAY_2)
    {
        vec = vec2;
    }
    
    if (launch==LAUNCH_CENTER)
    {
        workPoint = workPoint;      //from center vector
    }
    
    else if (launch==LAUNCH_UP)   //from left vector
    {
        if (dir_==RIGHT_LEFT)
        {
            workPoint = ccpAdd(workPoint, ccp(0,ACTOR_BLOCK_TEST.boundingBox.size.width*0.45f));
            //BLOCK TEST B2 ->NOT DELETE IT !!! IT's LONG VERTICAL BLOCK !!!!!!!!!!!!!!!!!!
        }
    }
    else if (launch==LAUNCH_DOWN)
    {
        if (dir_==RIGHT_LEFT)
        {
            workPoint = ccpAdd(workPoint, ccp(0,-(ACTOR_BLOCK_TEST.boundingBox.size.width*0.45f)));
        }
    }
    
    else if (launch==LAUNCH_LEFT)   //top left 
    {
        if (dir_==UP_DOWN)
        {
            workPoint = ccpAdd(workPoint, ccp(-(ACTOR_BLOCK_TEST.boundingBox.size.width*0.45f),0));
        }
    }
    else if (launch==LAUNCH_RIGHT)   
    {
        if (dir_==UP_DOWN)
        {
            workPoint = ccpAdd(workPoint, ccp((ACTOR_BLOCK_TEST.boundingBox.size.width*0.45f),0));
        }
    }
    
    CGPoint workPointFixed = workPoint;
    
    
    for (int x = 0 ; x < ACTOR_BLOCK_RECT.boundingBox.size.width/V_COEEFF; x++)
    {
        workPoint = ccpAdd(workPoint, vec);
        
        for (int c = 1; c <= BLOCK_MAX; c++)
        {
            if (c==touchedTAG) continue;
                //LHSprite *actor in  [loader allSprites]
            LHSprite *s = [loader spriteWithUniqueName:[NSString stringWithFormat:@"B%i",c]];
            
            if (CGRectContainsPoint(s.boundingBox, workPoint))
            {
            //    NSLog(@"found COLLIDER in %f %f with BLOCK %i",workPoint.x,workPoint.y,c);
                
                //check the distance
                
       
                
                if (dir_==RIGHT_LEFT)
                {
                    p = s.position.x;
                    p+=[self addHaflofnodeByTag:s];
                    p+=[self giveHalfOfDraggedNodeMovedOn:s];
                  //   [self giveHalfOfDraggedNodeMovedOn:s];   
                    //p = workPoint.x;
//                    p=s.position.x+([self addHaflofnodeByTag:s collisionPos:s.position]/2);
//                    p=p+[self addHaflofnodeByTag:s collisionPos:s.position];//workPoint];

                    return p;
                    
                }
                else if (dir_==UP_DOWN)
                {
                   // p = workPoint.y;//-(touchedNode.boundingBox.size.height/2);
//                    p=s.position.y+([self addHaflofnodeByTag:s collisionPos:s.position]/2);
//                    p=p+[self addHaflofnodeByTag:s collisionPos:s.position];//workPoint];
                    p = s.position.y;
                    p+=[self addHaflofnodeByTag:s];
                    p+=[self giveHalfOfDraggedNodeMovedOn:s];
                    return p;
                }
            }
        }
        
    }
    return p;
}

-(float)giveHalfOfDraggedNodeMovedOn:(CCNode*)c_{

    float w = c_.boundingBox.size.width/2;
    float h = c_.boundingBox.size.height/2;
    float wh = 0;
    if (w < h) {
        wh = w;
    }
    else wh = h;
    
    if ([self legalMoveForActor:touchedNode] == RIGHT_LEFT) {
        if (touchedNode.position.x > c_.position.x) {
            return wh;
        }
        else return -wh;
    }
    else if ([self legalMoveForActor:touchedNode] == UP_DOWN) {
        if (touchedNode.position.y < c_.position.y) {
            return -wh;
        }
        else return wh;
    }
    return 0;
}

- (float) smallestOf: (float) a andOf: (float) b andOf: (float) c
{
    if (a==0)a = 1000;
    if (b==0)b = 1000;
    if (c==0)c = 1000;
    
    float min = a;
    
    if ( b < min )
        min = b;
    
    if( c < min )
        min = c;
    
    return min;
}

- (float) bigestOf: (float) a andOf: (float) b andOf: (float) c
{
    float max = a;
    
    if ( b > max )
        max = b;
    
    if( c > max )
        max = c;
    
    return max;
}

-(CGPoint)getLimmitPointsForNode:(CCNode*)node_ withDirection:(int)dir_{  //TWO X:X or Y:Y
    
    //nearest <--- and nearrest ---> or up---down
    float pos1 = 0;
    float pos2 = 0;
    
    if (dir_==RIGHT_LEFT)
    {
        float pos1a = [self checkSideDistanceWith_WAY:WAY_1 startPos:node_.position dir:dir_ launchSide:LAUNCH_CENTER coeff:20];
        float pos1b = 0;//[self checkSideDistanceWith_WAY:WAY_1 startPos:node_.position dir:dir_ launchSide:LAUNCH_UP];
        float pos1c = 0;//[self checkSideDistanceWith_WAY:WAY_1 startPos:node_.position dir:dir_ launchSide:LAUNCH_DOWN];
        
        pos1 = [self smallestOf:pos1a andOf:pos1b andOf:pos1c];
        
        float pos2a = [self checkSideDistanceWith_WAY:WAY_2 startPos:node_.position dir:dir_ launchSide:LAUNCH_CENTER coeff:20];
        float pos2b = 0;//[self checkSideDistanceWith_WAY:WAY_2 startPos:node_.position dir:dir_ launchSide:LAUNCH_UP];
        float pos2c = 0;//[self checkSideDistanceWith_WAY:WAY_2 startPos:node_.position dir:dir_ launchSide:LAUNCH_DOWN];
        
        pos2 = [self bigestOf:pos2a andOf:pos2b andOf:pos2c];
        
        
        
    //    NSLog(@"A: DIRECTION RIGHT-LEFT FOUND LIMMITS:---> posa posb posc %f %f %f. biggest is %f",pos1a,pos1b,pos1c,pos1);
    //    NSLog(@"B: DIRECTION RIGHT-LEFT FOUND LIMMITS:---> posa posb posc %f %f %f. biggest is %f",pos2a,pos2b,pos2c,pos2);
    }
    
    else if (dir_==UP_DOWN)
    {
        float pos1a = [self checkSideDistanceWith_WAY:WAY_1 startPos:node_.position dir:dir_ launchSide:LAUNCH_CENTER coeff:20];
        float pos1b = 0;//[self checkSideDistanceWith_WAY:WAY_1 startPos:node_.position dir:dir_ launchSide:LAUNCH_LEFT];
        float pos1c = 0;//[self checkSideDistanceWith_WAY:WAY_1 startPos:node_.position dir:dir_ launchSide:LAUNCH_RIGHT];
        
        pos1 = [self smallestOf:pos1a andOf:pos1b andOf:pos1c];
        
        float pos2a = [self checkSideDistanceWith_WAY:WAY_2 startPos:node_.position dir:dir_ launchSide:LAUNCH_CENTER coeff:20];
        float pos2b = 0;//[self checkSideDistanceWith_WAY:WAY_2 startPos:node_.position dir:dir_ launchSide:LAUNCH_LEFT];
        float pos2c = 0;//[self checkSideDistanceWith_WAY:WAY_2 startPos:node_.position dir:dir_ launchSide:LAUNCH_RIGHT];
        
        pos2 = [self bigestOf:pos2a andOf:pos2b andOf:pos2c];
        
    //    NSLog(@"A: DIRECTION UP-DOWN FOUND LIMMITS:---> posa posb posc %f %f %f. biggest is %f",pos1a,pos1b,pos1c,pos1);
    //    NSLog(@"B: DIRECTION UP-DOWN FOUND LIMMITS:---> posa posb posc %f %f %f. biggest is %f",pos2a,pos2b,pos2c,pos2);
    }
    
    return CGPointMake(pos1, pos2);
    
}

-(BOOL)checkIfOnExitWay{
    
    //ACTOR_EXIT ACTOR_BLOCK_JOE
    //check only if joe pos is > kWidth * 0.75
    
    if (CGRectIntersectsRect(ACTOR_BLOCK_JOE.boundingBox, ACTOR_EXIT.boundingBox))
    {
    //    NSLog(@"on the exit ! ");
        canMove = NO;
        return YES;
    }
    return NO;
}

-(void)foundAwayOutAnimation{
    
    [AUDIO playEffect:fx_winmusic];
    
    [ACTOR_BLOCK_JOE stopAllActions];
    
    id moveFewSteps = [CCMoveTo actionWithDuration:0.35f
    position:ccpAdd(ccp(ACTOR_BLOCK_RECT.position.x, ACTOR_BLOCK_JOE.position.y),
                    ccp(ACTOR_BLOCK_RECT.boundingBox.size.width/2, 0))];
    
    id delay1 = [CCDelayTime actionWithDuration:0.35f];
    id offFallowQuestionBox = [CCCallBlock actionWithBlock:^(void){
        
        questionFallowBox = NO;
        
    }];
    id blockOff = [CCJumpBy actionWithDuration:0.5f
                                      position:ccp(-ACTOR_BLOCK_JOE.boundingBox.size.width*2.5f,
                                                    -kHeightScreen*0.75)
                                        height:ACTOR_BLOCK_JOE.boundingBox.size.width
                                         jumps:1];
    
    id blockSeq = [CCSequence actions:delay1,offFallowQuestionBox,blockOff, nil];
    
    id moveBoxOut = [CCMoveBy actionWithDuration:1.f position:ccp(kWidthScreen*0.35f, 0)];
    
    id win = [CCCallBlock actionWithBlock:^(void)
              {
             //     NSLog(@"LEVEL WON");
                  [_hud TIME_Stop];
                  [_hud WINLevel];
              }];
    
    [ACTOR_QUEST_BOX runAction:blockSeq];
    
    [ACTOR_BLOCK_JOE runAction:[CCSequence actions:moveFewSteps,
                               [CCDelayTime actionWithDuration:0.5f],
                               moveBoxOut,win, nil]];
    
    
    /*
    //questionFallowBox
    return;
    
    id move = [CCMoveBy actionWithDuration:1.f position:ccp(ACTOR_EXIT.boundingBox.size.width*2, 0)];
    
    id win = [CCCallBlock actionWithBlock:^(void)
    {
        NSLog(@"LEVEL WON");
        [_hud TIME_Stop];
        [_hud WINLevel];
    }];
    
    id seq = [CCSequence actions:move,win, nil];
    
    [ACTOR_BLOCK_JOE runAction:seq];
     */
    
}


-(void)jumpToBrainLine:(CCNode*)node_{
    
    id jump = [CCMoveTo actionWithDuration:0.5f position:ccp(screenSize.width*0.9f,
                                                          screenSize.height*0.9f)];
    
    id fadeOut = [CCFadeOut actionWithDuration:0.1f];
    
    
    id increaseNUM = [CCCallBlock actionWithBlock:^(void)
    {
      //  NSLog(@"increase brain nr ");
        [_hud increaseBRAINSNUMBER];
    }];
    
    id spawn =  [CCSequence actions:[CCDelayTime actionWithDuration: 0.4f],fadeOut, nil];
    
    id spawn2 = [CCSpawn actions:spawn,jump, nil];
    
    id seq = [CCSequence actions:spawn2,increaseNUM, nil];
    
    [node_ runAction:seq];
    
    
}

-(CGRect)ifTouchedONSIZEDRECT:(CCNode*)node_ resizedTimes:(int)times{
    
    CGRect f = [node_ boundingBox];
    f.size.width = f.size.width*times;
    f.size.height = f.size.height*times;
    f.origin.x = f.origin.x - f.size.width/2;
    f.origin.y = f.origin.y - f.size.height/2;
    return f;
    
}

-(void)ifTouchedOnBrain:(CGPoint)loc_{
    
    if(CGRectContainsPoint([ACTOR_BRAIN1 boundingBox],loc_) && !brain1)
    {
        brain1  = YES;
         [ACTOR_BRAIN1.parent reorderChild:ACTOR_BRAIN1 z:10];
        
        [_hud BRAIN_:TAG_BRAIN_1 zOrder:10 parent:LAYER_MAIN];
        
        
         [cfg makeBrainActionForNode:[LAYER_MAIN getChildByTag:TAG_BRAIN_1] fakeBrainsNode:nil direction:0 pixelsToMove:1 time:0.1f parent:self removeBrainsAfter:YES makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
     //   NSLog(@"increase brain brain 1");
       // [self jumpToBrainLine:ACTOR_BRAIN1];
    }
    
   else if(CGRectContainsPoint([ACTOR_BRAIN2 boundingBox],loc_) && !brain2)
    {
        brain2  = YES;
         [ACTOR_BRAIN2.parent reorderChild:ACTOR_BRAIN2 z:10];
        
         [_hud BRAIN_:TAG_BRAIN_2 zOrder:10 parent:LAYER_MAIN];
        
        [cfg makeBrainActionForNode:[LAYER_MAIN getChildByTag:TAG_BRAIN_2] fakeBrainsNode:nil direction:0 pixelsToMove:1 time:0.1f parent:self removeBrainsAfter:YES makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
        // [self jumpToBrainLine:ACTOR_BRAIN2];
        //NSLog(@"increase brain brain 2");
    }
    
   else if(CGRectContainsPoint([ACTOR_SNAKE boundingBox],loc_) && !snakeBrain)
    {
        snakeBrain = YES;
        //NSLog(@"brain 3");
       // ACTOR_BRAIN3.position = ACTOR_SNAKE.position;
        
        //[ACTOR_BRAIN3.parent reorderChild:ACTOR_BRAIN3 z:10];
       [_hud BRAIN_:TAG_BRAIN_3 zOrder:10 parent:LAYER_MAIN];
        
        [cfg makeBrainActionForNode:[LAYER_MAIN getChildByTag:TAG_BRAIN_3] fakeBrainsNode:nil direction:0 pixelsToMove:100 time:0.3f parent:self removeBrainsAfter:YES makeActionAfterall:@selector(increaseBRAINSNUMBER) target:_hud];
        //[self jumpToBrainLine:ACTOR_BRAIN3];
    }
    
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    wasMoved = NO;
    
    if (!canTouch) {
        return NO;
    }
    
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToGL: location];
    firstTouch = location;
    
    if (!canMove)
    {
        return NO;
    }
    
    for (LHSprite *actor in  [loader allSprites])
    {
        if(CGRectContainsPoint([actor boundingBox],location) && actor.tag !=TAG_BG
                                                             && actor.tag !=TAG_RECT
                                                             && actor.tag !=TAG_EXIT
                                                             && actor.tag !=0
                                                             && actor.tag !=TAG_BRAIN1
                                                             && actor.tag !=TAG_BRAIN2
                                                             && actor.tag !=TAG_BRAIN3
                                                             && actor.tag !=TAG_BRAIN_1
           && actor.tag !=TAG_BRAIN_2
           && actor.tag !=TAG_BRAIN_3
           && actor.tag !=TAG_SNAKE)
        {
          //  NSLog(@"touched on actor %i",actor.tag);
            
            whereTouch=ccpSub(actor.position, location);
            
            touchedNode =     actor;
            touchedTAG =      actor.tag;
            
            directionForSprite = [self legalMoveForActor:touchedNode];                                      // UPDOWN : LEFTRIGHT
            
            limmitBoxPos =       [self getLimmitPointsForNode:touchedNode withDirection:directionForSprite];
            
          //  NSLog(@"limmits will be %f %f",limmitBoxPos.x,limmitBoxPos.y);
         
            return YES;
        }
 
    }

    [self ifTouchedOnBrain:location];   //after all block filter check for brain TOUCH
    
    return NO;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
    if (!canMove)
    {
        return;
    }
    CGPoint location = [touch locationInView:[touch view]];
    
    location = [[CCDirector sharedDirector] convertToGL:location];
    
     //   int newDirectionType = [self WhatWasTheLastDirection:lastDirection now:location legasMoveSides:directionForSprite];
    
        CGPoint newP =  [self newPositionByActor:touchedNode location:location direction_:directionForSprite];
    

    if (dragBODYTYPE)
    {
      //  [touchedNode body]->SetTransform(b2Vec2(newP.x, newP.y), 0);
    }
    
    else {
        
        if ([self checkIfOnExitWay])
        {
            [self foundAwayOutAnimation];
            [_hud TIME_Stop];
            return;
        }
        
        //LESF BOUND
        
        newP = [self checkMainBoundary:newP];
        
        
        //check BY INDUVIDEUAL BOX BOUNDRIES
        //x
        
        if (directionForSprite == RIGHT_LEFT)
        {
            if (limmitBoxPos.x !=0) //right side check
            {
                if (newP.x > limmitBoxPos.x) {
                    newP.x = limmitBoxPos.x;
                }
            }
            if (limmitBoxPos.y !=0) //left side check
            {
                if (newP.x < limmitBoxPos.y) {
                    newP.x = limmitBoxPos.y;
                }
            }
        }
        else if (directionForSprite == UP_DOWN)
        {
            if (limmitBoxPos.x !=0) //up
            {
                if (newP.y > limmitBoxPos.x) {
                    newP.y = limmitBoxPos.x;
                }
            }
            if (limmitBoxPos.y !=0) //down
            {
                if (newP.y < limmitBoxPos.y) {
                    newP.y = limmitBoxPos.y;
                }
            }
        }
        wasMoved = YES;
        touchedNode.position = newP;
    }
    
}

-(LHSprite*)getMagnetWhichIsNearrest{
    
    //one and second points [a    b]

    
    LHSprite *nearestOne = touchedNode;
    int side = [self legalMoveForActor:touchedNode];
    
    float dist = 10000;
    for (LHSprite *s in [self children]) {
        if (s.tag == TAG_MAGNET) {
            
            float distanceBetweenA  = 0;
            float distanceBetweenB  = 0;
            
            if (side == RIGHT_LEFT) {   //[a
            distanceBetweenA=
            ccpDistance(ccp(touchedNode.position.x-(touchedNode.boundingBox.size.width/2),touchedNode.position.y), s.position);
            distanceBetweenB=
            ccpDistance(ccp(touchedNode.position.x+(touchedNode.boundingBox.size.width/2),touchedNode.position.y), s.position);
            }
            
           else  if (side == UP_DOWN) {     //a- UP | b- down
               distanceBetweenA=
               ccpDistance(ccp(touchedNode.position.x,touchedNode.position.y+(touchedNode.boundingBox.size.width/2)), s.position);
               distanceBetweenB=
               ccpDistance(ccp(touchedNode.position.x,touchedNode.position.y-(touchedNode.boundingBox.size.width/2)), s.position);
            }
           
            // *** final conclusion
            if ((distanceBetweenA < distanceBetweenB) && distanceBetweenA < dist)
            {
                dist = distanceBetweenA;
                nearestOne = s;
            }
            else if ((distanceBetweenB < distanceBetweenA) && distanceBetweenB < dist)
            {
                dist = distanceBetweenB;
                nearestOne = s;
            }
            
            
        }
    }
    
  //  NSLog(@"The nearest is %@. dist %f",nearestOne,dist);
    return nearestOne;
}

-(int)onWhatSideIsMagnet:(LHSprite*)mag_{
    
    if ([self legalMoveForActor:touchedNode] == RIGHT_LEFT) {
        if      (touchedNode.position.x < mag_.position.x) {
       //     NSLog(@"right side");
            return 2;
        }
        else if (touchedNode.position.x >= mag_.position.x) {
        //    NSLog(@"left side");
            return 1;
        }
    }
    else if ([self legalMoveForActor:touchedNode] == UP_DOWN) {
        if      (touchedNode.position.y < mag_.position.y) {
        //    NSLog(@"up side");
            return 3;
        }
        else if (touchedNode.position.y >= mag_.position.y) {
        //    NSLog(@"down side");
            return 4;
        }
    }
    return 0;
}

-(BOOL)isItLongBlock:(CCNode*)b_{
    
     int nrOfBlocksInRow = 6;
     float miniBlockWH = (ACTOR_BLOCK_RECT.boundingBox.size.width/nrOfBlocksInRow);
    if (b_.boundingBox.size.height > miniBlockWH*2) {
        return YES;
    }
    return NO;
    
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
    if (!wasMoved) {
        return;
    }
    
    CGPoint location = [touch locationInView:[touch view]];
    
    location = [[CCDirector sharedDirector] convertToGL:location];
    if (ccpDistance(location, firstTouch) <= 1 ) {
        return;
    }
    
    if (touchedNode==nil) {
        
        return;
    }
    

    canMakeSoundMove = YES;
    [self BlockHaveBeenDragged];
     
}

-(void)BlockHaveBeenDragged{
    
    if (canMakeSoundMove) {
            [AUDIO playEffect:l1_itemclick];
        canMakeSoundMove = NO;
    }

    
    LHSprite *nearest = [self getMagnetWhichIsNearrest];
    
    int side =          [self onWhatSideIsMagnet:nearest];   //  1 left  |  2 right |  3 up |  4 down
    
    CGPoint fi = ccp(0, 0);
    
    int nrOfBlocksInRow = 6;
    
    float miniBlockWH = (ACTOR_BLOCK_RECT.boundingBox.size.width/nrOfBlocksInRow);
    
    
    if (side == 1) {
        fi = ccpAdd(nearest.position, ccp(touchedNode.boundingBox.size.width/2-(miniBlockWH/2), 0));
    }
    else if (side == 2) {
        fi = ccpAdd(nearest.position, ccp(-touchedNode.boundingBox.size.width/2+(miniBlockWH/2), 0));
    }
    
    else if (side == 3) {
        if ([self isItLongBlock:touchedNode]) {
            fi = nearest.position;//ccpAdd(nearest.position, ccp(0,-touchedNode.boundingBox.size.height/2+(miniBlockWH/2)));
        }
        else{
            fi = ccpAdd(nearest.position, ccp(0,-touchedNode.boundingBox.size.height/2+(miniBlockWH/2)));
        }
        
    }
    else if (side == 4) {
        if ([self isItLongBlock:touchedNode]) {
            fi = nearest.position;
        }
        else{
            fi = ccpAdd(nearest.position, ccp(0,touchedNode.boundingBox.size.height/2-(miniBlockWH/2)));
        }
        
    }
    canTouch = NO;
    id move =  [CCMoveTo actionWithDuration:0.15f position:fi];
    id move_ = [CCEaseInOut actionWithAction:move rate:2.f];
    id unblock= [CCCallBlock actionWithBlock:^(void){canTouch = YES;}];
    [touchedNode runAction:[CCSequence actions:move_,unblock, nil]];
    
   // NSLog(@"go to : %f %f",fi.x,fi.y);
    
    touchedNode = nil;

}

-(void)mainBoxFallowBLOCK_MAIN:(ccTime)dt{
    
    ACTOR_BLOCK_MAIN.position = ccpAdd(ACTOR_BLOCK_JOE.position,
                                   ccp(ACTOR_BLOCK_MAIN.boundingBox.size.width/2, 0));
    
    ACTOR_ZOMBIE.position = ccpAdd(ACTOR_BLOCK_JOE.position,
                                   ccp(-ACTOR_ZOMBIE.boundingBox.size.width*0.8f, 0));
    
    if (questionFallowBox) ACTOR_QUEST_BOX.position = ACTOR_BLOCK_MAIN.position;
    //ZOMBIE JOE FALLOW ALSO    
    
    JOE.position =ccpAdd(ACTOR_BLOCK_JOE.position,ccp(-(ACTOR_BLOCK_JOE.boundingBox.size.width*0.25f), 0));

}

-(void)randomPositionForBrains{
    
    int brain1_ = [self MyRandomIntegerBetween:3 :BLOCK_MAX];
    int brain2_ = brain1_;
    
    while (brain1_==brain2_)
    {
        brain2_= [self MyRandomIntegerBetween:3 :BLOCK_MAX];
    }
    
    //NSLog(@"brains will be under blocks %i %i",brain1_,brain2_);
    
  //  NSLog(@"a) %i b) %i",ACTOR_BRAIN1.zOrder,[LAYER_MAIN getChildByTag:TAG_BRAIN_2].zOrder);
    
    [_hud BRAIN_:TAG_BRAIN_1 zOrder:0 parent:LAYER_MAIN];
    [_hud BRAIN_:TAG_BRAIN_2 zOrder:0 parent:LAYER_MAIN];
    [_hud BRAIN_:TAG_BRAIN_3 zOrder:-2 parent:LAYER_MAIN];
    
      
    ACTOR_BRAIN1.visible = NO;
    ACTOR_BRAIN2.visible = NO;
    
  //  ACTOR_BRAIN3.contentSize = CGSizeMake(ACTOR_BRAIN3.contentSize.width*3, ACTOR_BRAIN3.contentSize.height*3);
    ACTOR_BRAIN3.visible = NO;

    ACTOR_BRAIN1.position =  [loader spriteWithUniqueName:[NSString stringWithFormat:@"B%i",brain1_]].position;
    ACTOR_BRAIN2.position =  [loader spriteWithUniqueName:[NSString stringWithFormat:@"B%i",brain2_]].position;
    ACTOR_BRAIN3.position =  ACTOR_SNAKE.position;
    
    [LAYER_MAIN getChildByTag:TAG_BRAIN_1].position = ACTOR_BRAIN1.position ;
    [LAYER_MAIN getChildByTag:TAG_BRAIN_2].position = ACTOR_BRAIN2.position ;
    [LAYER_MAIN getChildByTag:TAG_BRAIN_3].position = ACTOR_SNAKE.position ;
    
}

-(void)addPointsForBlock{
    
    int nrOfBlocksInRow = 6;
    int nrOfAllblocks   = 6*6;
    
    float posZerox = ACTOR_BLOCK_RECT.position.x-ACTOR_BLOCK_RECT.boundingBox.size.width/2;
    float posZeroy = ACTOR_BLOCK_RECT.position.y-ACTOR_BLOCK_RECT.boundingBox.size.height/2;
    
    float miniBlockWH = (ACTOR_BLOCK_RECT.boundingBox.size.width/nrOfBlocksInRow);
    float y_ = 1;
    float x_=0;
    
    for (int x = 0; x < nrOfAllblocks; x++)
    {
        x_++;
        
        float f = (float)x/6;
        int f_= x /6;
        float fi = f-f_;
        
        if (fi == 0 && x !=0)
        {
            x_=1;
            y_++;
        }
        LHSprite *point = [loader createSpriteWithName:@"rect"
                                             fromSheet:@"SpritesLevel13"
                                            fromSHFile:@"SpriteSheetLevel13" parent:self];
        
        point.position = ccp(posZerox+(x_*miniBlockWH)-(miniBlockWH/2),
                             posZeroy+(y_*miniBlockWH)-(miniBlockWH/2));
        
        point.tag = TAG_MAGNET;
        point.opacity = 0;
    }
    
}

-(void)TouchedOnBrainByNode:(LHSprite*)n_{
    
    n_.tag = TAG_NOF_FALLOW_BODY;
    [n_ setSensor:YES];
    
}

-(void)touchedOnBrain1:(LHTouchInfo*)info{
    
    [ACTOR_BRAIN1 removeTouchObserver];
    [self TouchedOnBrainByNode:ACTOR_BRAIN1];
    
}

-(void)touchedOnBrain2:(LHTouchInfo*)info{
    
    [ACTOR_BRAIN2 removeTouchObserver];
    [self TouchedOnBrainByNode:ACTOR_BRAIN2];
    
}

-(void)touchedOnBrain3:(LHTouchInfo*)info{
    
    [ACTOR_BRAIN3 removeTouchObserver];
    [self TouchedOnBrainByNode:ACTOR_BRAIN3];
    
}

-(void)fixPositions{
    
    for (LHSprite *actor in  [loader allSprites])
    {
        if (actor.tag >= 1 && actor.tag <=11 && actor.tag !=2) {    //fix positions to allign to points
            
            touchedNode =     actor;
            touchedTAG =      actor.tag;
            
            directionForSprite = [self legalMoveForActor:touchedNode];                                      // UPDOWN : LEFTRIGHT
            
            limmitBoxPos =       [self getLimmitPointsForNode:touchedNode withDirection:directionForSprite];
            [self BlockHaveBeenDragged];
            
        }

    }
    
}

-(void)showParticleSunLight{
    
    CCParticleSystemQuad *effect = [CCParticleSystemQuad particleWithFile:[NSString stringWithFormat: @"l13_blast.plist"/*,kDevice*/]];
    effect.position = ccp(300,300);

    [self addChild:effect z:0];
    effect.scale = 0.3f;
    effect.autoRemoveOnFinish = YES;
    
}

- (id)initWithHUD:(InGameButtons *)hud
{
    if ((self = [super init])) {
        _hud = hud;

		// enable touches
		self.isTouchEnabled = YES;
        
        canMove = YES;
		
		screenSize = [CCDirector sharedDirector].winSize;
        
        

    //    [LevelHelperLoader loadLevelsWithOffset:CGPointMake(0,0)];
        
        if (IS_IPHONE_5 || IS_IPAD)
        {
            [LevelHelperLoader dontStretchArt];  //iphone 5 fix
        }
//        
////        if (IS_IPAD)
//        {
//            CGPoint a = [LHSettings sharedInstance].possitionOffset;
//            //NSLog(@"a %f %f",a.x,a.y);
//            
//           // [[LHSettings sharedInstance] setStretchArt:true];
//            [LevelHelperLoader loadLevelsWithOffset:CGPointMake(0,-(a.y))];
//        }
        
        loader = [[LevelHelperLoader alloc]initWithContentOfFile:@"Level13"];
        
        [loader addObjectsToWorld:world cocos2dLayer:self];
        
        //  [loader createPhysicBoundaries:world];
        
        questionFallowBox = YES;
        
//        ACTOR_BRAIN1.scale = 0.8f;
//        ACTOR_BRAIN2.scale = 0.8f;
//        ACTOR_BRAIN3.scale = 0.8f;
        
        [_hud preloadBlast_self:self brainNr:3 parent:LAYER_MAIN];
        
        
        [self schedule:@selector(mainBoxFallowBLOCK_MAIN:)];
        
        [self randomPositionForBrains];
        
      //  [self addBrainsMoveMents];
        
        ACTOR_BLOCK_JOE.opacity = 0;    //debug block joe off opacity
        ACTOR_ZOMBIE.opacity = 0;
        
        
   //     ACTOR_BRAIN3.position = ACTOR_SNAKE.position;
      //  ACTOR_BRAIN3.visible = NO;
        
        [self addJoe];
        
        [self addPointsForBlock];
        
        canTouch = YES;
        
        [self fixPositions];
        
        if (![Combinations checkNSDEFAULTS_Bool_ForKey:C_TUTORIAL_(_hud.level)])
        {
            [cfg runSelectorTarget:self selector:@selector(showTut_13) object:nil afterDelay:1 sender:self];
        }
        
        //  [self schedule: @selector(tick:)];
	}
	return self;
}

-(void)showTut_13
{
    
    for (int i = 0; i<=3; i++) {
        Tutorial *tut = [[[Tutorial alloc]init]autorelease];
        [_hud addChild:tut z:0 tag:3636];
        switch (i) {
            case 0:
                [tut SWIPE_TutorialWithDirection:SWIPE_LEFT times:1 delay:0.3f runAfterDelay:0];
                tut.position = [loader spriteWithUniqueName:@"B3"].position;
                break;
            case 1:
                [tut SWIPE_TutorialWithDirection:SWIPE_RIGHT times:1 delay:0.3f runAfterDelay:2.f];
                tut.position = [loader spriteWithUniqueName:@"B3"].position;
                break;
            case 2:
                [tut SWIPE_TutorialWithDirection:SWIPE_UP times:1 delay:0.3f runAfterDelay:4.f];
                tut.position = [loader spriteWithUniqueName:@"B5"].position;
                break;
            case 3:
                [tut SWIPE_TutorialWithDirection:SWIPE_DOWN times:1 delay:0.3f runAfterDelay:6.f];
                tut.position = [loader spriteWithUniqueName:@"B5"].position;
                break;
                
            default:
                break;
        }
    }
    
}

-(void)addBrainsMoveMents{
    
    [cfg brainMoveUpdDownAction:ACTOR_BRAIN1];
    [cfg brainMoveUpdDownAction:ACTOR_BRAIN2];
    [cfg brainMoveUpdDownAction:ACTOR_BRAIN3];
    
}

-(void)addJoe{
    
    JOE = [[[GoinCharacter alloc]initWithRect:CGRectMake(0, 0,
                                                    characterW*0.1f, characterH*0.05f)
                                                  tag:999]autorelease];
    
    [self addChild:JOE z:9999];
    
    [JOE hide_shadow:NO];
    
  
    [JOE Action_IDLE_SetDelay:0.3f funForever:YES];
    
    [JOE ACtion_WalkToSceneAndBack:0.5f pos:ccp(7, 0)];
    
}


- (void)onEnter{
    
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [super onEnter];
}


- (void)onExit{
    [self removeAllChildrenWithCleanup:YES];
    
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [super onExit];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	delete world;
	world = NULL;
	
	delete m_debugDraw;

	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
