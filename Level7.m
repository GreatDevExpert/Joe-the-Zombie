
#import "Level5.h"
#import "cfg.h"
#import "Constants.h"
#import "constants_l5.h"

@implementation Level5
@synthesize CHARACTER_GO;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	Level5 *layer = [Level5 node];
	[scene addChild: layer];
	return scene;
}

#pragma mark DELEGATE METHODS

-(id)getNode{
    
    return [Level5 node];
    
}

-(void)gameStateEnded{
    
    NSLog(@"level passed");
    
}

-(id) init
{
	if( (self=[super init])) {
        
        self.isTouchEnabled = YES;

        //add top buttons with delegates
        [cfg addInGameButtonsFor:self];
        [self addBottom];
        
        [cfg addBG_forNode:self withCCZ:@"BG_level5" bg:@"background.jpg"];
        
        [self addSprites];  //may delete later
        [self addBGSliders];
        [self charactertBorn];

        alive = YES;
        
        [self schedule:@selector(update:)];
        
        
	}
	return self;
}

-(void)addlava{
    
    CCSprite * lava = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"lavalight.png"]];
    lava.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    //sprite.opacity = 100;
    lava.scale = 2;
    [spritesBgNode addChild:lava];
    
    id fadeOut =  [CCFadeOut actionWithDuration:1];
    id fadeIn = [fadeOut reverse];
    
    [lava runAction:[CCRepeatForever actionWithAction:[CCSequence actions:fadeIn,fadeOut, nil]]];
    
}

-(void)addBottom{
    
    CCSprite *bottom = [[[CCSprite alloc]init]autorelease];
    
    [bottom setTextureRect:CGRectMake(0, 0, ScreenSize.width,
                                            ScreenSize.height)];
    bottom.position = ccp(ScreenSize.width/2,ScreenSize.height/2);
    bottom.anchorPoint = ccp(0.5f, 0.5f);
    [self addChild:bottom z:0 tag:kBottom];
    bottom.color = ccGREEN;
    
}

-(void)charactertBorn{
    
    CHARACTER_GO = [[GoinCharacter alloc]initWithRect:CGRectMake(0, 0,
                                         characterW, characterH) tag:kCHARACTERTAG];
    
    [self addChild:CHARACTER_GO];
    
    CHARACTER_GO.position =ccp([self getChildByTag:col0].position.x-(characterW),
                               [self getChildByTag:col0].position.y);
    if (IS_IPHONE) {
        CHARACTER_GO.position =ccp([self getChildByTag:col0].position.x-(characterW),
                                   [self getChildByTag:col0].position.y+(characterH/2));
    }
                               
}

-(void)addSprites{
    
    NSString *spritesStr =      [NSString stringWithFormat:@"sprites_level5_iPhone"];
    if (IS_IPAD) spritesStr =   [NSString stringWithFormat:@"sprites_level5"];
    
    spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz",spritesStr]];
    [self addChild:spritesBgNode];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache]
     addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist",spritesStr]];

    
}

-(void)addBGSliders{

    for (int x = 0;  x < l5_nr_ofSliders; x++)
    {
        SliderPart *SL = [[SliderPart alloc]initWithRect:
        CGRectMake((x)*(kSliderW)+(kSliderW/2),
                   ScreenSize.height/2,
                   kSliderW,
                   kSliderH)
                                                     tag:x+(col_Tag)];
        [self addChild:SL];
     
/*
        if (x !=0 && x !=l5_nr_ofSliders-1)
        {
        NSLog(@"name %@",[NSString stringWithFormat:@"slide%i.png",x-1]);
        [SL setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
        spriteFrameByName:[NSString stringWithFormat:@"slide%i.png",x-1]]];
            
        [spritesBgNode addChild:SL];
        }

        else
        [self addChild:SL];
 */
    }
 
 
}

-(CCSpriteBatchNode*)giveBatch{
    
    return spritesBgNode;
    
}

