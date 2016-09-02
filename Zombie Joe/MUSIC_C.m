
#import "MUSIC_C.h"
#import "cfg.h"
#import "Strings.h"
#import "SimpleAudioEngine.h" 
#import "SoundManager.h"
#import "SOUND_EFFECTS_BASE.h"

#define MUSIC_MENU  999
#define MUSIC_LEVEL 888

#define S_PRELOAD(__X__) [AUDIO preloadEffect:(__X__)]    : [AUDIO unloadEffect:(__X__)]

@implementation MUSIC_C
@synthesize MUSIC_trackID;
@synthesize name;
@synthesize MUSIC_TYPE;
@synthesize soundEffectsARR;

+(id)shared{
    static id shared = nil;
    
    if (shared == nil) {
        
        shared = [[self alloc] init];
    }
    return shared;
}

-(void)setMUSIC_MENU{
    
    if (MUSIC_TYPE == MUSIC_LEVEL)
    {
       // [self unLoadSoundsForLevel:MUSIC_trackID];
        [self preLoadUnloadSoundsForLevel:MUSIC_trackID preload:NO];
        MUSIC_trackID = 0;
    }
    
    MUSIC_TYPE = MUSIC_MENU;
    
    [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"music_mainMenu2.mp3" loop:YES];
    
}

-(void)soundVolumeCheck{
    
    BOOL m = [Combinations checkNSDEFAULTS_Bool_ForKey:C_MUSIC_ON];

    if ([SimpleAudioEngine sharedEngine].backgroundMusicVolume  < 1 && m) {
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume  = 1;
    }
    
}

-(void)setMUSIC_forLevelNR:(int)level_{
    
    if (level_==MUSIC_trackID && MUSIC_TYPE!=MUSIC_MENU)
    {
            //    NSLog(@"level nr is the same,return");
        //restat state
        [self soundVolumeCheck];
        return;
    }
    
    //MUSIC_TYPE = MUSIC_LEVEL;
    
    if (MUSIC_trackID!=0)       //if was a level music was before -> unload it and all it's sound effects
    {
        [self soundVolumeCheck];    //next level state
        [self preLoadUnloadSoundsForLevel:MUSIC_trackID preload:NO];    // ->>> unload if NO
        [[SimpleAudioEngine sharedEngine]unloadEffect:[self bgMusicName:MUSIC_trackID]];
    }
    
    MUSIC_trackID = level_;
    MUSIC_TYPE = MUSIC_LEVEL;
    
            //***** Preload sound effects for level X
    
   [self preLoadUnloadSoundsForLevel:level_ preload:YES]; //preload sounds effects and bg music for the level

            //**** Play the BG MUSIC for level X
    
   [[SimpleAudioEngine sharedEngine]playBackgroundMusic:[self bgMusicName:level_] loop:YES];
    
}

-(NSString*)bgMusicName:(int)level_{
    
    if      (level_==1) return @"lvl1_music.mp3";
    else if (level_==2) return @"lvl9_river.mp3";
    else if (level_==3) return @"music_spookie.mp3";
    else if (level_==4) return @"music_fun.mp3";
    else if (level_==5) return @"music_sample2.mp3";
    else if (level_==6) return @"music_fun.mp3";
    else if (level_==7) return @"music_fun.mp3";
    else if (level_==8) return @"music_sample.mp3";
    else if (level_==9) return @"lvl9_river.mp3";
    else if (level_==10)return @"music_sample2.mp3";
    else if (level_==11)return @"music_sample4.mp3";
    else if (level_==12)return @"music_misc3.mp3";
    else if (level_==13)return @"music_flyLevel.mp3";
    else if (level_==14)return @"music_flyLevel.mp3";
    else if (level_==15)return @"music_flyLevel.mp3";
    
    return @"";
    
}

