//
//  Zombie_lvl11.m
//  project_box2d
//
//  Created by Slavian on 2013-06-20.
//
//

#import "Zombie_lvl11.h"
#import "SConfig.h"
#import "cfg.h"

#define BNtag 100

@implementation Zombie_lvl11


-(void)dead
{
    for (CCSprite *s in self.children) {
        s.visible = NO;
    }
    CCSprite *s = [CCSprite spriteWithSpriteFrameName:@"death.png"];
    s.anchorPoint = ccp(0, 0);
    s.position = ccp(0, 0);
    [self addChild:s z:10 tag:10];
    [self colorAllBodyPartsWithColor:ccc3(220, 72, 72) restore:YES restoreAfterDelay:0.15f obj:s];
}

-(void)colorAllBodyPartsWithColor:(ccColor3B)c_ restore:(BOOL)restore_ restoreAfterDelay:(float)delay_ obj:(CCSprite*)s_{
    

        
        s_.color = c_;
        
        if (restore_){
            
            id delay = [CCDelayTime actionWithDuration:delay_];
            
            id block = [CCCallBlock actionWithBlock:^(void){
                
                s_.color = ccc3(255, 255, 255);
                
            }];
            
            [s_ runAction:[CCSequence actions:delay,block, nil]];
            
        }


    
}

-(void)rotateHead:(NSNumber *)num
{
    if ([[self getChildByTag:BNtag] getChildByTag:1].numberOfRunningActions == 0) {
    
        if (num.integerValue == 1) {
            [[[self getChildByTag:BNtag] getChildByTag:1] runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.1f],[CCEaseInOut actionWithAction:[CCRotateTo actionWithDuration:0.2f angle:-110] rate:2],[CCDelayTime actionWithDuration:1.5f],[CCEaseInOut actionWithAction:[CCRotateTo actionWithDuration:0.2f angle:-90] rate:2], nil]];
        }
        else if(num.integerValue == 2)
        {
            [[[self getChildByTag:BNtag] getChildByTag:1] runAction:[CCSequence actions:[CCSpawn actions:[CCScaleTo actionWithDuration:0.1f scaleX:-1.0f scaleY:1.0],[CCMoveBy actionWithDuration:0.05f position:ccp(0, [[self getChildByTag:BNtag] getChildByTag:1].contentSize.width/5)], nil],[CCDelayTime actionWithDuration:1.5f],[CCSpawn actions:[CCScaleTo actionWithDuration:0.1f scaleX:1.0f scaleY:1.0f],[CCMoveBy actionWithDuration:0.05f position:ccp(0, -[[self getChildByTag:BNtag] getChildByTag:1].contentSize.width/5)], nil], nil]];
        
    
        }
    }
}

-(void)scaleBody:(NSNumber *)num
{
    if([[self getChildByTag:BNtag] getChildByTag:0].numberOfRunningActions == 0){
        
        if (num.integerValue == 1) {
        
            [[[self getChildByTag:BNtag] getChildByTag:0] runAction:[CCScaleTo actionWithDuration:0.2f scaleX:1.2f scaleY:1.0f]];
        }
        else if (num.integerValue == 2) {
            [[[self getChildByTag:BNtag] getChildByTag:0] runAction:[CCScaleTo actionWithDuration:0.2f scaleX:0.8f scaleY:1.0f]];
        }
        else if (num.integerValue == 3) {
            [[[self getChildByTag:BNtag] getChildByTag:0] runAction:[CCScaleTo actionWithDuration:0.2f scaleX:1.0f scaleY:1.0f]];
        }
    }
}

-(float)MyRandomIntegerBetween:(int)min :(int)max{
    
    return ( ((arc4random() % (max-min)) + min)/0.01 );
}


-(void)eyesBlink:(CCNode *)sprite
{
    [sprite runAction:
     [CCRepeatForever actionWithAction:
      [CCSequence actions:
       [CCRepeat actionWithAction:
        [CCSequence actions:
         [CCFadeTo actionWithDuration:0.05f opacity:255],
         [CCDelayTime actionWithDuration:0.08f],
         [CCEaseIn actionWithAction:[CCFadeTo actionWithDuration:0.05f opacity:0] rate:3],
         [CCDelayTime actionWithDuration:0.08f]
         ,nil] times:2],
       [CCDelayTime actionWithDuration:2.5f],
       nil]]]
    ;
}

-(void)createSprites
{
    for (int i = 0; i<=3; i++) {
        CCSprite *sprite;

        switch (i) {
            case 0:sprite = [CCSprite spriteWithSpriteFrameName:@"body.png"];sprite.position = ccp(sprite.contentSize.width*1.7,sprite.contentSize.height); sprite.anchorPoint = ccp(0.2f, 0.9f);
            
                sprite.rotation = -90;
                [[self getChildByTag:BNtag] addChild:sprite z:i tag:i]; break;
                
            case 1:sprite = [CCSprite spriteWithSpriteFrameName:@"head.png"];sprite.position = ccp([[self getChildByTag:BNtag] getChildByTag:0].position.x,sprite.contentSize.height/3);sprite.anchorPoint = ccp(0.45f, 0.11f);
                
                sprite.rotation = -90;

                [[self getChildByTag:BNtag] addChild:sprite z:i tag:i]; break;
                
            case 2:sprite = [CCSprite spriteWithSpriteFrameName:@"propeler.png"];sprite.position = ccp(sprite.contentSize.width*2.07f,sprite.contentSize.height*3.08f);sprite.anchorPoint = ccp(0.5f, 0.5f);[sprite runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:0.15f angle:200]]];
                
                [[[self getChildByTag:BNtag] getChildByTag:1] addChild:sprite z:-1 tag:i]; break;
                
            case 3:sprite = [CCSprite spriteWithSpriteFrameName:@"eyesclosed.png"];sprite.position = ccp(sprite.contentSize.width*1.05,sprite.contentSize.height/1.3f);sprite.anchorPoint = ccp(0.5f, 0.5f); sprite.opacity = 0;
                [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.f],[CCCallFuncO actionWithTarget:self selector:@selector(eyesBlink:) object:sprite], nil]];
              
                [[[self getChildByTag:BNtag] getChildByTag:1] addChild:sprite z:i tag:i]; break;
             
            default:break;
        }
    }
}

-(void)createBatchNode
{
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    CCSpriteBatchNode *spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"Level11_zombie%@.pvr.ccz",kDevice]];
    [self addChild:spriteBatchNode z:1 tag:BNtag];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"Level11_zombie%@.plist",kDevice]];
}

-(id)initWithRect:(CGRect)boxrect_{
    
    if (self =[super init]) {
        
        self.contentSize = CGSizeMake(boxrect_.size.width,boxrect_.size.height);
        self.anchorPoint = ccp(0,0);
        self.position = ccp(boxrect_.origin.x, boxrect_.origin.y);
       // self.color = ccRED;
        [self createBatchNode];
        [self createSprites];
        
        
        
    }
    return self;
}

@end
