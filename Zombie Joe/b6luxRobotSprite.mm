//
//  b6lRobot.m
//  Zombie Joe
//
//  Created by macbook on 2013-07-05.
//
//

#import "b6luxRobotSprite.h"
#import "cfg.h"

#define MAX_STATES           100

#define TAG_ACTION_EYESBLINK 100
#define TAG_ACTION_MAIN      101

@implementation b6luxRobotSprite
@synthesize uniqueNamePrefix;
@synthesize robotCanScale,robotCanRotate;

+(id)initRobotWithLoader:(LevelHelperLoader*)loader_
          uniqNamePrefix:(NSString*)prefix_
              fallowNode:(LHSprite*)nodeFallow_
{
    b6luxRobotSprite* sprite = [[[b6luxRobotSprite alloc]loadRobotWithLoader:loader_
                                                              uniqNamePrefix:prefix_
                                                                  fallowNode:nodeFallow_]autorelease];
    return sprite;
    
}

-(id)loadRobotWithLoader:(LevelHelperLoader*)loader_
          uniqNamePrefix:(NSString*)prefix_
              fallowNode:(LHSprite*)nodeFallow_
{
if((self = [super init]))   {

    RobotPartNames = [[NSMutableDictionary alloc]init];
    RobotPoints    = [[NSMutableDictionary alloc]init];
    RobotRotations = [[NSMutableDictionary alloc]init];
    RobotScaleX_Y =  [[NSMutableDictionary alloc]init];
    
    AnimationPriority   = [[NSMutableDictionary alloc]init];
    AnimationDurations  = [[NSMutableDictionary alloc]init];
    
    RobotPartsEnableAnimation = [[NSMutableDictionary alloc]init];
    
    loader =            loader_;
    uniqueNamePrefix =  prefix_;
    
    robotCanFallowNode  = YES;
    
    robotCanMove        = YES;
    robotCanRotate      = YES;
    robotCanScale       = YES;
    
        if (nodeFallow_!=nil)
        {
              NodeToFallow =      nodeFallow_;
              self.position =     NodeToFallow.position;
              self.rotation =     NodeToFallow.rotation;
        }

    }
    
    return self;
}

-(void)ACTION_ShowContentSize{
    
     [cfg addTEMPBGCOLOR:self anchor:self.anchorPoint color:ccRED];
    
}

-(void)ACTION_SetContentSize:(CGSize)size_{
    
    
    self.contentSize = size_;
    
    for (CCNode *n in [self children]) {
        n.position= ccpAdd(n.position,ccp(self.contentSize.width/2, self.contentSize.height/2));
    }
    
}

-(void)colorAllBodyPartsWithColor:(ccColor3B)c_ part:(int)x_ all:(BOOL)all_ restore:(BOOL)restore_ restoreAfterDelay:(float)delay_{
    
    if (all_) {
        for (int x = 0; x < robotParts; x++)
        {
            CCSprite *s = (CCSprite*)[self getChildByTag:x];
            s.color = c_;
        }
    }
    else
    {
            CCSprite *s = (CCSprite*)[self getChildByTag:x_];
            s.color = c_;
    }

    if (restore_){
        
        id delay = [CCDelayTime actionWithDuration:delay_];
        
        id block = [CCCallBlock actionWithBlock:^(void){
            
            if (all_) {
                for (int x = 0; x < robotParts; x++)
                {
                    CCSprite *s = (CCSprite*)[self getChildByTag:x];
                    s.color = ccc3(255, 255, 255);
                }
            }
            
            else if (!all_){
                
                CCSprite *s = (CCSprite*)[self getChildByTag:x_];
                s.color = ccc3(255, 255, 255);
                
            }
            
        }];
        
        [self runAction:[CCSequence actions:delay,block, nil]];
        
    }

}

-(CGSize)getNowScaleXYValuesByPart:(int)part_{
    
    return CGSizeMake([self getChildByTag:part_].scaleX, [self getChildByTag:part_].scaleX);
    
}