-(void)preLoadUnloadSoundsForLevel:(int)level_ preload:(BOOL)preload_{
    

    
    if (level_==1)
    {
        (preload_) ? S_PRELOAD(l1_item_got);
        (preload_) ? S_PRELOAD(l1_bird_tapped);
      //  (preload_) ? S_PRELOAD(l1_itemclick);
    }

    else if (level_==4)
    {
        (preload_) ? S_PRELOAD(l4_jump);
        (preload_) ? S_PRELOAD(l4_clap);
        (preload_) ? S_PRELOAD(l4_fall);
    }
   else if (level_==5){
       (preload_) ? S_PRELOAD(l5_catcatch);
       (preload_) ? S_PRELOAD(l5_falldown);
       (preload_) ? S_PRELOAD(l5_momsadsound);
       (preload_) ? S_PRELOAD(l5_babybirdrandom);
       (preload_) ? S_PRELOAD(l5_hitobstacle);
       (preload_) ? S_PRELOAD(l1_itemclick);
       (preload_) ? S_PRELOAD(l5_doorOpen);
       (preload_) ? S_PRELOAD(l5_momPushjoe);
    }
    
   else if (level_==7){
        (preload_) ? S_PRELOAD(l7_birdClap);
        (preload_) ? S_PRELOAD(l7_giraffeshow);
        (preload_) ? S_PRELOAD(fx_misc_1);
        (preload_) ? S_PRELOAD(l7_giraffeclick);
    }
  else if (level_==8){
          (preload_) ? S_PRELOAD(l5_falldown);
       // (preload_) ? S_PRELOAD(l8_rockSlide);
    }
    else if (level_==9){
        (preload_) ? S_PRELOAD(l9_monster);
    
    }
    else if (level_==10)
    {
        (preload_) ? S_PRELOAD(l10_blockMove);
        
    }
    else if (level_==14)
    {
        (preload_) ? S_PRELOAD(l14_laserhit);
        (preload_) ? S_PRELOAD(l14_diamondpick);
        (preload_) ? S_PRELOAD(l14_diamonddrop);
        (preload_) ? S_PRELOAD(l14_dooropen);
        
    }
    
    else if(level_ == 3)
    {
        (preload_) ? S_PRELOAD(l3_diamondInsert);
        (preload_) ? S_PRELOAD(l3_mouthOpen);
        (preload_) ? S_PRELOAD(l3_doorOpen);
        (preload_) ? S_PRELOAD(l3_mouthClose);
        (preload_) ? S_PRELOAD(l3_monsterSlide);
        (preload_) ? S_PRELOAD(l3_monsterLaugh);
        (preload_) ? S_PRELOAD(l3_gearSpund);
    }

    else if (level_==12)
    {
        (preload_) ? S_PRELOAD(l12_beeGo);
        (preload_) ? S_PRELOAD(l12_flower);
        (preload_) ? S_PRELOAD(l12_speedUp);
        
    }
    else if (level_==15)
    {
        (preload_) ? S_PRELOAD(l15_fly);
        (preload_) ? S_PRELOAD(l15_flower);
        (preload_) ? S_PRELOAD(l15_bee);
    }
    
    
   else  if (level_==2) // Level 2
    {
        (preload_) ? S_PRELOAD(l2_dropletglass);
        (preload_) ? S_PRELOAD(l2_baddroplet);
        (preload_) ? S_PRELOAD(l2_dropletwater);
        (preload_) ? S_PRELOAD(l2_monster2);
    }
    
    else if (level_==4) // Level 6
    {
        (preload_) ? S_PRELOAD(l4_jump);
        (preload_) ? S_PRELOAD(l4_clap);
        (preload_) ? S_PRELOAD(l4_fall);
    }
   else if (level_==11) // Level 12
    {
        (preload_) ? S_PRELOAD(l11_brickHit);
        (preload_) ? S_PRELOAD(l11_jump);
        (preload_) ? S_PRELOAD(l11_clap);
        (preload_) ? S_PRELOAD(l11_fall);
        (preload_) ? S_PRELOAD(l11_speedUp);
        (preload_) ? S_PRELOAD(l11_speedDown);
    }
    else if (level_==13) // Level 10
    {
        (preload_) ? S_PRELOAD(l13_jump);
        (preload_) ? S_PRELOAD(l13_clap);
        (preload_) ? S_PRELOAD(l13_speedDown);
        (preload_) ? S_PRELOAD(l13_hitRail2);
        (preload_) ? S_PRELOAD(l13_monster);
        (preload_) ? S_PRELOAD(l13_monster2);
    }


}


-(int)getTRACKID{
    
    return MUSIC_trackID;
    
}

-(void)setTRACKID:(int)ID{
    
    MUSIC_trackID = ID;
    
}

-(id) init
{
    if ( (self=[super init]) ) {
           
        [self preloadSoundEffects];
        
    }
    return self;
}

-(void)preloadSoundEffects{
    
    [AUDIO preloadEffect:fx_buttonclick];  
    [AUDIO preloadEffect:fx_winmusic];
    [AUDIO preloadEffect:fx_loosemusic];
    [AUDIO preloadEffect:joe_s_hitSpikes];
    [AUDIO preloadEffect:fx_blockGot];
    [AUDIO preloadEffect:l1_itemclick];
    [AUDIO preloadEffect:fx_brainGet];
    [AUDIO preloadEffect:fx_newrecord];
}

@end
