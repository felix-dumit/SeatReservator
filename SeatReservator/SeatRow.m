//
//  Seat.m
//  SeatReservator
//
//  Created by Felix Dumit on 9/20/14.
//  Copyright (c) 2014 Felix Dumit. All rights reserved.
//
#import "SeatRow.h"

@implementation SeatRow : RLMObject

+ (SeatRow*)seatRowWithNumber:(NSInteger)row forType:(SeatRowType)type
{
    SeatRow* seatRow = [SeatRow new];
    seatRow.rowNumber = row;
    seatRow.seatType = type;
    switch (type) {
        case SeatTypeFirstClass:
            [seatRow fillSeatsForArray:FIRST_SEATS];
            break;
        case SeatTypeBusinessClass:
            [seatRow fillSeatsForArray:BUSINESS_SEATS];
            break;
        case SeatTypeEconomyClass:
            [seatRow fillSeatsForArray:ECONOMY_SEATS];
            break;
            
        default:
            break;
    }
    return seatRow;
}

- (void)fillSeatsForArray:(NSArray*)array
{
    for (int i = 0; i < array.count; i++) {
        Seat* seat = [Seat new];
        seat.seatNumber = self.rowNumber;
        seat.seatLabel = [array objectAtIndex:i % array.count];
        seat.reserved = NO;
        seat.type = self.seatType;
        [self.seats addObject:seat];
    }
}

// Specify default values for properties

//+ (NSDictionary*)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}
@end
