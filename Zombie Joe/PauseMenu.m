//
//  PauseMenu.m
//  Zombie Joe
//
//  Created by Mac4user on 4/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "PauseMenu.h"
#import "cfg.h"
#import "Constants.h"
#import "SceneManager.h"

#import "JOE_C.h"
#import "B6luxPopUpManager.h"

#define b_goHome    0
#define b_restart   1
#define b_info      2
#define b_continue  3
#define b_tutorial  4

#define kJoeFace   5

#define type_continue_afterLevelBegin   1
#define type_continue_afterInfo         2

#define p_pauseButtonH  0.5f

@implementation PauseMenu
@synthesize delegate;
@synthesize admin;

-(id)initWithRect:(CGRect)rect type:(int)type_ brainBonus:(int)brains_ milisesc:(int)milisec_ level:(int)level_{
    
    if((self = [super init]))
    {
        self.anchorPoint = ccp(0.5f,0.5f);
        self.contentSize = CGSizeMake(rect.size.width,
                                      rect.size.height);
        
        self.position = ccp(rect.origin.x, rect.origin.y);

        [self addBatchNode];
        
        TYPE = type_;
        
        if (type_==kPAUSE_WINDOW_TAG)
        {
            [self addBG_byType:type_];
            [self addHomeButton:kPAUSE_WINDOW_TAG];
            [self addRestartButton_type:kPAUSE_WINDOW_TAG];
            [self addContinueButton:kPAUSE_WINDOW_TAG :level_];
            [self addInfoButon];
            
            [admin performSelector:@selector(TIME_Pause)];
        
        }
        
        else if (type_ == kRESTART_WINDOW_TAG){
            
             [self addBG_byType:type_];
            
        }
        
        else if (type_==kLOOSE_WINDOW_TAG){
            
            NSLog(@"LOST LEVEL WINDOW");
            [self addJoeKilled];
            [self addHomeButton:kLOOSE_WINDOW_TAG];
            [self addRestartButton_type:kLOOSE_WINDOW_TAG];
            [self addOuch];
            
             [admin performSelector:@selector(TIME_Pause)];
            
        }
        
        else if (type_==kWIN_WINDOW_TAG){
            
            [self addBG_byType:type_]; // 08-03
            [self moveInAction:self];
            
            [self addHomeButton:kWIN_WINDOW_TAG];
            [self addRestartButton_type:kWIN_WINDOW_TAG];
            
          //   if (level_ <15)
          //  {
                [self addContinueButton:kWIN_WINDOW_TAG :level_];
          //  }
            
            [self addScoreBlock_withTime:milisec_ forLevel:level_ brains:brains_];
            
            // *** free levels
            // *** unlock second free level is passed previous
            
            if (level_ < 5)
            {
                 [Combinations saveNSDEFAULTS_Bool:YES forKey:C_UNLOCK_LEVEL(level_+1)];    //unlock second free level
            }
            
            //unlock level if purchase was done before
            
            else if (level_ >= 5 && [Combinations checkNSDEFAULTS_Bool_ForKey:C_PURCHASE_DONE])
            {
                [Combinations saveNSDEFAULTS_Bool:YES forKey:C_UNLOCK_LEVEL(level_+1)];
            }
            
            // *** premium levels
            
        }
            
    }
    return self;
}

-(void)addScoreBlock_withTime:(float)time_ forLevel:(int)level_ brains:(int)brains_{
    
    //  CCSprite *home = [CCSprite spriteWithSpriteFrameName:@"btn_gohome.png"];
    
    CCSprite *home = (CCSprite*)[spritesBgNode getChildByTag:b_goHome];
    
    float w = (kWidthScreen)*0.7f;
    
    ScoreBlock *SB = [[[ScoreBlock alloc]initWithRect_:CGRectMake
                       (kWidthScreen*0.5f,
                        home.position.y+home.contentSize.height/2,
                        w,
                        (kHeightScreen)*0.6f) scored:time_ level:level_ brains:brains_]autorelease];
    
    [self addChild:SB];
    SB.delegate = self;
    
}

