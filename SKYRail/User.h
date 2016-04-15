//
//  User.h
//  SKYRail
//
//  Created by YASH on 16/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *mobileNumber;
@property (strong, nonatomic) NSString *gender;

- (instancetype) initWithName: (NSString *) uName email: (NSString *) email password: (NSString *) password mobileNo: (NSString *) mobNo gender: (NSString *) gen;

- (void)saveToDefaults;

+ (void)clearUser;

+ (User *)currentUser;

@end
