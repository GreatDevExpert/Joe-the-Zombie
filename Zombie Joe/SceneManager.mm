//
//  SceneManager.m
// 

#import "SceneManager.h"
#import "Level1.h"
#import "Level5.h"
#import "Level7.h"
#import "Level8.h"
#import "Level3.h"
#import "level2.h"
#import "Level4.h"
#import "Level6.h"
#import "Level9.h"
#import "Level10.h"
#import "Level11.h"
#import "Level12.h"
#import "Level13.h"
#import "Level14.h"
#import "Level15.h"

#import "SimpleAudioEngine.h"
#import "MUSIC_C.h"

#define TAG_MAIN_LAYER 1
#define TAG_HUD_LAYER  2

@interface SceneManager ()


+(void) go: (CCLayer *) layer;
+(CCScene *) wrap: (CCLayer *) layer;

@end

@implementation SceneManager

/*  ___Template___________________________________
 
    Step 3 - Add implementation to call scene
    ______________________________________________
 

+(void) goSceneName {
    [SceneManager go:[SceneName node]];
}
 
*/

+(void)restartLevel:(CCLayer*)node_{
    
    [SceneManager go:node_];
    
}

+(void) goMainMenu {
    
    [delegater setOrientationLandscape:NO];
    
    [SceneManager go:[MainMenu node]];
    
    [music_ setMUSIC_MENU];

}

