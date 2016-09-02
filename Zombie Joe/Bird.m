
#import "SConfig.h"
#import "cfg.h"
#import "Bird.h"

#define BNtag 10

@implementation Bird

-(void)birdAnimation
{
    [[[self getChildByTag:BNtag]getChildByTag:0] runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.25f scaleX:0.8f scaleY:-0.8f],[CCScaleTo actionWithDuration:0.45f scaleX:0.8f scaleY:0.8f], nil]]];
    
    [[self getChildByTag:BNtag] runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCMoveBy actionWithDuration:0.25f position:ccp(0,[[self getChildByTag:BNtag]getChildByTag:1].contentSize.height/3.2)],[CCMoveBy actionWithDuration:0.45f position:ccp(0,-[[self getChildByTag:BNtag]getChildByTag:1].contentSize.height/3.2)], nil]]];
    
    [[[self getChildByTag:BNtag]getChildByTag:1] runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.25f scaleX:0.8f scaleY:0.9f],[CCScaleTo actionWithDuration:0.45f scaleX:0.8f scaleY:0.8f], nil]]];
    
    [[[self getChildByTag:BNtag]getChildByTag:2] runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.25f scaleX:0.8f scaleY:-0.8f],[CCScaleTo actionWithDuration:0.45f scaleX:0.8f scaleY:0.8f], nil]]];
}

-(void)createBird
{
    for (int i = 0; i<=2; i++) {
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"bird%i.png",i]];
        sprite.scale = 0.8f;
        switch (i) {
            case 0:sprite.anchorPoint = ccp(0.5f, 0);sprite.position = ccp(sprite.contentSize.width/3, sprite.contentSize.height/2.5); break;
            case 1:sprite.anchorPoint = ccp(0.5f, 1.f);sprite.position = ccp(0, sprite.contentSize.height/1.2);break;
            case 2:sprite.anchorPoint = ccp(0.5f, 0);sprite.position = ccp(sprite.contentSize.width/3, sprite.contentSize.height/2.5);break;
            default:break;
        }
        [[self getChildByTag:BNtag] addChild:sprite z:i tag:i];
    }
}

-(void)createBatchNode
{
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    CCSpriteBatchNode *spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"Level9%@.pvr.ccz",kDevice]];
    [self addChild:spriteBatchNode z:1 tag:BNtag];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"Level9%@.plist",kDevice]];
}

-(id)initWithRect:(CGRect)boxrect_{
    
    if (self =[super init]) {
       
        self.contentSize = CGSizeMake(boxrect_.size.width,boxrect_.size.height);
        self.anchorPoint = ccp(0,0);
        self.position = ccp(boxrect_.origin.x, boxrect_.origin.y);
        [self createBatchNode];
        [self createBird];
        [self birdAnimation];
    }
    return self;
}
@end
