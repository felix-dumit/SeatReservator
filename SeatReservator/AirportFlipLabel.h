//
//  AirportFlipLabel.h
//  MyAnimations
//
//  Created by Felix Dumit on 3/25/14.
//  Copyright (c) 2014 Felix Dumit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AirportFlipLabel : UILabel
@property BOOL useSound;
@property NSInteger textSize;
@property NSInteger fixedLenght;
@property (nonatomic, copy) void (^finishedFlippingLabelsBlock)(void);
@property (nonatomic, copy) void (^startedFlippingLabelsBlock)(void);

@property BOOL flipping;
@end
