//
//  User.m
//  SKYRail
//
//  Created by YASH on 16/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import "User.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

@implementation User

- (instancetype) initWithName: (NSString *) uName email: (NSString *) email password: (NSString *) password mobileNo: (NSString *) mobNo gender: (NSString *) gen
{
    self = [super init];
    
    if (self)
    {
        
        self.userName = uName;
        self.email = email;
        self.password = password;
        self.mobileNumber = mobNo;
        self.gender = gen;
        
    }
    
    return self;
}

- (void)saveToDefaults {
    
    if (self) {
        
        [[NSUserDefaults standardUserDefaults] rm_setCustomObject:self forKey:@"savedUser"];
        
    }
    
}

+ (User *)currentUser {
    
    User *user = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"savedUser"];
    return user;
    
}

+ (void)clearUser
{
    [[NSUserDefaults standardUserDefaults] rm_setCustomObject:nil forKey:@"savedUser"];
}

@end
