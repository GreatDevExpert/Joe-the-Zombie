//
//  SpeedBonus.m
//  project_box2d
//
//  Created by Slavian on 2013-06-20.
//
//

#import "SpeedBonus.h"
#import "SConfig.h"
#import "cfg.h"

#define BNtag 100

#define R1_ipad ccp(36.5,11)
#define R2_ipad ccp(74.5,30)
#define R3_ipad ccp(94.5,15)
#define R4_ipad ccp(155.5,11)
#define R5_ipad ccp(193.5,30)
#define R6_ipad ccp(213.5,15)

#define R1_iphone ccp(17,5)
#define R2_iphone ccp(35,14)
#define R3_iphone ccp(44.5,7)
#define R4_iphone ccp(73,5)
#define R5_iphone ccp(91,14)
#define R6_iphone ccp(100.5,7)

@implementation SpeedBonus


-(CGPoint)rowsPos:(NSNumber*)numOFrow
{
    switch (numOFrow.intValue) {
        case 1:if(IS_IPAD)return R1_ipad;return R1_iphone;break;
        case 2:if(IS_IPAD)return R2_ipad;return R2_iphone;break;
        case 3:if(IS_IPAD)return R3_ipad;return R3_iphone;break;
        case 4:if(IS_IPAD)return R4_ipad;return R4_iphone;break;
        case 5:if(IS_IPAD)return R5_ipad;return R5_iphone;break;
        case 6:if(IS_IPAD)return R6_ipad;return R6_iphone;break;
        default:break;
    }
    return R1_ipad;
}

-(void)rowsAnimation:(CCNode *)sprite
{
    [sprite runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCFadeTo actionWithDuration:0.1f opacity:255],[CCFadeTo actionWithDuration:0.1f opacity:0],[CCDelayTime actionWithDuration:0.4f], nil]]];
}

-(void)createSprites
{
    for (int i = 0; i<=6; i++) {
     
        CCSprite *sprite;
        CCSprite *sprite2;
        
        switch (i) {
            case 0:sprite2 = [CCSprite spriteWithSpriteFrameName:@"boost0.png"];sprite2.position = ccp(0, 0);break;
            case 1:sprite = [CCSprite spriteWithSpriteFrameName:@"boost1.png"];sprite.position = [self rowsPos:[NSNumber numberWithInt:1]];break;
            case 2:sprite = [CCSprite spriteWithSpriteFrameName:@"boost2.png"];sprite.position = [self rowsPos:[NSNumber numberWithInt:2]];break;
            case 3:sprite = [CCSprite spriteWithSpriteFrameName:@"boost3.png"];sprite.position = [self rowsPos:[NSNumber numberWithInt:3]];break;
            case 4:sprite = [CCSprite spriteWithSpriteFrameName:@"boost1.png"];sprite.position = [self rowsPos:[NSNumber numberWithInt:4]];break;
            case 5:sprite = [CCSprite spriteWithSpriteFrameName:@"boost2.png"];sprite.position = [self rowsPos:[NSNumber numberWithInt:5]];break;
            case 6:sprite = [CCSprite spriteWithSpriteFrameName:@"boost3.png"];sprite.position = [self rowsPos:[NSNumber numberWithInt:6]];break;
            default:break;
        }
        if (i == 0) {
            sprite2.anchorPoint = ccp(0, 0);
            sprite2.opacity = 255;
            [[self getChildByTag:BNtag] addChild:sprite2 z:i tag:i];
        }
        else {
            sprite.anchorPoint = ccp(0, 0);
            sprite.opacity = 0;
            
            [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:(float)i/12],[CCCallFuncO actionWithTarget:self selector:@selector(rowsAnimation:) object:sprite], nil]];
        
            [[self getChildByTag:BNtag] addChild:sprite z:i tag:i];
        }
        
        
    }
}

-(void)createBatchNode
{
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    CCSpriteBatchNode *spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"Level11_speedB%@.pvr.ccz",kDevice]];
    [self addChild:spriteBatchNode z:1 tag:BNtag];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"Level11_speedB%@.plist",kDevice]];
}

-(id)initWithRect:(CGRect)boxrect_{
    
    if (self =[super init]) {
        
        self.contentSize = CGSizeMake(boxrect_.size.width,boxrect_.size.height);
        self.anchorPoint = ccp(0,0);
        self.position = ccp(boxrect_.origin.x, boxrect_.origin.y);
        [self createBatchNode];
        [self createSprites];
        
//        CCSprite *blackBoard = [[[CCSprite alloc]init]autorelease];
//        
//        [blackBoard setTextureRect:CGRectMake(0, 0, self.contentSize.width,
//                                              self.contentSize.height)];
//        blackBoard.position = ccp(0,0);
//        blackBoard.opacity = 255;
//        blackBoard.anchorPoint = ccp(1.f, 0.f);
//        [self addChild:blackBoard z:0 tag:5];
//        blackBoard.color = ccRED;
        
    }
    return self;
}

@end
