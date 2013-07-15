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
    CGFloat _velocity;
    CGFloat _scrollSpeed;
    
    CGFloat _startOffset;
    CGFloat _endOffset;
    double _startTime;
    NSTimeInterval _scrollDuration;
    
    NSMutableArray *_itemsArray;
    
    struct {
        unsigned int scrolling:1;
        unsigned int decelerating:1;
        
        unsigned int paging:1;
        unsigned int oneWindowEachPan:1;
    } _statusFlag;
}

@end

@implementation TMOnePageView


- (TMOPActionItem *) actionItemWithView:(UIView *)aContentView
{
    __autoreleasing TMOPActionItem *item = [[TMOPActionItem alloc] init];
    CGRect f = aContentView.frame;
    f.origin = CGPointZero;
    aContentView.frame = f;
    
     item.contentView = [[UIView alloc] initWithFrame:aContentView.bounds];
    [item.contentView addSubview:aContentView];
    item.contentView.alpha = 0.0;
    [self addSubview:item.contentView];
    
    [_itemsArray addObject:item];
    
    return item;
}

- (void) setUp
{
    _perspective = -1.0f/500.0f;
    _viewpointOffset = CGSizeZero;
    _numberOfPage = 1.0;
    _scrollSpeed = 1.0;
    _statusFlag.paging = YES;
    _statusFlag.oneWindowEachPan = YES;
    _statusFlag.scrolling = _statusFlag.decelerating = NO;
    
    _itemsArray = [[NSMutableArray alloc] init];
    
    /// initial a scroll view
    _mainContentView = [[UIView alloc] initWithFrame:self.bounds];
    _mainContentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gesPan:)];
    panGesture.delegate = self;
    [_mainContentView addGestureRecognizer:panGesture];
    
    [self addSubview:_mainContentView];
    
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
    
    [self updateAllItems];
    
}

- (void) updateAllItems
{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = _perspective;
    transform = CATransform3DTranslate(transform, -_viewpointOffset.width, -_viewpointOffset.height, 0.0f);
    transform = CATransform3DTranslate(transform, -_positionMark, 0.0f, 0.0f);
    
    for (TMOPActionItem *actionItem in _itemsArray) {
        actionItem.contentView.alpha = (actionItem.alphaBlock) ? actionItem.alphaBlock(actionItem.contentView.alpha, self) : 0;
        actionItem.contentView.layer.transform = (actionItem.actionBlock) ? actionItem.actionBlock(transform, self) : transform;
        
        actionItem.contentView.userInteractionEnabled = NO;
    }
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
            _velocity = -[panGesture velocityInView:self].x * factor * _scrollSpeed / [self windowWidth];
            //_scrollOffset -= translation * factor * _offsetMultiplier / _itemWidth;
            _positionMark -= translation;
            NSLog(@"_positionMark = %f", _positionMark);
            [self disableAnimation];
            [self didScroll];
            [self enableAnimation];
        }
    }
}

- (CGFloat) scrollOffset
{
    return _positionMark / [self windowWidth];
}

- (CGFloat) contentWidth
{
    return _numberOfPage * [self windowWidth];
}

#pragma mark - 

- (CGFloat)decelerationDistance
{
    static CGFloat decelerationRate = 0.95f;
    CGFloat acceleration = -_velocity * 30.0f * (1.0f - decelerationRate);
    return -powf(_velocity, 2.0f) / (2.0f * acceleration);
}

- (BOOL)shouldDecelerate
{
    return (fabsf(_velocity) > 2.0) &&
    (fabsf([self decelerationDistance]) > 0.1);
}

- (BOOL)shouldScroll
{
#if 1
    return YES;
#else
    
    return (fabsf(_velocity) > 2.0) &&
    (fabsf(_scrollOffset - self.currentItemIndex) > 0.1);
#endif
}

- (void)startDecelerating
{
    CGFloat distance = [self decelerationDistance];
    _startOffset = [self scrollOffset];
    _endOffset = _startOffset + distance;
    if (_statusFlag.paging)
    {
        if (distance > 0.0f)
        {
            _endOffset = ceilf(_endOffset);
        }
        else
        {
            _endOffset = floorf(_endOffset);
        }
    }

    distance = _endOffset - _startOffset;
    
    if (_statusFlag.oneWindowEachPan && _statusFlag.paging) {
        if (distance > 1) {
            _endOffset -= 1.0 * floorf(distance);
            distance = _endOffset - _startOffset;
        }
        else if (distance < -1.0) {
            _endOffset -= 1.0 * ceilf(distance);
            distance = _endOffset - _startOffset;
        }
    }
    
    _startTime = CACurrentMediaTime();
    _scrollDuration = fabsf(distance) / fabsf(0.5f * _velocity);
    
    if (distance != 0.0f)
    {
        _statusFlag.decelerating = YES;
        [self startAnimation];
    }
}

- (CGFloat)easeInOut:(CGFloat)time
{
    return (time < 0.5f)? 0.5f * powf(time * 2.0f, 3.0f): 0.5f * powf(time * 2.0f - 2.0f, 3.0f) + 1.0f;
}

@end
