//
//  SliderPart.m
//  Zombie Joe
//
//  Created by Mac4user on 4/29/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SliderPart.h"
#import "cfg.h"
#import "Constants.h"
#import "constants_l5.h"
#import "BrainsBonus.h"

#define kSHAKETAG 10
#define kArrowTag 20

#define collumsZ 0
#define arrowsZ  1

#define USE_ARROWS  0
#define USE_VIBRATE 0

@implementation SliderPart

@synthesize trackArea;
//@synthesize delegate;
@synthesize trackAreaBrain  ;
@synthesize spritesBgNode;
@synthesize speed;
@synthesize touching;
@synthesize movable;

-(id)initWithRect:(CGRect)rect tag:(int)_tag{
    
    if((self = [super init]))
    {
        
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        self.tag = _tag;
        
        collumnNr = _tag - col_Tag;
        
        self.anchorPoint = ccp(0.5f,0.5f);
        self.contentSize = CGSizeMake(rect.size.width,
                                      rect.size.height);
        
        self.position = ccp(rect.origin.x, rect.origin.y);
        
  
     //
        //NSLog(@"add track with tag %i",self.tag);
        
        if (collumnNr==1 || collumnNr==2 || collumnNr==3 || collumnNr==4 || collumnNr==6)
        {
            NSString *spritesStr =      [NSString stringWithFormat:@"arrows_Effect_iPhone"];
            if (IS_IPAD) spritesStr =   [NSString stringWithFormat:@"arrows_Effect"];
            
            otherBatchnode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz",spritesStr]];
            [self addChild:otherBatchnode z:arrowsZ];
            
            [[CCSpriteFrameCache sharedSpriteFrameCache]
             addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist",spritesStr]];
            
        }
        
        
        if (collumnNr != 0 && collumnNr != 7)
        {
            NSString *spritesStr =      [NSString stringWithFormat:@"sprites_level5_iPhone"];
            if (IS_IPAD) spritesStr =   [NSString stringWithFormat:@"sprites_level5"];
            
            spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz",spritesStr]];
            [self addChild:spritesBgNode z:collumsZ];
            
            [[CCSpriteFrameCache sharedSpriteFrameCache]
             addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist",spritesStr]];
            
        //    NSLog(@"%@",[NSString stringWithFormat:@"slide%i.png",collumnNr-1]);
            Slider = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"slide%i.png",collumnNr-1]];
            Slider.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
            Slider.scale = kSCALE_FACTOR_FIX;
            Slider.opacity = 255;
           // Slider.scale = Slider.scale*0.95f;
            [spritesBgNode addChild:Slider];
            
        }
        

            [self addTrack];
        
            if (self.tag !=col0 && self.tag != col7)
            {
                 movable = YES;
                 moveUP = YES;
                touchable = YES;
                
           }
        
        [self scheduleUpdate];
        
        if (movable)
        {
            if (USE_VIBRATE) [self vibrate];
            
            posMax = [cfg MyRandomIntegerBetween:0 :100];
            
            if (collumnNr==1 && collumnNr==2)
            {
                directionUP = [self giveMeDirection:self.tag-col_Tag];
            }
            
            else directionUP = [cfg MyRandomIntegerBetween:0 :1];
            
            speed =       [self giveMeSpeedBySliderNr:self.tag-col_Tag]*0.75f;
            //
            

         //   [self scheduleUpdate];
            
            
            
        }
        
        if (IS_IPAD)    [self vibrate];
        
        //     [cfg addTEMPBGCOLOR:self anchor:ccp(0.5f, 0.5f) color:ccGREEN];
        
    }
    return self;
}

-(void)MANA_ON{
    
    speed = speed/20;
    
}

-(void)MANA_OFF{
    
    speed = speed*20;
    
}

-(void)getSpeed{
    
    
    
}


-(void)update:(ccTime)dt{
    
    if (touching || !movable) {
        return;
    }
    
    if (directionUP)
    {
        self.position = ccpAdd(self.position, ccp(0, 1.f+(speed)));
    }
    else if (!directionUP)
    {
        self.position = ccpAdd(self.position, ccp(0, -1.f-(speed)));
    }
    
    [self checkPositionMax];

}

