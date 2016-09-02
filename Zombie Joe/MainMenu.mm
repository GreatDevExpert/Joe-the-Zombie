
// Import the interfaces
#import "MainMenu.h"
#import "cfg.h"
#import "Constants.h"
#import "SceneManager.h"
//#import "JOE_C.h"
#import "ClippingNode.h"
#import "JoeZombieController.h"
#import "BrainsBonus.h"

#import "B6luxYouTube.h"
#import "B6luxPopUpManager.h"
#import "b6luxLoadingView.h"
#import "B6luxRatePopup.h"

//#import "SimpleAudioEngine.h"

//#import "SBJson.h"
//
//#import "ASIFormDataRequest.h"
//#import "ASIHTTPRequest.h"

#define TAG_SOUNDFX 1
#define TAG_MUSIC   2
#define TAG_GC      3
#define TAG_INFO    4
#define TAG_MOVIE   5

@implementation MainMenu
{
      JoeZombieController *JoeRobot;
}

//@synthesize MZSCrollW;
//@synthesize TutorialBoard;
//@synthesize tutorialImage;

#define PTM_RATIO [LevelHelperLoader pointsToMeterRatio]

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	MainMenu *layer = [MainMenu node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
        
        [self addBG_forNode:self withCCZ:@"MainMenu" bg:@"MainMenu.jpg"];

        
        [self addScrollerView];             //  LEAK
        [self addAllItemsBatchNode];
        [self addTutorialBoard_];
        [self tutorialBoardHIDE:YES];
        [self allocTutorialImage];
        
        [self addJoeRobot];
        
        [self addSoundSettings];
        
        [self addTotalScoreLine];
        
        [self addSpider];
        
        [self addStarBlinking];
        
        [self checkRate];
        
        canTouch = YES;
        
        [cfg runSelectorTarget:self
                      selector:@selector(checkForIntroOnFirstRun)
                        object:nil afterDelay:0.5f
                        sender:self];
         
        // [self SERVER_CALL];
        
	}
	return self;
}

-(void)checkPlayerInfo{
    
    if (![Combinations checkNSDEFAULTS_Bool_ForKey:C_INFOUSER])
    {
        [db SS_sendUserInfo:[gc_ getLocalPlayerAlias]];
    }
    
}

-(CGPoint)getRandomStarPos{
    
    int random = [cfg MyRandomIntegerBetween:1 :3];
    CGPoint pos ;
    
    if (random == 1)
    {
     pos =    (IS_IPHONE) ?
        ccp(kWidthScreen*0.25f, kHeightScreen*0.8f):
        ccp(kWidthScreen*0.25f, kHeightScreen*0.8f);
    }
    else if (random == 2)
    {
        pos =    (IS_IPHONE) ?
        ccp(kWidthScreen*0.15f, kHeightScreen*0.8f):
        ccp(kWidthScreen*0.15f, kHeightScreen*0.8f);
    }
    else if (random == 3)
    {
        pos =    (IS_IPHONE) ?
        ccp(kWidthScreen*0.20f, kHeightScreen*0.75f):
        ccp(kWidthScreen*0.20f, kHeightScreen*0.75f);
    }
    
    return pos;

}

-(void)addStarBlinking{
    
    CCSprite *star = [CCSprite spriteWithFile:@"star.png"];
    [self addChild:star z:1];
    star.scale = (kSCALE_FACTOR_FIX)*(kSCALEVALX);
//    star.position =  (IS_IPHONE) ? ccp(kWidthScreen*0.25f, kHeightScreen*0.8f)   :
//                                   ccp(kWidthScreen*0.25f, kHeightScreen*0.8f);
    
    id fadeTo = [CCFadeTo actionWithDuration:0.3f opacity:0];
    id fadeFull =[CCFadeTo actionWithDuration:0.3f opacity:255];
    id rotate =[CCRotateBy actionWithDuration:0.3f angle:10];

    id seq= [CCSequence  actions:[CCMoveTo actionWithDuration:0 position:[self getRandomStarPos]],
             [CCSpawn actions:fadeTo,rotate, nil],
             [CCDelayTime actionWithDuration:5.5f],
             [CCSpawn actions:fadeFull,rotate,
             [CCDelayTime actionWithDuration:0.1f], nil],
             nil];
    
    [star runAction:[CCRepeatForever actionWithAction:seq]];
    
}

-(void)checkRate{
    
    if ([Combinations getNSDEFAULTS_INT_forKey:C_GAME_RATED] >= 4 && [Combinations connectedToInternet])
    {
        B6luxRatePopup *rp = [[B6luxRatePopup alloc]init];
        [rp ratePopUp];
    }
    
}

-(void)checkForIntroOnFirstRun{
    
    if ([Combinations checkNSDEFAULTS_Bool_ForKey:C_FIRST_GAME_RUN])
    {
           [self zombieJumpOut];
    }
   else if (![Combinations checkNSDEFAULTS_Bool_ForKey:C_FIRST_GAME_RUN] &&
        [Combinations connectedToInternet])
    {
        // *** first game run -> show video
      //  [Combinations saveNSDEFAULTS_Bool:YES forKey:C_FIRST_GAME_RUN];
        [self loadIntro];
    }
    
    else if (![Combinations connectedToInternet]){
        [Combinations saveNSDEFAULTS_Bool:YES forKey:C_FIRST_GAME_RUN];
        [self zombieJumpOut];
    }

    
}

