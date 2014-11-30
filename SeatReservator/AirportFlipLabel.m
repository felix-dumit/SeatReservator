//
//  AirportFlipLabel.m
//  MyAnimations
//
//  Created by Felix Dumit on 3/25/14.
//  Copyright (c) 2014 Felix Dumit. All rights reserved.
//

#import "AirportFlipLabel.h"
#import <AVFoundation/AVFoundation.h>

// Singleton audio player to avoid multiple playbacks when multiple labels are flipping
@interface FlipAudioPlayer : NSObject

@property NSInteger labelsPlaying;

@end

@implementation FlipAudioPlayer {
    AVAudioPlayer *flipAudioPlayer;
}

static FlipAudioPlayer *sharedInstance = nil;

+ (FlipAudioPlayer *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[FlipAudioPlayer alloc] init];
        sharedInstance.labelsPlaying = 0;
    }
    
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        NSURL *url =
        [[NSBundle mainBundle] URLForResource:@"flipflap"
                                withExtension:@"aiff"];
        flipAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    }
    
    return self;
}

- (void)playFlipSound {
    self.labelsPlaying++;
    if (!flipAudioPlayer.isPlaying) {
        [flipAudioPlayer play];
    }
}

- (void)fadeVolume {
    // fade by 0.2 every 0.2 seconds if it is last label playing sound
    self.labelsPlaying--;
    if (self.labelsPlaying <= 1) {
        if (flipAudioPlayer.volume > 0.0) {
            flipAudioPlayer.volume -= 0.05;
            [self performSelector:@selector(fadeVolume)
                       withObject:nil
                       afterDelay:0.2];
        }
        else {
            // Stop and get the sound ready for playing again
            [self stopFlipSound];
        }
    }
}

- (void)stopFlipSound {
    [flipAudioPlayer stop];
    flipAudioPlayer.currentTime = 0;
    [flipAudioPlayer prepareToPlay];
    flipAudioPlayer.volume = 1.0;
}

@end

@interface AirportFlipLabel () {
    NSInteger labelsInFlip;
}

@property (strong, nonatomic) NSMutableArray *labels;

@end

@implementation AirportFlipLabel

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.textColor = [UIColor clearColor];
    self.labels = [[NSMutableArray alloc] init];
    self.useSound = YES;
    self.fixedLenght = -1;
    
    if (self.textSize == 0) {
        self.textSize = 14;
    }
    
    //[self updateText:self.text];
}

- (UILabel *)getOrCreateLabelForIndex:(NSInteger)index {
    CGRect frame = CGRectMake(self.bounds.origin.x + (self.textSize + 3) * index,
                              self.bounds.origin.y, self.textSize + 2, self.textSize + 2);
    
    UILabel *label;
    
    if (index < [self.labels count]) {
        label = [self.labels objectAtIndex:index];
    }
    else {
        label = [[UILabel alloc] initWithFrame:frame];
        
        [self.labels addObject:label];
        [self addSubview:label];
        
        label.backgroundColor = [UIColor colorWithRed:0.157 green:0.161 blue:0.165 alpha:1.000];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
    }
    
    label.frame = frame;
    label.font = [UIFont systemFontOfSize:self.textSize];
    
    return label;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self updateText:text];
}

- (void)updateText:(NSString *)text {
    [self resetLabels];
    
    //    self.textSize = self.frame.size.width / text.length - 2;
    
    text = [text uppercaseString];
    
    NSInteger len = self.fixedLenght > 0 ? self.fixedLenght : text.length;
    
    for (int i = 0; i < len; i++) {
        // get ith label
        UILabel *label = [self getOrCreateLabelForIndex:i];
        
        // get ith character
        NSString *ichar = @"";
        if (i < [text length]) {
            ichar = [NSString stringWithFormat:@"%c", [text characterAtIndex:i]] ? : @"";
        }
        
        //if it is different than current animate flip
        label.hidden = [ichar isEqualToString:@""] && !self.fixedLenght > 0;
        
        if (![ichar isEqualToString:label.text]) {
            [self animateLabel:label
                      toLetter:ichar];
        }
        
        if (self.useSound && labelsInFlip == 1) {
            [[FlipAudioPlayer sharedInstance] playFlipSound];
        }
    }
}

- (void)resetLabels {
    labelsInFlip = 0;
    
    for (UILabel *label in self.labels) {
        label.hidden = YES;
    }
}

- (void)animateLabel:(UILabel *)label toLetter:(NSString *)letter {
    // only 1 flip for spaec
    labelsInFlip++;
    
    if ([letter isEqualToString:@" "] || [letter isEqualToString:@""]) {
        [self flipLabel:label
               toLetter:letter
        inNumberOfFlips:1];
    }
    else {
        // if it is the first label to start flipping, perform start block
        if (labelsInFlip == 1 && self.startedFlippingLabelsBlock) {
            self.startedFlippingLabelsBlock();
        }
        
        // animate with between 10 to 20 flips
        [self flipLabel:label
               toLetter:letter
        inNumberOfFlips:10 + arc4random() % 10];
    }
}

- (NSString *)randomAlphabetCharacter {
    static const NSString *alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    
    return [NSString stringWithFormat:@"%C", [alphabet characterAtIndex:(arc4random() % alphabet.length)]];
}

- (void)flipLabel:(UILabel *)label toLetter:(NSString *)letter inNumberOfFlips:(NSInteger)flipsToDo {
    static const CGFloat flipVel = 0.1;
    
    [UIView transitionWithView:label
                      duration:flipVel + drand48() * flipVel
                       options:UIViewAnimationOptionTransitionFlipFromTop
                    animations: ^{
                        label.text = flipsToDo == 1 ? letter : [self randomAlphabetCharacter];
                    }
     
                    completion: ^(BOOL finished) {
                        // if last flip
                        if (flipsToDo == 1) {
                            // label has set its final value, so it stopped flipping
                            labelsInFlip--;
                            
                            // if is is 2nd last (or last) label flipping, start fading sound
                            if (labelsInFlip <= 1 && self.useSound) {
                                [[FlipAudioPlayer sharedInstance] fadeVolume];
                            }
                            
                            //if it is was last label flipping, perform finish block
                            if (labelsInFlip == 0 && self.finishedFlippingLabelsBlock) {
                                self.finishedFlippingLabelsBlock();
                            }
                        }
                        else {
                            [self flipLabel:label
                                   toLetter:letter
                            inNumberOfFlips:flipsToDo - 1];
                        }
                    }];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
