//
//  LocationSearchResultsViewController.h
//  SnapExt
//
//  Created by Leonardos Jr. on 11.04.19.
//
#import "LocationPicker-Frameworks.h"
#import "CustomLocation.h"


@interface LocationSearchResultsViewController : UITableViewController

//@property (nonatomic) _Bool isShowingHistory;
//@property (nonatomic, copy) NSString * _Nullable searchHistoryLabel;
@property (nonatomic, strong) NSArray<CustomLocation*> * _Nullable locations;
@property (nonatomic, copy) void (^ _Nullable onSelectLocation)(CustomLocation * location);


- (void)viewDidLoad;
- (NSString * _Nullable)tableView:(UITableView * _Nonnull)tableView titleForHeaderInSection:(NSInteger)section;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)tableView:(UITableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;

@end
