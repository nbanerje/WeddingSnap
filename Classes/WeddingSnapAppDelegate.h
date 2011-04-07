//
//  WeddingSnapAppDelegate.h
//  WeddingSnap
//
//  Created by Neel Banerjee on 3/26/11.
//  Copyright 2011 Om Design LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeddingSnapViewController.h"

@interface WeddingSnapAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	WeddingSnapViewController *cameraViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

