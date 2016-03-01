//
//  PTPPJigsawView.m
//  PTPPCamera
//
//  Created by CHEN KAIDI on 29/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//
#import "ELCImagePickerHeader.h"
#import "CombinationImageView.h"
#import "PTPPJigsawViewPopup.h"
#import "CombinationMovingView.h"
#import "PTPPJigsawView.h"
#import "PTPPJigsawCell.h"
#import "PTPPImageUtil.h"
#import "AssetHelper.h"

@interface PTPPJigsawView ()<ELCImagePickerControllerDelegate>
{
    CombinationMovingView *movingView; //the view moving
    float distanceWidth;
    float distanceHeight;
    CombinationImageView *selectedView;
    CombinationImageView *beginView;
}

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) PTPPJigsawTemplateModel *templateModel;
@property (nonatomic, strong) PTPPJigsawViewPopup *popup;
@end

@implementation PTPPJigsawView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        movingView = [[CombinationMovingView alloc] initWithFrame:CGRectZero];
        movingView.hidden = true;
        [self addSubview:movingView];
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)setAttributeWithTemplateModel:(PTPPJigsawTemplateModel *)templateModel images:(NSArray *)images{
    self.templateModel = templateModel;
    self.images = images;
    NSInteger index = 0;
    for(NSMutableArray *maskArray in self.templateModel.maskPointArray){
        NSMutableArray *pointArray = [[NSMutableArray alloc] init];
        for(NSString *pointStr in maskArray){
            CGPoint point = [self getPointFromString:pointStr];
            CGFloat ratio = templateModel.imageSize.width/self.width;
            CGPoint newPoint = CGPointMake(point.x/ratio, point.y/ratio);
//            UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(newPoint.x-5, newPoint.y-5, 10, 10)];
//            dot.layer.cornerRadius = 5;
//            dot.layer.masksToBounds = YES;
//            dot.backgroundColor = [UIColor redColor];
//            [self addSubview:dot];
            [pointArray addObject:[NSValue valueWithCGPoint:newPoint]];
        }
        CGRect boundingRect = [self getBoundingRectFromPointArray:pointArray];
        NSLog(@"%@",pointArray);
        NSLog(@"bouding:%@",NSStringFromCGRect(boundingRect));
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        for (NSInteger i=0; i<pointArray.count; i++) {
            CGPoint p = [[pointArray safeObjectAtIndex:i] CGPointValue];
            CGPoint newPoint = CGPointMake(p.x-boundingRect.origin.x, p.y-boundingRect.origin.y);
            if (i==0) {
                [path moveToPoint:newPoint];
            }else{
                [path addLineToPoint:newPoint];
            }
            
        }
        [path closePath];
        
//        PTPPJigsawCell *cell = [[PTPPJigsawCell alloc] initWithFrame:boundingRect];
//        [cell setAttributeWithImage:[images safeObjectAtIndex:index] maskPointArray:pointArray];
//        [self addSubview:cell];
        
        CombinationImageView *elementView = [[CombinationImageView alloc] initWithFrame:boundingRect];
        elementView.tag = index+1000;           //self 视图tag默认为0
        elementView.realCellArea = path;
        [elementView setImageViewData:[images safeObjectAtIndex:index]];
        [self addSubview:elementView];
        if (images.count>1) {
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(photoLongPressed:)];
            longPress.numberOfTouchesRequired = 1;
            [elementView addGestureRecognizer:longPress];
        }
        UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [elementView addGestureRecognizer:singleRecognizer];
        index++;
    }
}

-(CGRect)getBoundingRectFromPointArray:(NSArray *)pointArray{
    CGRect rect = CGRectZero;
    CGFloat minX = INT_MAX;
    CGFloat maxX = 0;
    CGFloat minY = INT_MAX;
    CGFloat maxY = 0;
    for (int i = 0; i < [pointArray count]; i++) {
        
        CGPoint point = [[pointArray safeObjectAtIndex:i] CGPointValue];

        if (point.x <= minX) {
            minX = point.x;
        }
        if (point.x >= maxX) {
            maxX = point.x;
        }
        if (point.y <= minY) {
            minY = point.y;
        }
        if (point.y >= maxY) {
            maxY = point.y;
        }
        rect = CGRectMake(minX, minY, maxX - minX, maxY - minY);
    }
    
    return rect;
}

-(CGPoint)getPointFromString:(NSString *)pointStr{
    NSArray *strComponents = [pointStr componentsSeparatedByString:@","];
    if (strComponents.count == 2) {
        CGFloat x = [[strComponents objectAtIndex:0] floatValue];
        CGFloat y = [[strComponents objectAtIndex:1] floatValue];
        return CGPointMake(x, y);
    }
    return CGPointZero;
}

