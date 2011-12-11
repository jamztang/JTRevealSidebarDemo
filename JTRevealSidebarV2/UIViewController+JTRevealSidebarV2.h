//
//  UINavigationController+JTRevealSidebarV2.h
//  JTRevealSidebarDemo
//
//  Created by James Apple Tang on 8/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

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

