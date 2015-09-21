//
//  ViewController.m
//  FloatingTextFieldDemo
//
//  Created by liuge on 9/20/15.
//  Copyright (c) 2015 ZiXuWuYou. All rights reserved.
//

#import "ViewController.h"
#import "FloatingTextField.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FloatingTextField *emailTextField = [[FloatingTextField alloc] initWithFrame:(CGRect){20, 100, self.view.frame.size.width - 20 * 2, 45}];
    emailTextField.leftImage = [UIImage imageNamed:@"email"];
    emailTextField.placeholder = @"Your Email";
    [self.view addSubview:emailTextField];
    
    FloatingTextField *passwordTextField = [[FloatingTextField alloc] initWithFrame:CGRectOffset(emailTextField.frame, 0, 60)];
    passwordTextField.leftImage = [UIImage imageNamed:@"password"];
    passwordTextField.secureTextEntry = YES;
    passwordTextField.placeholder = @"Password";
    [self.view addSubview:passwordTextField];
    
    FloatingTextField *verifyTextField = [[FloatingTextField alloc] initWithFrame:CGRectOffset(passwordTextField.frame, 0, 60)];
    verifyTextField.placeholder = @"Verification Code";
    [self.view addSubview:verifyTextField];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
