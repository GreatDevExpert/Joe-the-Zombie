//
//  TutorialVIEW.m
//  Zombie Joe
//
//  Created by macbook on 2013-05-22.
//
//

#import "TutorialVIEW.h"
#import "cfg.h"
#import "Constants.h"
#import "SimpleAudioEngine.h"

#import "ClippingNode.h"

#define b_continueFromTutorial 13

@implementation TutorialVIEW
@synthesize hidden;

-(id)initWithRect:(CGRect)rect levelNR:(int)level_ type:(int)type_{
    
    if((self = [super init]))
    {
        
        TYPE = type_;
     //   parent = parent_;
        
        self.anchorPoint = ccp(0.5f,0.5f);
        self.contentSize = CGSizeMake(rect.size.width,
                                      rect.size.height);
        
        self.position = ccp(rect.origin.x, rect.origin.y);
        
        [self addBatchNode];
        
        if (type_==TUTORIAL_TYPE_STARTLEVEL) {
             [self addTutorialImage:level_ blackBoardOpacity:255];
            [TutorialBoard runAction:[CCFadeTo actionWithDuration:0.75f opacity:120.f]];
            [tutorialImage runAction:[CCFadeTo actionWithDuration:0.75f opacity:200.f]];
        }
        else {
            
            [self addTutorialImage:level_ blackBoardOpacity:0];
         //   [TutorialBoard runAction:[CCFadeTo actionWithDuration:0.f opacity:120.f]];
            [tutorialImage runAction:[CCFadeTo actionWithDuration:0.f opacity:200.f]];
        }
        
        [self addContinueButton_type:type_];
        
    }
    
return self;
}

-(void)fadebit{
    
    
    
}

-(void)hideMe{
    
    //id fadeBoard = [CCFadeTo actionWithDuration:0.25f opacity:0];
    
  //  [TutorialBoard runAction:[CCFadeTo actionWithDuration:0.5f opacity:0.f]];
    
    
  // id move =   [CCMoveTo actionWithDuration:0.55f position:ccp(ScreenSize.width+(ScreenSize.width/2),ScreenSize.height/2)];
    
    // ** delete old fades and actions
    [tutorialImage stopAllActions];
    [TutorialBoard stopAllActions];
    [self stopAllActions];
    
    
    id fade =   [CCFadeTo actionWithDuration:0.75f opacity:0];
    

        [TutorialBoard runAction:[CCFadeTo actionWithDuration:0.35f opacity:0.f]];
        [tutorialImage runAction:[CCFadeTo actionWithDuration:0.35f opacity:0.f]];
        [continueBtn runAction:[CCFadeTo actionWithDuration:0.35f opacity:0.f]];
    
    id remove =  [CCCallBlock actionWithBlock:^(void)
                  {
                      hidden = YES;
                      [self removeFromParentAndCleanup:YES];
                      BLOCK_TOUCH = NO;
                  }];

    id action = [CCEaseElasticInOut actionWithAction:fade period:1.f];
    //[self runAction: action];
    
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.6f],remove, nil]];
    
   
    
  //  [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"music_sample1.mp3"];
    
//    id fade = [CCMoveBy actionWithDuration:0.4f position:ccp(500, 0)];//[CCFadeTo actionWithDuration:0.4f opacity:0];
//    [self runAction:fade];
    
}

-(void)addBatchNode{
    
    NSString *spritesStr =      [NSString stringWithFormat:@"PauseMenus_iPhone"];
    if (IS_IPAD) spritesStr =   [NSString stringWithFormat:@"PauseMenus"];
    
    spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz",spritesStr]];
    [self addChild:spritesBgNode z:4];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache]
     addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist",spritesStr]];
    
}

-(void)showTutorial:(BOOL)yes_{
    
    if (!yes_)
    {
        //        [spritesBgNode getChildByTag:b_continueFromTutorial].visible = NO;
        //        TutorialBoard.visible = NO;
        id fadeOut = [CCFadeTo actionWithDuration:0.5f opacity:0];
        [(CCSprite*)[spritesBgNode getChildByTag:b_continueFromTutorial] runAction:fadeOut];
        [TutorialBoard runAction:fadeOut];
        [tutorialImage runAction:fadeOut];
        
    }
    
    else if (yes_)
    {
        id fadeOut = [CCFadeTo actionWithDuration:0.5f opacity:255];
        [(CCSprite*)[spritesBgNode getChildByTag:b_continueFromTutorial] runAction:fadeOut];
        [TutorialBoard runAction:fadeOut];
        [tutorialImage runAction:fadeOut];
        //        [spritesBgNode getChildByTag:b_continueFromTutorial].visible = YES;
        //        TutorialBoard.visible = YES;
    }
    
}

