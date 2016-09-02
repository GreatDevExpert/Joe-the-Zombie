//
//  CCScrollView.h
//  Zombie Joe
//
//  Created by macbook on 2013-05-23.
//
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface CCScrollView : UIScrollView

+(CCScrollView *) makeScrollViewWithWidth:(int)width Height:(int)height rect:(CGRect)rect_;

- (void)setWidth:(int)width Height:(int)height;
- (int) getOffset;
- (CGPoint) getOffsetAsPoint;

@end
