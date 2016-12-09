//
//  FilterColorTableViewController.h
//  Window
//
//  Created by Kristen on 12/1/16.
//
//

#import <UIKit/UIKit.h>

@protocol FilterColorTableViewControllerDelegate;

@interface FilterColorTableViewController : UITableViewController {
    IBOutlet UITableView *myTableView;
}

@property (assign, nonatomic) id<FilterColorTableViewControllerDelegate>delegate;

@end

@protocol FilterColorTableViewControllerDelegate
- (void)updateColorFilterDescriptionWithString:(NSString*)string;
@end
