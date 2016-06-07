//
//  ViewController.m
//  TCards
//
//  Created by Tulakshana Weerasooriya on 5/12/16.
//  Copyright © 2016 Tulakshana Weerasooriya. All rights reserved.
//

#import "ViewController.h"

#import "TCardsView.h"

@interface ViewController () <cardsViewDelegate>{
    IBOutlet TCardsView *cardView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    cardView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    
    [cardView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - cardsViewDelegate

- (CGSize)sizeForContainerCardsView:(TCardsView *)cardsView{
    return CGSizeMake(250, 250);
}
- (int)numberOfItemsInCardsView:(TCardsView *)cardsView{
    return 5;
}

- (int)numberOfVisibleItemsInCardsView:(TCardsView *)cardsView{
    return 3;
}

- (UIView *)cardsView:(TCardsView *)cardsView itemAtIndex:(int)index{
    UIView *card = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    [card setBackgroundColor:[UIColor colorWithRed:180./255. green:180./255. blue:180./255. alpha:1.]];
    [card.layer setShadowColor:[UIColor blackColor].CGColor];
    [card.layer setShadowOpacity:.5];
    [card.layer setShadowOffset:CGSizeMake(0, 0)];
    [card.layer setBorderColor:[UIColor whiteColor].CGColor];
    [card.layer setBorderWidth:10.];
    [card.layer setCornerRadius:4.];
    
    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectInset(card.frame, 20, 20)];
    [labelView setCenter:CGPointMake(card.frame.size.width/2, card.frame.size.height/2)];
    [labelView setFont:[UIFont boldSystemFontOfSize:100]];
    [labelView setTextAlignment:NSTextAlignmentCenter];
    [labelView setTextColor:[UIColor grayColor]];
    [labelView setText:[NSString stringWithFormat:@"%d",index]];
    [card addSubview:labelView];
    
    
    return card;
}

- (void)cardsView:(TCardsView *)cardsView didTouchItemAtIndex:(int)index{}

#pragma mark - 

- (IBAction)btnNextTapped:(id)sender{
    [cardView loadNext];
}

- (IBAction)btnPreviousTapped:(id)sender{
    [cardView loadPrevious];
}

@end
