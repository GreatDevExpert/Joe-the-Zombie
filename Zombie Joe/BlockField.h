//
//  BlockField.h
//  Zombie Joe
//
//  Created by macbook on 2013-05-08.
//
//

#import "CCSprite.h"
#import "cocos2d.h"

@interface BlockField : CCSprite<CCTargetedTouchDelegate>{
    
    float buttonW;
    
    CGPoint     whereTouch;
    int diamondCaughtTag;
    
}

-(id)initWithRect:(CGRect)rect;

@end
