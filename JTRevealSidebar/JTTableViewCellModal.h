/*
 * This file is part of the JTRevealSidebar package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>


@protocol JTTableViewCellModal <NSObject>
- (NSString *)title;
@end

@interface JTTableViewCellModal : NSObject <JTTableViewCellModal>
@property (nonatomic, copy) NSString *title;
+ (id)modalWithTitle:(NSString *)title;
@end

@interface NSString (JTTableViewCellModal) <JTTableViewCellModal>
@end


#pragma mark -
@protocol JTTableViewCellModalSimpleType <NSObject, JTTableViewCellModal>
- (NSInteger)type;
@end

@interface JTTableViewCellModalSimpleType : JTTableViewCellModal <JTTableViewCellModalSimpleType>
@property (nonatomic, assign) NSInteger type;
+ (id)modalWithTitle:(NSString *)title type:(NSInteger)type;
@end


#pragma mark -

@protocol JTTableViewCellModalLoadingIndicator <NSObject>
@end

@interface JTTableViewCellModalLoadingIndicator : NSObject <JTTableViewCellModalLoadingIndicator>
+ (id)modal;
@end


#pragma mark -

@protocol JTTableViewCellModalCustom <NSObject>
- (NSDictionary *)info;
@end

@interface JTTableViewCellModalCustom : NSObject <JTTableViewCellModalCustom>
@property (nonatomic, retain) NSDictionary *info;
+ (id)modalWithInfo:(NSDictionary *)info;
@end