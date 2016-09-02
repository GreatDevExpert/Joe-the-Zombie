
#import "Tutorial.h"
#import "SCombinations.h"
#import "SConfig.h"
#import "cfg.h"
#import "Combinations.h"

#define kBatchNode 10
#define hand 1
#define tap 20
#define circle 21
#define loadingLine 2
#define rotateDevice 3
#define tiltDevice 30
#define baloon 50
#define explanation 51
#define alpha 255

#define TAG_ACTIVE1 1
#define TAG_ACTIVE2 2
#define TAG_ACTIVE3 3
#define TAG_ACTIVE4 4
#define TAG_ACTIVE5 5

@implementation Tutorial

-(BOOL)thereAreTutorialsRunning{
    
    BOOL running = NO;
    
    for (CCSprite *ch_ in [[self getChildByTag:kBatchNode] children]) {
        if      ([ch_ getActionByTag:TAG_ACTIVE1]) {
            running = YES;
            break;
        }
        else if ([ch_ getActionByTag:TAG_ACTIVE2]) {
            running = YES;
            break;
        }
        else if ([ch_ getActionByTag:TAG_ACTIVE3]) {
            running = YES;
            break;
        }
        else if ([ch_ getActionByTag:TAG_ACTIVE4]) {
            running = YES;
            break;
        }
        else if ([ch_ getActionByTag:TAG_ACTIVE5]) {
            running = YES;
            break;
        }
    }
    
    return  running;
}

-(int)whatTagIsLegal{
    
    for (CCSprite *ch_ in [[self getChildByTag:kBatchNode] children])
    {
        if (![ch_ getActionByTag:TAG_ACTIVE1]) {
            return TAG_ACTIVE1;
        }
        else if (![ch_ getActionByTag:TAG_ACTIVE2]) {
            return TAG_ACTIVE2;
        }
        else if (![ch_ getActionByTag:TAG_ACTIVE3]) {
            return TAG_ACTIVE3;
        }
        else if (![ch_ getActionByTag:TAG_ACTIVE4]) {
            return TAG_ACTIVE4;
        }
        else if (![ch_ getActionByTag:TAG_ACTIVE5]) {
            return TAG_ACTIVE5;
        }
    }
    

    return 0;
}

-(void)stopTutorials
{
    
    [[self getChildByTag:kBatchNode] stopAllActions];
    
    for (CCNode *ch in [self children]) {
        [ch stopAllActions];
        // ch.visible = NO;
        for (CCNode *c in [ch children]) {
            [c stopAllActions];
            // c.visible = NO;
            for (CCNode *c_ in [c children]) {
                [c_ stopAllActions];
                // c_.visible = NO;
            }
        }
    }

    [[self getChildByTag:kBatchNode] removeAllChildrenWithCleanup:YES];
    
   // [self stopAllActions];
    //self.visible = NO;
    
}

-(void)TAP_Special_For_8LVL
{
    self.visible = YES;
    
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"hand.png"];
    sprite.opacity = 0;
    sprite.scale = 1.3f;
    sprite.anchorPoint = ccp(0.25f, 0.9f);
    sprite.position = ccp(0, 0);
    [[self getChildByTag:kBatchNode]addChild:sprite z:2 tag:tap];
    
    CCSprite *sprite1 = [CCSprite spriteWithSpriteFrameName:@"point.png"];
    sprite1.opacity = 0;
    sprite1.scale = 0.1f;
    sprite1.anchorPoint = ccp(0.52f, 0.5f);
    sprite1.position = [self getChildByTag:tap].position;
    [[self getChildByTag:kBatchNode]addChild:sprite1 z:1 tag:circle];
    
    [sprite runAction:
     [CCSpawn actions:
         [CCFadeTo actionWithDuration:0.1f opacity:255],
         [CCScaleTo actionWithDuration:0.7 scale:1.0f], nil]
       ].tag = [self whatTagIsLegal];
    
    [sprite1 runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.5f],[CCSpawn actions:
                                            [CCScaleTo actionWithDuration:0.3f scale:0.8f],
                                            [CCFadeTo actionWithDuration:0.3f opacity:255], nil],
                        [CCSpawn actions:
                         [CCScaleTo actionWithDuration:0.1f scale:0.3f],
                         [CCFadeTo actionWithDuration:0.1f opacity:0], nil], nil]
     
        ].tag = [self whatTagIsLegal];
    
}

