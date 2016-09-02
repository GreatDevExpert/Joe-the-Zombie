//
//  AppDelegate.m
//  Zombie Joe
//
//  Created by Mac4user on 4/29/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "GameConfig.h"
#import "RootViewController.h"
#import "SceneManager.h"
#import "MainMenu.h"
#import "cfg.h"

@implementation AppDelegate

@synthesize window;
@synthesize minimized;

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	
	//	CC_ENABLE_DEFAULT_GL_STATES();
	//	CCDirector *director = [CCDirector sharedDirector];
	//	CGSize size = [director winSize];
	//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
	//	sprite.position = ccp(size.width/2, size.height/2);
	//	sprite.rotation = -90;
	//	[sprite visit];
	//	[[director openGLView] swapBuffers];
	//	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController
}
-(void)setOrientationLandscape:(BOOL)bool_
{
    if (bool_) {
        [viewController setOrientation:YES];
    }
    else
    {
        [viewController setOrientation:NO];
    }
}

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
    
    
    EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
                                   pixelFormat:kEAGLColorFormatRGB565//kEAGLColorFormatRGBA8
                                   depthFormat:0//GL_DEPTH_COMPONENT16_OES
                            preserveBackbuffer:YES
                                    sharegroup:nil
                                 multiSampling:NO
                               numberOfSamples:0
                        ];
    
    /*  old
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8    //kEAGLColorFormatRGB565
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
     */
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
    
    

    
 //   [glView setMultipleTouchEnabled:NO];
	
//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:NO];
	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	//[window addSubview: viewController.view];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0){
         window.rootViewController = viewController;
        
        [window setRootViewController:viewController];
    }
    else{
        [window addSubview:viewController.view];
    }
	
	[window makeKeyAndVisible];
    
    if (![Combinations checkNSDEFAULTS_Bool_ForKey:C_FIRST_GAME_RUN])
    {
        NSLog(@"FIRST GAME RUN !!!");
        [self firstGameRunSettings];
    }
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

    // *** TEMP UNLOCK LEVELS
    
    // ***
    
      //UNLOCK ALL
    
//    for (int x = 1; x < 16; x++)
//    {
//        [Combinations saveNSDEFAULTS_Bool:YES forKey:C_UNLOCK_LEVEL(x)];   //lock other levels
//    }
    
	
	// Removes the startup flicker
	[self removeStartupFlicker];
    
    [self goRunTheGame];
    
    NSLog(@"PURCHASE STATE %i",[Combinations checkNSDEFAULTS_Bool_ForKey:C_PURCHASE_DONE]);
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    if (![Combinations checkNSDEFAULTS_Bool_ForKey:C_INFOUSER])
    {
        [db SS_sendUserInfo:[gc_ getLocalPlayerAlias]];
    }
    
  // NSLog(@"%@ %@",[Combinations WhatsMyMachine],[Combinations WhatsMyiOSVersion]);
    
	// Run the intro Scene
	//[[CCDirector sharedDirector] runWithScene: [HelloWorldLayer scene]];
}

-(void)firstGameRunSettings{
    
   // [Combinations saveNSDEFAULTS_Bool:YES forKey:C_FIRST_GAME_RUN];
    
    [Combinations saveNSDEFAULTS_Bool:YES forKey:C_FX_ON];
    [Combinations saveNSDEFAULTS_Bool:YES forKey:C_MUSIC_ON];
    
    [Combinations saveNSDEFAULTS_Bool:YES forKey:C_UNLOCK_LEVEL(1)];
    [Combinations saveNSDEFAULTS_Bool:YES forKey:C_UNLOCK_LEVEL(2)];
    [Combinations saveNSDEFAULTS_Bool:YES forKey:C_UNLOCK_LEVEL(3)];
    [Combinations saveNSDEFAULTS_Bool:YES forKey:C_UNLOCK_LEVEL(4)];
    [Combinations saveNSDEFAULTS_Bool:YES forKey:C_UNLOCK_LEVEL(5)];
    
    [Combinations saveNSDEFAULTS_INT:0 forKey:C_GAME_RATED];
    
    [CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
    
    /*
    for (int x = 2; x < 16; x++)
    {
        [Combinations saveNSDEFAULTS_Bool:YES forKey:C_UNLOCK_LEVEL(x)];   //lock other levels
    }
    */
    
}

-(void)goRunTheGame{
    
    // ***
    
    
    // HAVE FUN !!! ;)
    
    
    // ***
    
    [SceneManager goMainMenu];
    //[[CCDirector sharedDirector] runWithScene: [MainMenu scene]];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
    
        minimized = NO;
    
    [self GC_CHECK_AND_AUTHENT];
}

-(void)GC_CHECK_AND_AUTHENT{
        
    [gc_ authenticateLocalPlayer];
 //   [gc_ checkTopPlayers];

}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
    minimized = YES;
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
    minimized = NO;
	[[CCDirector sharedDirector] startAnimation];
    [self GC_CHECK_AND_AUTHENT];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] end];
	[window release];
	[super dealloc];
}

@end
