
#import "Head.h"
#import "SConfig.h"
#import "Constants_Level4.h"
#import "cfg.h" 
#import "Cristal.h"
#import "BrainsBonus.h"

@implementation Head

@synthesize openMouth;
-(CGPoint)returnValuePOS_:(int)number
{
    switch (number) {
        case 1:if(IS_IPAD){return CP1_ipad;}else if(IS_IPHONE_5){return CP1_iphone5;}else if (IS_IPHONE){return CP1_iphone;}break;
        case 2:if(IS_IPAD){return CP2_ipad;}else if(IS_IPHONE_5){return CP2_iphone5;}else if (IS_IPHONE){return CP2_iphone;}break;
        case 3:if(IS_IPAD){return CP3_ipad;}else if(IS_IPHONE_5){return CP3_iphone5;}else if (IS_IPHONE){return CP3_iphone;}break;
        case 4:if(IS_IPAD){return CP4_ipad;}else if(IS_IPHONE_5){return CP4_iphone5;}else if (IS_IPHONE){return CP4_iphone;}break;
        case 5:if(IS_IPAD){return CP5_ipad;}else if(IS_IPHONE_5){return CP5_iphone5;}else if (IS_IPHONE){return CP5_iphone;}break;
        case 6:if(IS_IPAD){return CP6_ipad;}else if(IS_IPHONE_5){return CP6_iphone5;}else if (IS_IPHONE){return CP6_iphone;}break;
        case 7:if(IS_IPAD){return CP7_ipad;}else if(IS_IPHONE_5){return CP7_iphone5;}else if (IS_IPHONE){return CP7_iphone;}break;
        case 8:if(IS_IPAD){return CP8_ipad;}else if(IS_IPHONE_5){return CP8_iphone5;}else if (IS_IPHONE){return CP8_iphone;}break;
        case 9:if(IS_IPAD){return CP9_ipad;}else if(IS_IPHONE_5){return CP9_iphone5;}else if (IS_IPHONE){return CP9_iphone;}break;
        case 10:if(IS_IPAD){return DP_ipad;}else if(IS_IPHONE_5){return DP_iphone5;}else if (IS_IPHONE){return DP_iphone;}break;
        case 11:if(IS_IPAD){return GP1_ipad;}else if(IS_IPHONE_5){return GP1_iphone5;}else if (IS_IPHONE){return GP1_iphone;}break;
        case 12:if(IS_IPAD){return GP2_ipad;}else if(IS_IPHONE_5){return GP2_iphone5;}else if (IS_IPHONE){return GP2_iphone;}break;
        case 13:if(IS_IPAD){return GP3_ipad;}else if(IS_IPHONE_5){return GP3_iphone5;}else if (IS_IPHONE){return GP3_iphone;}break;
        case 14:if(IS_IPAD){return GP4_ipad;}else if(IS_IPHONE_5){return GP4_iphone5;}else if (IS_IPHONE){return GP4_iphone;}break;
        case 15:return cup1Pos;break;
        case 16:return cup2Pos;break;
        case 17:return cup3Pos;break;
        default:break;
    }
    return cup1Pos;
}

-(void)addBrain{

    if ([spriteBatchNode getChildByTag:44]) {
   // [[spriteBatchNode getChildByTag:44] removeFromParentAndCleanup:NO];
    }
    
    if (![spriteBatchNode getChildByTag:44]) {
        
//        CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
//        CCSprite *sprite = [CCSprite spriteWithSpriteFrame:[cache spriteFrameByName:@"brains.png"]];
        
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"brain_.png"];
        //cristalW = [sprite boundingBox].size.width;
        //cristalH = [sprite boundingBox].size.height;
        
        sprite.position = ccp([spriteBatchNode getChildByTag:0].position.x, [spriteBatchNode getChildByTag:0].position.y+sprite.contentSize.height*1.5);
        sprite.anchorPoint = ccp(0, 0);
        sprite.opacity = 0;
        sprite.scale = 1.0f;
        
       // CCTexture2D *texture2d = [CCTexture2D ];
       // [sprite setTexture:[spriteBatchNode texture]];
        
        [spriteBatchNode addChild:sprite z:1 tag:44];
        
    }
   
    if (![self getActionByTag:2]) {
    [[spriteBatchNode getChildByTag:44] runAction:[CCFadeTo actionWithDuration:0.1f opacity:255]].tag = 2;
    }
}

-(void)removeBrain{

    if ([spriteBatchNode getChildByTag:44]) {
  // [[spriteBatchNode getChildByTag:44] removeFromParentAndCleanup:NO];
    }
}

