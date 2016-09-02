//
//  GoinCharacter.m
//  Zombie Joe
//
//  Created by Mac4user on 4/29/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GoinCharacter.h"
#import "SimpleAudioEngine.h"

#define TAG_ARROW 10
#define TAG_ACTION_ARROW 11

@implementation GoinCharacter
@synthesize body;

-(id)initWithRect:(CGRect)rect tag:(int)_tag{
    
    if((self = [super init]))
    {
        
        self.anchorPoint = ccp(0.5f,0.5f);
        self.contentSize = CGSizeMake(rect.size.width,
                                      rect.size.height);
        
        self.position = ccp(rect.origin.x, rect.origin.y);
        
     //   [cfg addTEMPBGCOLOR:self anchor:ccp(0.5f, 0.5f) color:ccBLUE];
        
         [self addZombieBoy];
        
     //   [[SimpleAudioEngine sharedEngine]preloadEffect:@"lvl5_walking.mp3"];
        
    //     [self schedule:@selector(update:)];

      //   arrow = YES;
        
    }
    return self;
}

-(void)colorAllBodyPartsWithColor:(ccColor3B)c_ restore:(BOOL)restore_ restoreAfterDelay:(float)delay_{
    
        body.color = c_;
    
    if (restore_){
        
        id delay = [CCDelayTime actionWithDuration:delay_];
        
        id block = [CCCallBlock actionWithBlock:^(void){
            
                body.color = ccc3(255, 255, 255);
                
        }];
        
        [body runAction:[CCSequence actions:delay,block, nil]];
        
    }
    
}

-(void)addArrowForZombieInFront{
    
    
    
}

-(void)scaleForever{
    
    id scale =   [CCScaleTo actionWithDuration:0.5f scale:self.scale+0.05f];
    id rescale = [CCScaleTo actionWithDuration:0.5f scale:self.scale-0.05f];
    id seq =     [CCSequence actions:scale,rescale, nil];
    
    [self runAction:[CCRepeatForever actionWithAction:seq]];
    
}


-(CGPoint)getArrowHead{
    
    CGPoint loc =[self convertToWorldSpace:ccp(400,
                                               self.contentSize.height/2)];
    
    return loc;
    
}

- (void)draw {
    
    
    if (arrow) {
        
        glEnable(GL_LINE_SMOOTH);
        
        glLineWidth(3.0f);
        
        glColor4f(0.8, 1.0, 0.76, 1.0);
        
        ccDrawLine(ccp(self.contentSize.width,
                       self.contentSize.height/2),
                   ccp(200,
                       self.contentSize.height/2));
        
    }
  
}

-(void)drawForwardArrow{
    float first = body.boundingBox.size.width*0.6f;
    for (int x = 1; x <= 3; x++)
    {
        CCSprite *arrowPointer = [CCSprite spriteWithSpriteFrameName:@"arrowJoe.png"];
        if (IS_IPHONE)
        {
                    arrowPointer.position = ccp(first+body.boundingBox.size.width*((float)x/2.75f),
                                                body.boundingBox.size.height*0.1f);
        }
        
        else if (IS_IPAD)
        {
            arrowPointer.position = ccp((body.boundingBox.size.width/2)+first+body.boundingBox.size.width*((float)x/2.75f),body.position.y+body.boundingBox.size.height*0.1f);
        }

        arrowPointer.tag = TAG_ARROW+x;
        arrowPointer.scale =                      0.5f;
        if      (x == 2)     arrowPointer.scale = 0.7f;
        else if (x==1)       arrowPointer.scale = 0.9f;
        
        if (![Combinations isRetina])
        {
            arrowPointer.scale = arrowPointer.scale/2;
        }
        
        arrowPointer.visible = NO;
        
        [spritesBgNode addChild:arrowPointer];
//        
//        id fadeOut = [CCFadeTo actionWithDuration:(float)x/5 opacity:0];
//   //     id moveOut = [CCMoveBy actionWithDuration:(float)x/4 position:ccp(body.boundingBox.size.width/3*x, 0)];
//        id spawn1 =  [CCSpawn actions:fadeOut, nil];
//        
//        id fadeIn  = [CCFadeTo actionWithDuration:(float)x/5 opacity:255];
//   //     id moveIn =  [CCMoveBy actionWithDuration:(float)x/4 position:ccp(-body.boundingBox.size.width/3*x, 0)];
//        id spawn2 =  [CCSpawn actions:fadeIn, nil];
//        
//        id seq =[CCSequence actions:spawn1,spawn2, nil];
//        [arrowPointer runAction:[CCRepeatForever actionWithAction:seq]];
        
    }


    [self showArrows];

}

