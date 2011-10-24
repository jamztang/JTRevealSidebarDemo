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
    UINavigationBar *_navigationBar;
    UINavigationItem *_navigationItem;
    
    struct {
        unsigned int isNavigationBarHidden:1;
    } _navigationViewFlags;
}


- (void)pushView:(UIView *)view animated:(BOOL)animated;
- (UIView *)popViewAnimated:(BOOL)animated;
- (UIView *)topView;
- (NSArray *)views;

// Navigation Bar
- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;        // Default NO

@end



@interface UIView (UINavigationControllerItem)

@property(nonatomic, retain) UINavigationItem *navigationItem; // Created on-demand so that a view controller may customize its navigation appearance.

@property (nonatomic, copy) NSString *title;

@end