-(int)returnInt:(int)number
{
    if (number == 1) {if(IS_IPAD){return Angle_ipad;}else{return Angle_iphone;}}
    else if (number == 2){if(IS_IPAD){return Angle_Reverse_ipad;}else{return Angle_Reverse_iphone;}}
    else if (number == 3){if(IS_IPAD){return headjump1_ipad;}else{return headjump1_iphone;}}
    else if (number == 4){if(IS_IPAD){return ipad_smile_height;}else{return iphone_smile_height;}}
    else if (number == 5){if(IS_IPAD){return cristaljump_ipad;}else{return cristaljump_iphone;}}
    else if (number == 6){if(IS_IPAD){return headjump2_ipad;}else{return headjump2_iphone;}}
    return 0;
}

-(void)eaysStartPos
{
    //[[spriteBatchNode getChildByTag:3]stopAllActions];
   // [spriteBatchNode getChildByTag:3].position = ccp(self.contentSize.width/2,[spriteBatchNode getChildByTag:3].contentSize.height*3);
    
    [[spriteBatchNode getChildByTag:1] stopAllActions];
    [spriteBatchNode getChildByTag:1].position = ccp(self.contentSize.width/2,0);
}

-(void)eaysRunning
{
    id a = [CCMoveBy actionWithDuration:0.1f position:ccp(-[[spriteBatchNode getChildByTag:1] getChildByTag:3].contentSize.width/20, 0)];
    id b = [CCDelayTime actionWithDuration:0.3f];
    
    //if (![self getActionByTag:1]) {
    [[[spriteBatchNode getChildByTag:1] getChildByTag:3] runAction:[CCSequence actions:b,b,a,b,b,b,[a reverse],[a reverse],[a reverse],b,a,a, nil]].tag = 1;
   // }
}

-(void)callCristal
{
    [[spriteBatchNode getChildByTag:4] removeFromParentAndCleanup:YES];
}

-(void)movingHeads
{
    CCSprite *sprite = (CCSprite*)[spriteBatchNode getChildByTag:1];
    //CCSprite *sprite1 = (CCSprite*)[spriteBatchNode getChildByTag:3];
    
    id a = [CCMoveBy actionWithDuration:0.1f position:ccp(0, [self returnInt:4])];
    id b = [CCRepeat actionWithAction:[CCSequence actions:a,[a reverse], nil] times:2];
    
    if (![self getActionByTag:3]) {
    [sprite runAction:b].tag = 3;
  //  [sprite1 runAction:[b copy]];
    }
}

-(void)particles:(void *)data
{
    CGPoint spriteCoord = [(NSValue *)data CGPointValue];
    
    CCParticleSystemQuad *effect = [CCParticleSystemQuad particleWithFile:[NSString stringWithFormat: @"Crislat_par.plist"/*,kDevice*/]];
   // NSLog(@"%f, %f",spriteCoord.x,spriteCoord.y);
    effect.position = ccp(spriteCoord.x,spriteCoord.y);
    if (IS_IPHONE || IS_IPHONE_5) {effect.scale = 0.4f;}
    else{effect.scale = 0.7f;}
    [self addChild:effect z:6];
    effect.autoRemoveOnFinish = YES;

}

-(void)cristalGo:(CGPoint)pos
{
    float scale = 1;
  
    if (self.scale < 1.0f) {
        //CCSprite *sprite = (CCSprite*)[spriteBatchNode getChildByTag:4];
        scale = 1.65f;
       // NSLog(@"scale: %f",self.scale);
    }
  
    CGPoint worldCoord = [self convertToNodeSpace:pos];
    NSValue *value = [NSValue valueWithCGPoint:worldCoord];
    if (![self getActionByTag:4]) {
    [[spriteBatchNode getChildByTag:4]runAction:
     [CCSequence actions:[CCSpawn actions:[CCEaseOut actionWithAction:[CCJumpTo actionWithDuration:0.5f position:worldCoord height:[self returnInt:5] jumps:1] rate:2],[CCScaleBy actionWithDuration:0.5f scale:scale],nil],[CCCallFuncO actionWithTarget:self selector:@selector(particles:) object:value], nil]].tag = 4;
    }
    
    if (cristalCount == 10) {
         [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.7f],[CCCallFuncO actionWithTarget:self selector:@selector(callCristal)], nil]];
    }
    else{
         [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.5f],[CCCallFuncO actionWithTarget:self selector:@selector(callCristal)], nil]];
         [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.5f],[CCCallFuncO actionWithTarget:self selector:@selector(removeBrain)], nil]];
    }
    
}
-(void)headGoDown{

    openMouth = false;
    CCSprite *sprite = (CCSprite*)[spriteBatchNode getChildByTag:1];
    sprite.anchorPoint = ccp(0.5f, 0);
    float rotate;
    if (IS_IPAD) {rotate = 2.4f;}else{rotate = 2.6f;}
    
    id a = [CCMoveTo actionWithDuration:0.2f position:ccp(sprite.contentSize.width/rotate,0)];
    [sprite runAction:a].tag = 5;


}

