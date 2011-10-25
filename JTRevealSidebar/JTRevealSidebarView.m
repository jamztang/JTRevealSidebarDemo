/*
 * This file is part of the JTRevealSidebar package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "JTRevealSidebarView.h"
#import "JTNavigationView.h"

@implementation JTRevealSidebarView

@synthesize sidebarView, contentView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _state.isShowing = 0;
    }
    return self;
}

#pragma mark Properties

- (void)setContentView:(JTNavigationView *)aContentView {
    [contentView removeFromSuperview];
    [contentView autorelease], contentView = nil;
    contentView = [aContentView retain];
    [self addSubview:aContentView];
}

- (void)setSidebarView:(JTNavigationView *)aSidebarView {
    [sidebarView removeFromSuperview];
    [sidebarView autorelease], sidebarView = nil;
    sidebarView = [aSidebarView retain];
    [self insertSubview:sidebarView atIndex:0];
}

- (BOOL)isSidebarShowing {
    return _state.isShowing == 1 ? YES : NO;
}

#pragma mark Instance method

- (void)revealSidebar:(BOOL)shouldReveal {
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.3];
    if (shouldReveal) {
        contentView.frame = CGRectOffset(contentView.bounds, CGRectGetWidth(sidebarView.frame), 0);
    } else {
        contentView.frame = contentView.bounds;
    }
    [UIView commitAnimations];
    _state.isShowing = shouldReveal ? 1 : 0;
}

#pragma mark Class method

+ (JTRevealSidebarView *)defaultViewWithFrame:(CGRect)frame {
    JTRevealSidebarView *revealView = [[JTRevealSidebarView alloc] initWithFrame:frame];
    revealView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    JTNavigationView *sidebarView = [[[JTNavigationView alloc] initWithFrame:CGRectMake(0, 0, 270, CGRectGetHeight(frame))] autorelease];
    {
        [sidebarView setNavigationBarHidden:YES animated:NO];
        sidebarView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
        revealView.sidebarView = sidebarView;
    }
    
    JTNavigationView *contentView = [[[JTNavigationView alloc] initWithFrame:(CGRect){CGPointZero, frame.size} animationStyle:JTNavigationViewAnimationStyleCoverUp] autorelease];
    {
        contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        contentView.backgroundColor = [UIColor lightGrayColor];
        revealView.contentView = contentView;
    }

    return [revealView autorelease];
}

@end
