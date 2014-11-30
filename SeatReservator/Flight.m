//
//  Flight.m
//  SeatReservator
//
//  Created by Felix Dumit on 9/20/14.
//  Copyright (c) 2014 Felix Dumit. All rights reserved.
//

#import "Flight.h"

@implementation Flight

+ (Flight*)createFlightWithName:(NSString*)name
           firstClassRows:(NSInteger)first
    businessClassSeatRows:(NSInteger)business
     economyClassSeatRows:(NSInteger)economy
{
    RLMRealm* realm = [RLMRealm defaultRealm];
    
    Flight* flight = [Flight new];
    [realm beginWriteTransaction];
    
    SeatRow* seatRow;
    for (NSInteger i = 0; i < first; i++) {
        seatRow = [SeatRow seatRowWithNumber:i + 1 forType:SeatTypeFirstClass];
        [flight.firstClassSeatRows addObject:seatRow];
    }
    for (NSInteger i = first; i < first + business; i++) {
        seatRow = [SeatRow seatRowWithNumber:i + 1 forType:SeatTypeBusinessClass];
        [flight.businessClassSeatRows addObject:seatRow];
    }
    
    for (NSInteger i = first + business; i < first + business + economy; i++) {
        seatRow = [SeatRow seatRowWithNumber:i + 1 forType:SeatTypeEconomyClass];
        [flight.economyClassSeatRows addObject:seatRow];
    }
    
    flight.name = name;
    [realm addObject:flight];
    [realm commitWriteTransaction];
    
    return flight;
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
