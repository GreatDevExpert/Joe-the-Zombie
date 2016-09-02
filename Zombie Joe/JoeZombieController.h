//
//  JoeZombieRobot.h
//  Zombie Joe
//
//  Created by macbook on 2013-07-18.
//
//

#import "cocos2d.h"
#import "LevelHelperLoader.h"
#import "b6luxRobotSprite.h"
#import "JoeZombieRobot.h"

@interface JoeZombieController : CCSprite{
    
     LevelHelperLoader *loader;
    
    JoeZombieRobot *robot;
    
    CCSprite *blast;
    CCSprite *blast2;
    CCSprite *blast3;

 //   b2World* world;
    //	GLESDebugDraw *m_debugDraw;
    
    //  LevelHelperLoader *loader;
    
}

-(id)initBlastOnly_Parent:(CCNode*)par_ brainsNumber:(int)bnum_;

-(id)initWitPos:(CGPoint)pos size:(CGSize)size_ sender:(CCNode*)par_ brains:(int)sum_;

-(id)initWitPos:(CGPoint)pos size:(CGSize)size_ sender:(CCNode*)par_;

-(id)initWitPos:(CGPoint)pos size:(CGSize)size_;

-(void)ACTION_SetContentSize:(CGSize)size_;

-(void)showKillBlastEffectInPosition:(CGPoint)pos_;

-(void)JOE_flipX:(BOOL)fli_;

-(void)showMyBox;

-(void)JOE_HIDE:(int)x_ opacity:(float)op_;

-(void)JOE_JUMP_FORLevel:(int)level_;

-(void)JOE_HANGING_RIGHT;
-(void)JOE_HANGING_LEFT;
-(void)JOE_HANGING_DOWN;
-(void)JOE_WALK;
-(void)JOE_IDLE;
-(void)JOE_JUMP_UP; 
-(void)JOE_JUMP_DOWN;

-(JoeZombieRobot*)robot_;


@end
