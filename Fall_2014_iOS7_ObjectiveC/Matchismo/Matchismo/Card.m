//
//  Card.m
//  Matchismo
//
//  Created by laurenyew on 10/24/15.
//  Copyright © 2015 CS193p. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int) match:(NSArray *)otherCards
{
    int score = 0;
    
    for (Card *card in otherCards)
    {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    
    return score;
}

@end
