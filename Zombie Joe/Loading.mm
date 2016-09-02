
#import "Loading.h"
#import "Level1.h"
#import "Level5.h"
#import "Level7.h"
#import "Level8.h"
#import "Level3.h"
#import "level2.h"
#import "Level4.h"
#import "Level6.h"


@implementation Loading

+(CCScene *) scene {

	CCScene *scene = [CCScene node];
	
	Loading *layer = [Loading node];
    
	[scene addChild: layer];
	
	return scene;
}

-(void)addLoadingLabel{
    
    label = [CCLabelTTF labelWithString:@"Loading" fontName:[Singelton giveMeFontname] fontSize:18];
	
    label.position =  ccp(ScreenSize.width/2-[label boundingBox].size.width/1.5f, ScreenSize.height/2 );
    
    label.anchorPoint = ccp(0,0.5f);
    
    [self addChild: label z:1];

    
}

-(void)loadingSprite{
    
    CCSprite *sprite = [CCSprite spriteWithFile:@"loading_label.png"];
    [self addChild:sprite];
    sprite.position = ccp(ScreenSize.width/2,ScreenSize.height/2);
    
}

-(void)sceneAfterDelay{
    
    // [[CCDirector sharedDirector] replaceScene:[GameLayer1 scene2]]; 
 //   [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameLayer1 scene2]]];

}

-(void)timeschedule:(ccTime)dt{

        [self unschedule:@selector(timeschedule:)];
        [self sceneAfterDelay];
    
    
}

-(id) init {
	
	if( (self=[super init])) {
    

	}
     
	return self;
}

-(void)spinStar{
    
    CCSprite *star = [CCSprite spriteWithFile:@"loading_star.png"];
    [self addChild:star];
    star.position = ccp(ScreenSize.width/2,ScreenSize.height/2);
    star.scale = 1.5f;
    star.opacity = 180.f;

    [star runAction:[CCRotateBy actionWithDuration:0.5f angle:720]];
}

- (void) dealloc {
	
	[super dealloc];
}
@end
