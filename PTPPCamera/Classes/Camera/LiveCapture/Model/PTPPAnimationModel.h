//
//  PTPPAnimationModel.h
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 8/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTPPAnimationModel : NSObject
// 动画宽度
@property int width;
// 动画高度
@property int height;
// 如果是眼部动画，两眼距离
@property int distance;
// 动画中心点，眼睛对应两眼中心在图像中的坐标
@property int centerX;
@property int centerY;
// 每一帧动画的停留时间
@property float duration;
// 动画图片名字列表
@property NSMutableArray * imageList;
@end
