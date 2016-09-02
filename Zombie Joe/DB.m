#import "DB.h"
#import "Constants.h"
#import "Combinations.h"
#import "Strings.h"

#import "SBJson.h"
//
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"

#define dTableScore     @"scores"
#define dID             @"id"
#define dLevel          @"level"
#define dscore          @"score"
#define dtime           @"time"

#define SS_LOG NO

@implementation DB

@synthesize db;

+(id)access{
    static id access = nil;
    
    if (access == nil) {
        access = [[self alloc] init];
    }
    return access;
}

-(id) init
{
    if ( (self=[super init]) ) {
        
        
    }
    return self;
}

-(NSString*) screenshotPathForFile:(NSString *)file
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* screenshotPath = [documentsDirectory
                                stringByAppendingPathComponent:file];
    return screenshotPath;
}

-(UIImage*) screenshotWithStartNode:(CCNode*)startNode
{
    [CCDirector sharedDirector].nextDeltaTimeZero = YES;
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CCRenderTexture* rtx =
    [CCRenderTexture renderTextureWithWidth:winSize.width
                                     height:winSize.height pixelFormat:kCCImageFormatPNG];
    //    [rtx.sprite setBlendFunc:(ccBlendFunc){GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA}];
    //    [rtx.sprite setBlendFunc: (ccBlendFunc) (ccBlendFunc) {GL_ONE,GL_ZERO}];
    //    [rtx beginWithClear:0 g:0 b:0 a:0];
    [startNode visit];
    [rtx end];
    
    return [rtx getUIImageFromBufferNew];
}

-(UIImage*)getScreenShotForNode:(CCNode*)n_{
    
    CCScene *scene = [[CCDirector sharedDirector] runningScene];
   // CCNode *n = [scene.children objectAtIndex:0];
    UIImage *img = [self screenshotWithStartNode:scene];
    // UIImageWriteToSavedPhotosAlbum (img, nil, nil, nil);
    
    return img;
    
}

-(UIImage*)getScreenShot{
    
    CCScene *scene = [[CCDirector sharedDirector] runningScene];
  //  CCNode *n = [scene.children objectAtIndex:0];
    UIImage *img = [self screenshotWithStartNode:scene];
   // UIImageWriteToSavedPhotosAlbum (img, nil, nil, nil);
    
    return img;
    
}

-(void)SS_sendUserInfo:(NSString*)player_{
    
    if (![Combinations connectedToInternet])
    {
        return;
    }
    
    return;
    
    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        //http://b6lux.com/api/server_v1.0.php
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",SS_Link]];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod:@"POST"];
        
        //    [request setUsername:kAPIUsername]; //cia reikia ideti analogiskai
        //    [request setPassword:kAPIPassword]; //email ir password is textfieldu
        
        [request setPostValue:@"device"                                        forKey:@"func"];
        [request setPostValue:player_                                       forKey:@"player"];
        [request setPostValue:[Combinations WhatsMyMachine]                 forKey:@"model"];
        [request setPostValue:[Combinations WhatsMyiOSVersion]                 forKey:@"ios"];
        
     
        
        [request startSynchronous];
        
        NSError *error = [request error];
        NSString *response = [request responseString];
        if (SS_LOG)  NSLog(@"response string %@",response);
        
        if (error) {
            NSDictionary *tempDic= [response JSONValue];
            NSString *errorStr = [tempDic objectForKey:@"message"];
            NSLog(@"error message: %@",errorStr);
        }
        
        else {
            
        //    NSLog(@"successfully sended the player info");
            [Combinations saveNSDEFAULTS_Bool:YES forKey:@"USERINFO"];
            
        }
        
    });

    
}

