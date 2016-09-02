//
//  ScoreBlock.m
//  Zombie Joe
//
//  Created by Mac4user on 6/12/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "ScoreBlock.h"
#import "cfg.h"
#import "Constants.h"

#import "B6luxFacebook.h"
#import "B6luxPopUpManager.h"
#import "B6luxTwitter.h"
#import "FacebookManager.h"
#import "b6luxLoadingView.h"
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import "JoeZombieController.h"

#define Z_YellowCircle 2
#define Z_BlackCircle 1
#define Z_BatchNOde 3

#define Z_BRAIN_INACTIVE 3
#define Z_BRAIN_ACTIVE 4

#define Z_NEWRECORD 5
#define Z_POINTS_LABELS 2

#define Z_WORLDRECORD_LABEL 7
#define Z_WORLDRECORD_SCORES 8


#define BRAIN_INACTIVE_TAG 100
#define BRAIN_ACTIVE_TAG 200

#define TWITTER_TAG 301
#define FB_TAG      302
#define GC_TAG      304

#define ZOMBIE_J   303

#define FILL_CIRCLE_TIME 2.f

#define FILL_CIRCLE_TIME_BONUS 0.5f

#define JOE_SCALE 0.75f

#define SCORE_LABEL_T_INTERVERL 0.1f

#define SCORE_LABEL_T_BONUS_INTERVAL 0.1f

#define WHEEL_WIBRATE_INTERVAL 0.02f

#define JOE [spritesBgNode getChildByTag:ZOMBIE_J]

#define BONUS_COEFF ((16.6666f/100)*2)


@implementation ScoreBlock{
    
        JoeZombieController *JoeRobot;
    
}
@synthesize delegate;

-(id)initWithRect_:(CGRect)rect scored:(int)milisec level:(int)level_ brains:(int)brains_{
    
    if((self = [super init]))
    {
        
        self.anchorPoint = ccp(0.5f,0.f);
        self.contentSize = CGSizeMake(rect.size.width,
                                  rect.size.height);
    
        self.position = ccp(rect.origin.x, rect.origin.y);
        
        CGSize rez  = [cfg getScoresByLevel:level_ time:milisec brains:brains_];   //WIDTH -> SCORE
        score = rez.width;
        percentFILL = rez.height/2;   //--->HEIGHT - >procent to fill. 50 % max
        brainNR = brains_;
        brainBonusVisible = 0;
        level = level_;
        time = milisec;
        
        if (level_ != 0)
        {
            [self fastScoreSavings];
            [self getTopPlayer];
        }
        
        [self addWHEELPar];
        [self addBatchNode];
        [self addCircle];
        [self addJoe];
        
        [self addZombastic];
        [self addBrains];
        [self addPointsNScoreLabel];
        [self addFB_N_TwitterShareBtns];
        
        [self preloadLabels];
        
        [self moveInActions];
        
    }
     return self;
}

-(void)preloadLabels
{
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"WORLD RECORD:" dimensions:contentSize_ alignment:UITextAlignmentRight fontName:@"StartlingFont" fontSize:IS_IPAD ? 35 : 15];
    label.position = ccp(-500, -100);
    label.color = ccc3(101, 154, 226);
    label.opacity = 0;
    [self addChild:label z:Z_WORLDRECORD_LABEL tag:Z_WORLDRECORD_LABEL];
    
    CCLabelTTF *label1 = [CCLabelTTF labelWithString:@"" dimensions:contentSize_ alignment:UITextAlignmentLeft fontName:@"StartlingFont" fontSize:IS_IPAD ? 35 : 15];
    label1.position = ccp(-500, -100);
    label1.color = ccc3(176, 48, 96);
    label1.opacity = 0;
    [self addChild:label1 z:Z_WORLDRECORD_LABEL tag:Z_WORLDRECORD_SCORES];

}

-(void)getTopPlayer{
    
    topPlayerScore = [[gc_ returnTopPlayerByCategory:gc_LEVEL(level)
                                                    type:gc_TopPlayerScore]intValue];
    
   // NSLog(@"TOP PLAYER %i",topPlayerScore);
    
//    NSString *topPlayerName = [gc_ returnTopPlayerByCategory:gc_LEVEL(level)
//                                                        type:gc_TopPlayerNickName];
    
    //NSLog(@"TOP PLAYER %@ %i",topPlayerName,topPlayerScore);
}

