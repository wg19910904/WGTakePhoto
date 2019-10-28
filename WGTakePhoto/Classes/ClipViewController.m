//
//  ClipViewController.m
//  Camera

#import "ClipViewController.h"
#import "TKImageView.h"
#import "Masonry.h"
#define SelfWidth [UIScreen mainScreen].bounds.size.width
#define SelfHeight  [UIScreen mainScreen].bounds.size.height
@interface ClipViewController ()

@property (nonatomic, assign) BOOL isClip;

@property (nonatomic, strong) TKImageView *tkImageView;
@property (nonatomic, strong) UIImageView *headView;


@end

@implementation ClipViewController


-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIApplication sharedApplication].delegate.window.bounds.size.width, 24)];
    headerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:headerView];
    [self createdTkImageView];
//    NSDate *date = [NSDate date];
//    NSString * hourtime= [date formattedDateWithFormat:@"hh:mm"];
//    NSString * daytime = [date formattedDateWithFormat:@"yyyy.MM.dd EEEE"];
//    self.MyhandleBlock = ^(NSString *location) {
//
//        UIImage *newImage = [self watermarkImage:self.image withName:hourtime withtime:daytime withlocation:location];
//        _headView.image = newImage;
//        //[self.view addSubview:self.headView];
//    };
    
    [self createdTool];
    
}

- (void)createdTkImageView
{
    _headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, SelfWidth, SelfHeight - 100)];
    self.headView.contentMode =UIViewContentModeScaleAspectFit;
    self.headView.backgroundColor = [UIColor blackColor];
 
    NSDate *date = [NSDate date];
    NSString * hourtime= [self formattedDateWithFormat:@"hh:mm" date:date];
    NSString * daytime = [self formattedDateWithFormat:@"yyyy.MM.dd EEEE" date:date];
    //获取星期
    if (!self.location) {
        self.location = @"暂时无法获取定位信息";
    }
    //从本地取
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *String = [user objectForKey:@"ImageLocation"];
    
    if (String) {
        self.location = String;
    }
    UIImage *newImage = [self watermarkImage:self.image withName:hourtime withtime:daytime withlocation:self.location];
    _headView.image = newImage;
    [self.view addSubview:self.headView];
    self.isClip = NO;
}
-(NSString *)formattedDateWithFormat:(NSString *)format date:(NSDate *)date{
    return [self formattedDateWithFormat:format timeZone:[NSTimeZone systemTimeZone] locale:[NSLocale autoupdatingCurrentLocale] date:date];
}
-(NSString *)formattedDateWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale date:(NSDate *)date{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
    });

    [formatter setDateFormat:format];
    [formatter setTimeZone:timeZone];
    [formatter setLocale:locale];
    return [formatter stringFromDate:date];
}
-(UIImage *)watermarkImage:(UIImage *)img withName:(NSString *)name withtime:(NSString *)time withlocation:(NSString *)location

