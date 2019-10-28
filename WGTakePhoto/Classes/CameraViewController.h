//
//  CameraView.h
//  Camera
#import <UIKit/UIKit.h>

@protocol CameraDelegate <NSObject>

- (void)CameraTakePhoto:(UIImage *)image;

@end

@interface CameraViewController : UIViewController

@property (nonatomic, weak)id<CameraDelegate> delegate;
@property (nonatomic,copy) NSString *locaton;
@property (nonatomic,copy)void(^handleBlock)(NSString *location);



@end
