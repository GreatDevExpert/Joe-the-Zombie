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

#define suffix_POINT_CENTER @"CENTER"  //** suffix for center point (unique name)
#define PART(__X__) (LHSprite*)[self getChildByTag:(__X__)]
#define PART_S(__X__) [self getChildByTag:(__X__)]

@interface b6luxRobotSprite : LHSprite{
    
    NSMutableDictionary *RobotPoints;
    NSMutableDictionary *RobotPartNames;
    NSMutableDictionary *RobotRotations;
    NSMutableDictionary *RobotScaleX_Y;
    
    NSString *uniqueNamePrefix;
    
    LevelHelperLoader *loader;
    
    LHSprite *NodeToFallow;
    
    int robotParts;
    int robotStates;
    
    NSMutableDictionary *AnimationPriority;
    NSMutableDictionary *AnimationDurations;
    NSMutableDictionary *RobotPartsEnableAnimation;
    
    BOOL robotCanRotate;
    BOOL robotCanMove;
    BOOL robotCanScale;
    BOOL robotCanFallowNode;
    
}

@property (readonly) NSString *uniqueNamePrefix;
@property (nonatomic,assign)  BOOL robotCanScale;
@property (nonatomic,assign)  BOOL robotCanRotate;

+(id)initRobotWithLoader:(LevelHelperLoader*)loader_
          uniqNamePrefix:(NSString*)prefix_
              fallowNode:(LHSprite*)nodeFallow_;

-(id)loadRobotWithLoader:(LevelHelperLoader*)loader_
          uniqNamePrefix:(NSString*)prefix_
              fallowNode:(LHSprite*)nodeFallow_;

-(void)createRobotWithStatesSum:(int)sum_ robotPartsSum:(int)parts_ mainState:(int)main_;

// *** ACCESSING OBJECTS

-(LHSprite*)PART:(int)t_;

-(LHSprite*)myFallower;

// *** ACTIONS

-(void)ACTION_CLOSE_EYES_eyesTag:(int)eyes_;

-(void)ACTION_UPDATE_ANIMATION_Between_State1:(int)state1_ State2_:(int)state2_ percent:(float)percent_;

-(void)ACTION_ShowContentSize;

-(void)ACTION_SetContentSize:(CGSize)size_;

-(void)ACTION_FlipRobot_X:(BOOL)x_ Y:(BOOL)y_ duration:(float)d_;

-(void)ACTION_PlayAnimation_Repeat:(BOOL)repeat_;

-(void)ACTION_StopAllPartsAnimations_Clean:(BOOL)clean_;

-(void)ACTION_RemoveStateByID:(int)state_;

-(BOOL)ACTION_SetAnimationState:(int)state_ priority:(int)prio_ duration:(float)time_;

-(void)ACTION_StopAnimationForPart:(int)part_;

-(void)ACTION_EyesBlink_WithObject:(id)eyes_ openedTime:(float)opened_ closedTime:(float)closed_ startRandomly:(BOOL)randomLy durationOpen:(float)dur_open durationClose:(float)dur_close blinkTimes:(int)blinkTimes;

// **** Options

-(void)colorAllBodyPartsWithColor:(ccColor3B)c_ part:(int)x_ all:(BOOL)all_ restore:(BOOL)restore_ restoreAfterDelay:(float)delay_;

-(void)makeOpacityForPart:(int)part_ opacity:(float)op_;

-(void)makeOpacityOfAllParts:(float)op_;

-(float)RotateRobotToPoint:(CGPoint)pos2;

-(void)removeRobotFallower;

-(int)homManyStatesAreInLoaderByPrefix:(NSString*)preffix_;

@end
