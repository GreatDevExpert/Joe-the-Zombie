//
//  droplet.h
//  2_level
//
//  Created by Eimio on 4/23/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface droplet : CCSprite
{
    CCSprite *dropletSp;
    
    CCSpriteBatchNode *dropletsItem;
    
    float fallingTime;
    float fallingTime2;
    
    bool endD;
    BOOL killed;
    
}

@property (assign)  BOOL killed;


-(void)dropFadeOut;
-(id)initWithPosition:(CGPoint)pos withTyp:(int)type_;
-(void) goodDroplets;
-(void) badDroplets;

@end
