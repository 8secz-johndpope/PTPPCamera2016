//
//  PTPPLiveVideoShareViewController.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 25/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "UMSocialWechatHandler.h"
#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialQQHandler.h"
#import "PTPPMediaShareViewController.h"
#import "PTRecommendAppBottomView.h"

#import "PTPPVideoUploadManager.h"
#import "NSString+Hashes.h"
#import "SVProgressHUD.h"
@interface PTPPMediaShareViewController ()<UMSocialUIDelegate,HTTPRequestDelegate>
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) SOImageTextControl *saveTitleView;
@property (nonatomic, strong) UILabel *shareTitle;
@property (nonatomic, strong) UIImage *imgShare;
@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, assign) NSInteger shareOption;
@property (nonatomic, strong) NSString *videoWebLink;
@property (nonatomic, strong) PTRecommendAppBottomView *recommendAppView;
@property (nonatomic, strong) NSString *shareMediaType;
@end

static NSString *PTShareMediaTypeImage = @"PTShareMediaTypeImage";
static NSString *PTShareMediaTypeVideo = @"PTShareMediaTypeVideo";

@implementation PTPPMediaShareViewController

-(id)initWithImage:(UIImage *)img videoPath:(NSURL *)videoURL{
    self = [super init];
    if (self) {
        self.imgShare = img;
        self.videoURL = videoURL;
        self.shareMediaType = PTShareMediaTypeVideo;
    }
    return self;
}

-(id)initWithImage:(UIImage *)img{
    self = [super init];
    if (self) {
        self.imgShare = img;
        self.shareMediaType = PTShareMediaTypeImage;
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
    [self addWhereToGoView];
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

-(void)addWhereToGoView{
    //美化，拍照，拼图
    for (NSInteger i=0; i<3; i++) {
        SOImageTextControl *actionButton = [[SOImageTextControl alloc] initWithFrame:CGRectMake(i*(Screenwidth/3), self.saveTitleView.bottom+45, Screenwidth/3, Screenwidth/3/1.5)];
        actionButton.tag = i;
        actionButton.imageSize = CGSizeMake(50, 50);
        actionButton.imagePosition = SOImagePositionTop;
        actionButton.textLabel.textColor = [UIColor grayColor];
        actionButton.textLabel.font = [UIFont systemFontOfSize:14];
        actionButton.textLabel.textAlignment = NSTextAlignmentCenter;
        switch (i) {
            case 0:
                actionButton.imageView.image = [UIImage imageNamed:@"icon_50_01"];
                actionButton.textLabel.text = @"美化";
                break;
            case 1:
                actionButton.imageView.image = [UIImage imageNamed:@"icon_50_02"];
                actionButton.textLabel.text = @"拍照";
                break;
            case 2:
                actionButton.imageView.image = [UIImage imageNamed:@"icon_50_03"];
                actionButton.textLabel.text = @"拼图";
                break;
            default:
                break;
        }
        [actionButton addTarget:self action:@selector(didTapActionOption:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:actionButton];
    }
}

-(void)addShareOptionView{
    //分享给好友
    for (NSInteger i=0; i<4; i++) {
        SOImageTextControl *shareButton = [[SOImageTextControl alloc] initWithFrame:CGRectMake(i*(Screenwidth/4), self.recommendAppView.top-40-Screenwidth/4, Screenwidth/4, Screenwidth/4)];
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
                shareButton.imageView.image = [UIImage imageNamed:@"icon_40_05"];
                shareButton.textLabel.text = @"新浪微博";
                break;
            default:
                break;
        }
        [shareButton addTarget:self action:@selector(didTapShareOption:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:shareButton];
    }
    [self.view addSubview:self.shareTitle];
    self.shareTitle.frame = CGRectMake(0, self.recommendAppView.top-40-Screenwidth/4-20-self.shareTitle.height, self.shareTitle.width, self.shareTitle.height);
}

#pragma mark - Touch events
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)shootAgain{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)didTapActionOption:(UIButton *)actionButton{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    switch (actionButton.tag) {
        case 0:
            [self.navigationController popToRootViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLiveCameraAlbumButtonTapped object:screenShot];
            break;
        case 1:
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        case 2:
            [self.navigationController popToRootViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLiveCameraJigsawButtonTapped object:screenShot];
            
            break;
        default:
            break;
    }
}

-(void)didTapShareOption:(UIButton *)shareButton{
    self.shareOption = shareButton.tag;
    if (self.shareMediaType == PTShareMediaTypeVideo) {
        PTPPVideoUploadManager *pthttp = [[PTPPVideoUploadManager alloc] init];
        [pthttp api_getVideoUploadTokenWithDelegate:self];
        [SVProgressHUD showWithStatus:@"处理中"];
    }else{
        [self share];
    }
    
}

-(void)share{
    switch (self.shareOption) {
        case 0:
            [self shareWxSession];
            break;
        case 1:
            [self shareWxTimeline];
            break;
        case 2:
            [self shareQQ];
            break;
        case 3:
            [self shareSina];
            break;
        default:
            break;
    }
}

#pragma mark - 分享操作
-(void) shareWxSession{

    [self shareWithType:UmengWXSession];
}
-(void) shareWxTimeline{

    [self shareWithType:UmengWXTimeline];
}

-(void) shareQQ{

    [self shareWithType:UmengQQ];
}

-(void) shareQzone{

    [self shareWithType:UmengQzone];
}
-(void) shareSina{

    [self shareWithType:UmengSina];
}

-(void) shareWithType:(NSString *)type {
    NSString *strShare = @"葡萄亲子相机";
    
    NSData *dataPhoto = UIImageJPEGRepresentation(self.imgShare, 0.7);
    UIImage *shareImage = [UIImage imageWithData:dataPhoto];

    if ([self.shareMediaType isEqualToString:PTShareMediaTypeVideo]) {
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeVideo url:self.videoWebLink];
        [[UMSocialControllerService defaultControllerService] setShareText:strShare shareImage:shareImage socialUIDelegate:self];
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:type];
        snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }else{
        if([type isEqualToString:UmengQQ]) {
            [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
        } else if([type isEqualToString:UmengWXSession]||[type isEqualToString:UmengWXTimeline]){
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        }else if([type isEqualToString:UmengQzone]) {
            strShare = [self getShareText];
            [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
        }
        [[UMSocialControllerService defaultControllerService] setShareText:strShare shareImage:shareImage socialUIDelegate:self];
        
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:type];
        snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }
}

-(NSString *)getShareText{
    NSArray *arrText = @[@"再不拍，孩子就长大了！",@"用镜头记录孩子成长点滴，满满的都是爱啊！",@"我对你的喜爱有如滔滔江水，连绵不绝，又如黄河泛滥一发不可收拾。",@"萌主驾到，速来围观！",@"家有萌娃，可爱，就是这么任性！"];
    int random = arc4random() % 5;
    
    return arrText[random];
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        
    } else {
        // stay on this page
    }
    
}

