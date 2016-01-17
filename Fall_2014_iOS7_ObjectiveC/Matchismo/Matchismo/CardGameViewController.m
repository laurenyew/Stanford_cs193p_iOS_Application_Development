//
//  ViewController.m
//  Matchismo
//
//  Created by laurenyew on 10/18/15.
//  Copyright © 2015 CS193p. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "Card.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation CardGameViewController


#pragma Setup
- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[self createDeck]];
    }
    return _game;
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck  alloc]init];
}


#pragma Game Buttons

- (IBAction)touchDealButton {
    NSLog(@"Re-deal the deck");
    self.game = nil;
    [self updateUI];
}

- (IBAction)setCardMatchModeControl:(UISegmentedControl *)sender {
    NSLog(@"Selected index: %ld", sender.selectedSegmentIndex);
    NSString *cardMatchMode =[sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    NSLog(@"Toggle Card Match Mode Control to: %@", cardMatchMode);
    self.game.maxCardsToStartMatch = [cardMatchMode integerValue];
}


#pragma Card Buttons

- (IBAction)touchCardButton:(UIButton *)sender {
    NSLog(@"Touch Card Button");
    NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card]
                    forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];
        //disable matched cards
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", (int) self.game.score];
    }
}

- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardFront" : @"cardBack"];
}

@end
