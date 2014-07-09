//
//  UIGestureRecognizer+SHGestureRecognizerBlocks.h
//  Example
//
//  Created by Seivan Heidari on 5/16/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//


#pragma mark - Block Defs
typedef void (^SHGestureRecognizerBlock)(UIGestureRecognizer * sender, UIGestureRecognizerState state, CGPoint location);

@interface UIGestureRecognizer (SHGestureRecognizerBlocks)

#pragma mark - Init
+(instancetype)completionGestureRecognizerWithBlock:(SHGestureRecognizerBlock)theBlock;

#pragma mark - Add block
-(void)completionAddBlock:(SHGestureRecognizerBlock)theBlock;

#pragma mark - Remove block
-(void)completionRemoveBlock:(SHGestureRecognizerBlock)theBlock;
-(void)completionRemoveAllBlocks;

#pragma mark - Properties

#pragma mark - Getters
@property(nonatomic,readonly) NSSet * completionBlocks;

@end