-(void)popUpButShare:(NSNumber *)levelNr
{
    for (CCNode *childrr in self.children) {
        if ([childrr isKindOfClass:[B6luxPopUpManager class]]) {
            return ;
        }
    }
    
    B6luxPopUpManager *popUpM = [[[B6luxPopUpManager alloc]init]autorelease];
    
    [self addChild:popUpM z:9999];
    [popUpM addPopUpWithType:levelUnlock level:levelNr.integerValue];
    
}

-(void)addLoadImageWithName:(NSNumber*)levelNR{
    
    int nr  = [levelNR intValue];
    tutorialImage.visible = YES;
    tutorialImage.opacity = 0;

    
    [tutorialImage runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.2f],
                             [CCFadeTo actionWithDuration:0.25f opacity:255], nil]];
    
    
 //   NSLog(@"load scren %i",nr);
    
    [self tutorialBoardHIDE:NO];
    
    [tutorialImage setTexture:[[CCTextureCache sharedTextureCache]
                               addImage:[NSString stringWithFormat:@"level_%i.png",nr]]];
    
     if (IS_IPHONE)
     {
        
        tutorialImage.scale = kSCALE_FACTOR_FIX;
        
     }
    
    float w = (IS_IPAD) ? 400 :   400*0.46875f;
    float h = (IS_IPAD) ? 60 :    60*0.46875f;
    
    float size = (IS_IPAD) ? 40 : 40*0.46875f;
    
    CCLabelTTF *label = [[[CCLabelTTF alloc] initWithString:@"Loading..." dimensions:CGSizeMake(w,h)
                                                 alignment:UITextAlignmentCenter fontName:@"StartlingFont" fontSize:size]autorelease];
    //LABEL POSITION HERE
    label.position = ccp(ScreenSize.width/2, ScreenSize.height*0.2f);
    label.color = COL_YELLOW_DARK;
    [self addChild:label z:11];
    label.opacity = 0;
    [label runAction:[CCFadeTo actionWithDuration:0.3f opacity:255]];
    
    
    [cfg runSelectorTarget:self selector:@selector(PlayLevel:) object:[NSNumber numberWithInt:nr] afterDelay:0.4f sender:self];
    
   // [self performSelector:@selector(PlayLevel:) withObject:[NSNumber numberWithInt:nr] afterDelay:0.35f];
    
  //  [self PlayLevel:[NSNumber numberWithInt:nr]];
    
    //[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"level_%i.jpg",nr]]];
    
}


-(void)PlayLevel:(NSNumber*)levelNR{
    
    [SceneManager goGameScene:[levelNR intValue]showTutorial:YES restart:NO];
    
}

-(void)allocTutorialImage{

    tutorialImage = [CCSprite spriteWithFile:@"level_1.png"];
    [self addChild:tutorialImage z:11];
    
    if (IS_IPAD) {
        tutorialImage.scale = 1.5f;
        if (![Combinations isRetina]) {
            tutorialImage.scale = 1;
        }
    }
    tutorialImage.visible = NO;
   // tutorialImage.opacity = 0;
    tutorialImage.position = ccp(ScreenSize.width/2, ScreenSize.height/2);
    
}

-(void)addTutorialBoard_{
    
    TutorialBoard = [[[CCSprite alloc]init]autorelease];
    
    [TutorialBoard setTextureRect:CGRectMake(0, 0, self.contentSize.width,
                                             self.contentSize.height)];
    TutorialBoard.anchorPoint = ccp(0.5f, 0.5f);
    TutorialBoard.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
    
    [self addChild:TutorialBoard z:10 tag:5];
    TutorialBoard.color = ccBLACK;
    TutorialBoard.opacity = 255;
    
}

-(void)tutorialBoardHIDE:(BOOL)yes_{
    
    if (yes_) {
        [TutorialBoard runAction:[CCFadeTo actionWithDuration:0.3f opacity:0]];
    }
    else [TutorialBoard runAction:[CCFadeTo actionWithDuration:0.3f opacity:255]];
    
    
    /*
    if (yes_) {
        TutorialBoard.visible = NO;
    }
    else TutorialBoard.visible = YES;
    */
    
}

-(void)addBG_forNode:(CCNode*)node_ withCCZ:(NSString*)ccz_ bg:(NSString*)bg_{
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    if (IS_IPHONE) {
        ccz_ = [NSString stringWithFormat:@"%@_iPhone",ccz_];
    }
    
    CCSpriteBatchNode *spritesBgNode;
    
    spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz",ccz_]];
    [node_ addChild:spritesBgNode];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist",ccz_]];
    CCSprite *background = [CCSprite spriteWithSpriteFrameName: bg_];
    background.position = ccp(ScreenSize.width/2,ScreenSize.height/2);
    [spritesBgNode addChild:background z:0];
    
    if (![Combinations isRetina])
    {
        background.scale = 0.5f;
    }
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
}

