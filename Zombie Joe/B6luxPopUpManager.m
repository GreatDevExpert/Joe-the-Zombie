//
//  B6luxPopUpManager.m
//  Zombie Joe
//
//  Created by Slavian on 2013-07-25.
//
//

#import "B6luxPopUpManager.h"
#import "cfg.h"
#import "SConfig.h"
#import "MainMenu.h"
#import "SCombinations.h"
#import "B6luxIAPHelper.h"
#import "B6luxTwitter.h"
#import "FacebookManager.h"
#import "SceneManager.h"
#import "b6luxLoadingView.h"
#import <Twitter/Twitter.h>

#define kBg 100
#define kBatchNode 500
#define kLevelsBatchNode 501
#define kBuyButton 600
#define kShareButton 601
#define kShareButtonImage 602
#define kCloseButton 603
#define kBuySprite 800
#define kInfoImage 810
#define kTwitter 850
#define kLabelTag 1000
#define kPlayButton 1003

@implementation B6luxPopUpManager


-(void)LOAD_START
{
//    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//        b6luxLoading *l = [[[b6luxLoading alloc] init] autorelease];
//        [self addChild:l z:9999];
//        
//        [l performSelectorOnMainThread:@selector(loadingON) withObject:nil waitUntilDone:YES];
//    });
    
}

