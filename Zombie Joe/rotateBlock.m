//
//  rotateBlock.m
//  Zombie Joe
//
//  Created by Mac4user on 5/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "rotateBlock.h"
#import "cfg.h"

@implementation rotateBlock

-(id)initWithRect:(CGRect)rect tag:(int)_tag{
    
    if((self = [super init]))
    {

        
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        self.tag = _tag;
        
        self.anchorPoint = ccp(0.5f,0.5f);
        self.contentSize = CGSizeMake(rect.size.width/2,
                                      rect.size.height/2);
        

        
      
        
        self.position = ccp(rect.origin.x, rect.origin.y);
        
        self.scale = kSCALE_FACTOR_FIX;
    
        rotate = 360;
 
        speed = 10;
        int tag=  self.tag - 100;
        
        NSString *imgName = @"rock.png";
        if (tag==1 || tag==10) {
            imgName = @"rock1.png";
        }
        
//        if (tag==5 || tag==6 || tag == 8 || tag ==10) {
//            self.scale = 0.7f;
//        }

  
        
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
                               spriteFrameByName:imgName]];
        
 
        
        switch (tag) {
            case 0:
                speed = 1.5f;
                self.scale = 0.75f;
                break;
            case 1:
                speed = 3;  //brain #1
                self.scale = 0.9f;
                break;
            case 2:
                speed = 2.5f;
                 self.scale = 0.9f;
                break;
            case 3:
                speed = 3;
                 self.scale = 0.8f;
                break;
            case 4:
                speed = 3.5f;
                 self.scale = 0.7f;
                break;
            case 5:
                speed = 4.f;
                 self.scale = 0.7f;
                break;
            case 6:
                speed = 5;
                 self.scale = 0.65f;
                break;
            case 7:
                speed = 5.5f;
                 self.scale = 0.6f;
                break;
            case 8:
                speed = 6.f;
                 self.scale = 0.55f;
                break;
            case 9:
                speed = 0.f;
                 self.scale = 1.f;
                break;
            case 10:
                speed = 8.f;    //brain #2
                 self.scale = 0.5f;
                break;
                
                
            default:
                break;
        }
        
        self.scale = self.scale * kSCALE_FACTOR_FIX;
        
     //   [self addWaveEffect];
    
        [self schedule:@selector(update:)];
        
        [self scaleForever];
        
        directionRotate = 0;
        
        
     //   [cfg addTEMPBGCOLOR:self anchor:ccp(0.5f, 0.5f) color:ccRED];
        
        
    }
    return self;
}

-(void)addWaveEffect{
 
    CCSprite *wave = [CCSprite spriteWithSpriteFrameName:@"wave.png"];
    [self addChild:wave z:-1];
    wave.scale = kSCALE_FACTOR_FIX;
    wave.position = ccp(self.contentSize.width/2-10,self.contentSize.height/2-10);
    wave.scale = 0;
    
    int f = [cfg MyRandomIntegerBetween:1 :3];
    
    id scaleUP =[CCScaleTo actionWithDuration:f scale:1.5f*(kSCALE_FACTOR_FIX)];
    
    id fadeOut =[CCFadeTo actionWithDuration:f opacity:0];
    
    id scaleDOWN=[CCScaleTo actionWithDuration:0.f scale:0];
    id fadeIn =[CCFadeTo actionWithDuration:0.f opacity:255];
    
    id sp1 = [CCSpawn actions:scaleUP,fadeOut, nil];
    id sp2 = [CCSpawn actions:scaleDOWN,fadeIn, nil];
    
    id seq = [CCSequence actions:sp1,sp2, nil];
    id fr = [CCRepeatForever actionWithAction:seq];
    
    [wave runAction:fr];
    
}

-(float)giveSpeedOfRotation{
    
    return speed;
    
}

-(int)directionToRotate{
    
    return directionRotate;

}

-(void)update:(ccTime)dt{
    
    if (self.tag == 8) {
        return;
    }
    
    if (self.tag-100==3 || self.tag-100==5 || self.tag-100==10)
    {
        self.rotation-=speed;
        
        if (self.rotation <0)
        {
            self.rotation = 360;
        }
        
        directionRotate = -1;
        
    }
    else{
        self.rotation+=speed;
        if (self.rotation >=rotate)
        {
            self.rotation = 0;
        }
        
        directionRotate = 1;
        
    }
    
    
 
    
    
}

-(void)scaleForever{
    
    id scale =   [CCScaleTo actionWithDuration:0.5f scale:self.scale+0.05f];
    id rescale = [CCScaleTo actionWithDuration:0.5f scale:self.scale-0.05f];
    id seq =     [CCSequence actions:scale,rescale, nil];
    
    [self runAction:[CCRepeatForever actionWithAction:seq]];

}

@end
