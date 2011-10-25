/*
 * This file is part of the JTRevealSidebar package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */


#import "JTNavigationView.h"

#define DEFAULT_NAVIGATION_BAR_HEIGHT 44


@interface JTNavigationView () <JTNavigationBarDelegate>
@end

@implementation JTNavigationView

@synthesize rootView = _rootView;

- (id)initWithFrame:(CGRect)frame {
    self = [self initWithFrame:frame animationStyle:JTNavigationViewAnimationStylePush];
    return self;
}

- (id)initWithFrame:(CGRect)frame animationStyle:(JTNavigationViewAnimationStyle)style {
    self = [super initWithFrame:frame];
    if (self) {
        _views = [[NSMutableArray alloc] init];
        _animationStyle = style;

        // We will need to have 
        _navigationBar = [[JTNavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), DEFAULT_NAVIGATION_BAR_HEIGHT)];
        _navigationBar.delegate = self;
        _navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_navigationBar];
        
        UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:self.title];
        [_navigationBar pushNavigationItem:item animated:NO];
        _navigationBar.delegate = self;
        _navigationItem = item;
        [item release];
        
        _navigationViewFlags.isNavigationBarHidden = NO;
    }
    return self;
}

- (void)dealloc {
    [_navigationBar release];
    [_views release];
    [super dealloc];
}

#pragma mark Instance method

- (void)pushView:(UIView *)view animated:(BOOL)animated {
    UIView *existView = [_views lastObject];
    view.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(self.frame), 0);
    [self addSubview:view];
    [_views addObject:view];

    if (animated) {
        [UIView beginAnimations:@"pushView" context:view];
    }

    view.transform = CGAffineTransformMakeTranslation(0, 0);
    if (existView) {
        if (_animationStyle == JTNavigationViewAnimationStylePush) {
            existView.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(self.frame), 0);
        }
    }
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:view.title];
    item.leftBarButtonItem = view.navigationItem.leftBarButtonItem;
    item.rightBarButtonItem = view.navigationItem.rightBarButtonItem;
    [_navigationBar pushNavigationItem:item animated:animated];

    [item release];

    if (animated) {
        [UIView commitAnimations];
    }

    [self setNeedsLayout];
}


- (UIView *)popViewAnimated:(BOOL)animated shouldPopNavigationItem:(BOOL)popNavigationItem {
    UIView *view = [_views lastObject];
    [_views removeLastObject];
    UIView *previousView = [_views lastObject];

    if (animated) {
        [UIView beginAnimations:@"popView" context:view];
    }

    view.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(self.frame), 0);
    if (previousView) {
        if (_animationStyle == JTNavigationViewAnimationStylePush) {
            previousView.transform = CGAffineTransformMakeTranslation(0, 0);
        }
    }

    if (animated) {
        [UIView commitAnimations];
    }

    [view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
    return view;
}

- (UIView *)popViewAnimated:(BOOL)animated {
    return [self popViewAnimated:animated shouldPopNavigationItem:YES];
}

- (UIView *)topView {
    return [_views lastObject];
}

- (NSArray *)views {
    return _views;
}

- (void)setRootView:(UIView *)rootView {
    [_rootView removeFromSuperview], [_rootView autorelease], _rootView = nil;
    _rootView = [rootView retain];

    for (UIView *view in _views) {
        [self popViewAnimated:NO];
    }
    [_navigationBar setItems:[NSArray arrayWithObject:_navigationItem]];

    _navigationItem.title = _rootView.title;
    // Insert root view to be the bottom most index.
    [self insertSubview:_rootView atIndex:0];
}

// Auto stretching the views to fit the visible bounds
- (void)layoutSubviews {
    int yOffset = _navigationViewFlags.isNavigationBarHidden ? 0 : DEFAULT_NAVIGATION_BAR_HEIGHT;
    CGRect bounds = CGRectMake(0, yOffset, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - yOffset);
    _rootView.frame = bounds;
    ((UIView *)[_views lastObject]).frame = bounds;
}

// Navigation Bar

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    if (_navigationViewFlags.isNavigationBarHidden != hidden) {
        // Only change state when the state is different
        
        if (animated) {
            [UIView beginAnimations:@"" context:nil];
        }
        _navigationBar.transform = CGAffineTransformMakeTranslation(0, hidden ? -DEFAULT_NAVIGATION_BAR_HEIGHT : 0);
        
        if (animated) {
            [UIView commitAnimations];
        }
        
        _navigationViewFlags.isNavigationBarHidden = hidden;
    }
}

- (UINavigationItem *)navigationItem {
    return _navigationItem;
}

#pragma mark JTNavigationBarDelegate

- (void)willPopNavigationItemAnimated:(BOOL)animated {
    [self popViewAnimated:animated shouldPopNavigationItem:NO];
}

@end


#import <objc/runtime.h>

@implementation UIView (UINavigationControllerItem)

static char *navigationItemKey;

- (UINavigationItem *)navigationItem {
    UINavigationItem *item = objc_getAssociatedObject(self, &navigationItemKey);
    return item;
}

- (void)setNavigationItem:(UINavigationItem *)navigationItem {
    objc_setAssociatedObject(self, &navigationItemKey, navigationItem, OBJC_ASSOCIATION_RETAIN);
}

static char *titleKey;

- (NSString *)title {
    NSString *title = objc_getAssociatedObject(self, &titleKey);
    return title;
}

- (void)setTitle:(NSString *)title {
    objc_setAssociatedObject(self, &titleKey, title, OBJC_ASSOCIATION_COPY);
}

@end