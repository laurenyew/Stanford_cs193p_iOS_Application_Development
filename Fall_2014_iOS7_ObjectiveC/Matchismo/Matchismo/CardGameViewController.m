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
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameMatchModeControl;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (strong, nonatomic) CardMatchingGame *game;
@property (nonatomic) NSUInteger historyIndex;
@end

@implementation CardGameViewController


#pragma Setup
- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[self createDeck]];
        [self setCardMatchModeControl:self.gameMatchModeControl];
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
    
    //re-enable the card match mode control
    self.gameMatchModeControl.enabled = YES;
    
    //reset the game
    self.game = nil;
    
    [self updateUI];
}

- (IBAction)setCardMatchModeControl:(UISegmentedControl *)sender {
    NSLog(@"Selected index: %ld", sender.selectedSegmentIndex);
    NSString *cardMatchMode =[sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    NSLog(@"Toggle Card Match Mode Control to: %@", cardMatchMode);
    self.game.maxCardsToStartMatch = [cardMatchMode integerValue];
}


- (IBAction)slideGameSummaryHistorySlider:(UISlider *)sender {
    NSUInteger index =(NSUInteger) sender.value;
    if(index != self.historyIndex)
    {
        NSLog(@"Slid game summary history slider to index: %lu" , index);
        self.historyIndex = index;
        [self updateSummaryUI];
    }
}



#pragma Card Buttons

- (IBAction)touchCardButton:(UIButton *)sender {
    NSLog(@"Touch Card Button");
    
    //Disable game play mode control
    self.gameMatchModeControl.enabled = NO;
    
    //Logic for choosing a card and updating game/UI
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
        cardButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //cardButton.imageView.frame = CGRectMake(0, 0, 70, 70);
        //disable matched cards
        cardButton.enabled = !card.isMatched;
        
    }
    
    //Update score label
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", (int) self.game.score];
 
    //reset the history slider to be at the most recent value
    self.historyIndex = self.game.summaryItemCount;
    [self.historySlider setMaximumValue:self.historyIndex];
    [self.historySlider setValue:self.historyIndex animated:YES];
    
    //Update history summary for new move
    [self updateSummaryUI];
}

static const float CURRENT_EVENT_ALPHA = 1.0;
static const float PAST_EVENT_ALPHA = 0.3;

- (void)updateSummaryUI
{
    self.summaryLabel.text = [self.game summaryAtIndex: self.historyIndex];
    
    //Summaries from the past should be grayed out
    if (self.historyIndex == self.historySlider.maximumValue) {
        [self.summaryLabel setAlpha:CURRENT_EVENT_ALPHA];
    }
    else{
        [self.summaryLabel setAlpha:PAST_EVENT_ALPHA];
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
