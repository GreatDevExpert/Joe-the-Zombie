#import "cfg.h"
#import "Combinations.h"
#import <QuartzCore/QuartzCore.h>
#import "Strings.h"
#import "cocos2d.h"


@implementation cfg

+(NSString*)postSoscialWith_level:(int)level_{
    
    return [NSString stringWithFormat:@"My high score on level %i from Joe the Zombie game.",level_];
    
}

+(UIImage*) screenshotUIImage_2

{
    
	CGSize displaySize	= [[CCDirector sharedDirector] winSizeInPixels];
	CGSize winSize		= [[CCDirector sharedDirector] winSizeInPixels];
    
	//Create buffer for pixels
	GLuint bufferLength = displaySize.width * displaySize.height * 4;
	GLubyte* buffer = (GLubyte*)malloc(bufferLength);
    
	//Read Pixels from OpenGL
	glReadPixels(0, 0, displaySize.width, displaySize.height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
	//Make data provider with data.
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, bufferLength, NULL);
    
	//Configure image
	int bitsPerComponent = 8;
	int bitsPerPixel = 32;
	int bytesPerRow = 4 * displaySize.width;
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
	CGImageRef iref = CGImageCreate(displaySize.width, displaySize.height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
	uint32_t* pixels = (uint32_t*)malloc(bufferLength);
	CGContextRef context = CGBitmapContextCreate(pixels, winSize.width, winSize.height, 8, winSize.width * 4, CGImageGetColorSpace(iref), kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
	CGContextTranslateCTM(context, 0, displaySize.height);
	CGContextScaleCTM(context, 1.0f, -1.0f);
    
    UIDeviceOrientation orientation = [[CCDirector sharedDirector]deviceOrientation];
	switch (orientation)
	{
		case UIDeviceOrientationPortrait: break;
		case UIDeviceOrientationPortraitUpsideDown:
			CGContextRotateCTM(context, CC_DEGREES_TO_RADIANS(180));
			CGContextTranslateCTM(context, -displaySize.width, -displaySize.height);
			break;
		case UIDeviceOrientationLandscapeLeft:
			CGContextRotateCTM(context, CC_DEGREES_TO_RADIANS(-90));
			CGContextTranslateCTM(context, -displaySize.height, 0);
			break;
		case UIDeviceOrientationLandscapeRight:
			CGContextRotateCTM(context, CC_DEGREES_TO_RADIANS(90));
			CGContextTranslateCTM(context, displaySize.width * 0.5f, -displaySize.height);
			break;
        case UIDeviceOrientationUnknown:
            break;
        case UIDeviceOrientationFaceUp:
            break;
        case UIDeviceOrientationFaceDown:
            break;
	}
    
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, displaySize.width, displaySize.height), iref);
	CGImageRef imageRef = CGBitmapContextCreateImage(context);
	UIImage *outputImage = [UIImage imageWithCGImage:imageRef];
    
	//Dealloc
	CGImageRelease(imageRef);
	CGDataProviderRelease(provider);
	CGImageRelease(iref);
	CGColorSpaceRelease(colorSpaceRef);
	CGContextRelease(context);
	free(buffer);
	free(pixels);
    
	return outputImage;
    
}

+(UIImage*) takeAsUIImage
{

}
    /*
    CCDirector* director = [CCDirector sharedDirector];
    CGSize size =CGSizeMake(kWidthScreen, kHeightScreen);
    
    //Create buffer for pixels
    GLuint bufferLength = size.width * size.height * 4;
    GLubyte* buffer = (GLubyte*)malloc(bufferLength);
    
    //Read Pixels from OpenGL
    glReadPixels(0, 0, size.width, size.height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    //Make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, bufferLength, NULL);
    
    //Configure image
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * size.width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef iref = CGImageCreate(size.width, size.height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    uint32_t* pixels = (uint32_t*)malloc(bufferLength);
    CGContextRef context = CGBitmapContextCreate(pixels, [director winSize].width, [director winSize].height, 8, [director winSize].width * 4, CGImageGetColorSpace(iref), kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextTranslateCTM(context, 0, size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    switch (director.deviceOrientation)
    {
        case CCDeviceOrientationPortrait:
            break;
        case CCDeviceOrientationPortraitUpsideDown:
            CGContextRotateCTM(context, CC_DEGREES_TO_RADIANS(180));
            CGContextTranslateCTM(context, -size.width, -size.height);
            break;
        case CCDeviceOrientationLandscapeLeft:
            CGContextRotateCTM(context, CC_DEGREES_TO_RADIANS(-90));
            CGContextTranslateCTM(context, -size.height, 0);
            break;
        case CCDeviceOrientationLandscapeRight:
            CGContextRotateCTM(context, CC_DEGREES_TO_RADIANS(90));
            CGContextTranslateCTM(context, size.width * 0.5f, -size.height);
            break;
    }
    
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), iref);
    UIImage *outputImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    
    //Dealloc
    CGDataProviderRelease(provider);
    CGImageRelease(iref);
    CGContextRelease(context);
    free(buffer);
    free(pixels);
    
    return outputImage;
     */

