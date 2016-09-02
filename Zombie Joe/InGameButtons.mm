//
//  InGameButtons.m
//  Zombie Joe
//
//  Created by Mac4user on 4/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "InGameButtons.h"
#import "cfg.h"
#import "SceneManager.h"
#import "BrainsBonus.h"
#import "SimpleAudioEngine.h"  
#import "JoeZombieController.h"
#import "BrainRobot.h"

#define b_Home          0
#define b_Info          1
#define b_Pause         2
#define b_MANA          3

#define BRAIN1  10
#define BRAIN2  11
#define BRAIN3  12

#define offsetPAUSE     (IS_IPAD)  ? 15 : 5
#define offsetBRAINLINE (IS_IPAD)  ? 15 : 5
#define offsetPAUSE_Y   (IS_IPAD)  ? 15 : 5

@implementation InGameButtons
@synthesize admin;
@synthesize level;
@synthesize brainsNR;
@synthesize tutorialSHOW;

-(id)initWithRect:(CGRect)rect level:(int)level_ showtutorial:(BOOL)tutorial_{
    
    if((self = [super init]))
        
    {
        
        
        level = level_;
        
        
        
        PAUSE  = [[[PauseMenu alloc]initWithRect:
                   
            CGRectMake(-(kPauseMenuW/2),ScreenSize.height/2,
                       kPauseMenuW, kPauseMenuH)
                       type:kPAUSE_WINDOW_TAG brainBonus:0 milisesc:0 level:level]autorelease];
        
        PAUSE.delegate = self;
        
        //PRELOAD

        ScoreBlock *SB = [[[ScoreBlock alloc]initWithRect_:CGRectMake
                           (0,
                            0,
                            0,
                            0) scored:0 level:0 brains:0]autorelease];
         

        
        self.anchorPoint = ccp(0.f,0.f);
        self.contentSize = CGSizeMake(ScreenSize.width,
                                      ScreenSize.height);
        
        self.position = ccp(0, 0);
        
     //  [cfg addTEMPBGCOLOR:self anchor:ccp(0, 1) color:ccGREEN];   //temp fill
        
        [self addPauseButton];
        
        [self addBransLine];
         
        
        [self addTimerLINE];
        
        
      //  [self darkenScreenCreate];  // --- >>> HUGE FPS DROP!!!
        
       
        
        if (tutorial_)
        {
            tutorialSHOW = YES;
            [self showTutorial:TUTORIAL_TYPE_STARTLEVEL];
        }
        else if (!tutorial_)
        {
             //probably restart
            tutorialSHOW  =NO;
            [self TIME_Begin];
        }
        
        // *** INSTANT RESTART AFTER LOST LEVEL ( no death scene )
        LostLevelInstantRestart = YES;
        
        ENABLE_MANA = NO;
        
        if (ENABLE_MANA)
        {
                   [self EnterTheMatrixButton];     // **** ENABLE MANA ACTIONS
        }

    }
    return self;
}

-(void)BRAIN_:(int)x_ position:(CGPoint)pos_ parent:(CCNode*)par_{
    
    BrainRobot *b =  (BrainRobot*)[par_ getChildByTag:x_];
    b.position = pos_;
    
}

-(void)BRAIN_:(int)x_ zOrder:(int)z_ parent:(CCNode *)par_{
    
    BrainRobot *b =  (BrainRobot*)[par_ getChildByTag:x_];
    [par_ reorderChild:b z:z_];
    
}

-(void)preloadBlast_self:(CCNode*)self_ brainNr:(int)brainnr_ parent:(CCNode*)p_{
    
    [self_ addChild:[[[JoeZombieController alloc]initBlastOnly_Parent:p_ brainsNumber:brainnr_]autorelease]z:100 tag:TAG_BLAST];
    
}

-(void)makeBlastInPosposition:(CGPoint)pos_{    //must pass brainnr here too
    
    [(JoeZombieController*)[[(JoeZombieController*)[admin getChildByTag:TAG_BLAST]parent]
                            getChildByTag:TAG_BLAST] showKillBlastEffectInPosition:pos_];
    
}

