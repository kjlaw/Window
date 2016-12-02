//
//  ScanViewController.m
//  Window
//
//  Created by Max Freundlich on 11/29/16.
//
//

#import <Foundation/Foundation.h>

#import "ScanStoreViewController.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
//#import <TesseractOCR/TesseractOCR.h>
//#import "tesseract.h"



@interface ScanStoreViewController ()

@end

@implementation ScanStoreViewController

@synthesize vImagePreview;
@synthesize scanAreaButton;
@synthesize startShoppingButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[scanAreaButton layer] setBorderWidth:3.0f];
    [[scanAreaButton layer] setBorderColor:[UIColor redColor].CGColor];
    
    
    // Languages are used for recognition (e.g. eng, ita, etc.). Tesseract engine
    // will search for the .traineddata language file in the tessdata directory.
    // For example, specifying "eng+ita" will search for "eng.traineddata" and
    // "ita.traineddata". Cube engine will search for "eng.cube.*" files.
    // See https://code.google.com/p/tesseract-ocr/downloads/list.
    
    // Create your G8Tesseract object using the initWithLanguage method:
    //  tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng"];
    // tesseract = [[G8Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
    
    //tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng" configDictionary:nil configFileNames:nil absoluteDataPath:@"/" engineMode:G8OCREngineModeTesseractOnly copyFilesFromResources:false];
    
    // Optionaly: You could specify engine to recognize with.
    // G8OCREngineModeTesseractOnly by default. It provides more features and faster
    // than Cube engine. See G8Constants.h for more information.
    //tesseract.engineMode = G8OCREngineModeTesseractOnly;
    
    // Set up the delegate to receive Tesseract's callbacks.
    // self should respond to TesseractDelegate and implement a
    // "- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract"
    // method to receive a callback to decide whether or not to interrupt
    // Tesseract before it finishes a recognition.
    // tesseract.delegate = self;
}

- (IBAction)scanAreaTapped:(UIButton *)sender {
    [[scanAreaButton layer] setBorderColor:[UIColor greenColor].CGColor];
    [startShoppingButton setHidden:NO];
}


//********** VIEW DID UNLOAD **********
- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [vImagePreview release];
    vImagePreview = nil;
}

//*************************************
//*************************************
//********** VIEW DID APPEAR **********
//*************************************
//*************************************
//View about to be added to the window (called each time it appears)
//Occurs after other view's viewWillDisappear
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    //----- SHOW LIVE CAMERA PREVIEW -----
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    CALayer *viewLayer = self.vImagePreview.layer;
    NSLog(@"viewLayer = %@", viewLayer);
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    captureVideoPreviewLayer.frame = self.vImagePreview.bounds;
    NSLog(@"vImagePreview bounds: %@", NSStringFromCGRect(self.vImagePreview.bounds));
    NSLog(@"vImagePreview frame: %@", NSStringFromCGRect(self.vImagePreview.frame));
    NSLog(@"captureVideoPreviewLayer frame: %@", NSStringFromCGRect(captureVideoPreviewLayer.frame));
    [self.vImagePreview.layer addSublayer:captureVideoPreviewLayer];
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        // Handle the error appropriately.
        NSLog(@"ERROR: trying to open camera: %@", error);
    }
    [session addInput:input];
    
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [_stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:_stillImageOutput];
    
    [session startRunning];
    
    //    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    //    singleTap.numberOfTapsRequired = 1;
    //    [vImagePreview setUserInteractionEnabled:YES];
    //    [vImagePreview addGestureRecognizer:singleTap];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[scanAreaButton layer] setBorderColor:[UIColor redColor].CGColor];
    [startShoppingButton setHidden:YES];
    [self.navigationController setNavigationBarHidden:NO];

}


// User clicked camera
-(void)tapDetected{
    NSLog(@"single Tap on imageview");
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    NSLog(@"about to request a capture from: %@", _stillImageOutput);
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         
         UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
         [vImagePreview addSubview:imageView];
         [imageView release];
         
         // Optional: Limit the character set Tesseract should try to recognize from
         //tesseract.charWhitelist = @"0123456789";
         
         // This is wrapper for common Tesseract variable kG8ParamTesseditCharWhitelist:
         // [tesseract setVariableValue:@"0123456789" forKey:kG8ParamTesseditCharBlacklist];
         // See G8TesseractParameters.h for a complete list of Tesseract variables
         
         // Optional: Limit the character set Tesseract should not try to recognize from
         //tesseract.charBlacklist = @"OoZzBbSs";
         
         // Specify the image Tesseract should recognize on
         //tesseract.image = [image g8_blackAndWhite];
         //[tesseract setImage:image];
         
         
         // Optional: Limit the area of the image Tesseract should recognize on to a rectangle
         // tesseract.rect = CGRectMake(20, 20, 100, 100);
         
         // Optional: Limit recognition time with a few seconds
         //tesseract.maximumRecognitionTime = 2.0;
         
         // Start the recognition
         //         [tesseract recognize];
         //         unsigned long prog = 0;
         //         while( prog < 100) {
         //             prog  = (unsigned long)tesseract;
         //             NSLog(@"progress: %lu", prog);
         //         }
         //
         //         // Retrieve the recognized text
         //         NSLog(@"Text: %@", [tesseract recognizedText]);
     }];
}

//- (void)progressImageRecognitionForTesseract:(G8Tesseract *)tesseract {
//    NSLog(@"progress: %lu", (unsigned long)tesseract.progress);
//}
//
//- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract {
//    return NO;  // return YES, if you need to interrupt tesseract before it finishes
//}

//********** DEALLOC **********
- (void)dealloc
{
    [vImagePreview release];
    
    [super dealloc];
}

@end
