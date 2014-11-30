//
//  BusinessClassTableViewCell.m
//  SeatReservator
//
//  Created by Felix Dumit on 9/20/14.
//  Copyright (c) 2014 Felix Dumit. All rights reserved.
//

#import "SeatRowTableViewCell.h"
#import "SeatRow.h"

@interface SeatRowTableViewCell ()

@end

@implementation SeatRowTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    for (UIButton* button in self.seatButtons) {
        [button addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setupSeatRow:(SeatRow*)seatRow selectedSeat:(Seat*)selectedSeat {
    self.rowLabel.text = @(seatRow.rowNumber).description;
    
    for (int i = 0; i < seatRow.seats.count; i++) {
        Seat* seat = [seatRow.seats objectAtIndex:i];
        UIButton* button = [self.seatButtons objectAtIndex:i];
        
        // setup buttons for reserved and available state
        if (seatRow.seatType == SeatTypeFirstClass) {
            // diferent left side and right side for first class
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"firstClassTaken%@", @(i + 1)]]
                    forState:UIControlStateDisabled];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"firstClassAvailable%@", @(i + 1)]]
                    forState:UIControlStateNormal];
        } else if (seatRow.seatType == SeatTypeBusinessClass) {
            [button setImage:[UIImage imageNamed:@"proSeatTaken"] forState:UIControlStateDisabled];
            [button setImage:[UIImage imageNamed:@"proSeatAvailable"] forState:UIControlStateNormal];
        } else if (seatRow.seatType == SeatTypeEconomyClass) {
            [button setImage:[UIImage imageNamed:@"economySeatTaken"] forState:UIControlStateDisabled];
            [button setImage:[UIImage imageNamed:@"economySeatAvailable"] forState:UIControlStateNormal];
        }
        // global image for current selected seat
        [button setImage:[UIImage imageNamed:@"user"] forState:UIControlStateSelected];
        
        // if it is not selected, seat is clickable
        button.enabled = !seat.reserved;
        
        // selected is it is current selected seat
        button.selected = [seat isEqualToSeat:selectedSeat];
        
        UILabel* label = [self.seatLabels objectAtIndex:i];
        label.text = seat.seatLabel;
        label.textColor = button.selected || !button.enabled ? [UIColor whiteColor] : [UIColor blackColor];
    }
}

- (void)tappedButton:(UIButton*)sender
{
    [self.delegate seatRowCell:self didTapButtonAtIndex:[self.seatButtons indexOfObject:sender]];
}

@end
