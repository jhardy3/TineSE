// Generated by Apple Swift version 2.2 (swiftlang-703.0.18.1 clang-703.0.29)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if defined(__has_include) && __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
# if defined(__has_feature) && __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if defined(__has_feature) && __has_feature(modules)
@import UIKit;
@import CoreLocation;
@import CoreGraphics;
@import ObjectiveC;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
@class UIWindow;
@class UIApplication;
@class NSObject;

SWIFT_CLASS("_TtC6TineSE11AppDelegate")
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow * _Nullable window;
@property (nonatomic, readonly, copy) NSString * _Nonnull cognitoAccountId;
@property (nonatomic, readonly, copy) NSString * _Nonnull cognitoIdentityPoolId;
@property (nonatomic, readonly, copy) NSString * _Nonnull cognitoUnauthRoleArn;
@property (nonatomic, readonly, copy) NSString * _Nonnull cognitoAuthRoleArn;
- (BOOL)application:(UIApplication * _Nonnull)application didFinishLaunchingWithOptions:(NSDictionary * _Nullable)launchOptions;
- (void)applicationWillResignActive:(UIApplication * _Nonnull)application;
- (void)applicationDidEnterBackground:(UIApplication * _Nonnull)application;
- (void)applicationWillEnterForeground:(UIApplication * _Nonnull)application;
- (void)applicationDidBecomeActive:(UIApplication * _Nonnull)application;
- (void)applicationWillTerminate:(UIApplication * _Nonnull)application;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class UIImage;
@class CLLocationManager;
@class UITapGestureRecognizer;
@class UIButton;
@class UIImagePickerController;
@class UITextField;
@class UITextView;
@class NSError;
@class CLLocation;
@class UIPickerView;
@class UIImageView;
@class UIView;
@class NSBundle;
@class NSCoder;

SWIFT_CLASS("_TtC6TineSE20CameraViewController")
@interface CameraViewController : UIViewController <UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate>
@property (nonatomic, strong) UIImage * _Nullable image;
@property (nonatomic, strong) CLLocationManager * _Null_unspecified locationManager;
@property (nonatomic) BOOL postButtonTapped;
@property (nonatomic) BOOL firedOnce;
@property (nonatomic, copy) NSString * _Nonnull shedColor;
@property (nonatomic, copy) NSString * _Nonnull shedType;
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified shedImageView;
@property (nonatomic, weak) IBOutlet UIPickerView * _Null_unspecified shedColorPickerView;
@property (nonatomic, weak) IBOutlet UIPickerView * _Null_unspecified shedTypePickerView;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified clearShedButton;
@property (nonatomic, weak) IBOutlet UIView * _Null_unspecified shedView;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified crosshairButton;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewDidLoad;
- (IBAction)tapGestureTapped:(UITapGestureRecognizer * _Nonnull)sender;
- (IBAction)postButtonTapped:(UIButton * _Nonnull)sender;
- (IBAction)clearShedTapped:(UIButton * _Nonnull)sender;
- (void)displayCamera;
- (void)imagePickerControllerDidCancel:(UIImagePickerController * _Nonnull)picker;
- (void)imagePickerController:(UIImagePickerController * _Nonnull)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> * _Nonnull)info;
- (BOOL)textFieldShouldReturn:(UITextField * _Nonnull)textField;
- (void)textViewDidEndEditing:(UITextView * _Nonnull)textView;
- (void)locationManager:(CLLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nonnull)error;
- (void)locationManager:(CLLocationManager * _Nonnull)manager didUpdateLocations:(NSArray<CLLocation *> * _Nonnull)locations;
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView * _Nonnull)pickerView;
- (NSInteger)pickerView:(UIPickerView * _Nonnull)pickerView numberOfRowsInComponent:(NSInteger)component;
- (void)pickerView:(UIPickerView * _Nonnull)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (NSString * _Nullable)pickerView:(UIPickerView * _Nonnull)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (void)createAnimation;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class ProfileViewController;

SWIFT_CLASS("_TtC6TineSE23ImageCollectionViewCell")
@interface ImageCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) ProfileViewController * _Nullable delegate;
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified shedImage;
- (void)awakeFromNib;
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC6TineSE13ImageUitilies")
@interface ImageUitilies : NSObject
+ (UIImage * _Nonnull)cropToSquareWithImage:(UIImage * _Nonnull)originalImage;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class UITableView;
@class NSIndexPath;
@class UITableViewCell;
@class UISegmentedControl;
@class UIStoryboardSegue;

SWIFT_CLASS("_TtC6TineSE25LeaderboardViewController")
@interface LeaderboardViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UISegmentedControl * _Null_unspecified segmentedControl;
@property (nonatomic, weak) IBOutlet UITableView * _Null_unspecified tableView;
@property (nonatomic) BOOL isTracking;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)fetchTrackedHuntersForLeaderBoard;
- (void)fetchAllHuntersForLeaderBoard;
- (IBAction)segmentedControlChanged:(UISegmentedControl * _Nonnull)sender;
- (void)prepareForSegue:(UIStoryboardSegue * _Nonnull)segue sender:(id _Nullable)sender;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UICollectionView;
@class UILabel;
@class UICollectionViewFlowLayout;

