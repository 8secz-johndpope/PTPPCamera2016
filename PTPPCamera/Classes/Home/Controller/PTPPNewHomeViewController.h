//
//  PTPPNewHomeViewController.h
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 12/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "SOBaseViewController.h"

@protocol PTPPNewHomeProtocol <NSObject>

-(void)resumeFaceDetector;

@end

@interface PTPPNewHomeViewController : SOBaseViewController
@property (nonatomic, assign) id<PTPPNewHomeProtocol>delegate;
@end