-(int)returnLevelNr{
    
    return levelNr;
    
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint location = [self convertTouchToNodeSpace:touch];
    
    if (!b_infoPopUp) {
        
        if ([[self getChildByTag:kBatchNode] getChildByTag:kPlayButton]) {
            if (CGRectContainsPoint([[[self getChildByTag:kBatchNode] getChildByTag:kPlayButton]boundingBox], location))
            {
                 [AUDIO playEffect:fx_buttonclick];
                
                
                
                [cfg clickEffectForButton:[[self getChildByTag:kBatchNode] getChildByTag:kPlayButton] duration:0.1f];
                
                // check if level unlocked ?
                
                BOOL levelToPlayState = [Combinations checkNSDEFAULTS_Bool_ForKey:C_UNLOCK_LEVEL(levelNr)];
                
                if  (!levelToPlayState)
                {
                //    NSLog(@"ERROR! Level is not unlocked , but PLAY button is shown");
                    return NO;
                }
                
                
                [self runAction:[CCSequence actions:
                                [CCDelayTime actionWithDuration:0.2f],
                                [CCCallBlock actionWithBlock:^
                {
                    [SceneManager goGameScene:levelNr showTutorial:YES restart:NO];
                }], nil]];
                
                
                return YES;
        }
 
        }
        
        if (CGRectContainsPoint([[[self getChildByTag:kBatchNode] getChildByTag:kBuyButton]boundingBox], location))
        {
             [AUDIO playEffect:fx_buttonclick];
            [cfg clickEffectForButton:[[self getChildByTag:kBatchNode] getChildByTag:kBuyButton] duration:0.1f];
            
            if (![Combinations connectedToInternet]){
                
                // B6luxPopUpManager *b = [[[B6luxPopUpManager alloc]init]autorelease];
                [B6luxPopUpManager internetConnectionPopUp];
                return NO;
            }
            
            
            [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.2f],[CCCallBlock actionWithBlock:^{
                if ((![[B6luxIAPHelper sharedInstance]isPurchasedNow]) && (![[B6luxIAPHelper sharedInstance]isRestoringNow])) {
                    UIView *view__ = [[[b6luxLoadingView alloc]init]autorelease];
                    view__.tag = kLOADINGTAG;
                    [[[CCDirector sharedDirector] openGLView]addSubview:view__];
                    
                    [[B6luxIAPHelper sharedInstance] requestProductsWithIndetifier:purchaseIndetifier parent:self];
                }
                
            }], nil]];
        
            return YES;
        }

        if (CGRectContainsPoint([[[self getChildByTag:kBatchNode] getChildByTag:kBuySprite]boundingBox], location))
        {
             [AUDIO playEffect:fx_buttonclick];
            [cfg clickEffectForButton:[[self getChildByTag:kBatchNode] getChildByTag:kBuySprite] duration:0.1f];
            
            if (![Combinations connectedToInternet]){
                
                // B6luxPopUpManager *b = [[[B6luxPopUpManager alloc]init]autorelease];
                [B6luxPopUpManager internetConnectionPopUp];
                return NO;
            }
            
            
            [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.2f],[CCCallBlock actionWithBlock:^{
             if ((![[B6luxIAPHelper sharedInstance]isPurchasedNow]) && (![[B6luxIAPHelper sharedInstance]isRestoringNow])) {
                UIView *view__ = [[[b6luxLoadingView alloc]init]autorelease];
                view__.tag = kLOADINGTAG;
                [[[CCDirector sharedDirector] openGLView]addSubview:view__];
                
                [[B6luxIAPHelper sharedInstance] requestProductsWithIndetifier:purchaseIndetifier parent:self];
             }
            }], nil]];
            return YES;
        }
        if (CGRectContainsPoint([[[self getChildByTag:kBatchNode] getChildByTag:kBuySprite+1]boundingBox], location))
        {
             [AUDIO playEffect:fx_buttonclick];
            [cfg clickEffectForButton:[[self getChildByTag:kBatchNode] getChildByTag:kBuySprite+1]duration:0.1f];
            
            if (![Combinations connectedToInternet]){
                
                // B6luxPopUpManager *b = [[[B6luxPopUpManager alloc]init]autorelease];
                [B6luxPopUpManager internetConnectionPopUp];
                return NO;
            }
            
            UIView *view__ = [[[b6luxLoadingView alloc]init]autorelease];
            view__.tag = kLOADINGTAG;
            [[[CCDirector sharedDirector] openGLView]addSubview:view__];
            
            
            
            [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.2f],[CCCallBlock actionWithBlock:^{
                
                        [[FacebookManager sharedMgr] Feed:self];
        
            }], nil]];
            
            return YES;
              
        }

        if (CGRectContainsPoint([[[self getChildByTag:kBatchNode] getChildByTag:kBuySprite+2]boundingBox], location))
        {
             [AUDIO playEffect:fx_buttonclick];
             [cfg clickEffectForButton:[[self getChildByTag:kBatchNode] getChildByTag:kBuySprite+2]duration:0.1f];
            
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

            if (![Combinations connectedToInternet]){
                
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
                        return;
                    }
                }
                B6luxTwitter*_twitter = [[[B6luxTwitter alloc]init] autorelease];
                [self addChild:_twitter z:999 tag:kTwitter];
                [_twitter tweet_withScreenShot:NO text:twitterSharetxt];
                
            }], nil]];
            
            return YES;
            
        }
        if ([[self getChildByTag:kBatchNode] getChildByTag:kBuySprite+3]) {
     
            if (CGRectContainsPoint([[[self getChildByTag:kBatchNode] getChildByTag:kBuySprite+3]boundingBox], location))
            {
                 [AUDIO playEffect:fx_buttonclick];
                 [cfg clickEffectForButton:[[self getChildByTag:kBatchNode] getChildByTag:kBuySprite+3] duration:0.1f];
                
                if (![Combinations connectedToInternet]){
                    
                    // B6luxPopUpManager *b = [[[B6luxPopUpManager alloc]init]autorelease];
                    [B6luxPopUpManager internetConnectionPopUp];
                    return NO;
                }
                
                
                [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.2f],[CCCallBlock actionWithBlock:^{
                    if ((![[B6luxIAPHelper sharedInstance]isPurchasedNow]) && (![[B6luxIAPHelper sharedInstance]isRestoringNow])) {
                    UIView *view__ = [[[b6luxLoadingView alloc]init]autorelease];
                    view__.tag = kLOADINGTAG;
                    [[[CCDirector sharedDirector] openGLView]addSubview:view__];
                    
                    [[B6luxIAPHelper sharedInstance] restoreCompletedTransactionsWithparent:self];
                    }
                }], nil]];
          
                return YES;
            }
        }
        if (CGRectContainsPoint([[[self getChildByTag:kBatchNode] getChildByTag:kCloseButton]boundingBox], location))
        {
             [AUDIO playEffect:fx_buttonclick];
            [cfg clickEffectForButton:[[self getChildByTag:kBatchNode] getChildByTag:kCloseButton] duration:0.1f];
            
            [[self getChildByTag:kBg] runAction:[CCFadeTo actionWithDuration:0.5f opacity:0]];
            [self smoothRemove];
        
            return YES;
        }
    }else
    {
        [[self getChildByTag:kInfoImage] runAction:[CCMoveTo actionWithDuration:0.3f position:ccp(kWidthScreen/2, -[self getChildByTag:kInfoImage].contentSize.height)]];
        
        [[self getChildByTag:kBg] runAction:[CCFadeTo actionWithDuration:0.3f opacity:0]];
        [self smoothRemove];
    }
    return YES;
}

