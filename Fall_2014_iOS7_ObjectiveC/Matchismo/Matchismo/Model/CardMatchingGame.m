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


- (NSInteger)maxCardsToMatch
{
    //You need at least 2 cards to have a match
    //This also protects from a negative number
    if (_maxCardsToMatch < 2) {
        _maxCardsToMatch = 2;
    }
    return _maxCardsToMatch;
}

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
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            }
            else{
                self = nil;
                break;
            }
            
        }
    }
    return self;
}


- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index <[self.cards count])? self.cards[index] : nil;
}

static const int MATCH_BONUS = 4;
static const int MISMATCH_PENALTY = 2;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    //cards only allowed to be matched once
    if (!card.matched) {
        //allow the card to be flipped
        if(card.isChosen)
        {
            card.chosen = NO;
        }
        else
        {
            //try to match the card against other cards
            for (Card *othercard in self.cards) {
                if(othercard.isChosen && !othercard.isMatched)
                {
                    //calculate if the cards match
                    int matchScore = [card match:@[othercard]];
                    if (matchScore) {
                        self.score += matchScore * MATCH_BONUS;
                        othercard.matched = YES;
                        card.matched = YES;
                    } else {
                        self.score -= MISMATCH_PENALTY;
                        othercard.chosen = NO;
                    }
                    
                    //only matching 2 cards at a time for now.
                    break;
                }
            }
            
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}
@end
