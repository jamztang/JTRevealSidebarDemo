/*
 * This file is part of the JTRevealSidebar package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "JTNavigationBar.h"

@implementation JTNavigationBar
@synthesize delegate;

- (UINavigationItem *)popNavigationItemAnimated:(BOOL)animated {
    if ([self.delegate respondsToSelector:@selector(willPopNavigationItemAnimated:)]) {
        [self.delegate willPopNavigationItemAnimated:animated];
    }
    return [super popNavigationItemAnimated:animated];
}

- (void)dealloc {
    self.delegate = nil;
    [super dealloc];
}

@end