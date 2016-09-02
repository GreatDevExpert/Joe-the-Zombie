//
//  b6luxLoadingView.m
//  Zombie Joe
//
//  Created by Slavian on 2013-07-30.
//
//

#import "b6luxLoadingView.h"
#import "cfg.h"
#import "Combinations.h"
#import "SConfig.h"
#import "SCombinations.h"
#import <QuartzCore/QuartzCore.h>

@implementation b6luxLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[CCDirector sharedDirector] openGLView].userInteractionEnabled = NO;
        [self imagesLoad];
    }
    return self;
}

-(void)imagesLoad
{
    CGRect rect;
    if (IS_IPAD) {rect = CGRectMake(0, 0, 300, 200);}else{rect = CGRectMake(0, 0, 150, 100);}
    UIView *image = [[[UIImageView alloc]initWithFrame:rect]autorelease];
    image.backgroundColor = [UIColor blackColor];
    image.center = ccp(kWidthScreen/2, kHeightScreen/2);
    image.layer.opacity = 0.9f;
    
    image.layer.cornerRadius = IS_IPAD ? 15 : 10;
    
   // image.layer.borderColor = [UIColor whiteColor].CGColor;
   //kada image.layer.borderWidth = 1.5f;
    
    [self addSubview:image];
    
    for (int i = 0; i<3; i++) {
        UIImageView *imageView;
        switch (i) {
            case 0:imageView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"circle_back.png"]] autorelease];
                [self runSpinAnimationOnView:imageView duration:0.4f rotations:1 repeat:1e100 degree:2.0];
                break;
            case 1:imageView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"circle_middle.png"]] autorelease];
                [self runSpinAnimationOnView:imageView duration:0.4f rotations:1 repeat:1e100 degree:-2.0];
                break;
            case 2:imageView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"circle_front.png"]] autorelease];
                break;
            default:break;
        }
        imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, (kSCALELOADING_FACTOR_FIX)*(kSCALEVALLOADINGX), (kSCALELOADING_FACTOR_FIX)*(kSCALEVALLOADINGY));
        imageView.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
        imageView.layer.position = ccp(kWidthScreen/2, kHeightScreen/2);
        [self addSubview:imageView];
    }
}

- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(double)repeat degree:(float)degree_;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * degree_ /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)loadingON
{
}

-(void)dealloc
{
    [[CCDirector sharedDirector] openGLView].userInteractionEnabled = YES;
    
//    for (UIView *v in [[[CCDirector sharedDirector]openGLView]subviews]) {
//        NSLog(@"--[[SUBVIEW]]-- %@",v);
//    }
    [super dealloc];
}

@end
