//
//  ARViewController.m
//  ARApp2
//
//  Disclaimer: IMPORTANT:  This Daqri software is supplied to you by Daqri
//  LLC ("Daqri") in consideration of your agreement to the following
//  terms, and your use, installation, modification or redistribution of
//  this Daqri software constitutes acceptance of these terms.  If you do
//  not agree with these terms, please do not use, install, modify or
//  redistribute this Daqri software.
//
//  In consideration of your agreement to abide by the following terms, and
//  subject to these terms, Daqri grants you a personal, non-exclusive
//  license, under Daqri's copyrights in this original Daqri software (the
//  "Daqri Software"), to use, reproduce, modify and redistribute the Daqri
//  Software, with or without modifications, in source and/or binary forms;
//  provided that if you redistribute the Daqri Software in its entirety and
//  without modifications, you must retain this notice and the following
//  text and disclaimers in all such redistributions of the Daqri Software.
//  Neither the name, trademarks, service marks or logos of Daqri LLC may
//  be used to endorse or promote products derived from the Daqri Software
//  without specific prior written permission from Daqri.  Except as
//  expressly stated in this notice, no other rights or licenses, express or
//  implied, are granted by Daqri herein, including but not limited to any
//  patent rights that may be infringed by your derivative works or by other
//  works in which the Daqri Software may be incorporated.
//
//  The Daqri Software is provided by Daqri on an "AS IS" basis.  DAQRI
//  MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
//  THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
//  FOR A PARTICULAR PURPOSE, REGARDING THE DAQRI SOFTWARE OR ITS USE AND
//  OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
//
//  IN NO EVENT SHALL DAQRI BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
//  OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
//  MODIFICATION AND/OR DISTRIBUTION OF THE DAQRI SOFTWARE, HOWEVER CAUSED
//  AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
//  STRICT LIABILITY OR OTHERWISE, EVEN IF DAQRI HAS BEEN ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
//  Copyright 2015 Daqri LLC. All Rights Reserved.
//  Copyright 2010-2015 ARToolworks, Inc. All rights reserved.
//
//  Author(s): Philip Lamb
//

#import "ARViewController.h"
#import <AR/gsub_es.h>
#import "../ARAppCore/ARMarkerSquare.h"
#import "../ARAppCore/ARMarkerMulti.h"
#import "VEObjectOBJ.h"
#import <Eden/EdenMath.h>
#import "BrowseClothesViewController.h"


#define VIEW_DISTANCE_MIN        5.0f          // Objects closer to the camera than this will not be displayed.
#define VIEW_DISTANCE_MAX        2000.0f        // Objects further away from the camera than this will not be displayed.


//
// ARViewController
//


@implementation ARViewController {
    
    BOOL            running;
    NSInteger       runLoopInterval;
    NSTimeInterval  runLoopTimePrevious;
    BOOL            videoPaused;
    
    // Video acquisition
    AR2VideoParamT *gVid;
    
    // Marker detection.
    ARHandle       *gARHandle;
    ARPattHandle   *gARPattHandle;
    long            gCallCountMarkerDetect;
    
    // Transformation matrix retrieval.
    AR3DHandle     *gAR3DHandle;
    
    // Markers.
    NSMutableArray *markers;
    
    // Drawing.
    ARParamLT      *gCparamLT;
    ARView         *glView;
    VirtualEnvironment *virtualEnvironment;
    ARGL_CONTEXT_SETTINGS_REF arglContextSettings;
    ARVec3 rayPoint1;
    ARVec3 rayPoint2;
    
    // Interaction.
   // id <ARViewTouchDelegate> touchDelegate;
}

@synthesize glView, virtualEnvironment, markers;
@synthesize arglContextSettings;
@synthesize running, runLoopInterval;
//@synthesize touchDelegate;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

- (void)loadView
{
    self.wantsFullScreenLayout = YES;
    
    itemPriceMapping = [[NSMutableDictionary alloc] init];
    
    // This will be overlaid with the actual AR view.
    NSString *irisImage = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        irisImage = @"Iris-iPad.png";
    }  else { // UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if (result.height == 568) {
            irisImage = @"Iris-568h.png"; // iPhone 5, iPod touch 5th Gen, etc.
        } else { // result.height == 480
            irisImage = @"Iris.png";
        }
    }
    UIView *irisView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:irisImage]] autorelease];
    
    
