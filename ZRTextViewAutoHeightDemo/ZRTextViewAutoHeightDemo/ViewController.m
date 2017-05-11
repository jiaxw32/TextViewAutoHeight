//
//  ViewController.m
//  ZRTextViewAutoHeightDemo
//
//  Created by jiaxw-mac on 2017/5/11.
//  Copyright © 2017年 jiaxw32. All rights reserved.
//

#import "ViewController.h"
#import "ZRMarcos.h"

@interface ViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *textContentView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textContentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.textContentView.layer.borderWidth = 1.0f;
    self.textContentView.layer.borderColor = [UIColorFromRGB(0xDDDDDD) CGColor];
    
//    self.textView.layer.borderColor = [UIColorFromRGB(0x444444) CGColor];
    self.textView.layer.cornerRadius = 4.0f;
    self.textView.contentInset = UIEdgeInsetsMake(kTextViewTopInset, 0, 0, 0);
//    self.textView.layer.borderWidth = 1.0f;
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.backgroundColor = UIColorFromRGB(0xEEEEEE);
    self.textView.delegate = self;
//    self.textView.scrollEnabled = NO;
    
    [_tapGesture addTarget:self action:@selector(onTap:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyBoardWillHide:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval time = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.textViewBottomConstraint.constant = 0;
    [UIView animateWithDuration:time animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyBoardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    
    CGRect frame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = frame.size.height - kTabBarHeight;
    
    NSTimeInterval time = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.textViewBottomConstraint.constant = height;
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
        self.textViewHeightConstraint.constant = kTextViewMinHeight;
        self.textContentViewHeightConstraint.constant = kTextViewMinHeight + 8 * 2;
    } else if (height > kTextViewMaxHeight){
        self.textViewHeightConstraint.constant = kTextViewMaxHeight;
        self.textContentViewHeightConstraint.constant = kTextViewMaxHeight + 8 * 2;
    } else {
        self.textViewHeightConstraint.constant = height;
        self.textContentViewHeightConstraint.constant = height + 8 * 2;
    }
    [UIView animateWithDuration:0.3f animations:^{
        [self.textContentView.superview layoutIfNeeded];
    } completion:nil];
}


@end
