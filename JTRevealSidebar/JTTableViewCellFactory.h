//
//  JTTableViewCellFactory.h
//  JTRevealSidebarDemo
//
//  Created by James Tang on 15/10/2011.
//  Copyright (c) 2011 CUHK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTTableViewCellFactory : NSObject
+ (UITableViewCell *)loaderCellWithIdentifier:(NSString *)reuseIdentifier;
@end
