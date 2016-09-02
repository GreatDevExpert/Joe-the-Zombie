#import "CCSprite.h"
#import "cocos2d.h"
#import "GLES-Render.h"
#import "Box2D.h"

#define PTM_RATIO 32.0

@interface Monsters_level9 : CCSprite
{
   // b2World *world2;
    CCSpriteBatchNode *spriteBatchNodeML;
}
-(void)setMonsterByNR:(NSNumber*)num:(b2World*)world_;
-(id)initWithRect:(CGRect)boxrect_;
-(void)animationOf2;

@property (nonatomic,retain) CCSpriteBatchNode *spriteBatchNodeML;

@end
