//
//  JoeAndFlyiers.m
//  Level 14
//
//  Created by macbook on 2013-06-18.
//
//

#import "JoeAndFlyiers.h"


#define ACTION_TAG_JUMP 301
#define ACTIN_TAG_ONROPE 302

#define ACTION_TAG_ROTATE_R 500
#define ACTION_TAG_ROTATE_L 501

@implementation JoeAndFlyiers

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





-(void)scaleChangeActionWithScaleFactor:(int)fak_{
    
    if (![self getActionByTag:1])
    {
        [self runAction:[CCScaleTo actionWithDuration:0.1f scaleX:fak_ scaleY:1]].tag = 1;
    }
    
}

-(void)fallowPath:(ccTime)dt{
    
    self.position = ccpAdd(blockToFallow.position, ccp(0, -fliers.boundingBox.size.height*0.1f));
    
}

-(void)fliersSitOnRope{
    
    if ([fliers getActionByTag:ACTIN_TAG_ONROPE])
    {
        return;
    }
    
    id scaleNorm = [CCScaleTo actionWithDuration:0.1f scaleX:1.f scaleY:1.f];
    id scaleDown2 = [CCScaleTo actionWithDuration:0.1f scaleX:0.9f scaleY:1.2f];
    id scaleDown2_ = [CCEaseElasticInOut actionWithAction:scaleDown2 period:1.f];
    
    id seq = [CCSequence actions:scaleDown2_,scaleNorm, nil];
    [fliers runAction:seq].tag = ACTIN_TAG_ONROPE;
    
}

-(void)jumpFliersEffect{
    if ([fliers getActionByTag:ACTION_TAG_JUMP])
    {
        return;
    }
    id scaleDown = [CCScaleTo actionWithDuration:0.1f scaleX:0.9f scaleY:1.2f];
    id scaleDown_ = [CCEaseElasticInOut actionWithAction:scaleDown period:1.f];
    
    id scaleNorm = [CCScaleTo actionWithDuration:0.3f scaleX:1.f scaleY:1.f];
    
    id scaleDown2 = [CCScaleTo actionWithDuration:0.1f scaleX:0.9f scaleY:1.2f];
    id scaleDown2_ = [CCEaseElasticInOut actionWithAction:scaleDown2 period:1.f];
    
    id seq = [CCSequence actions:scaleDown_,scaleNorm, nil];
    [fliers runAction:seq].tag = ACTION_TAG_JUMP;
    
}

-(LHSprite*)getBirdPositionByUNIQUENAME:(NSString*)name_ loader:(LevelHelperLoader*)loader_{
    
    return [loader_ spriteWithUniqueName:[NSString stringWithFormat:@"%@",name_]];
    
}

-(void)addSpritesforLoader:(LevelHelperLoader*)loader_{
    
    
    fliers = [loader_ createSpriteWithName:@"jumper"
                                           fromSheet:@"flierSheet"
                                          fromSHFile:@"SpriteSheetsLevel14" parent:PARENT];
    fliers.position = ccp(0, 0);
    
    //add hands
    fliersHands = [loader_ createSpriteWithName:@"jumper_hands"
                                       fromSheet:@"flierSheet"
                                      fromSHFile:@"SpriteSheetsLevel14" parent:PARENT];
    
        fliersHands.anchorPoint = ccp(0.5f, 1.f);
    
        fliersHands.position = ccp(0, -(fliers.boundingBox.size.height*0.04f));
    
}

-(void)rotateHandsBy:(float)val_{
    
    if (val_ > rotateVal)
    {
        rotateRight = YES;
        [fliers stopActionByTag:ACTION_TAG_ROTATE_L];
        [fliersHands stopActionByTag:ACTION_TAG_ROTATE_L];
    }
    else if (val_ < rotateVal)
    {
        rotateRight = NO;
        [fliers stopActionByTag:ACTION_TAG_ROTATE_L];
        [fliersHands stopActionByTag:ACTION_TAG_ROTATE_L];
    }
    
    if (val_ > 15)
    {
        val_ = 15;
    }
    
    else if (val_ < - 15)
    {
        val_ = -15;
    }
    
    id rotateH =  [CCRotateTo actionWithDuration:0.15f angle:val_*0.75f];
    id rotateRs = [CCRotateTo actionWithDuration:0.15f angle:-(val_)];
    
    if (rotateRight && ![fliers getActionByTag:ACTION_TAG_ROTATE_R])
    {
        [fliers runAction:rotateRs].tag = ACTION_TAG_ROTATE_R;
        [fliersHands runAction:rotateH].tag = ACTION_TAG_ROTATE_R;
    }
   else if (!rotateRight && ![fliers getActionByTag:ACTION_TAG_ROTATE_L])
    {
        [fliers runAction:rotateRs].tag = ACTION_TAG_ROTATE_L;
        [fliersHands runAction:rotateH].tag = ACTION_TAG_ROTATE_L;
    }
    
    //fliersHands.rotation = val_*0.75f;
    //fliers.rotation = -(val_);
    
}

-(void)scaleHandsY:(float)val_{
    
    fliersHands.scaleY = val_;
  //
 //   fliers.scaleY = val_;
    
}

-(id)initWithRect:(CGRect)rect withLoader:(LevelHelperLoader*)loader_ parent:(CCNode*)par_{
    
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
        
     //   blockToFallow = [self getBirdPositionByUNIQUENAME:@"PLAYER" loader:loader_];
        
        [self addSpritesforLoader:loader_];
        
       // [self addZombie:par_];
        
        rotateVal = 0;
        
        
        
    //    [self addCOLOR_SHAPE];
        
      //  [self schedule:@selector(fallowPath:)];
        
    }
    return self;
}

-(JoeZombieController*)returnJoe{
    
    return zombiebody;
    
}

-(void)addZombie:(CCNode*)pa_{
    
    zombiebody = [[[JoeZombieController alloc]initWitPos:ccp(0, 0) size:CGSizeMake(20, 20) sender:pa_]autorelease];
    [pa_ addChild:zombiebody];
    zombiebody.scale = 0.4f;
    zombiebody.anchorPoint= ccp(0.5f, 0.5f);
    zombiebody.position = ccp(-fliers.boundingBox.size.width*0.28f, -fliers.boundingBox.size.width);
    
    [zombiebody JOE_HANGING_DOWN];
    
}

- (void) dealloc
{
    
    
	[super dealloc];
}

@end