-(void)submitShare
{
    //[self transformAfterShare];
    [self playButtonShow];
    // *** SHARED A GAME -> save trigger
    [Combinations saveNSDEFAULTS_Bool:YES forKey:C_GAME_SHARED];
    
    // *** unlock level
    [Combinations saveNSDEFAULTS_Bool:YES forKey:C_UNLOCK_LEVEL(levelNr)];
    // unlock level
    
    if ([parent_ isKindOfClass:[MainMenu class]])
    {
         [parent_ performSelector:@selector(purchaseWasDoneNow)];
       //   NSLog(@"main menu class parent - Share action -> Unlock lelel");
    }

}

- (void) onEnter
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-40 swallowsTouches:YES];
    
    [super onEnter];
}

-(void)playButtonShow
{
    for (int i = 1; i<3; i++) {
        [[[self getChildByTag:kBatchNode] getChildByTag:kBuySprite+i] runAction:[CCSpawn actions:[CCScaleTo actionWithDuration:0.3f scale:0],[CCFadeTo actionWithDuration:0.3f opacity:0], nil]];
    }
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"btn_play.png"];
    sprite.anchorPoint = ccp(0.5f, 0.5f);
    sprite.position = ccp([[self getChildByTag:kBatchNode] getChildByTag:kShareButton].position.x, [[self getChildByTag:kBatchNode] getChildByTag:kBuySprite+1].position.y);
    [[self getChildByTag:kBatchNode] addChild:sprite z:5 tag:kPlayButton];
    
    [cfg clickEffectForButton:sprite duration:0.15f];
    [SCombinations opacityEffectToSprite:sprite from:0 to:255 timeDuration:0.3f];

}

-(void)dealloc{
    
    [super dealloc];
    
}

-(void)onExit
{
    [[CCTouchDispatcher sharedDispatcher]removeDelegate:self];
    [[CCDirector sharedDirector] openGLView].userInteractionEnabled = YES;
    [self removeAllChildrenWithCleanup:YES];
    //[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];

    //[[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    [super onExit];
}

+(void)internetConnectionPopUp
{
//    if ([Combinations connectedToInternet]) {
//        return;
//    }
//    else
//    {

    
    
    if ([[[CCDirector sharedDirector] openGLView]viewWithTag:kLOADINGTAG]) {
        [[[[CCDirector sharedDirector] openGLView]viewWithTag:kLOADINGTAG]removeFromSuperview];
    }
       
    UIAlertView *tmp = [[UIAlertView alloc]
                        initWithTitle:@"Warning!"
                        message:@"Can't connect. Please check your internet connection."
                        delegate:self
                        cancelButtonTitle:@"OK"
                        otherButtonTitles:nil, nil];
    [tmp show];
    [tmp release];
    
  //  [self removeFromParentAndCleanup:YES];
    
//    }

}

