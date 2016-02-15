
#import "NoiseFilter.h"

@implementation NoiseFilter

@synthesize dataLength;
@synthesize dataArray;

// 初始化方法，带参数
-(id) initWithDataLength:(int) length {
    // 调用父类init 生成类
    self = [super init];
    
    if (self) {
        // 执行自己的方法
        self.dataLength = length;
    }
    
    dataArray = [[NSMutableArray alloc] init];
    return self;
}

// 过滤数据外部接口
- (float) noiseFilterWithData:(float) data{
    [dataArray addObject:[NSNumber numberWithFloat:data]];
    if([dataArray count]<2) return data;
    
    if([dataArray count]> dataLength){
        [dataArray removeObjectAtIndex:0];
    }
    if(self.dataLength == 5) return [self getLinearSmooth5:dataArray];
    else return [self getAverageValue:dataArray];
}


// 求平均值
- (float) getAverageValue:(NSMutableArray *) dataArr{
    if([dataArr count] == 0) return  0;
    float total = 0;
    for(int  i = 0; i< [dataArr count]; i++){
        total = total + [[dataArr objectAtIndex:i] floatValue];
    }
    return total/[dataArr count];
}

// 5点平滑算法
- (float) getLinearSmooth5:(NSMutableArray *) dataArr{
    if([dataArr count]<5) return [[dataArr objectAtIndex:[dataArr count] -1] floatValue];
    return ( 3.0 * [[dataArr objectAtIndex:4] floatValue] + 2.0 * [[dataArr objectAtIndex:3] floatValue] + [[dataArr objectAtIndex:2] floatValue] - [[dataArr objectAtIndex:0] floatValue] ) / 5.0;

}



/* 三点 5点 7点平滑算法
 void linearSmooth3 ( double in[], double out[], int N )
 {
 int i;
 if ( N < 3 )
 {
 for ( i = 0; i <= N - 1; i++ )
 {
 out[i] = in[i];
 }
 }
 else
 {
 out[0] = ( 5.0 * in[0] + 2.0 * in[1] - in[2] ) / 6.0;
 
 for ( i = 1; i <= N - 2; i++ )
 {
 out[i] = ( in[i - 1] + in[i] + in[i + 1] ) / 3.0;
 }
 
 out[N - 1] = ( 5.0 * in[N - 1] + 2.0 * in[N - 2] - in[N - 3] ) / 6.0;
 }
 }
 
 void linearSmooth5 ( double in[], double out[], int N )
 {
 int i;
 if ( N < 5 )
 {
 for ( i = 0; i <= N - 1; i++ )
 {
 out[i] = in[i];
 }
 }
 else
 {
 out[0] = ( 3.0 * in[0] + 2.0 * in[1] + in[2] - in[4] ) / 5.0;
 out[1] = ( 4.0 * in[0] + 3.0 * in[1] + 2 * in[2] + in[3] ) / 10.0;
 for ( i = 2; i <= N - 3; i++ )
 {
 out[i] = ( in[i - 2] + in[i - 1] + in[i] + in[i + 1] + in[i + 2] ) / 5.0;
 }
 out[N - 2] = ( 4.0 * in[N - 1] + 3.0 * in[N - 2] + 2 * in[N - 3] + in[N - 4] ) / 10.0;
 out[N - 1] = ( 3.0 * in[N - 1] + 2.0 * in[N - 2] + in[N - 3] - in[N - 5] ) / 5.0;
 }
 }
 
 void linearSmooth7 ( double in[], double out[], int N )
 {
 int i;
 if ( N < 7 )
 {
 for ( i = 0; i <= N - 1; i++ )
 {
 out[i] = in[i];
 }
 }
 else
 {
 out[0] = ( 13.0 * in[0] + 10.0 * in[1] + 7.0 * in[2] + 4.0 * in[3] +
 in[4] - 2.0 * in[5] - 5.0 * in[6] ) / 28.0;
 
 out[1] = ( 5.0 * in[0] + 4.0 * in[1] + 3 * in[2] + 2 * in[3] +
 in[4] - in[6] ) / 14.0;
 
 out[2] = ( 7.0 * in[0] + 6.0 * in [1] + 5.0 * in[2] + 4.0 * in[3] +
 3.0 * in[4] + 2.0 * in[5] + in[6] ) / 28.0;
 
 for ( i = 3; i <= N - 4; i++ )
 {
 out[i] = ( in[i - 3] + in[i - 2] + in[i - 1] + in[i] + in[i + 1] + in[i + 2] + in[i + 3] ) / 7.0;
 }
 
 out[N - 3] = ( 7.0 * in[N - 1] + 6.0 * in [N - 2] + 5.0 * in[N - 3] +
 4.0 * in[N - 4] + 3.0 * in[N - 5] + 2.0 * in[N - 6] + in[N - 7] ) / 28.0;
 
 out[N - 2] = ( 5.0 * in[N - 1] + 4.0 * in[N - 2] + 3.0 * in[N - 3] +
 2.0 * in[N - 4] + in[N - 5] - in[N - 7] ) / 14.0;
 
 out[N - 1] = ( 13.0 * in[N - 1] + 10.0 * in[N - 2] + 7.0 * in[N - 3] +
 4 * in[N - 4] + in[N - 5] - 2 * in[N - 6] - 5 * in[N - 7] ) / 28.0;
 }
 }
 */


@end