-(CGSize)getScaleXYWithState:(int)state_ partNumber:(int)part_{
    
        return [[[RobotScaleX_Y objectForKey:[NSString stringWithFormat:@"%i",state_]]objectAtIndex:part_]CGSizeValue];
    
}

-(int)getRotationWithState:(int)state_ partNumber:(int)part_{
    
    return [[[RobotRotations objectForKey:[NSString stringWithFormat:@"%i",state_]]objectAtIndex:part_]integerValue];
                 
}

-(CGPoint)getPartPointWithState:(int)state_ partNumber:(int)part_{
    
    return [[[RobotPoints objectForKey:[NSString stringWithFormat:@"%i",state_]]objectAtIndex:part_]CGPointValue];
    
}

// *** Will return NO if a) values were the same before; b) the setting values are not correct

-(BOOL)ACTION_SetAnimationState:(int)state_ priority:(int)prio_ duration:(float)time_{
    
    if (![self ifRobotPartsValid] || ![self ifStateIsAvailable:state_])
    {
        NSLog(@"WARNING! -> State, prioirty an time will not be set (Check state and prioirty values)");
        return NO;
    }
    
    //  * check if state and priority is not overriten
    int   stateForPrio = [[AnimationPriority  objectForKey: [NSNumber numberWithInt:prio_]]intValue];
    float duratForPrio = [[AnimationDurations  objectForKey:[NSNumber numberWithInt:prio_]]floatValue];
    
    if (stateForPrio==state_ && duratForPrio == time_ ) {
     //   NSLog(@"values are the same -> return NO");
        return NO;
    }
    
    [AnimationPriority  setObject:[NSNumber numberWithInt:state_]   forKey:[NSNumber numberWithInt:prio_]];
    [AnimationDurations setObject:[NSNumber numberWithFloat:time_]  forKey:[NSNumber numberWithInt:prio_]];
    
//    NSLog(@"animations priorities %@. Durations %@",AnimationPriority,AnimationDurations);
    
    return YES;
    

    
}

-(void)makeOpacityForPart:(int)part_ opacity:(float)op_{
    
        CCSprite *s = (CCSprite*)[self getChildByTag:part_];
        s.opacity = op_;

}

-(void)makeOpacityOfAllParts:(float)op_{
    
    for (int x = 0; x < robotParts; x++)
    {
        CCSprite *s = (CCSprite*)[self getChildByTag:x];
        s.opacity = op_;
    }
    
}

-(void)ACTION_StopAnimationForPart:(int)part_{

    CCSprite *s = (CCSprite*)[self getChildByTag:part_];
    [s stopAllActions];
    
}

-(void)ACTION_RemoveStateByID:(int)state_{
    
    if (![AnimationPriority objectForKey:[NSNumber numberWithInt:state_]] ||
        ![AnimationDurations objectForKey:[NSNumber numberWithInt:state_]]) {
        return;
    }
 //   NSLog(@"before %@,",AnimationPriority);
    [AnimationPriority removeObjectForKey:[NSNumber numberWithInt:state_]];
    [AnimationDurations removeObjectForKey:[NSNumber numberWithInt:state_]];
 //    NSLog(@"after %@,",AnimationPriority);
    
}

-(void)ACTION_StopAllPartsAnimations_Clean:(BOOL)clean_{
    
    if (clean_)
    {
        [AnimationPriority removeAllObjects];
        [AnimationDurations removeAllObjects];
    }
    
    for (int x = 0; x < robotParts; x++)
    {
        [[self getChildByTag:x]stopActionByTag:TAG_ACTION_MAIN];
    }
    
//    NSLog(@"animations priorities %@. Durations %@",AnimationPriority,AnimationDurations);
}

