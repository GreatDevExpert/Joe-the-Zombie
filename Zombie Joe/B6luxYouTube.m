//
//  B6luxYouTube.m
//  Zombie Joe
//
//  Created by Slavian on 2013-07-24.
//
//

#import "B6luxYouTube.h"
#import "cfg.h"
#import "SConfig.h"
#import "MainMenu.h"
#import <QuartzCore/QuartzCore.h>
#import "b6luxLoadingView.h"
#import <MediaPlayer/MediaPlayer.h>

#define kSkipButton 99
#define kBg 100

@implementation B6luxYouTube

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([[[CCDirector sharedDirector] openGLView]viewWithTag:kLOADINGTAG]) {
        [[[[CCDirector sharedDirector] openGLView]viewWithTag:kLOADINGTAG]removeFromSuperview];
    }
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([[[CCDirector sharedDirector] openGLView]viewWithTag:kLOADINGTAG]) {
        [[[[CCDirector sharedDirector] openGLView]viewWithTag:kLOADINGTAG]removeFromSuperview];
    }
}


-(void)playVideoFromURL:(NSString *)url_
{
    [self scrollDisable:YES];
    [self addBG];
    
    [cfg runSelectorTarget:self selector:@selector(addButtonSkip) object:nil afterDelay:2 sender:self];
    
    [AUDIO setMute:YES];
   
    CGRect webFrame = CGRectMake(0, 0, kWidthScreen/1.5f, kHeightScreen/1.5f);
    webView = [[[UIWebView alloc] initWithFrame:webFrame] autorelease];
    webView.center = [self convertToNodeSpace:ccp(kWidthScreen/2, kHeightScreen+webView.frame.size.height)];
    webView.delegate = self;
    webView.backgroundColor = [UIColor blackColor];
    [webView setOpaque:NO];
    webView.scrollView.scrollEnabled = NO;
    webView.scrollView.bounces = NO;
    webView.scrollView.layer.cornerRadius = 15;
    webView.layer.cornerRadius = 15;
    
    NSString *html = [NSString stringWithFormat:@"\
                      <html>\
                      <head>\
                      <style type=\"text/css\">\
                      iframe {position:absolute; top:27%%; margin-top:%i;}\
                      body {background-color:#000; margin:0;}\
                      </style>\
                      </head>\
                      <body>\
                      <iframe width=\"100%%\" height=\"100%%\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe>\
                      </body>\
                      </html>",IS_IPAD ? -130 : -55, url_];
    
    [webView loadHTMLString:html baseURL:nil];
    
    //webView.tag = 666999;
    
    [[[CCDirector sharedDirector] openGLView] addSubview:webView];
    
    [UIView animateWithDuration:0.5f animations:^{
        webView.center = [self convertToNodeSpace:ccp(kWidthScreen/2, kHeightScreen/2)];
    }];
     
    
    [self addObservers];
    
}

-(void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youTubeStarted:) name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youTubeFinished:) name:@"UIMoviePlayerControllerDidExitFullscreenNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemEnded:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemFailed:) name:AVPlayerItemFailedToPlayToEndTimeErrorKey object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemFailed:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
    

}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint location = [self convertTouchToNodeSpace:touch];
 
    if (CGRectContainsPoint([[self getChildByTag:kSkipButton] boundingBox], location))
    {
        [AUDIO playEffect:fx_buttonclick];
        [cfg clickEffectForButton:[self getChildByTag:kSkipButton]];
        [[self getChildByTag:kSkipButton] runAction:[CCFadeTo actionWithDuration:0.2f opacity:0]];
        
        [self smoothRemove];
        
        return YES;
    }
    return YES;
}

-(void)smoothRemove
{
    if ([[[CCDirector sharedDirector] openGLView]viewWithTag:kLOADINGTAG]) {
        [[[[CCDirector sharedDirector] openGLView]viewWithTag:kLOADINGTAG]removeFromSuperview];
    }
    
    [self runAction:[CCSequence actions:
                     [CCCallBlock actionWithBlock:^{
        if (IS_IPHONE && playEnd) {
            [self runAction:[CCSequence actions:[CCCallBlock actionWithBlock:^{
                [UIView animateWithDuration:0.5f animations:^{
                    webView.center = [self convertToNodeSpace:ccp(kWidthScreen/2, kHeightScreen+webView.frame.size.height)];
                }];
            }],[CCDelayTime actionWithDuration:0.3f],[CCCallBlock actionWithBlock:^{
                [self removeAll];
                return;
            }], nil]];
        }
        
        [[self getChildByTag:kBg] runAction:[CCFadeTo actionWithDuration:0.5f opacity:0]];
            [UIView animateWithDuration:0.5f animations:^{
            webView.center = [self convertToNodeSpace:ccp(kWidthScreen/2, kHeightScreen+webView.frame.size.height)];
            }];
        
        }],[CCDelayTime actionWithDuration:0.5f],[CCCallBlock actionWithBlock:^{
        [self removeAll];
    }], nil]];
}

