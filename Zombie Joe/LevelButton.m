//
//  LevelButton.m
//  Zombie Joe
//
//  Created by macbook on 2013-05-24.
//
//

#import "LevelButton.h"
#import "cfg.h"
#import "Constants.h"  
#import "BrainsBonus.h"

#define BRAIN1  10
#define BRAIN2  11
#define BRAIN3  12

@implementation LevelButton
@synthesize level;
@synthesize unlocked;

-(id)initWith_tag:(int)levlenr frameName:(NSString*)name_{
    
    if((self = [super init]))
    {
       // NSLog(@"Init with tag :%i. Name %@",levlenr,name_);
        level = levlenr;
        
        [self addItemsBatchNode];
        
        [self addSpriteImage_name:name_];
        
   //     [cfg addTEMPBGCOLOR:self anchor:ccp(0.f, 0.f) color:ccRED];
        
        if (level<16)
        {
            [self addStatusWindow];
         //   [self addPointsNumberOfLevel];

        }
        
    }
    return self;
}

-(void)addTimeLabel{
    
    float w = (IS_IPAD) ? 80.f :     70*0.46875f;
    float h = (IS_IPAD) ? 42.5f :    42.5f*0.46875f;
    
    int time = [db getHighTIMEForLevel:level];
    
    NSString *stringTime = [NSString stringWithFormat:@"%02li:%02li:%02li",
                            
                            lround(floor(time / 3600.)) % 100,
                            lround(floor(time / 60.)) % 60,
                            lround(floor(time)) % 60];

    TimeLabel = [[[CCLabelTTF alloc] initWithString:@"00:00:00" dimensions:CGSizeMake(w*2,h)
                                                 alignment:UITextAlignmentCenter fontName:@"StartlingFont" fontSize:fFONT_MENU_BLACKLINE_LABELS]autorelease];
   

    TimeLabel.anchorPoint = ccp(0.5f, 0.5f);
    
    TimeLabel.position = ccp(blackBoard.position.x, blackBoard.position.y-(kFontMenuYFix));
    TimeLabel.color = COL_YELLOW_DARK;
    [self addChild:TimeLabel z:10];
    [TimeLabel setString:stringTime];
    
}

-(void)addPointsNumberOfLevel{
    
    float w = (IS_IPAD) ? 80.f :     70*0.46875f;
    float h = (IS_IPAD) ? 42.5f :    42.5f*0.46875f;

    int score = [db getHighScoreForLevel:level];
    
    CCLabelTTF *label = [[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"Points: 00000"] dimensions:CGSizeMake(w*2,h)
                                                 alignment:UITextAlignmentLeft fontName:@"StartlingFont" fontSize:fFONT_MENU_BLACKLINE_LABELS]autorelease];
    //LABEL POSITION HERE
    
    
    label.anchorPoint = ccp(0, 0.5f);
    
    label.position = ccp(blackBoard.position.x-(blackBoard.boundingBox.size.width*0.45f), blackBoard.position.y-(kFontMenuYFix));

    label.color = COL_YELLOW_DARK;
    [self addChild:label z:10];
    [label setString:[NSString stringWithFormat:@"Points: %i",score]];
    
}

-(void)action{
    
 //   NSLog(@"pushed button");
    
}

-(void)addBrainsNumber{
    
    float offset = (IS_IPAD) ? 5 : 5*0.46f;
    CGPoint pos = ccp(blackBoard.position.x+(blackBoard.boundingBox.size.width/2), blackBoard.position.y);
    
    for (int x = 2;  x >= 0; x--) {
        
        BrainsBonus *BRAIN = [[[BrainsBonus alloc]initWithRect:CGRectMake(0, 0, 0, 0)]autorelease];
        BRAIN.tag = BRAIN1+x;
        BRAIN.anchorPoint = ccp(1.f, 0.5f);
        BRAIN.scale = 0.4f;
        BRAIN.position =
        ccpAdd(pos,ccp((-BRAIN.boundingBox.size.width*x)-((x+1)*offset),0));

        [self addChild:BRAIN];
        
    }
    
    int brainNr = [Combinations getNSDEFAULTS_INT_forKey:C_BRAIN_RECORD_LEVEL(level)];
    
    [self setBRAINS_TO:brainNr];
    
}



-(void)setBRAINS_TO:(int)nrOfBrains{
    
    //reset all
    for (int x = BRAIN1; x <=BRAIN3; x++) {
        BrainsBonus *brain = (BrainsBonus*)[self getChildByTag:x];
        brain.brain.opacity = 50;
    }
    
    if (nrOfBrains< 1 || nrOfBrains > 3) {
        return;
    }

    
    for (int x = BRAIN1; x < BRAIN1+(nrOfBrains); x++)
    {
        BrainsBonus *brain = (BrainsBonus*)[self getChildByTag:x];
        brain.brain.opacity = 255.f;
    }
    
}

-(void)HIDE_BRAINS{
    
    for (int x = BRAIN1; x <=BRAIN3; x++) {
        BrainsBonus *brain = (BrainsBonus*)[self getChildByTag:x];
        brain.brain.opacity = 0;
    }
    
}

