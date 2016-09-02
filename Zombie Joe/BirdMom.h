//
//  BirdMom.h
//  Zombie Joe
//
//  Created by macbook on 2013-07-02.
//
//

#import "CCSprite.h"
#import "LevelHelperLoader.h"

@interface BirdMom : LHSprite{
    
    LHSprite *NodeToFallow;
    
    LHSprite *bodyMom;
    
}

-(LHSprite*)myFallower;

-(id)initWithLoader:(LevelHelperLoader*)loader_ fallowNode:(LHSprite*)nodeFallow_;

@end
