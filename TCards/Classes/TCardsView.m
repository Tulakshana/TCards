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

- (void)reloadData{
    [self removeAllCards];
    

    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [_delegate numberOfItemsInCardsView:self] ; i++) {
        UIView *card = [_delegate cardsView:self itemAtIndex:i];
        
        
        CGSize size = [_delegate sizeForContainerCardsView:self];
        if (i < ([_delegate numberOfItemsInCardsView:self] - 1)) {
            card.frame = CGRectMake(card.frame.origin.x, card.frame.origin.y, size.width - (NEXT_CARD_OFFSET * 2), size.height);
            card.center = CGPointMake(self.center.x, self.center.y - NEXT_CARD_OFFSET);
            
        }else {
            card.frame = CGRectMake(card.frame.origin.x, card.frame.origin.y, size.width, size.height);
            card.center = self.center;
        }
        
        card.layer.zPosition = i;
        
        [self addSubview:card];
        [tempArray addObject:card];
    }
    _cardsArray = (NSArray *)tempArray;
    _currentIndex = (int)[_cardsArray count] - 1;
    
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
    
    UISwipeGestureRecognizer *previousSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeToPrevious:)];
    [previousSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:previousSwipe];
    
    UISwipeGestureRecognizer *nextSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeToNext:)];
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
                             if (i < _currentIndex) {
                                 singleView.frame = CGRectMake(singleView.frame.origin.x, singleView.frame.origin.y, size.width - (NEXT_CARD_OFFSET * 2), size.height);
                                 singleView.center = CGPointMake(self.center.x, self.center.y - NEXT_CARD_OFFSET);
                             }else {
                                 singleView.frame = CGRectMake(singleView.frame.origin.x, singleView.frame.origin.y, size.width, size.height);
                                 singleView.center = self.center;
                                 
                             }
                         }
                     } completion:^(BOOL finished) {

                     }];

}

#pragma mark - Cards Interactions

- (void)didSwipeToPrevious:(UISwipeGestureRecognizer*)swipeGesture
{
    NSLog(@"did swipe to previous");
    [self setCurrentCard:_currentIndex - 1];
}

- (void)didSwipeToNext:(UISwipeGestureRecognizer*)swipeGesture
{
    NSLog(@"did swipe to next");
    [self setCurrentCard:_currentIndex + 1];
}

- (void)didTouchCard:(UITapGestureRecognizer*)tapGesture
{
    NSLog(@"did touch card: %d",_currentIndex);
}

@end
