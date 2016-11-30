#import "RBLSendCode.h"
#import "RBLAppDelegate.h"

@implementation RBLSendCode

@synthesize text;

- (void) sendCodeArduino {
    
    
    RBLAppDelegate *appDelegate = (RBLAppDelegate *)[[UIApplication sharedApplication] delegate];
    BLE * bleShield = appDelegate->bleShield;
    
    if (bleShield.activePeripheral.state == CBPeripheralStateConnected) {
        NSLog(@"sendCodeArduino Arduino connected");
        
        NSString *s;
        NSData *d;
        
        if (text.length > 16)
            s = [text substringToIndex:16];
        else
            s = text;
        
        d = [s dataUsingEncoding:NSUTF8StringEncoding];
        
        
        [bleShield write:d];

    }
    
    NSLog(@"sendCodeArduino Ran");
}

@end