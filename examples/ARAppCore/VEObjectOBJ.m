//
//  VEObjectOBJ.m
//  ARToolKit for iOS
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

#import "VEObjectOBJ.h"
#import "VirtualEnvironment.h"
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "glStateCache.h"
#import <stdio.h>
#import <stdlib.h>
#import <string.h>
#import <sys/param.h> // MAXPATHLEN
#import <Eden/EdenMath.h>
#import <Eden/glm.h>

#import "ARView.h"
#import "ARViewController.h"

@implementation VEObjectOBJ {
    GLMmodel *glmModel;
}

+ (void)load
{
    VEObjectRegistryRegister(self, @"obj");
}

- (id) initFromFile:(NSString *)file translation:(const ARdouble [3])translation rotation:(const ARdouble [4])rotation scale:(const ARdouble [3])scale config:(char *)config
{
    if ((self = [super initFromFile:file translation:translation rotation:rotation scale:scale config:config])) {
        
        // Process config, if supplied.
        BOOL flipV = FALSE;
        if (config) {
            char *a = config;
            for (;;) {
                while( *a == ' ' || *a == '\t' ) a++; // Skip whitespace.
                if( *a == '\0' ) break; // End of string.
                
                if (strncmp(a, "TEXTURE_FLIPV", 13) == 0) flipV = TRUE;
                
                while( *a != ' ' && *a != '\t' && *a != '\0') a++; // Move to next token.
            }
        }
        
        glmModel = glmReadOBJ3([file UTF8String], 0, FALSE, flipV); // 0 -> contextIndex, FALSE -> read textures later.
        if (!glmModel) {
            NSLog(@"Error: Unable to load model %@.\n", file);
            [self release];
            return (nil);
        }

        if (scale && (scale[0] != 1.0f || scale[1] != 1.0f || scale[2] != 1.0f)) glmScale(glmModel, (scale[0] + scale[1] + scale[2]) / 3.0f);
        if (translation && (translation[0] != 0.0f || translation[1] != 0.0f || translation[2] != 0.0f)) glmTranslate(glmModel, translation);
        if (rotation && (rotation[0] != 0.0f)) glmRotate(glmModel, rotation[0]*DTOR, rotation[1], rotation[2], rotation[3]);
        glmCreateArrays(glmModel, GLM_SMOOTH | GLM_MATERIAL | GLM_TEXTURE);
        
        _drawable = TRUE;

    }
    return (self);
}

- (void) wasAddedToEnvironment:(VirtualEnvironment *)environment
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(draw:) name:ARViewDrawPreCameraNotification object:environment.arViewController.glView];
    
    [super wasAddedToEnvironment:environment];
}

- (void) willBeRemovedFromEnvironment:(VirtualEnvironment *)environment
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ARViewDrawPreCameraNotification object:environment.arViewController.glView];
    
    [super willBeRemovedFromEnvironment:environment];
}

-(void) fillPose:(ARdouble* [16]) pose
{
    pose[0] = 1;
    pose[1] = 0;
    pose[2] = 0;
    pose[3] = 0;
    pose[4] = 0;
    pose[5] = 1;
    pose[6] = 0;
    pose[7] = 0;
    pose[8] = 0;
    pose[9] = 0;
    pose[10] = 1;
    pose[11] = 0;
    pose[12] = 0;
    pose[13] = 0;
    pose[14] = 0;
    pose[15] = 1;
}

