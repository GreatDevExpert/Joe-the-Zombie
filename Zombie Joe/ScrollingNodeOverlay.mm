//
//  ScrollingNodeOverlay.m
//  Cocos2dScrolling
//
//  Created by Tony Ngo on 11/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ScrollingNodeOverlay.h"

@implementation ScrollingNodeOverlay

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if(!self.dragging) {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self.nextResponder touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if(!self.dragging) {
        [self.nextResponder touchesEnded:touches withEvent:event];
    }
}

@end