-(void)SHOW_LABELS{
    
    TimeLabel.visible        = YES;
    levelNumberLabel.visible = YES;
    blackBoard.visible = YES;
    
    //[levelNumberLabel removeFromParentAndCleanup:YES];
    
}

-(void)HIDE_LABELS{
    
    TimeLabel.visible        = NO;
    levelNumberLabel.visible = NO;
    
    //[levelNumberLabel removeFromParentAndCleanup:YES];
    
}

-(void)HIDE_TOPLINE{
    
    blackBoard.visible = NO;
    
}

-(void)HIDE_ELEMENTS_LOCK_STATE{
    
    [self HIDE_BRAINS];
    [self HIDE_LABELS];
    [self HIDE_TOPLINE];
    
}

-(void)refreshStatusLabel{
    
    if ([Combinations checkNSDEFAULTS_Bool_ForKey:C_PURCHASE_DONE])
    {
        [lockedLabel1 setString:[NSString stringWithFormat:@"   FINISH              PREVIOUS"]];
        lockedLabel1.color = COL_YELLOW_DARK;
    }
    
}

-(void)refreshLevelStatusWindow{
    
    [self refreshStatusLabel];  // PREMIUM ? FINISH PREVIOUS ?
    
    // *** Unlock level if PREVIOUS was 5 or 6 ???
    
    /*
    if (![Combinations checkNSDEFAULTS_Bool_ForKey:C_PURCHASE_DONE])
    {
        NSLog(@"ERROR ! Purchase was not done");
        return;
    }
    */


    int score = [db getHighScoreForLevel:level];
    //int scorePrev = [db getHighScoreForLevel:level-1];
    

    if (score > 0)
    {
      //  NSLog(@"MUST UNlock second level. Level now %i score %i",level,score);
        [Combinations saveNSDEFAULTS_Bool:YES forKey:C_UNLOCK_LEVEL(level+1)];
    }

    if   ([Combinations checkNSDEFAULTS_Bool_ForKey:C_UNLOCK_LEVEL(level)] && locked)
    {
            [self visualAndBrianSettingsRefresh];
    }

}

-(void)visualAndBrianSettingsRefresh{
 
    //NSLog(@"unlock on the air level %i",level);
    
        // *** LEVEL WAS UNLOCKED !
        unlocked = YES;
        locked = NO;
        
        levelImg.opacity = 255; //opacity
        
        int brainNr = [Combinations getNSDEFAULTS_INT_forKey:C_BRAIN_RECORD_LEVEL(level)];
        [self setBRAINS_TO:brainNr];
        
        lockedLabel1.visible = NO;
        
        lock.visible = NO;
        [self SHOW_LABELS];

}

-(void)addStatusWindow{
    
    //unlocked = YES;
    
    [self addBlackWindow];          //upper black line
    
  //  [self addTimeLabel];            //time passed the level
    
    [self addLevelNumberLabel];     //level number label
    
    [self addBrainsNumber];         //Brain number
    
    //Must check level status here before setting the lock state
    
    BOOL unlocked_ = [Combinations checkNSDEFAULTS_Bool_ForKey:C_UNLOCK_LEVEL(level)];
  //  locked = levelState;
    
  //  NSLog(@"Level  %i  state %i",level,locked);
    
    if (unlocked_)
    {
        return;
    }
    
    {
        NSString *lockText = [NSString stringWithFormat:@"PREMIUM               LEVELS"];
        
        
        /*  08-08
         
        if (level < 6)
        {
            lockText = [NSString stringWithFormat:@"   FINISH              PREVIOUS"];
        }
        */
        
        if (level > 6 && [Combinations checkNSDEFAULTS_Bool_ForKey:C_PURCHASE_DONE])
        {
        lockText = [NSString stringWithFormat:@"   FINISH              PREVIOUS"];
        }
        
        [self addLockStateWithText:lockText];
        [self HIDE_ELEMENTS_LOCK_STATE];
        
    }
    
    
}

