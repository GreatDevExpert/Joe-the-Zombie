//
//  BlockField.m
//  Zombie Joe
//
//  Created by macbook on 2013-05-08.
//
//

#import "BlockField.h"
#import "cocos2d.h"
#import "cfg.h"
#import "Constants.h"

#define kBoxTag 100

@implementation BlockField

-(void)onEnter //---cia leidzia naudoti touch komandas. onEnter nereikia niekur kviest, jisai pats pirmas pasileidzia pagal prioriteta netgi jo neisrasiu i init
{
    
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-5 swallowsTouches:YES];
    
    [super onEnter];
}

- (void)onExit
{
    
    [self removeAllChildrenWithCleanup:YES];
    
    [[CCTouchDispatcher sharedDispatcher]removeDelegate:self];
    
    //    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    //
    //    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    [super onExit];
    
}

-(id)initWithRect:(CGRect)rect{
    
    if((self = [super init]))
    {

        self.anchorPoint = ccp(0.5f,0.5f);
        
        self.contentSize = CGSizeMake(rect.size.width,
                                      rect.size.height);
        
        self.position = ccp(rect.origin.x, rect.origin.y);
    //    [cfg addTEMPBGCOLOR:self anchor:ccp(0.5f, 0.5f) color:ccBLUE];
        
        [self addButtons];
        
    }
    return self;
}

-(void)addCrystals{
    
    
    
}

-(void)addButtons{
    
    buttonW = self.contentSize.width/11;
    
    int posx = 0;
    int posy = 0;
    
    int diamonds = 1;
    
    for (int x = 0; x < 40; x++)
    {
        if (x==5 || x == 15 || x == 25 || x == 35) {
            posx++;
        }
        
        if (x==10 || x == 20 || x == 30) {
            posy++;
        }
        
        CCSprite *blackBoard = [[[CCSprite alloc]init]autorelease];
        
        [blackBoard setTextureRect:CGRectMake(0, 0, buttonW,buttonW)];
        blackBoard.position = ccp(posx*buttonW+(buttonW/2)-(posy*(buttonW*11)), (posy*buttonW)+(buttonW/2));
        blackBoard.anchorPoint = ccp(0.5f, 0.5f);
        [self addChild:blackBoard z:0 tag:5];
        blackBoard.color = ccBLACK;
        blackBoard.opacity = 50;
        blackBoard.scale = 0.9f;
        blackBoard.tag = kBoxTag+x;
        
        posx++;
        
        if (x==1 || x == 15 || x == 26 || x==33) {
            CCSprite *sprite = [CCSprite spriteWithFile:@"diamond.png"];
            sprite.position = blackBoard.position;
            [self addChild:sprite];
            sprite.tag = diamonds;
            sprite.scale = 0.875;
            
            diamonds++;
        }
        
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

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    NSSet *allTouches = [event allTouches];
    for (UITouch *aTouch in allTouches) {
        
        if ( ![self containsTouchLocation:aTouch] ) return NO;
    }
  //  NSLog(@"there is a touch in blocks");
    
    //CGPoint location = [touch locationInView:[touch view]];
     CGPoint location = [self convertTouchToNodeSpace:touch];
    
  //  location = [[CCDirector sharedDirector] convertToGL:location];
    

    
    diamondCaughtTag =[self getSpriteTag:location];
    
    if (diamondCaughtTag >=1 && diamondCaughtTag <=4) {
      //  NSLog(@"caught sprite %i",diamondCaughtTag);
        whereTouch=ccpSub([self getChildByTag:diamondCaughtTag].position, location);
        return YES;
    }
    
    /*
    for (int x = kBoxTag; x < kBoxTag+40  ; x++)
    {
        
        if (CGRectContainsPoint( [[self getChildByTag:x] boundingBox], location))
        {
            NSLog(@"touched block %i",x);
            
        }
    }
     */
    
    
    return NO;
    
}

-(void)recheckLimmits{
    
    //x
    if ([self getChildByTag:diamondCaughtTag].position.x <= [self getChildByTag:diamondCaughtTag].boundingBox.size.width/2) {
        [self getChildByTag:diamondCaughtTag].position =
        ccp([self getChildByTag:diamondCaughtTag].boundingBox.size.width/2, [self getChildByTag:diamondCaughtTag].position.y);
    }
    if ([self getChildByTag:diamondCaughtTag].position.x > self.contentSize.width-([self getChildByTag:diamondCaughtTag].boundingBox.size.width/2)) {
        [self getChildByTag:diamondCaughtTag].position =
        ccp(self.contentSize.width-([self getChildByTag:diamondCaughtTag].boundingBox.size.width/2), [self getChildByTag:diamondCaughtTag].position.y);
    }
    //y
    if ([self getChildByTag:diamondCaughtTag].position.y <= [self getChildByTag:diamondCaughtTag].boundingBox.size.width/2) {
        [self getChildByTag:diamondCaughtTag].position =
        ccp([self getChildByTag:diamondCaughtTag].position.x,[self getChildByTag:diamondCaughtTag].boundingBox.size.width/2);
    }
    if ([self getChildByTag:diamondCaughtTag].position.y >= self.contentSize.height-([self getChildByTag:diamondCaughtTag].boundingBox.size.height/2)) {
        [self getChildByTag:diamondCaughtTag].position =
        ccp([self getChildByTag:diamondCaughtTag].position.x,self.contentSize.height - [self getChildByTag:diamondCaughtTag].boundingBox.size.height/2);
    }
    
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
    CGPoint location = [self convertTouchToNodeSpace:touch];
    
    [self getChildByTag:diamondCaughtTag].position=ccpAdd(location,whereTouch);
    
    //check xy
    [self recheckLimmits];
    
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
    CGPoint location = [self convertTouchToNodeSpace:touch];
    
    [self recheckLimmits];
    
    for (int x = kBoxTag; x < kBoxTag+40; x++)
    {
        if (CGRectContainsPoint([self getChildByTag:x].boundingBox, [self getChildByTag:diamondCaughtTag].position))
        {
            [self getChildByTag:diamondCaughtTag].position = [self getChildByTag:x].position;
        }
    }

    
    diamondCaughtTag = 0;   //reset the diamonds tag
    
}




-(int)getSpriteTag:(CGPoint)location{
    
    for (int x = 1; x < 5; x++){
        
        if (CGRectContainsPoint([self getItemRect:x], location))
            
            return x;
        
    }
    
    return 0;
    
}

-(CGRect)getItemRect:(int)x{
    
    float rectOffsetW = [[self getChildByTag:x]boundingBox].size.width;
    float rectOffsetH = [[self getChildByTag:x]boundingBox].size.height;
    
    CGRect itemBoundingBox = [[self getChildByTag:x] boundingBox];
    
    CGRect itemRect = CGRectMake(itemBoundingBox.origin.x-rectOffsetW/2, itemBoundingBox.origin.y-rectOffsetH/2,
                                 itemBoundingBox.size.width+rectOffsetW, itemBoundingBox.size.height+rectOffsetH);
    
    return itemRect;
}






@end