-(void)hideArrows{
    
    [[spritesBgNode getActionByTag:TAG_ACTION_ARROW]stop];
    [spritesBgNode getChildByTag:TAG_ARROW+1].visible = NO;
    [spritesBgNode getChildByTag:TAG_ARROW+2].visible = NO;
    [spritesBgNode getChildByTag:TAG_ARROW+3].visible = NO;
    
    
}

-(void)showArrows{
    
    if ([spritesBgNode getActionByTag:TAG_ACTION_ARROW]) {
        return;
    }
    
    [spritesBgNode getChildByTag:TAG_ARROW+1].visible = NO;
    [spritesBgNode getChildByTag:TAG_ARROW+2].visible = NO;
    [spritesBgNode getChildByTag:TAG_ARROW+3].visible = NO;
    
    id one = [CCCallBlock actionWithBlock:^(void){
        [spritesBgNode getChildByTag:TAG_ARROW+1].visible = YES;
    }];
    id two =
    [CCCallBlock actionWithBlock:^(void){
        [spritesBgNode getChildByTag:TAG_ARROW+2].visible = YES;
    }];
    id three =
    [CCCallBlock actionWithBlock:^(void){
        [spritesBgNode getChildByTag:TAG_ARROW+3].visible = YES;
    }];
    
    id off = [CCCallBlock actionWithBlock:^(void){
        [spritesBgNode getChildByTag:TAG_ARROW+1].visible = NO;
        [spritesBgNode getChildByTag:TAG_ARROW+2].visible = NO;
        [spritesBgNode getChildByTag:TAG_ARROW+3].visible = NO;
    }];
    
    id delay = [CCDelayTime actionWithDuration:0.2f];
    id seq = [CCSequence actions:one,delay,two,delay,three,delay,off,delay, nil];
    [spritesBgNode runAction:[CCRepeatForever actionWithAction:seq]].tag = TAG_ACTION_ARROW;
    

}

-(void)arrowsFadeEffect:(CCNode*)node_{
    

    
}

-(void)ramaMoveBy{
    
    id rotate =         [CCRotateBy actionWithDuration:0.3f angle:self.rotation+5];
    id delay =          [CCDelayTime actionWithDuration:0.2f];
    id rotate_back =    [CCRotateBy actionWithDuration:0.15f angle:self.rotation-5];
    id seq_rot = [CCSequence actions:rotate,rotate_back, nil];
    id foreverMove = [CCRepeatForever actionWithAction:seq_rot];
    [self runAction:foreverMove];
    
}

-(void)ramaMove{

    id rotate =         [CCRotateTo actionWithDuration:0.3f angle:5];
    id delay =          [CCDelayTime actionWithDuration:0.2f];
    id rotate_back =    [CCRotateTo actionWithDuration:0.15f angle:-5];
    id seq_rot = [CCSequence actions:rotate,rotate_back, nil];
    id foreverMove = [CCRepeatForever actionWithAction:seq_rot];
    [self runAction:foreverMove];
    
}

-(void)inlavaAction{
    float d = 30;
    if (IS_IPAD) {
        d=d*1.6f;
    }
    id rotate = [CCRotateBy actionWithDuration:3 angle:360];
    id scale =  [CCScaleTo actionWithDuration:2 scale:0];
    id move =   [CCMoveTo actionWithDuration:1  position:ccp(self.position.x+d, kHeightScreen/2)];
    id spawn =  [CCSpawn actions:rotate,scale,move, nil];
    [self runAction:spawn];
    
}

-(void)reset{
    
    [body stopAllActions];
    
    
}

-(void)ACtion_WalkToSceneAndBack:(float)delay_ pos:(CGPoint)pos_{

    CGPoint posNow = body.position;
    id move = [CCMoveBy actionWithDuration:delay_ position:pos_];
    id moveBack = [CCMoveTo actionWithDuration:delay_ position:posNow];
    id seq = [CCSequence actions:move,moveBack, nil];
    [body runAction:[CCRepeatForever actionWithAction:seq]];

}

