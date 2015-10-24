//
//  Deck.h
//  Matchismo
//
//  Created by laurenyew on 10/24/15.
//  Copyright © 2015 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card;
- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (Card *)drawRandomCard;

@end
