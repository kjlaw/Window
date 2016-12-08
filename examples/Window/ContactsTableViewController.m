//
//  ContactsTableViewController.m
//  Window
//
//  Created by Kristen on 11/30/16.
//
//

#import "ContactsTableViewController.h"
#import <Contacts/Contacts.h>
#import <MessageUI/MessageUI.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ContactsTableViewController () <MFMessageComposeViewControllerDelegate>

@end

@implementation ContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //    CGSize statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
    //    CGFloat statusBarHeight = MIN(statusBarSize.width, statusBarSize.height);
    //
    //    self.tableView.contentInset = UIEdgeInsetsMake(statusBarHeight, 0, 0, 0);
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.allowsMultipleSelection = YES;
    
    [self getAllContacts];
}

- (void)getAllContacts {
    contactList = [[NSMutableArray alloc] init];
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            //keys with fetching properties
            NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
            CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
            NSError *error;
            
            [store enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact * __nonnull contact, BOOL * __nonnull stop) {
                
                // only add contact if there is a phone number
                if (contact.phoneNumbers != nil && [contact.phoneNumbers count] > 0) {
                    [contactList addObject:contact];
                    NSLog(@"added: %@ %@", contact.givenName, contact.familyName);
                    [self refreshUI];
                    for (CNLabeledValue *label in contact.phoneNumbers) {
                        NSString *phone = [label.value stringValue];
                        if ([phone length] > 0) {
                            NSLog(@"phone: %@", phone);
                        }
                    }
                }
            }];
        }
    }];
}

- (void)refreshUI {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Calling reloadData");
        [self.tableView reloadData];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"tableview count: %lu", (unsigned long)contactList.count);
    return contactList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
    
    CNContact *contact = [contactList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", contact.givenName, contact.familyName];
    cell.detailTextLabel.text = [contact.phoneNumbers firstObject].value.stringValue;
    
    cell.accessoryType = cell.selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

- (IBAction)sendTapped:(UIBarButtonItem *)sender {
    NSArray *selectedIndexPaths = [self.tableView indexPathsForSelectedRows];
    NSLog(@"selectedIndexPaths count: %lu", (unsigned long)selectedIndexPaths.count);
    
    NSMutableArray *selectedRecipients = [NSMutableArray array];
    for (int i = 0; i < selectedIndexPaths.count; i++) {
        CNContact *contact = [contactList objectAtIndex:[selectedIndexPaths[i] row]];
        NSLog(@"recipient: %@", [contact.phoneNumbers firstObject].value.stringValue);
        [selectedRecipients addObject:[contact.phoneNumbers firstObject].value.stringValue];
    }
    NSArray *recipients = [NSArray arrayWithArray:selectedRecipients];
    
    [self sendText:recipients];
}

- (void)sendText:(NSArray *)recipients {
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipients];
    
    if (_snapshotImage != nil) {
        NSData *attachment = UIImagePNGRepresentation(_snapshotImage);
        [messageController addAttachmentData:attachment typeIdentifier:(NSString *)kUTTypePNG filename:@"window_clothes.png"];
    }
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result {
    switch (result) {
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
        case MessageComposeResultSent:
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [_snapshotImage release];
    [super dealloc];
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
