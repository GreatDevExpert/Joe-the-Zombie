//
//  BabyBirdC.h
//  Zombie Joe
//
//  Created by macbook on 2013-07-01.
//
//

#import "CCSprite.h"
#import "LevelHelperLoader.h"

@interface BabyBirdC : CCSprite{
    
    LHSprite *eyes;
    
}

-(void)closeEyes;

-(id)initWithRect:(CGRect)rect withLoader:(LevelHelperLoader*)loader_;

@end
