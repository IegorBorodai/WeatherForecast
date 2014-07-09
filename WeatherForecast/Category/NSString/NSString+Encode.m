//
//  MNSString.m
//  PriceUA
//
//  Created by Alexander Kozharin on 11/3/10.
//  Copyright IDE Group. All rights reserved.
//

#import "NSString+Encode.h"
#import "md5.h"

@implementation NSString(Encode)

+ (NSString*)stringFromUInt:(unsigned int)num
{
    return [[NSString alloc] initWithFormat:@"%u", num];
}
+(NSString*)stringFromInt:(int)num
{
    return [[NSString alloc] initWithFormat:@"%d", num];
}
+ (NSString*)getStringOid:(NSObject*)obj
{
    if([obj isKindOfClass:[NSNumber class]])
    {
        return [obj description];
    }
    return [obj copy];
}
+(NSString *)stringWithData:(NSData*)data
{
    if([data length]<=0) return nil;
    if((((char*)[data bytes])[[data length]]) != 0)
    {
        NSMutableData*ldata = [NSMutableData dataWithBytes:[data bytes] length:[data length]];
        [ldata appendBytes:"\0" length:1];
        return [NSString stringWithUTF8String:[ldata bytes]];
    }
    return [NSString stringWithUTF8String:[data bytes]];;
}
+ (char)getChar
{
    if(rand()%3 != 0)
        return (char)((rand() % 23) + 'a');
    else
        return (char)((rand() % 9 ) +'0');
}

