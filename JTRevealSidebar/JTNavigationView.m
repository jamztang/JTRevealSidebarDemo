/*
 * This file is part of the JTRevealSidebar package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */


#import "JTNavigationView.h"

#define DEFAULT_NAVIGATION_BAR_HEIGHT 44

@protocol JTNavigationBarDelegate <NSObject>
@optional
- (void)willPopNavigationItemAnimated:(BOOL)animated;
@end

@interface JTNavigationBar : UINavigationBar

@property (nonatomic, assign) id <JTNavigationBarDelegate> delegate2;
@end

@implementation JTNavigationBar
@synthesize delegate2;

- (UINavigationItem *)popNavigationItemAnimated:(BOOL)animated {
    if ([delegate2 respondsToSelector:@selector(willPopNavigationItemAnimated:)]) {
        [delegate2 willPopNavigationItemAnimated:animated];
    }
    return [super popNavigationItemAnimated:animated];
}

@end

@interface JTNavigationView () <UINavigationBarDelegate, JTNavigationBarDelegate>
@end

@implementation JTNavigationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _views = [[NSMutableArray alloc] init];

        _navigationBar = [[JTNavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), DEFAULT_NAVIGATION_BAR_HEIGHT)];
        [(JTNavigationBar *)_navigationBar setDelegate2:self];
        _navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_navigationBar];
        
        UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:self.title];
        [_navigationBar pushNavigationItem:item animated:NO];
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
        existView.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(self.frame), 0);
    }
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:view.title];
    item.leftBarButtonItem = view.navigationItem.leftBarButtonItem;
    item.rightBarButtonItem = view.navigationItem.rightBarButtonItem;
    [_navigationBar.backItem.leftBarButtonItem setTarget:self];
    [_navigationBar.backItem.leftBarButtonItem setAction:@selector(popViewAnimated:)];
    [_navigationBar pushNavigationItem:item animated:animated];
    _navigationBar.delegate = self;

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
        previousView.transform = CGAffineTransformMakeTranslation(0, 0);
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

- (void)layoutSubviews {
    int yOffset = _navigationViewFlags.isNavigationBarHidden ? 0 : DEFAULT_NAVIGATION_BAR_HEIGHT;
    ((UIView *)[_views lastObject]).frame = CGRectMake(0, yOffset, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - yOffset);
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

//- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
//    [self popViewAnimated:YES];
//    [_navigationBar popNavigationItemAnimated:YES];
//    [_navigationBar ]
//    return NO;
//}

//- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item {
//    [self popViewAnimated:YES shouldPopNavigationItem:NO];
//}

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