-(void)checkPositionMax{
    
    if (self.position.y >= (kHeightScreen)-posMax)//kHeightScreen)
    {
        directionUP = NO;
    }
    else if (self.position.y <= posMax)//0)
    {
        directionUP = YES;
    }
    
}

-(float)giveMeDirection:(int)slider_{
    
    if      (slider_==1) directionUP = 0;
    else if (slider_==2) directionUP = 1;
    else if (slider_==3) directionUP = 1;
    else if (slider_==4) directionUP = 0;
    else if (slider_==5) directionUP = 1;
    else if (slider_==6) directionUP = 0;
    
    return directionUP;
}

-(float)giveMeSpeedBySliderNr:(int)slider_{

    if      (slider_==1) speed = 1;
    else if (slider_==2) speed = 2;
    else if (slider_==3) speed = 3;
    else if (slider_==4) speed = 4;
    else if (slider_==5) speed = 6;
    else if (slider_==6) speed = 8;
    
    if (IS_IPHONE)
    {
        speed=speed/3;
    }
    return speed/20;//speed;
}

-(void)vibrate{
    
    int rand = [cfg MyRandomIntegerBetween:1 :10];
    float randF= (float)rand/100;
    
    self.scale = 1.0f;
    id menuItem1ActRight= [CCScaleTo actionWithDuration:0.075f+(randF) scaleX:1.01f-((randF)/10) scaleY:1.005f];
    id menuItem1ActLeft=  [CCScaleTo actionWithDuration:0.075f-(randF) scaleX:1.0f scaleY:1.0f];
    id seq =              [CCSequence actions:menuItem1ActLeft,menuItem1ActRight, nil];
    
//    CCAction *shake =     [CCRepeatForever actionWithAction:seq];
//    shake.tag = kSHAKETAG;
    
    [self runAction:[CCRepeatForever actionWithAction:seq]].tag = kSHAKETAG;
}

-(void)moveMe_direction:(BOOL)up_{
    
    if (up_) {

    }
    
}


//-(void)update:(ccTime)dt{
//    
//
//    
////    if (movable) {
////        
////        self.position = ccpAdd(self.position, ccp(self.position.x, 1/100.f));
////    }
//    
//}

- (CGRect)rect
{
	CGSize s =  self.displayedFrame.rect.size;//[self.texture contentSize];
   // NSLog(@"rect called");
	return CGRectMake(-s.width / 2, -s.height / 2, s.width, s.height);
}
//    if (collumnNr==4)
//    {
//        trackAreaBrain= [[[CCSprite alloc]init]autorelease];
//
//        float h_ = self.contentSize.height/12;
//        float w_ = self.contentSize.width;
//
//        float y_ = -1000;//y = 13.7f * h/2;
//
//        if (collumnNr==4)  y_ = 13.7f * h_/2;
//
//
//        [trackAreaBrain setTextureRect:CGRectMake(0, 0, w_,h_)];
//        trackAreaBrain.position = ccp(w_/2,y_+(h_/2));
//
//        trackAreaBrain.anchorPoint = ccp(0.5f,0.5f);
//
//        [self addChild:trackAreaBrain z:0 tag:SliderTrackAreaBrain];
//        trackAreaBrain.color = ccRED;
//    }

-(void)addBrain_Pos:(CGPoint)pos_ forCol:(int)col_{
    
    if (col_==5)
    {
        BrainsBonus *BRAIN = [[BrainsBonus alloc]initWithRect:CGRectMake(0, 0, 100*kSCALE_FACTOR_FIX, 200*kSCALE_FACTOR_FIX)];
        [self addChild:BRAIN z:30 tag:BRAIN_BONUS_TAG];
        BRAIN.position= pos_;
        if (IS_IPAD) {
            BRAIN.position = ccpAdd(BRAIN.position, ccp(0, -10));
        }
        BRAIN.scale = 1.25f;
      //  BRAIN.color = ccRED;
        [BRAIN moveUpDown_particles:NO];
    }
    
}

