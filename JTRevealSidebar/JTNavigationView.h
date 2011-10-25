/*
 * This file is part of the JTRevealSidebar package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */


#import <UIKit/UIKit.h>
#import "JTNavigationBar.h"

typedef enum {
    JTNavigationViewAnimationStylePush,
    JTNavigationViewAnimationStyleCoverUp,
} JTNavigationViewAnimationStyle;

@interface JTNavigationView : UIView <JTNavigationBarDelegate> {
    NSMutableArray *_views;
    JTNavigationBar *_navigationBar;
    UINavigationItem *_navigationItem;
    UIView           *_rootView;
    
    JTNavigationViewAnimationStyle _animationStyle;
    struct {
        unsigned int isNavigationBarHidden:1;
    } _navigationViewFlags;
}

// Setting the root view will pop all views in the stack
@property (nonatomic, retain) UIView *rootView;

- (id)initWithFrame:(CGRect)frame animationStyle:(JTNavigationViewAnimationStyle)style;

- (void)pushView:(UIView *)view animated:(BOOL)animated;
- (UIView *)popViewAnimated:(BOOL)animated;
- (UIView *)topView;
- (NSArray *)views;

// Navigation Bar
- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;        // Default NO

@end



@interface UIView (UINavigationControllerItem)

@property(nonatomic, retain) UINavigationItem *navigationItem;
@property (nonatomic, copy) NSString *title;

@end