//
//  MJViewController.m
//  MJContactsManager
//
//  Created by jgyhc on 08/24/2019.
//  Copyright (c) 2019 jgyhc. All rights reserved.
//

#import "MJViewController.h"
#import <MJContactsManager.h>

@interface MJViewController ()
@property (nonatomic, strong) MJContactsManager * manager;
@end

@implementation MJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)handlerEvent:(id)sender {
    [self.manager JudgeAddressBookPowerWithViewController:self resultBlock:^(NSString *contactName, NSString *contactMobile) {
        NSLog(@"contactName:%@", contactName);
        NSLog(@"contactMobile:%@", contactMobile);
    }];
}

- (MJContactsManager *)manager {
    if (!_manager) {
        _manager = [[MJContactsManager alloc] init];
    }
    return _manager;
}

@end
