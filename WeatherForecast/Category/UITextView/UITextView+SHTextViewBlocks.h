//
//  UIControl+SHControlEventBlock.h
//  Example
//
//  Created by Seivan Heidari on 5/16/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//


#pragma mark - Block Defs
typedef void (^SHTextViewBlock)(UITextView * textView);
typedef BOOL (^SHTextViewPredicateBlock)(UITextView * textView);

typedef BOOL (^SHTextViewRangeReplacementBlock)(UITextView * textView,
NSRange shouldChangeTextInRange,
NSString * string);

@interface UITextView (SHTextViewBlocks)


#pragma mark - Helpers

#pragma mark - Properties

#pragma mark - Setters

-(void)completionSetShouldBeginEditingBlock:(SHTextViewPredicateBlock)theBlock;

-(void)completionSetShouldEndEditingBlock:(SHTextViewPredicateBlock)theBlock;

-(void)completionSetDidBeginEditingBlock:(SHTextViewBlock)theBlock;

-(void)completionSetDidEndEditingBlock:(SHTextViewBlock)theBlock;

-(void)completionSetShouldChangeCharactersInRangeWithReplacementTextBlock:(SHTextViewRangeReplacementBlock)theBlock;

-(void)completionSetDidChangeBlock:(SHTextViewBlock)theBlock;

-(void)completionSetDidChangeSelection:(SHTextViewBlock)theBlock;



#pragma mark - Getters

-(SHTextViewPredicateBlock)completionBlockShouldBeginEditing;

-(SHTextViewPredicateBlock)completionBlockShouldEndEditing;


-(SHTextViewBlock)completionBlockDidBeginEditing;

-(SHTextViewBlock)completionBlockDidEndEditing;

-(SHTextViewRangeReplacementBlock)completionBlockShouldChangeCharactersInRangeWithReplacementText;

-(SHTextViewBlock)completionBlockDidChange;

-(SHTextViewBlock)completionBlockDidChangeSelection;

@end
