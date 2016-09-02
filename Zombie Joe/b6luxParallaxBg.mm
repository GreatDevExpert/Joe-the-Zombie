//
//  b6lRobot.m
//  Zombie Joe
//
//  Created by macbook on 2013-07-05.
//
//

#import "b6luxParallaxBg.h"
#import "cfg.h"

@implementation b6luxParallaxBg
@synthesize enableMoveY;

-(id)loadParallaxBackgroundWithLoader:(LevelHelperLoader*)loader_
                         fallowedNode:(CCNode*)node_
                            direction:(int)dir_
{
    
    if((self = [super init]))   {

        loader =loader_;            // *** Loader where all objects will be taken from
        nodeToFallow = node_;       // *** Node which backgrounds will fallow
        direction = dir_;           // *** Direction where bg will be scrolledTo (Right-Left; Up-Down)
        
        firstNodePosition = nodeToFallow.position;  // *** First position of node
        previousNodePosition = firstNodePosition;
        
        bgPositions = [[NSMutableDictionary alloc]init];
        bgSpeeds    = [[NSMutableDictionary alloc]init];
        bgObjects   = [[NSMutableDictionary alloc]init];    
    
        moverNode = [[CCNode alloc]init];
        moverNode.position = ccp(0, 0);
        moverNode.anchorPoint = ccp(0.f, 0.f);
        moverNode.contentSize = CGSizeMake(kWidthScreen, kHeightScreen);
       // [cfg addTEMPBGCOLOR:moverNode anchor:ccp(0, 0) color:ccRED];
        
        enableMoveY = YES;
        
        [self addChild:moverNode];
        
        [self schedule:@selector(tick:) interval:1/90.f];
        
    }
    
    return self;
}

-(CGPoint)getPositionDifferenceWithPoints_p1:(CGPoint)p1_ p2_:(CGPoint)p2_{
    
    CGFloat xDist = (p2_.x - p1_.x);
    CGFloat yDist = (p2_.y - p1_.y);
    
    return CGPointMake(xDist, yDist);
    
}

-(void)addBgWithUniqeName:(NSString*)name_ speed:(float)speed_{
    
    // * Unique name mus be exple: bg (in LH - bg_0, gb_1)
    
    int howManyParts = [self homManyStatesAreInLoaderByPrefix:name_];
    
    // * Calculate distances between
    
    NSMutableArray *da =    [[NSMutableArray alloc]init];
    NSMutableArray *objects = [[NSMutableArray alloc]init];
    
    LHSprite *beg = [loader spriteWithUniqueName:[NSString stringWithFormat:@"%@_0",name_]];
    
    for (int x = 0; x < howManyParts; x++)
    {
        LHSprite *b = [loader spriteWithUniqueName:[NSString stringWithFormat:@"%@_%i",name_,x]];
        CGPoint pos = [self getPositionDifferenceWithPoints_p1:beg.position p2_:b.position];
        [da addObject:[NSValue valueWithCGPoint:pos]];
    }
    
    // * Positionate the elements
    
    for (int x = 0; x < howManyParts; x++)
    {
        LHSprite *b = [loader spriteWithUniqueName:[NSString stringWithFormat:@"%@_%i",name_,x]];
        b.anchorPoint = ccp(0, 0);
        b.position = [[da objectAtIndex:x]CGPointValue];
        
        [objects addObject:b];
        
    }
    
    // * Add bg objects to dictionary
    
    [bgObjects setObject:objects forKey:C_OBJ(numberOfBackgrounds)];
    
    // MUST SET THE SPEED HERE TOO !!!
    
    // .......
    
    
    
    // * Backgrounds sum is increased
    
    numberOfBackgrounds++;
    
    NSLog(@"bgObjects %@",bgObjects);
    
    [da release];
    [objects release];
}

-(CGPoint)giveZeroOneDifferenceBetween_p1:(CGPoint)pt1_ p2:(CGPoint)pt2_{
    
    int x = 0;
    int y = 0;
    
    /*
    float maxDiiffX = 10;
    float maxDiiffY = 10;

    float diffX = pt1_.x - pt2_.x;
    float diffY = pt1_.y - pt2_.y;
    */
    
    if (pt1_.x > pt2_.x) {
        x = 1;
    }
    else if (pt1_.x < pt2_.x){
        x = -1;
    }
    else if (pt1_.x == pt2_.x) x = 0;
    
    if (pt1_.y > pt2_.y) {
        y = 1;
    }
    else if (pt1_.y < pt2_.y){
        y = -1;
    }
    else if (pt1_.y == pt2_.y) y = 0;
    
    /*
    if (diffX < maxDiiffX) {
        x = 0;
    }
    if (diffY < maxDiiffY) {
        y = 0;
    }
    */
    
    return CGPointMake(x, y);
    
}

-(void)tick:(ccTime)dt{
    
  //  NSLog(@"self pos %f %f",self.position.x,self.position.y);
  //  NSLog(@"node to follow %f %f",firstNodePosition.x,firstNodePosition.y);
    
    CGPoint moved      = nodeToFallow.position;
    moverNode.position = ccp(moverNode.position.x,moved.y-(moverNode.contentSize.height/2));
    CGPoint ch = [self giveZeroOneDifferenceBetween_p1:moved p2:previousNodePosition];
    
    if (numberOfBackgrounds < 0) {
        return; // * No bg objects to move
    }
    
    for (int x = 0; x < numberOfBackgrounds;x++ ) {
        NSArray *a = [bgObjects objectForKey:C_OBJ(x)]; // * BG objects for key (1,2...)
        for (LHSprite *s in a)
        {
            if (s.position.y < moverNode.position.y-s.boundingBox.size.height*0.75f)
            {
                s.position = ccpAdd(s.position, ccp(s.position.x, s.boundingBox.size.height*[a count]));  // * reposition bg
            }
            
            float y_ = (-ch.y*2.5f);
            float x_ =  0;
            
            s.position = ccpAdd(s.position, ccp(x_,(enableMoveY) ? y_ : 0));

        }
    }

        previousNodePosition = moved;

}

-(int)homManyStatesAreInLoaderByPrefix:(NSString*)preffix_{
    int sum = 0;
    
    for (LHSprite *s in [loader allSprites]) {
        NSRange r =  [s.uniqueName rangeOfString:preffix_ options:NSCaseInsensitiveSearch];
        if (r.length > 0){
            sum ++;
        }
    }
    // NSLog(@"summed centeres %i",sum);
    return sum;
}

-(void)addTemp{
    /*
    LHSprite *part = [loader createSpriteWithName:s.shSpriteName
                                        fromSheet:s.shSheetName
                                       fromSHFile:s.shSceneName parent:self];
    part.position = pos;
    part.tag = x;
    part.rotation = s.rotation;
    part.flipX = s.flipX;
    part.flipY = s.flipY;
    [self reorderChild:part z:s.zOrder];
    */
}

-(void) onExit{

    [self removeAllChildrenWithCleanup:YES];
    
    [super onExit];
    
}

- (void) dealloc
{
    
    if (moverNode) {
        [moverNode release];
        moverNode = nil;
    }
    if(bgPositions){
        [bgPositions release];
        bgPositions = nil;
    }
    if(bgSpeeds){
        [bgSpeeds release];
        bgSpeeds = nil;
    }
    if (bgObjects) {
        [bgObjects release];
        bgObjects = nil;
    }
	[super dealloc];
}

@end
