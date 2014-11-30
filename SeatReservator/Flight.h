//
//  Flight.h
//  SeatReservator
//
//  Created by Felix Dumit on 9/20/14.
//  Copyright (c) 2014 Felix Dumit. All rights reserved.
//

#import "SeatRow.h"
#import <Realm/Realm.h>

@interface Flight : RLMObject

@property NSString* name;
@property RLMArray<SeatRow>* firstClassSeatRows;
@property RLMArray<SeatRow>* businessClassSeatRows;
@property RLMArray<SeatRow>* economyClassSeatRows;

+ (Flight*)createFlightWithName:(NSString*)name firstClassRows:(NSInteger)first businessClassSeatRows:(NSInteger)business economyClassSeatRows:(NSInteger)economy;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Flight>
RLM_ARRAY_TYPE(Flight)
