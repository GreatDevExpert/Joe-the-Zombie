//
//  JoeZombieController.h
//  Zombie Joe
//
//  Created by macbook on 2013-07-18.
//
//

#import "LevelHelperLoader.h"
#import "b6luxRobotSprite.h"

@interface JoeZombieRobot : b6luxRobotSprite{
    
    
    
}

-(void)initContent;

/*** INDUVIDUAL JUMP ACTIONS ***////
-(void)JOE_JUMP_LEVEL_4;
-(void)JOE_JUMP_LEVEL_6;

-(void)JOE_IDLE_CUSTOM:(float)speed_;

-(void)JOE_WALK_SPEED:(float)speed_;
-(void)JOE_JUMP_MENU:(int)speed_;
-(void)JOE_IDLE_MENU;
-(void)JOE_HANGING_RIGHT;
-(void)JOE_HANGING_LEFT;
-(void)JOE_HANGING_DOWN;
-(void)JOE_HANGING_DOWN_2;
-(void)JOE_WALK;
-(void)JOE_IDLE;
-(void)JOE_JUMP_UP;     // ---> jump begin
-(void)JOE_JUMP_DOWN;   // ---> jump ended (on the ground)

@end
