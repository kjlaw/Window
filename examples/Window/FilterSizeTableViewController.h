//
//  FilterSizeTableViewController.h
//  Window
//
//  Created by Kristen on 12/1/16.
//
//

#import <UIKit/UIKit.h>

@protocol FilterSizeTableViewControllerDelegate;

@interface FilterSizeTableViewController : UITableViewController {
    IBOutlet UITableView *myTableView;
}

@property (assign, nonatomic) id<FilterSizeTableViewControllerDelegate>delegate;

@end

@protocol FilterSizeTableViewControllerDelegate
- (void)updateSizeFilterDescriptionWithString:(NSString*)string;
@end
