#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Combinations.h"
#import "AppDelegate.h"
#import "Singelton.h"
#import "Constants.h"   
#import "DB.h"
#import "InGameButtons.h"
#import "MUSIC_C.h"
#import "SimpleAudioEngine.h"
#import "SOUND_EFFECTS_BASE.h"
#import "AppDelegate.h"
#import "B6luxGameKitHelper.h"
#import "SoundManager.h"

#define delegater        (AppDelegate *)[[UIApplication sharedApplication] delegate]

//TURN OFF COLLIDERS OF LEVEL

#define LOCK_LEVELS NO     // Unlock all levels

#define Z_TUTORIAL 20

#define L3_COLLIDERS YES
#define L9_COLLIDERS NO

#define SOUND_          [SoundManager sharedManager]
#define gc_             [B6luxGameKitHelper sharedB6luxGameKitHelper]
#define music_          (MUSIC_C*)[MUSIC_C shared]
#define db              [DB access]
#define AUDIO           [SimpleAudioEngine sharedEngine]

#define C_FIRST_GAME_RUN    @"FIRST_GAME_RUN"
#define C_BRAINS_COUNT      @"BrainCounter"
#define C_GAME_RATED        @"GAME_RATE"
#define C_GAME_SHARED       @"GAME_SHARED"
#define C_FX_ON             @"FXON"
#define C_MUSIC_ON          @"MusicOn"
#define C_PURCHASE_DONE     @"PRCHDN"
#define C_INFOUSER          @"USERINFO"
#define C_BRAIN_RECORD_LEVEL(__X__) [NSString stringWithFormat:@"BrainRecLevel%i_",(__X__)]

#define C_TUTORIAL_(__X__)               [NSString stringWithFormat:@"TUT_L%i",(__X__)]
#define C_UNLOCK_LEVEL(__X__)            [NSString stringWithFormat:@"LOCKL%i",(__X__)]

#define kSCALEVAL_IPHONE (IS_IPHONE_5) ? 0.625f : 0.46875f
#define kSCALEVALY (IS_IPAD) ? 1.f : 0.46875f
#define kSCALEVALX (IS_IPAD) ? 1.f : kSCALEVAL_IPHONE
#define kSCALE_FACTOR_FIX ([Combinations isRetina]) ? 1.f : 0.5f

#define kPAUSE 1000
#define kMENUBUTTONSTAG 100020

#define touch_InGameMenu -10
#define touch_PAUSEMENU -11
#define touchTutorial   -12

#define kPAUSE_WINDOW_TAG 600
#define kWIN_WINDOW_TAG   601
#define kLOOSE_WINDOW_TAG 602
#define kRESTART_WINDOW_TAG 603


#define TUTORIAL_TYPE_PAUSED     1
#define TUTORIAL_TYPE_STARTLEVEL 2

#define RETINA_FIX      ([Combinations isRetina]) ? 0 : 0
#define kWidthScreen    (ScreenSize.width)                  //*(RETINA_FIX))   //[Combinations give_me_screen_width]
#define kHeightScreen   (ScreenSize.height)                 //*(RETINA_FIX))  //[Combinations give_me_screen_height]

#define kMenuZombieWindowW ((kWidthScreen)*0.4f)
#define kMenuZombieWindowH (kHeightScreen)

#define kMenuScrollerIPHONEX        (IS_IPHONE_5) ? 12.5f : -(10)
#define kMenuLevelScrollerWindowW   (IS_IPAD)     ? 580 : 265
#define kMenuLevelScrollerWindowH   (IS_IPAD)     ? 525 : 250
#define kMenuLevelScrollerWindowX   (IS_IPAD)     ? 195 : (101)+(kMenuScrollerIPHONEX)
#define kMenuLevelScrollerWindowY   0

#define kInGameButtonViewW          kWidthScreen
#define kInGameButtonViewH          (IS_IPAD) ? 60.f : 40.f
#define kInGameButtonViewX          0
#define kInGameButtonViewY          kHeightScreen
#define kInGameButtonViewRect        CGRectMake(kInGameButtonViewX,kInGameButtonViewY,kInGameButtonViewW,kInGameButtonViewH)

#define kPauseMenuW     kWidthScreen
#define kPauseMenuH     ((kHeightScreen)*0.60f)

#define TAG_BLAST   2131

#define TAG_BRAIN_1 9001
#define TAG_BRAIN_2 9002
#define TAG_BRAIN_3 9003

// *** 08-01

