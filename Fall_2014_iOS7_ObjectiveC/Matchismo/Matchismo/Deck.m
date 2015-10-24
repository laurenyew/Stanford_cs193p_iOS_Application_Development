//
//  Deck.m
//  Matchismo
//
//  Created by laurenyew on 10/24/15.
//  Copyright © 2015 CS193p. All rights reserved.
//

#import "Deck.h"
@interface Deck()
@property (strong, nonatomic) NSMutableArray *cards; //of Card
@end
@implementation Deck

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc]init];
    }
    return _cards;
}

- (void)addCard:(Card*)card atTop:(BOOL)atTop
{
    
}

- (void)addCard:(Card *)card
{
    [self addCard:card atTop:NO];
}

- (Card *)drawRandomCard
{
    return nil;
}


@end
