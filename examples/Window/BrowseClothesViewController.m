//
//  BrowseClothesViewController.m
//  Window
//
//  Created by Kristen on 12/7/16.
//
//

#import "BrowseClothesViewController.h"
#import "ContactsTableViewController.h"

@interface BrowseClothesViewController ()

@end

@implementation BrowseClothesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)getScreenshotImageFromView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates: false];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShareSegue"]) {
        UINavigationController *navcon = (UINavigationController *)segue.destinationViewController;
        ContactsTableViewController *sharevc = (ContactsTableViewController *)navcon.visibleViewController;
        UIImage *image = [self getScreenshotImageFromView:_snapshotView];
        sharevc.snapshotImage = image;
    }
}

@end