-(void)fastScoreSavings{
    
    scoreFastFinal = score;
    
    for (int x = 1; x <=brainNR; x++)
    {
        scoreFastFinal=scoreFastFinal+(scoreFastFinal*(BONUS_COEFF));
    }
    
    //
    
    // save brains
    
//    int BrainWas = [Combinations getNSDEFAULTS_INT_forKey:C_BRAIN_RECORD_LEVEL(level)];
//    
//    if (BrainWas < brainNR)
//    {
//          [Combinations saveNSDEFAULTS_INT:brainNR forKey:C_BRAIN_RECORD_LEVEL(level)];
//    }
    
    if ([db getHighScoreForLevel:level] < scoreFastFinal)
    {
        newRecord = YES;
        [Combinations saveNSDEFAULTS_INT:brainNR forKey:C_BRAIN_RECORD_LEVEL(level)];
    }
    
    [db setScoreForLevel:level score:scoreFastFinal time:time];
    
    [db ShowAllRecordsFromScoresTable];
    
    
    [gc_ submitScore:scoreFastFinal level:level];
    
    [gc_ submitMainScore:[db getAllLevelsScore]];
    
    [gc_ submitBrainScore:[db getBrainsCounter]];
    
    //SS
    [db SS_endgame_player:[gc_ getLocalPlayerAlias] level:level brains:brainNR time:time score:scoreFastFinal];
    
}

-(void)showNewRecordImage{

    CCSprite *nr = [CCSprite spriteWithSpriteFrameName:@"newrecord.png"];
    [self addChild:nr z:Z_NEWRECORD tag:Z_NEWRECORD];
    nr.anchorPoint = ccp(1.0f, 0.1f);
    nr.position = ccp(kWidthScreen+nr.contentSize.width, kHeightScreen/6);
    nr.rotation = 30;
    
    CGPoint pos__;
    if (IS_IPHONE_5) {
       pos__ = [self convertToNodeSpace:ccp(kWidthScreen, kHeightScreen/6.5)];
    }
    else if (IS_IPHONE) {
       pos__ = [self convertToNodeSpace:ccp(kWidthScreen+nr.contentSize.width/3, kHeightScreen/6.5)];
    }
    else if (IS_IPAD){
       pos__ = [self convertToNodeSpace:ccp(kWidthScreen+nr.contentSize.width/3, kHeightScreen/5)];
    }
    [nr runAction:[CCSequence actions:[CCSpawn actions:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:0.2f position:pos__] rate:2],[CCEaseInOut actionWithAction:[CCRotateTo actionWithDuration:0.3f angle:-10] rate:2], nil],[CCEaseInOut actionWithAction:[CCRotateTo actionWithDuration:0.1f angle:0] rate:2], nil]];

    // 08-08
    
    NSString *NEW_RECORD_TEXT = @"";
    
  //  NSLog(@"TOP PLAYER SCORE %i",topPlayerScore);
    
    if (newRecord)
    {
        //        NSLog(@"WORLD RECORD ........... %d", topPlayerScore);
        //        NSLog(@"NEW   RECORD ........... %d", scoreFastFinal);
        
        if (topPlayerScore <= 0)   NEW_RECORD_TEXT = @"MY NEW \n RECORD!";
        
        else if (scoreFastFinal > topPlayerScore)
        {
            NEW_RECORD_TEXT = @"NEW WORLD \n RECORD!";
        }
        else
        {
            NEW_RECORD_TEXT = @"MY NEW \n RECORD!";
        }
    }
    
    float Hg;
    float Wd;
    
    if (IS_IPAD)        { Hg = 0.82f; Wd = 0.1f; }
    if (IS_IPHONE_5)    { Hg = 0.75f; Wd = 0.35f; }
    else if(IS_IPHONE)  { Hg = 0.98f; Wd = 0.1f; }
    
    CCLabelTTF *NRlabel = [CCLabelTTF labelWithString:NEW_RECORD_TEXT dimensions:contentSize_ alignment:UITextAlignmentCenter fontName:@"StartlingFont" fontSize:IS_IPAD ? 28 : 14];
    NRlabel.position = ccp(((-[self getChildByTag:Z_NEWRECORD].contentSize.width * Wd) + kWidthScreen*0.2f) * (kSCALEVAL_IPHONE) , ([self getChildByTag:Z_NEWRECORD].contentSize.height * Hg) * (kSCALEVAL_IPHONE));
    [[self getChildByTag:Z_NEWRECORD] addChild:NRlabel z:Z_WORLDRECORD_LABEL tag:Z_WORLDRECORD_LABEL];
    
    //
    
}
-(void)showWorldRecord
{
    if (topPlayerScore > 0) {
        
        int x;
        if (IS_IPAD) {x = -690;}else if (IS_IPHONE_5){x = -290;}else if (IS_IPHONE){x = -300;}
        int x_;
        if (IS_IPAD) {x_ = 420;}else if (IS_IPHONE_5){x_ = 250;}else if (IS_IPHONE){x_= 200;}
        int y;
        if (IS_IPAD) {y = -100;} else {y = -30;}
        
    [self getChildByTag:Z_WORLDRECORD_LABEL].position = ccpAdd(SCORE_LABEL.position, ccp(x*(kSCALEVAL_IPHONE), y*(kSCALEVAL_IPHONE)));
    
        CCLabelTTF *l = (CCLabelTTF *)[self getChildByTag:Z_WORLDRECORD_SCORES];
        l.string = [NSString stringWithFormat:@"%i",topPlayerScore];
        
    [[self getChildByTag:Z_WORLDRECORD_LABEL] runAction:[CCFadeTo actionWithDuration:0.2f opacity:255]];
    
    
    [self getChildByTag:Z_WORLDRECORD_SCORES].position = ccpAdd(SCORE_LABEL.position, ccp([self getChildByTag:Z_WORLDRECORD_LABEL].position.x + x_*(kSCALEVAL_IPHONE), y*(kSCALEVAL_IPHONE)));
    
    [[self getChildByTag:Z_WORLDRECORD_SCORES] runAction:[CCFadeTo actionWithDuration:0.2f opacity:255]];
        
    }

}

