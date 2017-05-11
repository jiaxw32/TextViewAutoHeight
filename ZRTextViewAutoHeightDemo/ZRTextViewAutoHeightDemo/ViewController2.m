//
//  ViewController2.m
//  ZRTextViewAutoHeightDemo
//
//  Created by jiaxw-mac on 2017/5/11.
//  Copyright © 2017年 jiaxw32. All rights reserved.
//

#import "ViewController2.h"
#import "ZRMarcos.h"
#import "Masonry.h"

@interface ViewController2 ()<UITextViewDelegate>

@property (nonatomic,strong) UITextView *textView;

@property (nonatomic,strong) UIView *textContentView;

@end

@implementation ViewController2

- (instancetype)init{
    if (self = [super init]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupViews{
    UIView *contentView = self.view;
    
    
    UIView *textContentView = ({
        UIView *v = [UIView new];
        v.backgroundColor = [UIColor whiteColor];
        v.layer.borderWidth = 1.0f;
        v.layer.borderColor = [UIColorFromRGB(0xDDDDDD) CGColor];
        [contentView addSubview:v];
        v;
    });
    [textContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(contentView);
        make.height.mas_equalTo(64);
    }];
    self.textContentView = textContentView;
    
    self.textView = ({
        UITextView *v = [[UITextView alloc] init];
        v.layer.cornerRadius = 4.0f;
        v.contentInset = UIEdgeInsetsMake(kTextViewTopInset, 0, 0, 0);
        v.font = [UIFont systemFontOfSize:16];
        v.backgroundColor = UIColorFromRGB(0xEEEEEE);
        v.delegate = self;
        [textContentView addSubview:v];
        v;
    });
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(textContentView).insets(UIEdgeInsetsMake(8, 6, 8, 100));
    }];
}


- (void)keyBoardWillHide:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval time = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [self.textContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(0);
    }];
    [UIView animateWithDuration:time animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyBoardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    
    CGRect frame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = frame.size.height - kTabBarHeight;
    
    NSTimeInterval time = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self.textContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-height);
    }];
    [UIView animateWithDuration:time animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)onTap:(UIGestureRecognizer *)gesture{
    [self.textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView{
    CGFloat height = textView.contentSize.height + kTextViewTopInset;
    if (height <= kTextViewMinHeight) {
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kTextViewMinHeight);
        }];
        [self.textContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kTextViewMinHeight + 8 * 2);
        }];
    } else if (height > kTextViewMaxHeight){
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kTextViewMaxHeight);
        }];
        [self.textContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kTextViewMaxHeight + 8 * 2);
        }];
    } else {
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
        [self.textContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height + 8 * 2);
        }];
    }
    [UIView animateWithDuration:0.3f animations:^{
        [self.textContentView.superview layoutIfNeeded];
    } completion:nil];
}


@end
