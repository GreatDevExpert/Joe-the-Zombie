//
//  JOE_C.h
//  Zombie Joe
//
//  Created by macbook on 2013-05-16.
//
//

#import "CCSprite.h"

@interface JOE_C : CCSprite{
    
    CCSpriteBatchNode *spritesBgNode;
    
    CCSprite *body;
    
}

@property (nonatomic,retain) CCSprite *body;

-(id)initWithRect:(CGRect)rect tag:(int)_tag;

//ACTIONS

-(void)Action_IDLE_Setdelay:(float)delay_ funForever:(BOOL)forever_;

-(void)Action_WALK_SetDelay:(float)delay_ funForever:(BOOL)forever_;

-(void)Action_JUMP_Setdelay:(float)delay_ funForever:(BOOL)forever_;

-(void)Action_DEAD_Setdelay:(float)delay_ funForever:(BOOL)forever_;

@end
