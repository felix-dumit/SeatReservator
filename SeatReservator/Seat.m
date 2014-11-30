//
//  Seat.m
//  SeatReservator
//
//  Created by Felix Dumit on 9/21/14.
//  Copyright (c) 2014 Felix Dumit. All rights reserved.
//

#import "Seat.h"

@implementation Seat

- (BOOL)isEqualToSeat:(Seat*)other
{
    return self.seatNumber == other.seatNumber && [self.seatLabel isEqualToString:other.seatLabel];
}
- (NSString*)description
{
    return [NSString stringWithFormat:@"%@%@", @(self.seatNumber), self.seatLabel];
}

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
