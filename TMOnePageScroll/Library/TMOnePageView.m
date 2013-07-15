/*
 TMOnePageView.m
 
 Copyright (c) 2013 willsbor Kang at ThinkerMobile
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
*/


#import "TMOnePageView.h"

#import <libkern/OSAtomic.h>
#import <QuartzCore/QuartzCore.h>

#import "TMOPActionItem.h"

@interface TMOnePageView () <UIGestureRecognizerDelegate>
{
    UIView *_mainContentView;
    CGFloat _previousLocation;
    int32_t _animationTrigCount;
    NSTimer *_animationTimer;
    CGFloat _perspective;
    CGSize _viewpointOffset;
    
    NSMutableArray *_itemsArray;
    
    TMOPActionItem *_tmpItem;
    
    struct {
        unsigned int scrolling:1;
    } _statusFlag;
}

@end

@implementation TMOnePageView

- (void) setUp
{
    _perspective = -1.0f/500.0f;
    _viewpointOffset = CGSizeZero;
    _contentWidth = 500.0;
    
    _itemsArray = [[NSMutableArray alloc] init];
    
    /// initial a scroll view
    _mainContentView = [[UIView alloc] initWithFrame:self.bounds];
    _mainContentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gesPan:)];
    panGesture.delegate = self;
    [_mainContentView addGestureRecognizer:panGesture];
    
    [self addSubview:_mainContentView];
    
    
    //CATransform3D transform = CATransform3DIdentity;
    //transform.m34 = _perspective;
    //transform = CATransform3DTranslate(transform, -_viewpointOffset.width, -_viewpointOffset.height, 0.0f);
    
    _tmpItem = [[TMOPActionItem alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [_tmpItem setAction:^CATransform3D(CATransform3D transform, TMOnePageView *onePageView) {

        if (onePageView.positionMark < 160) {
            return CATransform3DTranslate(transform, onePageView.windowWidth - onePageView.positionMark, 0.0f, 0.0f);
        }
        else if (onePageView.positionMark < 300) {
            return CATransform3DTranslate(transform, 160, 0.0f, 0.0f);
        }
        else {
            return CATransform3DTranslate(transform, onePageView.windowWidth - (onePageView.positionMark - 140), 0.0f, 0.0f);
        }
    }];
    
    _tmpItem.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    [_mainContentView addSubview:_tmpItem];
}

- (CGFloat) windowWidth
{
    return self.frame.size.width;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
        
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}


#pragma mark - animation

- (void)enableAnimation
{
    //OSAtomicDecrement32(&_animationTrigCount);
    _animationTrigCount--;
    if (_animationTrigCount == 0) {
        [CATransaction setDisableActions:NO];
    }
}

- (void)disableAnimation
{
    //OSAtomicIncrement32(&_animationTrigCount);
    _animationTrigCount++;
    if (_animationTrigCount == 1) {
        [CATransaction setDisableActions:YES];
    }
}


- (void)startAnimation
{
    if (!_animationTimer)
    {
        _animationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0
                                                  target:self
                                                selector:@selector(step)
                                                userInfo:nil
                                                 repeats:YES];
    }
}

- (void)stopAnimation
{
    [_animationTimer invalidate];
    _animationTimer = nil;
}

- (void)step
{
    [self disableAnimation];
    NSTimeInterval currentTime = CACurrentMediaTime();
    
    if (_statusFlag.scrolling)
    {
        [self didScroll];

    }
    
    [self enableAnimation];
}

- (void)didScroll
{
    
    //[self loadUnloadViews];
   // [self transformItemViews];
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = _perspective;
    transform = CATransform3DTranslate(transform, -_viewpointOffset.width, -_viewpointOffset.height, 0.0f);
    
    
    //if (_tmpItem.startPosition - _tmpItem.frame.size.width >= _scrollOffset
    //    && _tmpItem.startPosition <= _scrollOffset + self.frame.size.width) {
        
        
        //transform = CATransform3DTranslate(transform, _tmpItem.startPosition, 0.0f, 0.0f);
        _tmpItem.layer.transform = _tmpItem.action(transform, self);
    //}
    
    
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gesture shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gesture
{
    return YES;
}


- (void)gesPan:(UIPanGestureRecognizer *)panGesture
{
    switch (panGesture.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            NSLog(@"UIGestureRecognizerStateBegan");
            _statusFlag.scrolling = YES;
            _previousLocation = [panGesture translationInView:self].x;
            //[self startAnimation];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            NSLog(@"UIGestureRecognizerStateEnded & UIGestureRecognizerStateCancelled");
            //[self stopAnimation];
            _statusFlag.scrolling = NO;
            break;
        }
        default:
        {
            NSLog(@"default");
            CGFloat translation = ([panGesture translationInView:self].x) - _previousLocation;
            CGFloat factor = 1.0f;
            _previousLocation = [panGesture translationInView:self].x;
            //_startVelocity = -[panGesture velocityInView:self].x * factor * _scrollSpeed / _itemWidth;
            //_scrollOffset -= translation * factor * _offsetMultiplier / _itemWidth;
            _positionMark -= translation;
            NSLog(@"_positionMark = %f", _positionMark);
            [self didScroll];
        }
    }
}


@end
