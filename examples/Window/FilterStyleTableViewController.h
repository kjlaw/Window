//
//  FilterStyleTableViewController.h
//  Window
//
//  Created by Kristen on 12/1/16.
//
//

#import <UIKit/UIKit.h>

@protocol FilterStyleTableViewControllerDelegate;

@interface FilterStyleTableViewController : UITableViewController {
    IBOutlet UITableView *myTableView;
}

@property (assign, nonatomic) id<FilterStyleTableViewControllerDelegate>delegate;

@end

@protocol FilterStyleTableViewControllerDelegate
- (void)updateStyleFilterDescriptionWithString:(NSString*)string;
@end
