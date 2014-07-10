//
//  ACEphemeralObject.m
//  ActivityRecordObjectiveC
//
//  Created by Iegor Borodai on 6/19/14.
//  Copyright (c) 2014 Iegor Borodai. All rights reserved.
//

#import "ACEphemeralObject.h"
@import ObjectiveC.runtime;

@implementation ACEphemeralObject

#pragma mark - Internal methods

+ (Class)getClassFromPropertyAttributes:(objc_property_t)property
{
    const char *propType = property_getAttributes(property);
    NSString *propString = @(propType);
    NSArray *attrArray = [propString componentsSeparatedByString:@","];
    NSString *classString=[[[attrArray firstObject] stringByReplacingOccurrencesOfString:@"\"" withString:@""] stringByReplacingOccurrencesOfString:@"T@" withString:@""];
    Class class = objc_getClass([classString UTF8String]);
    return class;
}

+ (NSManagedObject*)convertInMemoryObjectToManaged:(NSDictionary*)dict class:(Class)class
{
    NSManagedObject* obj = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:NSStringFromClass(class) inManagedObjectContext:[NSManagedObjectContext MR_contextForCurrentThread]] insertIntoManagedObjectContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList(class, &count);
    
    for (NSUInteger i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            NSString *name = [NSString stringWithCString:propName
                                                encoding:[NSString defaultCStringEncoding]];
            if (dict[name]) {
                if ([dict[name] isKindOfClass:[NSDictionary class]]) {
                    Class subClass = [self getClassFromPropertyAttributes:property];
                    NSManagedObject* subObj = [ACEphemeralObject convertInMemoryObjectToManaged:dict[name] class:subClass];
                    [obj setValue:subObj forKeyPath:name];
                } else {
                    [obj setValue:dict[name] forKeyPath:name];
                }
            }
        }
    }
    free(properties);
    
    return obj;
}

@end
