//
//  Person.h
//  SKYRail
//
//  Created by YASH on 19/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic) NSInteger personId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *mobNo;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *password;

- (instancetype)initWithDict:(id)dict;

+ (NSMutableArray <Person *> *)returnArrayFromJSONStructure:(id)json;

@end
