//
//  TCardsView.h
//  TCards
//
//  Created by Tulakshana Weerasooriya on 5/13/16.
//  Copyright © 2016 Tulakshana Weerasooriya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol cardsViewDelegate;

@interface TCardsView : UIView

@property (nonatomic,weak)id<cardsViewDelegate>delegate;
- (void)reloadData;
- (void)loadNext;
- (void)loadPrevious;
@end

@protocol cardsViewDelegate <NSObject>

- (CGSize)sizeForContainerCardsView:(TCardsView *)cardsView;
- (int)numberOfItemsInCardsView:(TCardsView *)cardsView;
- (int)numberOfVisibleItemsInCardsView:(TCardsView *)cardsView;
- (UIView *)cardsView:(TCardsView *)cardsView itemAtIndex:(int)index;
- (void)cardsView:(TCardsView *)cardsView didTouchItemAtIndex:(int)index;
@end