{
    NSString* mark = name;
    int w = img.size.width;
    
    int h = img.size.height;
    CGFloat a = w/[UIApplication sharedApplication].delegate.window.bounds.size.width;
//    CGFloat b = h/(SCREEN_HEIGHT-100);
    CGFloat b = a;
    UIGraphicsBeginImageContext(img.size);
    [img drawInRect:CGRectMake(0, 0, w, h)];
    {
        
        UIImage *appImage = [UIImage imageNamed:@"photo_line"];
        [appImage drawInRect:CGRectMake(17*a, 16*b, 2*a, 63*b)];
        
        NSDictionary *attr = @{
                               NSFontAttributeName: [UIFont boldSystemFontOfSize:23*a],  //设置字体
                               NSForegroundColorAttributeName : [UIColor whiteColor]   //设置字体颜色
                               };
        [mark drawInRect:CGRectMake(30*a ,15*b ,200*a ,35*b) withAttributes:attr];
    }{
        NSDictionary *attr = @{
                               NSFontAttributeName: [UIFont systemFontOfSize:18*a],  //设置字体
                               NSForegroundColorAttributeName : [UIColor whiteColor]   //设置字体颜色
                               };
        [time drawInRect:CGRectMake(30*a ,50*b ,260*a ,30*b) withAttributes:attr];
        
    }{
//        UIImage *appImage = [UIImage imageNamed:@"photo_appicon"];
//        [appImage drawInRect:CGRectMake(30*a, 75*b, 30*a, 30*b)];
//        NSDictionary *attr = @{
//                               NSFontAttributeName: [UIFont systemFontOfSize:16*a],  //设置字体
//                               NSForegroundColorAttributeName : [UIColor whiteColor]   //设置字体颜色
//                               };
//        [@"思傅帮" drawInRect:CGRectMake(65*a ,80*b ,200*a ,30*b) withAttributes:attr];
        
    }{//下面
        
        NSDictionary *attr = @{
                               NSFontAttributeName:  [UIFont systemFontOfSize:15*a],  //设置字体
                               NSForegroundColorAttributeName : [UIColor whiteColor]   //设置字体颜色
                               };
        CGFloat width =[self widthWithHeight:30*b font:15*a propertyString:self.employeName];
        [self.employeName drawInRect:CGRectMake(w-width-15*a,h-60*b ,width ,30*b) withAttributes:attr];
        UIImage *appImage = [UIImage imageNamed:@"photo_user"];
        [appImage drawInRect:CGRectMake(w-width-15*a-20*a, h-60*b, 20*a, 20*b)];
        
    }{
        NSDictionary *attr = @{
                               NSFontAttributeName: [UIFont systemFontOfSize:15*a],  //设置字体
                               NSForegroundColorAttributeName : [UIColor whiteColor]   //设置字体颜色
                               };
        CGFloat width =[self widthWithHeight:30*b font:15*a propertyString:location];
        if (width+20*a>w) {
            width = w -20*a;
        }
        
        [location drawInRect:CGRectMake(w-width-15*a,h-30*b ,width ,25*b) withAttributes:attr];
        UIImage *appImage = [UIImage imageNamed:@"photo_location"];
        [appImage drawInRect:CGRectMake(w-width-15*a-20*a, h-30*b, 20*a, 20*b)];
       
    }
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return aimg;
    
}
- (void)createdTool
{
    UIView  *editorView = [[UIView alloc]init];
    editorView.backgroundColor = [UIColor blackColor];
    editorView.alpha = 0.8;
    [self.view addSubview:editorView];
    [editorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(80);
    }];
    
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setTitle:@"取消" forState:0];
    [cancleBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:0];
    [cancleBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [editorView addSubview:cancleBtn];
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(editorView);
        make.height.mas_equalTo(30);
    }];
    

    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"使用照片" forState:0];
    [sureBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:0];
    [sureBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [editorView addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [editorView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(editorView);
        make.height.mas_equalTo(30);
    }];
    
}
- (CGFloat)widthWithHeight:(CGFloat)height font:(CGFloat)font propertyString:(NSString *)propertyString
{
    UIFont* fonts = [UIFont systemFontOfSize:font];
    CGSize size = CGSizeMake(100000.0,height);
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:fonts, NSFontAttributeName, nil];
    size = [propertyString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size.width;
}
- (void)back{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)sure{
    
    //裁剪
//    if (self.isClip == YES) {
//
//        UIImage *image = [_tkImageView currentCroppedImage];
//
//        if (self.isTakePhoto) {
//            //将图片存储到相册
//            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
//        }
//
//        if (self.delegate && [self.delegate respondsToSelector:@selector(clipPhoto:)]) {
//
//            [self.delegate clipPhoto:image];
//        }
//    }else{

        if (self.delegate && [self.delegate respondsToSelector:@selector(clipPhoto:)]) {

            [self.delegate clipPhoto:self.headView.image];
        }
    
//        if (self.isTakePhoto) {
//
//            //将图片存储到相册
//           // UIImageWriteToSavedPhotosAlbum(self.image, self, nil, nil);
//        }
    
   // }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.picker dismissViewControllerAnimated:YES completion:nil];
    [self.controller dismissViewControllerAnimated:YES completion:nil];
}



@end





