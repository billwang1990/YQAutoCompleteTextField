//
//  YQAutoCompleteTextField.m
//  todoApp
//
//  Created by wangyaqing on 15/3/18.
//  Copyright (c) 2015年 billwang1990.github.com. All rights reserved.
//

#import "YQAutoCompleteTextField.h"
#import "UIView+YQExtension.h"

@interface YQAutoCompleteTextField ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *promptTable;
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) NSMutableArray *dataAfterFilter;
@end

@implementation YQAutoCompleteTextField

- (instancetype)init
{
    if (self = [super init]) {
        [self initialAutoCompleteTextField];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialAutoCompleteTextField];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initialAutoCompleteTextField];
    }
    
    return self;
}

/**
 *  custom initialize
 */
- (void)initialAutoCompleteTextField
{
    _promptDirection = PromptListViewDirectionDown;
    _promptLines = 5;
    _promptListViewHeight = 30;
    _autoFilter = YES;
    
    CGFloat margin = 1;
    
    _inputField = [[UITextField alloc]initWithFrame:CGRectMake(margin, margin, self.bounds.size.width - 2*margin, self.bounds.size.height - 2*margin)];
    _inputField.borderStyle = UITextBorderStyleRoundedRect;
    _inputField.delegate = self;
    
    self.clipsToBounds = NO;
    [self addSubview:_inputField];
    
}

- (NSMutableArray *)dataAfterFilter
{
    if (!_dataAfterFilter) {
        _dataAfterFilter = [[NSMutableArray alloc]init];
    }
    return _dataAfterFilter;
}

- (UITableView *)promptTable
{
    if (!_promptTable) {
        _promptTable = [[UITableView alloc]initWithFrame:CGRectMake(2, 0, self.bounds.size.width - 4, self.promptListViewHeight*self.promptLines)];
        _promptTable.delegate = self;
        _promptTable.dataSource = self;
        _promptTable.tableFooterView = [UIView new];
        [_promptTable setShowsVerticalScrollIndicator:NO];
        [_promptTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        _promptTable.backgroundColor = RGB(250, 250, 250);
//        _promptTable.layer.borderColor = [UIColor blackColor].CGColor;
//        _promptTable.layer.borderWidth = 1;
    
    }
    return _promptTable;
}

- (void)showPromptListView:(BOOL)show
{
    if (show) {
    
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textUpdated) name:UITextFieldTextDidChangeNotification object:self.inputField];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self.promptTable];
        [self adjustPromptListDirection];
        [self doAutoFilterAction];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.inputField];
        [self.promptTable removeFromSuperview];
        self.promptTable = nil;
    }
}

- (void)adjustPromptListDirection
{
    if(self.promptDirection == PromptListViewDirectionDown)
    {
        [self.promptTable setX:self.frame.origin.x+2];
        [self.promptTable setY:(self.frame.origin.y+self.frame.size.height)];
    }
    else
    {
        [self.promptTable setX:self.frame.origin.x+2];
        [self.promptTable setY:(self.frame.origin.y-self.promptTable.frame.size.height)];
    }
    
//    if (self.dataSourceArray.count < 5) {
//        [self.promptTable setHeight:(self.promptListViewHeight*self.dataSourceArray.count)];
//    }
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow bringSubviewToFront:self.promptTable];
    
}

- (NSString *)te
{
    return self.inputField.text;
}

- (void)textUpdated
{
    [self doAutoFilterAction];
}

- (void)doAutoFilterAction
{
    
    if (self.autoFilter) {
        
        NSString *inputContent = self.inputField.text;
        
        self.dataAfterFilter = [NSMutableArray arrayWithArray:self.dataSourceArray];
        
        if (inputContent && inputContent.length > 0) {
            
            [self.dataAfterFilter removeAllObjects];

            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",inputContent];
            
            NSArray *ret = [self.dataSourceArray filteredArrayUsingPredicate:pred];
            
            if ([ret isKindOfClass:[NSArray class]] && ret.count > 0) {
                [self.dataAfterFilter addObjectsFromArray:ret];
            }
        }
    }
 
    [self.promptTable reloadData];
}

#pragma mark UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.inputField]) {
        [self showPromptListView:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.inputField]) {
        [self showPromptListView:NO];
    }
}


#pragma mark UITableViewDelegate and UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.promptListViewHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.autoFilter ? self.dataAfterFilter.count : self.dataSourceArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    
    cell.textLabel.text = [[(self.autoFilter?self.dataAfterFilter:self.dataSourceArray) objectAtIndex:indexPath.row] description];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.inputField.text = (self.autoFilter?self.dataAfterFilter:self.dataSourceArray)[indexPath.row];
    
    [self endEditing:YES];

}

@end
