
#import "Monsters_level9.h"
#import "SConfig.h"
#import "cfg.h"
#import "GB2ShapeCache.h"
#import "Level9.h"

#define BNtag 20
#define monster1 30
#define monster2 40


@implementation Monsters_level9
@synthesize spriteBatchNodeML;

-(void)monster1TailChange
{
    CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [[[self getChildByTag:BNtag] getChildByTag:monster1+4] runAction:
     [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:
      [CCAnimation animationWithFrames:
       [NSArray arrayWithObjects:
        [cache spriteFrameByName:[NSString stringWithFormat:@"2monster5.png"]],[cache spriteFrameByName:[NSString stringWithFormat:@"2monster4.png"]],nil]delay:0.02f] restoreOriginalFrame:NO]]];
}

-(void)animationOf2
{
    id action1 = [CCRotateBy actionWithDuration:0.05f angle:-35];
    
    id action2 = [CCRotateBy actionWithDuration:0.05f angle:35];
    
    [[[self getChildByTag:BNtag] getChildByTag:monster2+1] runAction:[CCSequence actions:[CCEaseInOut actionWithAction:action1 rate:2],[CCDelayTime actionWithDuration:0.8f],[action1 reverse], nil]];
    
    [[[self getChildByTag:BNtag] getChildByTag:monster2+2] runAction:[CCSequence actions:[CCEaseInOut actionWithAction:action2 rate:2],[CCDelayTime actionWithDuration:0.8f],[action2 reverse], nil]];
}


-(void)animationOf1
{
    id action1 = [CCMoveBy actionWithDuration:0.7f position:ccp(-[[[self getChildByTag:BNtag] getChildByTag:monster1] getChildByTag:monster1+3].contentSize.width, 0)];
    
    id action2 = [CCMoveBy actionWithDuration:0.5f position:ccp(0, -[[[self getChildByTag:BNtag] getChildByTag:monster1+1] getChildByTag:monster1+2].contentSize.height/12)];
    
    id action3 = [CCRotateBy actionWithDuration:0.3f angle:10];
    
    [[[[self getChildByTag:BNtag] getChildByTag:monster1] getChildByTag:monster1+3] runAction:[CCRepeatForever actionWithAction:[CCSequence actions:action1,[action1 reverse], nil]]];
    
     [[[[self getChildByTag:BNtag] getChildByTag:monster1+1] getChildByTag:monster1+2] runAction:[CCRepeatForever actionWithAction:[CCSequence actions:action2,[CCDelayTime actionWithDuration:0.7f],[action2 reverse], nil]]];
    
    [[[self getChildByTag:BNtag] getChildByTag:monster1] runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCEaseOut actionWithAction:action3 rate:2],[action3 reverse], nil]]];
    
    //[[[self getChildByTag:BNtag] getChildByTag:monster1+1] runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCEaseIn actionWithAction:[action3 reverse] rate:2],action3, nil]]];
}

-(void)monster2Constr:(b2World*)world_
{
    NSString *string;
    for (int i = 0; i<3; i++) {
        int z0rder = 0;
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"monster%i.png",i]];
        switch (i) {
            case 0:sprite.anchorPoint = ccp(0.5, 0);sprite.position = ccp((sprite.contentSize.width*1.3f)-(IS_IPAD ? 10 : 5),0);z0rder = 1;string = @"monster0"; break;
            case 1:sprite.anchorPoint = ccp(1.0f, 0);sprite.position = ccp((sprite.contentSize.width)-(IS_IPAD ? 10 : 5), [[self getChildByTag:BNtag] getChildByTag:monster2].contentSize.height-3);z0rder = 2;string = @"monster1"; break;
            case 2:sprite.anchorPoint = ccp(0, 0);sprite.position = ccp([[self getChildByTag:BNtag]getChildByTag:monster2].position.x-(sprite.contentSize.width/4)-(IS_IPAD ? 10 : 5),[[self getChildByTag:BNtag] getChildByTag:monster2].contentSize.height-3);z0rder = 3;string = @"monster2";break;
            default:break;
        }
        [[self getChildByTag:BNtag] addChild:sprite z:z0rder tag:monster2+i];
        
        
        [[GB2ShapeCache sharedShapeCache] addShapesWithFile:[NSString stringWithFormat:@"PE_Level9%@.plist",kDevice]];
        
        //b2BodyDef monsterBodyDef;
        //monsterBodyDef.type = b2_kinematicBody;
        //monsterBodyDef.position.Set(sprite.position.x/PTM_RATIO,sprite.position.y/PTM_RATIO);
        //monsterBodyDef.userData = sprite;
        //b2Body *body = world_->CreateBody(&monsterBodyDef);
       // body->SetFixedRotation(true);
        
       // [[GB2ShapeCache sharedShapeCache]addFixturesToBody:body forShapeName:string];

    }
   // [self animationOf2];
}
/*
-(void)update:(ccTime*)dt
{
    for (b2Body* b = world2->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
            
			CCSprite *myActor = (CCSprite*)b->GetUserData();
            
            b->SetTransform(b2Vec2(myActor.position.x/PTM_RATIO,myActor.position.y/PTM_RATIO), -myActor.rotation/PTM_RATIO);
		}
	}
}*/