-(void) draw:(NSNotification *)notification
{
    // Lighting setup.
    // Ultimately, this should be cached via the app-wide OpenGL state cache.
    const GLfloat lightWhite100[]        =    {1.00, 1.00, 1.00, 1.0};    // RGBA all on full.
    const GLfloat lightWhite75[]        =    {0.75, 0.75, 0.75, 1.0};    // RGBA all on three quarters.
    const GLfloat lightPosition0[]     =    {1.0f, 1.0f, 2.0f, 0.0f}; // A directional light (i.e. non-positional).
    
    if(_ve.arViewController.glView->showDetail == YES){
        VEObjectOBJ * obj = (VEObjectOBJ *) _ve->objects[0];
        if( obj->glmModel == glmModel && glmModel != NULL){
            NSLog(@"HEYY");
            ARdouble* pose[16];
            ARdouble val = -0.06599;
            pose[0] = &val;
            val = 0.713;
            pose[1] = &val;
            val = -0.6979;
            pose[2] = &val;
            pose[3] = 0;
            val = -0.198405;
            pose[4] = &val;
            val = -0.6949;
            pose[5] = &val;
            pose[6] = &val;
            pose[7] = 0;
            val = -0.97789;
            pose[8] = &val;
            val = 0.0928;
            pose[9] = &val;
            val = 0.18733;
            pose[10] = &val;
            pose[11] = 0;
            val = 82.97743;
            pose[12] = &val;
            val = -16.8155;
            pose[13] = &val;
            val = -610.43;
            pose[14] = &val;
            pose[15] = 1;
            //glPushMatrix();
            //glMultMatrixf(pose);
            pose[0] = 1;
            pose[1] = 0;
            pose[2] = 0;
            pose[3] = 0;
            pose[4] = 0;
            pose[5] = 1;
            pose[6] = 0;
            pose[7] = 0;
            pose[8] = 0;
            pose[9] = 0;
            pose[10] = 1;
            pose[11] = 0;
            pose[12] = 0;
            pose[13] = 0;
            pose[14] = 0;
            pose[15] = 1;
            //[self fillPose:detailPose];
//            glMultMatrixf(pose);
//            if (_lit) {
//                glLightfv(GL_LIGHT0, GL_DIFFUSE, lightWhite100);
//                glLightfv(GL_LIGHT0, GL_SPECULAR, lightWhite100);
//                glLightfv(GL_LIGHT0, GL_AMBIENT, lightWhite75);            // Default ambient = {0,0,0,0}.
//                glLightfv(GL_LIGHT0, GL_POSITION, lightPosition0);
//                glEnable(GL_LIGHT0);
//                glDisable(GL_LIGHT1);
//                glDisable(GL_LIGHT2);
//                glDisable(GL_LIGHT3);
//                glDisable(GL_LIGHT4);
//                glDisable(GL_LIGHT5);
//                glDisable(GL_LIGHT6);
//                glDisable(GL_LIGHT7);
//                glShadeModel(GL_SMOOTH);                // Do not flat shade polygons.
//                glStateCacheEnableLighting();
//            } else glStateCacheDisableLighting();
//            glmDrawArrays(glmModel, 0);
//            glPopMatrix();
        }
    } else if (_visible) {
        if(_ve->moveLeft == true && _ve->numMoved <= [_ve->objects count]){
            if(_ve->numMoved == [_ve->objects count]){
                _ve->moveLeft = false;
                _ve->numMoved = 0;
            } else {
                _ve->numMoved ++;
                _localPose.T[12] -= 100.0;
            }
        }
        if(_ve->moveRight == true && _ve->numMoved <= [_ve->objects count]){
            if(_ve->numMoved == [_ve->objects count]){
                _ve->moveRight = false;
                _ve->numMoved = 0;
            } else {
                _ve->numMoved ++;
                _localPose.T[12] += 100.0;
            }
        }
        glPushMatrix();
        glMultMatrixf(_poseInEyeSpace.T);
        glMultMatrixf(_localPose.T);
        if (_lit) {
            glLightfv(GL_LIGHT0, GL_DIFFUSE, lightWhite100);
            glLightfv(GL_LIGHT0, GL_SPECULAR, lightWhite100);
            glLightfv(GL_LIGHT0, GL_AMBIENT, lightWhite75);            // Default ambient = {0,0,0,0}.
            glLightfv(GL_LIGHT0, GL_POSITION, lightPosition0);
            glEnable(GL_LIGHT0);
            glDisable(GL_LIGHT1);
            glDisable(GL_LIGHT2);
            glDisable(GL_LIGHT3);
            glDisable(GL_LIGHT4);
            glDisable(GL_LIGHT5);
            glDisable(GL_LIGHT6);
            glDisable(GL_LIGHT7);
            glShadeModel(GL_SMOOTH);                // Do not flat shade polygons.
            glStateCacheEnableLighting();
        } else glStateCacheDisableLighting();
        glmDrawArrays(glmModel, 0);
        glPopMatrix();
    }
}

-(void) dealloc
{
    glmDelete(glmModel, 0); // Does an implicit glmDeleteArrays();

    [super dealloc];
}

@end
