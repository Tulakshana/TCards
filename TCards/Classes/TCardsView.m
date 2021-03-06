//
//  TCardsView.m
//  TCards
//
//  Created by Tulakshana Weerasooriya on 5/13/16.
//  Copyright © 2016 Tulakshana Weerasooriya. All rights reserved.
//

#import "TCardsView.h"

#define NEXT_CARD_OFFSET 8

const static NSTimeInterval kMovingAnimationDuration = .4f;

@interface TCardsView ()

@property (nonatomic,strong) NSArray *cardsArray;
@property (nonatomic)int currentIndex;

@end

@implementation TCardsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self commonInit];
}

#pragma mark -

- (void)commonInit{
    _cardsArray = [[NSMutableArray alloc]init];
}

- (void)setDelegate:(id<cardsViewDelegate>)delegate{
    if (_delegate != delegate) {
        _delegate = delegate;
        if (_delegate) {
            
            [self setupGestures];
        }
    }
}



- (void)removeAllCards{
    for (UIView *view in _cardsArray) {
        [view removeFromSuperview];
    }
}

- (void)setCurrentCard:(int)index{
    NSLog(@"setCurrentCard: %d",index);
    if ((index > ([_cardsArray count] - 1)) || (index < 0)) {
        return;
    }
    if (_currentIndex < index) {
        [self showNext];
    }else if (_currentIndex > index) {
        [self showPrevious];
    }
}

- (void)showNext{
    _currentIndex++;
    UIView *card = [_cardsArray objectAtIndex:_currentIndex];
    [UIView animateWithDuration:kMovingAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         card.center = self.center;
                     } completion:^(BOOL finished) {
                         
                     }];
    [self arrangeStack];
}

- (void)showPrevious{
    UIView *card = [_cardsArray objectAtIndex:_currentIndex];
    _currentIndex--;
    [UIView animateWithDuration:kMovingAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         card.center = CGPointMake(self.frame.size.width + card.frame.size.width, self.center.y);
                         
                         
                     } completion:^(BOOL finished) {
                         
                         
                     }];
    [self arrangeStack];
}

- (void)setupGestures
{
    
    UISwipeGestureRecognizer *previousSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeToNext:)];
    [previousSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:previousSwipe];
    
    UISwipeGestureRecognizer *nextSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeToPrevious:)];
    [nextSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:nextSwipe];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchCard:)];
    [self addGestureRecognizer:tap];

}

- (void)arrangeStack{
    [UIView animateWithDuration:kMovingAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         for (int i = 0; i <= _currentIndex; i++) {
                             UIView *singleView = [_cardsArray objectAtIndex:i];
                             CGSize size = [_delegate sizeForContainerCardsView:self];
                             
                             int indexOfLastVisibleCard = _currentIndex - [_delegate numberOfVisibleItemsInCardsView:self] + 1;
                             
                             if (i <= indexOfLastVisibleCard) {
                                 int numberOfCardsBeforeThisCard = (_currentIndex - indexOfLastVisibleCard);
                                 CGFloat offset = NEXT_CARD_OFFSET * numberOfCardsBeforeThisCard;
                                 singleView.frame = CGRectMake(singleView.frame.origin.x, singleView.frame.origin.y, size.width - (offset * 2), size.height);
                                 singleView.center = CGPointMake(self.center.x, self.center.y - offset);
                             }else {
                                 int numberOfCardsBeforeThisCard = (_currentIndex - i);
                                 CGFloat offset = NEXT_CARD_OFFSET * numberOfCardsBeforeThisCard;
                                 singleView.frame = CGRectMake(singleView.frame.origin.x, singleView.frame.origin.y, size.width - (offset * 2), size.height);
                                 singleView.center = CGPointMake(self.center.x, self.center.y - offset);
                             }
                         }
                     } completion:^(BOOL finished) {

                     }];

}

#pragma mark - Cards Interactions

- (void)didSwipeToPrevious:(UISwipeGestureRecognizer*)swipeGesture
{
    NSLog(@"did swipe to previous");
    [self loadPrevious];
}

- (void)didSwipeToNext:(UISwipeGestureRecognizer*)swipeGesture
{
    NSLog(@"did swipe to next");
    [self loadNext];
}

- (void)didTouchCard:(UITapGestureRecognizer*)tapGesture
{
    NSLog(@"did touch card: %d",_currentIndex);
    [_delegate cardsView:self didTouchItemAtIndex:_currentIndex];
}

#pragma mark - public methods

- (void)loadNext{
    [self setCurrentCard:_currentIndex - 1];
    
}

- (void)loadPrevious{
    [self setCurrentCard:_currentIndex + 1];
}

- (void)reloadData{
    [self removeAllCards];
    
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [_delegate numberOfItemsInCardsView:self] ; i++) {
        UIView *card = [_delegate cardsView:self itemAtIndex:i];
        
        CGSize size = [_delegate sizeForContainerCardsView:self];
        
        int indexOfLastVisibleCard = [_delegate numberOfItemsInCardsView:self] - [_delegate numberOfVisibleItemsInCardsView:self];
        
        if (i < indexOfLastVisibleCard) {
            int numberOfCardsBeforeThisCard = (([_delegate numberOfItemsInCardsView:self] - 1) - indexOfLastVisibleCard);
            CGFloat offset = NEXT_CARD_OFFSET * numberOfCardsBeforeThisCard;
            card.frame = CGRectMake(card.frame.origin.x, card.frame.origin.y, size.width - (offset * 2), size.height);
            card.center = CGPointMake(self.center.x, self.center.y - offset);
        }else {
            int numberOfCardsBeforeThisCard = (([_delegate numberOfItemsInCardsView:self] - 1) - i);
            CGFloat offset = NEXT_CARD_OFFSET * numberOfCardsBeforeThisCard;
            card.frame = CGRectMake(card.frame.origin.x, card.frame.origin.y, size.width - (offset * 2), size.height);
            card.center = CGPointMake(self.center.x, self.center.y - offset);
        }
        
        card.layer.zPosition = i;
        
        [self addSubview:card];
        [tempArray addObject:card];
    }
    _cardsArray = (NSArray *)tempArray;
    _currentIndex = (int)[_cardsArray count] - 1;
    
}

@end
