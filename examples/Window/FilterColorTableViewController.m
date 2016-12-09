//
//  FilterColorTableViewController.m
//  Window
//
//  Created by Kristen on 12/1/16.
//
//

#import "FilterColorTableViewController.h"

@interface FilterColorTableViewController ()

@end

@implementation FilterColorTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.allowsMultipleSelection = YES;
    
    [self retrieveData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController) {
        [self save];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)save {
    NSArray *selectedIndexPaths = [self.tableView indexPathsForSelectedRows];
    NSMutableArray *selectedIndexPathRows = [NSMutableArray array];
    NSMutableString *filterString = [NSMutableString stringWithString:@""];
    
    NSMutableArray *selectedFilters = [NSMutableArray array];
    for (int i = 0; i < selectedIndexPaths.count; i++) {
        [selectedIndexPathRows addObject:[NSNumber numberWithInteger:[selectedIndexPaths[i] row]]];
        UITableViewCell *cell = [super tableView:myTableView cellForRowAtIndexPath:selectedIndexPaths[i]];
        [selectedFilters addObject:cell.textLabel.text];
        if (i > 0) {
            [filterString appendString:@", "];
        }
        [filterString appendString:cell.textLabel.text];
        NSLog(@"selected: %@", cell.textLabel.text);
    }
    
    [self storeData:selectedIndexPathRows];
    
    [self.delegate updateColorFilterDescriptionWithString:filterString];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)storeData:(NSMutableArray *)selectedIndexPathRows {
    // Get the standardUserDefaults object, store your UITableView data array against a key, synchronize the defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:selectedIndexPathRows forKey:@"colorIndexPathRowsNew"];
    [userDefaults synchronize];
}

- (void)retrieveData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *selectedIndexPathRows = [userDefaults arrayForKey:@"colorIndexPathRowsNew"];
    
    for (int i = 0; i < selectedIndexPathRows.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[selectedIndexPathRows[i] integerValue] inSection:0];
        UITableViewCell *cell = [super tableView:myTableView cellForRowAtIndexPath:indexPath];
        cell.selected = YES;
        [myTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = cell.selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:59.0f/255.0f
                                                  green:209.0f/255.0f
                                                   blue:209.0f/255.0f
                                                  alpha:0.5f];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