-(void)monster1Constr:(b2World*)world_
{
    NSString *string;
    for (int i = 0; i<=4; i++) {
        int z0rder = 0;
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"2monster%i.png",i]];
        sprite.opacity = 255;
        switch (i) {
            case 0:sprite.anchorPoint = ccp(1.0f, 0);sprite.position = ccp(sprite.contentSize.width,sprite.contentSize.height/1.2f);z0rder = 4;string = @"head1"; break;//head1
            case 1:sprite.anchorPoint = ccp(1.0f, 0.8f);sprite.position = ccp(sprite.contentSize.width, sprite.contentSize.height);z0rder = 2;string = @"head2"; break;//head2
            case 2:sprite.anchorPoint = ccp(1.0f, 1.0f);sprite.position = ccp(sprite.contentSize.width/1.3, sprite.contentSize.height/1.7);z0rder = 3; string = @"hands";break;//hands
            case 3:sprite.anchorPoint = ccp(0.5f, 0.5f);sprite.position = ccp(sprite.contentSize.width*2, sprite.contentSize.height*3);;z0rder = 5;break;//eye
            case 4:sprite.anchorPoint = ccp(0, 0.5f);sprite.position = ccp([[self getChildByTag:BNtag]getChildByTag:monster1].position.x-(IS_IPAD ? 5 : 2), [[self getChildByTag:BNtag]getChildByTag:monster1].position.y);z0rder = 3;break;//tail
            default:break;
        }
        if(i == 2){[[[self getChildByTag:BNtag ] getChildByTag:monster1+1] addChild:sprite z:z0rder tag:monster1+i];}
        else if(i == 3) {[[[self getChildByTag:BNtag] getChildByTag:monster1] addChild:sprite z:z0rder tag:monster1+i];}
        else{[[self getChildByTag:BNtag] addChild:sprite z:z0rder tag:monster1+i];}
        
        if(i <= 1){
            
        //[[GB2ShapeCache sharedShapeCache] addShapesWithFile:[NSString stringWithFormat:@"PE_Level9%@.plist",kDevice]];
        
        //b2BodyDef monsterBodyDef;
       // monsterBodyDef.type = b2_kinematicBody;
          
               // monsterBodyDef.position.Set([[self getChildByTag:BNtag] getChildByTag:monster1+i].position.x/PTM_RATIO,[[self getChildByTag:BNtag] getChildByTag:monster1+i].position.y/PTM_RATIO);
            
            
            
        //monsterBodyDef.position.Set(sprite.position.x/PTM_RATIO,sprite.position.y/PTM_RATIO);
            
            
       // monsterBodyDef.userData = sprite;
        //b2Body *body = world_->CreateBody(&monsterBodyDef);
        //body->SetFixedRotation(true);
        
            //[[GB2ShapeCache sharedShapeCache]addFixturesToBody:body forShapeName:string];
        }
    }
    [self animationOf1];
    [self monster1TailChange];
}

-(void)setMonsterByNR:(NSNumber *)num:(b2World*)world_
{
    if (num.integerValue == 1) {[self monster1Constr:world_];}
    else if (num.integerValue == 2){[self monster2Constr:world_];}
}

-(void)createBatchNode
{
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    spriteBatchNodeML = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"Level9%@.pvr.ccz",kDevice]];
    [self addChild:spriteBatchNodeML z:1 tag:BNtag];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"Level9%@.plist",kDevice]];
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
	
	world2->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
}*/


-(id)initWithRect:(CGRect)boxrect_{
    
    if (self =[super init]) {
        [self createBatchNode];
        //[self scheduleUpdate];
        
        /*
        b2Vec2 gravity = b2Vec2(0.0f, -20.0f);
        
        world2 = new b2World(gravity, true);
        b2DebugDraw *debugDraw = new GLESDebugDraw(PTM_RATIO);
        debugDraw->SetFlags(GLESDebugDraw::e_shapeBit);
        world2->SetDebugDraw(debugDraw);*/
        
        //self.color = ccRED;
        self.contentSize = CGSizeMake(boxrect_.size.width,boxrect_.size.height);
        self.anchorPoint = ccp(0,0);
        self.position = ccp(boxrect_.origin.x, boxrect_.origin.y);
        
    }
    return self;
}

-(void)childsPositions{
 
   // for (int x = monster1 ; x < monster1+5; x++) {
    //   CGPoint pt = [[self getChildByTag:BNtag]getChildByTag:x].position;
     
        
   // }
    
}
- (void) dealloc
{
    spriteBatchNodeML = nil;
	[super dealloc];
}

@end