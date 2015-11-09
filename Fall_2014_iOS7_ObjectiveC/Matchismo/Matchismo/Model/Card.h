//
//  Card.h
//  Matchismo
//
//  Created by laurenyew on 10/24/15.
//  Copyright © 2015 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;
@property (nonatomic, getter=isChosen) BOOL chosen;
@property (nonatomic, getter=isMatched) BOOL matched;

- (int) match:(NSArray *)otherCards;
@end
