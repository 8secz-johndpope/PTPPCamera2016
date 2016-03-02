//
//  ELCImageSelectionBottomPreview.m
//  PTPPCamera
//
//  Created by CHEN KAIDI on 26/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//



#import "ELCImageSelectionBottomPreview.h"
#import "PTPPImageUtil.h"
#define kScrollViewPadding 10
@interface ELCImageSelectionBottomPreview ()
@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UILabel *topTitle;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UILabel *selectionCount;
@property (nonatomic, strong) UILabel *nextLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray <ELCAsset *>*assetArray;
@property (nonatomic, strong) NSMutableArray *thumbnailArray;
@property (nonatomic, assign) NSInteger currentCount;
@property (nonatomic, assign) NSInteger maxCount;
@end

@implementation ELCImageSelectionBottomPreview

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
        [self addSubview:self.topBar];
        [self.topBar addSubview:self.topTitle];
        [self addSubview:self.nextButton];
        [self.nextButton addSubview:self.selectionCount];
        [self.nextButton addSubview:self.nextLabel];
        self.currentCount = self.assetArray.count;
        [self addSubview:self.scrollView];
    }
    return self;
}

-(void)setAttributeWithMaxCount:(NSInteger)maxCount{
    self.topTitle.text = [NSString stringWithFormat:@"请选择1-%ld张照片进行拼图",(long)maxCount];
    self.maxCount  = maxCount;
    [self setNeedsLayout];
}

-(void)addPhotoAsset:(ELCAsset *)asset{
    if (self.currentCount == self.maxCount) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"最多只能选择%ld张照片",(long)self.maxCount] duration:1.0];
        return;
    }
    [self.assetArray addObject:asset];
    CGSize thumbnailSize = CGSizeMake(self.scrollView.height-kScrollViewPadding*2, self.scrollView.height-kScrollViewPadding*2);
    UIButton *thumbnailButton = [[UIButton alloc] initWithFrame:CGRectMake(kScrollViewPadding*(self.thumbnailArray.count+1)+thumbnailSize.width*self.thumbnailArray.count, kScrollViewPadding, thumbnailSize.width, thumbnailSize.height)];
    [thumbnailButton setImage:[PTPPImageUtil getThumbnailFromALAsset:asset.asset] forState:UIControlStateNormal];
    UIImageView *deleteIcon = [[UIImageView alloc] initWithFrame:CGRectMake(thumbnailSize.width-20, 0, 20, 20)];
    deleteIcon.image = [UIImage imageNamed:@"icon_20_27"];
    thumbnailButton.tag = self.thumbnailArray.count;
    [thumbnailButton addSubview:deleteIcon];
    [thumbnailButton addTarget:self action:@selector(removeThumbnailButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.thumbnailArray addObject:thumbnailButton];
    thumbnailButton.alpha = 0.0;
    thumbnailButton.center = CGPointMake(thumbnailButton.centerX+40, thumbnailButton.centerY);
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1
          initialSpringVelocity:0.6 options:UIViewAnimationOptionAllowUserInteraction  animations:^(){
              thumbnailButton.alpha = 1.0;
             thumbnailButton.center = CGPointMake(thumbnailButton.centerX-40, thumbnailButton.centerY);
              if (thumbnailButton.right+kScrollViewPadding-self.scrollView.width>0) {
                  self.scrollView.contentOffset = CGPointMake(thumbnailButton.right+kScrollViewPadding-self.scrollView.width, 0);
              }
              
          } completion:^(BOOL finished) {
          }];
    [self.scrollView addSubview:thumbnailButton];
    self.scrollView.contentSize = CGSizeMake(thumbnailButton.right+kScrollViewPadding, self.scrollView.height);
    [self updateThumbnailFrames];
}

