//
//  Person.m
//  SKYRail
//
//  Created by YASH on 19/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import "Person.h"

@implementation Person

- (instancetype)initWithDict:(id)dict
{
    
    self = [super init];
    
    if (self)
    {
        
        @try
        {
            
            self.personId = [dict[@"Person_id"] integerValue];
            self.name = [NSString stringWithFormat:@"%@", dict[@"name"]];
            self.mobNo = [NSString stringWithFormat:@"%@", dict[@"mob_no"]];
            self.gender = [NSString stringWithFormat:@"%@", dict[@"gender"]];
            self.email = [NSString stringWithFormat:@"%@", dict[@"email"]];
            self.password = [NSString stringWithFormat:@"%@", dict[@"password"]];
            
        }
        @catch (NSException *exception)
        {
            NSLog(@"User parse error: %@", exception.reason);
        }
        
    }
    
    return self;
}

+ (NSMutableArray <Person *> *)returnArrayFromJSONStructure:(id)json
{
    NSMutableArray *persons = [NSMutableArray new];
    
    @try {
        
        for (id dict in json) {
            
            Person *person = [[Person alloc] initWithDict:dict];
            
            [persons addObject:person];
            
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"User parse error: %@", exception.reason);
    }
    
    return persons;
}

@end