-(void)request:(AFHTTPRequestOperation *)myRequest finshAction:(NSDictionary *)dic withURLTag:(NSString *)url{
    if ([url isEqualToString:@"0"]) {
        NSString *hash = [dic safeObjectForKey:@"hash"];
        NSString *ext = [dic safeObjectForKey:@"ext"];
        if (hash.length == 0 || ext.length == 0) {
            [SVProgressHUD dismissWithError:@"请求失败" afterDelay:2.0];
            return;
        }
        NSLog(@"Video Upload Success");
        PTPPVideoUploadManager *pthttp = [[PTPPVideoUploadManager alloc] init];
        [pthttp api_getVideoLinkWithDelegate:self hash:hash ext:ext];
    }
    if ([url isEqualToString:API_GET_VIDEO_UPLOAD_TOKEN]) {
        NSString *uploadToken = [[dic safeObjectForKey:@"data"] safeObjectForKey:@"uploadToken"];
        if (uploadToken.length == 0) {
            [SVProgressHUD dismissWithError:@"请求失败" afterDelay:2.0];
            return;
        }
        NSLog(@"Video Upload token received");
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
        NSLog(@"Video link get");
        NSString *originalLink = [[dic safeObjectForKey:@"data"] safeObjectForKey:@"media_url"];
        originalLink = [originalLink stringByAppendingString:@"&media_type=VIDEO"];
        self.videoWebLink = [[NSString stringWithFormat:@"%@%@",PTPP_BASE_URL,API_VIDEO_H5] stringByAppendingString:originalLink];
        if (!self.videoWebLink) {
            [SVProgressHUD dismissWithError:@"请求失败" afterDelay:2.0];
            return;
        }
        [SVProgressHUD dismiss];
        [self share];
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

-(UILabel *)shareTitle{
    if (!_shareTitle) {
        _shareTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screenwidth, [UIFont systemFontOfSize:14].lineHeight)];
        _shareTitle.textAlignment = NSTextAlignmentCenter;
        _shareTitle.text = @"分享给好友";
        _shareTitle.textColor = [UIColor colorWithHexString:@"959595"];
    }
    return _shareTitle;
}

-(PTRecommendAppBottomView *)recommendAppView{
    if (!_recommendAppView) {
        _recommendAppView = [[PTRecommendAppBottomView alloc] initWithFrame:CGRectMake(0, Screenheight-HEIGHT_NAV-HEIGHT_STATUS, Screenwidth, HEIGHT_STATUS+HEIGHT_NAV)];
        [_recommendAppView setAttributeWithAppIcon:@"icon_40_10" appTitle:@"葡萄时光" appSubtitle:@"共享亲子时刻" urlScheme:@"ptapp://" appStoreLink:@"https://itunes.apple.com/cn/app/pu-tao-shi-guang-bao-bao-cheng/id987826034?l=en&mt=8"];
    }
    return _recommendAppView;
}

@end