-(void)EnterTheMatrixButton{
    
    CCSprite *black = [[[CCSprite alloc]init]autorelease];
    
    [black setTextureRect:CGRectMake(0, 0, 200,
                                          60)];
    
    black.position = ccp(kWidthScreen*0.15f ,kWidthScreen*0.1f);
    black.opacity = 150;
    black.anchorPoint = ccp(0.5, 0.5);
    [self addChild:black z:0 tag:5];
    black.color = ccBLACK;
    
    //yellow bar add
    
    NSString *yelStr = (IS_IPAD) ? @"circle1.png" : @"circle1_iPhone.png";
    
   manaBar = [CCProgressTimer progressWithFile:@"mana.png"];
    
    manaBar.type = kCCProgressTimerTypeHorizontalBarLR;
    manaBar.percentage = 100;
    
    manaBar.anchorPoint = ccp(0.5f, 0.5f);
    
    manaBar.position = black.position;//ccpAdd(black.position,
                                //ccp(black.boundingBox.size.width/2,0));
    
    [self addChild:manaBar z:1 tag:b_MANA];
    
    manaBar.scaleX = 0.95f;
    manaBar.scaleY = 0.9f;
    
  //  CCProgressFromTo *to1 = [CCProgressFromTo actionWithDuration:10.f from:100 to:0];
    
   // [manaBar runAction:to1];

}

-(void)turnMANA:(BOOL)on_{
    
    if (on_)
    {
        manaON = YES;
        [self.admin performSelector:@selector(MANA_ON) withObject:nil afterDelay:0];
        [self schedule:@selector(manaUpdate:) interval:0.1f];
    }
    if (!on_) {
        manaON = NO;
        [self unschedule:@selector(manaUpdate:)];
        [self.admin performSelector:@selector(MANA_OFF) withObject:nil afterDelay:0];
    }
    
}

-(void)manaUpdate:(ccTime)dt{
    
    manaBar.percentage-=0.5f;
    if (manaBar.percentage <= 0)
    {
        manaBar.percentage = 0;
        [self turnMANA:NO];
    }
    
}

-(void)pressedOnMANA{
    
    if (manaBar.percentage <= 0) {
        return;
    }
    if (manaON) {
        [self turnMANA:NO]; //TURN OFF IT NEEDED
    }
    
    
    else [self turnMANA:YES];       //TURN ON!
    
   //  CCProgressFromTo *to1 = [CCProgressFromTo actionWithDuration:10.f from:100 to:0];
    
   //  [manaBar runAction:to1];
    
}

-(void)addTimerLINE{
    
    BOOL posCenter = NO;
    
    NSString *brainLine = @"topmenu_brainbg.png";
    if (IS_IPHONE)
    {
        brainLine =  @"topmenu_brainbg_iPhone.png";
    }
    
    CCSprite *brainLineSprite = [CCSprite spriteWithFile:brainLine];
    brainLineSprite.anchorPoint = ccp(0.5f, 0.5f);
    
    if (posCenter) {
        brainLineSprite.position = ccp(kWidthScreen/2,
                                       kHeightScreen-(brainLineSprite.boundingBox.size.height/2)-(offsetBRAINLINE));
    }
    else
        brainLineSprite.position = ccp((brainLineSprite.boundingBox.size.width/2)+(offsetPAUSE),
                                       kHeightScreen-(brainLineSprite.boundingBox.size.height/2)-(offsetBRAINLINE));
    

    [self addChild:brainLineSprite];
    //   brainLineSprite.scale = kSCALE_FACTOR_FIX;
  //  brainLineSprite.opacity = 200;
    

    
//    recordTime = [db getHighTIMEForLevel:level];
//    
//    NSLog(@"record was %i",recordTime);
    
   // NSLog(@"font used :%@",kFONT_LARGE);
    
    /*
    int t = [db getHighTIMEForLevel:level];
    
    NSString *bestTimeBefore = [NSString stringWithFormat:@"%02li:%02li:%02li",
                            
                            lround(floor(t / 3600.)) % 100,
                            lround(floor(t / 60.)) % 60,
                            lround(floor(t)) % 60];
     */

    TIME_LABEL = [CCLabelBMFont labelWithString:@"00:00:00" fntFile:kFONT_LARGE];
    
    TIME_LABEL.anchorPoint = ccp(0.f, 0.5f);
    
    TIME_LABEL.position = ccpAdd(brainLineSprite.position,
                                 ccp(-brainLineSprite.boundingBox.size.width*0.35f, 0));
    
    TIME_LABEL.color = ccc3(238,194,0);//ccGREEN;   //red ?!
    
    [self addChild:TIME_LABEL];
    
    if (IS_IPHONE) {
        if (![Combinations isRetina])
        {
            brainLineSprite.scaleX = 1.3;
            brainLineSprite.position = ccpAdd(brainLineSprite.position, ccp(15, 0));
        }
    }
    
}

