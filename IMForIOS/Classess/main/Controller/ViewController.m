//
//  ViewController.m
//  IMForIOS
//
//  Created by LC on 15/9/11.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import "ViewController.h"
#import "XHTabViewController.h"
#import "XHAsyncSocketClient.h"

@interface ViewController ()<UITextFieldDelegate,SessionServerDelegate>{
    
}
@property (weak, nonatomic) IBOutlet UITextField *pw_word;
@property (weak, nonatomic) IBOutlet UITextField *user_field;
@property (weak, nonatomic) IBOutlet UIButton *login_button;
@property (nonatomic,strong) XHTabViewController *tabViewController;

#pragma mark block
@property (nonatomic,copy) void (^loginAction)(NSString *username,NSString *password);


- (IBAction)loginClick;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewController load");
    [XHAsyncSocketClient shareSocketClient].sessionServerDelegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)kbFrameWillChange:(NSNotification *)noti{
    // 获取窗口的高度
    CGFloat windowH = [UIScreen mainScreen].bounds.size.height;
    // 键盘结束的Frm
    CGRect kbEndFrm = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 获取键盘结束的y值
    CGFloat kbEndY = kbEndFrm.origin.y;
    
    NSLog(@"---%@--%fd-",noti.userInfo,kbEndY);
    //    self.inputViewConstraint.constant = windowH - kbEndY;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 点击登录
- (IBAction)loginClick {
    NSString *user = self.user_field.text;
    NSString *pw = self.pw_word.text;
    
    XHAsyncSocketClient *sessionClient = [XHAsyncSocketClient shareSocketClient];
    
    [sessionClient loginWithBlock:^(int result,NSDictionary *dict) {
        [self handleResult:result AndContentDict:dict];
    }];
    NSLog(@"-----%@-------%@----",user,pw);
}

-(void)handleResult:(int)result AndContentDict:(NSDictionary *)dict{
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (result) {
            case LOGIN_SECCUSS:
            {
                [self dismissViewControllerAnimated:YES completion:nil];
                self.tabViewController =[[XHTabViewController alloc]init];
                self.view.window.rootViewController = self.tabViewController;
            }
                break;
            case 8:
                self.tabViewController.contacts = dict[@"friendList"];
                break;
            case 9:
                self.tabViewController.groupInfos = dict[@"groupInfoList"];
                break;
        }
    });
}


-(void)dealloc{
    NSLog(@"----%s---",__func__);
}

#pragma mark SessionServerDelegate
-(void)showFriendsWithDict:(NSDictionary *)dict{
    XHLog(@"--dict.count-----%@--------",dict);
}

-(void)searchContacts:(NSDictionary *)dict{
    
}

#pragma mark textField 代理
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}


@end