-(void)SS_foundHiddenBrainInMenu_player:(NSString*)player_{
    
    if (![Combinations connectedToInternet])
    {
        return;
    }
    
    return;
    
    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        //http://b6lux.com/api/server_v1.0.php
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",SS_Link]];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod:@"POST"];
        
        //    [request setUsername:kAPIUsername]; //cia reikia ideti analogiskai
        //    [request setPassword:kAPIPassword]; //email ir password is textfieldu
        
        [request setPostValue:@"found_hidden"         forKey:@"func"];
        [request setPostValue:player_                 forKey:@"player"];

        [request startSynchronous];
        
        NSError *error = [request error];
        NSString *response = [request responseString];
      if (SS_LOG)  NSLog(@"response string %@",response);
        
        if (error) {
            NSDictionary *tempDic= [response JSONValue];
            NSString *errorStr = [tempDic objectForKey:@"message"];
            NSLog(@"error message: %@",errorStr);
        }
        
    });

    
}

-(void)SS_sharegame_player:(NSString*)player_ level:(int)level_ type:(NSString*)type_{
    
    if (![Combinations connectedToInternet])
    {
        return;
    }
    
    return;
    
    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        //http://b6lux.com/api/server_v1.0.php
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",SS_Link]];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod:@"POST"];
        
        //    [request setUsername:kAPIUsername]; //cia reikia ideti analogiskai
        //    [request setPassword:kAPIPassword]; //email ir password is textfieldu
        
        [request setPostValue:@"share"         forKey:@"func"];
        [request setPostValue:player_        forKey:@"player"];
        [request setPostValue:[NSString stringWithFormat:@"%i",level_]         forKey:@"level"];
         [request setPostValue:type_         forKey:@"type"];
        
        [request startSynchronous];
        
        NSError *error = [request error];
        NSString *response = [request responseString];
      if (SS_LOG)   NSLog(@"response string %@",response);
        
        if (error) {
            NSDictionary *tempDic= [response JSONValue];
            NSString *errorStr = [tempDic objectForKey:@"message"];
            NSLog(@"error message: %@",errorStr);
        }
        
    });
    
}

-(void)SS_rategame_player:(NSString*)player_{
    
    if (![Combinations connectedToInternet])
    {
        return;
    }
    
    return;
    
    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        //http://b6lux.com/api/server_v1.0.php
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",SS_Link]];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod:@"POST"];
        
        //    [request setUsername:kAPIUsername]; //cia reikia ideti analogiskai
        //    [request setPassword:kAPIPassword]; //email ir password is textfieldu
        
        [request setPostValue:@"rate"         forKey:@"func"];
        [request setPostValue:player_        forKey:@"player"];
        
        [request startSynchronous];
        
        NSError *error = [request error];
        NSString *response = [request responseString];
     if (SS_LOG)    NSLog(@"response string %@",response);
        
        if (error) {
            NSDictionary *tempDic= [response JSONValue];
            NSString *errorStr = [tempDic objectForKey:@"message"];
            NSLog(@"error message: %@",errorStr);
        }
        
    });
    
}

-(void)SS_endgame_player:(NSString*)player_ level:(int)level_ brains:(int)brains_ time:(int)time_ score:(int)score_{
    
  
    if (![Combinations connectedToInternet])
    {
        return;
    }
    
    return;
    
    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        //http://b6lux.com/api/server_v1.0.php
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",SS_Link]];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod:@"POST"];
        
        //    [request setUsername:kAPIUsername]; //cia reikia ideti analogiskai
        //    [request setPassword:kAPIPassword]; //email ir password is textfieldu
        
        [request setPostValue:@"end_game"   forKey:@"func"];
        [request setPostValue:player_        forKey:@"player"];
        [request setPostValue:[NSString stringWithFormat:@"%i",level_]         forKey:@"level"];
        [request setPostValue:[NSString stringWithFormat:@"%i",brains_]        forKey:@"brains"];
        [request setPostValue:[NSString stringWithFormat:@"%i",time_]         forKey:@"time"];
        [request setPostValue:[NSString stringWithFormat:@"%i",score_]       forKey:@"score"];
        [request setPostValue:[Combinations WhatsMyMachine]                 forKey:@"model"];
        
        [request startSynchronous];
        
        NSError *error = [request error];
        NSString *response = [request responseString];
    if (SS_LOG)     NSLog(@"response string %@",response);
        
        if (error) {
            NSDictionary *tempDic= [response JSONValue];
            NSString *errorStr = [tempDic objectForKey:@"message"];
            NSLog(@"error message: %@",errorStr);
        }
        
    });
    
}


