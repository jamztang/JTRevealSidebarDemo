/*
 * This file is part of the JTRevealSidebar package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

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
