//
//  GlobalVars.h
//  Window
//
//  Created by Max Freundlich on 12/6/16.
//
//

#import <Foundation/Foundation.h>
#import "ARMarker.h" // ARVec3

@interface GlobalVars : NSObject
{
    Boolean *_clicked;
    ARVec3 *_rP1;
    ARVec3 *_rP2;
    int cycle;
    Boolean showTop;
    Boolean showBottom;
    Boolean newMove;
    Boolean inDetail;
    int numObjects;
    int index;
    int curIndex;
    ARPose saved;
    Boolean savedPose;
}

+ (GlobalVars *)sharedInstance;

@property(nonatomic, readwrite) Boolean *clicked;
@property(nonatomic, readwrite) Boolean *showTop;
@property(nonatomic, readwrite) Boolean *showBottom;
@property(nonatomic, readwrite) Boolean newMove;
@property(nonatomic, readwrite) Boolean inDetail;
@property(nonatomic, readwrite) ARVec3 *rP1;
@property(nonatomic, readwrite) ARVec3 *rP2;
@property(nonatomic, readwrite) int cycle;
@property(nonatomic, readwrite) int numObjects;
@property(nonatomic, readwrite) int index;
@property(nonatomic, readwrite) int curIndex;
@property(nonatomic, readwrite) ARPose saved;
@property(nonatomic, readwrite) Boolean savedPose;







@end