-(void)addTotalScoreLine{
    
   // float lineyDifference = (kHeightScreen)-(kMenuLevelScrollerWindowH);
    
    CCSprite *line = [CCSprite spriteWithSpriteFrameName:@"menu_pointsbg.png"];
    [spritesItemsBatchNode addChild:line];
    line.anchorPoint = ccp(0.5f, 0.5f);
    
    float lineY = kHeightScreen-(line.boundingBox.size.height*0.8f);
    
    if (IS_IPAD)
    {
       lineY = kHeightScreen-(line.boundingBox.size.height*0.8f);
    }
    
    line.position = ccp((MZSCrollW.position.x*2)+(kMenuLevelScrollerWindowW)-line.boundingBox.size.width/2,
                        lineY);
    line.opacity = 150;
    
    
    // Total score Label
    int score = [db getAllLevelsScore];
    //NSLog(@"score total is %i",score);
    
    float w = (IS_IPAD) ? 80.f :     70*0.46875f;
    float h = (IS_IPAD) ? 42.5f :    42.5f*0.46875f;
    
    float padFixY = (IS_IPAD) ? 4.5f :    0;
    
    CCLabelTTF *label = [[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"TOTAL SCORE: 00000"]
                                                 dimensions:CGSizeMake(w*4,h)
                                                  alignment:UITextAlignmentLeft fontName:@"StartlingFont"
                                                   fontSize:fFONT_MENU_BLACKLINE_LABELS*1.15f]autorelease];
    //LABEL POSITION HERE
    
    label.anchorPoint = ccp(0, 0.5f);
    
    label.position = ccp(line.position.x-(line.boundingBox.size.width*0.45f),line.position.y-(padFixY));
    
    label.color = COL_YELLOW_DARK;
    [self addChild:label z:9];
    [label setString:[NSString stringWithFormat:@"TOTAL SCORE: %i",score]];
    
    //Brain Logo
    
    BrainsBonus *BRAIN = [[[BrainsBonus alloc]initWithRect:CGRectMake(0, 0, 0, 0)]autorelease];
    BRAIN.anchorPoint = ccp(0.f, 0.5f);
    BRAIN.scale = 0.55f;
    BRAIN.position =
    ccpAdd(line.position,ccp(line.boundingBox.size.width*0.20f, 0));
    BRAIN.brain.opacity = 255;
    [self addChild:BRAIN z:9];
    
    //Brain counter
    int brainNr = [Combinations getNSDEFAULTS_INT_forKey:C_BRAINS_COUNT];
    
    
        labelBrain = [[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"00000"]
                                                     dimensions:CGSizeMake(w*3,h)
                                                      alignment:UITextAlignmentLeft fontName:@"StartlingFont"
                                                       fontSize:fFONT_MENU_BLACKLINE_LABELS*1.15f]autorelease];
        //LABEL POSITION HERE
        
        labelBrain.anchorPoint = ccp(0.f, 0.5f);
        
        labelBrain.position = ccp(BRAIN.position.x*1.05f, line.position.y-(padFixY));
        
        labelBrain.color = COL_YELLOW_DARK;;
        [self addChild:labelBrain z:9];
        [labelBrain setString:[NSString stringWithFormat:@"%i",brainNr]];
    
    // GC Button
    
    CCSprite *gc = [CCSprite spriteWithSpriteFrameName:@"menubtn_gamecenter.png"];
    [spritesItemsBatchNode addChild:gc z:9 tag:TAG_GC];
    line.anchorPoint = ccp(0.5f, 0.5f);
    
    gc.position =
    (IS_IPAD) ? ccp(line.position.x-line.boundingBox.size.width/2-(gc.boundingBox.size.width), line.position.y)
    :           ccp(line.position.x-line.boundingBox.size.width/2-(gc.boundingBox.size.width), line.position.y);
    
    //Info
    
    CCSprite *info = [CCSprite spriteWithSpriteFrameName:@"menubtn_info.png"];
    [spritesItemsBatchNode addChild:info z:9 tag:TAG_INFO];
    info.anchorPoint = ccp(0.5f, 0.5f);
    (IS_IPAD) ?    info.position = ccpAdd(gc.position, ccp(-gc.boundingBox.size.width*1.25f, 0))
    :              info.position = ccpAdd(gc.position, ccp(-gc.boundingBox.size.width*1.75f, 0));
 
    
    //Video
    
    CCSprite *video = [CCSprite spriteWithSpriteFrameName:@"menubtn_video.png"];
    [spritesItemsBatchNode addChild:video z:9 tag:TAG_MOVIE];
    video.anchorPoint = ccp(0.5f, 0.5f);
    (IS_IPAD) ? video.position = ccpAdd(info.position, ccp(-info.boundingBox.size.width*1.25f, 0))
    :           video.position = ccpAdd(info.position, ccp(-info.boundingBox.size.width*1.75f, 0));
 //   video.position = ccpAdd(info.position, ccp(-info.boundingBox.size.width*1.25f, 0));
    
}