-(void)SS_purchase_player:(NSString*)player type:(NSString*)type_ state:(int)state_{
    
    if (![Combinations connectedToInternet])
    {
        return;
    }
    
    return;
    
    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        //http://b6lux.com/api/server_v1.0.php

        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",SS_Link]];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod:@"POST"];
        
        //    [request setUsername:kAPIUsername]; //cia reikia ideti analogiskai
        //    [request setPassword:kAPIPassword]; //email ir password is textfieldu
        
        [request setPostValue:@"purchase"   forKey:@"func"];
        [request setPostValue:player        forKey:@"player"];
        [request setPostValue:type_         forKey:@"type"];
        [request setPostValue:@""           forKey:@"price"];
        [request setPostValue:[NSString stringWithFormat:@"%i",state_]        forKey:@"state"];

        [request startSynchronous];
        
        NSError *error = [request error];
        NSString *response = [request responseString];
      if (SS_LOG)   NSLog(@"response string %@",response);
        
        if (error) {
            NSDictionary *tempDic= [response JSONValue];
            NSString *errorStr = [tempDic objectForKey:@"message"];
            NSLog(@"error message: %@",errorStr);
        }
        
    });

}

-(void)incraseBrainCounter{
    
    [Combinations saveNSDEFAULTS_INT:[self getBrainsCounter]+1 forKey:@"BrainCounter"];
    
}

-(int)getBrainsCounter{
    
    return [Combinations getNSDEFAULTS_INT_forKey:@"BrainCounter"];
    
}

-(int)getAllLevelsTime{
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@",dTableScore];
    [self openDB];
    int count = 0;
    FMResultSet * result = [db executeQuery:query];
	while ([result next])
    {
        //int       idnr = [result intForColumn:dID];
        // int       lvl = [result intForColumn:dLevel];
       // int       score = [result intForColumn:dscore];
         int t = [result intForColumn:dtime];
        count+=t;
        
        //   NSLog(@"SELECT ALL from SCORES :%i %i %i",lvl,score,t);
    }
    
    [self closeDB];
    return count;
    
}

-(int)getAllLevelsScore{
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@",dTableScore];
    [self openDB];
    int count = 0;
    FMResultSet * result = [db executeQuery:query];
	while ([result next])
    {
        //int       idnr = [result intForColumn:dID];
       // int       lvl = [result intForColumn:dLevel];
        int       score = [result intForColumn:dscore];
       // int t = [result intForColumn:dtime];
        count+=score;
        
     //   NSLog(@"SELECT ALL from SCORES :%i %i %i",lvl,score,t);
    }
    
    [self closeDB];
    return count;
    
}

-(int)getLevelsCount{
    
    /*
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@",dTableScore];
    [self openDB];
    int count = 0;
    FMResultSet * result = [db executeQuery:query];
	while ([result next])
    {
        //int       idnr = [result intForColumn:dID];
        int       lvl = [result intForColumn:dLevel];
        int       score = [result intForColumn:dscore];
        int t = [result intForColumn:dtime];
        count++;
        
        NSLog(@"SELECT ALL from SCORES :%i %i %i",lvl,score,t);
    }
    
    [self closeDB];
    
    
    NSLog(@"counted levels %i",count);
     */
    
    return 15;
    
    return 0;
}

-(void)ShowAllRecordsFromScoresTable{
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@",dTableScore];
    [self openDB];
    FMResultSet * result = [db executeQuery:query];
	while ([result next])
    {
        //int       idnr = [result intForColumn:dID];
        int       lvl = [result intForColumn:dLevel];
        int       score = [result intForColumn:dscore];
        int t = [result intForColumn:dtime];
        
     //   NSLog(@"SELECT ALL from SCORES :%i %i %i",lvl,score,t);
    }
    
    [self closeDB];
    
}

