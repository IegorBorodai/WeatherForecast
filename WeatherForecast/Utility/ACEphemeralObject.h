//
//  ACEphemeralObject.h
//  ActivityRecordObjectiveC
//
//  Created by Iegor Borodai on 6/19/14.
//  Copyright (c) 2014 Iegor Borodai. All rights reserved.
//

@import Foundation;

@interface ACEphemeralObject : NSObject

+ (NSManagedObject*)convertInMemoryObjectToManaged:(NSDictionary*)dict class:(Class)class;

@end
