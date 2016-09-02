//
//  LevelButton.h
//  Zombie Joe
//
//  Created by macbook on 2013-05-24.
//
//

#import "cocos2d.h"

@interface LevelButton : CCSprite{
    
    CCSpriteBatchNode *spritesBgNode;
    CCSpriteBatchNode *spritesItemsBatchNode;
    CCSprite *blackBoard;
    CCSprite *blackBoardBIG;
    int level;
    
    CCLabelTTF *TimeLabel;
    CCLabelTTF *levelNumberLabel;
    CCLabelTTF *lockedLabel1;
    
    CCSprite *levelImg;
    CCSprite *lock;
    
    BOOL locked;
    
}

@property (assign) int level;
@property (assign) int unlocked;

-(void)refreshLevelStatusWindow;
-(id)initWith_tag:(int)levlenr frameName:(NSString*)name_;

@end
