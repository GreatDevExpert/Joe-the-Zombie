//
//  SceneManager.h
//  

#import <Foundation/Foundation.h>
#import "cocos2d.h"

/*  ___Template___________________________________

    Step 1 - Import header of your SceneName
    ______________________________________________
 
#import "SceneName.h"
 
*/
#import "MainMenu.h"

@interface SceneManager : NSObject {
    
}

/*  ___Template___________________________________
    
    Step 2 - Add interface scene calling method
    ______________________________________________
 
+(void) goSceneName; 
 
*/

+(void)restartLevel:(CCLayer*)node_;

+(void) goMainMenu;
+(void) goGameScene:(int)level showTutorial:(BOOL)tutorial_ restart:(BOOL)restart_;

@end
