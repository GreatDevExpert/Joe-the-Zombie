#import "b6luxHelper.h"


@implementation b6luxHelper

+(int)CountActorsByTag:(int)type_ fromLoader:(LevelHelperLoader*)loader_{
    
    int count = 0;
    
    for (LHSprite *s in [loader_ allSprites])
    {
        if (s.tag == type_)
        {
            count++;
        }
    }
    
    return count;
    
}



@end

