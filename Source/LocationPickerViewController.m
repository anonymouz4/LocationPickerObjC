//
//  LocationPickerViewController.m
//  SnapExt
//
//  Created by Leonardos Jr. on 12.04.19.
//

#import "LocationPickerViewController.h"
#import "SCGeneral.h"


@implementation CurrentLocationListener
+ (CurrentLocationListener *)initWithOnce:(bool)once action:(ActionBlock)action {
	CurrentLocationListener *listener = [CurrentLocationListener new];
	listener.once = once;
	listener.action = action;
	return listener;
}
@end

@implementation LocationPickerViewController

+ (NSString *)SearchTermKey {
	return @"SearchTermKey";
}

- (id)init {
	self = [super init];
	
	//Set Defaults
	self.showCurrentLocationButton = YES;
	self.showCurrentLocationInitially = YES;
	self.selectCurrentLocationInitially = NO;
	self.useCurrentLocationAsHint = NO;
	self.presentedInitialLocation = NO;
	
	self.searchBarPlaceholder = @"Search or enter an address";
	//self.searchHistoryLabel = @"Search History";
	self.selectButtonTitle = @"Select";
	
	self.results = [LocationSearchResultsViewController new];
	__weak typeof(self) weakSelf = self;
	self.results.onSelectLocation = ^(CustomLocation *location) {
		[weakSelf selectedLocation:location];
	};
	//self.results.searchHistoryLabel = self.searchHistoryLabel;
	
	self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.results];
	self.searchController.searchResultsUpdater = self;
	self.searchController.hidesNavigationBarDuringPresentation = false;
	
	self.resultRegionDistance = 600;
	
	self.currentLocationButtonBackground = (self.navigationController.navigationBar && self.navigationController.navigationBar.barTintColor) ? self.navigationController.navigationBar.barTintColor : UIColor.whiteColor;
	
	self.searchBarStyle =UISearchBarStyleMinimal;
	self.statusBarStyle = UIStatusBarStyleDefault;
	
	self.mapType = MKMapTypeStandard;
	
	self.currentLocationListeners = [NSMutableArray new];
	
	
	return self;
}

- (UISearchBar*)searchBar {
	UISearchBar *searchBar = self.searchController.searchBar;
	searchBar.searchBarStyle = self.searchBarStyle;
	searchBar.placeholder = self.searchBarPlaceholder;
	return searchBar;
}


- (void)close {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.locationManager.delegate = self;
	self.mapView.delegate = self;
	self.searchBar.delegate = self;

	
	UILongPressGestureRecognizer *locationSelectGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addLocation:)];
	//locationSelectGesture.delegate = self;
	
	[self.mapView addGestureRecognizer:locationSelectGesture];
	
	
	UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close)];
	
	bool ios11Available = false;
	if (@available(iOS 11.0, *)) ios11Available = true;
	
	if (ios11Available && self.navigationController && self.navigationController.viewControllers.count > 1) {
		self.navigationItem.searchController = self.searchController;
	} else {
		self.navigationItem.titleView = self.searchBar;
		self.navigationItem.rightBarButtonItem = done;
	}

	self.definesPresentationContext = true;
	
	//MapType Segmented Control
		NSArray *itemArray = @[@"Standard", @"Satellite", @"Hybrid", @"SatelliteFlyover", @"HybridFlyover" , @"MutedStandard"];
		UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
		segmentedControl.frame = CGRectMake(self.mapView.safeSize.height* -0.375 + 25/2 + 10, self.mapView.safeSize.height/2, self.mapView.safeSize.height * 0.75, 25);
		[segmentedControl addTarget:self action:@selector(changeMapTypeAction:) forControlEvents: UIControlEventValueChanged];
		segmentedControl.selectedSegmentIndex = 0;
	
		UIFont *font = [UIFont boldSystemFontOfSize:10.0f];
		NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
		[segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
	
		segmentedControl.backgroundColor = UIColor.whiteColor;
		segmentedControl.layer.cornerRadius = 4.0;
		segmentedControl.clipsToBounds = YES;
	
		//Make Vertical
		segmentedControl.transform = CGAffineTransformMakeRotation(-M_PI / 2.0);
	
		[self.mapView addSubview:segmentedControl];

	
	// User location
	self.mapView.userTrackingMode = MKUserTrackingModeNone;
	self.mapView.showsUserLocation = self.showCurrentLocationInitially || self.showCurrentLocationButton;

	if (self.useCurrentLocationAsHint) {
		[self getCurrentLocation];
	}
}
- (void)changeMapTypeAction:(UISegmentedControl *)segment {
	self.mapView.mapType = segment.selectedSegmentIndex;
}

