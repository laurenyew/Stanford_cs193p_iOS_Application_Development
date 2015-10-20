//
//  ViewController.m
//  Matchismo
//
//  Created by laurenyew on 10/18/15.
//  Copyright © 2015 CS193p. All rights reserved.
//

#import "CardGameViewController.h"

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@end

@implementation CardGameViewController

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    [self.flipsLabel setText:[NSString stringWithFormat:@"Flips: %d", flipCount]];
    NSLog(@"flipcount changed to %d", self.flipCount);
}

- (IBAction)touchCardButton:(UIButton *)sender {
    //length = 1, you are on the cardFront
    if ([sender.currentTitle length]) {
        [sender setBackgroundImage:[UIImage imageNamed: @"cardBack"] forState:  UIControlStateNormal];
        [sender setTitle:@"" forState:UIControlStateNormal];
    }
    else
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"cardFront"] forState:UIControlStateNormal];
        [sender setTitle:@"A♣︎" forState:UIControlStateNormal];
    }
    
    self.flipCount++;
}


@end
