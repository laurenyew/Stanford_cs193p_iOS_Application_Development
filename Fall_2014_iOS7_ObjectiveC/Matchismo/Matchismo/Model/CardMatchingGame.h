//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by laurenyew on 11/8/15.
//  Copyright © 2015 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

@property (nonatomic, readonly) NSInteger score;
//Set by the card match mode
@property (nonatomic, readwrite) NSInteger maxCardsToStartMatch;



//designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

//Summary
- (NSString *)summaryAtIndex:(NSUInteger)index;
- (NSUInteger)summaryItemCount;

@end