//*****NEVER BRAIN ACTION
+(void)makeBrainActionForNode:(CCNode*)node_
               fakeBrainsNode:(CCNode*)fakeBrain_
                    direction:(int)dir_
                 pixelsToMove:(float)pix_
                         time:(float)time_
                       parent:(CCNode*)parent_
            removeBrainsAfter:(BOOL)remove_
           makeActionAfterall:(SEL)sel_
                       target:(id)target_{
    
    if (pix_==0)
    {
        pix_=60;
    }
    
    float angle = dir_;
    CGPoint destination  = CGPointMake(pix_*(cos(-CC_DEGREES_TO_RADIANS(angle))),
                                       pix_*(sin(-CC_DEGREES_TO_RADIANS(angle))));
    
    CGPoint point = ccpAdd(node_.position, destination);
    
    // NSLog(@"node pos %f %f  --- point now %f %f with angle %f",node_.position.x,node_.position.y,point.x,point.y,angle);
    
    CCNode *brains = [[[CCNode alloc]init]autorelease];
    
    
    if (fakeBrain_!=nil)
    {
        node_.visible = NO;
        
        [parent_ addChild:brains];
        brains.position = node_.position;
        brains = fakeBrain_;
    }
    
    id fly =   [CCMoveTo actionWithDuration:time_ position:point];   //ccp(node_.position.x+posX, node_.position.y+posY)];
    id fly_ =  [CCEaseElasticInOut actionWithAction:fly period:1.f];
    
    id addParticle = [CCCallBlock actionWithBlock:^(void){
        
        CCParticleSystemQuad *brainBlow = [CCParticleSystemQuad particleWithFile:[NSString stringWithFormat: @"brain_take_5.plist"/*,kDevice*/]];
        brainBlow.position = point;
        // brainBlow.scale = 0.5f;
        
        [parent_ addChild:brainBlow z:9999];
   //     brainBlow.autoRemoveOnFinish = YES;
        
    }];
    
    id removeAll = [CCCallBlock actionWithBlock:^(void){
        
        if (remove_)
        {
            [node_ removeFromParentAndCleanup:NO];
            [brains removeFromParentAndCleanup:NO];
        }
        else if (!remove_){
            node_.visible = 0;
            node_.position = ccp(0, 0);
            brains.visible = 0;
        }
        
    }];
    
    id selector_ = [CCCallFuncN actionWithTarget:target_ selector:sel_];
    
    id seq = [CCSequence actions:fly_,addParticle,removeAll,selector_, nil];
    
    if (fakeBrain_==nil)
    {
        [node_ runAction:seq];
    }
    else [brains runAction:seq];
    
}