-(float)getMiliSeconds{
    
    NSLog(@"time is RETURNED %f",time);
    return time;
    
}

-(void)LEVEL_RESUME{
    
  //   [self TimerLabelSetToYellow];
    
    if (blackBoard.opacity > 0)  // In case if black board was left faded -> fade out
    {
        [self fadeOUTBLACKSCREEN];
    }
    
    [self TIME_Resume];
    
    if ([self.admin respondsToSelector:@selector(GAME_RESUME)])
    {
          [self.admin performSelector:@selector(GAME_RESUME)];
    }

}

-(void)LEVEL_START{
    
//     [self TimerLabelSetToYellow];
    
    [self TIME_Begin];
    
    if ([self.admin respondsToSelector:@selector(GAME_RESUME)])
    {
        [self.admin performSelector:@selector(GAME_RESUME)];
    }
    
}

-(void)TimerLabelSetToYellow{
    
    TIME_LABEL.color = ccc3(238,194,0); // yellow
    
}

-(void)TIME_Begin{
    
    
   // [self TimerLabelSetToYellow];
    
    time = 0;
    [self TIME_Stop];
    
    [self schedule:@selector(updateTimeLabel:) interval:0.1f];
    [self schedule:@selector(update_:) interval:0.001f];
    
}

-(void)TIME_Stop{
    
 //   time = 0;
    [self unschedule:@selector(updateTimeLabel:)];
    [self unschedule:@selector(update_:)];
    
   // [self schedule:@selector(updateTimeLabel:) interval:0.1f];
//    [self schedule:@selector(update_:) interval:0.001f];
    
}

-(void)TIME_Pause{
    
        [self unschedule:@selector(updateTimeLabel:)];
        [self unschedule:@selector(update_:)];
    
}

-(void)TIME_Resume{
    
        TIME_LABEL.color = ccc3(238,194,0); // yellow
    
    
    if (levelPassed)     // In case if Level was passed successufully, time after resume will not go one
    {
        return;
    }
    
    [self schedule:@selector(updateTimeLabel:) interval:0.1f];
    [self schedule:@selector(update_:) interval:0.001f];

    
}

-(void)LEVEL_PASSED:(BOOL)v_{
    
    levelPassed = v_;
    
}

-(void)update_:(ccTime)dt{
        time+=1;
   // NSLog(@"time is %f",time);
}

-(void)updateTimeLabel:(ccTime)dt{

         NSString *stringTime = [NSString stringWithFormat:@"%02li:%02li:%02li",

                                 lround(floor(time / 3600.)) % 100,
                                 lround(floor(time / 60.)) % 60,
                                 lround(floor(time)) % 60];
    
//    if (time  > recordTime)
//    {
//        TIME_LABEL.color = ccRED;
//    }
    
    [TIME_LABEL setString:stringTime];
    lastTime = time;
    //[NSString stringWithFormat:@"%02f:%02f", time/60, time/60]];
    
}

-(void)showTutorial:(int)type_{
    
    if (TUTORIAL!=nil)
    {
   //     NSLog(@"tutorial is already NOT NIL");
      //  return;
    }
  //
  //  NSLog(@"show tutorial");
    
    TUTORIAL = [[TutorialVIEW alloc]initWithRect:
                CGRectMake(ScreenSize.width/2,
                           ScreenSize.height/2,
                                    kWidthScreen,
                                    kHeightScreen)
                                    levelNR:level type:type_];//autorelease];
   // TUTORIAL.parent = self;
    
    [self addChild:TUTORIAL z:Z_TUTORIAL];
    
    [self TIME_Stop];
    
    //[admin PAUSE];
    
}

