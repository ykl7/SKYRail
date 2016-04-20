//
//  DBManager.h
//  SKYRail
//
//  Created by YASH on 18/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

- (instancetype)initWithDatabasePath:(NSString *)path;

- (void)dbManagerOpenDatabaseWithPath:(NSString *)path;
- (void)dbManagerCloseDatabase;

- (id)dbExecuteQuery:(NSString *)query error:(NSError *__autoreleasing *)error;

- (BOOL)dbExecuteUpdate:(NSString *)query error:(NSError *__autoreleasing *)error;

+ (DBManager *)sharedManager;

@end