-(void)addSoundSettings{
    
    NSString *strFx = @"";
    NSString *strMus = @"";
    
        BOOL f = [Combinations checkNSDEFAULTS_Bool_ForKey:C_FX_ON];
    
        if (f) {
            [AUDIO setEffectsVolume:1];
            strFx = @"menubtn_soundon.png";
        }
        else if (!f){
             [AUDIO setEffectsVolume:0];
            strFx = @"menubtn_soundoff.png";
        }
    
    BOOL m = [Combinations checkNSDEFAULTS_Bool_ForKey:C_MUSIC_ON];
    if (m) {
        [AUDIO setBackgroundMusicVolume:1];
        strMus = @"menubtn_musicon.png";
    }
    else if (!m){
        [AUDIO setBackgroundMusicVolume:0];
        strMus = @"menubtn_musicoff.png";
    }


    
    
    CCSprite *fx = [CCSprite spriteWithSpriteFrameName:strFx];
    [spritesItemsBatchNode addChild:fx z:1 tag:TAG_SOUNDFX];
    
    float x_ =   kWidthScreen*0.075f;
    
    if (IS_IPHONE_5)
    {
        x_ = kWidthScreen*0.13f;
    }
    
    fx.position = ccp(x_+(fx.boundingBox.size.width/2), kWidthScreen*0.04f);
    

    
    CCSprite *music = [CCSprite spriteWithSpriteFrameName:strMus];
    [spritesItemsBatchNode addChild:music z:1 tag:TAG_MUSIC];
    music.position = ccp(x_+(music.boundingBox.size.width*1.5f)+(fx.boundingBox.size.width/2), kWidthScreen*0.04f);
    
}

/*
-(void)SERVER_CALL{
        //http://b6lux.com/api/server_v1.0.php
        NSString *link = @"http://api.b6lux.com/server_v1.0.php";   //@"http://api.vm-c.lt/imagequiz";
    
//    
//    BOOL typePOST = YES;
//    
//    if (!typePOST) {
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?",link]];
//        NSLog(@"url %@",url);
//        
//        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//        [request startSynchronous];
//        
//        NSString *response = [request responseString];
//        NSLog(@"response %@",response);
//        
//        NSError *error = [request error];
//        if (error)
//        {
//            NSLog(@"error : %@",error);
//        }
//        
//    }
//        
//    else{
    
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",link]];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod:@"POST"];
        
    //    [request setUsername:kAPIUsername]; //cia reikia ideti analogiskai
    //    [request setPassword:kAPIPassword]; //email ir password is textfieldu
        
        [request setPostValue:@"333" forKey:@"func"];
     //   [request setPostValue:password_ forKey:@"password"];
        
        [request startSynchronous];
        
        NSError *error = [request error];
        NSString *response = [request responseString];
       NSLog(@"response string %@",response);
        
        if (error) {
            NSDictionary *tempDic= [response JSONValue];
            NSString *errorStr = [tempDic objectForKey:@"message"];
            NSLog(@"error message: %@",errorStr);
        }

 //   }

}
 */

-(void)addAllItemsBatchNode{
    
    NSString *spritesStr =      [NSString stringWithFormat:@"MenuItems_iPhone"];
    if (IS_IPAD) spritesStr =   [NSString stringWithFormat:@"MenuItems"];
    
   spritesItemsBatchNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz",spritesStr]];
    [self addChild:spritesItemsBatchNode z:3];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache]
     addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist",spritesStr]];
    
}

-(void)buttonTapped:(id)sender
{
	NSLog(@"buttonTapped");
}

-(void)addScrollerView{
    
    ClippingNode *nodd = [ClippingNode node];
    [nodd setClippingRegion:CGRectMake(kMenuLevelScrollerWindowX,
                                       0,
                                       kMenuLevelScrollerWindowW,       //kMenuLevelScrollerWindowW //kMenuLevelScrollerWindowH
                                       kMenuLevelScrollerWindowH)];
    
   // nodd.position = ccp(0, 0);
    [self addChild:nodd];
    
    //NSLog(@"nodd position :%f %f",nodd.position.x,nodd.position.y);
    
    MZSCrollW = [[[MenuLevelScroller alloc]initWithRect:CGRectMake(0,
                                                                   0,
                                                                   kMenuLevelScrollerWindowW,
                                                                   kMenuLevelScrollerWindowH)]autorelease];
    MZSCrollW.position = ccp(kMenuLevelScrollerWindowX, 0);
    MZSCrollW.admin = self;
    [nodd addChild:MZSCrollW];
    
}

-(void)purchaseWasDoneNow{
    
    [MZSCrollW purchaseWasDone_RefreshButtons];
    
}

//-(void)addZOMBIEC_CharacterView{
//    
//    MZBody = [[[MenuZombieBody alloc]initWitPos:
//               ccp(0, 0) size:CGSizeMake(kMenuZombieWindowW, kMenuZombieWindowH)]autorelease];
//
//    [self addChild:MZBody];
//
//}

-(void)addSpider{
    
    sprider = [CCSprite spriteWithFile:@"spider.png"];
    [self addChild:sprider];
    sprider.anchorPoint = ccp(0.5f, 1);
    CGPoint  pos = ccp(kWidthScreen*0.15f, kHeightScreen*0.855f);
    if (IS_IPHONE_5)
    {
       pos =  ccp(kWidthScreen*0.21f, kHeightScreen*0.83f);
    }
    sprider.position = pos;
    sprider.scale = (kSCALE_FACTOR_FIX) * (kSCALEVALX);
    sprider.rotation = -25;
    
    
    [sprider runAction:[CCRepeatForever actionWithAction:
                       [CCSequence actions:
                       [CCEaseInOut actionWithAction:
                       [CCRotateBy actionWithDuration:1.f angle:50] rate:2],
                       [CCEaseInOut actionWithAction:
                       [CCRotateBy actionWithDuration:1.f angle:-50] rate:2.f],nil]]];
    //rate:2],
                   //    [CCEaseInOut actionWithAction:
                     //  [CCRotateBy actionWithDuration:0.5f angle:-25] rate:2], nil]]];
    
    /*
    id rotate = [CCRotateTo actionWithDuration:2.f angle:-25];
    id e1 =[CCEaseOut actionWithAction:rotate rate:2.f];//[CCEaseRateAction actionWithAction:rotate];
    id rotateBack = [CCRotateTo actionWithDuration:2.f angle:25];
    id e2 =[CCEaseIn actionWithAction:rotateBack rate:2.f];//[CCEaseRateAction actionWithAction:rotateBack];
    id seq = [CCSequence actions:e1,e2, nil];
    [sprider runAction:[CCRepeatForever actionWithAction:seq]];
    */
    
    //[self getChildByTag:TAG_BRAIN_1].position = sprider.position;
    [self getChildByTag:TAG_BRAIN_1].visible = NO;
    
}