-(int)getLevelNr{
    
    return level;
    
}

-(void)addBransLine{
    NSString *brainLine = @"topmenu_brainbg.png";
    if (IS_IPHONE) {
        brainLine =  @"topmenu_brainbg_iPhone.png";
    }
    CCSprite *brainLineSprite = [CCSprite spriteWithFile:brainLine];
    brainLineSprite.anchorPoint = ccp(0.5f, 0.5f);
    
    brainLineSprite.position = ccp(
                pause.position.x-(brainLineSprite.boundingBox.size.width/2)-(pause.boundingBox.size.width/2)-(offsetBRAINLINE),
                kHeightScreen-(brainLineSprite.boundingBox.size.height/2)-(offsetBRAINLINE));
    
    [self addChild:brainLineSprite];
 //   brainLineSprite.scale = kSCALE_FACTOR_FIX;
 //   brainLineSprite.opacity = 200;
    
    //add brains later
    for (int x = 0;  x < 3; x++) {
        
        BrainsBonus *BRAIN = [[[BrainsBonus alloc]initWithRect:CGRectMake(0, 0, 0, 0)]autorelease];
        BRAIN.tag = BRAIN1+x;
        BRAIN.anchorPoint = ccp(0.5f, 0.5f);
        BRAIN.scale = 0.8f;
        switch (x) {
            case 1:
                BRAIN.position = ccp(brainLineSprite.position.x, brainLineSprite.position.y);
                break;
            case 0:
                BRAIN.position = ccp(brainLineSprite.position.x-(brainLineSprite.boundingBox.size.width*0.3f), brainLineSprite.position.y);
                break;
            case 2:
                  BRAIN.position = ccp(brainLineSprite.position.x+(brainLineSprite.boundingBox.size.width*0.3f), brainLineSprite.position.y);
                break;
                
            default:
                break;
        }
        [self addChild:BRAIN];

    }
    

    [self setBRAINS_TO:0];
    
    brainsNR = 0;
    
}

-(void)increaseBRAINSNUMBER{
    
    brainsNR++;
    if (brainsNR > 3) {
        brainsNR = 3;
    }
    
    [db incraseBrainCounter];
    
    [AUDIO playEffect:fx_brainGet];
    
  //  NSLog(@"brain nr %i",brainsNR);
    [self setBRAINS_TO:brainsNR];
    
}

-(void)setBRAINS_TO:(int)nrOfBrains{
  //  NSLog(@"set brains to %i",nrOfBrains);
    //reset all
    for (int x = BRAIN1; x <BRAIN3+1; x++) {
        BrainsBonus *brain = (BrainsBonus*)[self getChildByTag:x];
        brain.brain.opacity = 100;
    }
    
    if (nrOfBrains< 1 || nrOfBrains > 3)
    {
        return;
    }
    //1
    switch (nrOfBrains) {
        case 1:{
            BrainsBonus *brain = (BrainsBonus*)[self getChildByTag:BRAIN1];
            brain.brain.opacity = 255.f;
         //   [self reorderChild:brain z:1000];
            }   
            break;
        case 2:{
            BrainsBonus *brain = (BrainsBonus*)[self getChildByTag:BRAIN1];
            brain.brain.opacity = 255.f;
            BrainsBonus *brain2 = (BrainsBonus*)[self getChildByTag:BRAIN2];
            brain2.brain.opacity = 255.f;
            }
            break;
        case 3:{
            BrainsBonus *brain = (BrainsBonus*)[self getChildByTag:BRAIN1];
            brain.brain.opacity = 255.f;
            BrainsBonus *brain2 = (BrainsBonus*)[self getChildByTag:BRAIN2];
            brain2.brain.opacity = 255.f;
            BrainsBonus *brain3 = (BrainsBonus*)[self getChildByTag:BRAIN3];
            brain3.brain.opacity = 255.f;
        }
            break;
            
        default:
            break;
    }
    
    
}

-(void)addHomeButton{
    
    CCSprite *home = [CCSprite spriteWithFile:@"Icon.png"];
    [self addChild:home z:1 tag:b_Home];
    home.anchorPoint = ccp(0,0);
    home.position = ccp(0,0);
    
}

