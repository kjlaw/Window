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
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    _itemName.attributedText = [[NSAttributedString alloc] initWithString:@"Maroon Pinstripe Skirt" attributes:@{ NSStrokeColorAttributeName : [UIColor blackColor], NSForegroundColorAttributeName : [UIColor whiteColor], NSStrokeWidthAttributeName : @-1.0, NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle }];;
    
    _priceLabel.attributedText = [[NSAttributedString alloc] initWithString:@"$10" attributes:@{ NSStrokeColorAttributeName : [UIColor blackColor], NSForegroundColorAttributeName : [UIColor whiteColor], NSStrokeWidthAttributeName : @-1.0, NSFontAttributeName : [UIFont boldSystemFontOfSize:41] }];
    
    _availableSizes.attributedText = [[NSAttributedString alloc] initWithString:@"XS, S, M, L, XL" attributes:@{ NSStrokeColorAttributeName : [UIColor blackColor], NSForegroundColorAttributeName : [UIColor whiteColor], NSStrokeWidthAttributeName : @-1.0, NSFontAttributeName : [UIFont boldSystemFontOfSize:20], NSParagraphStyleAttributeName : paragraphStyle }];;
    
    
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
    GlobalVars *globals = [GlobalVars sharedInstance];
    globals.clicked = YES;
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
    [_itemName release];
    [_priceLabel release];
    [_availableSizes release];
    [super dealloc];
}
@end
