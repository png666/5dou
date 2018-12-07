//
//  ContactsManager.m
//  5dou
//
//  Created by 黄新 on 16/12/15.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//


#import "ContactsManager.h"

#define kAuthorizationStatusNotDetermined   0 // 用户未授权应用访问通讯录数据
#define kAuthorizationStatusRestricted      1 // 此应用程序没有被授权访问的通讯录数据。可能是家长控制权限
#define kAuthorizationStatusDenied          2 // 用户已经明确否认了这一通讯录应用程序访问
#define kAuthorizationStatusAuthorized      3 // 用户已经授权应用访问通讯录数据

@implementation ContactsManager

+ (instancetype)sharedInstace {
    static ContactsManager *_manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _manager = [[ContactsManager alloc] init];
    });
    
    return _manager;
}

- (void)openContactsFromViewController:(UIViewController *)viewController successBlock:(void (^) (WDContactsInfo *info))block {
    self.block = block;
    
#if IOS_9
    if ([CNContactPickerViewController class]) {
        _contactsPicker = [[CNContactPickerViewController alloc] init];
        _contactsPicker.delegate = self;
        
        [viewController presentViewController:_contactsPicker animated:YES completion:nil];
    }else {
        _abPicker = [[ABPeoplePickerNavigationController alloc] init];
        _abPicker.peoplePickerDelegate = self;
        if([_abPicker respondsToSelector:@selector(setPredicateForSelectionOfPerson:)]){
            [_abPicker setPredicateForSelectionOfPerson:[NSPredicate predicateWithValue:false]];
        }
        [viewController presentViewController:_abPicker animated:YES completion:nil];
    }
#else
    _abPicker = [[ABPeoplePickerNavigationController alloc] init];
    _abPicker.peoplePickerDelegate = self;
    if([_abPicker respondsToSelector:@selector(setPredicateForSelectionOfPerson:)]){
        [_abPicker setPredicateForSelectionOfPerson:[NSPredicate predicateWithValue:false]];
    }
    [viewController presentViewController:_abPicker animated:YES completion:nil];
#endif
}

- (void)checkAddressBookAuthorization:(void (^) (NSInteger authorizationStatus))statusBlock {
#if IOS_9
    if ([CNContactPickerViewController class]) {
        // 获取授权状态
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        
        if (status == CNAuthorizationStatusNotDetermined) {
            CNContactStore *store = [[CNContactStore alloc] init];
            
            [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"%@", error);
                    return;
                }
                
                if (granted) {
                    statusBlock(kAuthorizationStatusAuthorized);
                }
            }];
        }else if (status == CNAuthorizationStatusRestricted) {
            statusBlock(kAuthorizationStatusRestricted);
        }else if (status == CNAuthorizationStatusDenied) {
            statusBlock(kAuthorizationStatusDenied);
        }else if (status == CNAuthorizationStatusAuthorized) {
            statusBlock(kAuthorizationStatusAuthorized);
        }
    }else {
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAuthorizationStatus authorizationStatus = ABAddressBookGetAuthorizationStatus();
        
        if (authorizationStatus == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError *err = (__bridge NSError *)error;
                    if (err) {
                        NSLog(@"error is %@",error);
                    }else if (granted) {
                        statusBlock(kAuthorizationStatusAuthorized);
                    }
                });
            });
        }else if (authorizationStatus == kABAuthorizationStatusRestricted){
            statusBlock(kAuthorizationStatusRestricted);
        }else if (authorizationStatus == kABAuthorizationStatusDenied){
            statusBlock(kAuthorizationStatusDenied);
        }else if (authorizationStatus == kABAuthorizationStatusAuthorized){
            statusBlock(kAuthorizationStatusAuthorized);
        }
    }
#else
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAuthorizationStatus authorizationStatus = ABAddressBookGetAuthorizationStatus();
    
    if (authorizationStatus == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err = (__bridge NSError *)error;
                if (err) {
                    NSLog(@"error is %@",error);
                }else if (granted) {
                    statusBlock(kAuthorizationStatusAuthorized);
                }
            });
        });
    }else if (authorizationStatus == kABAuthorizationStatusRestricted){
        statusBlock(kAuthorizationStatusRestricted);
    }else if (authorizationStatus == kABAuthorizationStatusDenied){
        statusBlock(kAuthorizationStatusDenied);
    }else if (authorizationStatus == kABAuthorizationStatusAuthorized){
        statusBlock(kAuthorizationStatusAuthorized);
    }
#endif
}

#pragma mark contacts delegate

#if IOS_9

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    CNContact *contact = contactProperty.contact;
    
    id value = contactProperty.value;
    
    ContactsInfo *info = [[ContactsInfo alloc] init];
    
    NSString *name = [NSString stringWithFormat:@"%@",[CNContactFormatter stringFromContact:contact style:CNContactFormatterStyleFullName]];
    
    info.contactName = name;
    
    if ([value isKindOfClass:[CNPhoneNumber class]]) {
        CNPhoneNumber *phoneNumber = (CNPhoneNumber *)contactProperty.value;
        
        info.contactPhoneNumber = phoneNumber.stringValue;
    }else {
        info.contactPhoneNumber = @"";
    }
    
    info.contactPhoneNumber = [self phoneNumberFormatWith:info.contactPhoneNumber];
    
    if (self.block) {
        self.block(info);
    }
}
#endif
// Called after the user has pressed cancel.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

// Called after a property has been selected by the user.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    [self peoplePickerNavigationController:peoplePicker shouldContinueAfterSelectingPerson:person property:property identifier:identifier];
}
// Called after a person has been selected by the user.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person {
    [self peoplePickerNavigationController:peoplePicker shouldContinueAfterSelectingPerson:person];
}

// Deprecated in ios8
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    return YES;
}

// Deprecated in ios8
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    ABMultiValueRef valueRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex index = ABMultiValueGetIndexForIdentifier(valueRef,identifier);
    NSString *phoneNumber = (__bridge NSString *)ABMultiValueCopyValueAtIndex(valueRef, index);
    phoneNumber = [self phoneNumberFormatWith:phoneNumber];
    
    CFStringRef name = ABRecordCopyCompositeName(person);
    NSString *nameStr = [NSString stringWithFormat:@"%@",name];
    
    WDContactsInfo *info = [[WDContactsInfo alloc] init];
    info.contactName = nameStr;
    info.contactPhoneNumber = phoneNumber;
    
    if (self.block) {
        self.block(info);
    }
    
    return YES;
}

#pragma mark 去除手机号码中的特殊符号
- (NSString *)phoneNumberFormatWith:(NSString *)phoneNumber {
    if ([phoneNumber hasPrefix:@"+"]) {
        phoneNumber = [phoneNumber substringFromIndex:3];
    }
    
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    return phoneNumber;
}


@end
