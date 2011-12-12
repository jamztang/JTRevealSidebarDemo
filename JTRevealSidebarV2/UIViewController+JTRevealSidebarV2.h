/*
 * This file is part of the JTRevealSidebar package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <UIKit/UIKit.h>

typedef enum {
    JTRevealedStateNo,
    JTRevealedStateLeft,
    JTRevealedStateRight,
} JTRevealedState;

@interface UIViewController (JTRevealSidebarV2)

@property (nonatomic, assign) JTRevealedState revealedState;
- (CGAffineTransform)baseTransform;

@end


@interface UINavigationController (JTRevealSidebarV2)
- (UIViewController *)selectedViewController;
@end

