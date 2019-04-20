//
//  LocationPickerViewController.h
//  SnapExt
//
//  Created by Leonardos Jr. on 12.04.19.
//

#import "LocationPicker-Frameworks.h"

#import "LocationSearchResultsViewController.h"
#import "CustomLocation.h"
#import "UIImage+LocationPicker.h"
#import "LocationSelectionButton.h"



typedef void(^ _Null_unspecified ActionBlock)(CLLocation * location);

@interface CurrentLocationListener : NSObject
	+ (CurrentLocationListener*_Nonnull)initWithOnce:(_Bool)once action:(ActionBlock)action;
	@property _Bool * once;
	@property ActionBlock action;//void(^ _Null_unspecified action)(CLLocation * _Null_unspecified location);
@end


@interface LocationPickerViewController : UIViewController

//struct CurrentLocationListener {
//	_Bool * _Null_unspecified once;
//	void(^ _Null_unspecified action)(CLLocation * _Null_unspecified location);
//};
//typedef struct CurrentLocationListener CurrentLocationListener;

@property (nonatomic) CustomLocation * location;


@property (nonatomic) _Bool * showCurrentLocationButton;
@property (nonatomic) _Bool * showCurrentLocationInitially;
@property (nonatomic) _Bool * selectCurrentLocationInitially;
@property (nonatomic) _Bool * useCurrentLocationAsHint;
@property (nonatomic) _Bool * presentedInitialLocation;



@property (nonatomic, copy) NSString * _Null_unspecified searchBarPlaceholder;
@property (nonatomic, copy) NSString * _Null_unspecified searchHistoryLabel;
@property (nonatomic, copy) NSString * _Null_unspecified selectButtonTitle;


@property (nonatomic) UISearchBarStyle searchBarStyle;
@property (nonatomic) UIStatusBarStyle statusBarStyle;


@property (nonatomic) NSMutableArray<CurrentLocationListener*> * currentLocationListeners;


@property (nonatomic) CLLocationManager * _Null_unspecified locationManager;


@property (nonatomic) CLGeocoder * _Null_unspecified geocoder;

@property (nonatomic) MKLocalSearch * _Nullable localSearch;

@property (nonatomic) NSTimer * _Nullable searchTimer;

@property (nonatomic) MKMapView * _Nonnull mapView;

@property (nonatomic) UIButton * _Nullable locationButton;

@property (nonatomic, copy) void (^ _Nullable completion)(CustomLocation * _Nullable location);

@property (nonatomic) CLLocationDistance resultRegionDistance;

@property (nonatomic) UIColor * _Null_unspecified currentLocationButtonBackground;


@property (class, readonly,nonatomic) NSString * SearchTermKey;


@property (nonatomic) MKMapType mapType;

//@property (nonatomic) Location * _Nullable location;

@property (nonatomic) UISearchController * _Null_unspecified searchController;

@property (nonatomic) LocationSearchResultsViewController * _Null_unspecified results;

@property (nonatomic) UISearchBar * _Null_unspecified searchBar;




	//internal struct CurrentLocationListener {
	//
	//	internal let once: Bool
	//
	//	internal let action: (CLLocation) -> ()
	//}
	//
	//public var completion: ((Location?) -> ())?
	//
	//public var resultRegionDistance: CLLocationDistance
	//
	///// default: true
	//public var showCurrentLocationButton: Bool
	//
	///// default: true
	//public var showCurrentLocationInitially: Bool
	//
	///// default: false
	///// Select current location only if `location` property is nil.
	//public var selectCurrentLocationInitially: Bool
	//
	///// see `region` property of `MKLocalSearchRequest`
	///// default: false
	//public var useCurrentLocationAsHint: Bool
	//
	///// default: "Search or enter an address"
	//public var searchBarPlaceholder: String
	//
	///// default: "Search History"
	//public var searchHistoryLabel: String
	//
	///// default: "Select"
	//public var selectButtonTitle: String
	//
				//lazy public var currentLocationButtonBackground: UIColor { get set }
				//
	/// default: .Minimal
	//public var searchBarStyle: UISearchBar.Style
	//
	///// default: .Default
	//public var statusBarStyle: UIStatusBarStyle
	//
	//public var mapType: MKMapType { get set }
	//
	//public var location: SnapExt.Location? { get set }
	//
	//internal static let SearchTermKey: String
	//
