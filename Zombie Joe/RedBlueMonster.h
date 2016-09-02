//
//  RedBlueMonster.h
//  Level 14
//
//  Created by macbook on 2013-06-17.
//
//

#import "CCSprite.h"
#import "LevelHelperLoader.h"   
#import "constants_14.h"

@interface RedBlueMonster : CCSprite{

    CCSprite *blockToFallow;
    
    CCNode *PARENT;
    
    CGSize screenSize;
    
    int ID_;
    int type_;
    

}

@property (assign) int ID_;
@property (assign) int type_;


-(void)updateMonster;

-(id)initWithRect:(CGRect)rect withLoader:(LevelHelperLoader*)loader_ TYPE:(int)MONSTER_TYPE_ ID:(int)id_;

@end
