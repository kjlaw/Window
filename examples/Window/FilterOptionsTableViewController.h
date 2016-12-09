//
//  FilterOptionsTableViewController.h
//  Window
//
//  Created by Kristen on 12/1/16.
//
//

#import <UIKit/UIKit.h>
#import "FilterGenderTableViewController.h"
#import "FilterStyleTableViewController.h"
#import "FilterSizeTableViewController.h"
#import "FilterColorTableViewController.h"
#import "FilterPriceTableViewController.h"

@interface FilterOptionsTableViewController : UITableViewController <FilterGenderTableViewControllerDelegate, FilterStyleTableViewControllerDelegate, FilterSizeTableViewControllerDelegate, FilterColorTableViewControllerDelegate, FilterPriceTableViewControllerDelegate>

@property (retain, nonatomic) IBOutlet UITableViewCell *genderCell;
@property (retain, nonatomic) IBOutlet UITableViewCell *styleCell;
@property (retain, nonatomic) IBOutlet UITableViewCell *sizeCell;
@property (retain, nonatomic) IBOutlet UITableViewCell *colorCell;
@property (retain, nonatomic) IBOutlet UITableViewCell *priceCell;

@end
