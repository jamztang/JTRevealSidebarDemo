/*
 * This file is part of the JTRevealSidebar package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */


#import <UIKit/UIKit.h>

@interface JTRevealSidebarView : UIView {
    struct {
        unsigned int isShowing:1;
    } _state;
}

@property (nonatomic, retain) UIView *sidebarView;
@property (nonatomic, retain) UIView *contentView;

- (void)revealSidebar:(BOOL)shouldReveal;
- (BOOL)isSidebarShowing;

+ (JTRevealSidebarView *)defaultViewWithFrame:(CGRect)frame;

@end
