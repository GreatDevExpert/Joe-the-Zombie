#import "CCScrollView.h"

@implementation CCScrollView

/*
 * Returns a CCScrollView Object.
 * You can treat this like a regular UIScrollView, but don't add subviews. Instead
 * use the methods getOffset and getOffsetAsPoint to set the Y Position of the
 * CCNode you want to scroll each frame
 */
+(CCScrollView *) makeScrollViewWithWidth:(int)width Height:(int)height rect:(CGRect)rect_
{
    CCScrollView * scrollView =
    [[CCScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    scrollView.frame = CGRectMake(rect_.origin.x,rect_.origin.y,rect_.size.width,rect_.size.height);
    scrollView.contentSize = CGSizeMake(width, height);
   // scrollView.showsHorizontalScrollIndicator = YES;
   // scrollView.showsVerticalScrollIndicator = YES;
    [scrollView setUserInteractionEnabled:TRUE];
    scrollView.bounces = YES;
 //   scrollView.backgroundColor = [UIColor greenColor];
    [scrollView setScrollEnabled:TRUE];
    scrollView.contentSize  = CGSizeMake(width, 2000);
    
    
//    for (int x = 1 ; x <= 10; x++) {
//        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"ipad_lvl%i.jpg",x]]];
//       // img.image = [UIImage imageNamed:[NSString stringWithFormat:@"ipad_lvl%i.jpg",x]];
//        img.frame = CGRectMake(img.frame.origin.x,
//                               img.frame.origin.y+(img.frame.size.height*(x-1)),
//                               img.frame.size.width/2,
//                               img.frame.size.height/2);
//        [scrollView addSubview:img];
//        
//    }
 
    
    [[[CCDirector sharedDirector] openGLView] addSubview:scrollView];

   // 
    
    return scrollView;
}

/*
 * Change the size of the scrollable area
 */
- (void)setWidth:(int)width Height:(int)height
{
    self.contentSize = CGSizeMake(width, height);
}

/*
 * Returns the offset of the scrollview as a point
 */
- (CGPoint) getOffsetAsPoint
{
    CGPoint offset = [self contentOffset];
    offset = [[CCDirector sharedDirector] convertToGL: offset];
    offset.y *= -1;
    offset.x *= -1;
    
    return offset;
}

/*
 * Returns the Y co-ordinate of the offset of the ScrollView
 */
- (int) getOffset
{
    CGPoint offset = [self getOffsetAsPoint];
    return offset.y;
}

- (void) dealloc
{
    [self removeFromSuperview];
    [super dealloc];
}

/*
 * Override touch functions
 * This allows Cocos2d to process touches
 */
-(void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
    if (!self.dragging)
        [[[CCDirector sharedDirector] openGLView] touchesBegan:touches withEvent:event];
    
    [super touchesBegan: touches withEvent: event];
}

-(void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
    if (!self.dragging)
        [[[CCDirector sharedDirector] openGLView] touchesEnded:touches withEvent:event];
    
    [super touchesEnded: touches withEvent: event];
}
@end