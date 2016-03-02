//
//  PTPPLiveVideoShareViewController.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 25/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "PTPPMediaShareViewController.h"
#import "PTRecommendAppBottomView.h"

#import "PTPPVideoUploadManager.h"
#import "NSString+Hashes.h"
#import "SVProgressHUD.h"
@interface PTPPMediaShareViewController ()<HTTPRequestDelegate>
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) SOImageTextControl *saveTitleView;
@property (nonatomic, strong) UIImage *imgShare;
@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, assign) NSInteger shareOption;
@property (nonatomic, strong) NSString *videoWebLink;
@property (nonatomic, strong) PTRecommendAppBottomView *recommendAppView;
@end

@implementation PTPPMediaShareViewController

-(id)initWithImage:(UIImage *)img videoPath:(NSURL *)videoURL{
    self = [super init];
    if (self) {
        self.imgShare = img;
        self.videoURL = videoURL;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self disableAdjustsScrollView];
    [self cleanEdgesForExtendedLayout];
    self.view.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self.view addSubview:self.backgroundImage];
    [self addCustomNavigationBar];
    [self.view addSubview:self.saveTitleView];
    [self addShareOptionView];
    [self.view addSubview:self.recommendAppView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xff5a5d)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods
-(void)addCustomNavigationBar{
    UIView *navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screenwidth, HEIGHT_NAV)];
    navBar.backgroundColor = UIColorFromRGB(0xff5a5d);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:navBar.frame];
    titleLabel.text = @"分享";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navBar addSubview:titleLabel];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 30, HEIGHT_NAV)];
    [backButton setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backButton];
    UIButton *shootAgainButton = [[UIButton alloc] initWithFrame:CGRectMake(navBar.width-30-10, 0, 30, HEIGHT_NAV)];
    [shootAgainButton setImage:[UIImage imageNamed:@"btn_20_capture_w_nor"] forState:UIControlStateNormal];
    [shootAgainButton addTarget:self action:@selector(shootAgain) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:shootAgainButton];
    [self.view addSubview:navBar];
}

-(void)addShareOptionView{
    for (NSInteger i=0; i<4; i++) {
        SOImageTextControl *shareButton = [[SOImageTextControl alloc] initWithFrame:CGRectMake(i*(Screenwidth/4), Screenheight/2-Screenwidth/4/2, Screenwidth/4, Screenwidth/4)];
        shareButton.tag = i;
        shareButton.imageSize = CGSizeMake(40, 40);
        shareButton.imagePosition = SOImagePositionTop;
        shareButton.imageAndTextSpace = 0;
        shareButton.textLabel.textColor = [UIColor grayColor];
        shareButton.textLabel.font = [UIFont systemFontOfSize:12];
        shareButton.textLabel.textAlignment = NSTextAlignmentCenter;
        switch (i) {
            case 0:
                shareButton.imageView.image = [UIImage imageNamed:@"icon_40_01"];
                shareButton.textLabel.text = @"微信好友";
                break;
            case 1:
                shareButton.imageView.image = [UIImage imageNamed:@"icon_40_02"];
                shareButton.textLabel.text = @"微信朋友圈";
                break;
            case 2:
                shareButton.imageView.image = [UIImage imageNamed:@"icon_40_03"];
                shareButton.textLabel.text = @"QQ好友";
                break;
            case 3:
                shareButton.imageView.image = [UIImage imageNamed:@"icon_40_04"];
                shareButton.textLabel.text = @"新浪微博";
                break;
            default:
                break;
        }
        [shareButton addTarget:self action:@selector(didTapShareOption:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:shareButton];
    }
}

#pragma mark - Touch events
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)shootAgain{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)didTapShareOption:(UIButton *)shareButton{
    PTPPVideoUploadManager *pthttp = [[PTPPVideoUploadManager alloc] init];
    [pthttp api_getVideoUploadTokenWithDelegate:self];
    self.shareOption = shareButton.tag;
    [SVProgressHUD showWithStatus:@"处理中"];
}

-(void)shareVideo{
//    switch (self.shareOption) {
//        case 0:
//            [self shareWxSession];
//            break;
//        case 1:
//            [self shareWxTimeline];
//            break;
//        case 2:
//            [self shareQQ];
//            break;
//        case 3:
//            [self shareSina];
//            break;
//        default:
//            break;
//    }
}

#pragma mark - 分享操作
//-(void) shareWxSession{
//    [MobClick event:PHOTOEDIT_VIEW_SHARE_WxSession];//分享给微信好友次数
//    [self shareWithType:UmengWXSession];
//}
//-(void) shareWxTimeline{
//    [MobClick event:PHOTOEDIT_VIEW_SHARE_WxTimeline]; //分享给微信朋友圈次数
//    [self shareWithType:UmengWXTimeline];
//}
//
//-(void) shareQQ{
//    [MobClick event:PHOTOEDIT_VIEW_SHARE_QQ];    //分享给QQ空间次数
//    [self shareWithType:UmengQQ];
//}
//
//-(void) shareQzone{
//    [MobClick event:PHOTOEDIT_VIEW_SHARE_Qzone];    //分享给QQ空间次数
//    [self shareWithType:UmengQzone];
//}
//-(void) shareSina{
//    [MobClick event:PHOTOEDIT_VIEW_SHARE_Sina];    //分享给新浪微博次数
//    [self shareWithType:UmengSina];
//}
//
//-(void) shareWithType:(NSString *)type {
//    NSString *strShare = @"葡萄亲子相机";
//    
//    NSData *dataPhoto = UIImageJPEGRepresentation(self.imgShare, 0.7);
//    UIImage *shareImage = [UIImage imageWithData:dataPhoto];
//
//    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeVideo url:self.videoWebLink];
//    [[UMSocialControllerService defaultControllerService] setShareText:strShare shareImage:shareImage socialUIDelegate:self];
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:type];
//    snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
//    
//}
//
//-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
//{
//    //根据`responseCode`得到发送结果,如果分享成功
//    if(response.responseCode == UMSResponseCodeSuccess)
//    {
//        
//    } else {
//        // stay on this page
//    }
//    
//}