-(void)finishedCalcucations{

    if (newRecord)
    {
        [AUDIO playEffect:fx_newrecord];
        [self showNewRecordImage];
    }
    
    [self showFBTW];
    [self showWorldRecord];
    
    //  show top player
    //  cclabel TWOJ if record - >color pink
    

}

-(void)calculateBonusBrains{
    
    if (brainNR==0)
    {
     //   NSLog(@"No bonus");
        [self finishedCalcucations];
        return;
    }
    
   else if (brainNR > 0 && brainNR < 4)
   {
      //  NSLog(@"there is bonus left :%i",brainNR);
        brainNR--;
       
       [AUDIO playEffect:fx_blockGot];

     //  score=score+scoreToAdd;  //score+(score*(BONUS_COEFF));
       
       score=score+(score*(BONUS_COEFF));
       
        float oldPercent = percentFILL;
       
       percentFILL = percentFILL + percentFILL*BONUS_COEFF;    //first is 16
       
    //    percentFILL = percentFILL+percentToAdd;//(percentFILL*BONUS_COEFF);    //first is 16
       
        [self schedule:@selector(fillBonuScore:) interval:SCORE_LABEL_T_INTERVERL];
       
        [self zoomWheel];
       
        [self AddBonusBrainImage];
       
        CCProgressFromTo *to1 = [CCProgressFromTo actionWithDuration:FILL_CIRCLE_TIME_BONUS
                                                                from:oldPercent
                                                                  to:percentFILL];
       
       [yellowBar runAction:to1];

    }

}

-(void)AddBonusBrainImage{  //make brain visible
    
    for (int x = 0; x  < 3; x ++) {
        if (![spritesBgNode getChildByTag:BRAIN_ACTIVE_TAG+x].visible)
        {
            [spritesBgNode getChildByTag:BRAIN_ACTIVE_TAG+x].visible = YES;
            break;
        }
    }
}

