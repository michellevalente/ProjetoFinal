//
//  RBLAppDelegate.h
//  SimpleChat
//
//  Created by redbear on 14-4-8.
//  Copyright (c) 2014年 redbear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE.h"

@interface TableViewController : UITableViewController

@end
@interface RBLAppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString* reload;
@public
    BLE *bleShield;
    NSString* command;
    NSString* param;
    int sample;
    
}
@property (retain) NSString* reload;
@property (retain) NSString* command;
@property (retain) NSString* param;
@property int sample;
@property (strong, nonatomic) UIWindow *window;

@end
