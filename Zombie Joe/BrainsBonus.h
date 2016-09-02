//
//  BrainsBonus.h
//  Zombie Joe
//
//  Created by macbook on 2013-05-06.
//
//

#import "CCSprite.h"

@interface BrainsBonus : CCSprite{
    
    CCSprite* brain;
    
}

@property (nonatomic,retain) CCSprite* brain;

-(id)initWithRect:(CGRect)rect;

//-(void)moveUpDown;

-(void)moveUpDown_particles:(BOOL)yes_;
-(void)upDownParticles;



@end