//-(int)getBrainForLevel:(int)level_{
//    
//    [self openDB];
//    
//    NSString *query = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@=(?)",dtime,dTableScore,dLevel];
//    
//    FMResultSet * result = [db executeQuery:query,[NSNumber numberWithInt:level_]];
//    
//    int brain = 0;
//    
//    while ([result next])
//    {
//        brain = [result intForColumn:dtime];
//        
//    }
//    
//    [self closeDB];
//    
//    return time;
//    
//    return 0;
//}

-(int)getHighTIMEForLevel:(int)level_{
    
    [self openDB];
    
    NSString *query = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@=(?)",dtime,dTableScore,dLevel];
    
    FMResultSet * result = [db executeQuery:query,[NSNumber numberWithInt:level_]];
    
    int time = 0;
    
    while ([result next])
    {
        time = [result intForColumn:dtime];
        
    }
    
    [self closeDB];
    
    return time;
    
    return 0;
}

-(int)getHighScoreForLevel:(int)level_{
    
    [self openDB];
    
    NSString *query = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@=(?)",dscore,dTableScore,dLevel];
    
    FMResultSet * result = [db executeQuery:query,[NSNumber numberWithInt:level_]];
    
    int score = 0;
    
    while ([result next])
    {
        score = [result intForColumn:dscore];
    }
    
    [self closeDB];
    
    return score;
    
    return 0;
}

-(BOOL)ifRowExistsByLevel:(int)level_{
    
    [self openDB];
    
    NSString *query = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@=(?)",dLevel,dTableScore,dLevel];
    
    FMResultSet * result = [db executeQuery:query,[NSNumber numberWithInt:level_]];
    
    BOOL exists = NO;
    
    while ([result next])
    {
      // int l = [result intForColumn:dLevel];
        exists = YES;
    }
    
    
    if (!exists)
    {
        NSString *q = [NSString stringWithFormat:@"INSERT INTO %@(%@,%@,%@) VALUES (?, ?, ?)",dTableScore,dLevel,dscore,dtime];
        
        [db executeUpdate:q,
        [NSNumber numberWithInt:level_],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0]];
    }
    
    [self closeDB];
    
    
    return exists;
}

-(BOOL)setScoreForLevel:(int)level_ score:(int)score_ time:(int)time_{
    
 
    
    if ([self getHighScoreForLevel:level_] >= score_)
    {
    //    NSLog(@"score is higher saved");
        return NO;
    }
    
    if ([self ifRowExistsByLevel:level_])
    {
   //     NSLog(@"level data already exists");
    }
    
    [self openDB];
    
    NSString *query = [NSString stringWithFormat:@"update %@ set %@ = (?) where %@ =%i",dTableScore,dscore,dLevel,level_];
    [db executeUpdate:query,[NSNumber numberWithInt:score_]];
    
    NSString *queryTime = [NSString stringWithFormat:@"update %@ set %@ = (?) where %@ =%i",dTableScore,dtime,dLevel,level_];
    [db executeUpdate:queryTime,[NSNumber numberWithInt:time_]];
    
    [self closeDB];
    
    return YES;

}


-(void)closeDB{
    
    [db close];
    
}


-(void)openDB{
    BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"db.sqlite"];
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"db.sqlite"];
	BOOL forceRefresh = FALSE;
	success = [fileManager fileExistsAtPath:writableDBPath];
	if (!success || forceRefresh) {
		success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        	NSLog(@" database (%@) from (%@)", writableDBPath, defaultDBPath);
	}
	
	db = [FMDatabase databaseWithPath:writableDBPath];
	
	if ([db open]) {
     //   	NSLog(@"database opened: %@", writableDBPath);
		
		[db setTraceExecution: FALSE];
		[db setLogsErrors: TRUE];
		
		[db setShouldCacheStatements:FALSE];
		
	} else {
        
        NSLog(@"database not opened");

    }
}


@end
