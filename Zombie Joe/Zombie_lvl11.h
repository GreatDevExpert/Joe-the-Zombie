//
//  Zombie_lvl11.h
//  project_box2d
//
//  Created by Slavian on 2013-06-20.
//
//

#import "CCSprite.h"

@interface Zombie_lvl11 : CCSprite

-(id)initWithRect:(CGRect)boxrect_;
-(void)scaleBody:(NSNumber *)num;
-(void)rotateHead:(NSNumber *)num;
-(void)dead;

-(void)colorAllBodyPartsWithColor:(ccColor3B)c_ restore:(BOOL)restore_ restoreAfterDelay:(float)delay_ obj:(CCSprite*)s_;

@end
