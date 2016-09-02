//
//  HelloWorldLayer.h
//  Zombie Joe
//
//  Created by Mac4user on 4/25/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
//#import "MenuZombieBody.h"
#import "MenuLevelScroller.h"
#import "CCScrollView.h"

#import "CCUIViewWrapper.h"

//#import "JOE_C.h"

//#import "MenuZombieBody.h"


@interface MainMenu : CCLayer<CCTargetedTouchDelegate>
{
    MenuLevelScroller *MZSCrollW;
    CCSprite *TutorialBoard;
    CCSprite *tutorialImage;
    
    CCSpriteBatchNode *spritesItemsBatchNode;
  
    CGPoint zombiePos;
    CCSprite *sprider;
    
    CCLabelTTF *labelBrain;
    
  //  UIButton *button;
    
    BOOL canTouch;
    
    int touchedOnZombieCount;
    
    BOOL brainGot;
    
    BOOL canTouchJoe;
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

//@property (nonatomic,retain) MenuLevelScroller  *MZSCrollW;
//@property (nonatomic,retain) CCSprite *TutorialBoard;
//@property (nonatomic,retain) CCSprite *tutorialImage;

-(void)purchaseWasDoneNow;

-(void)addLoadImageWithName:(NSNumber*)levelNR;

-(void)scrollDisable:(BOOL)bool_;

@end