//    UIView* irisView = [[UIView alloc] initWithFrame:CGRectMake(0,
//                                                                0,
//                                                                [[UIScreen mainScreen] applicationFrame].size.width,
//                                                                [[UIScreen mainScreen] applicationFrame].size.height)];
    irisView.userInteractionEnabled = YES;
    self.view = irisView;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    modelPath = @"Data2/models.dat";
    // Init instance variables.
    glView = nil;
    virtualEnvironment = nil;
    markers = nil;
    gVid = NULL;
    gCparamLT = NULL;
    gARHandle = NULL;
    gARPattHandle = NULL;
    gCallCountMarkerDetect = 0;
    gAR3DHandle = NULL;
    arglContextSettings = NULL;
    running = FALSE;
    videoPaused = FALSE;
    runLoopTimePrevious = CFAbsoluteTimeGetCurrent();
    // Init gestures.
   // [self setMultipleTouchEnabled:YES];
   // [self setTouchDelegate:self];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(didSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self start];
}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    GlobalVars *globals = [GlobalVars sharedInstance];
    if(globals.inDetail) return;
    globals.newMove =true;
    globals.clicked = false;
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        self.virtualEnvironment->moveLeft = true;
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        self.virtualEnvironment->moveRight = true;
    }
}

// On iOS 6.0 and later, we must explicitly report which orientations this view controller supports.
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)startRunLoop
{
    if (!running) {
        // After starting the video, new frames will invoke cameraVideoTookPicture:userData:.
        if (ar2VideoCapStart(gVid) != 0) {
            NSLog(@"Error: Unable to begin camera data capture.\n");
            [self stop];
            return;
        }
        running = TRUE;
    }
}

- (void)stopRunLoop
{
    if (running) {
        ar2VideoCapStop(gVid);
        running = FALSE;
    }
}

- (void) setRunLoopInterval:(NSInteger)interval
{
    if (interval >= 1) {
        runLoopInterval = interval;
        if (running) {
            [self stopRunLoop];
            [self startRunLoop];
        }
    }
}

- (BOOL) isPaused
{
    if (!running) return (NO);

    return (videoPaused);
}

- (void) setPaused:(BOOL)paused
{
    if (!running) return;
    
    if (videoPaused != paused) {
        if (paused) ar2VideoCapStop(gVid);
        else ar2VideoCapStart(gVid);
        videoPaused = paused;
#  ifdef DEBUG
        NSLog(@"Run loop was %s.\n", (paused ? "PAUSED" : "UNPAUSED"));
#  endif
    }
}

static void startCallback(void *userData);

- (IBAction)start
{
    // Open the video path.
    char *vconf = ""; // See http://www.artoolworks.com/support/library/Configuring_video_capture_in_ARToolKit_Professional#AR_VIDEO_DEVICE_IPHONE
    if (!(gVid = ar2VideoOpenAsync(vconf, startCallback, self))) {
        NSLog(@"Error: Unable to open connection to camera.\n");
        [self stop];
        return;
    }
}

static void startCallback(void *userData)
{
    ARViewController *vc = (ARViewController *)userData;
    
    [vc start2];
}

- (void) start2

