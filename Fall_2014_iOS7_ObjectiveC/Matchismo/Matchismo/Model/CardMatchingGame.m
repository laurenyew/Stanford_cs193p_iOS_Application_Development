//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by laurenyew on 11/8/15.
//  Copyright © 2015 CS193p. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; //of Card
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if(!_cards)
    {
        _cards = [[NSMutableArray alloc]init];
    }
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)chooseCardAtIndex:(NSUInteger)index
{
    
}
- (Card *)cardAtIndex:(NSUInteger)index
{
    return nil;
}
@end
