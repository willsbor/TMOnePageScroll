/*
 TMOnePageView.h
 
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

#import <UIKit/UIKit.h>
#import "TMOPActionItem.h"

@protocol TMOnePageViewDelegate <NSObject>
@optional
- (void) onePageViewCurrentPageIndexDidChange:(TMOnePageView *)aOnePageView;

@end

@interface TMOnePageView : UIView

@property (nonatomic, weak) IBOutlet id<TMOnePageViewDelegate> delegate;
@property (nonatomic, readonly) CGFloat positionMark;
@property (nonatomic, readonly) CGFloat contentWidth;
@property (nonatomic, readonly) CGFloat windowWidth;
@property (nonatomic) NSUInteger numberOfPage;

- (TMOPActionItem *) actionItemWithView:(UIView *)aContentView AtPage:(NSUInteger)aPageIndex withAction:(TMOPActionBlock)aActionBlock andAlpha:(TMOPAlphaBlock)aAlphaBlock;

- (void) addActionItem:(TMOPActionItem *)aActionItem;
- (NSInteger) currentPageIndex;

- (CGFloat) markPointOfPage:(NSInteger)aPageIndex;

- (void)scrollToPageAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)scrollToPageAtIndex:(NSInteger)index duration:(NSTimeInterval)duration;

@end
