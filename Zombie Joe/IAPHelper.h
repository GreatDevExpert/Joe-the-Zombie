
#import "cocos2d.h"
#import <StoreKit/StoreKit.h>

UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

@interface IAPHelper : NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver,UIAlertViewDelegate>
{
    SKProductsRequest * _productsRequest;
    CCNode *parent;
    BOOL isPurchasedNow;
    BOOL isRestoringNow;
}
@property (assign) BOOL isPurchasedNow;
@property (assign) BOOL isRestoringNow;

- (id)init;
- (void)requestProductsWithIndetifier:(NSString *)_indetifier parent:(CCNode *)sender;
- (void)buyProduct:(SKProduct *)product;
- (void)restoreCompletedTransactionsWithparent:(CCNode *)sender;

@end