-(void)ACTION_FlipRobot_X:(BOOL)x_ Y:(BOOL)y_ duration:(float)d_{
    
    int x;
    int y;
    
    if (x_)  {
        if (self.scaleX < 0) {
            x = self.scaleX;
        }
        else x = -self.scaleX;
    }
    
     else if (!x_){
         if (self.scaleX < 0) {
             x = -(self.scaleX);
         }
         else x = self.scaleX;
     }
    
    if (y_)  {
        if (self.scaleY < 0) {
            y = self.scaleY;
        }
        else y = -self.scaleY;
    }
    else if (!y_){
        if (self.scaleY < 0) {
            y = -(self.scaleY);
        }
        else y = self.scaleY;
    }
    
    [self runAction:[CCScaleTo actionWithDuration:d_ scaleX:x scaleY:y]];
    
}

-(void)ACTION_UPDATE_ANIMATION_Between_State1:(int)state1_ State2_:(int)state2_ percent:(float)percent_{
    
  //  [self ACTION_StopAllPartsAnimations_Clean:NO];
    
    if ([AnimationPriority count] < 1)
    {
     //   NSLog(@"WARNING -> Could not play animation because Animation Priority value is %i",[AnimationPriority count]);
        return;
    }
    
    for (int x = 0; x < robotParts; x++)
    {
        //move
        CGPoint x1 =    [self getPartPointWithState:state1_   partNumber:x];
        CGPoint x2 =    [self getPartPointWithState:state2_   partNumber:x];
        
        CGPoint movePt;
        float dist = ccpDistance(x1, x2);
        dist = dist*(percent_/100);
        float angle = ccpAngle(x1, x2);
        
        CGPoint destination  = ccp(dist*(cos(-CC_DEGREES_TO_RADIANS(angle))),
                                   dist*(sin(-CC_DEGREES_TO_RADIANS(angle))));
        
        movePt = ccpAdd(x1, destination);
        
        /*
        CGPoint movePt = ccpMult(ccpAdd(x1, x2), (percent_/100));
        */
        
        //rotate
        float r1 =      [self getRotationWithState:state1_    partNumber:x];
        float r2 =      [self getRotationWithState:state2_    partNumber:x];
        float rotateVal = (r1+r2)*(percent_/100);
 
      //  NSLog(@"percent point is %f %f",movePt.x,movePt.y);
        
        float startAngle_ = r1;
        float dstAngle_   = r2;
        
        if (startAngle_ > 0)
            startAngle_ = fmodf(startAngle_, 360.0f);
        else
            startAngle_ = fmodf(startAngle_, -360.0f);
        
      CGFloat  diffAngle_ =dstAngle_ - startAngle_;
        
        if (diffAngle_ > 180)
            diffAngle_ -= 360;
        if (diffAngle_ < -180)
            diffAngle_ += 360;
        
        float rotateTo =startAngle_+((diffAngle_)*(percent_/100));
        
        [self getChildByTag:x].rotation = rotateTo;
        [self getChildByTag:x].position = movePt;
        
     //   NSLog(@"rotate to %f",rotateTo);

    }
    
}

-(void)ACTION_PlayAnimation_Repeat:(BOOL)repeat_{
    
    if ([AnimationPriority count] < 1) {
    //    NSLog(@"WARNING -> Could not play animation because Animation Priority value is %i",[AnimationPriority count]);
        return;
    }
    
    for (int x = 0; x < robotParts; x++){
        
        NSMutableArray *a =[[NSMutableArray alloc]init];
        for (int p = 0; p < [AnimationPriority count]; p ++)     // *** from highest priority p
        {                                 
            int state =     [[AnimationPriority objectForKey: [NSNumber numberWithInt:p]]intValue]; // *** state for priority
            float time =    [[AnimationDurations objectForKey:[NSNumber numberWithInt:p]]floatValue];
            
            CGSize  scaleTo  =    [self getScaleXYWithState:state     partNumber:x];
            float   rotateTo =    [self getRotationWithState:state    partNumber:x];
            CGPoint moveTo   =    [self getPartPointWithState:state   partNumber:x];
            
            [a addObject:[self MoveRotateTo:moveTo
                                     rotate:rotateTo
                                      scale:scaleTo
                               withDuration:time]];
            
        }
        
        id seq = [CCSequence actionsWithArray:a];
        
        [a release];
        
        if (repeat_)
        {
              [[self getChildByTag:x]runAction:[CCRepeatForever actionWithAction:seq]].tag = TAG_ACTION_MAIN;
        }
        else  [[self getChildByTag:x]runAction:seq].tag = TAG_ACTION_MAIN;
        
    }
    
}