-(void)addPauseButton{
    NSString *btnName = @"topmenu_pause.png";
    if (IS_IPHONE) {
        btnName = @"topmenu_pause_iPhone.png";
    }
    pause = [CCSprite spriteWithFile:btnName];
    [self addChild:pause z:0 tag:b_Pause];
    pause.anchorPoint = ccp(0.5f,0.5f);
 //   pause.opacity = 200;
   // pause.scale = kSCALE_FACTOR_FIX;
    pause.position = ccp(self.contentSize.width-[pause boundingBox].size.width/2-(offsetPAUSE),
                         kHeightScreen-(pause.boundingBox.size.height/2)-(offsetPAUSE));
    
}

-(void)musicFadeOut:(ccTime)dt{
    
    if (AUDIO.backgroundMusicVolume > 0.1f)
    {
        AUDIO.backgroundMusicVolume=AUDIO.backgroundMusicVolume-0.05f;
    }
    else
    [self unschedule:@selector(musicFadeOut:)];
    
}

-(void)musicFadeOutNow{
    
     [self schedule:@selector(musicFadeOut:) interval:0.1f];
    
}

-(void)saveRatingState{
    
    int shareCout = [Combinations getNSDEFAULTS_INT_forKey:C_GAME_RATED];
    
    if (shareCout < 0) {
        return;
    }
    shareCout++;
    [Combinations saveNSDEFAULTS_INT:shareCout forKey:C_GAME_RATED];
    
}

-(void)WINLevel{
    
    [Combinations saveNSDEFAULTS_Bool:YES forKey:C_TUTORIAL_([self level])];
    
    
    [self saveRatingState];
    
    [self musicFadeOutNow];
    
    //AUDIO.backgroundMusicVolume = 0;
    
 //   [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
    
    if ([cfg ifCihildExistInNode:self tag:kPAUSE])
    {
    //    NSLog(@"pause is already active");
        return;
    }
    
    /*
    NSString *stringTime = [NSString stringWithFormat:@"%02li:%02li:%02li",
                            
                            lround(floor(time / 3600.)) % 100,
                            lround(floor(time / 60.)) % 60,
                            lround(floor(time)) % 60];
    
    [TIME_LABEL setString:stringTime];
     */
    
    time = lastTime;
    
    PAUSE  = [[[PauseMenu alloc]initWithRect:CGRectMake(-(kPauseMenuW/2),
                                                        ScreenSize.height/2,
                                                        kPauseMenuW, kPauseMenuH)
                                        type:kWIN_WINDOW_TAG brainBonus:brainsNR milisesc:time level:level]autorelease];
    
    
    [self addChild:PAUSE z:15 tag:kPAUSE];
    //  PAUSE.delegate= parent;
    PAUSE.admin = self;
    PAUSE.delegate = self;
    
   // [self fadeINTOBLACKSCREEN:200.f time:0.2f];
    
}

-(void)restartLevel{
    
    [SceneManager goGameScene:[self getLevelNr]showTutorial:NO restart:YES];
    
}

-(void)LOST_AND_RESTART:(float)delay_{
    
    [AUDIO playEffect:fx_loosemusic];
    
    id delay =[CCDelayTime actionWithDuration:delay_];
    id delay2 =[CCDelayTime actionWithDuration:0.3f];
    id fade = [CCCallFunc actionWithTarget:self selector:@selector(fadeoutWithScreenPause)];
    id blockb = [CCCallFunc actionWithTarget:self selector:@selector(restartLevel)];
    [self runAction:[CCSequence actions:delay,fade,delay2,blockb, nil]];
    
    
    /*
    id one = [CCFadeTo actionWithDuration:0.5f opacity:255];
    
   // id blocka = [CCCallBlock actionWithBlock:^(void){ [self fadeINTOBLACKSCREEN:255.f time:0.2f];}];
    id blockb = [CCCallFunc actionWithTarget:self selector:@selector(restartLevel)];
    id sound = [CCCallBlock actionWithBlock:^(void) { [AUDIO playEffect:fx_loosemusic];}];
    id seq = [CCSequence actions:[CCDelayTime actionWithDuration:delay_],sound,one,blockb, nil];
    [blackBoard runAction:seq];
     */
    
}