SWIFT_CLASS("_TtC6TineSE21ProfileViewController")
@interface ProfileViewController : UIViewController <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, readonly) CGFloat kMargin;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified followButton;
@property (nonatomic, weak) IBOutlet UICollectionView * _Null_unspecified collectionView;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified usernameLabel;
@property (nonatomic, weak) IBOutlet UICollectionViewFlowLayout * _Null_unspecified flowLayout;
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified hunterProfileImage;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified brownsCountLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified whitesCountLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified chalksCountLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified trackersCountLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified shedCountLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified trackingCountLabel;
@property (nonatomic) BOOL viewLoaded;
@property (nonatomic) NSInteger trackingCount;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (void)viewDidLoad;
- (void)viewDidAppear:(BOOL)animated;
- (UICollectionViewCell * _Nonnull)collectionView:(UICollectionView * _Nonnull)collectionView cellForItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (NSInteger)collectionView:(UICollectionView * _Nonnull)collectionView numberOfItemsInSection:(NSInteger)section;
- (IBAction)followButtonTapped:(UIButton * _Nonnull)sender;
- (void)updateWithIdentifier:(NSString * _Nonnull)identifier;
- (void)shedDeletedUpdateView;
- (void)collectionView:(UICollectionView * _Nonnull)collectionView didSelectItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)collectionView:(UICollectionView * _Nonnull)collectionView didDeselectItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)prepareForSegue:(UIStoryboardSegue * _Nonnull)segue sender:(id _Nullable)sender;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UICollectionViewLayout;

@interface ProfileViewController (SWIFT_EXTENSION(TineSE)) <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView * _Nonnull)collectionView layout:(UICollectionViewLayout * _Nonnull)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
@end


SWIFT_CLASS("_TtC6TineSE32SearchResultsTableViewController")
@interface SearchResultsTableViewController : UITableViewController
- (void)viewDidLoad;
- (NSInteger)numberOfSectionsInTableView:(UITableView * _Nonnull)tableView;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)tableView:(UITableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (nonnull instancetype)initWithStyle:(UITableViewStyle)style OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UISearchController;

SWIFT_CLASS("_TtC6TineSE25SearchTableViewController")
@interface SearchTableViewController : UITableViewController <UISearchResultsUpdating>
@property (nonatomic, strong) UISearchController * _Null_unspecified searchController;
@property (nonatomic, weak) IBOutlet UISegmentedControl * _Null_unspecified segmentedControl;
- (void)viewDidLoad;
- (NSInteger)numberOfSectionsInTableView:(UITableView * _Nonnull)tableView;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)updateViewBasedOnMode;
- (void)setUpSearchController;
- (void)updateSearchResultsForSearchController:(UISearchController * _Nonnull)searchController;
- (IBAction)segmentedControllerChanged:(UISegmentedControl * _Nonnull)sender;
- (void)prepareForSegue:(UIStoryboardSegue * _Nonnull)segue sender:(id _Nullable)sender;
- (nonnull instancetype)initWithStyle:(UITableViewStyle)style OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class TinelineViewController;

SWIFT_CLASS("_TtC6TineSE17ShedTableViewCell")
@interface ShedTableViewCell : UITableViewCell
@property (nonatomic, strong) TinelineViewController * _Nullable delegate;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified usernameTextField;
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified shedImageView;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified reportButton;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified shedTypeTextLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified shedColorTextLabel;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (void)prepareForReuse;
- (IBAction)utilitiesButtonTapped:(UIButton * _Nonnull)sender;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UIRefreshControl;

SWIFT_CLASS("_TtC6TineSE22TinelineViewController")
@interface TinelineViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate, CLLocationManagerDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSArray<NSString *> * _Nonnull shedIDs;
@property (nonatomic, readonly) BOOL currentViewIsLocal;
@property (nonatomic, strong) CLLocationManager * _Null_unspecified locationManager;
@property (nonatomic, weak) IBOutlet UISegmentedControl * _Null_unspecified segmentedController;
@property (nonatomic, weak) IBOutlet UITableView * _Null_unspecified tableView;
- (void)viewDidLoad;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section;
- (void)setupLocationManagerAndGrabLocalSheds;
- (void)fetchShedsFirstLoad;
- (void)refresh:(UIRefreshControl * _Nonnull)refreshControl;
- (void)setUpRefreshController;
- (void)newShedsAddedRefresh;
- (IBAction)segmentedControlChanged:(UISegmentedControl * _Nonnull)sender;
- (void)prepareForSegue:(UIStoryboardSegue * _Nonnull)segue sender:(id _Nullable)sender;
- (void)locationManager:(CLLocationManager * _Nonnull)manager didUpdateLocations:(NSArray<CLLocation *> * _Nonnull)locations;
- (void)locationManager:(CLLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nonnull)error;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


@interface UIColor (SWIFT_EXTENSION(TineSE))
+ (UIColor * _Nonnull)rustyTruckGreen;
+ (UIColor * _Nonnull)desertFloorTan;
+ (UIColor * _Nonnull)desertSkyBlue;
+ (UIColor * _Nonnull)hunterOrange;
@end


@interface UIImageView (SWIFT_EXTENSION(TineSE))
- (void)downloadImageFromLink:(NSString * _Nonnull)link contentMode:(UIViewContentMode)contentMode;
@end


SWIFT_CLASS("_TtC6TineSE19logInViewController")
@interface logInViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified usernameTextField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified emailTextField;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified passwordTextField;
- (void)viewDidLoad;
- (void)viewDidAppear:(BOOL)animated;
- (void)didReceiveMemoryWarning;
- (IBAction)signUpTapped:(UIButton * _Nonnull)sender;
- (IBAction)signInTapped:(UIButton * _Nonnull)sender;
- (void)setupTextFields;
- (void)textFieldDidEndEditing:(UITextField * _Nonnull)textField;
- (BOOL)textFieldShouldReturn:(UITextField * _Nonnull)textField;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

#pragma clang diagnostic pop