-(void)addJoeRobot{
    
    zombiePos = ccp(self.contentSize.width*0.165f, self.contentSize.height*0.25f);
    
    if (IS_IPHONE)
    {
        if (IS_IPHONE_5)
        {
            zombiePos = ccp(self.contentSize.width*0.21f, self.contentSize.height*0.2775f);
        }
        else
            zombiePos = ccp(self.contentSize.width*0.15f, self.contentSize.height*0.275f);
    }
    
    JoeRobot = [[[JoeZombieController alloc]initWitPos:ccpAdd(zombiePos, ccp(-zombiePos.x*1.75f,0)) size:CGSizeMake(20, 20) sender:self brains:1]autorelease];
    JoeRobot.scale = 0.85f;
    [self addChild:JoeRobot];
    
    
   // [JoeRobot initBlastOnly_Parent:self brainsNumber:1];
    
    [JoeRobot ACTION_SetContentSize:CGSizeMake([[JoeRobot robot_]getChildByTag:0].boundingBox.size.width,
                                               [[JoeRobot robot_]getChildByTag:0].boundingBox.size.width)];
    
    //  [JoeRobot showMyBox];
    
//    if (![Combinations checkNSDEFAULTS_Bool_ForKey:C_FIRST_GAME_RUN]) {
//            [self zombieJumpOut];
//    }
    
}

-(void)zombieJumpOut{
    
    id jumpTo = [CCJumpTo actionWithDuration:0.5f position:zombiePos height:zombiePos.x*1.5f jumps:1];
    id jumpBlock = [CCCallBlock actionWithBlock:^(void){
        
        [AUDIO playEffect:joe_s_jump];
        [[JoeRobot robot_]JOE_JUMP_MENU:1];
        
    }];
    id idle = [CCCallBlock actionWithBlock:^(void){
        
        [[JoeRobot robot_]ACTION_StopAllPartsAnimations_Clean:YES];
        [[JoeRobot robot_]JOE_IDLE_MENU];
        canTouchJoe = YES;
        
    }];
    
    id spawnjumpblock = [CCSpawn actions:jumpTo,jumpBlock,nil];
    
    id seq = [CCSequence actions:[CCDelayTime actionWithDuration:1],spawnjumpblock,idle,nil];
    [JoeRobot runAction:seq];
    
}



-(void)spriderCollisionScheduler:(ccTime)dt{
    
    if (CGRectIntersectsRect(JoeRobot.boundingBox, sprider.boundingBox))
    {
        brainGot = YES;
        [self unschedule:@selector(spriderCollisionScheduler:)];
        [self getChildByTag:TAG_BRAIN_1].position = ccpAdd(sprider.position, ccp(0, -sprider.boundingBox.size.height*0.8f));
        [self getChildByTag:TAG_BRAIN_1].visible = YES;
        [AUDIO playEffect:fx_brainGet];
        [cfg makeBrainActionForNode: [self getChildByTag:TAG_BRAIN_1] fakeBrainsNode:nil direction:0 pixelsToMove:0.1f time:0.25f parent:self removeBrainsAfter:YES makeActionAfterall:nil target:nil];
        
        //update brainNumber db
        [db incraseBrainCounter];
        
        int brainNr = [Combinations getNSDEFAULTS_INT_forKey:C_BRAINS_COUNT];
        [labelBrain setString:[NSString stringWithFormat:@"%i",brainNr]];
        
        [db SS_foundHiddenBrainInMenu_player:[gc_ getLocalPlayerAlias]];
        
        //update brain number label
    }
    
}

