//
//  PTPPJigsawView.m
//  PTPPCamera
//
//  Created by CHEN KAIDI on 29/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//
#import "CombinationImageView.h"
#import "CombinationMovingView.h"
#import "PTPPJigsawView.h"
#import "PTPPJigsawCell.h"

@interface PTPPJigsawView (){
    CombinationMovingView *movingView; //the view moving
    float distanceWidth;
    float distanceHeight;
    CombinationImageView *selectedView;
    CombinationImageView *benginView;
}
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) PTPPJigsawTemplateModel *templateModel;
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
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(photoLongPressed:)];
        longPress.numberOfTouchesRequired = 1;
        [elementView addGestureRecognizer:longPress];
        [self addSubview:elementView];
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
        benginView = pressedView;
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
            UIImage *temp = benginView.imageview.image;
            [benginView setup];
            [benginView setImageViewData:selectedView.imageview.image];
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


@end
