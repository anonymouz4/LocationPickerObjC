//
//  LocationSearchResultsViewController.m
//  SnapExt
//
//  Created by Leonardos Jr. on 11.04.19.
//

#import "LocationSearchResultsViewController.h"

@implementation LocationSearchResultsViewController


- (void)viewDidLoad {
	[super viewDidLoad];
	self.extendedLayoutIncludesOpaqueBars = true;
}



- (NSString * _Nullable)tableView:(UITableView * _Nonnull)tableView titleForHeaderInSection:(NSInteger)section {
	return nil;//self.isShowingHistory ? self.searchHistoryLabel : nil;
}

- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section {
	return self.locations.count;
}

- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath {

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell"];
	if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"LocationCell"];
	
	CustomLocation *location = self.locations[indexPath.row];
	cell.textLabel.text = location.name;
	cell.detailTextLabel.text = location.address;
	
	return cell;
}

- (void)tableView:(UITableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath {
	self.onSelectLocation(self.locations[indexPath.row]);
}


@end
