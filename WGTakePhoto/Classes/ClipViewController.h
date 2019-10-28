//
//  ClipViewController.h
//  Camera

#import <UIKit/UIKit.h>

@protocol ClipPhotoDelegate <NSObject>

- (void)clipPhoto:(UIImage *)image;

@end

@interface ClipViewController : UIViewController
@property (strong, nonatomic) UIImage *image;

@property (nonatomic, strong) UIImagePickerController *picker;

@property (nonatomic, strong) UIViewController *controller;

@property (nonatomic, weak) id<ClipPhotoDelegate> delegate;

@property (nonatomic, assign) BOOL isTakePhoto;
@property (nonatomic,strong)NSString *location;
@property (nonatomic,copy)void(^MyhandleBlock)(NSString *location);
@property (nonatomic,strong)NSString *employeName;

@end