//internal let historyManager: SnapExt.SearchHistoryManager
	//
	//internal let locationManager: CLLocationManager
	//
	//internal let geocoder: CLGeocoder
	//
	//internal var localSearch: MKLocalSearch?
	//
	//internal var searchTimer: Timer?
	//
	//internal var currentLocationListeners: [CurrentLocationListener]
	//
	//internal var mapView: MKMapView!
	//
	//internal var locationButton: UIButton?

	//lazy internal var results: LocationSearchResultsViewController { get set }
	//
	//lazy internal var searchController: UISearchController { get set }
	//
	//lazy internal var searchBar: UISearchBar { get set }
	//



//open override func loadView()
//
//open override func viewDidLoad()
//
//open override var preferredStatusBarStyle: UIStatusBarStyle { get }
	//
	//internal var presentedInitialLocation: Bool


- (void)changeMapTypeAction:(UISegmentedControl *)segment;


//open override func viewDidLayoutSubviews()

	//internal func setInitialLocation()
- (void)setInitialLocation;

	//internal func getCurrentLocation()
- (void)getCurrentLocation;


	//@objc internal func currentLocationPressed()
- (void)currentLocationPressed;

	//internal func showCurrentLocation(_ animated: Bool = default)
- (void)showCurrentLocation:(_Bool)animated;

	//internal func updateAnnotation()
- (void)updateAnnotation;

	//internal func showCoordinates(_ coordinate: CLLocationCoordinate2D, animated: Bool = default)
- (void)showCoordinates:(CLLocationCoordinate2D)coordinate animated:(_Bool)animated;

	//internal func selectLocation(location: CLLocation)
- (void)selectLocation:(CLLocation *)location initialLocation:(_Bool)initialLocation;

@end


//Extentions

@interface LocationPickerViewController (CLLocationManagerDelegate) <CLLocationManagerDelegate>

//- (void)locationManager:(CLLocationManager*_Null_unspecified)manager didUpdateLocations:(NSArray<CLLocation*>*_Null_unspecified)locations;

@end

//extension LocationPickerViewController : CLLocationManagerDelegate {
//
//	public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
//}


@interface LocationPickerViewController (UISearchResultsUpdating) <UISearchResultsUpdating>

- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController;
- (void)searchFromTimer:(NSTimer*_Null_unspecified)timer;

- (void)showItemsForSearchResult:(MKLocalSearchResponse*_Nullable)searchResult;
- (void)selectedLocation:(CustomLocation*)location;

@end

//extension LocationPickerViewController : UISearchResultsUpdating {
//
//	public func updateSearchResults(for searchController: UISearchController)
//
//	@objc internal func searchFromTimer(_ timer: Timer)
//
//	internal func showItemsForSearchResult(_ searchResult: MKLocalSearch.Response?)
//
//	internal func selectedLocation(_ location: Location)
//}



@interface LocationPickerViewController (addLocation)

- (void)addLocation:(UIGestureRecognizer*)gestureRecognizer;

@end

//extension LocationPickerViewController {
//
//	@objc internal func addLocation(_ gestureRecognizer: UIGestureRecognizer)
//}



@interface LocationPickerViewController (MKMapViewDelegate) <MKMapViewDelegate>

//- (MKAnnotationView*_Nullable)mapView:(MKMapView*_Null_unspecified)mapView viewFor:(id<MKAnnotation> _Null_unspecified)annotation;
- (LocationSelectionButton*)selectLocationButton;

//- (void)mapView:(MKMapView*_Null_unspecified)mapView annotationView:(MKAnnotationView * _Null_unspecified)view calloutAccessoryControlTapped:(UIControl*_Null_unspecified)control;
//- (void)mapView:(MKMapView*_Null_unspecified)mapView didAdd:(NSArray<MKAnnotationView*>*_Null_unspecified)views;

@end
//extension LocationPickerViewController : MKMapViewDelegate {
//
//	public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
//
//	internal func selectLocationButton() -> UIButton
//
//	public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
//
//	public func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView])
//}



@interface LocationPickerViewController (UIGestureRecognizerDelegate) <UIGestureRecognizerDelegate>

- (_Bool)gestureRecognizer:(UIGestureRecognizer*_Null_unspecified)gestureRecognizer shouldRecognizeSimultaneouslyWith:(UIGestureRecognizer*_Null_unspecified)otherGestureRecognizer;

@end
//extension LocationPickerViewController : UIGestureRecognizerDelegate {
//
//	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
//}


@interface LocationPickerViewController (UISearchBarDelegate) <UISearchBarDelegate>

- (void)searchBarTextDidBeginEditing:(UISearchBar*_Null_unspecified)searchBar;
- (void)searchBar:(UISearchBar*_Null_unspecified)searchBar textDidChange:(NSString*_Null_unspecified)searchText;

@end
//extension LocationPickerViewController : UISearchBarDelegate {
//
//	public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
//
//	public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
//}