-(void)addContinueButton_type:(int)type_{
    
    if (type_ == TUTORIAL_TYPE_STARTLEVEL)
    {
        continueBtn = [CCSprite spriteWithSpriteFrameName:@"btn_continue.png"];
    }
    else
    {
        continueBtn = [CCSprite spriteWithSpriteFrameName:@"btn_resume.png"];
    }
    
 //   continueBtn = [CCSprite spriteWithSpriteFrameName:@"btn_continue.png"];
    [spritesBgNode addChild:continueBtn z:4 tag:b_continueFromTutorial];
    continueBtn.position = ccp(ScreenSize.width/2, ScreenSize.height*0.2f);
    continueBtn.scale = 0;
    
    id scale = [CCScaleTo actionWithDuration:0.2 scale:1.f];
    id action = [CCEaseElasticInOut actionWithAction:scale period:1.f];
    
    
    
    id seq = [CCSequence actions:action, nil];
    
    [continueBtn runAction: [CCSequence actions:seq, nil]];
}



-(void)addTutorialImage:(int)levelNR blackBoardOpacity:(float)blbdopacity_{
    
    TutorialBoard = [[[CCSprite alloc]init]autorelease];
    
    [TutorialBoard setTextureRect:CGRectMake(0, 0, self.contentSize.width,
                                             self.contentSize.height)];
    TutorialBoard.anchorPoint = ccp(0.5f, 0.5f);
    TutorialBoard.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
    
    [self addChild:TutorialBoard z:2 tag:5];
    TutorialBoard.color = ccBLACK;
    TutorialBoard.opacity = blbdopacity_;
    
    tutorialImage = [CCSprite spriteWithFile:[NSString stringWithFormat:@"level_%i.png",levelNR]];
    [self addChild:tutorialImage z:3];
    tutorialImage.opacity = blbdopacity_;
    if (IS_IPAD) {
        tutorialImage.scale = 1.5f;
        if (![Combinations isRetina]) {
            tutorialImage.scale = 1;
        }
    }
    else if (IS_IPHONE){
        
        tutorialImage.scale = kSCALE_FACTOR_FIX;
        
    }
    
    tutorialImage.visible = YES;
    tutorialImage.position = ccp(ScreenSize.width/2, ScreenSize.height/2);
    
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
    
  //  NSLog(@"touch in tutorial");
    
//    NSSet *allTouches = [event allTouches];
//    for (UITouch *aTouch in allTouches) {
//        
//        if ( ![self containsTouchLocation:aTouch] ) return NO;
//    }
  //  NSLog(@"there is a touch");
    
    CGPoint location = [self convertTouchToNodeSpace:touch];

    
        if (CGRectContainsPoint([[spritesBgNode getChildByTag:b_continueFromTutorial] boundingBox], location) && !BLOCK_TOUCH)
        {
            [cfg clickEffectForButton:[spritesBgNode getChildByTag:b_continueFromTutorial]];
      //      NSLog(@"pressed continue");
                        BLOCK_TOUCH = YES;
            if (TYPE == TUTORIAL_TYPE_STARTLEVEL) {
                 [AUDIO playEffect:fx_buttonclick];
                
                if ([parent_ respondsToSelector:@selector(LEVEL_START)])
                {
                     [parent_ performSelector:@selector(LEVEL_START)];
                }
                else [parent_ performSelector:@selector(TIME_Begin) withObject:nil];    //remove after
            }
            else if (TYPE == TUTORIAL_TYPE_PAUSED)
            {
                [parent_ performSelector:@selector(LEVEL_RESUME)];
                 [AUDIO playEffect:fx_buttonclick];
            }
 
            [self hideMe];
          //  [self showTutorial:NO];
            return YES;
        }
    
    return YES;
    
}


-(void)onEnter //---cia leidzia naudoti touch komandas. onEnter nereikia niekur kviest, jisai pats pirmas pasileidzia pagal prioriteta netgi jo neisrasiu i init
{
    
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:touchTutorial swallowsTouches:YES];
    
    [super onEnter];
}

- (void)onExit
{
    
    [self removeAllChildrenWithCleanup:YES];
    
    [[CCTouchDispatcher sharedDispatcher]removeDelegate:self];
    
 //   NSLog(@"REMOVED TUTORIAL SCREEN");
    
    //    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    //
    //    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    [super onExit];
    
}

-(void) dealloc
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	//parent = nil;
	[super dealloc];
}


@end
