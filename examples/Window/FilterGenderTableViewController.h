//
//  FilterGenderTableViewController.h
//  Window
//
//  Created by Kristen on 12/1/16.
//
//

#import <UIKit/UIKit.h>

@protocol FilterGenderTableViewControllerDelegate;

@interface FilterGenderTableViewController : UITableViewController {
    IBOutlet UITableView *myTableView;
}

@property (assign, nonatomic) id<FilterGenderTableViewControllerDelegate>delegate;

@end

@protocol FilterGenderTableViewControllerDelegate
- (void)updateGenderFilterDescriptionWithString:(NSString*)string;
@end