- (BOOL) rect:(CGRect) rect collisionWithRect:(CGRect) rectTwo
{
    float rect_x1 = rect.origin.x;
    float rect_x2 = rect_x1+rect.size.width;
    
    float rect_y1 = rect.origin.y;
    float rect_y2 = rect_y1+rect.size.height;
    
    float rect2_x1 = rectTwo.origin.x;
    float rect2_x2 = rect2_x1+rectTwo.size.width;
    
    float rect2_y1 = rectTwo.origin.y;
    float rect2_y2 = rect2_y1+rectTwo.size.height;
    
    if((rect_x2 > rect2_x1 && rect_x1 < rect2_x2) &&(rect_y2 > rect2_y1 && rect_y1 < rect2_y2))
        return YES;
    
    return NO;
}

-(CGRect) positionRect: (CCSprite*)sprite {
	CGSize contentSize = [sprite contentSize];
	CGPoint contentPosition = [sprite position];
	CGRect result = CGRectOffset(CGRectMake(0, 0, contentSize.width, contentSize.height), contentPosition.x-contentSize.width/2, contentPosition.y-contentSize.height/2);
	return result;
}

-(void)dropSlider{
    
    
    
}

-(void)update:(ccTime)dt{
    
    if (!alive) {
        return;
    }
    
    if ([self rect:CHARACTER_GO.boundingBox collisionWithRect:[self getChildByTag:kBottom].boundingBox])
    {
        BOOL stick = NO;
        BOOL track = NO;
     
        for (int x = col0; x < col7+1; x++) {
            
            float w_s = [self getChildByTag:x].boundingBox.size.width;
            float h_s = [self getChildByTag:x].boundingBox.size.height/2;   //in col 5,6 smaller
            if (x==col5 || x==col6) {
                h_s = [self getChildByTag:x].boundingBox.size.height*0.45f;
            }
            CGRect stickBox = CGRectMake([self getChildByTag:x].boundingBox.origin.x,
                                         [self getChildByTag:x].boundingBox.origin.y+(h_s/2),
                                         w_s,
                                         h_s);
            if ([self rect:CHARACTER_GO.boundingBox collisionWithRect:stickBox]) {
           // if ([self rect:CHARACTER_GO.boundingBox collisionWithRect:[self getChildByTag:x].boundingBox]) {
               // NSLog(@"collided with stick nr :%i",x);
                stick = YES;
                
//                [[self getChildByTag:x] stopAllActions];
//                
//                for (SliderPart *sprite in children_){
//                    
//                    if (sprite.tag==x) {
//                        [sprite startMoving:YES];
//                    }
//                    
//                }
                
                if (x==col0 || x==col7) {
                    continue;
                }
                
                BOOL kill = NO;
                
                for (CCSprite *sprite in [[self getChildByTag:x] children]) {
                    
                    if ([self getChildByTag:x-1] !=nil )
                    {   //drop it
                       // [self stopAllActions];
                        
                        id scaleDown = [CCScaleTo actionWithDuration:1.f scaleX:0.1f scaleY:0.1f];
                        id rotate = [CCRotateBy actionWithDuration:1 angle:180];
                        id spawn = [CCSpawn actions:scaleDown,rotate, nil];
                        id delay = [CCDelayTime actionWithDuration:3];
                        
                        id delete =     [CCCallBlock actionWithBlock:^(void)
                                         {
                                            [[self getChildByTag:x-1]removeFromParentAndCleanup:YES];
                                         }];
                        
                        id seq =     [CCSequence actions:delay,spawn,delete, nil];
                        
                        [[self getChildByTag:x-1]stopAllActions];
                        
                       // [[self getChildByTag:x-1] runAction:seq];
                        
                        //[[self getChildByTag:x-1]removeFromParentAndCleanup:YES];
                    }
                    
                    if (sprite.tag ==SliderTrackAreaBrain) {
                        
                        CGPoint loc =[[self getChildByTag:x] convertToWorldSpace:sprite.position];
                        float w = sprite.boundingBox.size.width*1.25f;
                        float h = sprite.boundingBox.size.height*1.25f;
                        CGRect trackBox = CGRectMake(loc.x-w/2,
                                                     loc.y-h/2,
                                                     w,
                                                     h);
                        
                   
                        
                        if (![self rect:CHARACTER_GO.boundingBox collisionWithRect:trackBox]) {
                            // NSLog(@"NOT COLLIDED WITH TRACK");
                            // alive = NO;
                            kill = YES;
                            //    [CHARACTER_GO stopAllActions];
                        }
                        else if ([self rect:CHARACTER_GO.boundingBox collisionWithRect:trackBox]) {
                            // NSLog(@"NOT COLLIDED WITH TRACK");
                            // alive = NO;
                            NSLog(@"got the brains");
                            //    [CHARACTER_GO stopAllActions];
                        }
                    }
                    
                    if (sprite.tag ==SliderTrackAreaTag) {
                        
                        CGPoint loc =[[self getChildByTag:x] convertToWorldSpace:sprite.position];
                        float w = sprite.boundingBox.size.width*1.25f;
                        float h = sprite.boundingBox.size.height*1.25f;
                        CGRect trackBox = CGRectMake(loc.x-w/2,
                                                     loc.y-h/2,
                                                     w,
                                                     h);
                        
                        //-(void)tintToRed
                        
                       
                        
                        if ([self rect:CHARACTER_GO.boundingBox collisionWithRect:trackBox]) {
                            // NSLog(@"NOT COLLIDED WITH TRACK");
                            kill = NO;
                           // alive = NO;
                            //    [CHARACTER_GO stopAllActions];
                        }
                    }
                    

    
                }
                
                if (kill) {
                    alive = NO;
                }

            }
        }
        
        if (!stick) {
           // NSLog(@"STOP ! collision with hole");
            alive = NO;
            [CHARACTER_GO stopAllActions];
            [CHARACTER_GO inlavaAction];
        }
    }
    
    CGPoint velocity = CGPointMake(1.f/2, 0.f); // Move right
    CHARACTER_GO.position = ccpAdd(CHARACTER_GO.position, velocity);
    
}

