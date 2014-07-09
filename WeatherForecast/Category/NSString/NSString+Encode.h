//
//  MNSString.h
//  PriceUA
//
//  Created by Alexander Kozharin on 11/3/10.
//  Copyright 2010 IDE Group. All rights reserved.
//

@import Foundation;


@interface NSString(Encode)
+ (NSString *)stringWithData:(NSData*)data;
+ (char)getChar;
- (NSString*)decodeAsUriComponent;
- (NSString*)encodeAsURIComponent;
- (NSString*)stringByDecodingXMLEntities;
- (NSString *)stringByStrippingHTML;
- (NSString*)md5;
+ (NSString*)getStringOid:(NSObject*)obj;
+ (NSString*)stringFromInt:(int)num;
+ (NSString*)stringFromUInt:(unsigned int)num;
+ (NSString*)random:(int)length;
- (BOOL)isValidEmail;
- (BOOL)isValidPhone;
@end
