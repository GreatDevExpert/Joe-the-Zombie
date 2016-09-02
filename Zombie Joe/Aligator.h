//
//  Aligator.h
//  Zombie Joe
//
//  Created by macbook on 2013-05-07.
//
//

#import "CCSprite.h"

@interface Aligator : CCSprite
{

    CCSprite *monster;
    
    CCSpriteBatchNode *spritesBgNode;
    BOOL aligatorSound;
    BOOL swallowZombie;
    
}

-(void)swallowedZombie;

-(id)initWithRect:(CGRect)rect;

-(void)chillAction;

-(void)caughtZombieAction:(CCNode*)deadBody;

-(void)closeMoutH;

-(void)openMouth;


@end
