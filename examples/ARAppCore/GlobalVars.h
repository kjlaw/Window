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
    int rightShifts;
    int leftShifts;
    Boolean newMove;
    Boolean inDetail;
    NSMutableDictionary *centers;
    int numObjects;
}

+ (GlobalVars *)sharedInstance;

@property(nonatomic, readwrite) Boolean *clicked;
@property(nonatomic, readwrite) Boolean *showTop;
@property(nonatomic, readwrite) Boolean *showBottom;
@property(nonatomic, readwrite) Boolean newMove;
@property(nonatomic, readwrite) Boolean inDetail;
@property(strong, nonatomic, readwrite) NSMutableDictionary *centers;
@property(nonatomic, readwrite) ARVec3 *rP1;
@property(nonatomic, readwrite) ARVec3 *rP2;
@property(nonatomic, readwrite) int cycle;
@property(nonatomic, readwrite) int rightShifts;
@property(nonatomic, readwrite) int leftShifts;
@property(nonatomic, readwrite) int numObjects;



@end
