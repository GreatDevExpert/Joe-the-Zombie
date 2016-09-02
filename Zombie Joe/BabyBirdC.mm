//
//  BabyBirdC.m
//  Zombie Joe
//
//  Created by macbook on 2013-07-01.
//
//

#import "BabyBirdC.h"

@implementation BabyBirdC

-(id)initWithRect:(CGRect)rect withLoader:(LevelHelperLoader*)loader_{
    
    if((self = [super init]))
    {
        
        [self addBabyBody:loader_];
        [self addBabyEyes:loader_];
        
    }
    return self;
}

-(void)closeEyes{
    
    [eyes stopAllActions];
    id OpenEys =   [CCFadeTo actionWithDuration:0.1f opacity:255];
    [eyes runAction:OpenEys];
}

-(void)addBabyEyes:(LevelHelperLoader*)loader_{
    
    eyes = [loader_ createSpriteWithName:@"birdbaby_eyes"
                                             fromSheet:@"level_15_spritesSH"
                                            fromSHFile:@"Level15SH" parent:self];
    eyes.position = ccp(0, -eyes.boundingBox.size.height*0.05f);
    
    id OpenEys =   [CCFadeTo actionWithDuration:0.1f opacity:0];
    id CloseEyes = [CCFadeTo actionWithDuration:0.1f opacity:255];
    id seq = [CCSequence actions:OpenEys,[CCDelayTime actionWithDuration:2.5f],CloseEyes,[CCDelayTime actionWithDuration:0.25f], nil];
    id forev = [CCRepeatForever actionWithAction:seq];
    [eyes runAction:forev];
    
}

-(void)addBabyBody:(LevelHelperLoader*)loader_{
    
    LHSprite *babyBird = [loader_ createSpriteWithName:@"birdbaby"
                                            fromSheet:@"level_15_spritesSH"
                                           fromSHFile:@"Level15SH" parent:self];
    babyBird.position = ccp(0, 0);
    
}

- (void) dealloc
{
	[super dealloc];
}

@end
