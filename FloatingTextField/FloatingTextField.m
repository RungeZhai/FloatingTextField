//
//  FloatingTextField.m
//  FloatingTextFieldDemo
//
//  Created by liuge on 9/20/15.
//  Copyright (c) 2015 ZiXuWuYou. All rights reserved.
//

#import "FloatingTextField.h"

typedef enum : NSUInteger {
    FloatingTextFieldStateNormal,
    FloatingTextFieldStateFloating
} FloatingTextFieldState;

static CGFloat scale = .7;  // floatingView's scale when floating up
static NSTimeInterval animationDuration = .35;
static CGFloat borderCornerRadius = 2;

@interface FloatingTextField ()<UITextFieldDelegate> {
    UIEdgeInsets _contentInsets;
}

@property (strong, nonatomic) UIView *floatingView;

@property (strong, nonatomic) UIImageView *leftImageView;

@property (strong, nonatomic) UIInSetsLabel *placeholderLabel;

@property (assign, nonatomic) id<UITextFieldDelegate> realDelegate;

@property (nonatomic) FloatingTextFieldState currentState;

@property (strong, nonatomic) CAShapeLayer *borderLayer;

@end

@implementation FloatingTextField

#pragma mark - lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.delegate = self;
    self.clipsToBounds = NO;
    [self initInterface];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        [self initInterface];
    }
    
    return self;
}

- (void)initInterface {
    
    _floatingView = [UIView new];
    _floatingView.backgroundColor = [UIColor clearColor];
    _floatingView.userInteractionEnabled = NO;
    [self addSubview:_floatingView];
    
    _leftImageView = [UIImageView new];
    _leftImageView.backgroundColor = [UIColor clearColor];
    _leftImageView.contentMode = UIViewContentModeCenter;
    [_floatingView addSubview:_leftImageView];
    
    _placeholderLabel = [UIInSetsLabel new];
    _placeholderLabel.font = self.font;
    _placeholderLabel.textColor = [UIColor colorWithRed:149 / 255.f green:149 / 255.f blue:149 / 255.f alpha:1];
    _placeholderLabel.backgroundColor = [UIColor clearColor];
    [_floatingView addSubview:_placeholderLabel];
    
    _borderLayer = [CAShapeLayer layer];
    _borderLayer.fillColor = [UIColor clearColor].CGColor;
    _borderLayer.strokeColor = [UIColor blackColor].CGColor;
    _borderLayer.lineWidth = 1 / [UIScreen mainScreen].scale;
    [self.layer addSublayer:_borderLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self adjustSubviews];
}

- (void)adjustSubviews {
    
    _contentInsets = (UIEdgeInsets){0, self.bounds.size.height / 5, 0, self.bounds.size.height / 5};
    
    _floatingView.transform = CGAffineTransformIdentity;
    
    CGSize placeholderSize = [self sizeOfText:_placeholderLabel.text withFont:_placeholderLabel.font];
    CGFloat placeholderContentInsetsRight = _contentInsets.left;
    CGFloat placeholderContentInsetsLeft = _leftImageView.image ? 0 : placeholderContentInsetsRight;
    placeholderSize.width += placeholderContentInsetsLeft + placeholderContentInsetsRight;
    
    _leftImageView.frame = (CGRect){.origin = CGPointZero, .size = (CGSize){_leftImageView.image ? self.bounds.size.height : 0, self.bounds.size.height}};
    _floatingView.frame = (CGRect){.origin = CGPointZero, .size = (CGSize){_leftImageView.bounds.size.width + placeholderSize.width, self.bounds.size.height}};
    _placeholderLabel.frame = (CGRect){_leftImageView.bounds.size.width, 0, placeholderSize.width, _floatingView.bounds.size.height};
    
    _placeholderLabel.contentInsets = (UIEdgeInsets){0, placeholderContentInsetsLeft, 0, placeholderContentInsetsRight};
    
    [self adjustAllAnimated:NO];
}


#pragma mark - Transition

- (void)transitToState:(FloatingTextFieldState)state animated:(BOOL)animated {
    if (_currentState != state) {
        _currentState = state;
        
        [self adjustAllAnimated:YES];
    }
}