- (void)loadView {
	
	self.mapView = [[MKMapView alloc] initWithFrame:UIScreen.mainScreen.bounds];
	self.mapView.mapType = self.mapType;
	self.view = self.mapView;
	
	if (self.showCurrentLocationButton) {
		UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
		button.layer.masksToBounds = true;
		button.layer.cornerRadius = 16;
		
		[button setImage:[UIImage imageForResourcePath:@"LocationPicker.bundle/geolocation" ofType:@"png"] forState:UIControlStateNormal];
		
		[button addTarget:self action:@selector(currentLocationPressed) forControlEvents:UIControlEventTouchUpInside];

		[self.view addSubview:button];
		self.locationButton = button;
	}
	
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return self.statusBarStyle;
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	if (self.locationButton) {
		CGRect newFrame = self.locationButton.frame;
		newFrame.origin = CGPointMake(self.view.frame.size.width - self.locationButton.frame.size.width - 16,
									self.view.frame.size.height - self.locationButton.frame.size.height - 20);
		
		self.locationButton.frame = newFrame;
	}
	
	if (!self.presentedInitialLocation) {
		[self setInitialLocation];
		self.presentedInitialLocation = YES;
	}
}

- (void)setInitialLocation {
	if (self.location) {
		[self showCoordinates:self.location.coordinate animated:NO];
		[self selectLocation:self.location.location initialLocation:YES];
		return;
	} else if (self.showCurrentLocationInitially || self.selectCurrentLocationInitially) {
		if (self.selectCurrentLocationInitially) {
			__weak typeof(self) weakSelf = self;
			CurrentLocationListener *listener = [CurrentLocationListener initWithOnce:YES action:^(CLLocation * location) {
				if (self.location == nil)
					[weakSelf selectLocation:location initialLocation:YES];
			}];
			[self.currentLocationListeners addObject:listener];
		}
		[self showCurrentLocation:NO];
	}
}

- (void)getCurrentLocation {
	[self.locationManager requestWhenInUseAuthorization];
	[self.locationManager startUpdatingLocation];
}

- (void)currentLocationPressed {
	[self showCurrentLocation:YES];
}

- (void)showCurrentLocation:(bool)animated {
	__weak typeof(self) weakSelf = self;
	CurrentLocationListener *listener = [CurrentLocationListener initWithOnce:YES action:^(CLLocation * location) {
		[weakSelf showCoordinates:location.coordinate animated:animated];
	}];
	[self.currentLocationListeners addObject:listener];
}

//- (void)updateAnnotation {
//	[self.mapView removeAnnotations:self.mapView.annotations];
//	if (self.location) {
//		[self.mapView addAnnotation:self.location];
//
//		[self.mapView selectAnnotation:self.location animated:YES];
//	}
//}

- (void)showCoordinates:(CLLocationCoordinate2D)coordinate animated:(bool)animated {
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, self.resultRegionDistance, self.resultRegionDistance);
	[self.mapView setRegion:region];
}

