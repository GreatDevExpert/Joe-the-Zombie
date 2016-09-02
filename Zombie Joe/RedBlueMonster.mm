//
//  RedBlueMonster.m
//  Level 14
//
//  Created by macbook on 2013-06-17.
//
//

#import "RedBlueMonster.h"
#import "cfg.h"

@implementation RedBlueMonster
@synthesize ID_;
@synthesize type_;

-(NSInteger)MyRandomIntegerBetween:(int)min :(int)max {
    return ( (arc4random() % (max-min+1)) + min );
}

-(void)MoveUpdDownAction:(CCNode*)node_{
    
    float moveDist = 15;
    
    id moveUp =         [CCMoveBy actionWithDuration:0.5f position:ccp(0,moveDist)];
    id move_ease =      [CCEaseSineInOut actionWithAction:[[moveUp copy] autorelease]];
    id rev =            [CCMoveBy actionWithDuration:0.5f position:ccp(0,-moveDist)];
    id move_ease_rev =  [CCEaseSineInOut actionWithAction:[[rev copy] autorelease]];
    id seq =            [CCSequence actions:move_ease,move_ease_rev, nil];
    [node_ runAction:[CCRepeatForever actionWithAction:seq]];
    
}

-(void)addSnukisAnimation:(LHSprite*)spr_{
    
    //spr_.rotation = -10;
    
    id rotate =  [CCRotateTo actionWithDuration:0.5f angle:0];
    id rot_def = [CCRotateTo actionWithDuration:0.3f angle:-20];
    
    id seq = [CCSequence actions:rotate,rot_def, nil];
    
    [spr_ runAction:[CCRepeatForever actionWithAction:seq]];
    
}

-(void)MoveWings:(LHSprite*)spr_{
    
    id scaleDown = [CCScaleTo actionWithDuration:0.05f scaleX:0.5f scaleY:1];
    id scaleDef =  [CCScaleTo actionWithDuration:0.05f scaleX:1.f scaleY:1];
    
    id seq = [CCSequence actions:scaleDown,scaleDef, nil];
    
    id forev = [CCRepeatForever actionWithAction:seq];
    
    [spr_  runAction:forev];
    
}

-(void)addMonstrBodywithType:(int)type_ forLoader:(LevelHelperLoader*)loader_{
    
    NSString *birdTypeBodyName = @"redbird_body";
    
    NSString *birdSnapTop =     @"redbird_snapasTop";
    
    NSString *birdSnapBottom =  @"redbird_snapasBottom";
    
    NSString *wingLeft      =   @"redbird_leftwing";
    
    NSString *wingRight      =  @"redbird_rightwing";
    
        
        if (type_ == TYPE_MONSTER_BLUE)
        {
            birdTypeBodyName =  @"bluebird_body";
            wingLeft =          @"bluebird_leftwing";
            wingRight =         @"bluebird_rightwing";
        }
    
    //wing left
   LHSprite *wingLeftSpr = [loader_ createSpriteWithName:wingLeft
                                                fromSheet:@"AllSpriteslvl14"
                                               fromSHFile:@"SpriteSheetsLevel14" parent:PARENT];
    
    wingLeftSpr.anchorPoint = ccp(1.f, 0);
    
    wingLeftSpr.position = ccp(-wingLeftSpr.boundingBox.size.width*1.f,
                                wingLeftSpr.boundingBox.size.height*0.275f);
    
        //wing right
   LHSprite *wingRightSpr = [loader_ createSpriteWithName:wingRight
                                                    fromSheet:@"AllSpriteslvl14"
                                                   fromSHFile:@"SpriteSheetsLevel14" parent:PARENT];
        
        wingRightSpr.anchorPoint = ccp(0.f, 0);
        
        wingRightSpr.position = ccp(wingRightSpr.boundingBox.size.width *0.3f,
                                    wingRightSpr.boundingBox.size.height*0.075f);
    
    //BODY
    LHSprite *Body = [loader_ createSpriteWithName:birdTypeBodyName
                                              fromSheet:@"AllSpriteslvl14"
                                             fromSHFile:@"SpriteSheetsLevel14" parent:PARENT];
    
    Body.position = ccp(0, 0);
    
        //SNAP BOTTOM
        LHSprite *snapBottom = [loader_ createSpriteWithName:birdSnapBottom
                                                   fromSheet:@"AllSpriteslvl14"
                                                  fromSHFile:@"SpriteSheetsLevel14" parent:PARENT];
        
        snapBottom.position = ccp(-Body.boundingBox.size.width*0.5f+  (snapBottom.boundingBox.size.width/2),
                                  -Body.boundingBox.size.height*0.25f+(snapBottom.boundingBox.size.height/2));
    
        snapBottom.rotation = -20;
    
        snapBottom.anchorPoint = ccp(1,1);
    
    
            //SNAP TOP
            LHSprite *snapTop = [loader_ createSpriteWithName:birdSnapTop
                                                      fromSheet:@"AllSpriteslvl14"
                                                     fromSHFile:@"SpriteSheetsLevel14" parent:PARENT];
            
            snapTop.position = ccp(-Body.boundingBox.size.width/2, -Body.boundingBox.size.height*0.1f);
    
    [self MoveWings:wingLeftSpr];
    
    [self MoveWings:wingRightSpr];
    
    [self addSnukisAnimation:snapBottom];

}

