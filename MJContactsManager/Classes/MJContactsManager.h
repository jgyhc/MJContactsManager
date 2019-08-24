//
//  MJContactsManager.h
//  ManJi
//
//  Created by manjiwang on 2018/6/11.
//  Copyright © 2018年 Zgmanhui. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^ContactsSelectResultBlock)(NSString *contactName, NSString* contactMobile);

@interface MJContactsManager : NSObject

- (void)JudgeAddressBookPowerWithViewController:(UIViewController *)viewController resultBlock:(ContactsSelectResultBlock)resultBlock;

@end
