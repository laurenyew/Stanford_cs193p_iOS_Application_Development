//
//  PlayingCard.m
//  Matchismo
//
//  Created by laurenyew on 10/24/15.
//  Copyright © 2015 CS193p. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

//Calculate match score for this PlayCard matched against an array of other PlayingCards
- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 1) {
        PlayingCard *otherCard = [otherCards firstObject];
        if (otherCard.rank == self.rank) {
            score = 4;
        } else if ([otherCard.suit isEqualToString:self.suit]){
            score = 1;
        }
        
        if (score > 0)
        {
            NSLog(@"Matched %@ and %@. Score is %d", self.contents, otherCard, score);
        }
    }
    //Recursive call to add up matching score for all cards
    else
    {
        NSArray *restOfOtherCards = [otherCards subarrayWithRange:NSMakeRange(1, [otherCards count] - 1)];
        score = score + [self match:restOfOtherCards];
    }
    
    
    return score;
}

- (NSString *)contents
{
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

+ (NSArray *)validSuits
{
    return @[@"♠︎",@"♣︎", @"♥︎", @"♦︎"];
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank
{
    return [[PlayingCard rankStrings] count];
}

@end
