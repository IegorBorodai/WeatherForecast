//
//  UIActionSheet+SHActionSheetBlocks.h
//  Example
//
//  Created by Seivan Heidari on 5/16/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//

#pragma mark -
#pragma mark Block Defs
typedef void (^SHActionSheetBlock)(NSInteger theButtonIndex);
typedef void (^SHActionSheetShowBlock)(UIActionSheet * theActionSheet);
typedef void (^SHActionSheetDismissBlock)(UIActionSheet * theActionSheet, NSInteger theButtonIndex);

@interface UIActionSheet (SHActionSheetBlocks)

#pragma mark -
#pragma mark Init
+(instancetype)completionActionSheetWithTitle:(NSString *)theTitle;

+(instancetype)completionActionSheetWithTitle:(NSString *)theTitle
                          buttonTitles:(NSArray *)theButtonTitles
                           cancelTitle:(NSString *)theCancelTitle
                      destructiveTitle:(NSString *)theDestructiveTitle
                             withBlock:(SHActionSheetBlock)theBlock;
#pragma mark -
#pragma mark Adding
-(NSInteger)completionAddButtonWithTitle:(NSString *)theTitle
                      withBlock:(SHActionSheetBlock)theBlock;

///Will add a new destructive button and make previous Destructive buttons to normal
-(NSInteger)completionAddButtonDestructiveWithTitle:(NSString *)theTitle
                                    withBlock:(SHActionSheetBlock)theBlock;

///Will add a new destructive button and make previous Destructive buttons to normal
-(NSInteger)completionAddButtonCancelWithTitle:(NSString *)theTitle
                               withBlock:(SHActionSheetBlock)theBlock;

#pragma mark -
#pragma mark Properties

#pragma mark -
#pragma mark Setters
-(void)completionSetButtonBlockForIndex:(NSInteger)theButtonIndex
                       withBlock:(SHActionSheetBlock)theBlock;


-(void)completionSetButtonDestructiveBlock:(SHActionSheetBlock)theBlock;
-(void)completionSetButtonCancelBlock:(SHActionSheetBlock)theBlock;

-(void)completionSetWillShowBlock:(SHActionSheetShowBlock)theBlock;
-(void)completionSetDidShowBlock:(SHActionSheetShowBlock)theBlock;

-(void)completionSetWillDismissBlock:(SHActionSheetDismissBlock)theBlock;
-(void)completionSetDidDismissBlock:(SHActionSheetDismissBlock)theBlock;

#pragma mark -
#pragma mark Getters
-(SHActionSheetBlock)SH_blockForButtonIndex:(NSInteger)theButtonIndex;

@property(nonatomic,readonly) SHActionSheetBlock SH_blockForDestructiveButton;
@property(nonatomic,readonly) SHActionSheetBlock SH_blockForCancelButton;


@property(nonatomic,readonly) SHActionSheetShowBlock    SH_blockWillShow;
@property(nonatomic,readonly) SHActionSheetShowBlock    SH_blockDidShow;

@property(nonatomic,readonly) SHActionSheetDismissBlock SH_blockWillDismiss;
@property(nonatomic,readonly) SHActionSheetDismissBlock SH_blockDidDismiss;

@end
