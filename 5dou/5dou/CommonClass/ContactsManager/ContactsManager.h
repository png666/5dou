//
//  ContactsManager.h
//  5dou
//
//  Created by 黄新 on 16/12/15.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDContactsInfo.h"


typedef void(^SelectedContactsBlock)(WDContactsInfo *info);
#if IOS_9
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

@interface ContactsManager : NSObject<ABPeoplePickerNavigationControllerDelegate, CNContactPickerDelegate, CNContactViewControllerDelegate>{
    CNContactPickerViewController *_contactsPicker;
}

#else
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ContactsManager : NSObject<ABPeoplePickerNavigationControllerDelegate>{
    ABPeoplePickerNavigationController *_abPicker;
}


#endif

@property (nonatomic, copy) SelectedContactsBlock block;

+ (instancetype)sharedInstace;

- (void)openContactsFromViewController:(UIViewController *)viewController successBlock:(void (^) (WDContactsInfo *info))block;

- (void)checkAddressBookAuthorization:(void (^) (NSInteger authorizationStatus))block;

@end