{
    GlobalVars *globals = [GlobalVars sharedInstance];

    globals.setFilterBanner = true;
    [self.navigationController setNavigationBarHidden:NO];

    // Find the size of the window.
    int xsize, ysize;
    if (ar2VideoGetSize(gVid, &xsize, &ysize) < 0) {
        NSLog(@"Error: ar2VideoGetSize.\n");
        [self stop];
        return;
    }
    
    // Get the format in which the camera is returning pixels.
    AR_PIXEL_FORMAT pixFormat = ar2VideoGetPixelFormat(gVid);
    if (pixFormat == AR_PIXEL_FORMAT_INVALID) {
        NSLog(@"Error: Camera is using unsupported pixel format.\n");
        [self stop];
        return;
    }

    // Work out if the front camera is being used. If it is, flip the viewing frustum for
    // 3D drawing.
    BOOL flipV = FALSE;
    int frontCamera;
    if (ar2VideoGetParami(gVid, AR_VIDEO_PARAM_IOS_CAMERA_POSITION, &frontCamera) >= 0) {
        if (frontCamera == AR_VIDEO_IOS_CAMERA_POSITION_FRONT) flipV = TRUE;
    }

    // Tell arVideo what the typical focal distance will be. Note that this does NOT
    // change the actual focus, but on devices with non-fixed focus, it lets arVideo
    // choose a better set of camera parameters.
    ar2VideoSetParami(gVid, AR_VIDEO_PARAM_IOS_FOCUS, AR_VIDEO_IOS_FOCUS_0_3M); // Default is 0.3 metres. See <AR/sys/videoiPhone.h> for allowable values.
    
    // Load the camera parameters, resize for the window and init.
    ARParam cparam;
    if (ar2VideoGetCParam(gVid, &cparam) < 0) {
        char cparam_name[] = "Data2/camera_para.dat";
        NSLog(@"Unable to automatically determine camera parameters. Using default.\n");
        if (arParamLoad(cparam_name, 1, &cparam) < 0) {
            NSLog(@"Error: Unable to load parameter file %s for camera.\n", cparam_name);
            [self stop];
            return;
        }
    }
    if (cparam.xsize != xsize || cparam.ysize != ysize) {
#ifdef DEBUG
        fprintf(stdout, "*** Camera Parameter resized from %d, %d. ***\n", cparam.xsize, cparam.ysize);
#endif
        arParamChangeSize(&cparam, xsize, ysize, &cparam);
    }
#ifdef DEBUG
    fprintf(stdout, "*** Camera Parameter ***\n");
    arParamDisp(&cparam);
#endif
    if ((gCparamLT = arParamLTCreate(&cparam, AR_PARAM_LT_DEFAULT_OFFSET)) == NULL) {
        NSLog(@"Error: arParamLTCreate.\n");
        [self stop];
        return;
    }

    // AR init.
    if ((gARHandle = arCreateHandle(gCparamLT)) == NULL) {
        NSLog(@"Error: arCreateHandle.\n");
        [self stop];
        return;
    }
    if (arSetPixelFormat(gARHandle, pixFormat) < 0) {
        NSLog(@"Error: arSetPixelFormat.\n");
        [self stop];
        return;
    }
    if ((gAR3DHandle = ar3DCreateHandle(&gCparamLT->param)) == NULL) {
        NSLog(@"Error: ar3DCreateHandle.\n");
        [self stop];
        return;
    }
    
    // libARvideo on iPhone uses an underlying class called CameraVideo. Here, we
    // access the instance of this class to get/set some special types of information.
    CameraVideo *cameraVideo = ar2VideoGetNativeVideoInstanceiPhone(gVid->device.iPhone);
    if (!cameraVideo) {
        NSLog(@"Error: Unable to set up AR camera: missing CameraVideo instance.\n");
        [self stop];
        return;
    }
    
    // The camera will be started by -startRunLoop.
    [cameraVideo setTookPictureDelegate:self];
    [cameraVideo setTookPictureDelegateUserData:NULL];
    
    // Other ARToolKit setup.
    arSetMarkerExtractionMode(gARHandle, AR_USE_TRACKING_HISTORY_V2);
    //arSetMarkerExtractionMode(gARHandle, AR_NOUSE_TRACKING_HISTORY);
    //arSetLabelingThreshMode(gARHandle, AR_LABELING_THRESH_MODE_MANUAL); // Uncomment to use  manual thresholding.
    
    // Allocate the OpenGL view.
    glView = [[[ARView alloc] initWithFrame:[[UIScreen mainScreen] bounds] pixelFormat:kEAGLColorFormatRGBA8 depthFormat:kEAGLDepth16 withStencil:NO preserveBackbuffer:NO] autorelease]; // Don't retain it, as it will be retained when added to self.view.
    glView.arViewController = self;
    [self.view addSubview:glView];
    
    // Create the OpenGL projection from the calibrated camera parameters.
    // If flipV is set, flip.
    GLfloat frustum[16];
    arglCameraFrustumRHf(&gCparamLT->param, VIEW_DISTANCE_MIN, VIEW_DISTANCE_MAX, frustum);
    [glView setCameraLens:frustum];
    glView.contentFlipV = flipV;
    // Set up content positioning.
    glView.contentScaleMode = ARViewContentScaleModeFill;
    glView.contentAlignMode = ARViewContentAlignModeCenter;
    glView.contentWidth = gARHandle->xsize;
    glView.contentHeight = gARHandle->ysize;
    BOOL isBackingTallerThanWide = (glView.surfaceSize.height > glView.surfaceSize.width);
    if (glView.contentWidth > glView.contentHeight) glView.contentRotate90 = isBackingTallerThanWide;
    else glView.contentRotate90 = !isBackingTallerThanWide;
#ifdef DEBUG
    NSLog(@"[ARViewController start] content %dx%d (wxh) will display in GL context %dx%d%s.\n", glView.contentWidth, glView.contentHeight, (int)glView.surfaceSize.width, (int)glView.surfaceSize.height, (glView.contentRotate90 ? " rotated" : ""));
#endif
    
    // Setup ARGL to draw the background video.
    arglContextSettings = arglSetupForCurrentContext(&gCparamLT->param, pixFormat);
    
    arglSetRotate90(arglContextSettings, (glView.contentWidth > glView.contentHeight ? isBackingTallerThanWide : !isBackingTallerThanWide));
    if (flipV) arglSetFlipV(arglContextSettings, TRUE);
    int width, height;
    ar2VideoGetBufferSize(gVid, &width, &height);
    arglPixelBufferSizeSet(arglContextSettings, width, height);
    
    // Prepare ARToolKit to load patterns.
    if (!(gARPattHandle = arPattCreateHandle())) {
        NSLog(@"Error: arPattCreateHandle.\n");
        [self stop];
        return;
    }
    arPattAttach(gARHandle, gARPattHandle);
    
    // Load marker(s).
    NSString *markerConfigDataFilename = @"Data2/markers.dat";
    int mode;
    if ((markers = [ARMarker newMarkersFromConfigDataFile:markerConfigDataFilename arPattHandle:gARPattHandle arPatternDetectionMode:&mode]) == nil) {
        NSLog(@"Error loading markers.\n");
        [self stop];
        return;
    }
#ifdef DEBUG
    NSLog(@"Marker count = %d\n", [markers count]);
#endif
    // Set the pattern detection mode (template (pictorial) vs. matrix (barcode) based on
    // the marker types as defined in the marker config. file.
    arSetPatternDetectionMode(gARHandle, mode); // Default = AR_TEMPLATE_MATCHING_COLOR

    // Other application-wide marker options. Once set, these apply to all markers in use in the application.
    // If you are using standard ARToolKit picture (template) markers, leave commented to use the defaults.
    // If you are usign a different marker design (see http://www.artoolworks.com/support/app/marker.php )
    // then uncomment and edit as instructed by the marker design application.
    //arSetLabelingMode(gARHandle, AR_LABELING_BLACK_REGION); // Default = AR_LABELING_BLACK_REGION
    //arSetBorderSize(gARHandle, 0.25f); // Default = 0.25f
    //arSetMatrixCodeType(gARHandle, AR_MATRIX_CODE_3x3); // Default = AR_MATRIX_CODE_3x3
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arr = [userDefaults objectForKey:@"genderIndexPathRows"];
    Boolean showWomen = false;
    Boolean showMen = false;
    Boolean showNeutral = false;
    for(int i= 0; i < [arr count]; i ++){
        switch ((int)[arr[i] integerValue]) {
            case 0:
                showMen = true;
                break;
            case 1:
                showWomen = true;
                break;
            case 2:
                showNeutral = true;
                break;
            default:
                break;
        }
    }
    if(showWomen){
        modelPath = @"Data2/models2.dat";
        globals.setFilterBanner = false;
    } else if(showMen){
        modelPath = @"Data2/models.dat";
        globals.setFilterBanner = false;
    }
    if(showMen && showWomen){
        modelPath = @"Data2/bothGenders.dat";
        globals.setFilterBanner = false;
    }
    
    NSMutableArray *styleArr = [userDefaults objectForKey:@"styleIndexPathRows"];
    Boolean casual = false;
    Boolean formal = false;
    Boolean activewear = false;
    Boolean seasonal = false;
    for(int i= 0; i < [styleArr count]; i ++){
        switch ((int)[styleArr[i] integerValue]) {
            case 0:
                casual = true;
                break;
            case 1:
                formal = true;
                break;
            case 2:
                activewear = true;
                break;
            case 3:
                seasonal = true;
                break;
            default:
                break;
        }
    }
    
    if(showWomen && formal){
        globals.setFilterBanner = false;
        modelPath = @"Data2/fancywomenmodels.dat";
    }
    if(formal && !showWomen && !showMen){
        globals.setFilterBanner = false;
        modelPath = @"Data2/fancywomenmodels.dat";
    }
    
    NSMutableArray *colorArr = [userDefaults objectForKey:@"colorIndexPathRows"];
    Boolean blue = false;
    Boolean pink = false;
    Boolean gray = false;
    Boolean red = false;
    for(int i= 0; i < [colorArr count]; i ++){
        switch ((int)[colorArr[i] integerValue]) {
            case 0:
                blue = true;
                break;
            case 1:
                pink = true;
                break;
            case 2:
                gray = true;
                break;
            case 3:
                NSLog(@"Show red");
                red = true;
                break;
            default:
                break;
        }
    }
    if(showMen && showWomen && red && !pink && !gray && !blue){
        modelPath = @"Data2/redmodels.dat";
        globals.setFilterBanner = false;
    } else if(showMen && red && !pink && !gray && !blue){
        modelPath = @"Data2/redmalemodels.dat";
        globals.setFilterBanner = false;
    } else if(showWomen && red && !pink && !gray && !blue){
        modelPath = @"Data2/redfemalemodels.dat";
        globals.setFilterBanner = false;
    }
    
    if(showMen && showWomen && !red && !pink && !gray && blue){
        modelPath = @"Data2/bluemodels.dat";
        globals.setFilterBanner = false;
    } else if(showMen && !red && !pink && !gray && blue){
        modelPath = @"Data2/bluemalemodels.dat";
        globals.setFilterBanner = false;
    } else if(showWomen && !red && !pink && !gray && blue){
        modelPath = @"Data2/bluefemalemodels.dat";
        globals.setFilterBanner = false;
    }
    
    if(showMen && showWomen && !red && !pink && gray && !blue){
        modelPath = @"Data2/graymodels.dat";
        globals.setFilterBanner = false;
    } else if(showMen && !red && !pink && gray && !blue){
        modelPath = @"Data2/graymalemodels.dat";
        globals.setFilterBanner = false;
    } else if(showWomen && !red && !pink && gray && !blue){
        modelPath = @"Data2/grayfemalemodels.dat";
        globals.setFilterBanner = false;
    }
    
    if(showMen && showWomen && red && !pink && !gray && blue){
        globals.setFilterBanner = false;
        modelPath = @"Data2/redbluemodels.dat";
    } else if(showMen && red && !pink && !gray && blue){
        globals.setFilterBanner = false;
        modelPath = @"Data2/redbluemalemodels.dat";
    } else if(showWomen && red && !pink && !gray && blue){
        globals.setFilterBanner = false;
        modelPath = @"Data2/redbluefemalemodels.dat";
    }
    
    if(showMen && showWomen && !red && pink && !gray && !blue){
        globals.setFilterBanner = false;
        modelPath = @"Data2/pinkfemalemodels.dat";
    } else if(showWomen && !red && pink && !gray && !blue){
        globals.setFilterBanner = false;
        modelPath = @"Data2/pinkfemalemodels.dat";
    }
    
    if ((seasonal || activewear) && !formal && !casual) {
        globals.setFilterBanner = true;
    }

    if (showMen && !showWomen && (seasonal || activewear || formal) && !casual) {
        globals.setFilterBanner = true;
    }
    
    // Clear out price to item mapping
    [itemPriceMapping removeAllObjects];
    
    
    if(globals.setFilterBanner){
        modelPath = @"Data2/nothing.dat";
    }
    
    if(!showMen && !showWomen && !showNeutral && !red && !blue && !gray && !pink && !casual && !formal && !activewear && !seasonal){
        modelPath = @"Data2/bothGenders.dat";
    }
    // Set up the virtual environment.
    self.virtualEnvironment = [[[VirtualEnvironment alloc] initWithARViewController:self] autorelease];
   [self.virtualEnvironment addObjectsFromObjectListFile:modelPath connectToARMarkers:markers];
    
    // Because in this example we're not currently assigning a world coordinate system
    // (we're just using local marker coordinate systems), set the camera pose now, to
    // the default (i.e. the identity matrix).
//    float pose[16] = {1.0f, 0.0f, 0.0f, 0.0f,  0.0f, 1.0f, 0.0f, 0.0f,  0.0f, 0.0f, 1.0f, 0.0f,  0.0f, 0.0f, 0.0f, 1.0f};
//    [glView setCameraPose:pose];
//    ARdouble translation[3], rotation[4], scale[3];
//    translation[0] = 0.5f;
//    translation[1] = 0.5f;
//    translation[2] = -2.5f;
//    rotation[0] = 0.0f;
//    rotation[1] = 0.0f;
//    rotation[2] = 0.0f;
//    rotation[3] = 0.0f;
//    scale[0] = 1.0f;
//    scale[1] = 1.0f;
//    scale[2] = 1.0f;
//    VEObjectOBJ *myobj = [[VEObjectOBJ alloc] initFromFile:@"Data2/models/Barrel_Construction.obj" translation:translation rotation:rotation scale:scale];
//    //myobj.visible = TRUE;
//    [self.virtualEnvironment addObject:myobj];
//    [myobj setVisible:TRUE];

    
    // For FPS statistics.
    arUtilTimerReset();
    gCallCountMarkerDetect = 0;
    
     //Create our runloop timer
    [self setRunLoopInterval:2]; // Target 30 fps on a 60 fps device.
    [self startRunLoop];
}