-(void)scrollDisable:(BOOL)bool_
{
    if ([parent_ isKindOfClass:[MainMenu class]]) {
        [parent_ performSelector:@selector(scrollDisable:) withObject:(BOOL)bool_];
    }
}

-(void) removeAll
{
    [self scrollDisable:NO];
    [AUDIO setMute:NO];
    [webView removeFromSuperview];
    webView = nil;
    [self removeFromParentAndCleanup:YES];

}
- (void)playerItemEnded:(NSNotification *)notification
{
    playEnd = YES;
    if(isFullScreen)
    {
        webView.alpha = 0;
    
    }
    
    if (IS_IPAD && !isFullScreen) {
        [self smoothRemove];
    }
    else if (IS_IPHONE)
    {
        [UIView animateWithDuration:0.5f animations:^{
            webView.center = [self convertToNodeSpace:ccp(kWidthScreen/2, kHeightScreen+webView.frame.size.height)];
        }];
    }
}

- (void)playerItemFailed:(NSNotification *)notification
{
    [self smoothRemove];
}


-(void)youTubeStarted:(NSNotification *)notification{
    isFullScreen = YES;
}

-(void)youTubeFinished:(NSNotification *)notification{
    isFullScreen = NO;
    if (playEnd) {
//        [UIView animateWithDuration:0.5f animations:^{
//            webView.center = [self convertToNodeSpace:ccp(kWidthScreen/2, kHeightScreen+webView.frame.size.height)];
//        }];
        [self smoothRemove];
    }
}

- (void) onEnter
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-30 swallowsTouches:YES];
    [super onEnter];
}

-(void) onExit
{
    [[CCTouchDispatcher sharedDispatcher]removeDelegate:self];

    //[[[[CCDirector sharedDirector] openGLView]viewWithTag:666999]removeFromSuperview];
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIMoviePlayerControllerDidExitFullscreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [super onExit];
}

-(void)addButtonSkip
{
    [[CCDirector sharedDirector] openGLView].userInteractionEnabled = YES;
    
    CCSprite *skipButton_ = [CCSprite spriteWithFile:[NSString stringWithFormat:@"btn_skipMovie%@.png",kDevice]];
    skipButton_.anchorPoint = ccp(0.5f, 0.5f);
    skipButton_.scale = IS_IPAD ? 0.5f : 0.75f;
    skipButton_.opacity = 0;
    skipButton_.position = [self convertToNodeSpace:ccp(kWidthScreen-skipButton_.boundingBox.size.width*0.7f,kHeightScreen - skipButton_.boundingBox.size.width*0.45f)];
    
    [self addChild:skipButton_ z:9999 tag:kSkipButton];
    [skipButton_ runAction:[CCFadeTo actionWithDuration:0.2f opacity:255]];
    [cfg clickEffectForButton:skipButton_ duration:0.2f];
}

-(void)addBG{
    
    CCSprite *blackBoard = [[[CCSprite alloc]init]autorelease];
    [blackBoard setTextureRect:CGRectMake(0, 0, kWidthScreen,
                                          kHeightScreen)];
    
    [self addChild:blackBoard z:0 tag:kBg];
    blackBoard.anchorPoint = ccp(0.5f, 0.5f);
    blackBoard.position = [self convertToNodeSpace:ccp(kWidthScreen/2, kHeightScreen/2)];
    
    blackBoard.color = ccBLACK;
    
    blackBoard.opacity = 0;
    [blackBoard runAction:[CCFadeTo actionWithDuration:0.5f opacity:IS_IPAD ? 150 : 180]];
    
}

- (void) dealloc
{
  //  NSLog(@"webview %@",webView);
    
//    if (webView) {
//          webView = nil;
//    }
//  
//   // [webView release];
	[super dealloc];
}

@end