- (void)adjustAllAnimated:(BOOL)animated {
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    CGFloat startX = self.bounds.size.height / 5;
    CGFloat width = _floatingView.bounds.size.width * scale;
    
    CGSize size = self.bounds.size;
    
    CGPoint startPoint = (CGPoint){size.width / 2, size.height};
    CGPoint bottomLeft = (CGPoint){0, size.height};
    CGPoint topLeft = (CGPoint){0, 0};
    CGPoint bottomRight = (CGPoint){size.width, size.height};
    CGPoint topRight = (CGPoint){size.width, 0};
    CGPoint endPointLeft = (CGPoint){startX + width / 2, 0};
    CGPoint endPointRight = endPointLeft;
    
    
    if (_currentState == FloatingTextFieldStateFloating) {
        transform = CGAffineTransformMake(scale, 0, 0, scale, startX + width / 2 - CGRectGetMidX(_floatingView.frame), -CGRectGetMidY(_floatingView.frame));
        
        endPointLeft = (CGPoint){startX, 0};
        endPointRight = (CGPoint){startX + width, 0};
        
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    // Left part
    CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
    CGPathAddArcToPoint(path, NULL, bottomLeft.x, bottomLeft.y, topLeft.x, topLeft.y, borderCornerRadius);
    CGPathAddArcToPoint(path, NULL, topLeft.x, topLeft.y, endPointLeft.x, endPointLeft.y, borderCornerRadius);
    CGPathAddLineToPoint(path, NULL, endPointLeft.x, endPointLeft.y);
    
    // right part
    CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
    CGPathAddArcToPoint(path, NULL, bottomRight.x, bottomRight.y, topRight.x, topRight.y, borderCornerRadius);
    CGPathAddArcToPoint(path, NULL, topRight.x, topRight.y, endPointRight.x, endPointRight.y, borderCornerRadius);
    CGPathAddLineToPoint(path, NULL, endPointRight.x, endPointRight.y);
    
    [UIView animateWithDuration:animated ? animationDuration : 0
                     animations:^{
                         _floatingView.transform = transform;
                     }];
    
    
    if (animated) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
        
        animation.duration = animationDuration;
        animation.fromValue = (id)_borderLayer.path;
        animation.toValue = (__bridge id)path;
        
        [_borderLayer addAnimation:animation forKey:@"path"];
    }
    
    _borderLayer.path = path;
}


#pragma mark - Setter & Getter

- (void)setText:(NSString *)text {
    if (_currentState == FloatingTextFieldStateNormal && text.length > 0) {
        [self transitToState:FloatingTextFieldStateFloating animated:NO];
    }
    
    [super setText:text];
}

- (void)setPlaceholder:(NSString *)placeholder {
    
    _placeholderLabel.text = placeholder;
    
    if (_currentState == FloatingTextFieldStateFloating) {
        [self adjustSubviews];
    }
}

- (void)setDelegate:(id<UITextFieldDelegate>)delegate {
    
    if (delegate == self) {
        [super setDelegate:delegate];
        _realDelegate = nil;
    } else {
        _realDelegate = delegate;
    }
}

- (id<UITextFieldDelegate>)delegate {
    return _realDelegate;
}

- (void)setLeftImage:(UIImage *)leftImage {
    
    BOOL shouldAdjustSubviews = ((leftImage && !_leftImageView.image) || (!leftImage && _leftImageView.image));
    
    _leftImageView.image = leftImage;
    
    if (shouldAdjustSubviews) {
        [self adjustSubviews];
    }
}


#pragma mark - Utilities

- (CGSize)sizeOfText:(NSString *)text withFont:(UIFont *)font {
    CGRect realRect = [text boundingRectWithSize:(CGSize){CGFLOAT_MAX, CGFLOAT_MAX}
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName : font}
                                         context:nil];
    
    return realRect.size;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self transitToState:FloatingTextFieldStateFloating animated:YES];
    
    if ([_realDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [_realDelegate textFieldShouldBeginEditing:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if (textField.text.length == 0) {
        [self transitToState:FloatingTextFieldStateNormal animated:YES];
    }
    if ([_realDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [_realDelegate textFieldShouldEndEditing:textField];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([_realDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [_realDelegate textFieldDidBeginEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([_realDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [_realDelegate textFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([_realDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [_realDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if ([_realDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [_realDelegate textFieldShouldClear:textField];
    }
    return YES;
}

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, _contentInsets);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, _contentInsets);
}

@end



@implementation UIInSetsLabel

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _contentInsets)];
}

@end