-(NSString*)md5
{
    return md5_ns(self);
}
-(NSString*)decodeAsUriComponent
{
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
- (NSString*)encodeAsURIComponent
{
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	/*const char* p = [self UTF8String];
	NSMutableString* result = [NSMutableString string];
	
	for (;*p ;p++) {
		unsigned char c = *p;
		if (('0' <= c && c <= '9') || ('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z') || c == '-' || c == '_') {
			[result appendFormat:@"%c", c];
		} else {
			[result appendFormat:@"%%%02X", c];
		}
	}
	return result;*/
}

+ (NSString*)random:(int)length
{
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *s = [NSMutableString stringWithCapacity:length];
    for (int i = 0U; i < length; i++) {
        [s appendFormat:@"%C", [alphabet characterAtIndex:arc4random() % [alphabet length]]];
    }
    return [s copy];
}
+(BOOL)makeFrequentReplacement:(NSScanner*)scanner into:(NSMutableString*)result
{
    static dispatch_once_t onceToken;
    static NSDictionary* fstringReplacemets = nil;
    dispatch_once(&onceToken, ^{
        fstringReplacemets = @{
        @"&apos;" : @"'",
		@"&amp;" :@"&",
        @"&quot;" : @"\"",
        @"&lt;" : @"<",
        @"&gt;": @">",
        @"&nbsp;" : @" ",
        @"&laquo;"  : @"«",
        @"&raquo;"  : @"»",
        @"&ndash;"  : @"–",
        @"&mdash;"  : @"—",
        @"&lsquo;"  : @"‘",
        @"&rsquo;"  : @"’",
        @"&ldquo;"  : @"“",
        @"&rdquo;"  : @"”",
        @"&bull;"  : @"•",
        @"&hellip;"  : @"…"};
    });
    
    for (NSString*key in fstringReplacemets) {
        if ([scanner scanString:key intoString:NULL]) {
            [result appendString:[fstringReplacemets objectForKey:key]];
            return YES;
        }
    }
    return NO;
}
+(BOOL)makeDigitalReplacemet:(NSScanner*)scanner into:(NSMutableString*)result
{
    if ([scanner scanString:@"&#" intoString:NULL]) {
        
        // Entity
        BOOL gotNumber;
        unsigned short charCode;
        unsigned scannedValue;
        NSString *xForHex = @"";
        
        // Is it hex or decimal?
        if ([scanner scanString:@"x" intoString:&xForHex]) {
            gotNumber = [scanner scanHexInt:&scannedValue];
        } else {
            gotNumber = [scanner scanInt:(int*)&scannedValue];
        }
        
        // Process
        if (gotNumber) {
            
            // Append character
            charCode = scannedValue;
            [result appendFormat:@"%C", charCode];
            [scanner scanString:@";" intoString:NULL];
            return YES;
        } else {
            
            // Failed to get a number so append to result and log error
            NSString *unknownEntity = @"";
            NSCharacterSet *boundaryCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" \t\n\r;"];
            [scanner scanUpToCharactersFromSet:boundaryCharacterSet intoString:&unknownEntity];
            [result appendFormat:@"&#%@%@", xForHex, unknownEntity]; // Append exact same string
        }
    }
    return NO;
}
+(BOOL)makeUnFrequentReplacement:(NSScanner*)scanner into:(NSMutableString*)result
{
    static dispatch_once_t onceToken;
    static NSDictionary* stringReplacemets = nil;
    dispatch_once(&onceToken, ^{
        stringReplacemets = @{
        @"&iexcl;" : @"¡",
        @"&cent;" : @"¢",
        @"&pound;" : @"£",
        @"&curren;" : @"¤",
        @"&yen;" : @"¥",
        @"&brvbar;" : @"¦",
        @"&sect;" : @"§",
        @"&uml;" : @"¨",
        @"&copy;" : @"©",
        @"&ordf;" : @"ª",
        @"&not;" : @"¬",
        @"&shy;" : @"­",
        @"&reg;" : @"®",
        @"&macr;" : @"¯",
        @"&deg;" : @"°",
        @"&plusmn;" : @"±",
        @"&sup2;" : @"²",
        @"&sup3;" : @"³",
        @"&acute;" : @"´",
        @"&micro;" : @"µ",
        @"&para;" : @"¶",
        @"&middot;" : @"·",
        @"&cedil;" : @"¸",
        @"&sup1;" : @"¹",
        @"&ordm;" : @"º",
        @"&frac14;" : @"¼",
        @"&frac12;" : @"½",
        @"&frac34;" : @"¾",
        @"&iquest;" : @"¿",
        @"&Agrave;" : @"À",
        @"&Aacute;" : @"Á",
        @"&Acirc;" : @"Â",
        @"&Atilde;" : @"Ã",
        @"&Auml;" : @"Ä",
        @"&Aring;" : @"Å",
        @"&AElig;" : @"Æ",
        @"&Ccedil;" : @"Ç",
        @"&Egrave;" : @"È",
        @"&Eacute;" : @"É",
        @"&Ecirc;" : @"Ê",
        @"&Euml;" : @"Ë",
        @"&Igrave;" : @"Ì",
        @"&Iacute;" : @"Í",
        @"&Icirc;" : @"Î",
        @"&Iuml;" : @"Ï",
        @"&ETH;" : @"Ð",
        @"&Ntilde;" : @"Ñ",
        @"&Ograve;" : @"Ò",
        @"&Oacute;" : @"Ó",
        @"&Ocirc;" : @"Ô",
        @"&Otilde;" : @"Õ",
        @"&Ouml;" : @"Ö",
        @"&times;" : @"×",
        @"&Oslash;" : @"Ø",
        @"&Ugrave;" : @"Ù",
        @"&Uacute;" : @"Ú",
        @"&Ucirc;" : @"Û",
        @"&Uuml;" : @"Ü",
        @"&Yacute;" : @"Ý",
        @"&THORN;" : @"Þ",
        @"&szlig;" : @"ß",
        @"&agrave;" : @"à",
        @"&aacute;" : @"á",
        @"&acirc;" : @"â",
        @"&atilde;" : @"ã",
        @"&auml;" : @"ä",
        @"&aring;" : @"å",
        @"&aelig;" : @"æ",
        @"&ccedil;" : @"ç",
        @"&egrave;" : @"è",
        @"&eacute;" : @"é",
        @"&ecirc;" : @"ê",
        @"&euml;" : @"ë",
        @"&igrave;" : @"ì",
        @"&iacute;" : @"í",
        @"&icirc;" : @"î",
        @"&iuml;" : @"ï",
        @"&eth;" : @"ð",
        @"&ntilde;" : @"ñ",
        @"&ograve;" : @"ò",
        @"&oacute;" : @"ó",
        @"&ocirc;" : @"ô",
        @"&otilde;" : @"õ",
        @"&ouml;" : @"ö",
        @"&divide;" : @"÷",
        @"&oslash;" : @"ø",
        @"&ugrave;" : @"ù",
        @"&uacute;" : @"ú",
        @"&ucirc;" : @"û",
        @"&uuml;" : @"ü",
        @"&yacute;" : @"ý",
        @"&thorn;" : @"þ",
        @"&yuml;" : @"ÿ",
        @"&OElig;" : @"Œ",
        @"&oelig;" : @"œ",
        @"&Scaron;" : @"Š",
        @"&scaron;" : @"š",
        @"&Yuml;" : @"Ÿ",
        @"&fnof;" : @"ƒ",
        @"&circ;" : @"ˆ",
        @"&tilde;" : @"˜",
        @"&Alpha;" : @"Α",
        @"&Beta;" : @"Β",
        @"&Gamma;" : @"Γ",
        @"&Delta;" : @"Δ",
        @"&Epsilon;" : @"Ε",
        @"&Zeta;" : @"Ζ",
        @"&Eta;" : @"Η",
        @"&Theta;" : @"Θ",
        @"&Iota;" : @"Ι",
        @"&Kappa;" : @"Κ",
        @"&Lambda;" : @"Λ",
        @"&Mu;" : @"Μ",
        @"&Nu;" : @"Ν",
        @"&Xi;" : @"Ξ",
        @"&Omicron;" : @"Ο",
        @"&Pi;" : @"Π",
        @"&Rho;" : @"Ρ",
        @"&Sigma;" : @"Σ",
        @"&Tau;" : @"Τ",
        @"&Upsilon;" : @"Υ",
        @"&Phi;" : @"Φ",
        @"&Chi;" : @"Χ",
        @"&Psi;" : @"Ψ",
        @"&Omega;" : @"Ω",
        @"&alpha;" : @"α",
        @"&beta;" : @"β",
        @"&gamma;" : @"γ",
        @"&delta;" : @"δ",
        @"&epsilon;" : @"ε",
        @"&zeta;" : @"ζ",
        @"&eta;" : @"η",
        @"&theta;" : @"θ",
        @"&iota;" : @"ι",
        @"&kappa;" : @"κ",
        @"&lambda;" : @"λ",
        @"&mu;" : @"μ",
        @"&nu;" : @"ν",
        @"&xi;" : @"ξ",
        @"&omicron;" : @"ο",
        @"&pi;" : @"π",
        @"&rho;" : @"ρ",
        @"&sigmaf;" : @"ς",
        @"&sigma;" : @"σ",
        @"&tau;" : @"τ",
        @"&upsilon;" : @"υ",
        @"&phi;" : @"φ",
        @"&chi;" : @"χ",
        @"&psi;" : @"ψ",
        @"&omega;" : @"ω",
        @"&thetasym;" : @"ϑ",
        @"&upsih;" : @"ϒ",
        @"&piv;" : @"ϖ",
        @"&ensp;" : @" ",
        @"&emsp;" : @" ",
        @"&thinsp;" : @" ",
        @"&zwnj;" : @"‌",
        @"&zwj;" : @"‍",
        @"&lrm;" : @"‎",
        @"&rlm;" : @"‏",
        @"&sbquo;" : @"‚",
        @"&bdquo;" : @"„",
        @"&dagger;" : @"†",
        @"&Dagger;" : @"‡",
        @"&permil;" : @"‰",
        @"&prime;" : @"′",
        @"&Prime;" : @"″",
        @"&lsaquo;" : @"‹",
        @"&rsaquo;" : @"›",
        @"&oline;" : @"‾",
        @"&frasl;" : @"⁄",
        @"&euro;" : @"€",
        @"&image;" : @"ℑ",
        @"&weierp;" : @"℘",
        @"&real;" : @"ℜ",
        @"&trade;" : @"™",
        @"&alefsym;" : @"ℵ",
        @"&larr;" : @"←",
        @"&uarr;" : @"↑",
        @"&rarr;" : @"→",
        @"&darr;" : @"↓",
        @"&harr;" : @"↔",
        @"&crarr;" : @"↵",
        @"&lArr;" : @"⇐",
        @"&uArr;" : @"⇑",
        @"&rArr;" : @"⇒",
        @"&dArr;" : @"⇓",
        @"&hArr;" : @"⇔",
        @"&forall;" : @"∀",
        @"&part;" : @"∂",
        @"&exist;" : @"∃",
        @"&empty;" : @"∅",
        @"&nabla;" : @"∇",
        @"&isin;" : @"∈",
        @"&notin;" : @"∉",
        @"&ni;" : @"∋",
        @"&prod;" : @"∏",
        @"&sum;" : @"∑",
        @"&minus;" : @"−",
        @"&lowast;" : @"∗",
        @"&radic;" : @"√",
        @"&prop;" : @"∝",
        @"&infin;" : @"∞",
        @"&ang;" : @"∠",
        @"&and;" : @"∧",
        @"&or;" : @"∨",
        @"&cap;" : @"∩",
        @"&cup;" : @"∪",
        @"&int;" : @"∫",
        @"&there4;" : @"∴",
        @"&sim;" : @"∼",
        @"&cong;" : @"≅",
        @"&asymp;" : @"≈",
        @"&ne;" : @"≠",
        @"&equiv;" : @"≡",
        @"&le;" : @"≤",
        @"&ge;" : @"≥",
        @"&sub;" : @"⊂",
        @"&sup;" : @"⊃",
        @"&nsub;" : @"⊄",
        @"&sube;" : @"⊆",
        @"&supe;" : @"⊇",
        @"&oplus;" : @"⊕",
        @"&otimes;" : @"⊗",
        @"&perp;" : @"⊥",
        @"&sdot;" : @"⋅",
        @"&lceil;" : @"⌈",
        @"&rceil;" : @"⌉",
        @"&lfloor;" : @"⌊",
        @"&rfloor;" : @"⌋",
        @"&lang;" : @"〈",
        @"&rang;" : @"〉",
        @"&loz;" : @"◊",
        @"&spades;" : @"♠",
        @"&clubs;" : @"♣",
        @"&hearts;" : @"♥",
        @"&diams;" : @"♦"};
        
    });
    for (NSString*key in stringReplacemets) {
        if ([scanner scanString:key intoString:NULL]) {
            [result appendString:[stringReplacemets objectForKey:key]];
            return YES;
        }
    }
    return NO;
}
- (NSString *)stringByDecodingXMLEntities {
    // Find first & and short-cut if we can
	NSUInteger ampIndex = [self rangeOfString:@"&" options:NSLiteralSearch].location;
	if (ampIndex == NSNotFound) {
		return [NSString stringWithString:self]; // return copy of string as no & found
	}
    
	// Make result string with some extra capacity.
	NSMutableString *result = [[NSMutableString alloc] initWithCapacity:(self.length * 1.25)];
    
	// First iteration doesn't need to scan to & since we did that already, but for code simplicity's sake we'll do it again with the scanner.
	NSScanner *scanner = [NSScanner scannerWithString:self];
	[scanner setCharactersToBeSkipped:nil];
	[scanner setCaseSensitive:YES];
    
	// Scan
	do {
        
		// Scan up to the next entity or the end of the string.
		NSString *nonEntityString;
		if ([scanner scanUpToString:@"&" intoString:&nonEntityString]) {
			[result appendString:nonEntityString];
		}
		if ([scanner isAtEnd]) break;
        else if ([scanner scanString:@"& " intoString:NULL])
			[result appendString:@"& "];
        else if (![[self class] makeFrequentReplacement:scanner into:result])
        {
            if (!([[self class] makeDigitalReplacemet:scanner into:result])) {
                if (![[self class] makeUnFrequentReplacement:scanner into:result])
                {
                    NSString *amp;
                    [scanner scanString:@"&" intoString:&amp]; // isolated & symbol
                    [result appendString:amp];
                }
            }
        }
        
    } while (![scanner isAtEnd]);
    
	return [result copy];
}

- (NSString *)stringByStrippingHTML {
	NSRange r;
	NSString *s = [self copy];
	while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
		s = [s stringByReplacingCharactersInRange:r withString:@""];
	return s;
}

- (BOOL)isValidEmail
{
    BOOL sticterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = sticterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];

}

- (BOOL)isValidPhone
{
    NSString *regex = @"[+0-9()-]{7,20}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

@end
