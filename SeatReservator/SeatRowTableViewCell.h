//
//  BusinessClassTableViewCell.h
//  SeatReservator
//
//  Created by Felix Dumit on 9/20/14.
//  Copyright (c) 2014 Felix Dumit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeatRowTableViewCell.h"

@class SeatRow;
@class Seat;
@protocol SeatCellButtonSelectProtocol;

@interface SeatRowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel* rowLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray* seatButtons;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray* seatLabels;
@property (weak, nonatomic) id<SeatCellButtonSelectProtocol> delegate;

-(void)setupSeatRow:(SeatRow*)seatRow selectedSeat:(Seat*)selectedSeat;

@end

@protocol SeatCellButtonSelectProtocol <NSObject>
- (void)seatRowCell:(SeatRowTableViewCell*)cell didTapButtonAtIndex:(NSInteger)index;

@end