+(void) goGameScene:(int)level showTutorial:(BOOL)tutorial_ restart:(BOOL)restart_{
    
    CCDirector *director = [CCDirector sharedDirector];
    
    //*** dealloc textures
    
    /*
    
     [[CCDirector sharedDirector] purgeCachedData];
     [[CCTextureCache sharedTextureCache] removeAllTextures];
     [CCTextureCache purgeSharedTextureCache];
     [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
     [CCSpriteFrameCache purgeSharedSpriteFrameCache];
     [[CCTextureCache sharedTextureCache] dumpCachedTextureInfo];
     
     */
    
    // *** Retreive top player only if loading level for first time from menu scene, NOT when restarting
    
    if (!restart_)
    {
            [gc_ retrieveTopPlayerFromCategory:gc_LEVEL(level)];
    }
    
    CCScene *newScene = [CCScene node];
    
    //*** BG MUSIC FOR LEVEL

   [music_ setMUSIC_forLevelNR:level];
    
    InGameButtons *hud = [[[InGameButtons alloc]initWithRect:kInGameButtonViewRect level:level showtutorial:tutorial_]autorelease];
    [newScene addChild:hud z:1];
    hud.tag = TAG_HUD_LAYER;
    hud.level = level;
    
    //MUST CHECK ALL LEVELS COUNT BEFORE
    
    if (level==1) {
         [delegater setOrientationLandscape:NO];
        Level1 *layer_ = [[[Level1 alloc] initWithHUD:hud] autorelease];
        [newScene addChild:layer_];
        hud.admin = layer_;
        layer_.tag = TAG_MAIN_LAYER;
        
    }
    else if (level==2) {
        [delegater setOrientationLandscape:YES];
        level2 *layer_ = [[[level2 alloc] initWithHUD:hud] autorelease];
        [newScene addChild:layer_];
        hud.admin = layer_;
        layer_.tag = TAG_MAIN_LAYER;
    }
    else if (level==3) {
        [delegater setOrientationLandscape:NO];
        Level4 *layer_ = [[[Level4 alloc] initWithHUD:hud] autorelease];
        [newScene addChild:layer_];
        hud.admin = layer_;
        layer_.tag = TAG_MAIN_LAYER;
    }
    else if (level==4) {
        [delegater setOrientationLandscape:NO];
        Level6 *layer_ = [[[Level6 alloc] initWithHUD:hud] autorelease];
        [newScene addChild:layer_];
        hud.admin = layer_;
        layer_.tag = TAG_MAIN_LAYER;
    }
    else if (level==5) {
        [delegater setOrientationLandscape:YES];
        Level15 *layer_ = [[[Level15 alloc] initWithHUD:hud] autorelease];
        [newScene addChild:layer_];
        hud.admin = layer_;
        layer_.tag = TAG_MAIN_LAYER;
    }
    else if (level==6) {
        [delegater setOrientationLandscape:NO];
        Level3 *layer_ = [[[Level3 alloc] initWithHUD:hud] autorelease];
        [newScene addChild:layer_];
        hud.admin = layer_;
        layer_.tag = TAG_MAIN_LAYER;

    }
    else if (level==7) {
        [delegater setOrientationLandscape:YES];
        Level14 *layer_ = [[[Level14 alloc] initWithHUD:hud] autorelease];
        [newScene addChild:layer_];
        hud.admin = layer_;
        layer_.tag = TAG_MAIN_LAYER;
    }
    else if (level==8) {
        [delegater setOrientationLandscape:NO];
        Level5 *layer_ = [[[Level5 alloc] initWithHUD:hud] autorelease];
        [newScene addChild:layer_];
        hud.admin = layer_;
        layer_.tag = TAG_MAIN_LAYER;
    }
    else if (level==9) {
        [delegater setOrientationLandscape:NO];
        Level7 *layer_ = [[[Level7 alloc] initWithHUD:hud] autorelease];
        [newScene addChild:layer_];
        hud.admin = layer_;
        layer_.tag = TAG_MAIN_LAYER;
    }
    else if (level==10) {
        [delegater setOrientationLandscape:NO];
        Level13 *layer_ = [[[Level13 alloc] initWithHUD:hud] autorelease];
        [newScene addChild:layer_];
        hud.admin = layer_;
        layer_.tag = TAG_MAIN_LAYER;
    }
    else if (level==11) {
        [delegater setOrientationLandscape:NO];
        Level12 *layer_ = [[[Level12 alloc] initWithHUD:hud] autorelease];
        [newScene addChild:layer_];
        hud.admin = layer_;
        layer_.tag = TAG_MAIN_LAYER;
    }
    else if (level==12) {
        [delegater setOrientationLandscape:NO];
        Level11 *layer_ = [[[Level11 alloc] initWithHUD:hud] autorelease];
        [newScene addChild:layer_];
        hud.admin = layer_;
        layer_.tag = TAG_MAIN_LAYER;
    }
    else if (level==13) {
        [delegater setOrientationLandscape:NO];
        Level10 *layer_ = [[[Level10 alloc] initWithHUD:hud] autorelease];
        [newScene addChild:layer_];
        hud.admin = layer_;
        layer_.tag = TAG_MAIN_LAYER;
    }
    else if (level==14) {
        [delegater setOrientationLandscape:NO];
        Level8 *layer_ = [[[Level8 alloc] initWithHUD:hud] autorelease];
        [newScene addChild:layer_];
        hud.admin = layer_;
        layer_.tag = TAG_MAIN_LAYER;
    }
    else if (level==15) {
        [delegater setOrientationLandscape:YES];
        Level9 *layer_ = [[[Level9 alloc] initWithHUD:hud] autorelease];
        [newScene addChild:layer_];
        hud.admin = layer_;
        layer_.tag = TAG_MAIN_LAYER;
    }
    
    else {
        NSLog(@" EERRROR LEVEL LOADING, directing to level1");
        Level1 *layer_ = [[[Level1 alloc] initWithHUD:hud] autorelease];
        [newScene addChild:layer_];
        hud.admin = layer_;
    }
    
    if ([director runningScene])
    {
        if (restart_) {
            [director replaceScene :[CCTransitionFade transitionWithDuration:0.5f scene:newScene]];
        }
        else
        [director replaceScene :newScene];
    }
    else {
        [director runWithScene:newScene];
    }
    
}


+(void) go: (CCLayer *) layer {
    CCDirector *director = [CCDirector sharedDirector];
    
    CCScene *newScene = [SceneManager wrap:layer];

    if ([director runningScene]) {
        
        [director replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:newScene]];
    }
    else {
        [director runWithScene:newScene];
    }
}

+(CCScene *) wrap: (CCLayer *) layer {
    CCScene *newScene = [CCScene node];
    [newScene addChild: layer];
    return newScene;
}

@end