- (void) cameraVideoTookPicture:(id)sender userData:(void *)data
{
    AR2VideoBufferT *buffer = ar2VideoGetImage(gVid);
    if (buffer) [self processFrame:buffer];
}

- (void) processFrame:(AR2VideoBufferT *)buffer
{
    if (buffer) {
        
        // Upload the frame to OpenGL.
        if (buffer->bufPlaneCount == 2) arglPixelBufferDataUploadBiPlanar(arglContextSettings, buffer->bufPlanes[0], buffer->bufPlanes[1]);
        else arglPixelBufferDataUpload(arglContextSettings, buffer->buff);
        
        gCallCountMarkerDetect++; // Increment ARToolKit FPS counter.
#ifdef DEBUG
        NSLog(@"video frame %ld.\n", gCallCountMarkerDetect);
#endif
#ifdef DEBUG
        if (gCallCountMarkerDetect % 150 == 0) {
            NSLog(@"*** Camera - %f (frame/sec)\n", (double)gCallCountMarkerDetect/arUtilTimer());
            gCallCountMarkerDetect = 0;
            arUtilTimerReset();            
        }
#endif
        
        // Detect the markers in the video frame.
        if (arDetectMarker(gARHandle, buffer->buff) < 0) return;
        int markerNum = arGetMarkerNum(gARHandle);
        ARMarkerInfo *markerInfo = arGetMarker(gARHandle);
#ifdef DEBUG
        NSLog(@"found %d marker(s).\n", markerNum);
#endif
        
        // Update all marker objects with detected markers.
        for (ARMarker *marker in markers) {
            if ([marker isKindOfClass:[ARMarkerSquare class]]) {
                [(ARMarkerSquare *)marker updateWithDetectedMarkers:markerInfo count:markerNum ar3DHandle:gAR3DHandle];
            } else if ([marker isKindOfClass:[ARMarkerMulti class]]) {
                [(ARMarkerMulti *)marker updateWithDetectedMarkers:markerInfo count:markerNum ar3DHandle:gAR3DHandle];
            } else {
                [marker update];
            }
        }
        
        // Get current time (units = seconds).
        NSTimeInterval runLoopTimeNow;
        runLoopTimeNow = CFAbsoluteTimeGetCurrent();
        [virtualEnvironment updateWithSimulationTime:(runLoopTimeNow - runLoopTimePrevious)];
        
        // The display has changed.
        [glView drawView:self];
        
        // Save timestamp for next loop.
        runLoopTimePrevious = runLoopTimeNow;
    }
}