-(void)zoomWheel{
    
    id sscaleUp =    [CCScaleTo    actionWithDuration:0.05f scale:1.03f];
    id easeScale =   [CCEaseElasticInOut actionWithAction:sscaleUp];
    
    id scaleBack =  [CCScaleTo actionWithDuration:0.1f scale:1.f];
    id scaleBack_ = [CCEaseElasticInOut actionWithAction:scaleBack];
    
    [wheelPAR runAction:[CCSequence actions:sscaleUp,scaleBack_, nil]];
    
    //[[spritesBgNode getChildByTag:TWITTER_TAG] runAction:easeScale];
    
   // [[spritesBgNode getChildByTag:FB_TAG] runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.15f],easeScaleT, nil]];
    
}

-(void)fillBonuScore:(ccTime)dt{
    
    
 [self soundfillStart];
    
    score_FILL+=score/((FILL_CIRCLE_TIME)*9);   //10 must be.
    
    if (score_FILL > score)
    {
        
        [self soundfillStop];
        [self unschedule:@selector(fillBonuScore:)];
        
         score_FILL = score;
        
         [SCORE_LABEL setString:[NSString stringWithFormat:@"%i",score_FILL]];
        
        [self calculateBonusBrains];
        
//         [self performSelector:@selector(calculateBonusBrains)
//                    withObject:nil
//                    afterDelay:0.f];    //0.25f was before
         return;
    }
    
    [SCORE_LABEL setString:[NSString stringWithFormat:@"%i",score_FILL]];
    
}

-(void)soundfillStop{
    
    [SOUND_ stopSound:l1_itemclick fadeOut:NO];
    fillSound = NO;
}

-(void)soundfillStart{
    
    if (!fillSound) {
         [SOUND_ playSound:l1_itemclick looping:YES fadeIn:NO];
        fillSound = YES;
    }

    
}

-(void)fillSCORE:(ccTime)dt{
    
        [self soundfillStart];
    
    score_FILL+=score/((FILL_CIRCLE_TIME)*9);   //10 must be.
    
    if (score_FILL >=score)
    {
        [self unschedule:@selector(fillSCORE:)];
        [self unschedule:@selector(shakeWheel)];
        
        //must show here FB & TW
       // return;
        score_FILL = score;
        [self calculateBonusBrains];
        
        [self soundfillStop];
    }
    
   // [self shakeWheel];
    
    [SCORE_LABEL setString:[NSString stringWithFormat:@"%i",score_FILL]];

}

-(void)shakeWheel{
    
    if (wheelPAR.scale == 1)
    {
        wheelPAR.scale = 1.004f;
    }
    else if (wheelPAR.scale == 1.004f)
    {
        wheelPAR.scale = 1.f;
    }
    
}

-(void)plauFBTWGCSOUND{
    
    [AUDIO playEffect:l1_itemclick];
    
}

-(void)showFBTW{
    
    id sscaleUp =    [CCScaleTo    actionWithDuration:0.5f scale:1.f];
    id easeScale = [CCEaseElasticInOut actionWithAction:sscaleUp];
    
    [[spritesBgNode getChildByTag:TWITTER_TAG] runAction:easeScale];
    
    id sscaleUpT =    [CCScaleTo    actionWithDuration:0.5f scale:1.f];
    id easeScaleT = [CCEaseElasticInOut actionWithAction:sscaleUpT];
    
    id sscaleUpGc =    [CCScaleTo    actionWithDuration:0.5f scale:1.f];
    id easeScaleGc = [CCEaseElasticInOut actionWithAction:sscaleUpGc];
    
    [[spritesBgNode getChildByTag:FB_TAG] runAction:[CCSequence actions:[[CCDelayTime actionWithDuration:0.15f]copy],easeScaleT, nil]];
    
      [[spritesBgNode getChildByTag:GC_TAG] runAction:[CCSequence actions:[[CCDelayTime actionWithDuration:0.30f]copy],easeScaleGc, nil]];
    
}

-(void)FillCircle_DEFAULT{  //the first fill depending ont the time-score
    
    [self schedule:@selector(fillSCORE:) interval:SCORE_LABEL_T_INTERVERL];
    
    [self schedule:@selector(shakeWheel) interval:WHEEL_WIBRATE_INTERVAL];
    
    CCProgressFromTo *to1 = [CCProgressFromTo actionWithDuration:FILL_CIRCLE_TIME from:0 to:percentFILL];
    
    [yellowBar runAction:to1];
    
}

