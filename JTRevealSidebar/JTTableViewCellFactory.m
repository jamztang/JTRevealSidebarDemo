//
//  JTTableViewCellFactory.m
//  JTRevealSidebarDemo
//
//  Created by James Tang on 15/10/2011.
//  Copyright (c) 2011 CUHK. All rights reserved.
//

#import "JTTableViewCellFactory.h"

@implementation JTTableViewCellFactory

+ (UITableViewCell *)loaderCellWithIdentifier:(NSString *)reuseIdentifier {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:reuseIdentifier];
    UIActivityIndicatorView *activityIndicator = [[[UIActivityIndicatorView alloc] 
                                                   initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    [activityIndicator hidesWhenStopped];
    activityIndicator.frame = cell.bounds;
    activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    activityIndicator.contentMode = UIViewContentModeCenter;
    activityIndicator.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    return cell;
}
@end
