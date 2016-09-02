//
//  CCFollowDynamicS.m
//  Zombie Joe
//
//  Created by macbook on 2013-05-07.
//
//

//
//  CCFollowDynamicS
//  UnknownGame
//
//  Created by hexo55 on 11/17/12.
//
//

#import "CCFollowDynamicS.h"

@implementation CCFollowDynamicS

@synthesize boundarySet;

+(id) actionWithTarget:(CCNode *) fNode
{
	return [[[self alloc] initWithTarget:fNode] autorelease];
}

+(id) actionWithTarget:(CCNode *)fNode smoothingFactor:(float)factor
{
	return [[[self alloc] initWithTarget:fNode smoothingFactor:factor] autorelease];
}

+(id) actionWithTarget:(CCNode *) fNode worldBoundary:(CGRect)rect
{
	return [[[self alloc] initWithTarget:fNode worldBoundary:rect] autorelease];
}

+ (id) actionWithTarget:(CCNode *)fNode worldBoundary:(CGRect)rect smoothingFactor:(float)factor
{
    return [[[self alloc] initWithTarget:fNode worldBoundary:rect smoothingFactor:factor] autorelease];
}

-(id) initWithTarget:(CCNode *)fNode
{
    return [self initWithTarget:fNode smoothingFactor:0.0f];
}

- (id) initWithTarget:(CCNode *)fNode smoothingFactor:(float)factor
{
    if( (self=[super init]) ) {
        
		followedNode_ = [fNode retain];
		boundarySet = FALSE;
        
		CGSize s = [[CCDirector sharedDirector] winSize];
		fullScreenSize = CGPointMake(s.width, s.height);
		halfScreenSize = ccpMult(fullScreenSize, .5f);
        
        smoothingFactor = factor;
        smoothingEnabled = YES;
        if ( (fabs(smoothingFactor-0.0f)<0.001) )
        {
            smoothingEnabled = NO;
        }
	}
    
	return self;
}

-(id) initWithTarget:(CCNode *)fNode worldBoundary:(CGRect)rect
{
    return [self initWithTarget:fNode worldBoundary:rect smoothingFactor:0.0f];
}

- (id) initWithTarget:(CCNode *)fNode worldBoundary:(CGRect)rect smoothingFactor:(float)factor
{
    if( (self=[super init]) ) {
		followedNode_ = [fNode retain];
		boundarySet = TRUE;
        
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		fullScreenSize = CGPointMake(winSize.width, winSize.height);
		halfScreenSize = ccpMult(fullScreenSize, .1f);
        
		leftBoundary = rect.origin.x;
		rightBoundary = rect.origin.x+rect.size.width ;
		topBoundary = rect.origin.y+rect.size.height;
		bottomBoundary = rect.origin.y;
        
        smoothingFactor = factor;
        smoothingEnabled = YES;
        if ( (fabs(smoothingFactor-0.0f)<0.001) )
        {
            smoothingEnabled = NO;
        }
	}
    
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	CCAction *copy = [[[self class] allocWithZone: zone] init];
	copy.tag = tag_;
	return copy;
}

-(void) step:(ccTime) dt
{
    CGPoint pos;
    float s = [(CCNode*)target_ scale];
    if(boundarySet)
    {
        CGPoint halfScreenSizeScaled = ccpMult(halfScreenSize, 1/s);
        CGPoint fullScreenSizeScaled = ccpMult(fullScreenSize, 1/s);
        CGPoint tempPos = ccpSub( halfScreenSizeScaled, followedNode_.position);
        
        CGPoint posMin = ccpSub(fullScreenSizeScaled, ccp(rightBoundary,topBoundary));
        CGPoint posMax = ccp(-leftBoundary,-bottomBoundary);
        pos = ccp(clampf(tempPos.x,posMin.x,posMax.x), clampf(tempPos.y,posMin.y,posMax.y));
    }
    else
    {
        CGPoint halfScreenSizeScaled = ccpMult(halfScreenSize, 1/s);
        pos = ccpSub( halfScreenSizeScaled, followedNode_.position );
    }
    
    pos.x *= s;
    pos.y *= s;
    
    if ( smoothingEnabled )
    {
        CGPoint oldPos = [target_ position];
        CGPoint increment = ccpMult(ccpSub(pos,oldPos),smoothingFactor);
        pos = ccpAdd(oldPos, increment);
    }
    
    [target_ setPosition:pos];
}

-(BOOL) isDone
{
	return !followedNode_.isRunning;
}

-(void) stop
{
	target_ = nil;
	[super stop];
}

-(void) dealloc
{
	[followedNode_ release];
	[super dealloc];
}

@end