-(void)actionReverse
{
    openMouth = false;
    CCSprite *sprite = (CCSprite*)[spriteBatchNode getChildByTag:1];
    sprite.anchorPoint = ccp(0.5f, 0);
    [AUDIO playEffect:l3_mouthClose];
    
    float rotate;
    if (IS_IPAD) {rotate = 2.4f;}else{rotate = 2.6f;}
    
    id a = [CCMoveTo actionWithDuration:0.2f position:ccp(sprite.contentSize.width/rotate,0)];
    
    if (![self getActionByTag:5]) {
    [sprite runAction:a].tag = 5;
   // [sprite1 runAction:[a copy]];
    [[spriteBatchNode getChildByTag:4] runAction:[CCFadeTo actionWithDuration:0.2f opacity:0]];
        [[spriteBatchNode getChildByTag:4] runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.2f scale:0.5f],[CCDelayTime actionWithDuration:1.5f],[CCScaleTo actionWithDuration:0 scale:1.f], nil]];
    }
    
    if ([spriteBatchNode getChildByTag:44]) {
        [[spriteBatchNode getChildByTag:44] runAction:[CCFadeTo actionWithDuration:0.2f opacity:0]];
        [[spriteBatchNode getChildByTag:44] runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.2f scale:0.5f],[CCDelayTime actionWithDuration:1.5f],[CCScaleTo actionWithDuration:0 scale:1.f], nil]];
    }
}

-(void)doSomething
{
    openMouth = true;
    [AUDIO playEffect:l3_mouthOpen];
    CCSprite *sprite = (CCSprite*)[spriteBatchNode getChildByTag:1];
    //CCSprite *sprite1 = (CCSprite*)[spriteBatchNode getChildByTag:3];
    
    id a = [CCMoveTo actionWithDuration:0.2f position:ccp(self.contentSize.width/2, [self returnInt:3])];
   // if (![self getActionByTag:6]) {
    [sprite runAction:a].tag = 6;
    //[sprite1 runAction:[a copy]];
   // }
}
-(void)smile2
{
    for (int i = 0; i<2; i++) {
        switch (i) {
            case 0:
                 [AUDIO playEffect:l3_monsterLaugh];
                break;
            case 1:
                [AUDIO performSelector:@selector(playEffect:) withObject:l3_monsterLaugh afterDelay:0.2f];
                break;
                
            default:
                break;
        }
       
    }
    
    CCSprite *sprite1 = (CCSprite*)[spriteBatchNode getChildByTag:3];
    id a = [CCMoveBy actionWithDuration:0.13f position:ccp(0, [self returnInt:3])];
    id c = [CCMoveBy actionWithDuration:0.13f position:ccp(0, [self returnInt:6])];
    id b = [CCSequence actions:a,[c reverse],c,[c reverse],c,[a reverse], nil];
    if (![self getActionByTag:7]) {
    [sprite1 runAction:b].tag = 7;
    }
}

-(void)gameOverSmile
{
    [self eaysStartPos];
    CCSprite *sprite = (CCSprite*)[spriteBatchNode getChildByTag:1];
    id a = [CCMoveBy actionWithDuration:0.13f position:ccp(0, [self returnInt:3])];
    id c = [CCMoveBy actionWithDuration:0.13f position:ccp(0, [self returnInt:6])];
    id b = [CCSequence actions:a,[c reverse],c,[c reverse],c,[a reverse], nil];
    if (![self getActionByTag:8]) {
    [sprite runAction:b].tag = 8;
    }
    [self smile2];
}

-(void)gameOver
{
    CCSprite *sprite = (CCSprite*)[spriteBatchNode getChildByTag:1];
    //CCSprite *sprite1 = (CCSprite*)[spriteBatchNode getChildByTag:3];
    id a = [CCMoveBy actionWithDuration:0.2f position:ccp(0, [self returnInt:3])];
    if (![self getActionByTag:9]) {
    [sprite runAction:a].tag = 9;
    //[sprite1 runAction:[a copy]];
    }
    [self addCristal];
}

-(void)pliusCristals
{
    cristalCount++;
}

