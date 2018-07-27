//
//  ViewController.m
//  TYNetworkDemo
//
//  Created by chengdonghai on 2018/7/27.
//  Copyright © 2018年 Dahai. All rights reserved.
//

#import "ViewController.h"
#import "CustomRequest.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)request:(UIButton*)sender {
    CustomRequest *req = [[CustomRequest alloc]initWithParam:@"ac"];
    
    [req startWithSuccess:^(TYRequest *req) {
        NSLog(@"Response:%@",req.responseObject);
        [sender setTitle:@"Success" forState:UIControlStateNormal];
    } andFailure:^(TYRequest *req) {
        NSLog(@"Response Error:%@",req.error.errorMessage);
        [sender setTitle:@"Fail" forState:UIControlStateNormal];

    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