- (void)selectLocation:(CLLocation *)location initialLocation:(_Bool)initialLocation {

	
	for (id<MKAnnotation> annotation in self.mapView.annotations)
		if ([annotation isMemberOfClass:MKPointAnnotation.class] && ![annotation.title isEqual: @"Saved Location"])
			[self.mapView removeAnnotation:annotation];
		
	
	
	
	MKPointAnnotation *annotation = [MKPointAnnotation new];
	annotation.coordinate = location.coordinate;
	annotation.title = initialLocation ? @"Saved Location" : @"Marked Location";
	
	[self.mapView addAnnotation:annotation];
	
	[self.geocoder cancelGeocode];

	[self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
		
		if (error && error.code != 10) {
			
			// ignore cancelGeocode errors
			// show error and remove annotation
			UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
			
			[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
			
			[self presentViewController:alert animated:YES completion:^{
				[self.mapView removeAnnotation:annotation];
			}];
		} else if (placemarks.firstObject) {
			// get POI name from placemark if any
			NSString *name = placemarks.firstObject.areasOfInterest.firstObject;
			
			// pass user selected location too
			self.location = [[CustomLocation alloc] initWithName:name location:location placemark:placemarks.firstObject];
		}
	}];
}

@end

@implementation LocationPickerViewController (CLLocationManagerDelegate)

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {

	if (!self.currentLocationListeners || !self.currentLocationListeners.count) return;
	
	for (CurrentLocationListener *listener in self.currentLocationListeners)
		listener.action(userLocation.location);
	
	
	NSMutableArray<CurrentLocationListener*> * filteredLocationListeners = [NSMutableArray new];
	for (CurrentLocationListener *listener in self.currentLocationListeners)
		if (!listener.once) [filteredLocationListeners addObject:listener];
	self.currentLocationListeners = filteredLocationListeners;
	
	[self.locationManager stopUpdatingLocation];
}

@end

// MARK: Searching

@implementation LocationPickerViewController (UISearchResultsUpdating)

- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController {
	if (!searchController.searchBar.text) return;
	
	[self.searchTimer invalidate];
	
	
	
	NSString *searchTerm = [searchController.searchBar.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
	
	if (!searchTerm.length) {
		[self showItemsForSearchResult:nil];
		
		//self.results.locations = self.historyManager.history;
		//self.results.isShowingHistory = YES;
		//[self.results.tableView reloadData];
	} else {
		// clear old results
		[self showItemsForSearchResult:nil];
		
		self.searchTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(searchFromTimer:) userInfo:@{LocationPickerViewController.SearchTermKey: searchTerm} repeats:NO];
	}
}

- (void)searchFromTimer:(NSTimer*_Null_unspecified)timer {
	
	if (!timer.userInfo || !timer.userInfo[LocationPickerViewController.SearchTermKey]) return;
	
	
	
	MKLocalSearchRequest *request = [MKLocalSearchRequest new];
	request.naturalLanguageQuery = timer.userInfo[LocationPickerViewController.SearchTermKey];
	
	
	if (self.locationManager.location && self.useCurrentLocationAsHint) {
		request.region = MKCoordinateRegionMake(self.locationManager.location.coordinate, MKCoordinateSpanMake(2, 2));
	}

	[self.localSearch cancel];
	
	self.localSearch = [[MKLocalSearch alloc] initWithRequest:request];
	
	__weak typeof(self) weakSelf = self;
	[self.localSearch startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
		[weakSelf showItemsForSearchResult:response];
	}];
}

- (void)showItemsForSearchResult:(MKLocalSearchResponse*_Nullable)searchResult {
	
	NSMutableArray *newLocations = [NSMutableArray new];
	
	for (MKMapItem *item in searchResult.mapItems)
		[newLocations addObject: [[CustomLocation alloc] initWithName:item.name location:nil placemark:item.placemark]];

	self.results.locations = !searchResult.mapItems ? @[] : newLocations;

	//self.results.isShowingHistory = NO;
	
	[self.results.tableView reloadData];
	
}

- (void)selectedLocation:(CustomLocation*)location {
	
	// dismiss search results
//	__weak typeof(self) weakSelf = self;
	[self.results dismissViewControllerAnimated:YES completion:^{
		// set location, this also adds annotation
		self.location = location;
		[self showCoordinates:location.coordinate animated:YES];
		[self selectLocation:location.location initialLocation:NO];
		//self.historyManager.addToHistory(location)
	}];
}

@end




@implementation LocationPickerViewController (addLocation)

