# TYNetwork
对AFNetworking 的二次封装，将HTTP请求封装为OC对象。
# How use

```objc
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
```
