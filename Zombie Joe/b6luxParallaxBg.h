//
//  b6lRobot.h
//  Zombie Joe
//
//  Created by macbook on 2013-07-05.
//
//

#import "LevelHelperLoader.h"
#import "LHSprite.h"
#import "b6luxHelper.h"

#define bg_direction_RL         1
#define bg_direction_UP_DOWN    2

#define bg_distanceFull         100

#define C_OBJ(__X__)         [NSString stringWithFormat:@"OBJ_%i",(__X__)]

@interface b6luxParallaxBg : LHSprite{
    
    CCNode  *nodeToFallow;
    LevelHelperLoader *loader;
    CCNode *moverNode;
    
    BOOL enableMoveY;
    
    NSMutableDictionary *bgPositions;
    NSMutableDictionary *bgSpeeds;
    NSMutableDictionary *bgObjects;
    
    int direction;
    int numberOfBackgrounds;
    
    CGPoint firstNodePosition;
    CGPoint previousNodePosition;
    
}

@property (nonatomic,assign) BOOL enableMoveY;

-(id)loadParallaxBackgroundWithLoader:(LevelHelperLoader*)loader_
                         fallowedNode:(CCNode*)node_
                            direction:(int)dir_;

-(void)addBgWithUniqeName:(NSString*)name_ speed:(float)speed_;


@end
