//
//  MonstersLVL11.m
//  project_box2d
//
//  Created by Slavian on 2013-06-17.
//
//

#import "MonstersLVL11.h"
#import "SConfig.h"
#import "cfg.h"

#define BNtag 100

@implementation MonstersLVL11

-(void)monster1Aciton
{
    [[[self getChildByTag:BNtag]getChildByTag:1] runAction:
     [CCSpawn actions:
      [CCSequence actions:
       [CCEaseInOut actionWithAction:
        [CCMoveBy actionWithDuration:0.3f position:ccp(0, [[self getChildByTag:BNtag]getChildByTag:1].contentSize.height/10)]rate:2],
       [CCEaseInOut actionWithAction:
        [CCMoveBy actionWithDuration:0.2f position:ccp(0, -[[self getChildByTag:BNtag]getChildByTag:1].contentSize.height/10)]rate:2], nil],
      [CCSequence actions:
       [CCScaleTo actionWithDuration:0.3f scaleX:1.0f scaleY:1.2f],
       [CCScaleTo actionWithDuration:0.2f scaleX:1.0f scaleY:1.0f], nil], nil]];
    
    
    [[[self getChildByTag:BNtag]getChildByTag:2] runAction:
     [CCSpawn actions:
      [CCSequence actions:
       [CCEaseInOut actionWithAction:
        [CCMoveBy actionWithDuration:0.3f position:ccp(0, [[self getChildByTag:BNtag]getChildByTag:2].contentSize.height/3)] rate:2],
       [CCEaseInOut actionWithAction:
        [CCMoveBy actionWithDuration:0.2f position:ccp(0, -[[self getChildByTag:BNtag]getChildByTag:2].contentSize.height/3)]rate:2], nil],
      [CCSequence actions:
       [CCScaleTo actionWithDuration:0.3f scaleX:1.0f scaleY:1.2f],
       [CCScaleTo actionWithDuration:0.2f scaleX:1.0f scaleY:1.0f], nil], nil]];
    
}

-(void)flowerAnim
{
    [[[self getChildByTag:BNtag]getChildByTag:1]runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:0.6f angle:360]]];
    
}

-(void)beeAnim
{
    [[[self getChildByTag:BNtag] getChildByTag:12] runAction:
     [CCRepeatForever actionWithAction:
      [CCSequence actions:
       [CCRotateBy actionWithDuration:0.02f angle:-30],
       [CCRotateBy actionWithDuration:0.02f angle:30], nil]]];
    
    
    [[[self getChildByTag:BNtag]getChildByTag:11] runAction:
     [CCRepeatForever actionWithAction:
      [CCSequence actions:
        [CCScaleTo actionWithDuration:0.2f scaleX:1.0f scaleY:0.9f],
       [CCDelayTime actionWithDuration:0.2f],
        [CCScaleTo actionWithDuration:0.1f scaleX:1.0f scaleY:1.0f], nil]]];
}

-(void)createMonster:(NSNumber*)num
{
    if (num.integerValue == 1) {
        
        for (int i = 0; i<=2; i++) {
            CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"flower_%i.png",i]];
            switch (i) {
                case 0:sprite.anchorPoint = ccp(0,0);sprite.position = ccp(0, 0);break;
                case 1:sprite.anchorPoint = ccp(0.5f,0.5f);sprite.position = ccp([[self getChildByTag:BNtag]getChildByTag:0].contentSize.width*0.4f,[[self getChildByTag:BNtag]getChildByTag:0].contentSize.height);break;
                case 2:sprite.anchorPoint = ccp(0.5f,0.5f);sprite.position = [[self getChildByTag:BNtag]getChildByTag:1].position;break;
                default:break;
            }
            [[self getChildByTag:BNtag]addChild:sprite z:i tag:i];
        }
        [self flowerAnim];
    }
    
    if (num.integerValue == 2) {
        
        for (int i = 0; i<=2; i++) {
            CCSprite *sprite;
            int z = 0;
            switch (i) {
                case 0:  sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"bee_%i.png",i]];z = 1;
                sprite.anchorPoint = ccp(0,0);sprite.position = ccp(-sprite.contentSize.width/5, -sprite.contentSize.height/8);break;
                case 1:sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"bee_%i.png",i]];
                    sprite.anchorPoint = ccp(0.5f,1.f);sprite.position = ccp(sprite.contentSize.width/1.4,sprite.contentSize.height/4); z = 2;break;
                case 2:sprite = [CCSprite spriteWithSpriteFrameName:@"bee_wing0.png"];
                    sprite.anchorPoint = ccp(0.1f,0.1f);sprite.position = ccp(sprite.contentSize.width,sprite.contentSize.height*1.2);z = 0; break;
                default:break;
            }
            [[self getChildByTag:BNtag]addChild:sprite z:z tag:10+i];
        }
        [self beeAnim];
  
    }
    
}

-(void)createBatchNode
{
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    CCSpriteBatchNode *spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"Level11%@.pvr.ccz",kDevice]];
    [self addChild:spriteBatchNode z:1 tag:BNtag];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"Level11%@.plist",kDevice]];
}

-(id)initWithRect:(CGRect)boxrect_{
    
    if (self =[super init]) {
    
        self.contentSize = CGSizeMake(boxrect_.size.width,boxrect_.size.height);
        self.anchorPoint = ccp(0,0);
        self.position = ccp(boxrect_.origin.x, boxrect_.origin.y);
        [self createBatchNode];
        
    }
    return self;
}

@end
