//
//  HelloWorldLayer.h
//  Level15
//
//  Created by macbook on 2013-06-30.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "LevelHelperLoader.h"
#import "BabyBirdC.h"
#import "GoinCharacter.h"
#import "BirdMom.h"
#import "MomPopup.h"

#import "PauseMenu.h"
#import "InGameButtons.h"

// HelloWorldLayer
@interface Level15 : CCLayer<pauseDelegate>
{
    InGameButtons * _hud;
    LevelHelperLoader *loader;
	b2World* world;
	GLESDebugDraw *m_debugDraw;

    BabyBirdC *baby;
    
    float bodyRotateFactor;
    BOOL momFallowBaby;
    
    GoinCharacter *CHARACTER_GO;
    
    BOOL enableMoveBaby;
    
    BirdMom *MOM;
    
    MomPopup *POP;
    
    BOOL pause;
    
    BOOL removeWorld;
    
    BOOL win;
    
}

- (id)initWithHUD:(InGameButtons *)hud;

-(void)lostSceneShow;

// returns a CCScene that contains the HelloWorldLayer as the only child
//+(CCScene *) scene;
// adds a new sprite at a given coordinate

@end