-(id)MoveTo:(CGPoint)pos_ withDuration:(float)d_{
    
    id move =  [CCMoveTo actionWithDuration:d_ position:pos_];
    return move;
}

-(id)MoveRotateTo:(CGPoint)pos_ rotate:(int)r_  scale:(CGSize)scalexy_ withDuration:(float)d_{
    
    id move =    (robotCanMove)   ? [CCMoveTo actionWithDuration:d_ position:pos_] : [CCDelayTime actionWithDuration:0];
    id rotate =  (robotCanRotate) ? [CCRotateTo actionWithDuration:d_ angle:r_]    : [CCDelayTime actionWithDuration:0];
    id scaleTo = (robotCanScale)  ? [CCScaleTo actionWithDuration:d_
                                                           scaleX:scalexy_.width
                                                           scaleY:scalexy_.height] : [CCDelayTime actionWithDuration:0];
    
    id spawn =   [CCSpawn actions:move,rotate,scaleTo, nil];
    return spawn;
}

-(LHSprite*)PART:(int)t_{
    
    return (LHSprite*)[self getChildByTag:t_];
    
}

-(void)ACTION_CLOSE_EYES_eyesTag:(int)eyes_{
    
    [[self PART:eyes_] stopActionByTag:TAG_ACTION_EYESBLINK];
    [self makeOpacityForPart:eyes_ opacity:255];
 
}

-(void)ACTION_EyesBlink_WithObject:(id)eyes_ openedTime:(float)opened_ closedTime:(float)closed_ startRandomly:(BOOL)randomLy durationOpen:(float)dur_open durationClose:(float)dur_close blinkTimes:(int)blinkTimes{

    //open prevent eys
    CCSprite *ey = eyes_;
    ey.opacity = 0;
    
    if ([eyes_ getActionByTag:TAG_ACTION_EYESBLINK])
    {
        [eyes_ stopActionByTag:TAG_ACTION_EYESBLINK];
    }
    
        id OpenEys =   [CCFadeTo actionWithDuration:dur_open opacity:0];
        id CloseEyes = [CCFadeTo actionWithDuration:dur_close opacity:255];
    
    id forev;
    
    if (blinkTimes == 1)
    {
        id seq =        [CCSequence actions:OpenEys,
                        [CCDelayTime actionWithDuration:opened_],
                        CloseEyes,
                        [CCDelayTime actionWithDuration:closed_], nil];
        
           forev = [CCRepeatForever actionWithAction:seq];
    }
    else {

            id seq0 =       [CCSequence actions:CloseEyes,
                            [CCDelayTime actionWithDuration:dur_close],
                            OpenEys,
                            [CCDelayTime actionWithDuration:dur_open], nil];
        
            id seq = [CCRepeat actionWithAction:seq0 times:blinkTimes];
        
            id seqF = [CCSequence actions:[CCDelayTime actionWithDuration:1.f],seq,[CCDelayTime actionWithDuration:opened_], nil];
        
            forev = [CCRepeatForever actionWithAction:seqF];
   
    }
 
    
    if (!randomLy) {
         [eyes_ runAction:forev].tag = TAG_ACTION_EYESBLINK;
    }
    else if (randomLy){
        
         [eyes_ runAction:forev].tag = TAG_ACTION_EYESBLINK;
         [eyes_ pauseSchedulerAndActions];
         id delay = [CCDelayTime actionWithDuration:[cfg MyRandomIntegerBetween:1 :5]];
         id resume = [CCCallBlock actionWithBlock:^(void){ [eyes_ resumeSchedulerAndActions]; }];
         [self runAction:[CCSequence actions:delay,resume, nil]];
    }
    

}

-(CGPoint)getCenterPointByState:(int)state_{
    
    return [loader spriteWithUniqueName:[NSString stringWithFormat:@"%@_%i_%@",uniqueNamePrefix,state_,suffix_POINT_CENTER]].position;
  
}

