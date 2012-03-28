/*
 * This file is part of the JTRevealSidebar package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>

@protocol JTRevealSidebarV2Delegate <NSObject>

@optional
- (UIView *)viewForLeftSidebar;
- (UIView *)viewForRightSidebar;
- (void)willChangeRevealedStateForViewController:(UIViewController *)viewController;
- (void)didChangeRevealedStateForViewController:(UIViewController *)viewController;

@end
