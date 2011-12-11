//
//  UINavigationItem+JTRevealSidebarV2.m
//  JTRevealSidebarDemo
//
//  Created by James Apple Tang on 8/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

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