-(CGPoint)getPositionDifferenceWithPoints_p1:(CGPoint)p1_ p2_:(CGPoint)p2_{
    
    CGFloat xDist = (p2_.x - p1_.x);
    CGFloat yDist = (p2_.y - p1_.y);
    
    return CGPointMake(xDist, yDist);
    
}

-(BOOL)ifStateIsAvailable:(int)state_{
    
    int count = [RobotPartNames count];
    if (state_ >= count) {
       //  NSLog(@"ERROR -> main robot part state is not valid < %i > .",state_);
        return NO;
    }
    if (count < 1) {
       // NSLog(@"ERROR -> robot parts sum is not valid < %i > !",count);
        return NO;
    }
    return YES;
}

-(BOOL)ifRobotPartsValid{
    
    if (!RobotPartNames) {
      //  NSLog(@"ERROR! -> no robot parts yet allocated . Use [ createRobotWithStatesSum ] method first");
        return NO;
    }
    return YES;
}

-(void)createRobotCostumePartsWithMainState:(int)stateMain_{
    
    //*** main nr is valid check

    [self ifRobotPartsValid];
    
    int count = [RobotPartNames count];
    
    if (stateMain_ >= count) {
     //   NSLog(@"ERROR -> main robot part state is not valid < %i > .",stateMain_);
        if (count < 1) {
     //       NSLog(@"ERROR -> robot parts sum is not valid < %i > !",count);
        }
        else{
           stateMain_ = 0;  //*** 0 is first
      //      NSLog(@"WARNING ! -> Setting the default robot state to 1");
        }
    }
    
     CGPoint centerPoint = [self getCenterPointByState:stateMain_];
    
    for (int x = 0; x < robotParts; x++)
    {
        LHSprite *s =    [loader spriteWithUniqueName:[[RobotPartNames objectForKey:[NSString stringWithFormat:@"%i",stateMain_]] objectAtIndex:x]];
        
    
        CGPoint pos = [self getPositionDifferenceWithPoints_p1:centerPoint p2_:s.position];
        
            LHSprite *part = [loader createSpriteWithName:s.shSpriteName
                                                fromSheet:s.shSheetName
                                               fromSHFile:s.shSceneName parent:self];
            part.position = pos;
            part.tag = x;
            part.rotation = s.rotation;
            part.flipX = s.flipX;
            part.flipY = s.flipY;
            [self reorderChild:part z:s.zOrder];

    }

}

-(void)createRobotPartsPointsAndRotations{
    
    for (int y = 0; y < robotStates; y++) {
        
        NSMutableArray *a = [[NSMutableArray alloc]init];
        NSMutableArray *r = [[NSMutableArray alloc]init];
        NSMutableArray *sc = [[NSMutableArray alloc]init];
        
        CGPoint centerPoint = [self getCenterPointByState:y];
        
        for (int x = 0; x < robotParts; x++)
        {
            LHSprite *s =    [loader spriteWithUniqueName:[[RobotPartNames objectForKey:[NSString stringWithFormat:@"%i",y]] objectAtIndex:x]];
            CGPoint pos = [self getPositionDifferenceWithPoints_p1:centerPoint p2_:s.position];

            //***** points add
            [a addObject: [NSValue valueWithCGPoint:pos]];
            [r addObject: [NSNumber numberWithInt:s.rotation]];
            [sc addObject:[NSValue valueWithCGSize:CGSizeMake(s.scaleX, s.scaleY)]];
            
        }
        
        [RobotScaleX_Y  setObject:sc forKey:[NSString stringWithFormat:@"%i",y]];
        [RobotRotations setObject:r forKey: [NSString stringWithFormat:@"%i",y]];
        [RobotPoints    setObject:a forKey: [NSString stringWithFormat:@"%i",y]];
        
        [a release];
        [r release];
        [sc release];
        
    }
    
     //  NSLog(@"default robot state points array %@//// \n rotation \n |||||| %@... SCALEes : %@",RobotPoints,RobotRotations,RobotScaleX_Y);

}

