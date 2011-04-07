//
//  WeddingSnapViewController.h
//  WeddingSnap
//
//  Created by Neel Banerjee on 3/26/11.
//  Copyright 2011 Om Design LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface WeddingSnapViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
	UIImagePickerController* cameraController;
	//UIImage* imageToSave;
}
- (NSOperation*)taskWithData:(id)data;
- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
								   usingDelegate: (id <UIImagePickerControllerDelegate,
												   UINavigationControllerDelegate>) delegate;
- (void)myTaskMethod:(id)imageToSave;	

@end
