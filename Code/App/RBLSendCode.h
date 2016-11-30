#import <Foundation/Foundation.h>
#import "BLE.h"

@interface RBLSendCode : NSObject <BLEDelegate>
{
    NSString *text;
}

//@property (strong, nonatomic) id text;
@property (retain) NSString* text;

- (void) sendCodeArduino;

@end