- (void)addLocation:(UIGestureRecognizer*)gestureRecognizer {
	
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
		
		CGPoint point = [gestureRecognizer locationInView:self.mapView];
		
		CLLocationCoordinate2D coordinates = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
		
//		[SCGeneral alertWithInfo:[NSString stringWithFormat:@"lati:%f-long:%f",(double)coordinates.latitude,(double)coordinates.longitude] withVC:self];

		CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinates.latitude longitude:coordinates.longitude];
		
		// clean location, cleans out old annotation too
		self.location = nil;
		[self selectLocation:location initialLocation:NO];
	}
}

@end



@implementation LocationPickerViewController (MKMapViewDelegate)

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {

//	if ([annotation isMemberOfClass:MKUserLocation.class]) return nil;


//	MKPointAnnotation *pin2 = [MKPointAnnotation new];
//	pin2.coordinate = annotation.coordinate;
	
	
	if ([annotation isMemberOfClass:MKPointAnnotation.class]) {
		
		if ([annotation.title isEqual: @"Saved Location"]) {

			MKPinAnnotationView *pin = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"savedAnnotation"];
			if (!pin) {
				pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"savedAnnotation"];
				pin.pinTintColor = UIColor.redColor;

				pin.animatesDrop = NO;
				pin.rightCalloutAccessoryView = self.selectLocationButton;
				pin.canShowCallout = YES;
			} else pin.annotation = annotation;

//			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//				[self.mapView selectAnnotation:annotation animated:YES];
//			});

			return pin;
		} else {
		
			MKPinAnnotationView *pin = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"markedAnnotation"];
			if (!pin) {
				pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"markedAnnotation"];
				pin.pinTintColor = UIColor.greenColor;
				
				pin.animatesDrop = YES;
				LocationSelectionButton *button = self.selectLocationButton;
				button.location = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
				pin.rightCalloutAccessoryView = button;
				pin.canShowCallout = YES;
			} else pin.annotation = annotation;
			
			return pin;
		}
		
		
	}
	return nil;
}

- (void)didChooseLocation:(LocationSelectionButton*)sender {
	[SCGeneral setLocation:sender.location];
	[self close];
}

- (LocationSelectionButton*)selectLocationButton {

	LocationSelectionButton *button = [[LocationSelectionButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
	[button addTarget:self action:@selector(didChooseLocation:) forControlEvents:UIControlEventTouchUpInside];
	[button setTitle:self.selectButtonTitle forState:UIControlStateNormal];

	if (button.titleLabel) {
		CGFloat width = [button.titleLabel textRectForBounds:CGRectMake(0, 0, 70, 30) limitedToNumberOfLines:1].size.width;
		
//		CGRect frameRect = button.frame;
//		frameRect.size.width = width;
//		button.frame = frameRect;
		
		button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, width, 30.0);
	}
	[button setTitleColor:self.view.tintColor forState:UIControlStateNormal];
	return button;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
//	self.completion(self.location);

//	if (self.navigationController && self.navigationController.viewControllers.count > 1) {
//		[self.navigationController popViewControllerAnimated:YES];
//	} else {
//		[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//	}
}



- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
	
	//dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self.mapView selectAnnotation:views.lastObject.annotation animated:YES];
	//});
	
	for (MKAnnotationView *view in views)
		if ([view.annotation isMemberOfClass:MKUserLocation.class]) {
			view.rightCalloutAccessoryView = self.selectLocationButton;
			view.canShowCallout = YES;
		}
}


@end



@implementation LocationPickerViewController (UIGestureRecognizerDelegate)

- (bool)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWith:(UIGestureRecognizer *)otherGestureRecognizer {
	return YES;
}

@end

@implementation LocationPickerViewController (UISearchBarDelegate)

- (void)searchBarTextDidBeginEditing:(UISearchBar*_Null_unspecified)searchBar {
	// dirty hack to show history when there is no text in search bar
	// to be replaced later (hopefully)
	if (searchBar.text && !searchBar.text.length) {
		searchBar.text = @" ";
	}
}
- (void)searchBar:(UISearchBar*_Null_unspecified)searchBar textDidChange:(NSString*_Null_unspecified)searchText {
	// remove location if user presses clear or removes text
	if (!searchText.length) {
		self.location = nil;
		searchBar.text = @" ";
	}
	
}

@end