-(void)Action_IDLE_SetDelay:(float)delay_ funForever:(BOOL)forever_{
    
    if (delay_==-1) {
        delay_ = 0.2f;
    }
    
    [self reset];
    
    NSMutableArray *animFrames = [NSMutableArray array];
    
    
    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"top_idle_0.png"]];
    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"top_idle_1.png"]];
    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"top_idle_2.png"]];
    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"top_idle_2.png"]];
    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"top_idle_2.png"]];
    
//    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"top_idle.png"]];
//    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"top_2.png"]];
    
    
    
    CCAnimation *animation = [CCAnimation animationWithFrames:animFrames delay:delay_];
    if (forever_) {
        [body runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation restoreOriginalFrame:YES]]];
    }
    else if (!forever_){
        [body runAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:YES]];
    }
    

    
}

-(void)Action_WALK_SetDelay:(float)delay_ funForever:(BOOL)forever_{
    
    if (delay_==-1) {
        delay_ = 0.2f;
    }
    
    [self reset];
    
    NSMutableArray *animFrames = [NSMutableArray array];

        
        [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"top_idle.png"]];
        [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"top_1.png"]];
        [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"top_idle.png"]];
        [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"top_2.png"]];

    
    
    CCAnimation *animation = [CCAnimation animationWithFrames:animFrames delay:delay_];
    if (forever_) {
        [body runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation restoreOriginalFrame:YES]]];
    }
    else if (!forever_){
        [body runAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:YES]];
    }
    
    
}

-(void)addZombieBoy{
    
    NSString *spritesStr =      [NSString stringWithFormat:@"JOE_Top_iPhone"];
    if (IS_IPAD) spritesStr =   [NSString stringWithFormat:@"JOE_Top"];
    
    spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz",spritesStr]];
    [self addChild:spritesBgNode];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache]
     addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist",spritesStr]];

    body = [CCSprite spriteWithSpriteFrameName:@"top_idle.png"];
    body.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
  //  body.opacity = 100;
 //   self.scale = kSCALE_FACTOR_FIX;
    [spritesBgNode addChild:body];
    body.scale = kSCALE_FACTOR_FIX;
    
//    hat = [CCSprite spriteWithSpriteFrameName:@"hat.png"];
//    hat.position = body.position;
//    hat.position = ccp(hat.position.x-hat.boundingBox.size.width*0.4f, hat.position.y+hat.boundingBox.size.height*0.4f);
//    [spritesBgNode addChild:hat];
    
    shadow = [CCSprite spriteWithSpriteFrameName:@"shadow.png"];
    [spritesBgNode addChild:shadow z:-1];
    
    if (![Combinations isRetina]) {
        shadow.scale = 0.5f;
    }
    shadow.anchorPoint = ccp(0.15f,0.25f);
    
}

-(void)hide_shadow:(BOOL)yes_{
    
    shadow.visible = yes_;
    
}

-(void)scaleUpDown{
    
    id scaleUpDown = [CCScaleBy actionWithDuration:0.4f scaleX:0.95f scaleY:0.9f];
    //    id rotate = [CCRotateBy actionWithDuration:0.2f angle:-10];
    //    id rotate2 = [CCRotateBy actionWithDuration:0.2f angle:20];
    id rescale = [scaleUpDown reverse];
    id seq = [CCSequence actions:scaleUpDown,rescale, nil];
    [self runAction:[CCRepeatForever actionWithAction: seq]];
    
}

-(void)spinPropeller_Default:(BOOL)default_{
    
    if (!default_) {
        id spin = [CCRotateBy actionWithDuration:1.f angle:360];
        id variat = [CCEaseBounceOut actionWithAction:spin];
        [hat runAction:[CCRepeatForever actionWithAction: variat]];
    }
    else
    {
    id spin = [CCRotateBy actionWithDuration:0.3f angle:360];
    [hat runAction:[CCRepeatForever actionWithAction: spin]];
    }
    
}

-(void)stopHatAction{
    
    [hat stopAllActions];
    
}

-(void)update:(ccTime)dt{
    
    
}

@end
