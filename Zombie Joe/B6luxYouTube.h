//
//  B6luxYouTube.h
//  Zombie Joe
//
//  Created by Slavian on 2013-07-24.
//
//

#import "cocos2d.h"

@interface B6luxYouTube : CCSprite<CCTargetedTouchDelegate,UIWebViewDelegate>
{
    UIWebView* webView;
    BOOL playEnd;
    BOOL isFullScreen;
}

-(void)playVideoFromURL:(NSString *)url_;

@end
