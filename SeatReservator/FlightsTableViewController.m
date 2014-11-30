//
//  FlightsTableViewController.m
//  SeatReservator
//
//  Created by Felix Dumit on 9/21/14.
//  Copyright (c) 2014 Felix Dumit. All rights reserved.
//
#import <Realm/Realm.h>
#import "CustomIOS7AlertView.h"
#import "FlightEditSeatsViewController.h"
#import "FlightTableViewCell.h"
#import "Flight.h"
#import "FlightsTableViewController.h"

@interface FlightsTableViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) RLMResults* flights;
@property (strong, nonatomic) RLMNotificationToken* notificationToken;

@end

@implementation FlightsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ios-linen"]];
    
    self.notificationToken = [[RLMRealm defaultRealm]
                              addNotificationBlock:^(NSString* notification, RLMRealm* realm) {
                                  [self loadFlights];
                              }];
    
    [self loadFlights];
}

- (void)loadFlights
{
    self.flights = [Flight allObjects];
    
    if (self.flights.count == 0) {
        [self generateSampleData];
    }
    [self.tableView reloadData];
}

- (void)generateSampleData
{
    [Flight createFlightWithName:@"GJ Sao Paulo" firstClassRows:4 businessClassSeatRows:10 economyClassSeatRows:30];
    [Flight createFlightWithName:@"GJ Dallas" firstClassRows:5 businessClassSeatRows:20 economyClassSeatRows:50];
    [Flight createFlightWithName:@"GJ Seattle" firstClassRows:5 businessClassSeatRows:10 economyClassSeatRows:30];
    [Flight createFlightWithName:@"GJ Spokane" firstClassRows:3 businessClassSeatRows:10 economyClassSeatRows:30];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[RLMRealm defaultRealm] removeNotification:self.notificationToken];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.flights.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    FlightTableViewCell* cell = (FlightTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"flightCell" forIndexPath:indexPath];
    
    Flight* flight = [self.flights objectAtIndex:indexPath.row];
    
    cell.flipLabel.useSound = YES;
    cell.flipLabel.fixedLenght = 20;
    cell.flipLabel.textSize = 20;
    cell.flipLabel.text = flight.name;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            [[RLMRealm defaultRealm] deleteObject:[self.flights objectAtIndex:indexPath.row]];
            [tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationFade];
        }];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self performSegueWithIdentifier:@"editFlightSegue" sender:self];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editFlightSegue"]) {
        // set flight as the selected row's flight
        FlightEditSeatsViewController* vc = [segue destinationViewController];
        vc.flight = (Flight*)[self.flights objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    }
}

#pragma mark - Add new Flight
- (IBAction)newFlightTapped:(id)sender
{
    //create alert view to enter name, and number of rows (First, Business, Economy)
    
    CustomIOS7AlertView* alertView = [[CustomIOS7AlertView alloc] init];
    
    UIView* containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 250)];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    label.text = @"Enter flight info";
    
    UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 50, 200, 50)];
    textField.placeholder = @"Enter flight name";
    textField.borderStyle = UITextBorderStyleRoundedRect;
    
    UITextField* textFieldFirst = [[UITextField alloc] initWithFrame:CGRectMake(10, 110, 200, 40)];
    textFieldFirst.placeholder = @"First Class Rows (5)";
    textFieldFirst.keyboardType = UIKeyboardTypeDecimalPad;
    textFieldFirst.borderStyle = UITextBorderStyleRoundedRect;
    
    UITextField* textFieldBusiness = [[UITextField alloc] initWithFrame:CGRectMake(10, 150, 200, 40)];
    textFieldBusiness.placeholder = @"Business Rows (10)";
    textFieldBusiness.keyboardType = UIKeyboardTypeDecimalPad;
    textFieldBusiness.borderStyle = UITextBorderStyleRoundedRect;
    
    UITextField* textFieldEconomy = [[UITextField alloc] initWithFrame:CGRectMake(10, 190, 200, 40)];
    textFieldEconomy.placeholder = @"Economy Rows (30)";
    textFieldEconomy.keyboardType = UIKeyboardTypeDecimalPad;
    textFieldEconomy.borderStyle = UITextBorderStyleRoundedRect;
    
    [containerView addSubview:label];
    [containerView addSubview:textField];
    [containerView addSubview:textFieldFirst];
    [containerView addSubview:textFieldBusiness];
    [containerView addSubview:textFieldEconomy];
    
    [alertView setContainerView:containerView];
    [alertView setUseMotionEffects:TRUE];
    
    [alertView setButtonTitles:@[ @"OK", @"Cancel" ]];
    
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView* alertView, int buttonIndex) {
        if (buttonIndex == 0) {
            [Flight createFlightWithName:textField.text.length > 0 ? textField.text : @"Anonymous"
                    firstClassRows:[textFieldFirst.text integerValue] ?: 5
             businessClassSeatRows:[textFieldBusiness.text integerValue] ?: 10
              economyClassSeatRows:[textFieldEconomy.text integerValue] ?: 30];
        }
    }];
    
    [alertView show];
}

@end