-(CGRect)getItemRect:(int)x{
    
    float rectOffsetW = [[self getChildByTag:x]boundingBox].size.width;
    float rectOffsetH = [[self getChildByTag:x]boundingBox].size.height;

    
    CGRect itemBoundingBox = [[self getChildByTag:x] boundingBox];
    
    CGRect itemRect = CGRectMake(itemBoundingBox.origin.x-rectOffsetW/2, itemBoundingBox.origin.y-rectOffsetH/2,
                                 itemBoundingBox.size.width+rectOffsetW, itemBoundingBox.size.height+rectOffsetH);
    
    return itemRect;
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{return NO;}
//    
//    CGPoint location = [touch locationInView:[touch view]];
//    
//    location = [[CCDirector sharedDirector] convertToGL:location];
//    
//    whereTouch=ccpSub(self.position, location);
//    
//    for (int x = 200; x < 208; x++){
//        
//        if (CGRectContainsPoint([self getChildByTag:x].boundingBox, location)){
//            tagTouched = x;
//            [[self getChildByTag:tagTouched]stopAllActions];
//          //  [self getChildByTag:x].position = ccp([self getChildByTag:x].position.x, location.y);
//        }
//    }
//    
//    return YES;
//    
//}
//
//-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
//    
//    CGPoint location = [touch locationInView:[touch view]];
//    
//    location = [[CCDirector sharedDirector] convertToGL:location];
//    
//    [self getChildByTag:tagTouched].position=ccpAdd(ccp([self getChildByTag:tagTouched].position.x, location.y),ccp(0, whereTouch.y));
//    
//}

- (void)onEnter{
    
   [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-2 swallowsTouches:YES];
    [super onEnter];
}


- (void)onExit{
    
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [super onExit];
}

@end
