//
//  TutorialVIEW.h
//  Zombie Joe
//
//  Created by macbook on 2013-05-22.
//
//

#import "cocos2d.h"
//#import "InGameButtons.h"

@interface TutorialVIEW : CCSprite<CCTargetedTouchDelegate>{
    
    CCSprite *TutorialBoard;
    CCSpriteBatchNode *spritesBgNode;
    CCSprite *tutorialImage;
    CCSprite *continueBtn;
    BOOL hidden;
    int TYPE;
    
    BOOL BLOCK_TOUCH;
    
  //  CCNode *par;
  //  id parent;
    
}

@property (assign) BOOL hidden;
//@property (nonatomic,retain) id parent;

-(id)initWithRect:(CGRect)rect levelNR:(int)level_ type:(int)type_;

@end
