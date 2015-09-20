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
    // Do any additional setup after loading the view, typically from a nib.
    
    FloatingTextField *floatingTextField = [[FloatingTextField alloc] initWithFrame:(CGRect){50, 100, 200, 50}];
    floatingTextField.placeholder = @"Less Than 4 Characters";
    
    [self.view addSubview:floatingTextField];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
