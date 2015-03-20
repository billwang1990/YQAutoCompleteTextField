//
//  YQAutoCompleteTextField.h
//  todoApp
//
//  Created by wangyaqing on 15/3/18.
//  Copyright (c) 2015年 billwang1990.github.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB(R,G,B) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:1.0]

@class YQAutoCompleteTextField;


typedef NS_ENUM(NSInteger, PromptListViewDirection)
{
    PromptListViewDirectionUp,
    PromptListViewDirectionDown
};

@interface YQAutoCompleteTextField : UIView

/**
 *  提示框行高，默认 30
 */
@property (nonatomic, assign) CGFloat promptListViewHeight;

/**
 *  最多可见提示的行数，默认为5
 */
@property (nonatomic, assign) NSInteger promptLines;

/**
 *  弹出方向
 */
@property (nonatomic, assign) PromptListViewDirection promptDirection;

/**
 *  是否自动根据输入过滤，默认YES
 */
@property (nonatomic, assign) BOOL autoFilter;

@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@property (nonatomic, readonly) NSString *text;

@end
