//
//  Seat.h
//  SeatReservator
//
//  Created by Felix Dumit on 9/20/14.
//  Copyright (c) 2014 Felix Dumit. All rights reserved.
//

#import "Seat.h"
#import <Realm/Realm.h>

#define FIRST_SEATS @[ @"A", @"D" ]
#define BUSINESS_SEATS @[ @"A", @"C", @"D", @"F" ]
#define ECONOMY_SEATS @[ @"A", @"B", @"C", @"D", @"E", @"F" ]

@interface SeatRow : RLMObject

@property NSInteger rowNumber;
@property SeatRowType seatType;
@property NSInteger reserved;
@property RLMArray<Seat>* seats;

+ (SeatRow*)seatRowWithNumber:(NSInteger)row forType:(SeatRowType)type;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<SeatRow>
RLM_ARRAY_TYPE(SeatRow)