-(void)addTrack{

    trackArea = [[[CCSprite alloc]init]autorelease];
    
    float h = self.contentSize.height/12;
    float w = self.contentSize.width;
    
    float y_yellow =    collumnNr * h/2;
    float y_blue =      collumnNr * h/2;
    float y_green =     collumnNr * h/2;
    float y_trap  =     collumnNr * h/2;
    
    if (collumnNr==0 || collumnNr==7)
    {
        y_yellow = self.contentSize.height/2-(w/2);
    }
    else
        switch (collumnNr) {
            case 1:
                y_yellow =  9.f     * h/2;
                y_blue =    14.25f  * h/2;
                y_green =   6.5f    * h/2;
                break;
            case 2:
                 y_yellow =     12.8f * h/2;
                 y_blue =       8.2f * h/2;
                 y_trap =       10.8f * h/2;
                //no green
                break;
            case 3:
                y_yellow =  7.9f * h/2;
                y_blue =    10.8f * h/2;
                y_green =   15.f * h/2;
                break;
            case 4:
                 y_yellow =     7.f * h/2;
                 y_blue =       13.75f * h/2;
                 y_green =      11.2f * h/2;
                 y_trap =       12.5f * h/2;
                break;
            case 5:
                y_yellow =  8.8f * h/2;
                y_green =   13.8f * h/2;
                y_trap =    11.8f * h/2;
                // no blue
                break;
            case 6:
                 y_yellow =  13.2f * h/2;
                 y_blue =    10.5f * h/2;
                break;
            default:
                break;
        }
    
    if (collumnNr!=0 &&
        collumnNr!=7 &&
        collumnNr !=5)
    {
        //add BLUE TRACK
        CCSprite *track = [[[CCSprite alloc]init]autorelease];
        [track setTextureRect:CGRectMake(0, 0, w,h)];
        track.position = ccp(w/2,y_blue+(h/2));
        
        track.anchorPoint = ccp(0.5f,0.5f);
        track.color = ccBLUE;
        track.opacity = 0;
        [self addChild:track z : 0 tag:SliderTrackAreaTagBLUE];
        
        if (IS_IPAD) [self addArrows_forPos:track.position width:track.boundingBox.size.width];
        
    }
    
    if (collumnNr == 2 || collumnNr == 5) {
        //add SliderTrackAreaTagTRAP
        CCSprite *track = [[[CCSprite alloc]init]autorelease];
        [track setTextureRect:CGRectMake(0, 0, w,h)];
        track.position = ccp(w/2,y_trap+(h/2));
        
        track.anchorPoint = ccp(0.5f,0.5f);
        track.color = ccRED;
        track.opacity = 0;
        
        track.scale =(IS_IPAD) ? 0.85f : 0.85f;
        track.scaleX = 0.45f;
        
        if (IS_IPAD)
        {
            track.position = ccpAdd(track.position, ccp(0, 22.5f));
        }
        if (IS_IPHONE) {
            track.position = ccpAdd(track.position, ccp(0, 6.5f));
        }
        [self addChild:track z : 0 tag:SliderTrackAreaTagTRAP];
        
        CCSprite *trap = [CCSprite spriteWithSpriteFrameName:@"traps_0.png"];
        trap.position = ccp(w/2,y_trap+(h/2));
        trap.anchorPoint = ccp(0.5f,0.5f);
        [spritesBgNode addChild:trap z:100 tag:SliderTrackAreaTagTRAP+collumnNr];
        trap.scale = kSCALE_FACTOR_FIX;
        //tag:SliderTrackAreaTagTRAP];
        
    }
    
    if (collumnNr==1 ||
        collumnNr==3 ||
        collumnNr==4 ||
        collumnNr==5)
    {
        //add GREEN TRACK
        CCSprite *track = [[[CCSprite alloc]init]autorelease];
        [track setTextureRect:CGRectMake(0, 0, w,h)];
        track.position = ccp(w/2,y_green+(h/2));
        
        track.anchorPoint = ccp(0.5f,0.5f);
        track.color = ccGREEN;
        track.opacity = 0;
        [self addChild:track z : 0 tag:SliderTrackAreaTagGREEN];
        
        if (collumnNr==5)
        {
          // [self addBrain_Pos:track.position forCol:5];
            
        }
        
    }
    
    //YELLOW TRACKS
    [trackArea setTextureRect:CGRectMake(0, 0, w,h)];
    trackArea.position = ccp(w/2,y_yellow+(h/2));
    
    trackArea.anchorPoint = ccp(0.5f,0.5f);
    trackArea.color = ccYELLOW;

    trackArea.opacity = 0;
    trackAreaBrain.opacity = 200;
    
    [self addChild:trackArea z:0 tag:SliderTrackAreaTagYELLOW];
    
   // [self closeTRAP];
    
}

