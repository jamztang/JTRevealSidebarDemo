/*
 * This file is part of the JTRevealSidebar package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
@protocol JTTableViewCellTypeLoader;
@protocol JTTableViewDatasourceDelegate;

@interface JTTableViewDatasource : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) id <JTTableViewDatasourceDelegate> delegate;
@property (nonatomic, retain) NSDictionary *sourceInfo;
@property (nonatomic, retain) NSArray *sections;

+ (JTTableViewDatasource *)dynamicDatasourceWithDelegate:(id <JTTableViewDatasourceDelegate>)delegate sourceInfo:(NSDictionary *)sourceInfo;

//- (void)replaceLoader:(id <JTTableViewCellTypeLoader>)loader withObjects:(NSArray *)objects;

- (void)configureSingleSectionWithArray:(NSArray *)objects;

@end



@protocol JTTableViewDatasourceDelegate <NSObject>

- (void)datasource:(JTTableViewDatasource *)datasource
         tableView:(UITableView *)tableView
   didSelectObject:(NSObject *)object;

- (UITableViewCell *)datasource:(JTTableViewDatasource *)datasource
                      tableView:(UITableView *)tableView
                  cellForObject:(NSObject *)object;

- (BOOL)datasourceShouldLoad:(JTTableViewDatasource *)datasource;
- (void)datasource:(JTTableViewDatasource *)datasource sectionsDidChanged:(NSArray *)oldSections;

@end
