//
//  PauseMenu.h
//  Zombie Joe
//
//  Created by Mac4user on 4/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ScoreBlock.h"
@protocol pauseDelegate <NSObject>
@optional

-(id)getNode;
-(int)getLevelNr;
-(void)showTutorial:(int)type_;
-(float)getMiliSeconds;

@end

@interface PauseMenu : CCSprite <CCTargetedTouchDelegate,scoreBlockDelegate>{
    
   // CCNode *parent;
    id<pauseDelegate> delegate;
    CCSpriteBatchNode *spritesBgNode;
    id admin;
    BOOL BLOCKTOUCH;
    
    int TYPE;

}

//@property (nonatomic,retain)  CCNode *parent;
@property (nonatomic,retain) id delegate;
@property (nonatomic,retain) id admin;


-(id)initWithRect:(CGRect)rect type:(int)type_ brainBonus:(int)brains_ milisesc:(int)milisec_ level:(int)level_;
@end
