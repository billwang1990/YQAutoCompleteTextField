//
//  UIView+YQExtension.m
//  todoApp
//
//  Created by wangyaqing on 15/3/19.
//  Copyright (c) 2015年 billwang1990.github.com. All rights reserved.
//

#import "UIView+YQExtension.h"

@implementation UIView (YQExtension)

-(void)setYNextToView:(UIView *)refView
{
    [self setFrame:CGRectMake(self.frame.origin.x, refView.frame.origin.y + refView.frame.size.height, self.frame.size.width, self.frame.size.height)];
}

-(void)setY:(CGFloat)y
{
    [self setFrame:CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height)];
}

- (void)setX:(CGFloat)x
{
    [self setFrame:CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
}

-(void)setHeight:(CGFloat)height
{
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height)];
}

-(void)setWidth:(CGFloat)width
{
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height)];
}

@end
