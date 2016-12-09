//
//  BrowseClothesViewController.h
//  Window
//
//  Created by Kristen on 12/7/16.
//
//

#import <UIKit/UIKit.h>

@interface BrowseClothesViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIView *snapshotView;
@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) IBOutlet UIButton *filterButton;
@property (nonatomic, retain) IBOutlet UILabel *storeLabel;
@property (nonatomic, retain) IBOutlet UIButton *menuButton;
@property (retain, nonatomic) IBOutlet UITextView *itemName;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;
@property (retain, nonatomic) IBOutlet UITextView *availableSizes;

@end
