
#import <Foundation/Foundation.h>

@interface MUSIC_C : NSObject{
    
    int MUSIC_trackID;
    int MUSIC_TYPE;
    NSString *name;
    NSArray *soundEffectsARR;
    
}

@property (assign) int MUSIC_trackID;
@property (assign) int MUSIC_TYPE;
@property (nonatomic,retain)  NSString *name;
@property (nonatomic,retain)     NSArray *soundEffectsARR;

+(id)shared;

-(int)getTRACKID;
-(void)setTRACKID:(int)ID;

-(void)setMUSIC_forLevelNR:(int)level_;
-(void)setMUSIC_MENU;

@end
