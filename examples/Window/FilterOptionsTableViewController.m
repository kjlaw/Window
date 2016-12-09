//
//  FilterOptionsTableViewController.m
//  Window
//
//  Created by Kristen on 12/1/16.
//
//

#import "FilterOptionsTableViewController.h"

@interface FilterOptionsTableViewController ()

@end

@implementation FilterOptionsTableViewController

- (IBAction)applyFilter:(UIBarButtonItem *)sender {
    // TODO apply filter (currently filters are saved to NSUserData when user hits save within submenu)
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
    // TODO don't apply filters (currently filters are saved to NSUserData when user hits save within submenu)
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self displaySavedFilters];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displaySavedFilters {
    // TODO populate details view from saved filters
}

- (void)updateGenderFilterDescriptionWithString:(NSString*)string {
    _genderCell.detailTextLabel.text = string;
}

- (void)updateStyleFilterDescriptionWithString:(NSString*)string; {
    _styleCell.detailTextLabel.text = string;
}

- (void)updateSizeFilterDescriptionWithString:(NSString*)string; {
    _sizeCell.detailTextLabel.text = string;
}

- (void)updateColorFilterDescriptionWithString:(NSString*)string; {
    _colorCell.detailTextLabel.text = string;
}

- (void)updatePriceFilterDescriptionWithString:(NSString*)string; {
    _priceCell.detailTextLabel.text = string;
}

#pragma mark - Table view data source

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

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


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([[segue identifier] isEqualToString:@"GenderSegue"]) {
         FilterGenderTableViewController *gendervc = (FilterGenderTableViewController *)segue.destinationViewController;
         gendervc.delegate = self;
     } else if ([[segue identifier] isEqualToString:@"StyleSegue"]) {
         FilterStyleTableViewController *stylevc = (FilterStyleTableViewController *)segue.destinationViewController;
         stylevc.delegate = self;
     } else if ([[segue identifier] isEqualToString:@"SizeSegue"]) {
         FilterSizeTableViewController *sizevc = (FilterSizeTableViewController *)segue.destinationViewController;
         sizevc.delegate = self;
     } else if ([[segue identifier] isEqualToString:@"ColorSegue"]) {
         FilterColorTableViewController *colorvc = (FilterColorTableViewController *)segue.destinationViewController;
         colorvc.delegate = self;
     } else if ([[segue identifier] isEqualToString:@"PriceSegue"]) {
         FilterPriceTableViewController *pricevc = (FilterPriceTableViewController *)segue.destinationViewController;
         pricevc.delegate = self;
     }
     
 }
 

- (void)dealloc {
    [_genderCell release];
    [_styleCell release];
    [_sizeCell release];
    [_colorCell release];
    [_priceCell release];
    [super dealloc];
}
@end
