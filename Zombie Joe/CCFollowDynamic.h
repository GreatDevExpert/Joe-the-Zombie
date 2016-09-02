#import "cocos2d.h"

@interface CCFollowDynamic : CCAction
{
    /* node to follow */
	CCNode	*followedNode_;
    
	/* whether camera should be limited to certain area */
	BOOL boundarySet;
    
	/* fast access to the screen dimensions */
	CGPoint halfScreenSize;
	CGPoint fullScreenSize;
    
	/* world boundaries */
	float leftBoundary;
	float rightBoundary;
	float topBoundary;
	float bottomBoundary;
    
    /* used for smoothing follow action */
    BOOL smoothingEnabled;
    float smoothingFactor;
}

/** alter behavior - turn on/off boundary */
@property (nonatomic,readwrite) BOOL boundarySet;

/** creates the action with no boundary set */
+(id) actionWithTarget:(CCNode *)followedNode;

/** creates the action with no boundary and with a smoothing factor
 @param factor factor used for smoothing the follow action. Recommended
 values are from (0.0f, 1.0f]. A low value provides slow smoothing while a
 value of 1.0f has no smoothing at all.
 */
+(id) actionWithTarget:(CCNode *)followedNode smoothingFactor:(float)factor;

/** creates the action with a set boundary */
+(id) actionWithTarget:(CCNode *)followedNode worldBoundary:(CGRect)rect;

/** creates the action with a set boundary and with a smoothing factor */
+ (id) actionWithTarget:(CCNode *)fNode worldBoundary:(CGRect)rect smoothingFactor:(float)factor nodePlace:(float)nod_place_;

/** initializes the action */
-(id) initWithTarget:(CCNode *)followedNode;

/** initializes the action with a set boundary */
-(id) initWithTarget:(CCNode *)followedNode worldBoundary:(CGRect)rect;

/** initializes the action with smoothing factor */
- (id) initWithTarget:(CCNode *)followedNode smoothingFactor:(float)factor;

/** initializes the action with a set boundary and with a smoothing factor */
- (id) initWithTarget:(CCNode *)fNode worldBoundary:(CGRect)rect smoothingFactor:(float)factor nodePlace:(float)nod_place_;

@end