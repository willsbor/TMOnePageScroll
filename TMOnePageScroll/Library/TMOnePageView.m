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

@interface TMOPActionItem (protected)
- (TMOPActionItem *) initWithView:(UIView *)aContentView AtPage:(NSUInteger)aPageIndex withAction:(TMOPActionBlock)aActionBlock andAlpha:(TMOPAlphaBlock)aAlphaBlock;
@end

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
    CGFloat _bounceDistance;
    
    NSInteger _previousPageIndex;
    
    CGFloat _toggle;
    NSTimeInterval _toggleTime;
    
    CGFloat _startOffset;
    CGFloat _endOffset;
    double _startTime;
    NSTimeInterval _scrollDuration;
    
    NSMutableArray *_itemsArray;
    
    struct {
        unsigned int scrolling:1;
        unsigned int decelerating:1;
        unsigned int dragging:1;

        unsigned int paging:1;
        unsigned int oneWindowEachPan:1;
        unsigned int bounces:1;
        unsigned int scrollEnabled:1;
    } _statusFlag;
}

@end

@implementation TMOnePageView


#pragma mark - setting

- (void) setUp
{
    _perspective = -1.0f/500.0f;
    _viewpointOffset = CGSizeZero;
    _numberOfPage = 1.0;
    _scrollSpeed = 1.0;
    _bounceDistance = 0.2f;
    _statusFlag.paging = YES;
    _statusFlag.oneWindowEachPan = YES;
    _statusFlag.scrolling = _statusFlag.decelerating = _statusFlag.dragging = NO;
    _statusFlag.bounces = YES;
    _statusFlag.scrollEnabled = YES;
    
    _itemsArray = [[NSMutableArray alloc] init];
    
    /// initial a scroll view
    _mainContentView = [[UIView alloc] initWithFrame:self.bounds];
    //_mainContentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gesPan:)];
    panGesture.delegate = self;
    [_mainContentView addGestureRecognizer:panGesture];
    
    [self addSubview:_mainContentView];
    
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

- (void)layoutSubviews
{
    _mainContentView.frame = self.bounds;
    
    _previousPageIndex = self.currentPageIndex;
    
    //align
    if (!_statusFlag.scrolling && !_statusFlag.decelerating)
    {
        if (_statusFlag.paging)
        {
            [self scrollToPageAtIndex:self.currentPageIndex animated:YES];
        }
        else
        {
            _positionMark = [self safeScrollOffset] * [self windowWidth];
        }
    }
    
    //update views
    [self didScroll];
}

#pragma mark - data control

- (TMOPActionItem *) actionItemWithView:(UIView *)aContentView AtPage:(NSUInteger)aPageIndex withAction:(TMOPActionBlock)aActionBlock andAlpha:(TMOPAlphaBlock)aAlphaBlock
{
    __autoreleasing TMOPActionItem *item = [[TMOPActionItem alloc] initWithView:aContentView AtPage:aPageIndex
                                                                     withAction:aActionBlock andAlpha:aAlphaBlock];
    
    
    [self addActionItem:item];
    
    return item;
}

- (void) addActionItem:(TMOPActionItem *)aActionItem
{
    if (![_itemsArray containsObject:aActionItem]) {
        [_itemsArray addObject:aActionItem];
        [_mainContentView addSubview:aActionItem.contentView];
        
        //UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesTap:)];
        //tapGesture.delegate = self;
        //[aActionItem.contentView addGestureRecognizer:tapGesture];
    }
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
    
    if (_toggle != 0.0f)
    {
        NSTimeInterval toggleDuration = _velocity? fminf(1.0, fmaxf(0.0, 1.0 / fabsf(_velocity))): 1.0;
        toggleDuration = 0.2 + (0.4 - 0.2) * toggleDuration;
        NSTimeInterval time = fminf(1.0f, (currentTime - _toggleTime) / toggleDuration);
        CGFloat delta = [self easeInOut:time];
        _toggle = (_toggle < 0.0f)? (delta - 1.0f): (1.0f - delta);
        [self didScroll];
    }
    
    if (_statusFlag.scrolling)
    {
        NSTimeInterval time = fminf(1.0f, (currentTime - _startTime) / _scrollDuration);
        CGFloat delta = [self easeInOut:time];
        _positionMark = (_startOffset + (_endOffset - _startOffset) * delta) * [self windowWidth];
        [self didScroll];
        if (time == 1.0f)
        {
            _statusFlag.scrolling = NO;
        }
    }
    else if (_statusFlag.decelerating)
    {
        CGFloat time = fminf(_scrollDuration, currentTime - _startTime);
        CGFloat acceleration = -_velocity/_scrollDuration;
        CGFloat distance = _velocity * time + 0.5f * acceleration * powf(time, 2.0f);
        _positionMark = (_startOffset + distance) * [self windowWidth];
        
        [self didScroll];
        if (time == (CGFloat)_scrollDuration)
        {
            _statusFlag.decelerating = NO;
            
            if (_statusFlag.paging || ([self scrollOffset] - [self safeScrollOffset]) != 0.0f)
            {
                if (fabsf([self scrollOffset] - self.currentPageIndex) < 0.01f)
                {
                    //call scroll to trigger events for legacy support reasons
                    //even though technically we don't need to scroll at all
                    [self scrollToPageAtIndex:self.currentPageIndex duration:0.01];
                }
                else
                {
                    [self scrollToPageAtIndex:self.currentPageIndex animated:YES];
                }
            }
            else
            {
                CGFloat difference = (CGFloat)self.currentPageIndex - [self scrollOffset];
                if (difference > 0.5)
                {
                    difference = difference - 1.0f;
                }
                else if (difference < -0.5)
                {
                    difference = 1.0 + difference;
                }
                _toggleTime = currentTime - 0.4f * fabsf(difference);
                _toggle = fmaxf(-1.0f, fminf(1.0f, -difference));
            }
        }
    }
    else if (_toggle == 0.0f)
    {
        [self stopAnimation];
    }
    
    [self enableAnimation];
}

- (void)didScroll
{
    
    if (!_statusFlag.bounces)
    {
        _positionMark = [self safeScrollOffset] * [self windowWidth];
    }
    else
    {
        CGFloat min = -_bounceDistance;
        CGFloat max = fmaxf(_numberOfPage - 1, 0.0f) + _bounceDistance;
        if ([self scrollOffset] < min)
        {
            _positionMark = min * [self windowWidth];
            _velocity = 0.0f;
        }
        else if ([self scrollOffset] > max)
        {
            _positionMark = max * [self windowWidth];
            _velocity = 0.0f;
        }
    }
    
    NSInteger currentIndex = roundf([self scrollOffset]);
    NSInteger difference = currentIndex - _previousPageIndex;
    if (difference)
    {
        _toggleTime = CACurrentMediaTime();
        _toggle = fmaxf(-1.0f, fminf(1.0f, -(CGFloat)difference));
        
        [self startAnimation];
    }
    
    [self updateAllItems];
    
    
    if (MIN(MAX(_previousPageIndex, 0), _numberOfPage - 1) != self.currentPageIndex &&
        [_delegate respondsToSelector:@selector(onePageViewCurrentPageIndexDidChange:)])
    {
        [self enableAnimation];
        [_delegate onePageViewCurrentPageIndexDidChange:self];
        [self disableAnimation];
    }

    _previousPageIndex = currentIndex;
    
}

- (void) updateAllItems
{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = _perspective;
    transform = CATransform3DTranslate(transform, -_viewpointOffset.width, -_viewpointOffset.height, 0.0f);
    
    for (TMOPActionItem *actionItem in _itemsArray) {

        CGFloat relativePosition = self.positionMark - actionItem.pageIndex * [self windowWidth];
        CATransform3D subtempTransform = CATransform3DTranslate(transform, -relativePosition, 0.0f, 0.0f);
        actionItem.contentView.alpha = (actionItem.alphaBlock) ? actionItem.alphaBlock(actionItem.contentView.alpha, relativePosition) : 0;
        actionItem.contentView.layer.transform = (actionItem.actionBlock) ? actionItem.actionBlock(subtempTransform, relativePosition) : subtempTransform;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)viewOrSuperview:(UIView *)view isKindOfClass:(Class)class
{
    if (view == nil || view == _mainContentView)
    {
        return NO;
    }
    else if ([view isKindOfClass:class])
    {
        return YES;
    }
    return [self viewOrSuperview:view.superview isKindOfClass:class];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gesture shouldReceiveTouch:(UITouch *)touch
{
    if ([gesture isKindOfClass:[UITapGestureRecognizer class]])
    {
        //handle tap
        
        if ([self viewOrSuperview:touch.view isKindOfClass:[UIControl class]] ||
            [self viewOrSuperview:touch.view isKindOfClass:[UITableViewCell class]])
        {
            return NO;
        }
    }
    else if ([gesture isKindOfClass:[UIPanGestureRecognizer class]])
    {
        if ([self viewOrSuperview:touch.view isKindOfClass:[UISlider class]] ||
            [self viewOrSuperview:touch.view isKindOfClass:[UISwitch class]] ||
            !_statusFlag.scrollEnabled)
        {
            return NO;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gesture
{
    if ([gesture isKindOfClass:[UIPanGestureRecognizer class]])
    {
        //ignore vertical swipes
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gesture;
        CGPoint translation = [panGesture translationInView:self];

        return fabsf(translation.x) >= fabsf(translation.y);
    }
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)gesTap:(UITapGestureRecognizer *)tapGesture
{

}


- (void)gesPan:(UIPanGestureRecognizer *)panGesture
{
    switch (panGesture.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            NSLog(@"UIGestureRecognizerStateBegan");
            _statusFlag.scrolling = NO;
            _statusFlag.dragging = YES;
            _statusFlag.decelerating = NO;
            _previousLocation = [panGesture translationInView:self].x;
            //[self startAnimation];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            NSLog(@"UIGestureRecognizerStateEnded & UIGestureRecognizerStateCancelled");
            //[self stopAnimation];
            _statusFlag.dragging = NO;
            
            if ([self shouldDecelerate])
            {
                [self startDecelerating];
            }
            
            if (!_statusFlag.decelerating
                && (_statusFlag.paging || ([self scrollOffset] - [self safeScrollOffset]) != 0.0f))
            {
                if (fabsf([self scrollOffset] - self.currentPageIndex) < 0.01f)
                {
                    [self scrollToPageAtIndex:self.currentPageIndex duration:0.01];
                }
                else if ([self shouldScroll])
                {
                    NSInteger direction = (int)(_velocity / fabsf(_velocity));
                    [self scrollToPageAtIndex:self.currentPageIndex + direction animated:YES];
                }
                else
                {
                    [self scrollToPageAtIndex:self.currentPageIndex animated:YES];
                }
            }

            break;
        }
        default:
        {
            NSLog(@"default");
            CGFloat translation = ([panGesture translationInView:self].x) - _previousLocation;
            CGFloat factor = 1.0f;
            _previousLocation = [panGesture translationInView:self].x;
            _velocity = -[panGesture velocityInView:self].x * factor * _scrollSpeed / [self windowWidth];

            _positionMark -= translation;
            NSLog(@"_positionMark = %f", _positionMark);
            [self disableAnimation];
            [self didScroll];
            [self enableAnimation];
        }
    }
}

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
    return (fabsf(_velocity) > 2.0)
    && (fabsf([self scrollOffset] - self.currentPageIndex) > 0.1);
}

- (void)startDecelerating
{
    CGFloat distance = [self decelerationDistance];
    _startOffset = [self scrollOffset];
    _endOffset = _startOffset + distance;
    if (_statusFlag.paging) {
        if (distance > 0.0f) {
            _endOffset = ceilf(_endOffset);
        }
        else {
            _endOffset = floorf(_endOffset);
        }
    }
    
    if (_statusFlag.bounces)
    {
        _endOffset = fmaxf(-_bounceDistance, fminf(_numberOfPage - 1.0f + _bounceDistance, _endOffset));
    }
    else
    {
        _endOffset = fminf(fmaxf(0.0f, _endOffset), (CGFloat)_numberOfPage - 1.0f);
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

#pragma mark - parameter control

- (CGFloat) windowWidth
{
    return self.frame.size.width;
}

- (CGFloat) markPointOfPage:(NSInteger)aPageIndex
{
    return [self windowWidth] * aPageIndex;
}

- (NSInteger) currentPageIndex
{
    return fminf(fmaxf(0.0f, roundf([self scrollOffset])), (CGFloat)_numberOfPage - 1.0f);
}

- (CGFloat) scrollOffset
{
    return _positionMark / [self windowWidth];
}

- (CGFloat) safeScrollOffset
{
    return fminf(fmaxf(0.0f, [self scrollOffset]), (CGFloat)_numberOfPage - 1.0f);
}

- (CGFloat) contentWidth
{
    return _numberOfPage * [self windowWidth];
}

- (void)scrollToPageAtIndex:(NSInteger)index animated:(BOOL)animated
{
    [self scrollToPageAtIndex:index duration:animated ? 0.3: 0];
}

- (void)scrollToPageAtIndex:(NSInteger)index duration:(NSTimeInterval)duration
{
    [self scrollToOffset:index duration:duration];
}

- (void)scrollByOffset:(CGFloat)offset duration:(NSTimeInterval)duration
{
    if (duration > 0.0)
    {
        _statusFlag.decelerating = NO;
        _statusFlag.scrolling = YES;
        _startTime = CACurrentMediaTime();
        _startOffset = [self scrollOffset];
        _scrollDuration = duration;
        _previousPageIndex = roundf([self scrollOffset]);
        _endOffset = _startOffset + offset;

        [self startAnimation];
    }
    else
    {
        _positionMark += offset * [self windowWidth];
    }
}

- (void)scrollToOffset:(CGFloat)offset duration:(NSTimeInterval)duration
{
    [self scrollByOffset:offset - [self scrollOffset] duration:duration];
}



@end
