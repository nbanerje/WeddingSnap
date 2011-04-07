    //
//  WeddingSnapViewController.m
//  WeddingSnap
//
//  Created by Neel Banerjee on 3/26/11.
//  Copyright 2011 Om Design LLC. All rights reserved.
//

#import "WeddingSnapViewController.h"
#import "UIImage+fixOrientation.h"

#define COMPRESSION 0.8
@implementation WeddingSnapViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 
	NSLog(@"In Here");
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
        /*
		// Custom initialization
		if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			cameraController = [[UIImagePickerController alloc] initWithNibName:nil bundle:nil];
			cameraController.delegate = self; 
			cameraController.mediaTypes =
			[UIImagePickerController availableMediaTypesForSourceType:
			UIImagePickerControllerSourceTypeCamera];
			NSLog(@"Camera Support");
		}
		else {
			NSLog(@"No Camera Support");
		}
		*/
	}
	return self;
}
 


-(void)viewDidAppear:(BOOL)animated {
	if([self startCameraControllerFromViewController:self
									   usingDelegate:self]) {
		NSLog(@"True");
	}
	else {
		NSLog(@"False");
	}
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
/*
 - (void)viewDidLoad {
 //if(cameraController) {
 //[self presentModalViewController:cameraController animated:YES];
 //}
}	
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
								   usingDelegate: (id <UIImagePickerControllerDelegate,
												   UINavigationControllerDelegate>) delegate {
	
	if (([UIImagePickerController isSourceTypeAvailable:
		  UIImagePickerControllerSourceTypeCamera] == NO)
		|| (delegate == nil)
		|| (controller == nil))
		return NO;
	
	
	UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
	cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
	
	// Displays a control that allows the user to choose picture or
	// movie capture, if both are available:
	cameraUI.mediaTypes =
	[UIImagePickerController availableMediaTypesForSourceType:
	 UIImagePickerControllerSourceTypeCamera];
	
	// Hides the controls for moving & scaling pictures, or for
	// trimming movies. To instead show the controls, use YES.
	cameraUI.allowsEditing = NO;
	
	cameraUI.delegate = delegate;
	
	[controller presentModalViewController: cameraUI animated: YES];
	return YES;
}



// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
	
	[[picker parentViewController] dismissModalViewControllerAnimated: YES];
	[picker release];
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
	
	[[picker parentViewController] dismissModalViewControllerAnimated: YES];
	[picker release];
	
	NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
	UIImage *originalImage, *editedImage, *imageToSave;
	
	// Handle a still image capture
	if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
		== kCFCompareEqualTo) {
		
		editedImage = (UIImage *) [info objectForKey:
								   UIImagePickerControllerEditedImage];
		originalImage = (UIImage *) [info objectForKey:
									 UIImagePickerControllerOriginalImage];
		
		if (editedImage) {
			imageToSave = editedImage;
			//[imageToSave retain];
		} else {
			imageToSave = originalImage;
			//[imageToSave retain];
		}
		
		
		
		[[self taskWithData:imageToSave] start];
		
		
		
	}
	
	// Handle a movie capture
	if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
		== kCFCompareEqualTo) {
		
		NSString *moviePath = [[info objectForKey:
								UIImagePickerControllerMediaURL] path];
		
		if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
			UISaveVideoAtPathToSavedPhotosAlbum (
												 moviePath, nil, nil, nil);
		}
		[[picker parentViewController] dismissModalViewControllerAnimated: YES];
		[picker release];
	}
	
	
}





- (void)requestFinished:(ASIHTTPRequest *)request
{
	// Use when fetching text data
	NSString *responseString = [request responseString];
	NSLog(responseString);
	
	
	// Use when fetching binary data
	//NSData *responseData = [request responseData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
}

- (NSOperation*)taskWithData:(id)data {
    NSInvocationOperation* theOp = [[[NSInvocationOperation alloc] initWithTarget:self
																		 selector:@selector(myTaskMethod:) object:data] autorelease];
	
	return theOp;
}

// This is the method that does the actual work of the task.
- (void)myTaskMethod:(id)imageToSave {
    // Perform the task.

	// Save the new image (original or edited) to the Camera Roll
	UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
	
	imageToSave = [imageToSave fixOrientation];
	
	//Get Date for unique file name 
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	//[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	//[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	[dateFormatter setDateFormat:@"yyyyddMMHHmmss"];
		
	NSString *dateTime  =  [dateFormatter stringFromDate:[NSDate date]];
	[dateFormatter release];
	
	//Send image to the server
	NSData *jpg = UIImageJPEGRepresentation(imageToSave,COMPRESSION);
	NSString *deviceName = [[[[UIDevice currentDevice] name]
							 stringByReplacingOccurrencesOfString:@"’" withString:@""]
							stringByReplacingOccurrencesOfString:@" " withString:@""];
	NSURL *url = [NSURL URLWithString:@"http://omdesignllc.com/postPic.php"];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setData:jpg withFileName:[NSString stringWithFormat:@"%@%@.jpg",deviceName,dateTime]  andContentType:@"image/jpeg" forKey:@"photo"];
	[request setDelegate:self];
	[request startAsynchronous];
}
@end