-(void)moveInActions {
    
  //  [self JoeMoveIn];
    
    [self CircleMoveIn];
    
}

-(void)JoeMoveIn{
    
    JoeRobot.scale = 0.4f;
    id sscaleUp =    [CCScaleTo    actionWithDuration:1.f scale:0.85f];
    id easeScaleJoe =[CCEaseElasticInOut actionWithAction:sscaleUp];
    
    [JoeRobot runAction:
     [CCSequence actions:easeScaleJoe, nil]];
    
    /*
    JOE.scale = 0.6;
    
    id sscaleUp =    [CCScaleTo    actionWithDuration:1.f scale:JOE_SCALE];
    id easeScaleJoe =[CCEaseElasticInOut actionWithAction:sscaleUp];
    
    [JOE runAction:
     [CCSequence actions:easeScaleJoe, nil]];
    */
}

-(void)CircleMoveIn{
    
    id unRotate = [CCRotateTo actionWithDuration:0.3f angle:10];
    id ease = [CCEaseBackInOut actionWithAction:unRotate];
    
    id moveF = [CCMoveTo actionWithDuration:0.2f position:ccp(5, 0)];
    id moveFEase = [CCEaseIn actionWithAction:moveF];
    id spawnRotMove = [CCSpawn actions:ease,moveFEase, nil];
    
    id unRotateDef = [CCRotateTo actionWithDuration:0.3f angle:0];
    id easedef = [CCEaseBackOut actionWithAction:unRotateDef];
    
    id moveFBack = [CCMoveTo actionWithDuration:0.2f position:ccp(0, 0)];
    id moveFBEase = [CCEaseBackOut actionWithAction:moveFBack];
    id spawnRotMoveBack = [CCSpawn actions:easedef,moveFBEase, nil];
    
    id enableFill = [CCCallFunc actionWithTarget:self selector:@selector(FillCircle_DEFAULT)];  //enable filling the score label
    
    [wheelPAR runAction:
     [CCSequence actions:
      [CCDelayTime actionWithDuration:0.3f],spawnRotMove,spawnRotMoveBack,enableFill, nil]];
    
}



-(void)addWHEELPar{
    
    wheelPAR = [[[CCNode alloc]init]autorelease];
    wheelPAR.rotation = -20;
    wheelPAR.scale = 1;
    
    [self addChild:wheelPAR];
    
}

-(void)addBrains{
    //inactive
    int bonus = 0;
            for (int x = BRAIN_INACTIVE_TAG; x < BRAIN_INACTIVE_TAG+3; x++)
            {
                CCSprite *brain = [CCSprite spriteWithSpriteFrameName:@"brains_inactive.png"];
                CCSprite *brainA = [CCSprite spriteWithSpriteFrameName:@"brains_active.png"];
                
                [spritesBgNode addChild:brain z:Z_BRAIN_INACTIVE  tag:x];
                [spritesBgNode addChild:brainA z:Z_BRAIN_ACTIVE tag:BRAIN_ACTIVE_TAG+bonus];
                
                if (x == BRAIN_INACTIVE_TAG)
                {
                    brain.position = ccpAdd(yellowBar.position,
                                            ccp(yellowBar.contentSize.width*0.28f,
                                                yellowBar.contentSize.width*0.3f)
                                            );
                    brain.rotation = 45;

                }
               else if (x == BRAIN_INACTIVE_TAG+1)
                {
                    brain.position = ccpAdd(yellowBar.position,
                                            ccp(yellowBar.contentSize.width*0.375f,
                                                yellowBar.contentSize.width*0.125f)
                                            );
                    brain.rotation = 75;

                }
               else if (x == BRAIN_INACTIVE_TAG+2)
               {
                   brain.position = ccpAdd(yellowBar.position,
                                           ccp(yellowBar.contentSize.width*0.38f,
                                               -yellowBar.contentSize.width*0.085f)
                                           );
                   brain.rotation = 100;

               }
                
                brainA.position = brain.position;
                brainA.rotation = brain.rotation;
                brainA.visible = NO;
                bonus++;
                
              //  NSLog(@"brain bonus is %i",BRAIN_ACTIVE_TAG+bonus);
            }
    
    //ACTIVE
    
}