-(void)addBrainCollected_nrOfBrains:(int)brainsNR{
    
    
    CCSprite *face  =(CCSprite*)[spritesBgNode getChildByTag:kJoeFace];
    
//    NSArray *points = [NSArray arrayWithObjects:
//                       [NSValue valueWithCGPoint:CGPointMake(280.f*(kSCALEVALX),           640*(kSCALEVALY))],          //birdhead
//                       [NSValue valueWithCGPoint:CGPointMake(220.f*(kSCALEVALX),           179.5f*(kSCALEVALY))],       //brains
//                       [NSValue valueWithCGPoint:CGPointMake(700.f*(kSCALEVALX)-(65),             457*(kSCALEVALY))],
//    
    
    for (int x = 1;  x <= 3 ; x++) {
        
        CCSprite *brain = [CCSprite spriteWithSpriteFrameName:@"brains_inactive.png"];
        [spritesBgNode addChild:brain];
        if (x == 1) {
            brain.position = ccp(face.position.x+(face.boundingBox.size.width*0.5f),
                                 face.position.y+(face.boundingBox.size.height*0.3f));
            brain.rotation = 45;
        
        }
        else if (x == 2) {
            brain.position = ccp(face.position.x+(face.boundingBox.size.width*0.65f),
                                 face.position.y+(face.boundingBox.size.height*0.09f));
            brain.rotation = 75;
           
            
        }
        else if (x == 3) {
            brain.position = ccp(face.position.x+(face.boundingBox.size.width*0.65f),
                                 face.position.y-(face.boundingBox.size.height*0.15f));
            brain.rotation = 110;
         
      
        }

        
        
    }


    
    for (int x = 1;  x <= brainsNR ; x++) {
        
        CCSprite *brain = [CCSprite spriteWithSpriteFrameName:@"brains_active.png"];
        [spritesBgNode addChild:brain];
        
        if (x == 1) {
            brain.position = ccp(face.position.x+(face.boundingBox.size.width*0.5f),
                                 face.position.y+(face.boundingBox.size.height*0.3f));
            brain.rotation = 45;
            brain.scale = 0;
            [self UPscaleInAction:brain delay:0.25f];

        }
        else if (x == 2) {
            brain.position = ccp(face.position.x+(face.boundingBox.size.width*0.65f),
                                 face.position.y+(face.boundingBox.size.height*0.09f));
            brain.rotation = 75;
              brain.scale = 0;
            [self UPscaleInAction:brain delay:0.5f];
            
        }
       else if (x == 3) {
           brain.position = ccp(face.position.x+(face.boundingBox.size.width*0.65f),
                                face.position.y-(face.boundingBox.size.height*0.15f));
           brain.rotation = 110;
             brain.scale = 0;
            [self UPscaleInAction:brain delay:0.75f];
           
        }
        
    }
    
}

-(void)addJoeWon{
    
    CCSprite *lostJoe = [CCSprite spriteWithSpriteFrameName:@"zombie_victory.png"];
    [spritesBgNode addChild:lostJoe z:0 tag:kJoeFace];
    lostJoe.position = ccp(self.contentSize.width*0.5f, self.contentSize.height*0.65f);
    
}

-(void)addZombastic{
    
    CCSprite *lostJoe = [CCSprite spriteWithSpriteFrameName:@"victory_text.png"];
    [spritesBgNode addChild:lostJoe];
    CCSprite *face  =(CCSprite*)[spritesBgNode getChildByTag:kJoeFace];
    
    lostJoe.position = ccp(face.position.x-(face.boundingBox.size.width*0.5f),
                           face.position.y+(face.boundingBox.size.height*0.2f));
    
}


-(void)addJoeKilled{

    CCSprite *lostJoe = [CCSprite spriteWithSpriteFrameName:@"zombie_lost.png"];
    [spritesBgNode addChild:lostJoe z:0 tag:kJoeFace];
    lostJoe.position = ccp(self.contentSize.width*0.5f, self.contentSize.height*0.65f);
    
}

