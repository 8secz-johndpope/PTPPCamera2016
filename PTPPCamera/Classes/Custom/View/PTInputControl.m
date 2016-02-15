//
//  PTInputControl.m
//  PTLatitude
//
//  Created by so on 15/11/29.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTInputControl.h"

@interface PTInputControl () <UITextFieldDelegate>
@property (strong, nonatomic, readonly) UIButton *subButton;
@property (strong, nonatomic, readonly) UITextField *textField;
@property (strong, nonatomic, readonly) UIButton *addButton;
@end

@implementation PTInputControl
@synthesize subButton = _subButton;
@synthesize textField = _textField;
@synthesize addButton = _addButton;
@dynamic value;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        [self addSubview:self.subButton];
        [self addSubview:self.textField];
        [self addSubview:self.addButton];
        self.horizontalSpace = 0.5f;
        _minValue = 1;
        _maxValue = 99;
        _stepValue = 1;
        self.value = 1;
        self.textColor = [UIColor grayColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return (self);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect inFrame = UIEdgeInsetsInsetRect(self.bounds, self.contentInsets);
    self.subButton.frame = CGRectMake(CGRectGetMinX(inFrame), CGRectGetMinY(inFrame), CGRectGetHeight(inFrame), CGRectGetHeight(inFrame));
    self.textField.frame = CGRectMake(self.subButton.right + self.horizontalSpace, self.subButton.top, CGRectGetWidth(inFrame) - 2 * (self.subButton.width + self.horizontalSpace), self.subButton.height);
    self.addButton.frame = CGRectMake(self.textField.right + self.horizontalSpace, self.textField.top, self.subButton.width, self.subButton.height);
}

#pragma mark - getter
- (UIButton *)subButton {
    if(!_subButton) {
        _subButton = [[UIButton alloc] init];
        [_subButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_subButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [_subButton setTitle:@"-" forState:UIControlStateNormal];
        [_subButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_subButton addTarget:self action:@selector(subButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        _subButton.layer.cornerRadius = 2;
        _subButton.clipsToBounds = YES;
    }
    return (_subButton);
}

- (UITextField *)textField {
    if(!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.textColor = [UIColor blackColor];
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.delegate = self;
        _textField.layer.cornerRadius = 2;
        _textField.clipsToBounds = YES;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return (_textField);
}

- (UIButton *)addButton {
    if(!_addButton) {
        _addButton = [[UIButton alloc] init];
        [_addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [_addButton setTitle:@"+" forState:UIControlStateNormal];
        [_addButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_addButton addTarget:self action:@selector(addButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        _addButton.layer.cornerRadius = 2;
        _addButton.clipsToBounds = YES;
    }
    return (_addButton);
}

- (NSInteger)value {
    return ([[self.textField text] integerValue]);
}
#pragma mark -

#pragma mark - setter
- (void)setValue:(NSInteger)value {
    NSInteger tValue = MIN(self.maxValue, MAX(self.minValue, value));
    self.textField.text = [@(tValue) stringValue];
    if(self.delegate && [self.delegate respondsToSelector:@selector(inputControl:didChangeValue:)]) {
        [self.delegate inputControl:self didChangeValue:tValue];
    }
}

- (void)setMinValue:(NSInteger)minValue {
    _minValue = minValue;
    if(self.value < _minValue) {
        self.value = _minValue;
    }
}

- (void)setMaxValue:(NSInteger)maxValue {
    _maxValue = maxValue;
    if(self.value > _maxValue) {
        self.value = _maxValue;
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    [self.subButton setBackgroundColor:_backgroundColor];
    [self.textField setBackgroundColor:_backgroundColor];
    [self.addButton setBackgroundColor:_backgroundColor];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self.subButton setTitleColor:_textColor forState:UIControlStateNormal];
    [self.textField setTextColor:_textColor];
    [self.addButton setTitleColor:_textColor forState:UIControlStateNormal];
}
#pragma mark -

#pragma mark - action
- (void)subButtonTouched:(id)sender {
    self.value -= self.stepValue;
}

- (void)addButtonTouched:(id)sender {
    self.value += self.stepValue;
}
#pragma mark -

#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(self.delegate && [self.delegate respondsToSelector:@selector(inputControl:textFieldShouldBeginEditing:)]) {
        return ([self.delegate inputControl:self textFieldShouldBeginEditing:textField]);
    }
    return (YES);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if(self.delegate && [self.delegate respondsToSelector:@selector(inputControl:textFieldDidBeginEditing:)]) {
        [self.delegate inputControl:self textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if(self.delegate && [self.delegate respondsToSelector:@selector(inputControl:textFieldShouldEndEditing:)]) {
        return ([self.delegate inputControl:self textFieldShouldEndEditing:textField]);
    }
    return (YES);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(self.delegate && [self.delegate respondsToSelector:@selector(inputControl:textFieldDidEndEditing:)]) {
        [self.delegate inputControl:self textFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(self.delegate && [self.delegate respondsToSelector:@selector(inputControl:textField:shouldChangeCharactersInRange:replacementString:)]) {
        BOOL should = [self.delegate inputControl:self textField:textField shouldChangeCharactersInRange:range replacementString:string];
        return (should);
    }
    return (YES);
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if(self.delegate && [self.delegate respondsToSelector:@selector(inputControl:textFieldShouldClear:)]) {
        return ([self.delegate inputControl:self textFieldShouldClear:textField]);
    }
    return (YES);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(self.delegate && [self.delegate respondsToSelector:@selector(inputControl:textFieldShouldReturn:)]) {
        return ([self.delegate inputControl:self textFieldShouldReturn:textField]);
    }
    return (YES);
}
#pragma mark -

#pragma mark - <KVO>
- (void)textFieldDidChanged:(NSNotification *)notification {
    if(notification && notification.object == self.textField) {
        self.value = [self.textField.text integerValue];
    }
}
#pragma mark -

@end