-(void)RobotJoeJumpOnPlace{
    
  
    
    if ([JoeRobot getActionByTag:313190]) {
        return;
    }
    

    
    touchedOnZombieCount++;
    BOOL slowMotion = NO;
    if (touchedOnZombieCount >= 3) {
        slowMotion = YES;
        touchedOnZombieCount = 0;
        
        if (!brainGot) {
            [self schedule:@selector(spriderCollisionScheduler:) interval:0.1f];
        }
        
    }
    
    float jumpWidth = (slowMotion) ? JoeRobot.contentSize.height*1.35f : JoeRobot.contentSize.height*0.85f;
    
    id jumpTo = [CCJumpTo actionWithDuration:((slowMotion) ? 1.25f : 0.5f)
                                    position:ccpAdd(JoeRobot.position, ccp(0,0))
                                      height:(IS_IPAD) ? jumpWidth : jumpWidth*0.7f jumps:1];
    
    id jumpBlock = [CCCallBlock actionWithBlock:^(void){
        
        [AUDIO playEffect:joe_s_jump];
        [[JoeRobot robot_]JOE_JUMP_MENU:(slowMotion) ? 2.5f : 1.f];
        
    }];
    id idle = [CCCallBlock actionWithBlock:^(void){
        
       // [[JoeRobot robot_]ACTION_StopAllPartsAnimations_Clean:YES];
        [[JoeRobot robot_]JOE_IDLE_MENU];
        [self unschedule:@selector(spriderCollisionScheduler:)];
        
    }];
    
    id spawnjumpblock = [CCSpawn actions:jumpTo,jumpBlock,nil];
    
    id seq = [CCSequence actions:spawnjumpblock,idle,nil];
    [JoeRobot runAction:seq].tag = 313190;
    
    /*
    if (JoeRobot.position.x >= zombiePos.x+(jumpWidth*2)) {
        NSLog(@"must fall");
        id rotate = [CCRotateTo actionWithDuration:1.f angle:180];
        id moveBy = [CCMoveBy actionWithDuration:1.f
                                        position:ccp(JoeRobot.position.x+jumpWidth, -(JoeRobot.contentSize.height*3))];
        id e = [CCEaseElasticInOut actionWithAction:moveBy period:2.f];
        id spawnFall = [CCSpawn actions:rotate,e, nil];
        [JoeRobot runAction:spawnFall];
                                                                    
    }
     */
    
     slowMotion = NO;

}

// *****

-(UIImage*)snapshot:(UIView*)eaglview
{
	GLint backingWidth, backingHeight;
    
	// Bind the color renderbuffer used to render the OpenGL ES view
	// If your application only creates a single color renderbuffer which is already bound at this point,
	// this call is redundant, but it is needed if you're dealing with multiple renderbuffers.
	// Note, replace "_colorRenderbuffer" with the actual name of the renderbuffer object defined in your class.
    // In Cocos2D the render-buffer is already binded (and it's a private property...).
    //	glBindRenderbufferOES(GL_RENDERBUFFER_OES, _colorRenderbuffer);
    
	// Get the size of the backing CAEAGLLayer
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
	NSInteger x = 0, y = 0, width = backingWidth, height = backingHeight;
	NSInteger dataLength = width * height * 4;
	GLubyte *data = (GLubyte*)malloc(dataLength * sizeof(GLubyte));
    
	// Read pixel data from the framebuffer
	glPixelStorei(GL_PACK_ALIGNMENT, 4);
	glReadPixels(x, y, width, height, GL_RGBA, GL_UNSIGNED_BYTE, data);
    
	// Create a CGImage with the pixel data
	// If your OpenGL ES content is opaque, use kCGImageAlphaNoneSkipLast to ignore the alpha channel
	// otherwise, use kCGImageAlphaPremultipliedLast
	CGDataProviderRef ref = CGDataProviderCreateWithData(NULL, data, dataLength, NULL);
	CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
	CGImageRef iref = CGImageCreate (
                                     width,
                                     height,
                                     8,
                                     32,
                                     width * 4,
                                     colorspace,
                                     // Fix from Apple implementation
                                     // (was: kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast).
                                     kCGBitmapByteOrderDefault,
                                     ref,
                                     NULL,
                                     true,
                                     kCGRenderingIntentDefault
                                     );
    
	// OpenGL ES measures data in PIXELS
	// Create a graphics context with the target size measured in POINTS
	NSInteger widthInPoints, heightInPoints;
	if (NULL != UIGraphicsBeginImageContextWithOptions)
	{
		// On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
		// Set the scale parameter to your OpenGL ES view's contentScaleFactor
		// so that you get a high-resolution snapshot when its value is greater than 1.0
		CGFloat scale = eaglview.contentScaleFactor;
		widthInPoints = width / scale;
		heightInPoints = height / scale;
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(widthInPoints, heightInPoints), NO, scale);
	}
	else {
		// On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
		widthInPoints = width;
		heightInPoints = height;
		UIGraphicsBeginImageContext(CGSizeMake(widthInPoints, heightInPoints));
	}
    
	CGContextRef cgcontext = UIGraphicsGetCurrentContext();
    
	// UIKit coordinate system is upside down to GL/Quartz coordinate system
	// Flip the CGImage by rendering it to the flipped bitmap context
	// The size of the destination area is measured in POINTS
	CGContextSetBlendMode(cgcontext, kCGBlendModeCopy);
	CGContextDrawImage(cgcontext, CGRectMake(0.0, 0.0, widthInPoints, heightInPoints), iref);
    
	// Retrieve the UIImage from the current context
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
	UIGraphicsEndImageContext();
    
	// Clean up
	free(data);
	CFRelease(ref);
	CFRelease(colorspace);
	CGImageRelease(iref);
    
	return image;
}

- (void) takeScreenshot
{
	[[CCScheduler sharedScheduler]
     scheduleSelector: @selector(takeScreenshotAux_:)
     forTarget: self
     interval: 0
     paused: NO];
}



- (void) takeScreenshotAux_: (id) sender
{
	[[CCScheduler sharedScheduler] unscheduleSelector:@selector(takeScreenshotAux_:) forTarget:self];
	UIImage * img = [self snapshot: [CCDirector sharedDirector].openGLView];
	UIImageWriteToSavedPhotosAlbum (img, nil, nil, nil);
}

// ****

-(void)JoeTestAction{
    
    [[JoeRobot robot_]ACTION_UPDATE_ANIMATION_Between_State1:2 State2_:7 percent:25];
    
}

