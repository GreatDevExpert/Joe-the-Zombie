//
//  rotateBlock.h
//  Zombie Joe
//
//  Created by Mac4user on 5/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface rotateBlock : CCSprite {
    
    float rotate;
    float speed;
    
    BOOL down;
    
    //   int tag;
    
    CCSprite *rock;
    int directionRotate;
    
}

-(float)giveSpeedOfRotation;

-(int)directionToRotate;

-(id)initWithRect:(CGRect)rect tag:(int)_tag;

@end
