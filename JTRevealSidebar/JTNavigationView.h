/*
 * This file is part of the JTRevealSidebar package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */


#import <UIKit/UIKit.h>

@interface JTNavigationView : UIView {
    NSMutableArray *_views;
}

- (void)pushView:(UIView *)view animated:(BOOL)animated;
- (UIView *)popViewAnimated:(BOOL)animated;
- (UIView *)topView;
- (NSArray *)views;

@end