-(UIImage*) screenshotWithStartNode:(CCNode*)startNode
{
    [CCDirector sharedDirector].nextDeltaTimeZero = YES;
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CCRenderTexture* rtx =
    [CCRenderTexture renderTextureWithWidth:winSize.width
                                     height:winSize.height];
    [rtx begin];
    [startNode visit];
    [rtx end];
    
    return [rtx getUIImageFromBuffer];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
  //  NSLog(@"Menu Layer Touched");
    
    CGPoint location = [self convertTouchToNodeSpace:touch];
    
    if ([[touch view] isKindOfClass:[UIScrollView class]]) {
    //    NSLog(@"touched  scroll view");
        return NO;
    }
    
    if (CGRectContainsPoint([JoeRobot boundingBox], location) && canTouchJoe)
    {
        [self RobotJoeJumpOnPlace];
        
       // [self takeScreenshot];
        
        /*
        CCScene *scene = [[CCDirector sharedDirector] runningScene];
        CCNode *n = [scene.children objectAtIndex:0];
        UIImage *img = [self screenshotWithStartNode:n];
        UIImageWriteToSavedPhotosAlbum (img, nil, nil, nil);
        */
        
    }
    
    else if (CGRectContainsPoint([[spritesItemsBatchNode getChildByTag:TAG_SOUNDFX]boundingBox], location))
    {
        [cfg clickEffectForButton:[spritesItemsBatchNode getChildByTag:TAG_SOUNDFX]];
        //NSLog(@"FX");
        [self FxAction];
        [AUDIO playEffect:fx_buttonclick];
        
    }
    else if (CGRectContainsPoint([[spritesItemsBatchNode getChildByTag:TAG_MUSIC]boundingBox], location))
    {
        [cfg clickEffectForButton:[spritesItemsBatchNode getChildByTag:TAG_MUSIC]];
        [self MusicAction];
        [AUDIO playEffect:fx_buttonclick];
        //    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"idle_0.png"];
        //    [monster setDisplayFrame:frame];
        //  NSLog(@"MUSIC");
        
    }
    
    // 08-01
    
    else if( !canTouch) return YES;
    
    else  if (CGRectContainsPoint([[spritesItemsBatchNode getChildByTag:TAG_GC]boundingBox], location))
    {
        [AUDIO playEffect:fx_buttonclick];
        canTouch = NO;
        [cfg runSelectorTarget:self selector:@selector(EnableTouch) object:nil afterDelay:0.2f sender:self];
        
        [cfg clickEffectForButton:[spritesItemsBatchNode getChildByTag:TAG_GC]duration:0.1f];
        
        if (![Combinations connectedToInternet])
        {
            //B6luxPopUpManager *b = [[[B6luxPopUpManager alloc]init]autorelease];
            [B6luxPopUpManager internetConnectionPopUp];
            return NO;
        }
        
        if (![gc_ isLeaderboardShow] && [gc_ isGameCenterAvailable]) {
            UIView *view__ = [[[b6luxLoadingView alloc]init]autorelease];
            view__.tag = kLOADINGTAG;
            [[[CCDirector sharedDirector] openGLView]addSubview:view__];
            
        }
        
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.2f],[CCCallBlock actionWithBlock:^{
            if (![gc_ isLeaderboardShow] && [gc_ isGameCenterAvailable]) {
                [gc_ showLeaderboard:gc_MAIN];
            }
            
        }], nil]];
        
        return YES;
        /*
        canTouch = NO;
        
        [cfg clickEffectForButton:[spritesItemsBatchNode getChildByTag:TAG_GC]];
        
        [self runAction: [CCSequence actions:[CCDelayTime actionWithDuration:0.2f],
                          [CCCallFunc actionWithTarget:self selector:@selector(showGameCenter)],
                          nil]];
        [cfg runSelectorTarget:self selector:@selector(EnableTouch) object:nil afterDelay:0.2f sender:self];
        */
    }
    else  if (CGRectContainsPoint([[spritesItemsBatchNode getChildByTag:TAG_INFO]boundingBox], location))
    {
        [AUDIO playEffect:fx_buttonclick];
        canTouch = NO;
        
        [cfg clickEffectForButton:[spritesItemsBatchNode getChildByTag:TAG_INFO]];
        
        [self runAction:  [CCSequence actions:[CCDelayTime actionWithDuration:0.2f],
                           [CCCallBlock actionWithBlock:^{
            
            for (CCNode *childrr in self.children) {
                if ([childrr isKindOfClass:[B6luxPopUpManager class]]) {
                    return ;
                }
            }
            B6luxPopUpManager *p = [[[B6luxPopUpManager alloc]init]autorelease];
            [self addChild:p z:9999];
            [p addPopUpWithType:infoPopUp level:0];
            
        }], nil]];
        
        [cfg runSelectorTarget:self selector:@selector(EnableTouch) object:nil afterDelay:0.2f sender:self];
        
    }
    else  if (CGRectContainsPoint([[spritesItemsBatchNode getChildByTag:TAG_MOVIE]boundingBox], location))
    {
        [AUDIO playEffect:fx_buttonclick];
        canTouch = NO;
        
        [cfg clickEffectForButton:[spritesItemsBatchNode getChildByTag:TAG_MOVIE]];
        
        [self runAction:  [CCSequence actions:[CCDelayTime actionWithDuration:0.2f],
                           [CCCallFunc actionWithTarget:self selector:@selector(loadIntro)],
                           nil]];
        
        [cfg runSelectorTarget:self selector:@selector(EnableTouch) object:nil afterDelay:0.2f sender:self];
    }
    
    return YES;
}

