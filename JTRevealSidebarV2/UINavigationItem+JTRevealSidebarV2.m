/*
 * This file is part of the JTRevealSidebar package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UINavigationItem+JTRevealSidebarV2.h"
#import <objc/runtime.h>

@implementation UINavigationItem (JTRevealSidebarV2)

static char *revealSidebarDelegateKey;

- (void)setRevealSidebarDelegate:(id<JTRevealSidebarV2Delegate>)revealSidebarDelegate {
    objc_setAssociatedObject(self, &revealSidebarDelegateKey, revealSidebarDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id <JTRevealSidebarV2Delegate>)revealSidebarDelegate {
    return (id <JTRevealSidebarV2Delegate>)objc_getAssociatedObject(self, &revealSidebarDelegateKey);
}

@end
