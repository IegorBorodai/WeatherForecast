//
//  UIControl+SHControlEventBlock.h
//  Example
//
//  Created by Seivan Heidari on 5/16/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//

#pragma mark -
#pragma mark Block Defs
typedef void (^SHBarButtonItemBlock)(UIBarButtonItem * sender);

@interface UIBarButtonItem (SHBarButtonItemBlocks)

#pragma mark -
#pragma mark Init
+(instancetype)completionBarButtonItemWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem
                                                    withBlock:(SHBarButtonItemBlock)theBlock;

+(instancetype)completionBarButtonItemWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style
                                      withBlock:(SHBarButtonItemBlock)theBlock;

+(instancetype)completionBarButtonItemWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style
                                      withBlock:(SHBarButtonItemBlock)theBlock;

#pragma mark -
#pragma mark Add
-(void)completionAddBlock:(SHBarButtonItemBlock)theBlock;

#pragma mark -
#pragma mark Remove
-(void)completionRemoveBlock:(SHBarButtonItemBlock)theBlock;
-(void)completionRemoveAllBlocks;

#pragma mark -
#pragma mark Properties

#pragma mark -
#pragma mark Getters
@property(nonatomic,readonly) NSSet * completionBlocks;

@end
