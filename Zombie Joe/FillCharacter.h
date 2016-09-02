//
//  FillCharacter.h
//  Zombie Joe
//
//  Created by macbook on 2013-04-28.
//
//

//#import "CCSprite.h"
#import "cocos2d.h"
#import "JoeZombieController.h"

@interface FillCharacter : CCSprite{// <CCTargetedTouchDelegate> {
    
    CCSpriteBatchNode *spritesBgNode;
    int collected;
    id admin;
    JoeZombieController *playerImage;
    
}

-(CCSpriteBatchNode*)spriteBatch;

-(BOOL)checkIfAllBodyPartsCollected;

-(id)initWithRect:(CGRect)rect;

-(void)enableBodyPartByTag:(int)tag__;

//@property (nonatomic,retain) CCSpriteBatchNode *spritesBgNode;

//@property (nonatomic,retain) id admin;

@property (assign) int collected;

@end