-(void)Lost_STATE_AFTERDELAY:(float)delay_{
    
    if (LostLevelInstantRestart)
    {
        [self LOST_AND_RESTART:delay_];
    }
    
    else    [cfg runSelectorTarget:self selector:@selector(LOSTLevel) object:nil afterDelay:delay_ sender:self];
    
    //[self performSelector:@selector(LOSTLevel) withObject:nil afterDelay:delay_];
    
}

-(void)LOSTLevel{
    
 //    [AUDIO playEffect:fx_loosemusic];
    
    if (LostLevelInstantRestart)
    {
        [self LOST_AND_RESTART:0.f];
        
        return;
    }
    
    if ([cfg ifCihildExistInNode:self tag:kPAUSE])
    {
        NSLog(@"pause is already active");
        return;
    }
    
    [self TIME_Stop];
    
    PAUSE  = [[[PauseMenu alloc]initWithRect:CGRectMake(-(kPauseMenuW/2), ScreenSize.height/2, kPauseMenuW, kPauseMenuH) type:kLOOSE_WINDOW_TAG brainBonus:0 milisesc:0 level:level]autorelease];
    
    
    [self addChild:PAUSE z:15 tag:kPAUSE];
    //  PAUSE.delegate= parent;
    PAUSE.admin = self;
    PAUSE.delegate = self;
    
   // [self fadeINTOBLACKSCREEN:200.f time:0.2f];

    
}

-(void)fadeoutWithScreenPause{
    
    PAUSE  = [[[PauseMenu alloc]initWithRect:
               CGRectMake(ScreenSize.width/2,//-(kPauseMenuW/2),
                          ScreenSize.height/2,
                          kPauseMenuW,
                          kHeightScreen)//kPauseMenuH*0.8f)
                                        type:kRESTART_WINDOW_TAG
                                  brainBonus:0 milisesc:0 level:level]autorelease];
    
    
    [self addChild:PAUSE z:15 tag:kPAUSE];
    
}

-(void)pressedPause{
    
    //NSLog(@"admin is :%@",self.admin);

    if ([cfg ifCihildExistInNode:self tag:kPAUSE])
    {
        NSLog(@"pause is already active");
        return;
    }
    
    [self TIME_Pause];
    
    if ([self.admin respondsToSelector:@selector(GAME_PAUSE)])
    {
        [self.admin performSelector:@selector(GAME_PAUSE)];
    }
    
    
   // [[CCDirector sharedDirector] stopAnimation];
    
     
    
    //[self.admin pauseSchedulerAndActions];
    
  //  [[CCDirector sharedDirector] pause];
    
   // ccp(ScreenSize.width/2,ScreenSize.height/2)
    
    PAUSE  = [[[PauseMenu alloc]initWithRect:
               CGRectMake(ScreenSize.width/2,//-(kPauseMenuW/2),
                          ScreenSize.height/2,
                          kPauseMenuW,
                          kHeightScreen)//kPauseMenuH*0.8f)
                          type:kPAUSE_WINDOW_TAG
                          brainBonus:0 milisesc:0 level:level]autorelease];
    
    
    [self addChild:PAUSE z:15 tag:kPAUSE];
  //  PAUSE.delegate= parent;
    PAUSE.admin = self;
    PAUSE.delegate = self;
    
  //  [self fadeINTOBLACKSCREEN:120.f time:0.2f];
    
   // [self performSelector:@selector(PAUSE) withObject:nil afterDelay:0.7f];
}

-(void)PAUSE{
    
   //   [[CCDirector sharedDirector] stopAnimation];
    
}

-(void)fadeOUTBLACKSCREENINSTANT{
    
    [self fadeINTOBLACKSCREEN:0.f time:0.f];
    
}

-(void)SetBlackBoard_Z_InFront{
    
  //  [self reorderChild:blackBoard z:9999];
    
}

-(void)fadeINTOBLACKSCREEN{
    
    [self fadeINTOBLACKSCREEN:255.f time:0.2f];
    
}