-(int)homManyStatesAreInLoaderByPrefix:(NSString*)preffix_{
    int sum = 0;
    
    for (LHSprite *s in [loader allSprites]) {
       NSRange r =  [s.uniqueName rangeOfString:suffix_POINT_CENTER options:NSCaseInsensitiveSearch];
        if (r.length > 0){
            sum ++;
        }
    }
   // NSLog(@"summed centeres %i",sum);
    return 0;
}

-(void)createRobotWithStatesSum:(int)sum_ robotPartsSum:(int)parts_ mainState:(int)main_{

    /*       // WHY CRASH HERE ?    -->> >BECAUCE RETURN IS 0
     
    // **** WARNING !!! SUFFIX of center point mus be as defined in <suffix_PONT_CENTER>
    int sumStatesAuto = [self homManyStatesAreInLoaderByPrefix:uniqueNamePrefix];
   // robotStates  = sum_ ;
    
    if (sumStatesAuto < 1) {
        NSLog(@"WARNING !!! -> Counted robot states -> sum  < %i > is not valid",sumStatesAuto);
    }
     */

    robotStates = sum_;
    robotParts   = parts_;
    
    for (int x = 0; x < robotStates; x++) {
        
        NSMutableArray *a = [[NSMutableArray alloc]init];
        
        for (int y = 0; y < robotParts; y++)
        {
            [a addObject:[NSString stringWithFormat:@"%@_%i_%i",uniqueNamePrefix,x,y]];
        }
        
        [RobotPartNames setObject:a forKey:[NSString stringWithFormat:@"%i",x]];
        
        [a release];
        
    }
    
    [self createRobotPartsPointsAndRotations];
    
    [self createRobotCostumePartsWithMainState:main_];

}

-(float)RotateRobotToPoint:(CGPoint)pos2{
    
    CGPoint pos1 = [self position];
    
    float theta = atan((pos1.y-pos2.y)/(pos1.x-pos2.x)) * 180 * 7 /22;
    
    float calculatedAngle;
    
    if(pos1.y - pos2.y > 0)
    {
        if(pos1.x - pos2.x < 0)
        {
            calculatedAngle = (-90-theta);
        }
        else if(pos1.x - pos2.x > 0)
        {
            calculatedAngle = (90-theta);
        }
    }
    else if(pos1.y - pos2.y < 0)
    {
        if(pos1.x - pos2.x < 0)
        {
            calculatedAngle = (270-theta);
        }
        else if(pos1.x - pos2.x > 0)
        {
            calculatedAngle = (90-theta);
        }
    }
    
    return calculatedAngle;
    
}

-(void)removeRobotFallower{
    
    robotCanFallowNode = NO;
    NodeToFallow = nil;
    
}

-(LHSprite*)myFallower{
    
    if (!robotCanFallowNode) {
        return nil;
    }
    return NodeToFallow;
    
}

-(void) onExit{

    for (CCNode *c in [self children]) {
        [c stopAllActions];
        [c removeAllChildrenWithCleanup:YES];
    }
    
        [self removeAllChildrenWithCleanup:YES];
    
    [super onExit];
    
}

- (void) dealloc
{
    if(RobotPoints){
        [RobotPoints release];
        RobotPoints = nil;
    }
    if(RobotPartNames){
        [RobotPartNames release];
        RobotPartNames = nil;
    }
    if(RobotRotations){
        [RobotRotations release];
        RobotRotations = nil;
    }
    if(AnimationPriority){
        [AnimationPriority release];
        AnimationPriority = nil;
    }
    if(AnimationDurations){
        [AnimationDurations release];
        AnimationDurations = nil;
    }
    if(RobotPartsEnableAnimation){
        [RobotPartsEnableAnimation release];
        RobotPartsEnableAnimation = nil;
    }
    if (RobotScaleX_Y) {
        [RobotScaleX_Y release];
        RobotScaleX_Y = nil;
    }
    
    uniqueNamePrefix = nil;
    
	[super dealloc];
}

@end
