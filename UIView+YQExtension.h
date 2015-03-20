//
//  UIView+YQExtension.h
//  todoApp
//
//  Created by wangyaqing on 15/3/19.
//  Copyright (c) 2015年 billwang1990.github.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YQExtension)

-(void)setY:(CGFloat)y;
-(void)setX:(CGFloat)x;
-(void)setYNextToView:(UIView *)refView;
-(void)setHeight:(CGFloat)height;
-(void)setWidth:(CGFloat)width;

@end
