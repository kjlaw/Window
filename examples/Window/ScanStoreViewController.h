//
//  ScanViewController.h
//  Window
//
//  Created by Max Freundlich on 11/29/16.
//
//

#ifndef ScanViewController_h
#define ScanViewController_h


#endif /* ScanViewController_h */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
//#import <TesseractOCR/TesseractOCR.h>
//#import "tesseract.h"


@interface ScanStoreViewController : UIViewController //<G8TesseractDelegate>
{
    IBOutlet UIView *vImagePreview;
    IBOutlet UIButton *scanAreaButton;
    IBOutlet UIButton *startShoppingButton;
    //G8Tesseract *tesseract;
}
@property(nonatomic, retain) IBOutlet UIView *vImagePreview;

@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic, retain) UIButton *scanAreaButton;
@property (nonatomic, retain) UIButton *startShoppingButton;

@end
