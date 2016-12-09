//
//  FilterPriceTableViewController.h
//  Window
//
//  Created by Kristen on 12/1/16.
//
//

#import <UIKit/UIKit.h>

@protocol FilterPriceTableViewControllerDelegate;

@interface FilterPriceTableViewController : UITableViewController {
    IBOutlet UITableView *myTableView;
}

@property (assign, nonatomic) id<FilterPriceTableViewControllerDelegate>delegate;

@end

@protocol FilterPriceTableViewControllerDelegate
- (void)updatePriceFilterDescriptionWithString:(NSString*)string;
@end