-(void)addOuch{
    
    CCSprite *lostJoe = [CCSprite spriteWithSpriteFrameName:@"text_lost.png"];
    [spritesBgNode addChild:lostJoe];
    CCSprite *face  =(CCSprite*)[spritesBgNode getChildByTag:kJoeFace];
    
    lostJoe.position = ccp(face.position.x-(face.boundingBox.size.width*0.6f),
                           face.position.y+(face.boundingBox.size.height*0.3f));
    
}

-(void)moveInAction:(CCNode*)node_{
    
    id move =   [CCMoveTo actionWithDuration:WIN_MOVEINTIME position:ccp(ScreenSize.width/2,ScreenSize.height/2)];
    id action = [CCEaseElasticInOut actionWithAction:move period:0.8f];
    [node_ runAction: action];
    
}

-(float)randomIntegerBetween:(int)min :(int)max {
    
    return ( (arc4random() % (max-min+1)) + min );
}

-(void)addBublesForCenter:(int)type_{
    int max = 7;
    if (type_ == b_restart) {
        max = 7;
    }
    if (IS_IPAD) {
        max = 10;
    }
        
    float dist = 10;
    
    if (IS_IPAD) {
        dist = 15;
    }
    
    CGPoint firstPos = [self getChildByTag:999].position;
    
    for (int x = 0; x < max; x ++) {
        CCSprite *bubble = [CCSprite spriteWithSpriteFrameName:@"buble.png"];
        
        if (type_==b_restart) {
             bubble.position = ccpAdd(firstPos, ccp(0+([self randomIntegerBetween:1 :dist]), x*dist));
        }
        else if (type_==b_goHome) {
            bubble.position = ccpAdd(firstPos, ccp(-([self randomIntegerBetween:1 :dist]+x*(dist*2)), x*dist));
        }
        else if (type_==b_continue) {
            bubble.position = ccpAdd(firstPos, ccp(([self randomIntegerBetween:1 :dist]+x*(dist*2)), x*dist));
        }
       
        [spritesBgNode addChild:bubble];
        bubble.scale = [self randomIntegerBetween:3.f :10.f]/10;
        bubble.opacity = 0;
        [bubble runAction:[CCFadeTo actionWithDuration:0.1f+(x/10) opacity:255]];
    }
    
}

-(void)addInfoButon{
    
    CCSprite *home = [CCSprite spriteWithSpriteFrameName:@"btn_info.png"];
     //  float offset = home.boundingBox.size.width*1.5f;
    [spritesBgNode addChild:home z:1 tag:b_info];
    home.anchorPoint = ccp(0.5f,0.5f);
    home.position = ccp(kWidthScreen-home.boundingBox.size.width*1.25f,home.boundingBox.size.width*1.25f);//ccp(self.contentSize.width-(offset),self.contentSize.height-(offset));
    home.scale = 0;
    
    [self UPscaleInAction:b_info delay:0.35f type:kPAUSE_WINDOW_TAG];
    
}

-(void)addContinueButton:(int)type_ :(int)level_{
    
    CGPoint pos;
    NSString *img = @"";
    
    if (type_==kPAUSE_WINDOW_TAG){
        img = @"btn_resume.png";
        pos = ccp(self.contentSize.width*0.75f,self.contentSize.height*p_pauseButtonH);
    }
    else if (type_==kWIN_WINDOW_TAG){
        img = @"btn_nextLevel.png";
        pos = ccp(self.contentSize.width*0.75f,self.contentSize.height*0.05f);
    }
    
    CCSprite *home = [CCSprite spriteWithSpriteFrameName:img];//@"btn_continue.png"];
    [spritesBgNode addChild:home z:1 tag:b_continue];
    home.anchorPoint = ccp(0.5f,0.5f);
    home.position = pos;
    home.scale = 0;
    
    if (level_==15 && type_==kWIN_WINDOW_TAG)
    {
        home.opacity = 100;
    }

   [self UPscaleInAction:b_continue delay:0.30f    type:type_];
    
}

