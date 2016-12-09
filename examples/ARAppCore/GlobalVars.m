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
@synthesize rightShifts = _rightShifts;
@synthesize leftShifts = _leftShifts;
@synthesize newMove = _newMove;
@synthesize inDetail = _inDetail;
@synthesize centers = _centers;
@synthesize numObjects = _numObjects;



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
        _rightShifts = 0;
        _leftShifts = 0;
        newMove = false;
        inDetail = false;
        _centers = [[NSMutableDictionary alloc] init];

        //centers = [NSMutableDictionary dictionary];
        [_centers setObject:@"centered" forKey:@"cool-jeans.obj"];
        [_centers setObject:@"centered" forKey:@"blue-shirt.obj"];
        [_centers setObject:@"out" forKey:@"red-hoodie.obj"];
        [_centers setObject:@"out" forKey:@"thsirt_v002.obj"];
        [_centers setObject:@"out" forKey:@"black-jeans.obj"];
        [_centers setObject:@"out" forKey:@"skirt.obj"];


    }
    return self;
}

@end
