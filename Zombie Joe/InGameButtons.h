//
//  InGameButtons.h
//  Zombie Joe
//
//  Created by Mac4user on 4/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PauseMenu.h"
#import "TutorialVIEW.h"

@interface InGameButtons : CCLayer <CCTargetedTouchDelegate,pauseDelegate> {
    
   // CCNode *parent;
    CCSprite *pause;
    PauseMenu  *PAUSE;
    CCSprite *blackBoard;
    TutorialVIEW *TUTORIAL;
    id admin;
    int level;
    int brainsNR;
    
    int lastTime;
    float time;
    
    float miliseconds;
    float seconds;
    float minutes;
    
    int recordTime;
    
    CCLabelBMFont *TIME_LABEL;
    
    CCProgressTimer *manaBar;
    
    BOOL ENABLE_MANA;
    
    BOOL manaON;

    BOOL tutorialSHOW;
    
    BOOL LostLevelInstantRestart;
    
    BOOL levelPassed;
    
    
}
@property (assign) BOOL tutorialSHOW;
@property (nonatomic,retain)  id admin;
@property (assign) int level;
@property (assign) int brainsNR;
//@property (nonatomic,retain) PauseMenu *PAUSE

//-(id)initWithParent:(CCNode *)parent_ initWithRect:(CGRect)rect;

//TIME SETTINGS

// *BRAIN ACTION S

-(void)BRAIN_:(int)x_ position:(CGPoint)pos_ parent:(CCNode*)par_;

-(void)LEVEL_START;

-(void)LEVEL_RESUME;

-(float)getMiliSeconds;

-(void)TIME_Begin;

-(void)TIME_Stop;

-(void)TIME_Pause;

-(void)TIME_Resume;

-(void)LEVEL_PASSED:(BOOL)v_;   //** set to YES when the level state is as done (and before WIN_LEVEL scene). This will not let the time go one after resume from pause scene

-(void)BRAIN_:(int)x_ zOrder:(int)z_ parent:(CCNode *)par_;

-(void)preloadBlast_self:(CCNode*)self_ brainNr:(int)brainnr_ parent:(CCNode*)p_;

-(void)makeBlastInPosposition:(CGPoint)pos_;

-(id)initWithRect:(CGRect)rect level:(int)level_ showtutorial:(BOOL)tutorial_;

-(void)setBRAINS_TO:(int)nrOfBrains;

-(void)increaseBRAINSNUMBER;

-(void)fadeOUTBLACKSCREEN;

-(void)SetBlackBoard_Z_InFront;

-(void)fadeINTOBLACKSCREEN;

-(void)showTutorial:(int)type_;


-(void)Lost_STATE_AFTERDELAY:(float)delay_;

-(void)LOSTLevel;

-(void)WINLevel;

@end
