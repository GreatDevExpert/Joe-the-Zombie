

#import "Cristal.h"
#import "SConfig.h"
#import "cfg.h"
#import "Head.h"
#import "Constants_Level4.h"



@implementation Cristal


-(void)setCristalPos:(CGPoint)pos_:(NSNumber*)cristalNum
{
    [spriteBatchNode getChildByTag:cristalNum.integerValue].position = ccp(pos_.x, pos_.y);
}

-(void)addCristal:(NSString*)spriteName:(NSNumber*)cristalNum
{
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:spriteName];
    sprite.position = ccp(kWidthScreen/2,kHeightScreen/2);
    sprite.anchorPoint = ccp(0, 0);
    [spriteBatchNode addChild:sprite z:1 tag:cristalNum.integerValue];
    [AUDIO playEffect:l3_diamondInsert];
    
    
    if (cristalNum.integerValue == 3) {
        for (int i = 1; i<=3; i++) {
            CCSprite *sprite = (CCSprite*)[spriteBatchNode getChildByTag:i];
            [sprite runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCFadeTo actionWithDuration:0.3 opacity:150],[CCFadeTo actionWithDuration:0.3 opacity:255], nil]]];
        }
    }
    else if(cristalNum.integerValue == 6)
    {
        for (int i = 4; i<=6; i++) {
            CCSprite *sprite = (CCSprite*)[spriteBatchNode getChildByTag:i];
            [sprite runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCFadeTo actionWithDuration:0.3 opacity:150],[CCFadeTo actionWithDuration:0.3 opacity:255], nil]]];
        }
    }
    else if (cristalNum.integerValue == 9)
    {
        for (int i = 7; i<=9; i++) {
            CCSprite *sprite = (CCSprite*)[spriteBatchNode getChildByTag:i];
            [sprite runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCFadeTo actionWithDuration:0.3 opacity:150],[CCFadeTo actionWithDuration:0.3 opacity:255], nil]]];
        }
    }
}

-(void)addBatchnode
{
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"Level4%@.pvr.ccz",kDevice]];
    [self addChild:spriteBatchNode z:0];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"Level4%@.plist",kDevice]];
}

-(void)blink:(CCNode*)node{

    if ([self getActionByTag:1].isDone) {

    [node runAction:[CCSpawn actions:[CCSequence actions:[CCFadeTo actionWithDuration:0.3 opacity:255],[CCDelayTime actionWithDuration:0.05f],[CCFadeTo actionWithDuration:0.3f opacity:0], nil],[CCRotateTo actionWithDuration:3.f angle:6000],[CCSequence actions:[CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:0.3f scale:1.4f] rate:2],[CCScaleTo actionWithDuration:0.3f scale:0.9f], nil], nil]].tag = 1;
    }
}

-(void)crateBlink
{
    CCSprite *blink = [CCSprite spriteWithSpriteFrameName:@"blink.png"];
    blink.anchorPoint = ccp(0.4f, 0.4f);
    // blink.position = ccp(sprite.position.x+sprite.contentSize.width/2.3f, sprite.position.y+sprite.contentSize.height/1.1f);
    blink.opacity = 0;
    [self addChild:blink z:2 tag:222];

}
-(void)update:(ccTime *)dt
{




}

-(id)initWithRect:(CGRect)boxrect_{
    
    if (self =[super init]) {
        self.contentSize = CGSizeMake(boxrect_.size.width,boxrect_.size.height);
        self.anchorPoint = ccp(self.contentSize.width, self.contentSize.height);
        self.position = ccp(boxrect_.origin.x,boxrect_.origin.y);
        [self addBatchnode];
        [self crateBlink];
        [self scheduleUpdate];
    }
    return self;
}

@end