-(void)transformAfterShare
{
    for (int i = 0;i<2; i++) {
        [[self getChildByTag:kLabelTag+i] runAction:[CCSpawn actions:[CCFadeTo actionWithDuration:0.3f opacity:0],[CCScaleTo actionWithDuration:0.3f scale:0], nil]];
    }
    
    [[[self getChildByTag:kBatchNode] getChildByTag:kShareButton] runAction:[CCSpawn actions:[CCScaleTo actionWithDuration:0.3f scale:0],[CCFadeTo actionWithDuration:0.3f opacity:0], nil]];
    [[[self getChildByTag:kLevelsBatchNode] getChildByTag:kShareButtonImage] runAction:[CCSpawn actions:[CCScaleTo actionWithDuration:0.3f scale:0],[CCFadeTo actionWithDuration:0.3f opacity:0], nil]];
    [[[self getChildByTag:kBatchNode] getChildByTag:kBuySprite+1] runAction:[CCSpawn actions:[CCScaleTo actionWithDuration:0.3f scale:0],[CCFadeTo actionWithDuration:0.3f opacity:0], nil]];
    [[[self getChildByTag:kBatchNode] getChildByTag:kBuySprite+2] runAction:[CCSpawn actions:[CCScaleTo actionWithDuration:0.3f scale:0.3f],[CCFadeTo actionWithDuration:0.3f opacity:0], nil]];
    
    [[[self getChildByTag:kBatchNode] getChildByTag:kBuyButton] runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:0.5f position:ccp(kWidthScreen/2,[[self getChildByTag:kBatchNode] getChildByTag:kBuyButton].position.y)] rate:3]];
    
    [[[self getChildByTag:kBatchNode] getChildByTag:kBuySprite] runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:0.5f position:ccp(kWidthScreen/2,[[self getChildByTag:kBatchNode] getChildByTag:kBuySprite].position.y)] rate:3]];
    
    [[self getChildByTag:1002] runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:0.5f position:ccp(kWidthScreen/2,[self getChildByTag:1002].position.y)] rate:3]];
}

-(void)onlyBuyPopUp
{
    for (int i = 0; i<=4; i++) {
        CCSprite *sprite;
        switch (i) {
            case 0:
                sprite = [CCSprite spriteWithSpriteFrameName:@"unlock_buy.jpg"];
                sprite.anchorPoint = ccp(0.5f, 0.5f);
                sprite.opacity = 0;
                sprite.position = [self convertToNodeSpace:ccp(kWidthScreen/2, kHeightScreen/2)];
                [[self getChildByTag:kBatchNode] addChild:sprite z:2 tag:kBuyButton];
                [SCombinations opacityEffectToSprite:sprite from:0 to:255 timeDuration:0.3f];
                break;
            case 1:{
                CCLabelTTF *label = [CCLabelTTF labelWithString:@"PREMIUM LEVELS" dimensions:contentSize_ alignment:UITextAlignmentCenter fontName:@"StartlingFont" fontSize:IS_IPAD ? 40 : 20];
                label.position = ccp([[self getChildByTag:kBatchNode] getChildByTag:kBuyButton].position.x,[[self getChildByTag:kBatchNode] getChildByTag:kBuyButton].position.y + [[self getChildByTag:kBatchNode] getChildByTag:kBuyButton].contentSize.height/1.6f);;
                [SCombinations opacityEffectToSprite:label from:0 to:255 timeDuration:0.3f];
                label.color = COL_YELLOW_DARK;
                [self addChild:label z:10 tag:kLabelTag+i];
            }
                break;
            case 2:
                sprite = [CCSprite spriteWithSpriteFrameName:@"unlock_btn_buy.png"];sprite.position = ccp([[self getChildByTag:kBatchNode] getChildByTag:kBuyButton].position.x, [[self getChildByTag:kBatchNode] getChildByTag:kBuyButton].position.y - [[self getChildByTag:kBatchNode] getChildByTag:kBuyButton].contentSize.height/2.f - sprite.contentSize.height/1.6f);
                sprite.anchorPoint = ccp(0.5f, 0.5f);
                sprite.opacity = 0;
                [SCombinations opacityEffectToSprite:sprite from:0 to:255 timeDuration:0.3f];
                [[self getChildByTag:kBatchNode] addChild:sprite z:20 tag:kBuySprite];
                break;
            case 3:
                sprite = [CCSprite spriteWithSpriteFrameName:@"unlock_btn_close.png"];
                sprite.anchorPoint = ccp(0.5f, 0.5f);
                sprite.position = [self convertToNodeSpace:ccp(kWidthScreen - sprite.contentSize.width*2, kHeightScreen - sprite.contentSize.height*2)];
                [[self getChildByTag:kBatchNode] addChild:sprite z:2 tag:kCloseButton];
                sprite.opacity = 0;
                [SCombinations opacityEffectToSprite:sprite from:0 to:255 timeDuration:0.3f];
                [cfg clickEffectForButton:sprite duration:0.1f];
                break;
            case 4:
                sprite = [CCSprite spriteWithSpriteFrameName:@"btn_restore.png"];sprite.position = [self convertToNodeSpace:ccp(kWidthScreen/2, kHeightScreen/8)];
                [SCombinations opacityEffectToSprite:sprite from:0 to:255 timeDuration:0.3f];
                [cfg clickEffectForButton:sprite duration:0.1f];
                [[self getChildByTag:kBatchNode] addChild:sprite z:2 tag:kBuySprite+3];

                break;
            default:break;
        }
    }
}

