/*
 * This file is part of the JTRevealSidebar package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */


#import "JTNavigationView.h"

@implementation JTNavigationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _views = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
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

    if (animated) {
        [UIView commitAnimations];
    }

}

- (UIView *)popViewAnimated:(BOOL)animated {
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

- (UIView *)topView {
    return [_views lastObject];
}

- (NSArray *)views {
    return _views;
}

@end
