//
//  MJContactsManager.m
//  ManJi
//
//  Created by manjiwang on 2018/6/11.
//  Copyright © 2018年 Zgmanhui. All rights reserved.
//

#import "MJContactsManager.h"
/// iOS 9前的框架
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
/// iOS 9的新框架
#import <ContactsUI/ContactsUI.h>

#define Is_up_Ios_9    ([[UIDevice currentDevice].systemVersion floatValue]) >= 9.0
@interface MJContactsManager ()<ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate>

@property (nonatomic, strong) UIViewController * viewController;

@property (nonatomic, strong) ContactsSelectResultBlock resultBlock;
@end

@implementation MJContactsManager


#pragma mark ---- 调用系统通讯录
- (void)JudgeAddressBookPowerWithViewController:(UIViewController *)viewController resultBlock:(ContactsSelectResultBlock)resultBlock {
    _resultBlock = resultBlock;
    ///获取通讯录权限，调用系统通讯录
    _viewController = viewController;
    [self CheckAddressBookAuthorization:^(bool isAuthorized , bool isUp_ios_9) {
        if (isAuthorized) {
            [self callAddressBook:isUp_ios_9];
        }else {
            [self showPromptBox];
        }
    }];
}

- (void)CheckAddressBookAuthorization:(void (^)(bool isAuthorized , bool isUp_ios_9))block {
    if (Is_up_Ios_9) {
        CNContactStore * contactStore = [[CNContactStore alloc]init];
        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * __nullable error) {
                if (error) {
                    NSLog(@"Error: %@", error);
                } else if (!granted) {
                    block(NO,YES);
                } else {
                    block(YES,YES);
                }
            }];
        } else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized){
            block(YES,YES);
        } else {
            [self showPromptBox];
        }
    }else {
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
        
        if (authStatus == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        NSLog(@"Error: %@", (__bridge NSError *)error);
                    } else if (!granted) {
                        block(NO,NO);
                    } else {
                        block(YES,NO);
                    }
                });
            });
        }else if (authStatus == kABAuthorizationStatusAuthorized) {
            block(YES, NO);
        }else {
            [self showPromptBox];
        }
    }
}

- (void)showPromptBox {
    // 1.创建UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                             message:@"您好像没有开启消息推送通知的权限哦，去开启一下吧！"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    // 2.创建并添加按钮
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:okAction];           // A
    [alertController addAction:cancelAction];       // B
    [_viewController presentViewController:alertController animated:YES completion:nil];
}


- (void)callAddressBook:(BOOL)isUp_ios_9 {
    if (isUp_ios_9) {
        CNContactPickerViewController *contactPicker = [[CNContactPickerViewController alloc] init];
        contactPicker.delegate = self;
        contactPicker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
        [_viewController presentViewController:contactPicker animated:YES completion:nil];
    } else {
        ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
        peoplePicker.peoplePickerDelegate = self;
        [_viewController presentViewController:peoplePicker animated:YES completion:nil];
    }
}

#pragma mark -- CNContactPickerDelegate  进入系统通讯录页面 --
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    CNPhoneNumber *phoneNumber = (CNPhoneNumber *)contactProperty.value;
    __weak typeof(self) wself = self;
    [_viewController dismissViewControllerAnimated:YES completion:^{
        /// 联系人
        NSString *name = [NSString stringWithFormat:@"%@%@",contactProperty.contact.familyName,contactProperty.contact.givenName];
        /// 电话
        NSString *mobile = [self phoneNumberFormat:phoneNumber.stringValue];
        wself.resultBlock(name, mobile);
    }];
}


#pragma mark -- ABPeoplePickerNavigationControllerDelegate   进入系统通讯录页面 --
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef,identifier);
    CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef,index);
    CFStringRef anFullName = ABRecordCopyCompositeName(person);
    __weak typeof(self) wself = self;
    [_viewController dismissViewControllerAnimated:YES completion:^{
        /// 联系人
        NSString *name = [NSString stringWithFormat:@"%@",anFullName];
        /// 电话
        NSString *mobile = [self phoneNumberFormat:(__bridge NSString*)value];
        wself.resultBlock(name, mobile);
    }];
}

- (NSString *)phoneNumberFormat:(NSString *)phoneNum {
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"[^\\d]" options:0 error:NULL];
    phoneNum = [regular stringByReplacingMatchesInString:phoneNum options:0 range:NSMakeRange(0, [phoneNum length]) withTemplate:@""];
    return phoneNum;
}




@end