+(void)makeBrainActionForNode:(CCNode*)node_
               fakeBrainsNode:(CCNode*)fakeBrain_
                    direction:(int)dir_
                 pixelsToMove:(float)pix_
                       parent:(CCNode*)parent_
            removeBrainsAfter:(BOOL)remove_
           makeActionAfterall:(SEL)sel_
                       target:(id)target_{
    
    if (pix_==0)
    {
        pix_=60;
    }
    
    float angle = dir_;
    CGPoint destination  = CGPointMake(pix_*(cos(-CC_DEGREES_TO_RADIANS(angle))),
                                       pix_*(sin(-CC_DEGREES_TO_RADIANS(angle))));
    
    CGPoint point = ccpAdd(node_.position, destination);
    
    // NSLog(@"node pos %f %f  --- point now %f %f with angle %f",node_.position.x,node_.position.y,point.x,point.y,angle);
    
    CCNode *brains = [[[CCNode alloc]init]autorelease];
    
    
    if (fakeBrain_!=nil)
    {
        node_.visible = NO;
        
        [parent_ addChild:brains];
        brains.position = node_.position;
        brains = fakeBrain_;
    }
    
    id fly =   [CCMoveTo actionWithDuration:0.3f position:point];   //ccp(node_.position.x+posX, node_.position.y+posY)];
    id fly_ =  [CCEaseElasticInOut actionWithAction:fly period:1.f];
    
    id addParticle = [CCCallBlock actionWithBlock:^(void){
        
        CCParticleSystemQuad *brainBlow = [CCParticleSystemQuad particleWithFile:[NSString stringWithFormat: @"brain_take_5.plist"/*,kDevice*/]];
        brainBlow.position = point;
        // brainBlow.scale = 0.5f;
        
        [parent_ addChild:brainBlow z:10];
       // brainBlow.autoRemoveOnFinish = YES;
        
    }];
    
    id removeAll = [CCCallBlock actionWithBlock:^(void){
        
        if (remove_)
        {
            [node_ removeFromParentAndCleanup:NO];
            [brains removeFromParentAndCleanup:NO];
        }
        else if (!remove_){
            node_.visible = 0;
            node_.position = ccp(0, 0);
            brains.visible = 0;
        }
        
    }];
    
    id selector_ = [CCCallFuncN actionWithTarget:target_ selector:sel_];
    
    id seq = [CCSequence actions:fly_,addParticle,removeAll,selector_, nil];
    
    if (fakeBrain_==nil)
    {
        [node_ runAction:seq];
    }
    else [brains runAction:seq];
    
}


+(void)brainMoveUpdDownAction:(CCNode*)node_{
    
    float moveDist = 10;
    
    id moveUp = [CCMoveTo actionWithDuration:0.5f position:ccpAdd(node_.position, ccp(0,moveDist))];
    id move_ease = [CCEaseSineInOut actionWithAction:[[moveUp copy] autorelease]];
    id rev =    [CCMoveTo actionWithDuration:0.5f position:ccpAdd(node_.position, ccp(0,-moveDist))];
    id move_ease_rev = [CCEaseSineInOut actionWithAction:[[rev copy] autorelease]];
    id seq = [CCSequence actions:move_ease,move_ease_rev, nil];
    [node_ runAction:[CCRepeatForever actionWithAction:seq]];
    
}

+(CGSize)getScoresByLevel:(int)level_ time:(int)timeMS_ brains:(int)brains_{
    
    NSString *floatSECTIME = [NSString stringWithFormat:@"%f",timeMS_ / 60.];
    
    float timeSEC = [floatSECTIME floatValue];
    
    float percentScored = 0;
    float scoreGot = 0;
    
    float min = 0;                 //  the fastest sec
    float max = 0;                //  60 sec - lowest
    float minScore = 0;          //  lowest score.
    float maxScore = 0;         //max score
    
    //brain fix -> score depends on brain nr
    brains_ = (brains_+1); 
    
    if      (level_==1)
        {
            min = 2;
            max = 7;
        }
    else  if (level_==2)
    {
        min = 34;
        max = 100;
    }
  else  if (level_==3)
    {
        /*
        min = 15;
        max = 45;
         */
        min = 4;
        max = 15;
    }
  else  if (level_==4)
  {
      /*
      min = 6;
      max = 15;
       */
      min = 21;
      max = 60;
  }
  else  if (level_==5)
  {
      /*
      min = 23;
      max = 70;
      */
      
      min = 15;
      max = 45;

  }
  else  if (level_==6)
  {
      /*
      min = 26;
      max = 80;
      */
      
      min = 15;
      max = 40;
  }
  else  if (level_==7)
  {
      /*
      min = 11;
      max = 30;
       */
      min = 37;
      max = 90;
  }
  else  if (level_==8)
  {
      /*
      min = 9;
      max = 40;
       */
      min = 22;
      max = 60;
  }
  else  if (level_==9)
  {
      /*
      min = 70;
      max = 150;
       */
      min = 11;
      max = 30;
  }

  else  if (level_==10)
  {
      /*
      min = 65;
      max = 210;
       */
      min = 10;
      max = 30;
  }
  else  if (level_==11)
  {
      /*
      min = 65;
      max = 210;
       */
      min = 45;
      max = 120;
  }
  else  if (level_==12)
  {
      /*
      min = 65;
      max = 210;
       */
      min = 65;
      max = 180;
  }
  else  if (level_==13)
  {
      /*
      min = 10;
      max = 30;
       */
      min = 53;
      max = 150;
  }
  else  if (level_==14)
  {
      /*
      min = 40;
      max = 120;
       */
      min = 5;
      max = 15;
  }
  else  if (level_==15)
  {
      min = 70;
      max = 210;
      /*
      min = 15;
      max = 45;
       */
  }
    
    //***STATIC MIN-MAX SCORES
    
    minScore  = 1000;
    maxScore  = 10000;
    
    min = min * brains_;
    max = max * brains_;
    
    /*  *** WHEN SCORE STATIC
    
    minScore = minScore * 3;    //always max -> 3 // brains_
    maxScore = maxScore * 3;    //
     
     */

    //percentScored = timeSEC*(100)/max-min;
    
    percentScored = ((timeSEC-min)/(max-min))*100;
    
    percentScored=100-percentScored;
    
    scoreGot = (percentScored*maxScore)/100;
    
    if (scoreGot < 0)
    {
        scoreGot = minScore;
    }
    
    if (percentScored  > 100) {
        percentScored = 100;
    }
    
    else if (percentScored <= 0)
    {
        percentScored = 10;
    }
    
    
    
  //  float bonus = (16.666666f * brains_)/100;
    
   // return CGSizeMake(scoreGot+(scoreGot*bonus), (percentScored/2)+(percentScored*bonus));
    
    return CGSizeMake(scoreGot,percentScored);    //max 50 proc
}