-(void)removeThumbnailButton:(UIButton *)button{
    CGSize thumbnailSize = CGSizeMake(self.scrollView.height-kScrollViewPadding*2, self.scrollView.height-kScrollViewPadding*2);
    CGSize targetContentSize = CGSizeMake(kScrollViewPadding*(self.thumbnailArray.count)+thumbnailSize.width*(self.thumbnailArray.count-1), self.scrollView.height);
    BOOL needsAdjustScrollView;
    if (self.scrollView.contentOffset.x+self.scrollView.width>targetContentSize.width && self.scrollView.contentOffset.x > 0) {
        needsAdjustScrollView = YES;
    }
    button.userInteractionEnabled = NO;
    [self.thumbnailArray removeObjectAtIndex:button.tag];
    [self.assetArray removeObjectAtIndex:button.tag];
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1
          initialSpringVelocity:0.6 options:UIViewAnimationOptionAllowUserInteraction  animations:^(){
              button.alpha = 0.0;
              button.transform = CGAffineTransformMakeScale(0.01, 0.01);
              if (needsAdjustScrollView) {
                  if (targetContentSize.width<self.scrollView.width) {
                      self.scrollView.contentOffset = CGPointZero;
                  }else{
                      self.scrollView.contentOffset = CGPointMake(targetContentSize.width-self.scrollView.width, 0);
                  }
              }
          } completion:^(BOOL finished) {
              [button removeFromSuperview];
              self.scrollView.contentSize = CGSizeMake(kScrollViewPadding*(self.thumbnailArray.count+1)+thumbnailSize.width*self.thumbnailArray.count, self.scrollView.height);
          }];
    
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1
          initialSpringVelocity:0.6 options:UIViewAnimationOptionAllowUserInteraction  animations:^(){
              [self updateThumbnailFrames];
          } completion:^(BOOL finished) {
              
              
          }];
    
}

-(void)updateThumbnailFrames{
    NSInteger index = 0;
    for(UIButton *button in self.thumbnailArray){
        button.frame = CGRectMake(kScrollViewPadding*(index+1)+button.width*index, kScrollViewPadding, button.width, button.height);
        button.tag = index;
        index++;
    }
    self.currentCount = self.assetArray.count;
    NSLog(@"%@",self.assetArray);
}

-(void)toggleNext{
    if (self.finishSelection) {
        self.finishSelection(self.assetArray);
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.topBar.frame = CGRectMake(0, 0, self.width-self.nextButton.width, self.topBar.height);
    self.topTitle.frame = CGRectMake(10, 0, self.topBar.width-20, self.topBar.height);
    self.selectionCount.frame = CGRectMake(10, (self.topBar.height-self.selectionCount.height)/2, self.selectionCount.width, self.selectionCount.height);
    self.nextLabel.frame = CGRectMake(self.selectionCount.right+5, 0, self.nextButton.width-self.selectionCount.right-5*2, self.nextButton.height);
    self.scrollView.frame = CGRectMake(0, self.topBar.bottom, self.width, self.scrollView.height);
}

-(void)setCurrentCount:(NSInteger)currentCount{
    _currentCount = currentCount;
    self.selectionCount.text = [NSString stringWithFormat:@"%ld",(long)_currentCount];
}

-(UIView *)topBar{
    if (!_topBar) {
        _topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, HEIGHT_NAV)];
        _topBar.backgroundColor = [UIColor blackColor];
    }
    return _topBar;
}

-(UILabel *)topTitle{
    if (!_topTitle) {
        _topTitle = [[UILabel alloc] init];
        _topTitle.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        _topTitle.font = [UIFont systemFontOfSize:14];
    }
    return _topTitle;
}

-(UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width-100, 0, 100, HEIGHT_NAV)];
        _nextButton.backgroundColor = THEME_COLOR;
        [_nextButton addTarget:self action:@selector(toggleNext) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

-(UILabel *)selectionCount{
    if (!_selectionCount) {
        _selectionCount = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, HEIGHT_NAV-20, HEIGHT_NAV-20)];
        _selectionCount.font = [UIFont systemFontOfSize:14];
        _selectionCount.textAlignment = NSTextAlignmentCenter;
        _selectionCount.backgroundColor = [UIColor whiteColor];
        _selectionCount.textColor = THEME_COLOR;
        _selectionCount.layer.cornerRadius = 4;
        _selectionCount.layer.masksToBounds = YES;
        _selectionCount.userInteractionEnabled = NO;
    }
    return _selectionCount;
}

-(UILabel *)nextLabel{
    if (!_nextLabel) {
        _nextLabel = [[UILabel alloc] init];
        _nextLabel.text = @"下一步";
        _nextLabel.textColor = [UIColor whiteColor];
        _nextLabel.userInteractionEnabled = NO;
    }
    return _nextLabel;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topBar.bottom, self.width, kBottomHeight-self.topBar.height)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

-(NSMutableArray *)assetArray{
    if (!_assetArray) {
        _assetArray = [[NSMutableArray alloc] init];
    }
    return _assetArray;
}

-(NSMutableArray *)thumbnailArray{
    if (!_thumbnailArray) {
        _thumbnailArray = [[NSMutableArray alloc] init];
    }
    return _thumbnailArray;
}

@end