-(void)addFB_N_TwitterShareBtns{
    
    //TW
    
    CCSprite *TW = [CCSprite spriteWithSpriteFrameName:@"btn_twitter.png"];
    
    TW.anchorPoint = ccp(0.5f, 0.5f);
    
    TW.position =   ccpAdd(SCORE_LABEL.position, ccp(-TW.contentSize.width*1.25f, -SCORE_LABEL.contentSize.height*0.55f));
    
    [spritesBgNode addChild:TW z:1 tag:TWITTER_TAG];
    
   // TW.visible = NO;
    
    TW.scale = 0;
    
    //FB
    
    CCSprite *FB = [CCSprite spriteWithSpriteFrameName:@"btn_facebook.png"];
    
    FB.anchorPoint = ccp(0.5f, 0.5f);
    
    FB.position =   ccpAdd(SCORE_LABEL.position, ccp(0, -SCORE_LABEL.contentSize.height*0.55f));
    
    [spritesBgNode addChild:FB z:1 tag:FB_TAG];
    
   // FB.visible = NO;
    
    FB.scale = 0;
    
    
    
    
    CCSprite *gamec = [CCSprite spriteWithSpriteFrameName:@"btn_gamecenter.png"];
    
    gamec.anchorPoint = ccp(0.5f, 0.5f);
    
    gamec.position =   ccpAdd(SCORE_LABEL.position, ccp(TW.contentSize.width*1.25f, -SCORE_LABEL.contentSize.height*0.55f));
    
    [spritesBgNode addChild:gamec z:1 tag:GC_TAG];
    
    // FB.visible = NO;
    
    gamec.scale = 0;
     
}

-(void)addPointsNScoreLabel{
    
    CCSpriteBatchNode *fontBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"startlight_font72.png"];
    [self addChild:fontBatchNode z:1];
    
    
    
   CCLabelBMFont *PTLABEL = [CCLabelBMFont labelWithString:@"POINTS" fntFile:kFONT_LARGE];
    PTLABEL.anchorPoint = ccp(0.5f, 0.5f);
    PTLABEL.position = ccp(yellowBar.position.x * 3,
                              yellowBar.position.y+(yellowBar.contentSize.height*0.2f));
    PTLABEL.color = ccc3(238,194,0);

    [self addChild:PTLABEL z:Z_POINTS_LABELS];
    
    SCORE_LABEL = [CCLabelBMFont labelWithString:@"    " fntFile:kFONT_SUPER_LARGE];
    SCORE_LABEL.anchorPoint = ccp(0.5f, 0.5f);
    SCORE_LABEL.position = ccpAdd(PTLABEL.position, ccp(0, -yellowBar.contentSize.height*0.25f));
    SCORE_LABEL.color = ccc3(238,194,0);
    SCORE_LABEL.scale = 0.9f;
    [self addChild:SCORE_LABEL z:Z_POINTS_LABELS];
    
}

-(void)addACTIVEBrains:(int)nrOfAchievedBrains{
    
    
    
}

-(void)addZombastic{
    
    CCSprite *zombastic = [CCSprite spriteWithSpriteFrameName:@"victory_text.png"];
    
    zombastic.anchorPoint = ccp(0.5f, 0.5f);
    
    float YposFix = (IS_IPAD) ? 73 : 33;
    float XposFix = (IS_IPAD) ? -93 : -43.f;
    
    zombastic.position =   ccpAdd(yellowBar.position, ccp(XposFix, YposFix));
    
    [spritesBgNode addChild:zombastic z:Z_BlackCircle];
    
}