-(void)request:(AFHTTPRequestOperation *)myRequest finshAction:(NSDictionary *)dic withURLTag:(NSString *)url{
    if ([url isEqualToString:@"0"]) {
        NSString *hash = [dic safeObjectForKey:@"hash"];
        NSString *ext = [dic safeObjectForKey:@"ext"];
        if (hash.length == 0 || ext.length == 0) {
            [SVProgressHUD dismissWithError:@"请求失败" afterDelay:2.0];
            return;
        }
        PTPPVideoUploadManager *pthttp = [[PTPPVideoUploadManager alloc] init];
        [pthttp api_getVideoLinkWithDelegate:self hash:hash ext:ext];
    }
    if ([url isEqualToString:API_GET_VIDEO_UPLOAD_TOKEN]) {
        NSString *uploadToken = [[dic safeObjectForKey:@"data"] safeObjectForKey:@"uploadToken"];
        if (uploadToken.length == 0) {
            [SVProgressHUD dismissWithError:@"请求失败" afterDelay:2.0];
            return;
        }
        PTPPVideoUploadManager *pthttp = [[PTPPVideoUploadManager alloc] init];
        NSData *videoData = [[NSFileManager defaultManager] contentsAtPath:[self.videoURL path]];
        NSString *file_sha = [NSString getSha1String:videoData];
        if (file_sha.length == 0) {
            [SVProgressHUD dismissWithError:@"请求失败" afterDelay:2.0];
            return;
        }
        [pthttp video_upload:self withUploadToken:uploadToken withPhotoFileName:[NSString stringWithFormat:@"%@",[NSDate date]] withVideoPath:self.videoURL withVideoSHA_1:file_sha withTag:0];
    }
    if ([url isEqualToString:API_VIDEO_WEB_SHARE]) {
        NSLog(@"Video Upload Success");
        NSString *originalLink = [[dic safeObjectForKey:@"data"] safeObjectForKey:@"media_url"];
        originalLink = [originalLink stringByAppendingString:@"&media_type=VIDEO"];
        self.videoWebLink = [[NSString stringWithFormat:@"%@%@",PTPP_BASE_URL,API_VIDEO_H5] stringByAppendingString:originalLink];
        if (!self.videoWebLink) {
            [SVProgressHUD dismissWithError:@"请求失败" afterDelay:2.0];
            return;
        }
        [SVProgressHUD dismiss];
        [self shareVideo];
    }
}

-(void)request:(AFHTTPRequestOperation *)myRequest failAction:(NSError *)error withURLTag:(NSString *)url{
    [SVProgressHUD dismissWithError:@"请求失败" afterDelay:2.0];
}

#pragma mark - Getters/Setters
-(UIImageView *)backgroundImage{
    if (!_backgroundImage) {
        _backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT_NAV, Screenwidth, Screenheight-HEIGHT_NAV)];
        _backgroundImage.image = [UIImage imageNamed:@"img_about_bg_736h@3x.jpg"];
        _backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroundImage;
}

-(SOImageTextControl *)saveTitleView{
    if (!_saveTitleView) {
        _saveTitleView = [[SOImageTextControl alloc] initWithFrame:CGRectMake(0, HEIGHT_NAV*2, Screenwidth, HEIGHT_NAV)];
        _saveTitleView.imageView.image = [UIImage imageNamed:@"icon_40_09"];
        _saveTitleView.imageAndTextSpace = 20;
        _saveTitleView.imagePosition = SOImagePositionHorizontalBothCenter;
        _saveTitleView.imageSize = CGSizeMake(40, 40);
        _saveTitleView.textLabel.text = @"已保存到相册";
        _saveTitleView.textLabel.font = [UIFont systemFontOfSize:18];
        _saveTitleView.textLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    return _saveTitleView;
}

-(PTRecommendAppBottomView *)recommendAppView{
    if (!_recommendAppView) {
        _recommendAppView = [[PTRecommendAppBottomView alloc] initWithFrame:CGRectMake(0, Screenheight-HEIGHT_NAV-HEIGHT_STATUS, Screenwidth, HEIGHT_STATUS+HEIGHT_NAV)];
        [_recommendAppView setAttributeWithAppIcon:@"icon_40_10" appTitle:@"葡萄时光" appSubtitle:@"共享亲子时刻" urlScheme:@"ptapp://" appStoreLink:@"https://itunes.apple.com/cn/app/pu-tao-shi-guang-bao-bao-cheng/id987826034?l=en&mt=8"];
    }
    return _recommendAppView;
}

@end
