//
//  BrowseClothesViewController.m
//  Window
//
//  Created by Kristen on 12/7/16.
//
//

#import "BrowseClothesViewController.h"
#import "ContactsTableViewController.h"
#import "ARViewController.h"

@interface BrowseClothesViewController ()

@end

@implementation BrowseClothesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _storeLabel.layer.masksToBounds = YES;
    _storeLabel.layer.cornerRadius = 12.0;
    
//    [_filterButton setFrame:CGRectMake(30, 30, 30, 30)];
//    UIImage *image = [UIImage imageNamed:@"options.png"] ;
//    [_filterButton setBackgroundImage:image forState:UIControlStateNormal];
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

- (IBAction)backButtonPressed:(UIButton *)sender {
    ARViewController *arvc = (ARViewController *)[self.childViewControllers objectAtIndex:0];
    arvc.glView->showDetail = NO;
    [arvc hideDetailViewUI];
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

- (void)dealloc {
    [_storeLabel release];
    [super dealloc];
}
@end
