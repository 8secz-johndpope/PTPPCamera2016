//
//  PTTextView.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/28.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTTextView.h"

@interface PTTextView ()
@property (nonatomic , strong) UILabel *placeholderLabel; //这里先拿出这个label以方便我们后面的使用
@end

@implementation PTTextView
@synthesize placeholderLabel = _placeholderLabel;

- (void)dealloc{
    
//    [super dealloc];
    
    [[NSNotificationCenter defaultCenter]removeObserver:UITextViewTextDidChangeNotification];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if(self) {
        
        self.backgroundColor= [UIColor clearColor];
        
        [self addSubview:self.placeholderLabel];
    
        self.myPlaceholderColor= [UIColor lightGrayColor]; //设置占位文字默认颜色
        self.font= [UIFont systemFontOfSize:15]; //设置默认的字体
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self]; //通知:监听文字的改变
        
    }
    
    return self;
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.placeholderLabel.y=8; //设置UILabel 的 y值
    self.placeholderLabel.x=5;//设置 UILabel 的 x 值
    self.placeholderLabel.width=self.width-self.placeholderLabel.x*2.0; //设置 UILabel 的 x
    
    //根据文字计算高度
    CGSize maxSize =CGSizeMake(self.placeholderLabel.width,MAXFLOAT);
    
    //至少要包含 NSStringDrawingUsesLineFragmentOrigin NSStringDrawingUsesFontLeading  这两个属性
    self.placeholderLabel.height= [self.myPlaceholder boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.placeholderLabel.font} context:nil].size.height;
    
}


#pragma mark - Getter
- (UILabel *)placeholderLabel{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _placeholderLabel.backgroundColor= [UIColor clearColor];
        _placeholderLabel.font = [UIFont systemFontOfSize:16.0f];
        _placeholderLabel.numberOfLines=0; //设置可以输入多行文字时可以自动换行
    }
    return _placeholderLabel;
}
#pragma mark -


#pragma mark - Action
#pragma mark -监听文字改变

- (void)textDidChange {
    //hasText  是一个 系统的 BOOL  属性，如果 UITextView 输入了文字  hasText 就是 YES，反之就为 NO
    self.placeholderLabel.hidden = self.hasText;
}

#pragma mark -


#pragma mark - Overwrite
- (void)setMyPlaceholder:(NSString*)myPlaceholder{
    
    _myPlaceholder= [myPlaceholder copy];
    
    //设置文字
    
    self.placeholderLabel.text= myPlaceholder;
    
    //重新计算子控件frame
    [self setNeedsLayout];
    
}

- (void)setMyPlaceholderColor:(UIColor *)myPlaceholderColor{
    
    _myPlaceholderColor= myPlaceholderColor;
    
    //设置颜色
    self.placeholderLabel.textColor= myPlaceholderColor;
    
}

//重写这个set方法保持font一致

- (void)setFont:(UIFont*)font {
    
    [super setFont:font];
    
    self.placeholderLabel.font= font;
    
    //重新计算子控件frame
    
    [self setNeedsLayout];
    
}

- (void)setText:(NSString*)text{
    
    [super setText:text];
    
    [self textDidChange]; //这里调用的就是 UITextViewTextDidChangeNotification 通知的回调
    
}

- (void)setAttributedText:(NSAttributedString*)attributedText {
    
    [super setAttributedText:attributedText];
    
    [self textDidChange]; //这里调用的就是UITextViewTextDidChangeNotification 通知的回调
    
}

#pragma mark -


@end