-(void)addRestartButton_type:(int)type_{
    
    CCSprite *home = [CCSprite spriteWithSpriteFrameName:@"btn_playagain.png"];
    [spritesBgNode addChild:home z:1 tag:b_restart];
    home.anchorPoint = ccp(0.5f,0.5f);

    
    if (type_==kPAUSE_WINDOW_TAG) {
          home.position = ccp(self.contentSize.width*0.5f,self.contentSize.height*p_pauseButtonH);
            
    }
    else if (type_==kLOOSE_WINDOW_TAG){
        
        float offset = (IS_IPAD) ? 15 : 6;
        
        home.position = ccp(self.contentSize.width*0.5f+(home.boundingBox.size.width/2)+(offset),self.contentSize.height*0.05f);
    }
    else if (type_==kWIN_WINDOW_TAG) {
        home.position = ccp(self.contentSize.width*0.5f,self.contentSize.height*0.05f);
    }
    home.scale = 0;

         [self UPscaleInAction:b_restart delay:0.30f    type:type_];

    
}

-(void)addHomeButton:(int)type_{
    
    CCSprite *home = [CCSprite spriteWithSpriteFrameName:@"btn_gohome.png"];
    [spritesBgNode addChild:home z:1 tag:b_goHome];
    home.anchorPoint = ccp(0.5f,0.5f);
    if (type_==kPAUSE_WINDOW_TAG) {
        home.position = ccp(self.contentSize.width*0.25f,self.contentSize.height*p_pauseButtonH);
    }
    else if (type_==kLOOSE_WINDOW_TAG){
        float offset = (IS_IPAD) ? 15 : 6;
        home.position = ccp(self.contentSize.width*0.5f-(home.boundingBox.size.width/2)-(offset),self.contentSize.height*0.05f);
    }
   else if (type_==kWIN_WINDOW_TAG) {
        home.position = ccp(self.contentSize.width*0.25f,self.contentSize.height*0.05f);
    }

    home.scale = 0;
    
    [self UPscaleInAction:b_goHome delay:0.25f type:type_];
    
}

-(void)UPscaleInAction:(CCNode*)node_ delay:(float)delay_{
    
    id delay = [CCDelayTime actionWithDuration:delay_];
    id scale = [CCScaleTo actionWithDuration:0.2 scale:1.f];
    id action = [CCEaseElasticInOut actionWithAction:scale period:1.f];
    id seq = [CCSequence actions:action, nil];
    
    [node_ runAction: [CCSequence actions:delay,seq, nil]];
    
}

-(void)UPscaleInAction:(int)tag delay:(float)delay_ type:(int)type_{
    
    id delay = [CCDelayTime actionWithDuration:delay_];
    id scale = [CCScaleTo actionWithDuration:0.2 scale:1.f];
    id action = [CCEaseElasticInOut actionWithAction:scale period:1.f];
    id addbuble =  [CCCallBlock actionWithBlock:^(void)
                    {
                       //  [self addBublesForCenter:tag];   //enable bubles
                    }];
    id seq;

    if (type_==kPAUSE_WINDOW_TAG) {
        seq = [CCSequence actions:action,addbuble, nil];
       //  [[spritesBgNode getChildByTag:tag] runAction: [CCSequence actions:delay,seq, nil]];
    }
    else seq = [CCSequence actions:action, nil];
    
    [[spritesBgNode getChildByTag:tag] runAction: [CCSequence actions:delay,seq, nil]];
   
    
}

-(void)addBatchNode{
    
    NSString *spritesStr =      [NSString stringWithFormat:@"PauseMenus_iPhone"];
    if (IS_IPAD) spritesStr =   [NSString stringWithFormat:@"PauseMenus"];
    
    spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz",spritesStr]];
    [self addChild:spritesBgNode z:1];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache]
     addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist",spritesStr]];
    
}