- (void)photoLongPressed:(UILongPressGestureRecognizer *)gesture
{
    CombinationImageView *pressedView = (id)[gesture view];
    CGPoint subPoint = [gesture locationInView:pressedView];
    
    if(gesture.state == UIGestureRecognizerStateBegan){
        CGPoint point = [gesture locationInView:self];
        movingView.hidden = false;
        movingView.frame = pressedView.frame;
        [self bringSubviewToFront:movingView];
        distanceWidth = point.x-subPoint.x;
        distanceHeight = point.y-subPoint.y;
        self.userInteractionEnabled = NO;
        beginView = pressedView;
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.7
              initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn  animations:^(){
                  pressedView.transform = CGAffineTransformMakeScale(0.8, 0.8);
              } completion:^(BOOL finished) { }];

    } else if(gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled){
        self.userInteractionEnabled = YES;
        movingView.hidden = true;
        NSArray *arrayViews = [self subviews];
        for(UIView *subview in arrayViews){
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7
                  initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn  animations:^(){
                      subview.transform = CGAffineTransformIdentity;
                  } completion:^(BOOL finished) { }];

        }
        if (selectedView!=nil) {
            UIImage *temp = beginView.imageview.image;
            [beginView setup];
            [beginView setImageViewData:selectedView.imageview.image];
            [selectedView setup];
            [selectedView setImageViewData:temp];
            selectedView=nil;
        }
    } else if(gesture.state == UIGestureRecognizerStateChanged){
        CGPoint point = [gesture locationInView:self];
        
        movingView.center = CGPointMake(point.x, point.y);
        BOOL isMatched = false;
        NSArray *arrayViews = [self subviews];
        for (int i=0; i<[arrayViews count]; i++) {
            UIView *subView = [arrayViews objectAtIndex:i];
            if ([subView isKindOfClass:[CombinationImageView class]]) {
                if (CGRectContainsPoint(subView.frame, point)) {
                    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.7
                          initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn  animations:^(){
                              subView.transform = CGAffineTransformMakeScale(0.8, 0.8);
                          } completion:^(BOOL finished) { }];
                    
                    isMatched = true;
                    selectedView= (CombinationImageView*)subView;
                    movingView.frame = CGRectMake(movingView.left, movingView.top, selectedView.width, selectedView.height);
                }else{
                    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.7
                          initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn  animations:^(){
                              subView.transform = CGAffineTransformIdentity;
                          } completion:^(BOOL finished) { }];
                    
                }
                
                
            }
        }
        if (!isMatched) {
            selectedView = nil;
        }else {
            //            [UIView beginAnimations:@"SelectedViewMoved"context:NULL];
            //            [UIView setAnimationDelegate:self];
            //            [UIView setAnimationDuration:0.3];
            //            movingView.frame = selectedView.frame;
            //            [UIView commitAnimations];
        }
    }
}

-(void)singleTap:(UITapGestureRecognizer *)gesture{

    __weak typeof(self) weakSelf = self;
    self.popup.hidden = !self.popup.hidden;
    if (!self.popup.hidden) {
        self.popup.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.popup.alpha = 0.0;
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4
              initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn  animations:^(){
                  self.popup.transform = CGAffineTransformIdentity;
                  self.popup.alpha = 1.0;
              } completion:^(BOOL finished) { }];

    }
    CombinationImageView *pressedView = (id)[gesture view];
    beginView = pressedView;
   
    self.popup.toolSelected = ^(NSInteger index){
        switch (index) {
            case 0:
                [weakSelf swapSelectedImage];
                weakSelf.popup.hidden = YES;
                break;
            case 1:
                [weakSelf rotateSelectedImage];
                break;
            case 2:
                [weakSelf flipSelectedImage];
                break;
            default:
                break;
        }
    };
   self.popup.center = [gesture locationInView:self];
    
}

-(void)swapSelectedImage{
    if (ASSETHELPER.assetArray.count>0) {
        [self displayPickerForGroup:[ASSETHELPER.assetArray objectAtIndex:0]];
    }
}

-(void)rotateSelectedImage{
    UIImage *rotatedImage =  [PTPPImageUtil image:beginView.imageview.image rotatedByDegrees:90];
    [beginView setup];
    [beginView setImageViewData:rotatedImage];
}

-(void)flipSelectedImage{
    UIImage *flippedImage =  [PTPPImageUtil image:beginView.imageview.image flip:0];
    [beginView setup];
    [beginView setImageViewData:flippedImage];
}

- (void)displayPickerForGroup:(ALAssetsGroup *)group
{
    ELCAssetTablePicker *tablePicker = [[ELCAssetTablePicker alloc] initWithStyle:UITableViewStylePlain];
    tablePicker.singleSelection = YES;
    tablePicker.immediateReturn = YES;
    
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:tablePicker];
    elcPicker.maximumImagesCount = 1;
    elcPicker.imagePickerDelegate = self;
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = NO; //For single image selection, do not display and return order of selected images
    tablePicker.parent = elcPicker;
    
    // Move me
    tablePicker.assetGroup = group;
    [tablePicker.assetGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    
    [self.originalVC presentViewController:elcPicker animated:YES completion:nil];
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self.originalVC dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                [images addObject:image];
                
                UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
                [imageview setContentMode:UIViewContentModeScaleAspectFit];
                
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        }
    }
    
    UIImage *chosenImage = [images safeObjectAtIndex:0];
    if (chosenImage) {
        [beginView setup];
        [beginView setImageViewData:chosenImage];
    }
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self.originalVC dismissViewControllerAnimated:YES completion:nil];
}


-(PTPPJigsawViewPopup *)popup{
    if (!_popup) {
        _popup = [[PTPPJigsawViewPopup alloc] init];
        [[UIApplication sharedApplication].keyWindow addSubview:self.popup];
        self.popup.hidden = YES;
    }
    return _popup;
}

@end