-(void)closeMouth
{
    CCSprite *sprite = (CCSprite*)[spriteBatchNode getChildByTag:1];
    //CCSprite *sprite1 = (CCSprite*)[spriteBatchNode getChildByTag:3];
    
    id a = [CCMoveBy actionWithDuration:0.2f position:ccp(0, -[self returnInt:3])];
    if (![self getActionByTag:10]) {
    [sprite runAction:a].tag = 10;
    //[sprite1 runAction:[a copy]];
    }
}

-(void)addCristal
{
    [[spriteBatchNode getChildByTag:4] removeFromParentAndCleanup:YES];

    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:cristalName];
    
    cristalW = [sprite boundingBox].size.width;
    cristalH = [sprite boundingBox].size.height;
    
    sprite.position = ccp([spriteBatchNode getChildByTag:0].position.x, [spriteBatchNode getChildByTag:0].position.y+sprite.contentSize.height/1.2);
    sprite.anchorPoint = ccp(0, 0);
    sprite.opacity = 0;
    [spriteBatchNode addChild:sprite z:1 tag:4];
    [[spriteBatchNode getChildByTag:4] runAction:[CCFadeTo actionWithDuration:0.1f opacity:255]];
    
    CCSprite *blink = [CCSprite spriteWithSpriteFrameName:@"blink.png"];
    blink.anchorPoint = ccp(0.4f, 0.4f);
    blink.position = ccp(sprite.position.x+sprite.contentSize.width/2.3f, sprite.position.y+sprite.contentSize.height/1.1f);
    blink.opacity = 0;
    [self addChild:blink z:2 tag:222];
    
    if (![self getActionByTag:11]) {
    [[self getChildByTag:222] runAction:[CCSpawn actions:[CCSequence actions:[CCFadeTo actionWithDuration:0.3 opacity:255],[CCDelayTime actionWithDuration:0.05f],[CCFadeTo actionWithDuration:0.3f opacity:0], nil],[CCRotateTo actionWithDuration:3.f angle:6000],[CCSequence actions:[CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:0.3f scale:1.4f] rate:2],[CCScaleTo actionWithDuration:0.3f scale:0.9f], nil], nil]].tag = 11;
    }

}

-(void)addSprite
{
    float sc;
    for (int i  = 0; i<=3; i++) {
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"cup%i.png",i]];
        sprite.anchorPoint = ccp(0.5f, 0);
            switch (i) {
                case 0:sprite.position = ccp(self.contentSize.width/2.095,-sprite.contentSize.height/10);sprite.scaleX = 1.05f;[spriteBatchNode addChild:sprite z:i tag:i];break;//back
                case 1:sprite.position = ccp(self.contentSize.width/2,0);[spriteBatchNode addChild:sprite z:i tag:i];break;//head
                case 2:sprite.position = ccp(self.contentSize.width/2,-sprite.contentSize.height/6);[spriteBatchNode addChild:sprite z:i tag:i];break;//mouth
                case 3:if(IS_IPAD){sc = 1.62f;}else{sc = 1.52f;} sprite.position = ccp(self.contentSize.width/sc,sprite.contentSize.height*3);[[spriteBatchNode getChildByTag:1] addChild:sprite z:i tag:i];break;//eays
                default:break;
        }
    }
}

-(void)update:(ccTime)dt
{
    if (cristalCount>=1 && cristalCount <4) {cristalName = @"gem0.png";}
    else if (cristalCount>=4 && cristalCount <7){cristalName = @"gem1.png";}
    else if (cristalCount>=7 && cristalCount <=9){cristalName = @"gem2.png";}
    
    float widthScreen = kWidthScreen;

        if (self.position.x < widthScreen/2)
        {
            float full = widthScreen/2;
            float itemPercentOnScreen = ( self.position.x * 100 ) /  full;
            self.scale = itemPercentOnScreen/100;
        }
        
        else if (self.position.x >= widthScreen/2)
        {
            float pxX = kWidthScreen-self.position.x;
            float itemPercentOnScreen = (pxX * 100) / kWidthScreen;
            self.scale = (itemPercentOnScreen/100)*2;
        }   
}

-(void)createBatchNode
{
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"Level4%@.pvr.ccz",kDevice]];
    [self addChild:spriteBatchNode z:0 tag:0];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"Level4%@.plist",kDevice]];
}

-(id)initWithRect:(CGRect)boxrect_{
    
    if (self =[super init]) {
        cristalCount = 1;
        //openMouth = false;
        [self scheduleUpdate];
        self.contentSize = CGSizeMake(boxrect_.size.width,boxrect_.size.height);
        self.anchorPoint = ccp(self.contentSize.width, self.contentSize.height);
        self.position = ccp(boxrect_.origin.x, boxrect_.origin.y);
    
        [self createBatchNode];
        [self addSprite];
    }
    return self;
}
@end
