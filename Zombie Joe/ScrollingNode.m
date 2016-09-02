//
//  ScrollingNode.m
//  Cocos2dScrolling
//
//  Created by Tony Ngo on 11/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScrollingNode.h"
#import "ScrollingNodeOverlay.h"
#import "cfg.h" 
#import "Constants.h"
#import "LevelButton.h"
#import "SimpleAudioEngine.h"

@implementation ScrollingNode

@synthesize scrollView=scrollView_;

@synthesize admin;
@synthesize LEVELS_NR;

#pragma mark - UIScrollViewDelegate

//-(void) scrollViewWillBeginDragging:(UIScrollView *) scrollView
//{
//    timer_ = [NSTimer scheduledTimerWithTimeInterval:1/60.0f
//                                              target: self
//                                            selector: @selector(refreshDirector)
//                                            userInfo: nil
//                                             repeats: YES];
//    
//    [[NSRunLoop mainRunLoop] addTimer: timer_ forMode: NSRunLoopCommonModes];
//}
//
//-(void) scrollViewDidEndDragging:(UIScrollView *) scrollView willDecelerate:(BOOL) decelerate
//{
//    [timer_ invalidate];
//}
//
//-(void) refreshDirector
//{
//    [[CCDirector sharedDirector] drawScene];
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // NSLog(@"scroll did scroll");
    CGPoint contentOffset = [scrollView contentOffset];
    [self setPosition:contentOffset];
    
    if (![delegater minimized])
    {
        [[CCDirector sharedDirector] drawScene];
    }
}

-(void)didSCROLLSCHEDULE{
  //  NSLog(@"did schedule. offset :%f",scrollView_.contentOffset.y);

    CGPoint contentOffset = scrollView_.contentOffset;
    self.position = contentOffset;
    
    if (![delegater minimized])
    {
            [[CCDirector sharedDirector] drawScene];
    }
    
}

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if(self) {
        CGRect frame = [[[CCDirector sharedDirector] openGLView] frame];
        scrollView_ = [[[ScrollingNodeOverlay alloc] initWithFrame:frame] retain];
        scrollView_.delegate = self;
        scrollView_.multipleTouchEnabled = NO;
        
        [[[CCDirector sharedDirector] openGLView] addSubview:scrollView_];
        
        /*
        timer_ = [NSTimer scheduledTimerWithTimeInterval:(IS_IPAD) ? 1/60.f : 1/60.f target:self
                                                selector:@selector(didSCROLLSCHEDULE) userInfo:nil repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:timer_ forMode:NSRunLoopCommonModes];
        */
         
        canTouch = YES;
        
    }
    return self;
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

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
     CGPoint location = [touch locationInView:[touch view]];

    int levelsnr = LEVELS_NR;
    if (levelsnr <= 0 || !levelsnr)
    {
        levelsnr     = 16;
    }
    
    location = ccp(location.x,
                   -(location.y-[self getChildByTag:1].position.y-([self getChildByTag:1].boundingBox.size.height/2)));
    
    for (int x = 1; x <= LEVELS_NR  ; x++) //LEVEL NUMBEr MAX
    {
        if(CGRectContainsPoint([self getChildByTag:x].boundingBox, location))
        {
            
         LevelButton *lev =   (LevelButton*)[self getChildByTag:x];
         canTouch = NO;
      
            if (x == 16)
            {
                // *** Comming soon popup
                  [cfg runSelectorTarget:self selector:@selector(enableTouch) object:nil afterDelay:0.2f sender:self];
                return;
            }
            
            [cfg clickEffectForButton:lev];
        
            [AUDIO playEffect:fx_buttonclick];
            
            BOOL unlocked = [Combinations checkNSDEFAULTS_Bool_ForKey:C_UNLOCK_LEVEL(x)];
            
         //   NSLog(@"Level button unlock state %i",unlocked);
            
            /*
            if ([Combinations checkNSDEFAULTS_Bool_ForKey:C_PURCHASE_DONE] && !unlocked)
            {
                [cfg runSelectorTarget:self selector:@selector(enableTouch) object:nil afterDelay:0.2f sender:self];
                NSLog(@"purchase was done but you must finish previous to open level");
                return;
            }
            */
            
            if (!unlocked && LOCK_LEVELS)
            {
                [cfg runSelectorTarget:self selector:@selector(enableTouch) object:nil afterDelay:0.2f sender:self];
                //NSLog(@"Could not load level - Level is locked");
                [self.admin performSelector:@selector(openLockedLevelPopup:) withObject:[NSNumber numberWithInt:x]];
                return;
            }
            
            // If level is available -> open it
            
            
            canTouch = NO;
      
            
            [cfg runSelectorTarget:self.admin selector:@selector(goToGameLevel:) object:[NSNumber numberWithInt:x] afterDelay:0.2f sender:self];

            break;
//            [self.admin performSelector:@selector(goToGameLevel:) withObject:[NSNumber numberWithInt:x]afterDelay:0.2f];

        }
    }
    
}

-(void)enableTouch{
    
    canTouch = YES;
    
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    if (!canTouch) {
        return NO;
    }

    //CGPoint location = [touch locationInView:[touch view]];
    //NSLog(@"touch begin");
    
    if (![[touch view] isKindOfClass:[UIScrollView class]]) {
      // NSLog(@"touched NOT scroll view");
        return NO;
    }
    
    

    return YES;
    
}


-(void)createBatchNode{
    
     [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
    
    NSString *spritesStr =      [NSString stringWithFormat:@"MenuLevels_iPhone"];
    if (IS_IPAD) spritesStr =   [NSString stringWithFormat:@"MenuLevels"];
    
    spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz",spritesStr]];
    [self addChild:spritesBgNode];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache]
     addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist",spritesStr]];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
}

- (void)onEnter
{
    [super onEnter];
    
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-20 swallowsTouches:YES];
    
}

- (void)onExit
{
    //[[SimpleAudioEngine sharedEngine]unloadEffect:@"button_click.mp3"];
    [self removeAllChildrenWithCleanup:YES];
    
    if (timer_!=nil) {
        [timer_ invalidate];
        timer_=nil;
    }
    
    [[CCTouchDispatcher sharedDispatcher]removeDelegate:self];
    
    scrollView_.delegate = nil;
    
    [scrollView_ removeFromSuperview];
    
    [super onExit];
    
}

- (void)dealloc
{
 //   NSLog(@"dealloc scrollnode");
    
    [scrollView_ release];
    scrollView_ = nil;
    
    [admin release];
    admin = nil;
   // admin=nil;
    
    
    
    if (timer_!=nil) {
        [timer_ invalidate];
        timer_=nil;
    }
    [super dealloc];

}

@end
