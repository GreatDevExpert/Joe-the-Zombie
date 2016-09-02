//
//  B6luxPopUpManager.h
//  Zombie Joe
//
//  Created by Slavian on 2013-07-25.
//
//

#import "cocos2d.h"

typedef  enum{
            levelUnlock,
            infoPopUp
        }popUpType;

@interface B6luxPopUpManager : CCSprite<CCTargetedTouchDelegate>
{
    BOOL popUpIsShowing;
    BOOL b_infoPopUp;
    BOOL b_isShared;
    int levelNr;
}

-(int)returnLevelNr;
-(void)submitShare;
-(void)addPopUpWithType:(popUpType)type_ level:(int)level_;
-(void)removePopUpWithType:(popUpType)type_;
+(void)internetConnectionPopUp;

@end
