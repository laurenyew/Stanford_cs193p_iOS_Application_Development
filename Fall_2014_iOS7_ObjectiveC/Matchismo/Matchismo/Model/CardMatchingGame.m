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


- (NSInteger)maxCardsToStartMatch
{
    //You need at least 2 cards to have a match
    //This also protects from a negative number
    if (_maxCardsToStartMatch < 2) {
        _maxCardsToStartMatch = 2;
    }
    return _maxCardsToStartMatch;
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
            //Tried to make generic to deal with any number of matches.
            
            // Step 1) Find all chosen unmatched cards for this matching session
            NSMutableArray *otherChosenCards = [[NSMutableArray alloc] init];
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [otherChosenCards addObject:otherCard];
                }
            }
            
            // Step 2) If we have hit the maxCardsToStartMatch (otherChosenCards + cardChosen),
            // match the card to otherChosenCards
            if ([otherChosenCards count] == (self.maxCardsToStartMatch - 1))
            {
                int matchScore = [card match:otherChosenCards];
                if (matchScore > 0)
                {
                    int addToScore = matchScore * MATCH_BONUS;
                    self.score += addToScore;
                    
                    NSLog(@"Matched %ld cards: Bonus: %d, Current Score: %ld", self.maxCardsToStartMatch, addToScore, self.score);
                    
                    //The cards are now matched and can no longer be rematched.
                    card.matched = YES;
                    for (Card *otherCard in otherChosenCards) {
                        otherCard.matched = YES;
                    }
                    
                }
                else{
                    //Add up score penalty for chosen cards
                    //and reset the other cards' chosen state
                    for(Card *otherCard in otherChosenCards)
                    {
                        self.score -= MISMATCH_PENALTY;
                        otherCard.chosen = NO;
                    }
                    NSLog(@"Cards did not match. Incurred penalty. Current Score: %ld", self.score);
                }
            }
            
            
//            //try to match the card against other cards
//            int numCardsMatched = 0;
//            for (Card *othercard in self.cards) {
//                if(othercard.isChosen && !othercard.isMatched)
//                {
//                    //calculate if the cards match
//                    int matchScore = [card match:@[othercard]];
//                    if (matchScore > 0) {
//                        self.score += matchScore * MATCH_BONUS;
//                        othercard.matched = YES;
//                        card.matched = YES;
//                        numCardsMatched++;
//                    } else {
//                        self.score -= MISMATCH_PENALTY;
//                        othercard.chosen = NO;
//                    }
//                    
//                    //only matching 2 cards at a time for now.
//                    if (numCardsMatched == self.maxCardsToMatch) {
//                        NSLog(@"Matched %d cards in a row.", numCardsMatched);
//                        break;
//                    }
//                }
//            }
            
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}


@end