-(void)joeIsThinking{
    
    float w = (IS_IPAD) ? 400 :   400*0.46875f;
    float h = (IS_IPAD) ? 60 :    60*0.46875f;
    float size = (IS_IPAD) ? 40 : 40*0.46875f;
    
    CCLabelTTF *label = [[CCLabelTTF alloc] initWithString:@"Joe is thinking..." dimensions:CGSizeMake(w,h)
                                     alignment:UITextAlignmentCenter fontName:@"StartlingFont" fontSize:size];
    //LABEL POSITION HERE
    label.position = ccp(self.contentSize.width/2, self.contentSize.height-(label.boundingBox.size.height*0.75f));
    label.color = ccc3(238,194,0);
    [self addChild:label];
    
}

-(void)addJoe{
    
    float offsetFromBottom = (IS_IPAD) ? 10 : 5;
    
    JOE_C *JOE = [[[JOE_C alloc]initWithRect:CGRectMake(0, 0, 100, 100) tag:999]autorelease];
    [self addChild:JOE z:10];
    JOE.tag = 999;
    JOE.scale = 1.f;
    JOE.position = ccp(self.contentSize.width/2, JOE.boundingBox.size.height/2 + offsetFromBottom);
    [JOE Action_IDLE_Setdelay:0.2f funForever:YES];
    
}

-(void)addBGOTOFADEBLACK{
    
    CCSprite *blackBoard = [[[CCSprite alloc]init]autorelease];
    //   if (kPAUSE_WINDOW_TAG) {
    [blackBoard setTextureRect:CGRectMake(0, 0, kWidthScreen,
                                          kHeightScreen)];

    
    [self addChild:blackBoard z:100 tag:5];
    blackBoard.anchorPoint = ccp(0.5f, 0.5f);
    blackBoard.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
    
    
    blackBoard.color = ccBLACK;

        blackBoard.opacity = 0;
        [blackBoard runAction:[CCFadeTo actionWithDuration:0.25f opacity:255]];
    
}

-(void)addBG_byType:(int)type_{
    
    CCSprite *blackBoard = [[[CCSprite alloc]init]autorelease];
 //   if (kPAUSE_WINDOW_TAG) {
        [blackBoard setTextureRect:CGRectMake(0, 0, kWidthScreen*4,
                                                    kHeightScreen)];
//       
//    }
//    else {
//        [blackBoard setTextureRect:CGRectMake(0, 0, self.contentSize.width,
//                                              self.contentSize.height)];
//    }

    [self addChild:blackBoard z:0 tag:5];
    blackBoard.anchorPoint = ccp(0.5f, 0.5f);
    blackBoard.position = ccp(self.contentSize.width/2,self.contentSize.height/2);

  
    blackBoard.color = ccBLACK;
    
    if (type_==kRESTART_WINDOW_TAG)
    {
        blackBoard.opacity = 0;
        [blackBoard runAction:[CCFadeTo actionWithDuration:0.25f opacity:255]];
    }
    
    else     blackBoard.opacity = 210;
    
}

-(void)pressedHome{
    /*
    id a = [CCCallFunc actionWithTarget:self.admin selector:@selector(fadeINTOBLACKSCREEN)];
    id a2 = [CCCallFunc actionWithTarget:self.admin selector:@selector(SetBlackBoard_Z_InFront)];
    id b = [CCCallFunc actionWithTarget:self selector:@selector(goToHomeScene)];
    //][self.admin performSelector:@selector(fadeINTOBLACKSCREEN)];
    id seq = [CCSequence actions:a2,a,[CCDelayTime actionWithDuration:0.25f],b, nil];
    [self runAction:seq];
     */
    [self goToHomeScene];
  
}

-(void)goToHomeScene{
    
     // [SceneManager goMainMenu];
    [self addBGOTOFADEBLACK];
    
    [self.parent performSelector:@selector(pressedHome)];
    
}

-(void)restartScene{
    
    [SceneManager goGameScene:[delegate getLevelNr]showTutorial:NO restart:YES];
    
}

