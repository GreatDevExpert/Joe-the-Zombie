//
//  JoeAndFlyiers.h
//  Level 14
//
//  Created by macbook on 2013-06-18.
//
//

#import "CCSprite.h"
#import "LevelHelperLoader.h"
#import "constants_14.h"
#import "JoeZombieController.h"

@interface JoeAndFlyiers : CCSprite{
    
    CCSprite *blockToFallow;
    
    CCNode *PARENT;
    
    CGSize screenSize;
    
    LHSprite *fliersHands;
    
    LHSprite *fliers;
    
    JoeZombieController *zombiebody;
    
    float rotateVal;
    BOOL rotateRight;
    
}

-(JoeZombieController*)returnJoe;

-(void)jumpFliersEffect;

-(void)fliersSitOnRope;

-(void)scaleHandsY:(float)val_;

-(void)rotateHandsBy:(float)val_;

-(id)initWithRect:(CGRect)rect withLoader:(LevelHelperLoader*)loader_ parent:(CCNode*)par_;

@end
