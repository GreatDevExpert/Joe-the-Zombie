#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "cfg.h"

#define l5_nr_ofSliders 8
#define kSliderW    ((kWidthScreen)/(l5_nr_ofSliders))
#define kSliderH    ((kHeightScreen)*2)

#define col_Tag 200
#define col0    0+(col_Tag)
#define col1    1+(col_Tag)
#define col2    2+(col_Tag)
#define col3    3+(col_Tag)
#define col4    4+(col_Tag)
#define col5    5+(col_Tag)
#define col6    6+(col_Tag)
#define col7    7+(col_Tag)

#define characterW          ((kSliderW)/2)
#define characterH          characterW
#define kCHARACTERTAG       929
#define kBottom             100        


#define SliderTrackAreaBrain            111

#define SliderTrackAreaTagYELLOW        110
#define SliderTrackAreaTagBLUE          112
#define SliderTrackAreaTagGREEN         113

#define SliderTrackAreaTagTRAP          114

#define SPEED_YELLOW       (IS_IPAD)     ?  (1.f/3) : (1.f/9) 
#define SPEED_GREEN        (IS_IPAD)     ?  (1.f/2) : (1.f/6) 
#define SPEED_BLUE         (IS_IPAD)     ?  (1.f/1) : (1.f/3) 
#define SPEED_LOW          (IS_IPAD)     ?  (1.f/5) : (1.f/15) 