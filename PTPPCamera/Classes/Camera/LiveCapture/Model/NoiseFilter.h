
#import <Foundation/Foundation.h>

@interface NoiseFilter : NSObject
// 数据长度
@property int dataLength;

// 保存数据
@property NSMutableArray * dataArray;


// 初始化
- (id) initWithDataLength:(int) length;
// 过滤数据
- (float) noiseFilterWithData:(float) data;
@end