-(void)TAP_TutorialRepeat:(int)times_ delay:(float)delay_ runAfterDelay:(float)del_
{
     self.visible = YES;
    
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"hand.png"];
    sprite.opacity = 0;
    sprite.scale = 1.3f;
    sprite.anchorPoint = ccp(0.25f, 0.9f);
    sprite.position = ccp(0, 0);
    [[self getChildByTag:kBatchNode]addChild:sprite z:2 tag:tap];
    
    CCSprite *sprite1 = [CCSprite spriteWithSpriteFrameName:@"point.png"];
    sprite1.opacity = 0;
    sprite1.scale = 0.5f;
    sprite1.anchorPoint = ccp(0.52f, 0.5f);
    sprite1.position = [self getChildByTag:tap].position;
    [[self getChildByTag:kBatchNode]addChild:sprite1 z:1 tag:circle];
    
    [sprite runAction:
     [CCSequence actions:[CCDelayTime actionWithDuration:del_],
      [CCRepeat actionWithAction:
       [CCSequence actions:
        [CCSpawn actions:
         [CCFadeTo actionWithDuration:0.1f opacity:255],
         [CCScaleTo actionWithDuration:0.7 scale:1.0f], nil],
        [CCDelayTime actionWithDuration:0.4f],
        [CCFadeTo actionWithDuration:0.2f opacity:0],
        [CCScaleTo actionWithDuration:0 scale:1.3f],
        [CCDelayTime actionWithDuration:delay_], nil] times:times_], nil]].tag = [self whatTagIsLegal];
    
    [sprite1 runAction:
     [CCSequence actions:[CCDelayTime actionWithDuration:del_],
      [CCRepeat actionWithAction:
       [CCSequence actions:
        [CCDelayTime actionWithDuration:0.8f],
        [CCSpawn actions:[CCScaleTo actionWithDuration:0.1f scale:1.0f],
         [CCFadeTo actionWithDuration:0.1f opacity:255], nil],
        [CCDelayTime actionWithDuration:0.1f],
        [CCFadeTo actionWithDuration:0.2f opacity:0],
        [CCScaleTo actionWithDuration:0 scale:0.5f],
        [CCDelayTime actionWithDuration:0.1f],
        [CCDelayTime actionWithDuration:delay_], nil] times:times_], nil
     ]].tag = [self whatTagIsLegal];
    

}

-(void)SWIPE_TutorialWithDirection:(int)direction times:(int)times_ delay:(float)delay_ runAfterDelay:(float)del_
{
     self.visible = YES;
    
    CCProgressFromTo *to1 = [CCProgressFromTo actionWithDuration:1.5f from:0 to:100];
    CCProgressFromTo *to2 = [CCProgressFromTo actionWithDuration:0 from:100 to:0];
    CCProgressTimer *timeBar = [CCProgressTimer progressWithFile:[NSString stringWithFormat:@"arrow%@.png",kDevice]];
    timeBar.type = kCCProgressTimerTypeHorizontalBarLR;
    timeBar.anchorPoint = ccp(0, 0.5f);
    timeBar.position = ccp(-timeBar.contentSize.width/2,0);
    [self addChild:timeBar z:1 tag:loadingLine];
    
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"hand.png"];
    sprite.opacity = 0;
    sprite.anchorPoint = ccp(0.25f, 0.9f);
    sprite.position = [self getChildByTag:loadingLine].position;
    [[self getChildByTag:kBatchNode]addChild:sprite z:2 tag:hand];
    
    switch (direction) {
        case SWIPE_UP:self.rotation = 270;break;
        case SWIPE_DOWN:self.rotation = 90;sprite.flipY = YES;sprite.flipX = YES;sprite.anchorPoint = ccp(0.75f, 0.1f);break;
        case SWIPE_LEFT:self.rotation = 0;break;
        case SWIPE_RIGHT:self.rotation = 180;sprite.flipY = YES;sprite.flipX = YES;sprite.anchorPoint = ccp(0.75f, 0.1f); break;
        default:break;
    }
 
    [sprite runAction:
     [CCSequence actions:[CCDelayTime actionWithDuration:del_],[CCRepeat actionWithAction:
                          [CCSequence actions:
                           [CCFadeTo actionWithDuration:0.1f opacity:255],
                           [CCSpawn actions:
                            [CCEaseInOut actionWithAction:
                             [CCMoveBy actionWithDuration:1.7f position:ccp([self getChildByTag:loadingLine].contentSize.width+[self getChildByTag:loadingLine].contentSize.width/5, 0)] rate:3],
                            [CCSequence actions:
                             [CCDelayTime actionWithDuration:1.5f],
                             [CCFadeTo actionWithDuration:0 opacity:0], nil], nil],
                           [CCMoveTo actionWithDuration:0 position:[self getChildByTag:loadingLine].position],[CCDelayTime actionWithDuration:delay_], nil] times:times_], nil]
      ].tag = [self whatTagIsLegal];
    
    [(CCSprite*)timeBar runAction:[CCSequence actions:[CCDelayTime actionWithDuration:del_],[CCRepeat actionWithAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.1f],[CCEaseInOut actionWithAction:to1 rate:3],to2,[CCDelayTime actionWithDuration:delay_+0.2f], nil] times:times_], nil]].tag = [self whatTagIsLegal];
}

