//
//  BirdMom.m
//  Zombie Joe
//
//  Created by macbook on 2013-07-02.
//
//

#import "BirdMom.h"
#import "cfg.h"

#define TAG_ACTION_ROTATE1 10
#define TAG_ACTION_ROTATE2 11

@implementation BirdMom

-(id)initWithLoader:(LevelHelperLoader*)loader_ fallowNode:(LHSprite*)nodeFallow_{
    
    if((self = [super init]))
    {
        NodeToFallow = nodeFallow_;
        
        self.position=  NodeToFallow.position;

        [self addMomBody:loader_];
        [self addMomEyes:loader_];
        
        [self addMomWings:loader_];
        
       // [self CreateBubleNotification:loader_];
        
       // self.rotation = -90;
        
        [self MomScaleUpDown];
        [self schedule:@selector(changeRotationScheduler:) interval:3.f];

        
    }
    return self;
    
}

-(void)CreateBubleNotification:(LevelHelperLoader*)loader_{
    
    LHSprite *Bubble = [loader_ createSpriteWithName:@"popup"
                                       fromSheet:@"level_15_spritesSH"
                                      fromSHFile:@"Level15SH" parent:self];
    Bubble.anchorPoint = ccp(0.f, 0.f);
    Bubble.position = ccp(bodyMom.boundingBox.size.width*0.35f, bodyMom.boundingBox.size.height*0.0f);
    
}

-(void)changeRotationScheduler:(ccTime)dt{
    
    if (![self getActionByTag:TAG_ACTION_ROTATE1])
    {
        [self runAction:[self getRotateAction]].tag = TAG_ACTION_ROTATE1;
    }
    
}

-(void)MomScaleUpDown{
    
    id scaleDown = [CCScaleTo actionWithDuration:1.f scaleX:0.9f scaleY:1.f];
    id scaleDef = [CCScaleTo actionWithDuration:1.f scaleX:1.f scaleY:1.f];
    id seq = [CCSequence actions:scaleDown,scaleDef, nil];
    id f_ = [CCRepeatForever actionWithAction:seq];
    [self runAction:f_];
    
}

-(id)getRotateAction{
    
    int ang = [cfg MyRandomIntegerBetween:3 :360];
    
    id rot = [CCRotateTo actionWithDuration:2.f angle:ang];
    id rot_ = [CCEaseBackInOut actionWithAction:rot];
    id rotd = [CCRotateTo actionWithDuration:1.f angle:-ang];
    id rotd_ = [CCEaseBackInOut actionWithAction:rotd];
    id seq = [CCSequence actions:rot_,rotd_, nil] ;
    
    return seq;
    
}


-(void)EyesActionForNode:(LHSprite*)s_{
    
    id OpenEys =   [CCFadeTo actionWithDuration:0.1f opacity:0];
    id CloseEyes = [CCFadeTo actionWithDuration:0.1f opacity:255];
    id seq = [CCSequence actions:OpenEys,[CCDelayTime actionWithDuration:2.f],CloseEyes,[CCDelayTime actionWithDuration:0.15f], nil];
    id forev = [CCRepeatForever actionWithAction:seq];
    [s_ runAction:forev];
    
}

-(void)addWingEffect:(LHSprite*)w_{
    
    id scaleDown = [CCScaleTo actionWithDuration:0.1f scaleX:0.5f scaleY:1];
    id scaleDef =  [CCScaleTo actionWithDuration:0.05f scaleX:1.f scaleY:1];
    
    id seq =  [CCSequence actions:
               scaleDown,scaleDef,
               [CCDelayTime actionWithDuration:0.1f],
               scaleDown,scaleDef,
               [CCDelayTime actionWithDuration:0.5f],
               scaleDown,scaleDef,
               [CCDelayTime actionWithDuration:1.5f],
                nil];
    
    id forev = [CCRepeatForever actionWithAction:seq];
    
    [w_  runAction:forev];
    
}

-(void)addMomWings:(LevelHelperLoader*)loader_{
    
    LHSprite *wL = [loader_ createSpriteWithName:@"birdmother_leftswing"
                                         fromSheet:@"level_15_spritesSH"
                                        fromSHFile:@"Level15SH" parent:self];
    wL.anchorPoint = ccp(1.f, 0.5f);
    wL.position = ccp(-bodyMom.boundingBox.size.width*0.45f, bodyMom.boundingBox.size.width*0.15f);
    
    //
    
    LHSprite *wR = [loader_ createSpriteWithName:@"birdmother_rightwing"
                                       fromSheet:@"level_15_spritesSH"
                                      fromSHFile:@"Level15SH" parent:self];
    wR.anchorPoint = ccp(0.f, 0.5f);
    wR.position = ccp(bodyMom.boundingBox.size.width*0.45f, bodyMom.boundingBox.size.width*0.15f);
    
//    [self reorderChild:wR z:-1];
//    [self reorderChild:wL z:-1];
    
    [self addWingEffect:wR];
    [self addWingEffect:wL];
    
//    id seq = [CCSequence actions:[CCDelayTime actionWithDuration:0.2f],
//             [CCCallFuncO actionWithTarget:self selector:@selector(addWingEffect:) object:wR],
//             [CCDelayTime actionWithDuration:0.2f],
//             [CCCallFuncO actionWithTarget:self selector:@selector(addWingEffect:) object:wL],nil];
//    
//    [self runAction:seq];
    
}

-(void)addMomEyes:(LevelHelperLoader*)loader_{
    
    bodyMom = [loader_ createSpriteWithName:@"birdmother"
                                         fromSheet:@"level_15_spritesSH"
                                        fromSHFile:@"Level15SH" parent:self];
    bodyMom.position = ccp(0, 0);
    
}

-(void)addMomBody:(LevelHelperLoader*)loader_{
    
    LHSprite *body = [loader_ createSpriteWithName:@"birdmother_eyes"
                                         fromSheet:@"level_15_spritesSH"
                                        fromSHFile:@"Level15SH" parent:self];
    
    body.position = ccp(-body.boundingBox.size.width*0.05f, -body.boundingBox.size.height*0.385f);
    [self reorderChild:body z:1];
    [self EyesActionForNode:body];
    
}

-(LHSprite*)myFallower{
    
    return NodeToFallow;
    
}

- (void) dealloc
{
	[super dealloc];
}

@end