- (IBAction)stop
{
    [self stopRunLoop];
    
    self.virtualEnvironment = nil;
    
    [markers release];
    markers = nil;
    
    if (arglContextSettings) {
        arglCleanup(arglContextSettings);
        arglContextSettings = NULL;
    }
    [glView removeFromSuperview]; // Will result in glView being released.
    glView = nil;
    
    if (gARHandle) arPattDetach(gARHandle);
    if (gARPattHandle) {
        arPattDeleteHandle(gARPattHandle);
        gARPattHandle = NULL;
    }
    if (gAR3DHandle) ar3DDeleteHandle(&gAR3DHandle);
    if (gARHandle) {
        arDeleteHandle(gARHandle);
        gARHandle = NULL;
    }
    arParamLTFree(&gCparamLT);
    if (gVid) {
        ar2VideoClose(gVid);
        gVid = NULL;
    }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewWillDisappear:(BOOL)animated {
    [self stop];
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    [itemPriceMapping release];
    [super dealloc];
}

// ARToolKit-specific methods.
- (BOOL)markersHaveWhiteBorders
{
    int mode;
    arGetLabelingMode(gARHandle, &mode);
    return (mode == AR_LABELING_WHITE_REGION);
}

- (void)setMarkersHaveWhiteBorders:(BOOL)markersHaveWhiteBorders
{
    arSetLabelingMode(gARHandle, (markersHaveWhiteBorders ? AR_LABELING_WHITE_REGION : AR_LABELING_BLACK_REGION));
}

- (void)hideDetailViewUI {
    BrowseClothesViewController *browsevc = (BrowseClothesViewController *)self.parentViewController;
    [browsevc.backButton setHidden:YES];
    [browsevc.filterButton setHidden:NO];
    [browsevc.menuButton setHidden:NO];
    [browsevc.itemName setHidden:YES];
    [browsevc.priceLabel setHidden:YES];
    [browsevc.availableSizes setHidden:YES];
}

- (void)showDetailViewUI:(NSString *)name {
    BrowseClothesViewController *browsevc = (BrowseClothesViewController *)self.parentViewController;
    [browsevc.backButton setHidden:NO];
    [browsevc.filterButton setHidden:YES];
    [browsevc.menuButton setHidden:YES];
    [browsevc.itemName setHidden:NO];
    [browsevc.priceLabel setHidden:NO];
    [browsevc.availableSizes setHidden:NO];
    
    NSLog(@"name: %@", name);
    NSArray *items = @[
                       @"blue-shirt.obj",
                       @"cool-jeans.obj",
                       @"red-hoodie.obj",
                       @"pink-shirt.obj",
                       @"skirt.obj",
                       @"black-jeans",
                       @"girlt.obj",
                       @"red-women-shirt.obj",
                       @"blue-women-shirt.obj",
                       @"gray-women-shirt.obj",
                       @"red-sweater.obj",
                       @"blue-sweater.obj",
                       @"gray-sweater.obj",
                       @"red-shirt.obj",
                       @"blue-hoodie.obj",
                       @"gray-hoodie.obj",
                       @"gray-suit-pants.obj",
                       @"gray-suit.obj",
                       @"brown-suit-pants.obj",
                       @"brown-suit.obj",
                       @"stripe-suit.obj",
                       ];
    int item = (int)[items indexOfObject:name];
    switch (item) {
        case 0:
            [self showDataForObj:@"Blue T-shirt"];
            break;
        case 1:
            [self showDataForObj:@"Faded Blue Jeans"];
            break;
        case 2:
            [self showDataForObj:@"Red Reflective Hoodie"];
            break;
        case 3:
            [self showDataForObj:@"Pink Short Sleeve Shirt"];
            break;
        case 4:
            [self showDataForObj:@"Maroon Pinstripe Skirt"];
            break;
        case 5:
            [self showDataForObj:@"Faded Black Jeans"];
            break;
        case 6:
            [self showDataForObj:@"Blue & Black Patterned T-shirt"];
            break;
        case 7:
            [self showDataForObj:@"Red Short Sleeve Shirt"];
            break;
        case 8:
            [self showDataForObj:@"Blue Short Sleeve Shirt"];
            break;
        case 9:
            [self showDataForObj:@"Gray Short Sleeve Shirt"];
            break;
        case 10:
            [self showDataForObj:@"Red Turtleneck Sweater"];
            break;
        case 11:
            [self showDataForObj:@"Blue Turtleneck Sweater"];
            break;
        case 12:
            [self showDataForObj:@"Gray Turtleneck Sweater"];
            break;
        case 13:
            [self showDataForObj:@"Red T-shirt"];
            break;
        case 14:
            [self showDataForObj:@"Blue Hoodie"];
            break;
        case 15:
            [self showDataForObj:@"Gray Hoodie"];
            break;
        case 16:
            [self showDataForObj:@"Gray Suit Pants"];
            break;
        case 17:
            [self showDataForObj:@"Gray Suit Jacket"];
            break;
        case 18:
            [self showDataForObj:@"Khaki Suit Pants"];
            break;
        case 19:
            [self showDataForObj:@"Khaki Suit Jacket"];
            break;
        case 20:
            [self showDataForObj:@"Gray Striped Suit Jacket"];
            break;
        default:
            [self showDataForObj:@""];
            break;
    }
}

- (void)showDataForObj:(NSString *)name {
    BrowseClothesViewController *browsevc = (BrowseClothesViewController *)self.parentViewController;
    browsevc.itemName.text = name;
    
    // Get price range
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arr = [userDefaults objectForKey:@"priceIndexPathRows"];
    
    // Wizard-of-oz to set the price, too many combinations otherwise
    NSString *price = [itemPriceMapping objectForKey:name];
    if (price == nil) {
        NSLog(@"price is nil");
        price = [NSString stringWithFormat:@"$%ld", (long)[self randomNumberBetween:8 maxNumber:60]];
        if (arr != nil && [arr count] > 0) {
            NSLog(@"selected index: %ld", (long)[arr[0] integerValue]);
            switch ([arr[0] integerValue]) {
                case 0:
                    price = [NSString stringWithFormat:@"$%ld", (long)[self randomNumberBetween:0 maxNumber:10]];
                    break;
                case 1:
                    price = [NSString stringWithFormat:@"$%ld", (long)[self randomNumberBetween:10 maxNumber:25]];
                    break;
                case 2:
                    price = [NSString stringWithFormat:@"$%ld", (long)[self randomNumberBetween:25 maxNumber:50]];
                    break;
                case 3:
                    price = [NSString stringWithFormat:@"$%ld", (long)[self randomNumberBetween:50 maxNumber:100]];
                    break;
                case 4:
                    price = [NSString stringWithFormat:@"$%ld", (long)[self randomNumberBetween:100 maxNumber:200]];
                    break;
                default:
                    break;
            }
        }
        [itemPriceMapping setObject:price forKey:name];
    }
    NSLog(@"price: %@", price);
    browsevc.priceLabel.text = price;
}


- (NSInteger)randomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max
{
    return min + arc4random_uniform((uint32_t)(max - min + 1));
}


//
//// Handles the start of a touch
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSArray*        array = [touches allObjects];
//    UITouch*        touch;
//    NSUInteger        i;
//    CGPoint            location;
//    NSUInteger      numTaps;
//    
//#ifdef DEBUG
//    //NSLog(@"[EAGLView touchesBegan].\n");
//#endif
//    
//    for (i = 0; i < [array count]; ++i) {
//        touch = [array objectAtIndex:i];
//        if (touch.phase == UITouchPhaseBegan) {
//            location = [touch locationInView:self.glView];
//            numTaps = [touch tapCount];
//            if (touchDelegate) {
//                if ([touchDelegate respondsToSelector:@selector(handleTouchAtLocation:tapCount:)]) {
//                    [touchDelegate handleTouchAtLocation:location tapCount:numTaps];
//                }
//            }
//        } // phase match.
//    } // touches.
//}
//
//// Handles the continuation of a touch.
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSArray*        array = [touches allObjects];
//    UITouch*        touch;
//    NSUInteger        i;
//    
//#ifdef DEBUG
//    //NSLog(@"[EAGLView touchesMoved].\n");
//#endif
//    
//    for (i = 0; i < [array count]; ++i) {
//        touch = [array objectAtIndex:i];
//        if (touch.phase == UITouchPhaseMoved) {
//            // Can do something appropriate for a moving touch here.
//        } // phase match.
//    } // touches.
//}
//
//// Handles the end of a touch event.
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSArray*        array = [touches allObjects];
//    UITouch*        touch;
//    NSUInteger        i;
//    
//#ifdef DEBUG
//    //NSLog(@"[EAGLView touchesEnded].\n");
//#endif
//    
//    for (i = 0; i < [array count]; ++i) {
//        touch = [array objectAtIndex:i];
//        if (touch.phase == UITouchPhaseEnded) {
//            // Can do something appropriate for end of touch here.
//        } // phase match.
//    } // touches.
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSArray*        array = [touches allObjects];
//    UITouch*        touch;
//    NSUInteger        i;
//    
//#ifdef DEBUG
//    //NSLog(@"[EAGLView touchesCancelled].\n");
//#endif
//    
//    for (i = 0; i < [array count]; ++i) {
//        touch = [array objectAtIndex:i];
//        if (touch.phase == UITouchPhaseCancelled) {
//            // Can do something appropriate for cancellation of a touch (e.g. by a system event) here.
//        } // phase match.
//    } // touches.
//}
//
//
//- (void)convertPointInViewToRay:(CGPoint)point
//{
//    
//    float m[16], A[16];
//    float p[4], q[4];
//    
//
//    
//    // Find INVERSE(PROJECTION * MODELVIEW).
//
//    float* cam = self.glView.cameraPose;
//    float* proj = self.glView->projection;
//    EdenMathMultMatrix(A, self.glView.cameraPose, self.glView->projection);
//    if (!EdenMathInvertMatrix(m, A)) {
//        
//        // Next, normalise point to viewport range [-1.0, 1.0], and with depth -1.0 (i.e. at near clipping plane).
//        p[0] = (point.x - glView.viewPort[viewPortIndexLeft]) * 2.0f / glView.viewPort[viewPortIndexWidth] - 1.0f; // (winx - viewport[0]) * 2 / viewport[2] - 1.0;
//        p[1] = (point.y - glView.viewPort[viewPortIndexBottom]) * 2.0f / glView.viewPort[viewPortIndexHeight] - 1.0f; // (winy - viewport[1]) * 2 / viewport[3] - 1.0;v
//        p[2] = -1.0f; // 2 * winz - 1.0;
//        p[3] = 1.0f;
//        
//        // Calculate the point's world coordinates.
//        EdenMathMultMatrixByVector(q, m, p);
//        NSLog(@"------------------");
//        NSLog(@"Making ray 1");
//        
//        if (q[3] != 0.0f) {
//            rayPoint1.v[0] = q[0] / q[3];
//            rayPoint1.v[1] = q[1] / q[3];
//            rayPoint1.v[2] = q[2] / q[3];
//            
//            // Next, a second point with depth 1.0 (i.e. at far clipping plane).
//            p[2] = 1.0f; // 2 * winz - 1.0;
//            NSLog(@"Making ray 2");
//            // Calculate the point's world coordinates.
//            EdenMathMultMatrixByVector(q, m, p);
//            if (q[3] != 0.0f) {
//                
//                rayPoint2.v[0] = q[0] / q[3];
//                rayPoint2.v[1] = q[1] / q[3];
//                rayPoint2.v[2] = q[2] / q[3];
//                
//                for (int i = 0; i < [self.glView->objects count]; i++) {
//                    VEObject * obj = (VEObject *) self.glView->objects[i];
//                    if([obj isIntersectedByRayFromPoint:rayPoint1 toPoint:rayPoint2]){
//                        NSLog(@"intersected");
//                    }
//                }
//                NSLog(@"Boo ya");
//                NSLog(@"------------------");
//                
//                return;
//            }
//        }
//    }
//}
//
//- (void) handleTouchAtLocation:(CGPoint)location tapCount:(NSUInteger)tapCount
//{
//    CGPoint locationFlippedY = CGPointMake(location.x, glView.surfaceSize.height - location.y);
//    NSLog(@"ARVIEWCONTROLLER - Touch at CG location (%.1f,%.1f), surfaceSize.height makes it (%.1f,%.1f) with y flipped.\n", location.x, location.y, locationFlippedY.x, locationFlippedY.y);
//    //showDetail = !showDetail;
//    [self convertPointInViewToRay:locationFlippedY];
//}

@end
