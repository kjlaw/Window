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
    // copy temp saved filters to official saved filters
    [self saveTempFilters];
    [self removeTempSavedFilters];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
    // clear out temp NSUserDefaults
    [self removeTempSavedFilters];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self displaySavedFilters];
    [self copySavedFiltersToTemp];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveTempFilters {
    // copy temp filters back to real filters
    
    NSArray *filterKeys = @[@"genderIndexPathRows", @"styleIndexPathRows", @"sizeIndexPathRows", @"colorIndexPathRows", @"priceIndexPathRows"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    for (NSString* key in filterKeys){
        NSString* newKey = [NSString stringWithFormat:@"%@New", key];
        NSMutableArray *data = [userDefaults valueForKey:newKey];
        [self storeData:data forKey:key];
//        NSLog(@"saved value: %@ forKey: %@",[[NSUserDefaults standardUserDefaults] valueForKey:key],key);
    }
}

- (void)removeTempSavedFilters {
    NSArray *filterKeys = @[@"genderIndexPathRowsNew", @"styleIndexPathRowsNew", @"sizeIndexPathRowsNew", @"colorIndexPathRowsNew", @"priceIndexPathRowsNew"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    for (NSString* key in filterKeys){
        [userDefaults removeObjectForKey:key];
        [userDefaults synchronize];
    }
}

- (void)copySavedFiltersToTemp {
    // user defaults appended with "New" will be saved to the non-new key when save is pressed, or cleared when cancel is pressed
    
    NSArray *filterKeys = @[@"genderIndexPathRows", @"styleIndexPathRows", @"sizeIndexPathRows", @"colorIndexPathRows", @"priceIndexPathRows"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    for (NSString* key in filterKeys){
        NSString* newKey = [NSString stringWithFormat:@"%@New", key];
        NSMutableArray *data = [userDefaults valueForKey:key];
        [self storeData:data forKey:newKey];
    }
}

- (void)storeData:(NSMutableArray *)data forKey:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:data forKey:key];
    [userDefaults synchronize];
}

- (void)displaySavedFilters {
    // populate details label from saved filters
    
    NSArray *gender = @[@"Men", @"Women", @"Neutral"];
    NSArray *style = @[@"Casual", @"Formal", @"Activewear", @"Seasonal"];
    NSArray *size = @[@"X-Small", @"Small", @"Medium", @"Large", @"X-Large"];
    NSArray *color = @[@"Blue", @"Pink", @"Gray", @"Red"];
    NSArray *price = @[@"Under $10", @"$10 to $25", @"$25 to $50", @"$50 to $100", @"$100 & Above"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *genderIndexPathRows = [userDefaults arrayForKey:@"genderIndexPathRows"];
    NSMutableString *genderString = [NSMutableString stringWithString:@""];
    
    for (int i = 0; i < genderIndexPathRows.count; i++) {
        NSInteger row = [genderIndexPathRows[i] integerValue];
        if (i > 0) {
            [genderString appendString:@", "];
        }
        [genderString appendString:gender[row]];
    }
    [self updateGenderFilterDescriptionWithString:genderString];
    
    
    NSArray *styleIndexPathRows = [userDefaults arrayForKey:@"styleIndexPathRows"];
    NSMutableString *styleString = [NSMutableString stringWithString:@""];
    
    for (int i = 0; i < styleIndexPathRows.count; i++) {
        NSInteger row = [styleIndexPathRows[i] integerValue];
        if (i > 0) {
            [styleString appendString:@", "];
        }
        [styleString appendString:style[row]];
    }
    [self updateStyleFilterDescriptionWithString:styleString];
    
    
    NSArray *sizeIndexPathRows = [userDefaults arrayForKey:@"sizeIndexPathRows"];
    NSMutableString *sizeString = [NSMutableString stringWithString:@""];
    
    for (int i = 0; i < sizeIndexPathRows.count; i++) {
        NSInteger row = [sizeIndexPathRows[i] integerValue];
        if (i > 0) {
            [sizeString appendString:@", "];
        }
        [sizeString appendString:size[row]];
    }
    [self updateSizeFilterDescriptionWithString:sizeString];
    
    
    NSArray *colorIndexPathRows = [userDefaults arrayForKey:@"colorIndexPathRows"];
    NSMutableString *colorString = [NSMutableString stringWithString:@""];
    
    for (int i = 0; i < colorIndexPathRows.count; i++) {
        NSInteger row = [colorIndexPathRows[i] integerValue];
        if (i > 0) {
            [colorString appendString:@", "];
        }
        [colorString appendString:color[row]];
    }
    [self updateColorFilterDescriptionWithString:colorString];
    
    
    NSArray *priceIndexPathRows = [userDefaults arrayForKey:@"priceIndexPathRows"];
    NSMutableString *priceString = [NSMutableString stringWithString:@""];
    
    for (int i = 0; i < priceIndexPathRows.count; i++) {
        NSInteger row = [priceIndexPathRows[i] integerValue];
        if (i > 0) {
            [priceString appendString:@", "];
        }
        [priceString appendString:price[row]];
    }
    [self updatePriceFilterDescriptionWithString:priceString];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:59.0f/255.0f
                                                  green:209.0f/255.0f
                                                   blue:209.0f/255.0f
                                                  alpha:0.5f];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
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