-(void)createLevelsBatchNode
{
    
    CCSpriteBatchNode *spritesItemsBatchNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"MenuLevels%@.pvr.ccz",kDevice]];
    [self addChild:spritesItemsBatchNode z:5 tag:kLevelsBatchNode];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache]
     addSpriteFramesWithFile:[NSString stringWithFormat:@"MenuLevels%@.plist",kDevice]];

}

-(void)infoPopUp
{
    CCSprite*sprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"credits%@.png",kDevice]];
    sprite.anchorPoint = ccp(0.5f,0.5f);
    sprite.position = ccp(kWidthScreen/2, -sprite.contentSize.height);
    [self addChild:sprite z:9999 tag:kInfoImage];
    [sprite runAction:[CCMoveTo actionWithDuration:0.3f position:ccp(kWidthScreen/2, kHeightScreen/2)]];
}

-(void)levelUnlockPopUp
{
    [self createLevelsBatchNode];
    
    for (int i = 0; i<4; i++) {
        CCSprite *sprite;
        switch (i) {
            case 0:
                sprite = [CCSprite spriteWithSpriteFrameName:@"unlock_buy.jpg"];
                sprite.anchorPoint = ccp(0.5f, 0.5f);
                sprite.position = [self convertToNodeSpace:ccp(kWidthScreen/2 + sprite.contentSize.width/1.8f, kHeightScreen/2)];
                [[self getChildByTag:kBatchNode] addChild:sprite z:2 tag:kBuyButton];
                break;
            case 1:
                sprite = [CCSprite spriteWithSpriteFrameName:@"unlock_share.png"];
                sprite.anchorPoint = ccp(0.5f, 0.5f);
                sprite.position = [self convertToNodeSpace:ccp(kWidthScreen/2 - sprite.contentSize.width/1.8f, kHeightScreen/2)];
                [[self getChildByTag:kBatchNode] addChild:sprite z:2 tag:kShareButton];
                break;
            case 2:
                sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"ipad_lvl%i.jpg",levelNr]]; sprite.scale = IS_IPAD ? 0.96f : 0.94f; sprite.anchorPoint = ccp(0.5f, 0);
                sprite.position = ccp([[self getChildByTag:kBatchNode] getChildByTag:kShareButton].position.x, [[self getChildByTag:kBatchNode] getChildByTag:kShareButton].position.y - [[self getChildByTag:kBatchNode] getChildByTag:kShareButton].contentSize.height/2.21f);
                [[self getChildByTag:kLevelsBatchNode] addChild:sprite z:2 tag:kShareButtonImage];
                break;
            case 3:
                sprite = [CCSprite spriteWithSpriteFrameName:@"unlock_btn_close.png"];
                sprite.anchorPoint = ccp(0.5f, 0.5f);
                sprite.position = [self convertToNodeSpace:ccp(kWidthScreen - sprite.contentSize.width*2, kHeightScreen - sprite.contentSize.height*2)];
                [[self getChildByTag:kBatchNode] addChild:sprite z:2 tag:kCloseButton];
                [cfg clickEffectForButton:sprite duration:0.1f];
                break;
            default:break;
        }
        [SCombinations opacityEffectToSprite:sprite from:0 to:255 timeDuration:0.3f];
    }

    for (int i = 0; i<2; i++) {
        NSString *string;
        CGPoint pos_;
    
        switch (i) {
            case 0:string = @"ONE FREE LEVEL";pos_ = ccp([[self getChildByTag:kBatchNode] getChildByTag:kShareButton].position.x,[[self getChildByTag:kBatchNode] getChildByTag:kShareButton].position.y + [[self getChildByTag:kBatchNode] getChildByTag:kShareButton].contentSize.height/1.6f);break;
                
//            case 1:string = @"OR";pos_ = ccp(kWidthScreen/2,[[self getChildByTag:kBatchNode] getChildByTag:kBuyButton].position.y + [[self getChildByTag:kBatchNode] getChildByTag:kBuyButton].contentSize.height/1.6f);break;
                
            case 1:string = @"PREMIUM LEVELS";pos_ = ccp([[self getChildByTag:kBatchNode] getChildByTag:kBuyButton].position.x,[[self getChildByTag:kBatchNode] getChildByTag:kBuyButton].position.y + [[self getChildByTag:kBatchNode] getChildByTag:kBuyButton].contentSize.height/1.6f);
                break;
                
            default:break;
        }
        CCLabelTTF *label = [CCLabelTTF labelWithString:string dimensions:contentSize_ alignment:UITextAlignmentCenter fontName:@"StartlingFont" fontSize:IS_IPAD ? 40 : 20];
        label.position = pos_;
        [SCombinations opacityEffectToSprite:label from:0 to:255 timeDuration:0.3f];
        label.color = COL_YELLOW_DARK;
        [self addChild:label z:10 tag:kLabelTag+i];
    }
    
    for (int i = 0; i<=3; i++) {
        CCSprite *sprite;
        switch (i) {
            case 0:sprite = [CCSprite spriteWithSpriteFrameName:@"unlock_btn_buy.png"];sprite.position = ccp([[self getChildByTag:kBatchNode] getChildByTag:kBuyButton].position.x, [[self getChildByTag:kBatchNode] getChildByTag:kBuyButton].position.y - [[self getChildByTag:kBatchNode] getChildByTag:kBuyButton].contentSize.height/2.f - sprite.contentSize.height/1.6f);
                break;
            case 1:sprite = [CCSprite spriteWithSpriteFrameName:@"unlock_btn_facebook.png"];sprite.position = ccp([[self getChildByTag:kBatchNode] getChildByTag:kShareButton].position.x - [[self getChildByTag:kBatchNode] getChildByTag:kShareButton].contentSize.width/3.9f, [[self getChildByTag:kBatchNode] getChildByTag:kShareButton].position.y - [[self getChildByTag:kBatchNode] getChildByTag:kShareButton].contentSize.height/2.f - sprite.contentSize.height/1.6f);
                break;
            case 2:
                sprite = [CCSprite spriteWithSpriteFrameName:@"unlock_btn_twitter.png"];sprite.position = ccp([[self getChildByTag:kBatchNode] getChildByTag:kShareButton].position.x + [[self getChildByTag:kBatchNode] getChildByTag:kShareButton].contentSize.width/3.9f, [[self getChildByTag:kBatchNode] getChildByTag:kShareButton].position.y - [[self getChildByTag:kBatchNode] getChildByTag:kShareButton].contentSize.height/2.f - sprite.contentSize.height/1.6f);
                break;
            case 3:
                sprite = [CCSprite spriteWithSpriteFrameName:@"btn_restore.png"];sprite.position = [self convertToNodeSpace:ccp(kWidthScreen/2, kHeightScreen/8)];
                break;
            default:break;
        }
        sprite.anchorPoint = ccp(0.5f, 0.5f);
        [SCombinations opacityEffectToSprite:sprite from:0 to:255 timeDuration:0.3f];
        [[self getChildByTag:kBatchNode] addChild:sprite z:20 tag:kBuySprite+i];
    }

}

