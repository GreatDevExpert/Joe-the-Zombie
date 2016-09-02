

#import "IAPHelper.h"
#import "B6luxPopUpManager.h"
#import "cfg.h"
#import "MainMenu.h"

#define IAPHelperProductPurchasedNotification @"IAPHelperProductPurchasedNotification"

@implementation IAPHelper
@synthesize isPurchasedNow, isRestoringNow;

- (id)init{
    
    if ((self = [super init])) {
        // Add self as transaction observer
    }
    return self;
}



- (void)requestProductsWithIndetifier:(NSString *)_indetifier parent:(CCNode *)sender{
    
    isPurchasedNow = YES;
    isRestoringNow = YES;
    parent = sender;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:_indetifier]];
    _productsRequest.delegate = self;
    [_productsRequest start];
    
}

- (void)buyProduct:(SKProduct *)product {
    
    NSLog(@"Buying %@...", product.productIdentifier);
    
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {

//    NSArray * skProducts = response.products;
//    for (SKProduct * skProduct in skProducts) {
//        NSLog(@"Found product: %@ %@ %0.2f",
//              skProduct.productIdentifier,
//              skProduct.localizedTitle,
//              skProduct.price.floatValue);
//    }
    
    SKProduct *_product = nil;
    _productsRequest = nil;
    int count = [response.products count];
    
    if (count>0) {
        _product = [response.products objectAtIndex:0];
        [self buyProduct:_product];
         NSLog(@"PRODUCTS:   %@",[response.products objectAtIndex:0]);
    
    } else {
        UIAlertView *tmp = [[UIAlertView alloc]
                            initWithTitle:@"Not Available"
                            message:@"No products to purchase"
                            delegate:self
                            cancelButtonTitle:@"OK"
                            otherButtonTitles:nil, nil];
        [tmp show];
        [tmp release];
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"Failed to load list of products.");
    
    UIAlertView *tmp = [[UIAlertView alloc]
                        initWithTitle:@"Error"
                        message:@"Your purchase was not completed. You will not be charged. Please try again."
                        delegate:self
                        cancelButtonTitle:@"OK"
                        otherButtonTitles:nil, nil];
    [tmp show];
    [tmp release];

    _productsRequest = nil;
    isPurchasedNow = NO;
    isRestoringNow = NO;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        if ([[[CCDirector sharedDirector] openGLView]viewWithTag:kLOADINGTAG]) {
            [[[[CCDirector sharedDirector] openGLView]viewWithTag:kLOADINGTAG]removeFromSuperview];
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [db SS_purchase_player:[gc_ getLocalPlayerAlias] type:@"purchased" state:transaction.transactionState];
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [db SS_purchase_player:[gc_ getLocalPlayerAlias] type:@"failed" state:transaction.transactionState];
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [db SS_purchase_player:[gc_ getLocalPlayerAlias] type:@"restored" state:transaction.transactionState];
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    UIAlertView *tmp = [[UIAlertView alloc]
                        initWithTitle:@"Success!"
                        message:@"You've bought all levels."
                        delegate:self
                        cancelButtonTitle:@"OK"
                        otherButtonTitles:nil, nil];
    [tmp show];
    [tmp release];
    
    
    
    NSLog(@"completeTransaction...");
    if ([[[CCDirector sharedDirector] openGLView]viewWithTag:kLOADINGTAG]) {
        [[[[CCDirector sharedDirector] openGLView]viewWithTag:kLOADINGTAG]removeFromSuperview];
    }
    
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    
    [self unlockLevels];
    
    if ([parent isKindOfClass:[B6luxPopUpManager class]]) {
        [parent performSelector:@selector(smoothRemove) withObject:nil];
    }
    
    //
    

    
    //
    
    
    parent = nil;
    
    isPurchasedNow = NO;
    isRestoringNow = NO;
}

-(void)unlockLevels{
    
    // *** UNLOCK PURCHASES
    
    [Combinations saveNSDEFAULTS_Bool:YES forKey:C_PURCHASE_DONE];
    
    // UNLOCK ALL
    
    for (int x = 1; x < 16; x++)
    {
        [Combinations saveNSDEFAULTS_Bool:YES forKey:C_UNLOCK_LEVEL(x)];   //lock other levels
    }
    
    //
    
    if ([parent.parent isKindOfClass:[MainMenu class]])
    {
      //  NSLog(@"MAIN MENU IS PARENT");
        [parent.parent performSelector:@selector(purchaseWasDoneNow)];
    }
    else if ([parent.parent isKindOfClass:[PauseMenu class]])
    {
     //   NSLog(@"PAUSE IS PARENT");
        
        
        int level = [parent performSelector:@selector(returnLevelNr) withObject:nil withObject:nil];
        
        //enable second level to play
        [Combinations saveNSDEFAULTS_Bool:YES forKey:C_UNLOCK_LEVEL(level)];
    }
    
}


- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"restoreTransaction...");
    
    UIAlertView *tmp = [[UIAlertView alloc]
                        initWithTitle:@"Success"
                        message:@"You have successfully restored all levels"
                        delegate:self
                        cancelButtonTitle:@"OK"
                        otherButtonTitles:nil, nil];
    [tmp show];
    [tmp release];

    if ([[[CCDirector sharedDirector] openGLView]viewWithTag:kLOADINGTAG]) {
        [[[[CCDirector sharedDirector] openGLView]viewWithTag:kLOADINGTAG]removeFromSuperview];
    }
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    
    isRestoringNow = NO;
    isPurchasedNow = NO;
    
     [self unlockLevels];
    
    if ([parent isKindOfClass:[B6luxPopUpManager class]]) {
        [parent performSelector:@selector(smoothRemove) withObject:nil];
    }
    parent = nil;
    
}


- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    
    NSLog(@"failedTransaction...");
    if ([[[CCDirector sharedDirector] openGLView]viewWithTag:kLOADINGTAG]) {
        [[[[CCDirector sharedDirector] openGLView]viewWithTag:kLOADINGTAG]removeFromSuperview];
    }
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        UIAlertView *tmp = [[UIAlertView alloc]
                            initWithTitle:@"Error"
                            message:@"Your purchase was not completed. You will not be charged. Please try again."
                            delegate:self
                            cancelButtonTitle:@"OK"
                            otherButtonTitles:nil, nil];
        [tmp show];
        [tmp release];
        
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    isPurchasedNow = NO;
    isRestoringNow = NO;
}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    
    if (alertView.visible) {
        [alertView removeFromSuperview];
    }
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    
     NSLog(@"Post Natification...");
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
    
}

- (void)paymentQueue:(SKPaymentQueue*)queue restoreCompletedTransactionsFailedWithError:(NSError*)error
{
    if ([[[CCDirector sharedDirector] openGLView]viewWithTag:kLOADINGTAG]) {
        [[[[CCDirector sharedDirector] openGLView]viewWithTag:kLOADINGTAG]removeFromSuperview];
    }
    NSLog(@"canceled restore... Error %@",error);
    
    UIAlertView *tmp = [[UIAlertView alloc]
                        initWithTitle:@"Error"
                        message:@"Your purchases restore was not completed. Please try again."
                        delegate:self
                        cancelButtonTitle:@"OK"
                        otherButtonTitles:nil, nil];
    [tmp show];
    [tmp release];
    // DO AGAIN !!!!!!!!!
    
    
    isRestoringNow = NO;
    isPurchasedNow = NO;
    
}

- (void)restoreCompletedTransactionsWithparent:(CCNode *)sender{
    
    parent = sender;
    
    isPurchasedNow = YES;
    isRestoringNow = YES;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

@end