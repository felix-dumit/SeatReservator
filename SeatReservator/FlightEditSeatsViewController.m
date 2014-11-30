//
//  ViewController.m
//  SeatReservator
//
//  Created by Felix Dumit on 9/18/14.
//  Copyright (c) 2014 Felix Dumit. All rights reserved.
//

#import <Realm/Realm.h>
#import "TWMessageBarManager.h"
#import "SeatRowTableViewCell.h"

#import "FlightEditSeatsViewController.h"

@interface FlightEditSeatsViewController () <UITableViewDelegate, UITableViewDataSource, SeatCellButtonSelectProtocol>

@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl* sectionSegmentedControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem* selectedSeatBarItem;

@property (weak, nonatomic) IBOutlet UIBarButtonItem* saveSelectedSeatBarItem;
@property (strong, nonatomic) RLMNotificationToken* notificationToken;

@property (strong, nonatomic) Seat* selectedSeat;
@property (strong, nonatomic) NSIndexPath* selectedIndexPath;

@end

@implementation FlightEditSeatsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ios-linen"]];
    
    self.title = self.flight.name;
    
    self.selectedSeat = nil;
    self.selectedIndexPath = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    __weak typeof(self) weakSelf = self;
    self.notificationToken = [[RLMRealm defaultRealm]
                              addNotificationBlock:^(NSString* notification, RLMRealm* realm) {
                                  [weakSelf.tableView reloadData];
                              }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[RLMRealm defaultRealm] removeNotification:self.notificationToken];
}

#pragma mark - Selected Seat methods
- (void)setSelectedSeat:(Seat*)selectedSeat
{
    _selectedSeat = selectedSeat;
    self.selectedSeatBarItem.title = [NSString stringWithFormat:@"Selected Seat: %@", selectedSeat ?: @""];
    
    self.saveSelectedSeatBarItem.enabled = selectedSeat != nil;
}
- (IBAction)goToSelectedSeat:(id)sender
{
    [self.tableView scrollToRowAtIndexPath:self.selectedIndexPath
                          atScrollPosition:UITableViewScrollPositionMiddle
                                  animated:YES];
}
- (IBAction)saveSelectedSeat:(id)sender
{
    [[RLMRealm defaultRealm] transactionWithBlock:^{
        self.selectedSeat.reserved = YES;
    }];
    
    [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Booked successfully"
                                                   description:[NSString stringWithFormat:@"Booked seat: %@ successfully", self.selectedSeat.description]
                                                          type:TWMessageBarMessageTypeSuccess];
    self.selectedSeat = nil;
}

- (IBAction)segmentedControlChangedSection:(id)sender
{
    // scroll to first item in section
    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:0
                                                 inSection:self.sectionSegmentedControl.selectedSegmentIndex];
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}

#pragma mark - UITableViewDataSource
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(5, 0, tableView.bounds.size.width - 5, 20)];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, 20)];
    label.text = [self.sectionSegmentedControl titleForSegmentAtIndex:section];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"halftone"]];
    [view addSubview:label];
    
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return self.sectionSegmentedControl.numberOfSegments;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.flight.firstClassSeatRows.count;
    }
    if (section == 1) {
        return self.flight.businessClassSeatRows.count;
    } else if (section == 2) {
        return self.flight.economyClassSeatRows.count;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* const firstIdentifier = @"firstRowCell";
    static NSString* const businessIdentifier = @"businessRowCell";
    static NSString* const economyIdentifier = @"economyRowCell";
    
    SeatRowTableViewCell* cell = nil;
    SeatRow* seatRow = nil;
    //FIRST CLASS CELL
    if (indexPath.section == 0) {
        cell = (SeatRowTableViewCell*)[tableView dequeueReusableCellWithIdentifier:firstIdentifier forIndexPath:indexPath];
        seatRow = [self.flight.firstClassSeatRows objectAtIndex:indexPath.row];
    }
    
    //BUSINESS CLASS CELL
    else if (indexPath.section == 1) {
        cell = (SeatRowTableViewCell*)[tableView dequeueReusableCellWithIdentifier:businessIdentifier forIndexPath:indexPath];
        seatRow = [self.flight.businessClassSeatRows objectAtIndex:indexPath.row];
    }
    
    //ECONOMY CLASS CELL
    else {
        cell = (SeatRowTableViewCell*)[tableView dequeueReusableCellWithIdentifier:economyIdentifier forIndexPath:indexPath];
        seatRow = [self.flight.economyClassSeatRows objectAtIndex:indexPath.row];
    }
    
    [cell setupSeatRow:seatRow selectedSeat:self.selectedSeat];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    // update segmented control section
    self.sectionSegmentedControl.selectedSegmentIndex = indexPath.section;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static const NSInteger firstSize = 160;
    static const NSInteger businessSize = 160;
    static const NSInteger economySize = 160;
    
    if (indexPath.section == 0) {
        return firstSize;
    } else if (indexPath.section == 1) {
        return businessSize;
    }
    return economySize;
}

#pragma mark - Cell Delegates
- (void)seatRowCell:(SeatRowTableViewCell*)cell didTapButtonAtIndex:(NSInteger)index
{
    
    NSIndexPath* previousIndexPath = [self.selectedIndexPath copy];
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    
    SeatRow* seatRow;
    if (indexPath.section == 0) {
        seatRow = [self.flight.firstClassSeatRows objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        seatRow = [self.flight.businessClassSeatRows objectAtIndex:indexPath.row];
    } else {
        seatRow = [self.flight.economyClassSeatRows objectAtIndex:indexPath.row];
    }
    
    Seat* seat = [seatRow.seats objectAtIndex:index];
    // if it is a deselection
    if ([seat isEqualToSeat:self.selectedSeat]) {
        self.selectedSeat = nil;
        self.selectedIndexPath = nil;
    }
    //set new selected seat
    else {
        self.selectedSeat = seat;
        self.selectedIndexPath = indexPath;
    }
    
    // reaload previous selected seat indexpath and new as well
    NSSet* set = [NSSet setWithObjects:indexPath, previousIndexPath, nil];
    [self.tableView reloadRowsAtIndexPaths:[set allObjects]
                          withRowAnimation:UITableViewRowAnimationNone];
}

@end