-(void)addBG{
    
    [self scrollDisable:YES];
    [self createBatchNode];
    
    CCSprite *blackBoard = [[[CCSprite alloc]init]autorelease];
    [blackBoard setTextureRect:CGRectMake(0, 0, kWidthScreen,
                                          kHeightScreen)];
    
    [self addChild:blackBoard z:0 tag:kBg];
    blackBoard.anchorPoint = ccp(0.5f, 0.5f);
    blackBoard.position = [self convertToNodeSpace:ccp(kWidthScreen/2, kHeightScreen/2)];
    
    blackBoard.color = ccBLACK;
    
    [SCombinations opacityEffectToSprite:blackBoard from:0 to:220 timeDuration:0.3f];
    
}

-(void)createBatchNode
{
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    CCSpriteBatchNode *spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"PopUp%@.pvr.ccz",kDevice]];
    [self addChild:spriteBatchNode z:1 tag:kBatchNode];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"PopUp%@.plist",kDevice]];
}

-(void) removeAll
{
    [self scrollDisable:NO];
    [self removeFromParentAndCleanup:YES];
    
    //NSLog(@"BOOL : %i", [[CCDirector sharedDirector] openGLView].userInteractionEnabled);
}

-(void)scrollDisable:(BOOL)bool_
{
    if ([parent_ isKindOfClass:[MainMenu class]])
    {
        [parent_ performSelector:@selector(scrollDisable:) withObject:(BOOL)bool_];
    }
}