-(void)fadeOUTBLACKSCREEN{
    
     [self fadeINTOBLACKSCREEN:0.f time:0.2f];
    
}

-(void)fadeINTOBLACKSCREEN:(float)percent_ time:(float)time_{
    
    [blackBoard runAction:[CCFadeTo actionWithDuration:time_ opacity:percent_]];
    
}

-(void)darkenScreenCreate{
    
    blackBoard = [[[CCSprite alloc]init]autorelease];
    
    [blackBoard setTextureRect:CGRectMake(0, 0, ScreenSize.width,
                                                ScreenSize.height)];
    
    blackBoard.anchorPoint = ccp(0.5f, 0.5f);
    
    blackBoard.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
    //ccp(self.contentSize.width/2,self.contentSize.height/2);
    
    [self addChild:blackBoard z:0];
    blackBoard.color = ccBLACK;
    blackBoard.opacity = 0;
    
}

-(void)goMainMenu{
    
    [SceneManager goMainMenu];
    
}

-(void)pressedHome{
    
    id  fade = [CCCallFunc actionWithTarget:self selector:@selector(fadeoutWithScreenPause)];
    id goMain = [CCCallFunc actionWithTarget:self selector:@selector(goMainMenu)];
    id delay = [CCDelayTime actionWithDuration:0.3f];
     id seq =[CCSequence actions:delay,goMain, nil];
  //  id seq =[CCSequence actions:fade,delay,goMain, nil];
    [self runAction:seq];
  //  [SceneManager goMainMenu];
    
}

- (CGRect)rectInPixels
{
    CGSize s = [self contentSize];
    return CGRectMake(0, 0, s.width, s.height);
}

- (BOOL)containsTouchLocation:(UITouch *)touch
{
    CGPoint p = [self convertTouchToNodeSpace:touch];
    CGRect r = [self rectInPixels];
    return CGRectContainsPoint(r, p);
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    NSSet *allTouches = [event allTouches];
    for (UITouch *aTouch in allTouches) {
        
        if ( ![self containsTouchLocation:aTouch] ) return NO;
    }
  //  NSLog(@"there is a touch");
    
     CGPoint location = [self convertTouchToNodeSpace:touch];
//      if (CGRectContainsPoint([[self getChildByTag:b_Home]boundingBox], location)) {
//          //NSLog(@"pressed home");
//          [self pressedHome];
//      }
    
       if (CGRectContainsPoint([[self getChildByTag:b_Pause]boundingBox], location)) {
        //NSLog(@"pressed home");
    //    NSLog(@"pressed pause");
        [self pressedPause];
            [AUDIO playEffect:fx_buttonclick];
           [cfg clickEffectForButton:[self getChildByTag:b_Pause]];
           return YES;
    }
    /*
    if (CGRectContainsPoint([[self getChildByTag:b_MANA]boundingBox], location)) {
        //NSLog(@"pressed home");
     //   NSLog(@"pressed pause");
      //  [self pressedPause];
        [self pressedOnMANA];
        
        [cfg clickEffectForButton:[self getChildByTag:b_MANA]];
        return YES;
    }
     */
    
//    if (CGRectContainsPoint([[spritesBgNode getChildByTag:b_continueFromTutorial] boundingBox], location))
//    {
//        [cfg clickEffectForButton:[spritesBgNode getChildByTag:b_continueFromTutorial]];
//        NSLog(@"pressed continue");
//        [self showTutorial:NO];
//        return YES;
//    }
    
    return NO;
   
}





-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
}

-(void)addButtons{
    
    
    
}

-(void)onEnter //---cia leidzia naudoti touch komandas. onEnter nereikia niekur kviest, jisai pats pirmas pasileidzia pagal prioriteta netgi jo neisrasiu i init
{
    
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:touch_InGameMenu swallowsTouches:YES];
    
    [super onEnter];
}

- (void)onExit
{
    
    [self removeAllChildrenWithCleanup:YES];
    
    [[CCTouchDispatcher sharedDispatcher]removeDelegate:self];
    
    [super onExit];
    
}

-(void) dealloc
{
    //CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
  //  NSLog(@"dealloc: %@", self);
    [admin release];
	admin =  nil;
	[super dealloc];
}



@end
