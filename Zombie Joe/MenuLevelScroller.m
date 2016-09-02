//
//  MenuLevelScroller.m
//  Zombie Joe
//
//  Created by Mac4user on 4/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MenuLevelScroller.h"
#import "cfg.h"
#import "SceneManager.h"
#import "ScrollingNode.h"
#import "LevelButton.h"

//#import "Loading.h"

@implementation MenuLevelScroller
@synthesize admin;

-(id)initWithRect:(CGRect)rect{
    
    if((self = [super init]))
    {
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);

        self.anchorPoint = ccp(0,0);
        self.contentSize = CGSizeMake(rect.size.width,
                                      rect.size.height);
        
        self.position = ccp(rect.origin.x, rect.origin.y);
        
        //****** NR OF LEVELS SET HERE****////
        LEVELNUMBER = 16;
        
        [self createScrollingNode]; // LEAK
        [self addLevelsButtons];
 
    }
    return self;
}

-(void)purchaseWasDone_RefreshButtons{
    
    for (LevelButton *b in [scrollingNode children]) {
        //NSLog(@"b ---- > %@",b);
        if ([b isKindOfClass:[LevelButton class]]) {
            if (b.tag == 16) {
                continue;
            }
            [b refreshLevelStatusWindow];
        }
    }
    
}

-(void)disableScroll:(BOOL)bool_
{
    scrollView.scrollEnabled = !bool_;scrollView.userInteractionEnabled = !bool_;
}

-(int)nrOfLevels{
    
    return LEVELNUMBER;
    
}

-(void)addLevelsButtons{
    
    //need to change format here
    
     [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
    
    NSString *spritesStr =      [NSString stringWithFormat:@"MenuLevels_iPhone"];
    if (IS_IPAD) spritesStr =   [NSString stringWithFormat:@"MenuLevels"];
    
    CCSpriteBatchNode *spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz",spritesStr]];
    [scrollingNode addChild:spritesBgNode z:5 tag:990];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache]
     addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist",spritesStr]];
    
     [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    
    int row = 0;
    
    int nrOfRows = LEVELNUMBER;//15;  //levels nr
    int h_ = 0;
    
    
    
  // CCSpriteBatchNode *batch =  (CCSpriteBatchNode*)[scrollingNode getChildByTag:990];
    
    for (int x = 1; x <= nrOfRows; x ++) {
        
      //  CCSprite *level = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"ipad_lvl%i.jpg",x]];
      //  NSLog(@"level to pass %i",x);
        LevelButton *level = [[[LevelButton alloc]
                               initWith_tag:x
                               frameName:[NSString stringWithFormat:@"ipad_lvl%i.jpg",x]]autorelease];
        
            float h = level.boundingBox.size.height*1.075f;
            h_ = h;
            float posY;
            if (x == 1 || x == 2) {
                posY = 0;
            }
            else{
                posY = h * row;
            }
            float posX = ![self isNumberEven:x] ? level.boundingBox.size.width/2
                         : self.contentSize.width/2+(level.boundingBox.size.width/2);
        
        level.anchorPoint = ccp(0.5f, 0.5f);
        level.position = ccp(posX,
                             self.contentSize.height
                             -(level.boundingBox.size.height/2)-(posY));
        level.tag = x;
        [scrollingNode addChild:level];
        
        level.scale = 0.95f;

        if ([self isNumberEven:x])
        {
            row++;
        }
        
    }
    
    //    CCNode *lastNode = [scrollingNode.children lastObject];
    //  CGSize contentSize = CGSizeMake(lastNode.contentSize.width,
    //                                winSize.height - lastNode.position.y + lastNode.contentSize.height);
    
   // NSLog(@"h : %i",h_);
    
    //***** SCROLL VIEW CONTENT SIZE
    CGSize contentSize = CGSizeMake(self.contentSize.width,((nrOfRows*h_)/2));    //(nrOfRows*h_)/2);
    
    scrollingNode.scrollView.contentSize = contentSize;
    
}

-(void)createScrollingNode{
    
   scrollingNode = [ScrollingNode node];
   scrollView = scrollingNode.scrollView;
   scrollView.showsVerticalScrollIndicator = NO;
   scrollView.bounces = YES;
   // scrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
   

  //  scrollView.backgroundColor   = [UIColor greenColor];
    
    float x = (kMenuLevelScrollerWindowX)*2;
    
    if (IS_IPHONE) {
        if (IS_IPHONE_5) {
            x = (kMenuLevelScrollerWindowX)*2;
        }
        else x = (kMenuLevelScrollerWindowX)*2;
    }
    
//    if (![Combinations isRetina]) {
//        x = x/2;
//    }
    
    scrollView.frame=  CGRectMake(x,
                                  kHeightScreen-(kMenuLevelScrollerWindowH),
                                  kMenuLevelScrollerWindowW,
                                  kMenuLevelScrollerWindowH);
    
    [self addChild:scrollingNode];
    
    scrollingNode.admin=self;
    scrollingNode.LEVELS_NR = LEVELNUMBER;
    
}

-(BOOL)isNumberEven:(int)num{
    
    if (num % 2){
        //    NSLog(@"odd-nelyginis");
        return NO;
    }
    else{
        //  NSLog(@"even-lyginis");
        return YES;
    }
    return NO;
}

-(void)openLockedLevelPopup:(NSNumber*)lev_{
    
    [self.admin performSelector:@selector(popUpButShare:) withObject:lev_];
    
}

-(void)goToGameLevel:(NSNumber*)lev{

    [self.admin performSelector:@selector(addLoadImageWithName:) withObject:lev];
    
}

-(void)addTEMPBGCOLOR{
    
    [cfg addTEMPBGCOLOR:self anchor:ccp(0, 0) color:ccGRAY];

}

- (void)onEnter
{
    [super onEnter];

}

- (void)onExit
{
    
    [self removeAllChildrenWithCleanup:YES];

//    if (scrollingNode) {
//        [scrollingNode release];
//        scrollingNode = nil;
//    }
    
//    if (scrollView) {
//        [scrollView release];
//        scrollView = nil;
//    }
    
    [super onExit];
    
}

- (void) dealloc
{
    [admin release];
    admin = nil;
    
    /*
    if (scrollingNode) {
        [scrollingNode release];
        scrollingNode = nil;
    }
    
    if (scrollView) {
        [scrollView release];
        scrollView = nil;
    }
     */
    
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
