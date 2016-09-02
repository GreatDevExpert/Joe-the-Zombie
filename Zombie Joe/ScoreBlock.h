//
//  ScoreBlock.h
//  Zombie Joe
//
//  Created by Mac4user on 6/12/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@protocol scoreBlockDelegate <NSObject>
@optional

-(int)getLevelNr;
-(int)howManyBrainsGot;

@end

@interface ScoreBlock : CCSprite<CCTargetedTouchDelegate> {
    
    id<scoreBlockDelegate> delegate;
    
    CCSpriteBatchNode *spritesBgNode;
    
    CCProgressTimer *yellowBar;
    
    CCLabelBMFont *SCORE_LABEL;
    
    CCNode *wheelPAR;
    
    BOOL ENABLE_LABEL;
    
    int score;
    int score_FILL;
    
    int percentFILL;
    
    int brainNR;
    int brainBonusVisible;
    
    float percentToAdd;
    
    float scoreToAdd;
    
    int level;
    
    int time;
    
    BOOL newRecord;
    
    BOOL fillSound;
    
    int topPlayerScore;
    
    int scoreFastFinal;
    
}

@property (nonatomic,retain) id delegate;

-(id)initWithRect_:(CGRect)rect scored:(int)milisec level:(int)level_ brains:(int)brains_;

@end
