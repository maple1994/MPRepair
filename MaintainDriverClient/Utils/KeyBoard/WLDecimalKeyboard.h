//
//  WLDecimalKeyboard.h
//  customkeyboard
//
//  Created by Wayne on 16/6/12.
//  Copyright © 2016年 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    WLKeyBoadyTypeDecialPad,
    WLKeyBoadyTypeNumberPad
} WLKeyBoadyType;

@interface WLDecimalKeyboard : UIView
/// 主色调（针对确定按钮）
@property (nonatomic) UIColor *tintColor;
/// 点击确定执行的回调
@property (copy, nonatomic, nullable) void (^done)();

- (instancetype)initWithTintColor:(UIColor *)tintColor;
- (instancetype)initWithType: (WLKeyBoadyType)type;

@end

NS_ASSUME_NONNULL_END