-(void)TILT_TrutorialRepaet:(int)times_ runAfterDelay:(float)del_ quadro:(BOOL)bool__
{
     self.visible = YES;
    
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:del_],[CCRepeat actionWithAction:[CCSequence actions:[CCCallBlock actionWithBlock:^{
        int n = bool__ ? 8 : 4;
        for (int i = 0; i <= n; i++) {
            NSString *format;
            
            switch (i) {
                case 0:format = @"device_tilt2.png";break;
                case 1:format = @"device_tilt0.png";break;
                case 2:format = @"device_tilt2.png";break;
                case 3:format = @"device_tilt1.png";break;
                case 4:format = @"device_tilt2.png";break;
                case 5:format = @"device_tilt3.png";break;
                case 6:format = @"device_tilt2.png";break;
                case 7:format = @"device_tilt4.png";break;
                case 8:format = @"device_tilt2.png";break;
                default:break;
            }
            
            CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:format];
            
            sprite.anchorPoint = ccp(0.5f, 0.5f);
            sprite.opacity = 0;
            sprite.position = ccp(0, 0);
            [[self getChildByTag:kBatchNode]addChild:sprite z:1 tag:tiltDevice+i];
            
            [sprite runAction:
             [CCSequence actions:
              [CCDelayTime actionWithDuration:i/1.5f],
              [CCFadeTo actionWithDuration:0 opacity:255],
              [CCDelayTime actionWithDuration:0.7f],
              [CCFadeTo actionWithDuration:0 opacity:0], nil]];
        }
        
    }],[CCDelayTime actionWithDuration:4], nil] times:times_], nil]].tag = [self whatTagIsLegal];
}

-(void)ROTATE_TutorialRepeat:(int)times_ delay:(float)delay_ runAfterDelay:(float)del_
{
     self.visible = YES;
    
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"device_rotate.png"];
    sprite.position = ccp(0, 0);
    sprite.opacity = 0;
    sprite.anchorPoint = ccp(0.5f, 0.5f);
    
    [[self getChildByTag:kBatchNode]addChild:sprite z:1 tag:rotateDevice];
    
    [sprite runAction:
     [CCSequence actions:[CCDelayTime actionWithDuration:del_],[CCRepeat actionWithAction:
                          [CCSequence actions:
                           [CCFadeTo actionWithDuration:0.15f opacity:255],
                           [CCEaseInOut actionWithAction:
                            [CCRotateBy actionWithDuration:0.5f angle:-30] rate:2],
                           [CCEaseInOut actionWithAction:
                            [CCRotateBy actionWithDuration:0.8f angle:60] rate:2],
                           [CCEaseInOut actionWithAction:
                            [CCRotateBy actionWithDuration:0.5f angle:-30] rate:2],
                           [CCFadeTo actionWithDuration:0.15f opacity:0],
                           [CCDelayTime actionWithDuration:delay_], nil] times:times_], nil]
     ].tag = [self whatTagIsLegal];
}



-(void)createBaloon
{
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"baloon.png"];
    sprite.anchorPoint = ccp(0, 0.82f);
    sprite.opacity = 0;
    sprite.position = ccp(0, 0);
    
    CCSprite *sprite1 = [CCSprite spriteWithSpriteFrameName:@"explanation.png"];
    sprite1.opacity = 0;
    sprite1.anchorPoint = ccp(0.5f, 0.5f);
    sprite1.position = ccp(sprite.position.x+sprite.contentSize.width/1.85f, sprite.position.y+sprite.contentSize.height/2);
    
    [[self getChildByTag:kBatchNode]addChild:sprite z:1 tag:baloon];
    [[[self getChildByTag:kBatchNode] getChildByTag:baloon]addChild:sprite1 z:2 tag:explanation];
    
    [sprite runAction:[CCSequence actions:[CCFadeTo actionWithDuration:0.3f opacity:255],[CCDelayTime actionWithDuration:5],[CCFadeTo actionWithDuration:0.3f opacity:0],[CCCallBlock actionWithBlock:^{
        [sprite removeFromParentAndCleanup:YES];
    }], nil]].tag =  [self whatTagIsLegal];
    [sprite1 runAction:[CCSequence actions:[CCFadeTo actionWithDuration:0.3f opacity:255],[CCDelayTime actionWithDuration:5],[CCFadeTo actionWithDuration:0.3f opacity:0],[CCCallBlock actionWithBlock:^{
        [sprite1 removeFromParentAndCleanup:YES];
    }], nil]].tag = [self whatTagIsLegal];

}

-(void)creatBatchNode
{
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"Tutorial%@.pvr.ccz",kDevice]];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"Tutorial%@.plist",kDevice]];
    
    [self addChild:batchNode z:2 tag:kBatchNode];
    
}

-(id)init{
    
    if (self =[super init]) {
        [self creatBatchNode];
    }
    return self;
}

- (void) dealloc
{
	[super dealloc];
}

@end
