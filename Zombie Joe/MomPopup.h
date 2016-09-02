//
//  MomPopup.h
//  Zombie Joe
//
//  Created by macbook on 2013-07-02.
//
//

#import "CCSprite.h"
#import "LevelHelperLoader.h"

@interface MomPopup : CCSprite{
    
    LHSprite *NodeToFallow;
    
    LHSprite *Bubble0;
    LHSprite *Bubble1;
    LHSprite *Bubble2;
    
    BOOL shown;
    
    float distanceBetweenCenterCat;
    
     LevelHelperLoader *loader;
    
}

-(id)initWithLoader:(LevelHelperLoader*)loader_ fallowNode:(LHSprite*)nodeFallow_;

-(LHSprite*)myFallower;

-(void)hideAllPopups;


@end
