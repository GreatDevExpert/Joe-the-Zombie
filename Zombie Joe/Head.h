

#import "CCSprite.h"
#import "cocos2d.h"

@interface Head : CCSprite
{
    int cristalCount;
    NSString *cristalName;
    int cristalW;
    int cristalH;
    bool openMouth;
    CCSpriteBatchNode *spriteBatchNode;
}
@property (nonatomic,assign) bool openMouth;

-(id)initWithRect:(CGRect)boxrect_;
-(void)doSomething;
-(void)addCristal;
-(void)cristalGo:(CGPoint)pos;
-(void)actionReverse;
-(void)callCristal;
-(void)eaysRunning;
-(void)eaysStartPos;
-(void)pliusCristals;
-(CGPoint)returnValuePOS_:(int)number;
-(CGRect*)returnRect:(int)number;
-(int)returnInt:(int)number;
-(void)closeMouth;
-(void)gameOver;
-(void)gameOverSmile;
-(void)movingHeads;
-(void)addBrain;
-(void)removeBrain;
-(void)headGoDown;
@end
