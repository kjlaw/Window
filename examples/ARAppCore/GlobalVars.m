//
//  GlobalVars.m
//  Window
//
//  Created by Max Freundlich on 12/6/16.
//
//
#import "GlobalVars.h"


@implementation GlobalVars

@synthesize clicked = _clicked;
@synthesize rP1 = _rP1;
@synthesize rP2 = _rP2;
@synthesize cycle = _cycle;
@synthesize showBottom = _showBottom;
@synthesize showTop = _showTop;
@synthesize newMove = _newMove;
@synthesize inDetail = _inDetail;
@synthesize numObjects = _numObjects;
@synthesize index = _index;
@synthesize curIndex = _curIndex;
@synthesize saved = _saved;
@synthesize savedPose = _savedPose;
@synthesize model = _model;



+ (GlobalVars *)sharedInstance {
    static dispatch_once_t onceToken;
    static GlobalVars *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[GlobalVars alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        _clicked = false;
        numObjects = 0;
        showTop = false;
        showBottom = false;
        cycle = 0;
        newMove = false;
        inDetail = false;
        _index = 0;
        _curIndex = 0;
        _saved = ARPoseUnity;
        _savedPose = false;
        _model = nil;
    }
    return self;
}

@end
