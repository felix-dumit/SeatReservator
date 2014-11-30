//
//  Seat.h
//  SeatReservator
//
//  Created by Felix Dumit on 9/21/14.
//  Copyright (c) 2014 Felix Dumit. All rights reserved.
//

#import <Realm/Realm.h>

typedef NS_ENUM(NSInteger, SeatRowType) {
    SeatTypeFirstClass,
    SeatTypeBusinessClass,
    SeatTypeEconomyClass,
};

@interface Seat : RLMObject

@property NSInteger seatNumber;
@property NSString* seatLabel;
@property BOOL reserved;
@property SeatRowType type;

- (BOOL)isEqualToSeat:(Seat*)other;
- (NSString*)description;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Seat>
RLM_ARRAY_TYPE(Seat)
