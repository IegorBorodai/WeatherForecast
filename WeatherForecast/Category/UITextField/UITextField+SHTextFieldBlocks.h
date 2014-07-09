//
//  UIControl+SHControlEventBlock.h
//  Example
//
//  Created by Seivan Heidari on 5/16/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//


#pragma mark - Block Defs
typedef void (^SHTextFieldBlock)(UITextField * textField);
typedef BOOL (^SHTextFieldPredicateBlock)(UITextField * textField);

typedef BOOL (^SHTextFieldRangeReplacementBlock)(UITextField * textField,
NSRange shouldChangeCharactersInRange,
NSString * string);

@interface UITextField (SHTextFieldBlocks)


#pragma mark - Helpers

#pragma mark - Properties

#pragma mark - Setters

-(void)completionSetShouldBeginEditingBlock:(SHTextFieldPredicateBlock)theBlock;

-(void)completionSetDidBeginEditingBlock:(SHTextFieldBlock)theBlock;

-(void)completionSetShouldEndEditingBlock:(SHTextFieldPredicateBlock)theBlock;

-(void)completionSetDidEndEditingBlock:(SHTextFieldBlock)theBlock;

-(void)completionSetShouldChangeCharactersInRangeWithReplacementStringBlock:(SHTextFieldRangeReplacementBlock)theBlock;

-(void)completionSetShouldClearBlock:(SHTextFieldPredicateBlock)theBlock;

-(void)completionSetShouldReturnBlock:(SHTextFieldPredicateBlock)theBlock;


#pragma mark - Getters

-(SHTextFieldPredicateBlock)completionBlockShouldBeginEditing;

-(SHTextFieldBlock)completionBlockDidBeginEditing;

-(SHTextFieldPredicateBlock)completionBlockShouldEndEditing;

-(SHTextFieldBlock)completionBlockDidEndEditing;

-(SHTextFieldRangeReplacementBlock)completionBlockShouldChangeCharactersInRangeWithReplacementString;

-(SHTextFieldPredicateBlock)completionBlockShouldClear;

-(SHTextFieldPredicateBlock)completionBlockShouldReturn;

@end
