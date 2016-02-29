//
//  PTPPJigsawView.m
//  PTPPCamera
//
//  Created by CHEN KAIDI on 29/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "PTPPJigsawView.h"
#import "PTPPJigsawCell.h"

@interface PTPPJigsawView ()
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) PTPPJigsawTemplateModel *templateModel;
@end

@implementation PTPPJigsawView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
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
        PTPPJigsawCell *cell = [[PTPPJigsawCell alloc] initWithFrame:boundingRect];
        [cell setAttributeWithImage:[images safeObjectAtIndex:index] maskPointArray:pointArray];
        [self addSubview:cell];
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

@end