#define kSCALEVALLOADINGY (IS_IPAD) ? 0.8f : 0.46875f
#define kSCALEVALLOADINGX (IS_IPAD) ? 0.8f : 0.46875f

#define kSCALELOADING_FACTOR_FIX ([Combinations isRetina]) ? 0.5f : 0.5f


#define VideoLink @"https:/www.youtube.com/embed/L3MMReK8UKM"
#define iTunesLink @"https://itunes.apple.com/us/app/joe-the-zombie/id673088915?ls=1&mt=8"
#define facebookImageLink @"http://api.b6lux.com/ext/fb_zombie_bg.png"
#define facebookZombieJoeLink @"https://apps.facebook.com/joethezombie/"

#define facebookPOSTtxt @"Check out my high score from Joe the Zombie game."
#define facebookSHAREtxt @"Do you have what it takes to help Joe to jump, fly, ride, think and find his way to the lost love? So what are you waiting for? Come in and help Joe the Zombie!"

#define facebookSHAREname @"I'm playing the Joe The Zombie."

#define twitterSharetxt @"Join Joe the Zombie and help in his adventure!"

#define twitterPOSTtxt @"Check out my high score from Joe the Zombie game."

#define purchaseIndetifier @"level_purchase"


#define twiiterViewTAG 888999
#define facebookViewTAG 777888
#define kLOADINGTAG 9191919

//


///FONT ATLAS

#define fntPadLARGE   ([Combinations isRetina]) ? @"startlight_font72.fnt" : @"startlight_font32.fnt"
#define fntPhoneLARGE ([Combinations isRetina]) ? @"startlight_font32.fnt" : @"startlight_font16.fnt"

#define fntSUPERPadLARGE   (kSCALE_FACTOR_FIX) ? @"256.fnt" : @"128.fnt"
#define fntPhoneSUPERLARGE (kSCALE_FACTOR_FIX) ? @"128.fnt" : @"48.fnt"

#define kFONT_LARGE (IS_IPAD) ? fntPadLARGE : fntPhoneLARGE

#define kFONT_SUPER_LARGEIPAD  ([Combinations isRetina]) ?   fntSUPERPadLARGE :  @"128.fnt"
#define kFONT_SUPER_LARGE (IS_IPAD) ? kFONT_SUPER_LARGEIPAD : fntPhoneSUPERLARGE

#define fFONT_MENU_BLACKLINE_LABELS (IS_IPAD) ? 25 :    25*0.46875f
#define kFontMenuYFix (IS_IPAD) ? 4 : 1.87f

#define WIN_MOVEINTIME 0.65f    

#define COL_YELLOW_DARK   ccc3(238,195,23)
#define COL_GREEN         ccc3(208,254,27)   



@interface cfg : NSObject{
    

    
}

+(NSString*)postSoscialWith_level:(int)level_;

+(UIImage*) screenshotUIImage_2;

+(UIImage*) takeAsUIImage;

+(void)runSelectorTarget:(id)target_ selector:(SEL)sel_ object:(id)obj_ afterDelay:(float)delay_ sender:(id)sender_;

+(void)makeBrainActionForNode:(CCNode*)node_
               fakeBrainsNode:(CCNode*)fakeBrain_
                    direction:(int)dir_
                 pixelsToMove:(float)pix_
                         time:(float)time_
                       parent:(CCNode*)parent_
            removeBrainsAfter:(BOOL)remove_
           makeActionAfterall:(SEL)sel_
                       target:(id)target_;

+(void)makeBrainActionForNode:(CCNode*)node_
               fakeBrainsNode:(CCNode*)fakeBrain_
                    direction:(int)dir_
                 pixelsToMove:(float)pix_
                       parent:(CCNode*)parent_
            removeBrainsAfter:(BOOL)remove_
           makeActionAfterall:(SEL)sel_
                       target:(id)target_;

+(void)brainMoveUpdDownAction:(CCNode*)node_;

+(CGSize)getScoresByLevel:(int)level_ time:(int)timeMS_ brains:(int)brains_;

+(BOOL)ifCihildExistInNode:(CCNode*)node_ tag:(int)tag_;

+(void)addTEMPBGCOLOR:(CCNode*)node_ anchor:(CGPoint)anchor_ color:(ccColor3B)color_;

+(void)addBG_forNode:(CCNode*)node_ withCCZ:(NSString*)ccz_ bg:(NSString*)bg_;

+(NSInteger)MyRandomIntegerBetween:(int)min :(int)max;

+(void)clickEffectForButton:(CCNode*)node_;

+(void)clickEffectForButton:(CCNode*)node_ duration:(float)d_;

@end
