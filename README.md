# FloatingTextField
A UITextField subclass with the placeholder floating on the top.

###Demo
<img src="https://cloud.githubusercontent.com/assets/3366713/9984777/d891e464-6050-11e5-9a67-dd4eae6d960a.gif" width=304>

###Usage
Basically, just Initialize a TextField like you always did and set the `leftImage` and `placeholder`.
```objective-c
FloatingTextField *emailTextField = [[FloatingTextField alloc] initWithFrame:(CGRect){20, 100, 280, 45}];
emailTextField.leftImage = [UIImage imageNamed:@"email"];
emailTextField.placeholder = @"Your Email";
[self.view addSubview:emailTextField];
```

