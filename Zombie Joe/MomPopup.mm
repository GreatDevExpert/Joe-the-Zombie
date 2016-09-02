//
//  MomPopup.m
//  Zombie Joe
//
//  Created by macbook on 2013-07-02.
//
//

#import "MomPopup.h"
#import "cfg.h"

#define TAG_ACTION_SHOW 1


@implementation MomPopup

-(id)initWithLoader:(LevelHelperLoader*)loader_ fallowNode:(LHSprite*)nodeFallow_{
    
    if((self = [super init]))
    {
        NodeToFallow = nodeFallow_;
        
        self.position=  NodeToFallow.position;
        
        shown = NO;
        
        [self createBublesForLoader:loader_];
        
        loader = loader_;
        
        distanceBetweenCenterCat = ccpDistance(self.position, [loader_ spriteWithUniqueName:@"SP_7"].position);
        
        [self schedule:@selector(showHidePopUpdate:) interval:5.f];
        
    }
    return self;
    
}

-(void)showHidePopUpdate:(ccTime)dt{
    

    if (shown) {
        shown = NO;
        [self hideAllPopups];
    }
    else if (!shown){
        if (ccpDistance([loader spriteWithUniqueName:@"EGG"].position, self.position) < distanceBetweenCenterCat)
        {
            // *** not show the popup - EGG is to close;
            return;
        }
        shown = YES;
        [AUDIO playEffect:l5_momsadsound];
        [self showAllPopups];
    }
    
}

-(LHSprite*)myFallower{
    
    return NodeToFallow;
    
}

-(void)createBublesForLoader:(LevelHelperLoader*)loader_{
    
    //small
    
    Bubble0 = [loader_ createSpriteWithName:@"popup0"
                                           fromSheet:@"level_15_spritesSH"
                                          fromSHFile:@"Level15SH" parent:self];
    Bubble1 = [loader_ createSpriteWithName:@"popup1"
                                  fromSheet:@"level_15_spritesSH"
                                 fromSHFile:@"Level15SH" parent:self];
    Bubble2 = [loader_ createSpriteWithName:@"popup2"
                                  fromSheet:@"level_15_spritesSH"
                                 fromSHFile:@"Level15SH" parent:self];
    
    Bubble2.anchorPoint = ccp(0.5f, 0.5f);
    Bubble1.anchorPoint = ccp(0.5f, 0.5f);
    Bubble0.anchorPoint = ccp(0.5f, 0.5f);
    
    Bubble0.position = [self getShowPosByPopNr:1];
    Bubble1.position = [self getShowPosByPopNr:2];
    Bubble2.position = [self getShowPosByPopNr:3];
    
    Bubble0.scale = 0;
    Bubble1.scale = 0;
    Bubble2.scale = 0;

    
}

-(void)hideAllPopups{
    
    [self showHidePopUp:1 scale:0 hide:YES];
    [self showHidePopUp:2 scale:0 hide:YES];
    [self showHidePopUp:3 scale:0 hide:YES];
    
}

-(void)showAllPopups{
    
    [self showHidePopUp:1 scale:1 hide:NO];
    [self showHidePopUp:2 scale:1 hide:NO];
    [self showHidePopUp:3 scale:1 hide:NO];
    
}

-(void)showHidePopUp:(int)nodeNr_ scale:(float)scale_ hide:(BOOL)hide_{

    id sscaleUp =    [CCScaleTo    actionWithDuration:1.f scale:scale_];
    id easeScale =   [CCEaseElasticInOut actionWithAction:sscaleUp];
    
    /*
    CGPoint p = ccp(0, 0);

    if (!hide_) {
        p = [self getShowPosByPopNr:nodeNr_];
    }
    id move = [CCMoveTo actionWithDuration:0.1f position:p];
    */
     
    id spawn = [CCSpawn actions:easeScale, nil];
               
    [[self NodeByNr:nodeNr_] runAction:spawn].tag = TAG_ACTION_SHOW;
    
}

-(CGPoint)getShowPosByPopNr:(int)nr_{
    
    if (nr_==1) 
    return CGPointMake(-Bubble2.boundingBox.size.width*0.1f, -Bubble2.boundingBox.size.width*0.1f);
    else if (nr_==2)
    return CGPointMake(Bubble2.boundingBox.size.width*0.1f, Bubble2.boundingBox.size.width*0.1f);
    else if (nr_==3)
    return CGPointMake(Bubble2.boundingBox.size.width*0.7f, Bubble2.boundingBox.size.width*0.4f);
    
    return ccp(0, 0);
}
               
-(CCNode*)NodeByNr:(int)nr_{
    
    if (nr_ == 1) {
        return Bubble0;
    }
    else if (nr_ == 2) {
        return Bubble1;
    }
    else if (nr_ == 3) {
        return Bubble2;
    }
    
    return Bubble0;
    
}

@end