-(void)closeTRAP{
    
  //  if (id_==1) {
       //   CCSpriteFrameCache* cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        
        CCSprite *trap = (CCSprite*)[spritesBgNode getChildByTag:SliderTrackAreaTagTRAP+collumnNr];
        NSString* newSprite = @"traps_1.png";
        CCSpriteFrameCache* cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [trap setDisplayFrame:[cache spriteFrameByName:newSprite]];

  //  }
//    if (id_==2) {
//        CCSprite *trap = (CCSprite*)[spritesBgNode getChildByTag:SliderTrackAreaTagTRAP+5];
//        CCSpriteFrameCache* cache = [CCSpriteFrameCache sharedSpriteFrameCache];
//        CCSpriteFrame* frame = [cache spriteFrameByName:@"trap_1.png"];
//        [trap setDisplayFrame:frame];
//      //  trap.visible = NO;
//    }
    
}

-(void)addArrows_forPos:(CGPoint)pos_ width:(float)w_{
    
    for (int x = 0; x < 3; x++)
    {
          CCSprite * arrow = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"arrow_%i.png",x]];
        
        if (x==0) {
                arrow.position = ccp(pos_.x-(w_*0.33f),pos_.y);
        }
       else  if (x==1)
       {
            arrow.position = ccp(pos_.x-(w_*0.025f),pos_.y);
       }
       else  if (x==2)
       {
           arrow.position = ccp(pos_.x+(w_*0.225f),pos_.y);
       }
        
        [otherBatchnode addChild:arrow z:1 tag:kArrowTag+x];
        arrow.opacity = 255;
        
        [self performSelector: @selector(startBlinking:)
                   withObject: [otherBatchnode getChildByTag:kArrowTag+x]
                   afterDelay: (float)x/5];
        
    }
    
    //add fadeInOutAction
    
}



-(void)startBlinking:(CCNode*)node_{
    
    id fadeIn =  [CCFadeTo actionWithDuration:0.125f opacity:255];
    id fadeOut = [CCFadeTo actionWithDuration:0.125f opacity:0];
    
    id delay =   [CCDelayTime actionWithDuration:0.375f];

    id seq_a =   [CCSequence actions:fadeIn,fadeOut,delay, nil];
    
    [node_ runAction:[CCRepeatForever actionWithAction:seq_a]];
    
}

-(void)tintToRed{
    if (tint) {
        return;
    }
    tint = YES;
    [Slider runAction: [CCTintBy actionWithDuration:3.f red:255 green:0 blue:0]];
    
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

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    
    //NSLog(@"touched %i",self.tag);
    
    if (!movable || touching || !touchable) {
        return NO;
    }
    
    NSSet *allTouches = [event allTouches];
    for (UITouch *aTouch in allTouches) {
        
        if ( ![self containsTouchLocation:aTouch] ) return NO;
        
    }
    
    touching = YES;
    
  //  [self stopAllActions];
    
   // [self unschedule:@selector(move:)];
    
    CGPoint location = [touch locationInView:[touch view]];
    
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    whereTouch=ccpSub(self.position, location);
    
    return YES;
    
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
    CGPoint location = [touch locationInView:[touch view]];
    
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    self.position=ccpAdd(ccp(self.position.x, location.y),ccp(0, whereTouch.y));
        
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
    CGPoint location = [touch locationInView:[touch view]];
    
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    touching = NO;
    
   // [self schedule:@selector(move:)];
    
   // [self startMoving:NO];

}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{
    
     touching = NO;
    
}
 

- (void)onEnter{
    
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [super onEnter];
    
}

- (void)onExit{
    
     [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    
     [self removeAllChildrenWithCleanup:YES];
    
    spritesBgNode    = nil;
    trackArea= nil;
    trackAreaBrain = nil;
 //   delegate = nil;
    
    [super onExit];
    
}

@end
