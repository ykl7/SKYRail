//
//  Platform.h
//  SKYRail
//
//  Created by YASH on 19/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Platform : NSObject

@property (strong, nonatomic) NSString *platformName;
@property (nonatomic) NSInteger platformId;
@property (nonatomic) NSInteger xcoord;
@property (nonatomic) NSInteger ycoord;

- (instancetype)initWithDict:(id)dict;

+ (NSMutableArray <Platform *> *)returnArrayFromJSONStructure:(id)json;

@end
