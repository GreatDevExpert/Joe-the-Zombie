
#import "CCSprite.h"
#import "cocos2d.h"

@interface Cristal : CCSprite
{
    CCSpriteBatchNode *spriteBatchNode;
}
-(id)initWithRect:(CGRect)boxrect_;
-(void)addCristal:(NSString*)spriteName:(NSNumber*)cristalNum;
-(void)setCristalPos:(CGPoint)pos:(NSNumber*)cristalNum;
@end