-(void)addLockStateWithText:(NSString*)text_{

    locked = YES;
    
    //box
    
    /*
    blackBoardBIG = [[[CCSprite alloc]init]autorelease];
    
    [blackBoardBIG setTextureRect:CGRectMake(0, 0, self.contentSize.width,
                                          self.contentSize.height)];
    blackBoardBIG.position = ccp(
                              self.contentSize.width/2,
                              self.contentSize.height/2);
    blackBoardBIG.opacity = 100;
    blackBoardBIG.anchorPoint = ccp(0.5f, 0.5f);
    [self addChild:blackBoardBIG z:0 tag:5];
    blackBoardBIG.color = ccBLACK;
    */
    //lock icon
    
    levelImg.opacity = 100; // SET THE IMAGE OF LEVEL OPACITY  ! warning when level unlocked back to 255
    
    lock =[CCSprite spriteWithSpriteFrameName:@"lvl_locked.png"];
    lock.position = ccp(self.position.x+self.contentSize.width/2,
                        self.position.y+self.contentSize.height/2);
    //ccp(lock.boundingBox.size.width*0.75f,self.contentSize.height-(lock.boundingBox.size.height*0.75f));
    [spritesItemsBatchNode addChild:lock z:1];
    
    // labels "unlock level X" or "buy all levels"
    float w = (IS_IPAD) ? 80.f :     70*0.46875f;
    float h = (IS_IPAD) ? 42.5f :    42.5f*0.46875f;
    
   lockedLabel1 = [[[CCLabelTTF alloc] initWithString:text_
                                                dimensions:CGSizeMake(lock.boundingBox.size.width,h)
                                                 alignment:UITextAlignmentCenter fontName:@"StartlingFont" fontSize:fFONT_MENU_BLACKLINE_LABELS]autorelease];
    
    lockedLabel1.anchorPoint = ccp(0.515f, 0.5f);
    lockedLabel1.position = lock.position;
    lockedLabel1.position = ccpAdd(lockedLabel1.position, ccp(0, -(kFontMenuYFix)));
    
    
 
    if (level < 6)
    {
        lockedLabel1.color = COL_YELLOW_DARK;
    }
       // ** LABEL SHOULD BE YELLOW WHEN PUCHASED
    else if (level > 5 && [Combinations checkNSDEFAULTS_Bool_ForKey:C_PURCHASE_DONE]){
        lockedLabel1.color = COL_YELLOW_DARK;
    }
    // *** LOCKED LEVEL COLOR
    else lockedLabel1.color =ccWHITE;// COL_GREEN;
    
    [self addChild:lockedLabel1 z:10];
    
}

-(void)addLevelNumberLabel{
    
    float w = (IS_IPAD) ? 80.f :     70*0.46875f;
    float h = (IS_IPAD) ? 42.5f :    42.5f*0.46875f;
    
    int time = [db getHighTIMEForLevel:level];
    
    NSString *stringTime = [NSString stringWithFormat:@"%02li:%02li:%02li",
                            
                            lround(floor(time / 3600.)) % 100,
                            lround(floor(time / 60.)) % 60,
                            lround(floor(time)) % 60];
    
    levelNumberLabel = [[[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"Level %i     %@",level,stringTime]
                                                 dimensions:CGSizeMake(w*3,h)
                                                 alignment:UITextAlignmentLeft fontName:@"StartlingFont" fontSize:fFONT_MENU_BLACKLINE_LABELS]autorelease];
    
    levelNumberLabel.anchorPoint = ccp(-0.05f, 0.5f);
    levelNumberLabel.position = ccp(blackBoard.position.x-(blackBoard.boundingBox.size.width/2)+(kFontMenuYFix), blackBoard.position.y-(kFontMenuYFix));
    levelNumberLabel.color = COL_YELLOW_DARK;
    [self addChild:levelNumberLabel z:10];
    
}

-(void)addBlackWindow{
    
    blackBoard = [[[CCSprite alloc]init]autorelease];
    
    [blackBoard setTextureRect:CGRectMake(0, 0, self.contentSize.width*1.f,// self.contentSize.width*0.65f,
                                          self.contentSize.height*0.21f)];
    blackBoard.position = ccp(
                self.contentSize.width-(blackBoard.boundingBox.size.width*0.5f),
                self.contentSize.height-(blackBoard.boundingBox.size.height/2));
    blackBoard.opacity = 200;
    blackBoard.anchorPoint = ccp(0.5f, 0.5f);
    [self addChild:blackBoard z:0 tag:5];
    blackBoard.color = ccBLACK;
    
}


-(void)onEnter
{
    
  //  [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-20 swallowsTouches:YES];
    [super onEnter];
}

- (void)onExit
{
    
    [self removeAllChildrenWithCleanup:YES];
    
    [super onExit];
    
}

-(void) dealloc
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	
	[super dealloc];
}

-(void)addSpriteImage_name:(NSString*)name_{
    
    levelImg = [CCSprite spriteWithSpriteFrameName:name_];
    self.contentSize = CGSizeMake(levelImg.boundingBox.size.width, levelImg.boundingBox.size.height);
    levelImg.anchorPoint = ccp(0.f, 0.f);
    [self addChild:levelImg];
    
}

-(void)addItemsBatchNode{

    NSString *spritesStr =      [NSString stringWithFormat:@"MenuItems_iPhone"];
    if (IS_IPAD) spritesStr =   [NSString stringWithFormat:@"MenuItems"];
    
    spritesItemsBatchNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz",spritesStr]];
    [self addChild:spritesItemsBatchNode z:10];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache]
     addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist",spritesStr]];
    
}

-(void)createBatchNode{
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
    
    NSString *spritesStr =      [NSString stringWithFormat:@"MenuLevels_iPhone"];
    if (IS_IPAD) spritesStr =   [NSString stringWithFormat:@"MenuLevels"];
    
    spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz",spritesStr]];
    [self addChild:spritesBgNode z:5];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache]
     addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist",spritesStr]];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
}

@end