-(void)EnableTouch{
    
    canTouch = YES;
    
}

-(void)showGameCenter{
    return;
        
        if ([Combinations connectedToInternet])
            
        {
            if (![gc_ isLeaderboardShow])
            {
                
                UIView *view__ = [[[b6luxLoadingView alloc]init]autorelease];
                view__.tag = kLOADINGTAG;
                [[[CCDirector sharedDirector] openGLView]addSubview:view__];
                [gc_ showLeaderboard:gc_MAIN];
            }
        }
    
        else
        {

            [B6luxPopUpManager internetConnectionPopUp];
        }
}

-(void)setMusicLogoON:(BOOL)on_{
    
    if (on_)
    {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"menubtn_musicon.png"];
        [(CCSprite*)[spritesItemsBatchNode getChildByTag:TAG_MUSIC] setDisplayFrame:frame];
    }
    else
    {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"menubtn_musicoff.png"];
        [(CCSprite*)[spritesItemsBatchNode getChildByTag:TAG_MUSIC] setDisplayFrame:frame];
    }
        
}

-(void)setFxLogoON:(BOOL)on_{
    
    if (on_) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"menubtn_soundon.png"];
        [(CCSprite*)[spritesItemsBatchNode getChildByTag:TAG_SOUNDFX] setDisplayFrame:frame];
    }
    else
    {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"menubtn_soundoff.png"];
        [(CCSprite*)[spritesItemsBatchNode getChildByTag:TAG_SOUNDFX] setDisplayFrame:frame];
    }
    
}

-(void)MusicAction{
    
    BOOL a = [Combinations checkNSDEFAULTS_Bool_ForKey:C_MUSIC_ON];
    
    if (a) {
        [Combinations saveNSDEFAULTS_Bool:NO forKey:C_MUSIC_ON];
        [AUDIO setBackgroundMusicVolume:0];
        [self setMusicLogoON:NO];
    }
    else if (!a){
        [Combinations saveNSDEFAULTS_Bool:YES forKey:C_MUSIC_ON];
        [AUDIO setBackgroundMusicVolume:1];
        [self setMusicLogoON:YES];
    }
    
    
}

-(void)FxAction{
    
    BOOL a = [Combinations checkNSDEFAULTS_Bool_ForKey:C_FX_ON];
    
    if (a) {
        [Combinations saveNSDEFAULTS_Bool:NO forKey:C_FX_ON];
         [AUDIO setEffectsVolume:0];
        [self setFxLogoON:NO];
    }
    else if (!a){
        [Combinations saveNSDEFAULTS_Bool:YES forKey:C_FX_ON];
         [AUDIO setEffectsVolume:1];
        [self setFxLogoON:YES];
    }
    
}

-(void)scrollDisable:(BOOL)bool_{
    
    // *** zombie jump out from the screen when it's a first game run
    if (!bool_ && ![Combinations checkNSDEFAULTS_Bool_ForKey:C_FIRST_GAME_RUN])
    {
        //NSLog(@"jump out");
        [self zombieJumpOut];
        [Combinations saveNSDEFAULTS_Bool:YES forKey:C_FIRST_GAME_RUN];
    }
    
     [MZSCrollW disableScroll:bool_];
    
}

-(void)loadIntro
{
        for (CCNode *childrr in self.children) {
            if ([childrr isKindOfClass:[B6luxYouTube class]]) {
                return ;
            }
        }
        if ([Combinations connectedToInternet]) {
            B6luxYouTube *tut_ = [[[B6luxYouTube alloc]init]autorelease];
            [self addChild:tut_ z:999];
            [tut_ playVideoFromURL:VideoLink];
            
            UIView *view__ = [[[b6luxLoadingView alloc]init]autorelease];
            view__.tag = kLOADINGTAG;
            [[[CCDirector sharedDirector] openGLView]addSubview:view__];
        }
        else
        {
          //  B6luxPopUpManager *b = [[[B6luxPopUpManager alloc]init]autorelease];
            [B6luxPopUpManager internetConnectionPopUp];
        }
    
    /*
    [self scrollDisable:YES];
    if ([Combinations connectedToInternet]) {
        B6luxYouTube *tut_ = [[[B6luxYouTube alloc]init]autorelease];
        [self addChild:tut_ z:9999];
        [tut_ playVideoFromURL:VideoLink];
    }
     */
    
}

- (void)onEnter
{
    [super onEnter];
    
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    
}

- (void)onExit
{
    //[[SimpleAudioEngine sharedEngine]unloadEffect:@"button_click.mp3"];
    [self removeAllChildrenWithCleanup:YES];
    
    [[CCTouchDispatcher sharedDispatcher]removeDelegate:self];
    [super onExit];
}

- (void) dealloc
{
//    [MZBody release];
//    MZBody = nil;
    
//    [MZSCrollW release];
//    MZSCrollW = nil;
//    
//    [TutorialBoard release];
//    TutorialBoard = nil;
//    
//    [tutorialImage release];
//    tutorialImage = nil;
    
    
	[super dealloc];
}
@end