-(void)addJoe{
    
    /*
    
    CCSprite *Joe = [CCSprite spriteWithSpriteFrameName:@"zombie_victory.png"];
    
    Joe.anchorPoint = ccp(0.5f, 0.5f);
    
    float YposFix = (IS_IPAD) ? 17 : 8;
    
    Joe.position =   ccpAdd(yellowBar.position, ccp(0, YposFix));
    
    Joe.scale = JOE_SCALE;
    
    [www addChild:Joe z:0 tag:ZOMBIE_J];
     
     */
    
     float YposFix = (IS_IPAD) ? -17 : -7;
     float XposFix = (IS_IPAD) ? 5 : 3;
    
    JoeRobot = [[[JoeZombieController alloc]initWitPos:ccpAdd(yellowBar.position, ccp(XposFix, YposFix)) size:CGSizeMake(20, 20) sender:nil]autorelease];
    JoeRobot.scale = 0.85f;
    [wheelPAR addChild:JoeRobot z:100];
    [[JoeRobot robot_]JOE_IDLE];
    
    [[JoeRobot robot_]makeOpacityForPart:8 opacity:0];
    [[JoeRobot robot_]makeOpacityForPart:13 opacity:0];
    [[JoeRobot robot_]makeOpacityForPart:14 opacity:0];
    [[JoeRobot robot_]makeOpacityForPart:5 opacity:0];
    [[JoeRobot robot_]makeOpacityForPart:6 opacity:0];
    
    JoeRobot.anchorPoint = ccp(0.5f, 0.5f);
    
    //[[JoeRobot robot_]makeOpacityOfAllParts:100];
    
    //add pants
    
    CCSprite *pants = [CCSprite spriteWithSpriteFrameName:@"pants.png"];
    [wheelPAR addChild:pants z:Z_BlackCircle-1];
    pants.scale = 0.85f;
    pants.position = ccpAdd(JoeRobot.position,
                            ccp([[JoeRobot robot_]getChildByTag:8].position.x*0.85f,
                                [[JoeRobot robot_]getChildByTag:8].position.y*0.8875f));
    
  //  JoeRobot.position = ccpAdd(yellowBar.position, ccp(0, YposFix));
    
}

-(void)addCircle{
    
    CCSprite *circleBlack = [CCSprite spriteWithSpriteFrameName:@"circle0.png"];
    
    circleBlack.anchorPoint = ccp(0, 0.5f);
    
    circleBlack.position =   ccp(0, self.contentSize.height/2);
    
    [wheelPAR addChild:circleBlack z:Z_BlackCircle];
    
    //yellow bar add
    
    NSString *yelStr = (IS_IPAD) ? @"circle1.png" : @"circle1_iPhone.png";

        yellowBar = [CCProgressTimer progressWithFile:yelStr];

        yellowBar.type = kCCProgressTimerTypeRadialCW;
    
        yellowBar.anchorPoint = ccp(0.5f, 0.5f);

        yellowBar.position = ccpAdd(circleBlack.position,
                                ccp(circleBlack.boundingBox.size.width/2,0));

        [wheelPAR addChild:yellowBar z:Z_YellowCircle  ];


}
//-(void)addPercent:(CCNode*)node_{
//    
//    
//    
//    CCProgressFromTo *to2 = [CCProgressFromTo actionWithDuration:1 from:50 to:75];
//    
//    [node_ runAction:to2];
//    
//    
//    
//}