-(void)addCOLOR_SHAPE{
    
    CCSprite *blackBoard = [[[CCSprite alloc]init]autorelease];
    
    [blackBoard setTextureRect:CGRectMake(0, 0, self.contentSize.width,
                                                self.contentSize.height)];
    blackBoard.position = ccp(0,0);
    blackBoard.opacity = 100;
    blackBoard.anchorPoint = ccp(0.5f, 0.5f);
    [self addChild:blackBoard z:0 tag:5];
    blackBoard.color = ccRED;
    
}

-(LHSprite*)getBirdPositionByUNIQUENAME:(int)tagID_ type:(int)type_ loader:(LevelHelperLoader*)loader_{
    
    NSString *typeName = @"EVILRED_";
    if (type_==TYPE_MONSTER_BLUE)
    {
        typeName = @"EVILBLUE_";
    }
    
    return [loader_ spriteWithUniqueName:[NSString stringWithFormat:@"%@%i",typeName,tagID_]];
    
}

-(void)startMoveAfterDelay:(CCNode*)nod_{
    
    [self MoveUpdDownAction:nod_];
    
}

-(id)initWithRect:(CGRect)rect withLoader:(LevelHelperLoader*)loader_ TYPE:(int)MONSTER_TYPE_ ID:(int)id_{
    
    if((self = [super init]))
    {
        
        self.anchorPoint = ccp(0.5f,0.5f);
        
        self.contentSize = CGSizeMake(rect.size.width,
                                      rect.size.height);
        
        self.position = ccp(rect.origin.x, rect.origin.y);
        
        screenSize = [CCDirector sharedDirector].winSize;
        
        PARENT = [[[CCNode alloc]init]autorelease];
        [self addChild:PARENT];
        
        //---//---//---//---//
        
        blockToFallow = [self getBirdPositionByUNIQUENAME:id_ type:MONSTER_TYPE_ loader:loader_];
        
    //    [self addCOLOR_SHAPE];
        
    
        [self addMonstrBodywithType:MONSTER_TYPE_ forLoader:loader_];
        
        float moveDelay = (float)[self MyRandomIntegerBetween:1 :20]/10;
        
        [cfg runSelectorTarget:self selector:@selector(startMoveAfterDelay:) object:PARENT afterDelay:moveDelay sender:self];
      //  [self performSelector:@selector(startMoveAfterDelay:) withObject:PARENT afterDelay:moveDelay];
        
     //   [self schedule:@selector(fallowPath:)];

        
    }
    return self;
}

-(void)scaleChangeActionWithScaleFactor:(int)fak_{
    
    if (![self getActionByTag:1])
    {
        [self runAction:[CCScaleTo actionWithDuration:0.1f scaleX:fak_ scaleY:1]].tag = 1;
    }
    
}

-(void)checkScaleFactor{
    
    if (self.position.x < screenSize.width*0.40f)    //flip when near <---side (left)
    {
        if (self.scaleX==1)
        {
           // self.scaleX = -1;
              [self scaleChangeActionWithScaleFactor:-1];
        }
    }
    else if (self.position.x > screenSize.width*0.6f)
    {
        if (self.scaleX==-1)
        {
            self.scaleX = 1;
            // [self scaleChangeActionWithScaleFactor:1];
        }
    }
    
}

-(void)updateMonster{
    
    if (!blockToFallow)
    {
        return;
    }
    
    self.position = blockToFallow.position;
    
    self.rotation = blockToFallow.rotation;
    
    [self checkScaleFactor];
    
}

-(void)fallowPath:(ccTime)dt{
    
    if (!blockToFallow)
    {
        return;
    }
    
    self.position = blockToFallow.position;
    
    self.rotation = blockToFallow.rotation;
    
    [self checkScaleFactor];
    

}

- (void) dealloc
{

    
	[super dealloc];
}

@end