-(void)smoothRemove
{
    popUpIsShowing = NO;
    
    [self runAction:[CCSequence actions:
                     [CCCallBlock actionWithBlock:^{
        
        for (CCNode *s in [self getChildByTag:kBatchNode].children) {
            [SCombinations opacityEffectToSprite:(CCSprite*)s from:255 to:0 timeDuration:0.3f];
        }
        for (CCNode *s in [self getChildByTag:kLevelsBatchNode].children) {
            [SCombinations opacityEffectToSprite:(CCSprite*)s from:255 to:0 timeDuration:0.3f];
        }
        for (int i = 0;i<3; i++) {
            [[self getChildByTag:kLabelTag+i] runAction:[CCFadeTo actionWithDuration:0.3f opacity:0]];
        }
        
    }],[CCDelayTime actionWithDuration:0.3f],[CCCallBlock actionWithBlock:^{
        [self removeAll];
    }], nil]];
}


-(void)addPopUpWithType:(popUpType)type_ level:(int)level_
{
    if (popUpIsShowing) {
        return;
    }
    [self addBG];
    levelNr = level_;
    b_isShared = [Combinations checkNSDEFAULTS_Bool_ForKey:C_GAME_SHARED];
    switch (type_) {
        case levelUnlock:
            if (b_isShared) {[self onlyBuyPopUp];}else{[self levelUnlockPopUp];}break;
        case infoPopUp:[self infoPopUp];b_infoPopUp = TRUE; break;
        default:break;
    }
    popUpIsShowing = YES;
}

-(void)removePopUpWithType:(popUpType)type_
{
    /*
    [self smoothRemove];
    
    switch (type_) {
        case levelUnlock:break;
        case infoPopUp:break;
        default:break;
    }
     */
}

@end