-(void)addBatchNode{
    
    NSString *spritesStr =      [NSString stringWithFormat:@"ScoreBlockSprites_iPhone"];
    if (IS_IPAD) spritesStr =   [NSString stringWithFormat:@"ScoreBlockSprites"];
    
   spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz",spritesStr]];
    [wheelPAR addChild:spritesBgNode z:Z_BatchNOde];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache]
     addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist",spritesStr]];
    
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    
    CGPoint location = [self convertTouchToNodeSpace:touch];
    
    if (CGRectContainsPoint([[spritesBgNode getChildByTag:FB_TAG]boundingBox], location)) {
        [AUDIO playEffect:fx_buttonclick];
        [cfg clickEffectForButton:[spritesBgNode getChildByTag:FB_TAG]duration:0.1f];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0){
            
            if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
                UIAlertView *alertView = [[[UIAlertView alloc]
                                           initWithTitle:@"Sorry"
                                           message:@"You can't send a post right now, make sure your device has an internet connection and you have at least one Facebook account setup"
                                           delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil]autorelease];
                [alertView show];
                return NO;
            }
        }
        
        if (![Combinations connectedToInternet]){
            
            // B6luxPopUpManager *b = [[[B6luxPopUpManager alloc]init]autorelease];
            [B6luxPopUpManager internetConnectionPopUp];
            return NO;
        }
        
        UIView *view__ = [[[b6luxLoadingView alloc]init]autorelease];
        view__.tag = kLOADINGTAG;
        [[[CCDirector sharedDirector] openGLView]addSubview:view__];
        
        
        
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.2f],[CCCallBlock actionWithBlock:^{
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0){
                
                for (CCNode *childrr in self.children) {
                    if ([childrr isKindOfClass:[B6luxFacebook class]]) {
                        if ([[[CCDirector sharedDirector] openGLView]viewWithTag:kLOADINGTAG]) {
                            [[[[CCDirector sharedDirector] openGLView]viewWithTag:kLOADINGTAG]removeFromSuperview];
                        }
                        return ;
                    }
                }

                B6luxFacebook * _facebook = [[[B6luxFacebook alloc] init] autorelease];
                [self addChild:_facebook z:999 tag:999989];
                [_facebook share_withScreenShot:YES text:[cfg postSoscialWith_level:level] url:iTunesLink];
            }
            else
            {
                [[FacebookManager sharedMgr] Feed:self];
            }
            
            
        }], nil]];
        return YES;
    }
    
    else if (CGRectContainsPoint([[spritesBgNode getChildByTag:TWITTER_TAG]boundingBox], location)) {
        [AUDIO playEffect:fx_buttonclick];
        [cfg clickEffectForButton:[spritesBgNode getChildByTag:TWITTER_TAG]duration:0.1f];
        
        if (![TWTweetComposeViewController canSendTweet]) {
            
            UIAlertView *alertView = [[[UIAlertView alloc]
                                       initWithTitle:@"Sorry"
                                       message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                       delegate:self
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil]autorelease];
            [alertView show];
            
            return NO;
        }
        
        if (![Combinations connectedToInternet]) {
            
            // B6luxPopUpManager *b = [[[B6luxPopUpManager alloc]init]autorelease];
            [B6luxPopUpManager internetConnectionPopUp];
            return NO;
        }
        
        UIView *view__ = [[[b6luxLoadingView alloc]init]autorelease];
        view__.tag = kLOADINGTAG;
        [[[CCDirector sharedDirector] openGLView]addSubview:view__];
        
        
        
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.2f],[CCCallBlock actionWithBlock:^{
            for (CCNode *childrr in self.children) {
                if ([childrr isKindOfClass:[B6luxTwitter class]]) {
                    if ([[[CCDirector sharedDirector] openGLView]viewWithTag:kLOADINGTAG]) {
                        [[[[CCDirector sharedDirector] openGLView]viewWithTag:kLOADINGTAG]removeFromSuperview];
                    }
                    return ;
                }
            }
            B6luxTwitter*_twitter = [[[B6luxTwitter alloc]init]autorelease];
            [self addChild:_twitter z:999 tag:9999];
            [_twitter tweet_withScreenShot:YES text:[cfg postSoscialWith_level:level]];//twitterPOSTtxt];
            
        }], nil]];
        return YES;
    }
    else if (CGRectContainsPoint([[spritesBgNode getChildByTag:GC_TAG]boundingBox], location)) {
        [AUDIO playEffect:fx_buttonclick];
        [cfg clickEffectForButton:[spritesBgNode getChildByTag:GC_TAG]duration:0.1f];
        
        if (![Combinations connectedToInternet]) {
            
            //B6luxPopUpManager *b = [[[B6luxPopUpManager alloc]init]autorelease];
            [B6luxPopUpManager internetConnectionPopUp];
            return NO;
        }
        
        if (![gc_ isLeaderboardShow]) {
            UIView *view__ = [[[b6luxLoadingView alloc]init]autorelease];
            view__.tag = kLOADINGTAG;
            [[[CCDirector sharedDirector] openGLView]addSubview:view__];
            
        }
        
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.2f],[CCCallBlock actionWithBlock:^{
            if (![gc_ isLeaderboardShow]) {
                [gc_ showLeaderboard:gc_LEVEL(level)];
            }
            
        }], nil]];
        
        return YES;
    }
    return NO;
}

-(void)onEnter
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:touch_InGameMenu-(1) swallowsTouches:YES];
    
    [super onEnter];
}

- (void)onExit
{
    [self soundfillStop];
    [self removeAllChildrenWithCleanup:YES];
    
    [[CCTouchDispatcher sharedDispatcher]removeDelegate:self];
    
    [super onExit];
    
}

-(void) dealloc
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    [delegate release];
    delegate = nil;
    
	[super dealloc];
}


@end