-(void)pressedRestart{
    
 //   [self addBGOTOFADEBLACK];
    id a = [CCCallFunc actionWithTarget:self selector:@selector(addBGOTOFADEBLACK)];
    id b = [CCCallFunc actionWithTarget:self selector:@selector(restartScene)];
    //][self.admin performSelector:@selector(fadeINTOBLACKSCREEN)];
    id seq = [CCSequence actions:a,[CCDelayTime actionWithDuration:0.3f],b, nil];
    [self runAction:seq];
    
    /*
  //  NSLog(@"restart. level %i",[delegate getLevelNr]);
    id a = [CCCallFunc actionWithTarget:self.admin selector:@selector(fadeINTOBLACKSCREEN)];
    id a2 = [CCCallFunc actionWithTarget:self.admin selector:@selector(SetBlackBoard_Z_InFront)];
    id b = [CCCallFunc actionWithTarget:self selector:@selector(restartScene)];
    //][self.admin performSelector:@selector(fadeINTOBLACKSCREEN)];
    id seq = [CCSequence actions:a2,a,[CCDelayTime actionWithDuration:0.25f],b, nil];
    [self runAction:seq];
    */
   
    
    //[SceneManager restartLevel:[delegate getNode]];
    
}


-(void)removePauseMenu:(int)type_{
   
    if (type_ == type_continue_afterLevelBegin)
    {
       // [self.admin performSelector:@selector(fadeOUTBLACKSCREEN) withObject:nil afterDelay:0.f];
    //    [self.admin performSelector:@selector(LEVEL_RESUME) withObject:nil afterDelay:0.35f];
    //    [cfg runSelectorTarget:self.admin selector:@selector(LEVEL_RESUME) object:nil afterDelay:0.1 sender:self];
        // [self.admin performSelector:@selector(TIME_Resume) withObject:nil afterDelay:0.35f];
        [self.admin performSelector:@selector(LEVEL_RESUME)];
        
        /*
        id move =   [CCMoveTo actionWithDuration:0.35f position:ccp(ScreenSize.width+(ScreenSize.width/2),ScreenSize.height/2)];
        id action = [CCEaseElasticInOut actionWithAction:move period:1.f];
        */
        
        id remove =  [CCCallBlock actionWithBlock:^(void){[self removeFromParentAndCleanup:NO];}];
        
        
        [self runAction:[CCSequence actions:remove, nil]];
    }

    if (type_ == type_continue_afterInfo)
    {
     //   [self.admin performSelector:@selector(fadeOUTBLACKSCREENINSTANT) withObject:nil afterDelay:0.f];

        id remove =  [CCCallBlock actionWithBlock:^(void){[self removeFromParentAndCleanup:NO];}];
        
        [self runAction:[CCSequence actions:remove, nil]];

    }
    
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

-(void)clickEffectForButton:(int)tag{
    
    id scaleDown = [CCScaleTo actionWithDuration:0.1f scale:0.8f];
    id rescale = [CCScaleTo actionWithDuration:0.1f scale:1.f];
    id seq = [CCSequence actions:scaleDown,rescale, nil];
    [[spritesBgNode getChildByTag:tag] runAction:seq];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
//    NSLog(@"touched on pause");
    
//    NSSet *allTouches = [event allTouches];
//    for (UITouch *aTouch in allTouches) {
//        
//        if ( ![self containsTouchLocation:aTouch] ) return NO;
//    }
    
    if (BLOCKTOUCH)
    {
        return NO;
    }
    
    CGPoint location = [self convertTouchToNodeSpace:touch];
    if (CGRectContainsPoint([[spritesBgNode getChildByTag:b_goHome]boundingBox], location)) {
        [self clickEffectForButton:b_goHome];
        //NSLog(@"pressed home");
       // [self pressedHome];
        [cfg runSelectorTarget:self selector:@selector(pressedHome) object:nil afterDelay:0.2f sender:self];
    //    [self performSelector:@selector(pressedHome) withObject:nil afterDelay:0.2f];
        BLOCKTOUCH   = YES;
         [AUDIO playEffect:fx_buttonclick];
    }
    else if (CGRectContainsPoint([[spritesBgNode getChildByTag:b_restart]boundingBox], location)) {
        //NSLog(@"pressed home");
        [self clickEffectForButton:b_restart];
          [cfg runSelectorTarget:self selector:@selector(pressedRestart) object:nil afterDelay:0.2f sender:self];
      //   [self performSelector:@selector(pressedRestart) withObject:nil afterDelay:0.2f];
        BLOCKTOUCH   = YES;
         [AUDIO playEffect:fx_buttonclick];
        //[self pressedRestart];
    }
    else if (CGRectContainsPoint([[spritesBgNode getChildByTag:b_continue]boundingBox], location)) {
        //NSLog(@"pressed home");
        if ([delegate getLevelNr] == 15 && TYPE == kWIN_WINDOW_TAG)
        {
            return NO;
        }
         [self clickEffectForButton:b_continue];
   //     [self performSelector:@selector(pressedContinue) withObject:nil afterDelay:0.2f];
        [cfg runSelectorTarget:self selector:@selector(pressedContinue) object:nil afterDelay:0.2f sender:self];
        BLOCKTOUCH   = YES;
         [AUDIO playEffect:fx_buttonclick];
        //[self pressedContinue];
    }
    else if (CGRectContainsPoint([[spritesBgNode getChildByTag:b_info]boundingBox], location)) {
        //NSLog(@"pressed home");
        [self clickEffectForButton:b_info];
        [self showInfo];
         [AUDIO playEffect:fx_buttonclick];
    }
    //
    
    return YES;
}

-(void)showInfo{
    
    //[self.admin performSelector:@selector(showTutorial)];
    
    [delegate showTutorial:TUTORIAL_TYPE_PAUSED];
    
    [self removePauseMenu:type_continue_afterInfo];
    
}

-(void)playNextLevel{
    
    [SceneManager goGameScene:[delegate getLevelNr]+1 showTutorial:YES restart:NO];
    
}

-(void)pressedContinue{
    
    if (TYPE==kWIN_WINDOW_TAG)
    {
         BLOCKTOUCH = NO;
        
        BOOL nextLevelState = [Combinations checkNSDEFAULTS_Bool_ForKey:C_UNLOCK_LEVEL([delegate getLevelNr]+1)];
      //  NSLog(@"next level state %i",nextLevelState);

        
        // *** next level is unlocked
        if (nextLevelState)
        {
            //[SceneManager goGameScene:[delegate getLevelNr]+1 showTutorial:YES restart:NO];
            id a = [CCCallFunc actionWithTarget:self selector:@selector(addBGOTOFADEBLACK)];
            id b = [CCCallFunc actionWithTarget:self selector:@selector(playNextLevel)];
            //][self.admin performSelector:@selector(fadeINTOBLACKSCREEN)];
            id seq = [CCSequence actions:a,[CCDelayTime actionWithDuration:0.3f],b, nil];
            [self runAction:seq];
        }
        else
            
        {
            B6luxPopUpManager *popUpM = [[[B6luxPopUpManager alloc]init]autorelease];
            
            [self addChild:popUpM z:9999];
            [popUpM addPopUpWithType:levelUnlock level:[delegate getLevelNr]+1];
        }
        
    }
    
    else
    {
    [self removePauseMenu:type_continue_afterLevelBegin];
    }
}

-(void)onEnter //---cia leidzia naudoti touch komandas. onEnter nereikia niekur kviest, jisai pats pirmas pasileidzia pagal prioriteta netgi jo neisrasiu i init
{
    
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:touch_PAUSEMENU swallowsTouches:YES];
    
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
  //  NSLog(@"DEALLOC PAUSE MENU %@",self);
    
    [delegate release];
	delegate = nil;
     [admin release];
    admin = nil;
	[super dealloc];
}




@end
