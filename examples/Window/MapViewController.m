//
//  MapViewController.m
//  Window
//
//  Created by Kristen on 12/8/16.
//
//

#import "MapViewController.h"


#define METERS_PER_MILE 1609.344

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewWillAppear:(BOOL)animated {
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 37.4428;
    zoomLocation.longitude= -122.1719;

    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5 * METERS_PER_MILE, 0.5 * METERS_PER_MILE);

    [_mapView setRegion:viewRegion animated:YES];
    
//    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
//    point.coordinate = userLocation.coordinate;
//    point.title = @"Where am I?";
//    point.subtitle = @"I'm here!!!";
//    
//    [self.mapView addAnnotation:point];
//    

//    MKPlacemark *placemark = [[[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(37.4390, -122.1735) addressDictionary:nil] autorelease];
//    MKMapItem *mapItem = [[[MKMapItem alloc] initWithPlacemark:placemark] autorelease];
//    [mapItem setName:@"Name of your location"];
//    
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(37.439187, -122.173559);
    annotation.title = @"Nordstrom";
    [_mapView addAnnotation:annotation];
    
    MKPointAnnotation *annotation1 = [[MKPointAnnotation alloc] init];
    annotation1.coordinate = CLLocationCoordinate2DMake(37.444683, -122.171593);
    annotation1.title = @"Banana Republic";
    [_mapView addAnnotation:annotation1];
    
    MKPointAnnotation *annotation2 = [[MKPointAnnotation alloc] init];
    annotation2.coordinate = CLLocationCoordinate2DMake(37.442808, -122.171237);
    annotation2.title = @"Gap";
    [_mapView addAnnotation:annotation2];
    
    MKPointAnnotation *annotation3 = [[MKPointAnnotation alloc] init];
    annotation3.coordinate = CLLocationCoordinate2DMake(37.445074, -122.171733);
    annotation3.title = @"Macy's";
    [_mapView addAnnotation:annotation3];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_mapView release];
    [super dealloc];
}
@end
