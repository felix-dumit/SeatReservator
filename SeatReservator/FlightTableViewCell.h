//
//  FlightTableViewCell.h
//  SeatReservator
//
//  Created by Felix Dumit on 9/21/14.
//  Copyright (c) 2014 Felix Dumit. All rights reserved.
//

#import "AirportFlipLabel.h"
#import <UIKit/UIKit.h>

@interface FlightTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet AirportFlipLabel* flipLabel;
@end
