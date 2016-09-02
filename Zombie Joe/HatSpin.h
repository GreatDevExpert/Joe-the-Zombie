//
//  HatSpin.h
//  Zombie Joe
//
//  Created by Mac4user on 6/5/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HatSpin : CCSprite {
    
    CCSpriteBatchNode *zombieFlyBatch;
    CCSprite *hat_;
    CCSprite *prop;
}

-(id)initWithRect:(CGRect)rect;

-(void)spinHat:(float)delay_ loop:(BOOL)yes_;

@end
