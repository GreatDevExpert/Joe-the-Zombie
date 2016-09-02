
#import <Foundation/Foundation.h>
#import "VPoint.h"
#import "VStick.h"
#import "cocos2d.h"
#import "Box2D.h"

//PTM_RATIO defined here is for testing purposes, it should obviously be the same as your box2d world or, better yet, import a common header where PTM_RATIO is defined
#define PTM_RATIO 32

@interface VRope : NSObject {
	int numPoints;
	NSMutableArray *vPoints;
	NSMutableArray *vSticks;
	NSMutableArray *ropeSprites;
	CCSpriteBatchNode* spriteSheet;
	float antiSagHack;
	#ifdef BOX2D_H
    b2RopeJoint *joint;
	#endif
}
#ifdef BOX2D_H
-(id)initWithRopeJoint:(b2RopeJoint*)joint spriteSheet:(CCSpriteBatchNode*)spriteSheetArg;
-(void)update:(float)dt;
-(void)reset;
-(VRope *)cutRopeInStick:(VStick *)stick newBodyA:(b2Body*)newBodyA newBodyB:(b2Body*)newBodyB;
@property (nonatomic, readonly) b2RopeJoint *joint;
#endif
-(id)initWithPoints:(CGPoint)pointA pointB:(CGPoint)pointB spriteSheet:(CCSpriteBatchNode*)spriteSheetArg;
-(void)createRope:(CGPoint)pointA pointB:(CGPoint)pointB distance:(float)distance;
-(void)resetWithPoints:(CGPoint)pointA pointB:(CGPoint)pointB;
-(void)updateWithPoints:(CGPoint)pointA pointB:(CGPoint)pointB dt:(float)dt;
-(void)updateSprites;
-(void)removeSprites;

@property (nonatomic, readonly) NSArray *sticks;
@property (nonatomic, readonly) NSArray *_ropeSprites;

@end