+(void)addTutorialVIEW:(CCNode*)node_ {
    
    /*
     
     
     
     */
    
}



+(void)clickEffectForButton:(CCNode*)node_ duration:(float)d_{
    if (![node_ getActionByTag:9998876]) {
        id scaleDown = [CCScaleTo actionWithDuration:d_ scale:node_.scale-0.1f];
        id rescale = [CCScaleTo actionWithDuration:d_ scale:node_.scale];
        id seq = [CCSequence actions:scaleDown,rescale, nil];
        [node_ runAction:seq].tag = 9998876;
    }
}

+(void)clickEffectForButton:(CCNode*)node_{
    if (![node_ getActionByTag:8787377]) {
        id scaleDown = [CCScaleTo actionWithDuration:0.1f scale:node_.scale-0.1f];
        id rescale = [CCScaleTo actionWithDuration:0.1f scale:node_.scale];
        id seq = [CCSequence actions:scaleDown,rescale, nil];
        [node_ runAction:seq].tag = 8787377;
    }
}

+(void)addTEMPBGCOLOR:(CCNode*)node_ anchor:(CGPoint)anchor_ color:(ccColor3B)color_{
    
  //  NSLog(@"add temp bg");
    
    CCSprite *blackBoard = [[[CCSprite alloc]init]autorelease];
    
    [blackBoard setTextureRect:CGRectMake(0, 0, node_.contentSize.width,
                                                node_.contentSize.height)];
    blackBoard.position = ccp(0,0);
    blackBoard.opacity = 200;
    blackBoard.anchorPoint = ccp(0, 0);
    [node_ addChild:blackBoard z:0 tag:5];
    blackBoard.color = color_;
    
}

+(BOOL)ifCihildExistInNode:(CCNode*)node_ tag:(int)tag_{
    
    BOOL isalive = [node_.children containsObject:[node_ getChildByTag:tag_]];
    if (isalive) {
        return YES;
    }
    
    
    return NO;
}

+(void)runSelectorTarget:(id)target_ selector:(SEL)sel_ object:(id)obj_ afterDelay:(float)delay_ sender:(id)sender_{
    
    [sender_ runAction:  [CCSequence actions:
                         [CCDelayTime actionWithDuration:delay_],
                         [CCCallFuncO actionWithTarget:target_ selector:sel_ object:obj_], nil]];
    
}

+(void)addBG_forNode:(CCNode*)node_ withCCZ:(NSString*)ccz_ bg:(NSString*)bg_{
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
    
    if (IS_IPHONE) {
        ccz_ = [NSString stringWithFormat:@"%@_iPhone",ccz_];
    }
 
    CCSpriteBatchNode *spritesBgNode;
    
    spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.pvr.ccz",ccz_]];
    [node_ addChild:spritesBgNode];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist",ccz_]];
    CCSprite *background = [CCSprite spriteWithSpriteFrameName: bg_];
    background.position = ccp(ScreenSize.width/2,ScreenSize.height/2);
    [spritesBgNode addChild:background z:0];
    
    if (![Combinations isRetina])
    {
        background.scale = 0.5f;
    }
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
}

+(NSInteger)MyRandomIntegerBetween:(int)min :(int)max {
    return ( (arc4random() % (max-min+1)) + min );
}


@end

