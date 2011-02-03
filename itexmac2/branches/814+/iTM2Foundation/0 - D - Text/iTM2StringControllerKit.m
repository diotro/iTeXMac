/*
//
//  @version Subversion: $Id: iTM2StringControllerKit.m 750 2008-09-17 13:48:05Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sat Jun 16 2001.
//  Copyright © 2001-2009 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
*/

#import "ICURegEx.h"
#import "iTM2StringKit.h"
#import "iTM2LiteScanner.h"
#import "iTM2StringControllerKit.h"
#import "iTM2StringControllerKitPrivate.h"
#import "iTM2ContextKit.h"
#import "iTM2InstallationKit.h"

NSString * const iTM2TextIndentationStringKey= @"iTM2TextIndentationString";
NSString * const iTM2TextNumberOfSpacesPerTabKey= @"iTM2TextNumberOfSpacesPerTab";
NSString * const iTM2TextIndentationUsesTabsKey= @"iTM2TextIndentationUsesTabs";

NSString * const iTM2TextTabAnchorStringKey = @"iTM2TextTabAnchorString";

@implementation NSObject(iTM2StringKit)
- (id)stringController4iTM3;
{
    return [iTM2StringController defaultController];
}
@end

@implementation iTM2IndentationComponent
- (BOOL)isEqual:(iTM2IndentationComponent *)rhs;
{
    return [rhs isKindOfClass:[iTM2IndentationComponent class]]?
        rhs.location == self.location
        && rhs.contentLength == self.contentLength
        && rhs.commentLength == self.commentLength
        && rhs.afterLength == self.afterLength
        && rhs.blackLength == self.blackLength
        && rhs.depth == self.depth
        && rhs.endsWithTab == self.endsWithTab
        : (rhs?NO:
            self.location ==ZER0            && self.contentLength ==ZER0            && self.commentLength ==ZER0            && self.afterLength ==ZER0            && self.blackLength ==ZER0            && self.depth ==ZER0            && !self.endsWithTab
        );
}
- (NSUInteger)length;
{
    return self.contentLength + self.commentLength + self.afterLength + self.blackLength;
}
- (NSUInteger)nextLocation;
{
    return self.location + self.length;
}
#define ULONG unsigned long
- (NSString *)description;
{
    return [NSString stringWithFormat:@"{l:%lu,c:%lu,%%:%lu,b:%lu,a:%lu,d:%lu}",
        (ULONG)self.location, (ULONG)self.contentLength, (ULONG)self.commentLength, (ULONG)self.blackLength, (ULONG)self.afterLength, (ULONG)self.depth];
}
- (NSUInteger)whiteDepth;
{
    //  whiteDepth means only ' ' or '\t'
    //  components with black characters are ignored
    //  this is used in unindentation
    return self.commentLength?ZER0:self.depth;
}
- (NSUInteger)location;
{
    return ZER0;
}
- (NSUInteger)commentLocation;
{
    return self.location + self.contentLength;
}
- (NSUInteger)contentLength;
{
    return ZER0;
}
- (NSUInteger)commentLength;
{
    return ZER0;
}
- (NSUInteger)blackLength;
{
    return ZER0;
}
- (NSUInteger)afterLength;
{
    return ZER0;
}
- (NSUInteger)depth;
{
    return ZER0;
}
- (BOOL) endsWithTab;
{
    return NO;
}
- (BOOL) shouldRemainAtTheEnd;
{
    return NO;//!self.length && self.commentLength;
}
- (NSRange) range;
{
    return iTM3MakeRange(self.location,self.length);
}
- (NSRange) commentRange;
{
    return iTM3MakeRange(self.commentLocation,self.commentLength);
}
@end

@implementation __iTM2IndentationComponent
@synthesize location;
@synthesize depth;
@dynamic contentLength;
@dynamic commentLength;
@dynamic blackLength;
@dynamic afterLength;
@dynamic endsWithTab;
- (void)setContentLength:(NSUInteger)arg;{return;}
- (void)setCommentLength:(NSUInteger)arg;{return;}
- (void)setBlackLength:(NSUInteger)arg;{return;}
- (void)setAfterLength:(NSUInteger)arg;{return;}
- (void)setEndsWithTab:(BOOL)yorn;{return;}
@end

#define DECLARE4iTM3(SON,IVAR_1)\
@interface __iTM2IndentationComponent##SON: __iTM2IndentationComponent{@private NSUInteger IVAR_1;} @property NSUInteger IVAR_1; @end\
@implementation __iTM2IndentationComponent##SON @synthesize IVAR_1 = IVAR_1; @end\
@interface _iTM2IndentationComponentWithTab##SON: __iTM2IndentationComponent##SON @property (readonly) BOOL endsWithTab; @end\
@implementation _iTM2IndentationComponentWithTab##SON -(BOOL)endsWithTab{return YES;} @end

DECLARE4iTM3(10000,contentLength)
DECLARE4iTM3(01000,commentLength)

#undef DECLARE4iTM3

#define DECLARE4iTM3(SON,IVAR_1,IVAR_2)\
@interface __iTM2IndentationComponent##SON: __iTM2IndentationComponent{@private NSUInteger IVAR_1;NSUInteger IVAR_2;} @property NSUInteger IVAR_1;@property NSUInteger IVAR_2; @end\
@implementation __iTM2IndentationComponent##SON @synthesize IVAR_1 = IVAR_1;@synthesize IVAR_2 = IVAR_2; @end\
@interface _iTM2IndentationComponentWithTab##SON: __iTM2IndentationComponent##SON @property (readonly) BOOL endsWithTab; @end\
@implementation _iTM2IndentationComponentWithTab##SON -(BOOL)endsWithTab{return YES;} @end

DECLARE4iTM3(01100,commentLength,blackLength)
DECLARE4iTM3(01010,commentLength,afterLength)
DECLARE4iTM3(11000,commentLength,contentLength)

#undef DECLARE4iTM3

#define DECLARE4iTM3(SON,IVAR_1,IVAR_2,IVAR_3)\
@interface __iTM2IndentationComponent##SON: __iTM2IndentationComponent{@private NSUInteger IVAR_1;NSUInteger IVAR_2;NSUInteger IVAR_3;} @property NSUInteger IVAR_1;@property NSUInteger IVAR_2;@property NSUInteger IVAR_3; @end\
@implementation __iTM2IndentationComponent##SON @synthesize IVAR_1 = IVAR_1;@synthesize IVAR_2 = IVAR_2;@synthesize IVAR_3 = IVAR_3; @end\
@interface _iTM2IndentationComponentWithTab##SON: __iTM2IndentationComponent##SON @property (readonly) BOOL endsWithTab; @end\
@implementation _iTM2IndentationComponentWithTab##SON -(BOOL)endsWithTab{return YES;} @end

DECLARE4iTM3(01110,commentLength,blackLength,afterLength)
DECLARE4iTM3(11100,commentLength,blackLength,contentLength)
DECLARE4iTM3(11010,commentLength,afterLength,contentLength)

#undef DECLARE4iTM3

#define DECLARE4iTM3(SON,IVAR_1,IVAR_2,IVAR_3,IVAR_4)\
@interface __iTM2IndentationComponent##SON: __iTM2IndentationComponent{@private NSUInteger IVAR_1;NSUInteger IVAR_2;NSUInteger IVAR_3;NSUInteger IVAR_4;} @property NSUInteger IVAR_1;@property NSUInteger IVAR_2;@property NSUInteger IVAR_3;@property NSUInteger IVAR_4; @end\
@implementation __iTM2IndentationComponent##SON @synthesize IVAR_1 = IVAR_1;@synthesize IVAR_2 = IVAR_2;@synthesize IVAR_3 = IVAR_3;@synthesize IVAR_4 = IVAR_4; @end\
@interface _iTM2IndentationComponentWithTab##SON: __iTM2IndentationComponent##SON @property (readonly) BOOL endsWithTab; @end\
@implementation _iTM2IndentationComponentWithTab##SON -(BOOL)endsWithTab{return YES;} @end

DECLARE4iTM3(11110,commentLength,blackLength,afterLength,contentLength)

#undef DECLARE4iTM3

@implementation _iTM2IndentationComponent
+ (id)indentationComponent;
{
    _iTM2IndentationComponent * new = [[_iTM2IndentationComponent new] autorelease];
    new.reset;
    return new;
}
- (void)reset;
{
    self.location = ZER0;
    self.depth = ZER0;
    self.contentLength = ZER0;
    self.commentLength = ZER0;
    self.blackLength = ZER0;
    self.afterLength = ZER0;
    self.endsWithTab = NO;
}
- (id)clone;
{
    if (self.contentLength)
    {
        if (self.commentLength)
        {
            if (self.blackLength)
            {
                if (self.afterLength)
                {
                    __iTM2IndentationComponent11110 * new = self.endsWithTab?[_iTM2IndentationComponentWithTab11110 new]:[__iTM2IndentationComponent11110 new];
                    new.location = self.location;
                    new.depth = self.depth;
                    new.contentLength = self.contentLength;
                    new.commentLength = self.commentLength;
                    new.blackLength = self.blackLength;
                    new.afterLength = self.afterLength;
                    return [new autorelease];
                }
                else
                {
                    __iTM2IndentationComponent11100 * new = self.endsWithTab?[_iTM2IndentationComponentWithTab11100 new]:[__iTM2IndentationComponent11100 new];
                    new.location = self.location;
                    new.depth = self.depth;
                    new.contentLength = self.contentLength;
                    new.commentLength = self.commentLength;
                    new.blackLength = self.blackLength;
                    return [new autorelease];
                }
            }
            else if (self.afterLength)
            {
                __iTM2IndentationComponent11010 * new = self.endsWithTab?[_iTM2IndentationComponentWithTab11010 new]:[__iTM2IndentationComponent11010 new];
                new.depth = self.depth;
                new.location = self.location;
                new.contentLength = self.contentLength;
                new.commentLength = self.commentLength;
                new.afterLength = self.afterLength;
                return [new autorelease];
            }
            else
            {
                __iTM2IndentationComponent11000 * new = self.endsWithTab?[_iTM2IndentationComponentWithTab11000 new]:[__iTM2IndentationComponent11000 new];
                new.location = self.location;
                new.depth = self.depth;
                new.contentLength = self.contentLength;
                new.commentLength = self.commentLength;
                return [new autorelease];
            }
        }
        else
        {
            __iTM2IndentationComponent10000 * new = self.endsWithTab?[_iTM2IndentationComponentWithTab10000 new]:[__iTM2IndentationComponent10000 new];
            new.location = self.location;
            new.depth = self.depth;
            new.contentLength = self.contentLength;
            return [new autorelease];
        }
    }
    else if (self.commentLength)
    {
        if (self.blackLength)
        {
            if (self.afterLength)
            {
                __iTM2IndentationComponent01110 * new = self.endsWithTab?[_iTM2IndentationComponentWithTab01110 new]:[__iTM2IndentationComponent01110 new];
                new.location = self.location;
                new.depth = self.depth;
                new.commentLength = self.commentLength;
                new.blackLength = self.blackLength;
                new.afterLength = self.afterLength;
                return [new autorelease];
            }
            else
            {
                __iTM2IndentationComponent01100 * new = self.endsWithTab?[_iTM2IndentationComponentWithTab01100 new]:[__iTM2IndentationComponent01100 new];
                new.location = self.location;
                new.depth = self.depth;
                new.commentLength = self.commentLength;
                new.blackLength = self.blackLength;
                return [new autorelease];
            }
        }
        else if (self.afterLength)
        {
            __iTM2IndentationComponent01010 * new = self.endsWithTab?[_iTM2IndentationComponentWithTab01010 new]:[__iTM2IndentationComponent01010 new];
            new.depth = self.depth;
            new.location = self.location;
            new.commentLength = self.commentLength;
            new.afterLength = self.afterLength;
            return [new autorelease];
        }
        else
        {
            __iTM2IndentationComponent01000 * new = self.endsWithTab?[_iTM2IndentationComponentWithTab01000 new]:[__iTM2IndentationComponent01000 new];
            new.location = self.location;
            new.depth = self.depth;
            new.commentLength = self.commentLength;
            return [new autorelease];
        }
    }
    else
    {
        __iTM2IndentationComponent * new = [__iTM2IndentationComponent new];
        new.location = self.location;
        new.depth = self.depth;
        return [new autorelease];
    }
}
@synthesize location;
@synthesize contentLength;
@synthesize commentLength;
@synthesize blackLength;
@synthesize afterLength;
@synthesize depth;
@synthesize endsWithTab;
@end

iTM2StringController * _iTM2StringController = nil;
@implementation iTM2StringController
+ (id)defaultController;
{
    return _iTM2StringController;
}
- (void)setUpMacroTypes;
{
    NSString * path = [[NSBundle bundleForClass:self.class]
        pathForResource:@"iTM2StringControllerMacroTypes" ofType:@"plist"];
    NSAssert(path,@"iTM2 would not work properly w/o macro types. Missing foundation resources, please report bug.");
    self->_macroTypes = [NSArray arrayWithContentsOfURL:[NSURL fileURLWithPath:path]];
}
+ (void)initialize;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{
	[SUD registerDefaults:
		 [NSDictionary dictionaryWithObjectsAndKeys:
            @"\xE2\x80\xA2", iTM2TextTabAnchorStringKey,//"•"
            @"	", iTM2TextIndentationStringKey,
            [NSNumber numberWithUnsignedInteger:4], iTM2TextNumberOfSpacesPerTabKey,
                nil]];
    _iTM2StringController = [self.alloc init];
}
- (id)initWithDelegate:(id)delegate;
{
    if ((self=[super init]))
    {
        self.setUpMacroTypes;
        self.delegate = delegate?:self;
    }
    return self;
}
#pragma mark Character sequence definitions
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tabAnchor
- (NSString *)tabAnchor;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self context4iTM3StringForKey:iTM2TextTabAnchorStringKey domain:iTM2ContextAllDomainsMask];
}
- (unichar)standaloneCharacterAtIndex:(NSUInteger)index inString:(NSString *)aString;
{
    NSRange R = [aString rangeOfComposedCharacterSequenceAtIndex:index];
    if (R.length!=1 || [self isEscapedCharacterAtIndex:index inString:aString])
        return ZER0;
    return [aString characterAtIndex:index];
}
- (BOOL)isEscapedCharacterAtIndex:(NSUInteger)index inString:(NSString *)aString;
{
    return index > ZER0 && [self isControlCharacterAtIndex:index-1 inString:aString];
}
- (BOOL)isControlCharacterAtIndex:(NSUInteger)index inString:(NSString *)aString;
{
    return [aString characterAtIndex:index] == '\\'
        && ![self isEscapedCharacterAtIndex:index inString:aString];
}
- (BOOL)isCommentCharacterAtIndex:(NSUInteger)index inString:(NSString *)aString;
{
    return [aString characterAtIndex:index] == '%'
        && ![self isEscapedCharacterAtIndex:index inString:aString];
}
- (BOOL)isStartingCommentSequenceAtIndexRef:(NSUInteger *)indexRef inString:(NSString *)aString;
{
    NSParameterAssert(indexRef != NULL);
    if ([self isCommentCharacterAtIndex:*indexRef inString:aString]) {
        ++(*indexRef);
        if ([aString characterAtIndex:*indexRef] == '!' ) {
            ++(*indexRef);
        }
        return YES;
    }
    return NO;
}
-(BOOL)usesTabs;
{
    return [self context4iTM3BoolForKey:iTM2TextIndentationUsesTabsKey domain:iTM2ContextAllDomainsMask];
}
-(void)setUsesTabs:(BOOL)new;
{
    return [self takeContext4iTM3Bool:new forKey:iTM2TextIndentationUsesTabsKey domain:iTM2ContextStandardMask];
}
-(NSUInteger)numberOfSpacesPerTab;
{
    return [self context4iTM3UnsignedIntegerForKey:iTM2TextNumberOfSpacesPerTabKey domain:iTM2ContextAllDomainsMask];
}
-(void)setNumberOfSpacesPerTab:(NSUInteger)new;
{
    return [self takeContext4iTM3UnsignedInteger:new forKey:iTM2TextNumberOfSpacesPerTabKey domain:iTM2ContextStandardMask];
}
- (id)currentContext4iTM3Manager;
{
    return self.delegate;
}
- (NSString *)indentationString;
{
    if (self.usesTabs) return @"\t";
    NSMutableDictionary * cache = nil;
    NSUInteger numberOfSpacesPerTab = self.numberOfSpacesPerTab;
    NSNumber * K = [NSNumber numberWithUnsignedInteger:numberOfSpacesPerTab];
    id V = [cache objectForKey:K];
    if (V)
    {
        return V;
    }
    if (!cache)
    {
        cache = [NSMutableDictionary dictionary];
    }
    V = [NSMutableString stringWithCapacity:numberOfSpacesPerTab];
    while(numberOfSpacesPerTab--)
    {
        [V appendString:@" "];
    }
    [cache setObject:V forKey:K];
    return V;
}
- (NSString *)commentString;
{
    return @"%";
}
- (NSString *) startPlaceholderMark;
{
    return @"__(";
}
- (NSString *) stopPlaceholderMark;
{
    return @")__";
}
- (NSString *) voidPlaceholderMark;
{
    return @"__()__";
}
#pragma mark Indentation
- (id)liteScannerWithString:(NSString *)aString;
{
	return [iTM2LiteScanner scannerWithString:aString charactersToBeSkipped:nil];
}
- (BOOL)_getNextIndentationComponent:(_iTM2IndentationComponent *)IC withScanner:(iTM2LiteScanner *)LS alreadyScanned:(NSUInteger)offset maxDepth:(NSUInteger)maxDepth;
/*! Description forthcoming.
*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    IC.reset;
    IC.location = LS.scanLocation - offset;
    while (IC.depth < maxDepth) {
        NSUInteger index = ZER0;
        if ([LS scanCharacter:'\t'])
        {
            IC.endsWithTab = YES;
            IC.contentLength += 1;
            IC.depth = 1;
            return YES;
        }
        else if ([LS scanCharacter:' '])
        {
            IC.endsWithTab = NO;
            IC.contentLength += 1;
            if (IC.length==self.numberOfSpacesPerTab)
            {
                IC.depth = 1;
                return YES;
            }
            continue;
        }
        else if ([LS scanCommentCharacter])
        {
            IC.endsWithTab = NO;
            do {
                IC.commentLength += 1;
                if (IC.length==self.numberOfSpacesPerTab)
                {
                    IC.depth = 1;
                    return YES;
                }
            } while ([LS scanCommentCharacter]);
continue_after_comment:
            // there is either too much or not enough characters for the component, we must add some more characters
            while(IC.depth < maxDepth)
            {
                if ([LS scanCharacter:'\t'])
                {
                    IC.endsWithTab = YES;
                    IC.depth = 1+IC.length/self.numberOfSpacesPerTab;
                    IC.afterLength += 1;
                    return YES;
                }
                else if ([LS scanCharacter:' '])
                {
                    IC.endsWithTab = NO;
                    IC.afterLength += 1;
                    if (IC.length % self.numberOfSpacesPerTab)
                    {
                        // continue to scan the string not separating white and black characters
                        while(IC.depth < maxDepth)
                        {
                            if ([LS scanCharacter:'\t'])
                            {
                                IC.endsWithTab = YES;
                                IC.depth = 1+IC.length/self.numberOfSpacesPerTab;
                                IC.afterLength += 1;
                                return YES;
                            }
                            else if ([LS scanCharacter:' '] || [LS scanCommentCharacter])
                            {
                                IC.endsWithTab = NO;
                                IC.afterLength += 1;
                                if (IC.length % self.numberOfSpacesPerTab)
                                {
                                    // continue to scan the string not separating white and black characters
                                    continue;
                                }
                                else
                                {
                                    IC.depth = IC.length/self.numberOfSpacesPerTab;
                                    return YES;
                                }
                            }
                            else if ((index = LS.scanLocation),[LS scanCommentSequence])
                            {
                                IC.endsWithTab = NO;
                                IC.afterLength += LS.scanLocation - index;
                                if (IC.length % self.numberOfSpacesPerTab)
                                {
                                    continue;
                                }
                                else
                                {
                                    IC.depth = IC.length/self.numberOfSpacesPerTab;
                                    return YES;
                                }
                            }
                            else
                            {
                                // either the end of the string is reached
                                // or an uncommented black character comes next
                                // Anyway, IC is exactly the last indentation component
                                IC.depth = IC.length/self.numberOfSpacesPerTab;
                                return YES;
                            }
                        }
                        return YES;
                    }
                    else
                    {
                        IC.depth = IC.length/self.numberOfSpacesPerTab;
                        return YES;
                    }
                }
                else if ([LS scanCommentCharacter])
                {
                    IC.endsWithTab = NO;
                    IC.blackLength += 1;
                    if (IC.length % self.numberOfSpacesPerTab)
                    {
                        continue;
                    }
                    else
                    {
                        IC.depth = IC.length/self.numberOfSpacesPerTab;
                        return YES;
                    }
                }
                else if ((index = LS.scanLocation),[LS scanCommentSequence])
                {
                    IC.endsWithTab = NO;
                    IC.blackLength += LS.scanLocation - index;
                    if (IC.length % self.numberOfSpacesPerTab)
                    {
                        continue;
                    }
                    else
                    {
                        IC.depth = IC.length/self.numberOfSpacesPerTab;
                        return YES;
                    }
                }
                else
                {
                    IC.depth = IC.length/self.numberOfSpacesPerTab;
                    return YES;
                }
            }
            return YES;
        }
        else if ((index = LS.scanLocation),[LS scanCommentSequence])
        {
            IC.endsWithTab = NO;
            IC.commentLength = LS.scanLocation - index;// comment will not be used afterwards
            if (IC.length % self.numberOfSpacesPerTab)
            {
                goto continue_after_comment;
            }
            else
            {
                IC.depth = IC.length / self.numberOfSpacesPerTab;
                return YES;
            }
            UNREACHABLE_CODE4iTM3;
        }
        else
        {
            //  no space, no tab, no comment, stop here
            return IC.length > ZER0;
        }
    }
    return IC.length > ZER0;
}
- (NSMutableArray *)_indentationComponentsInString:(NSString *)aString atIndex:(NSUInteger)index beforeIndex:(NSUInteger)before uncommentedOnly:(BOOL)yorn;
/*! Description forthcoming.
*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSMutableArray * result = [NSMutableArray array];
    
    if (index>=aString.length)
        return result;// nothing to do

    const NSUInteger numberOfSpacesPerTab = self.numberOfSpacesPerTab;
    NSAssert2(numberOfSpacesPerTab>ZER0,@"What the hell? This is a HUUUUUGE bug %s:%lu",__FILE__,__LINE__);

    _iTM2IndentationComponent * IC = [_iTM2IndentationComponent indentationComponent];
    IC.location = index;
    iTM2LiteScanner * LS = [self liteScannerWithString:aString];
    LS.scanLocation = index;
    LS.scanLimit = before;
    while ([self _getNextIndentationComponent:IC withScanner:LS alreadyScanned:ZER0 maxDepth:NSUIntegerMax]) {
        if (yorn && IC.commentLength) {
            return result;
        }
        [result addObject:IC.clone];
        IC.reset;
        IC.location = LS.scanLocation;
    }
    return result;
}
- (NSMutableArray *)_indentationComponentsInString:(NSString *)aString atIndex:(NSUInteger)index uncommentedOnly:(BOOL)yorn;
/*! Description forthcoming.
*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self _indentationComponentsInString:aString atIndex:index beforeIndex:aString.length uncommentedOnly:yorn];
}
- (void)getIndentationComponents:(NSMutableArray **)ICsBeforeRef:(NSMutableArray**)ICsAfterRef withScanner:(iTM2LiteScanner *)LS;
/*! Description forthcoming.
*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (ICsBeforeRef) {
        *ICsBeforeRef = [NSMutableArray array];
    }
    if (ICsAfterRef) {
        *ICsAfterRef = [NSMutableArray array];
    }
    _iTM2IndentationComponent * IC  = [_iTM2IndentationComponent indentationComponent];
    while ([self _getNextIndentationComponent:IC withScanner:LS alreadyScanned:ZER0 maxDepth:NSUIntegerMax]) {
        if (IC.commentLength) {
            if (ICsAfterRef) {
                [*ICsAfterRef addObject:IC.clone];
                while ([self _getNextIndentationComponent:IC withScanner:LS alreadyScanned:ZER0 maxDepth:NSUIntegerMax]) {
                    [*ICsAfterRef addObject:IC.clone];
                }
            }
            return;
        } else if (ICsBeforeRef) {
            [*ICsBeforeRef addObject:IC.clone];
        }
    }
}
- (void)updateCurrentPrefix:(NSString **)currentPrefix:(NSArray **)currentICsBefore:(NSArray **)currentICsAfter
            withMacroPrefix:(NSString *)macro:(NSArray *)macro1stICsBefore:(NSArray *)macro1stICsAfter:(NSArray *)macroICsBefore:(NSArray *)macroICsAfter
                selectionPrefix:(NSString *)selection:(NSArray *)selection1stICsBefore:(NSArray *)selection1stICsAfter:(NSArray *)selectionICsBefore:(NSArray *)selectionICsAfter;
{
    ;
}
- (NSString *)indentationStringWithDepth:(NSUInteger)depth;
{
    if (self.usesTabs) {
        //  Complete with simple components with tabs
        return [@"" stringByPaddingToLength:depth withString:@"\t" startingAtIndex:ZER0];
    } else {
        //  Complete with simple components with spaces
        return [@"" stringByPaddingToLength:depth*self.numberOfSpacesPerTab withString:@" " startingAtIndex:ZER0];
    }
}
- (NSString *)stringComplementForLength:(NSUInteger)length;
{
    if (self.usesTabs) {
        return @"\t";
    } else {
        return [@"" stringByPaddingToLength:self.numberOfSpacesPerTab-length % self.numberOfSpacesPerTab withString:@" " startingAtIndex:ZER0];
    }
    return @"";
}
- (NSString *)stringComplementForIndentationComponent:(iTM2IndentationComponent *)IC;
{
    if (!IC.shouldRemainAtTheEnd && !IC.endsWithTab && IC.length % self.numberOfSpacesPerTab) {
        return [self stringComplementForLength:IC.length];
    }
    return @"";
}
- (void)getIndentationPrefix:(NSString **)stringRef:(NSRangePointer)affectedRangeRef change:(NSUInteger)changeInDepth inString:(NSString *)actualS:(NSUInteger)actualIndex availablePrefix:(NSString *)availableS:(NSUInteger)availableIndex;
{
    NSParameterAssert(stringRef);
    if (changeInDepth == ZER0) {
        if (affectedRangeRef) {
            *affectedRangeRef = iTM3MakeRange(ZER0,ZER0);
        }
        *stringRef = @"";
        return;
    }
    _iTM2IndentationComponent * IC  = [_iTM2IndentationComponent indentationComponent];
    iTM2LiteScanner * LS = [self liteScannerWithString:actualS];
    LS.scanLimit = actualS.length;
    LS.scanLocation = actualIndex;
    NSMutableArray * actualICs = [NSMutableArray array];
    while ([self _getNextIndentationComponent:IC withScanner:LS alreadyScanned:ZER0 maxDepth:NSUIntegerMax]) {
        [actualICs addObject:IC.clone];
    }
    if (affectedRangeRef) {
        *affectedRangeRef = [actualICs indentationRange4iTM3];
    }
    NSMutableArray * returnICs = [NSMutableArray array];
    NSString * S1 = @"";
    NSString * S2 = @"";
    NSRange R;
    NSEnumerator * E = nil;
    iTM2IndentationComponent * lastAvailableIC = nil;
    NSMutableArray * availableICs = [self _indentationComponentsInString:availableS atIndex:availableIndex uncommentedOnly:NO];
    if (actualICs.count) {
        //  How do I manage the last indentation component?
        //  Different possibilities
        //  - complete actual ICs before adding more stuff,
        //    and use the last IC of available to close things
        //  - remove the last actual IC if it is not complete,
        //    add the expected depth
        //    and use instead the last available IC if any
        //  - if the last IC is commented and has 0 depth, it should remain the last IC
        //  We choose the last item and the first one.
        iTM2IndentationComponent * lastActualIC  = actualICs.lastObject;
        //  Shall we keep the last indentation component
        if (lastActualIC.shouldRemainAtTheEnd) {
            //  Yes
            [actualICs removeLastObject];
        }
        //  There are already used indentation components
        if (availableICs.count) {
            //  And there is a bunch of available components to work with
            lastAvailableIC  = availableICs.lastObject;
            if (!lastAvailableIC.shouldRemainAtTheEnd) {
                lastAvailableIC = nil;
            }
            //  Create the indentatin prefix
            R = [actualICs indentationRange4iTM3];
            S1 = [actualS substringWithRange:R];
            //  Should we complete?
            S2 = [self stringComplementForIndentationComponent:lastActualIC];
            S1 = [S1 stringByAppendingString:S2];
            //  add indentation components from the available ones
            for (IC in availableICs) {
                if (IC == lastAvailableIC) {
                    break;
                } else if (IC.depth < changeInDepth) {
                    changeInDepth -= IC.depth;
                    [returnICs addObject:IC];
                    continue;
                } else if (IC.depth == changeInDepth) {
                    [returnICs addObject:IC];
                    R = [returnICs indentationRange4iTM3];
                    S2 = [availableS substringWithRange:R];
                    S1 = [S1 stringByAppendingString:S2];
                    if (lastAvailableIC) {
                        R = lastAvailableIC.range;
                        S2 = [availableS substringWithRange:R];
                        S1 = [S1 stringByAppendingString:S2];
                    } else if (lastActualIC) {
                        R = lastActualIC.range;
                        S2 = [actualS substringWithRange:R];
                        S1 = [S1 stringByAppendingString:S2];
                    }
                    *stringRef = S1;
                    return;                                
                }
            }
            R = [returnICs indentationRange4iTM3];
            S2 = [availableS substringWithRange:R];
            S1 = [S1 stringByAppendingString:S2];
            //  No more ICs available, I must complete with default ones
            if (changeInDepth) {
                S2 = [self indentationStringWithDepth:changeInDepth];
                S1 = [S1 stringByAppendingString:S2];
            }
            //  Now add lastAvailableIC if any
            if (lastAvailableIC) {
                R = lastAvailableIC.range;
                S2 = [availableS substringWithRange:R];
                S1 = [S1 stringByAppendingString:S2];
            }
            //  Terminate
            *stringRef = S1;
            return;                                
        } else {
            //  No available ICs
            //  First complete the last component of actualICs if any
            R.length = LS.scanLocation = lastActualIC.nextLocation;
            if ([LS scanCharacterBackwards:'\t']) {
                S2 = [self indentationStringWithDepth:changeInDepth];
                S1 = [actualS stringByAppendingString:S2];
                *stringRef = S1;
                return;
            }
            //  No tab, only spaces and comment sequences
            //  compute in R the range of trailing spaces
            if (lastActualIC.commentLength) {
                while ([LS scanCharacterBackwards:' ']) {;}
                R.location = LS.scanLocation;
                R.length -= R.location;
            } else {
                R = lastActualIC.range;
            }
            //  Does it span over an indentation limit
            NSUInteger reminder = lastActualIC.length % self.numberOfSpacesPerTab;
            if (reminder > R.length) {
                //  rightmost part of the prefix: uncomplete indentation component
                //  The length does not change modulo self.numberOfSpacesPerTab
                S2 = [@"" stringByPaddingToLength:reminder withString:@" " startingAtIndex:ZER0];
                if (--changeInDepth) {
                    //  whole components, except the first one
                    S1 = [self indentationStringWithDepth:changeInDepth];
                    S2 = [S1 stringByAppendingString:S2];//S1 = @"";
                }
                S1 = [self stringComplementForLength:reminder-R.length];
                S1 = [S1 stringByAppendingString:S2];
                *stringRef = S1;
                if (affectedRangeRef) {
                    *affectedRangeRef = R;
                }
                return;
            }
            //  reminder <= R.length
            //  We insert indentation components
            R.location += R.length - reminder;
            R.length = ZER0;
            *stringRef = [self indentationStringWithDepth:changeInDepth];
            if (affectedRangeRef) {
                *affectedRangeRef = R;
            }
            return;
        }
        UNREACHABLE_CODE4iTM3;
    } else if (availableICs.count) {
        //  No indentation already defined
        //  Only indentation from availableICs
        E = availableICs.objectEnumerator;
        while ((IC = E.nextObject)) {
            if (IC.depth < changeInDepth) {
                [returnICs addObject:IC];
                changeInDepth -= IC.depth;
                continue;
            } else if (IC.depth == changeInDepth) {
                [returnICs addObject:IC];
                R = [returnICs indentationRange4iTM3];
                *stringRef = [availableS substringWithRange:R];
                return;
            } else if (IC.contentLength) {
                //  IC.depth > changeInDepth
                //  IC starts with white spaces
                //  its depth is more than 1 which means that it is commented
                //  We make a recursive call
                R.location = IC.location + IC.contentLength;
                R.length = IC.length - IC.contentLength;
                R.length += [[E allObjects] indentationLength4iTM3];
                availableS = [availableS substringWithRange:R];
                [self getIndentationPrefix:&S2:nil change:changeInDepth inString:@"":ZER0 availablePrefix:availableS:ZER0];
                *stringRef = [*stringRef stringByAppendingString:S2];
                return;
            } else {
                //  IC.depth > changeInDepth
                //  try to break IC after the comment, but before the black characters
                R.location = IC.location;
                R.length = IC.commentLength;
                changeInDepth -= R.length / self.numberOfSpacesPerTab;
                if (changeInDepth > ZER0) {
                    S2 = [availableS substringWithRange:R];
                    //  Complete R to an indentation component
                    //  Only spaces or tab
                    S1 = [self stringComplementForLength:R.length];
                    if (S1.length) {
                        S2 = [S2 stringByAppendingString:S1];//S1 = @"";
                        //  remove one depth level
                        --changeInDepth;
                        //  Add missing components
                        if (changeInDepth > ZER0) {
                            S1 = [self indentationStringWithDepth:changeInDepth];
                            S2 = [S2 stringByAppendingString:S1];//S1 = @"";
                        }
                    } else if (changeInDepth > ZER0) {
                        S1 = [self indentationStringWithDepth:changeInDepth];
                        S2 = [S2 stringByAppendingString:S1];//S1 = @"";
                    } else {
                        S1 = @" ";
                        S2 = [S2 stringByAppendingString:S1];//S1 = @"";
                    }
                } else if (changeInDepth == ZER0) {
                    S2 = [availableS substringWithRange:R];
                    //  add a space?
                }
                R = [returnICs indentationRange4iTM3];
                if (R.length) {
                    S1 = [availableS substringWithRange:R];
                    S2 = [S1 stringByAppendingString:S2];
                }
                *stringRef = S2;
                return;
            }
            UNREACHABLE_CODE4iTM3;
        }
        UNREACHABLE_CODE4iTM3;
    } else {
        *stringRef = [self indentationStringWithDepth:changeInDepth];
        return;
    }
    UNREACHABLE_CODE4iTM3;
}
- (void)getUnindentationPrefix:(NSString **)stringRef:(NSRangePointer)affectedRangeRef change:(NSUInteger)changeInDepth inString:(NSString *)actualS:(NSUInteger)actualIndex;
{
    //  Unindentation is not straightforward because we must know the whole indentation header
    //  in order to determine precisely what we are allowed to remove.
    //  We make different passes, each one being more precise.
    NSParameterAssert(stringRef);
    NSParameterAssert(affectedRangeRef);
    
    const NSUInteger numberOfSpacesPerTab = self.numberOfSpacesPerTab;
    NSAssert2(numberOfSpacesPerTab>ZER0,@"What the hell? This is a HUUUUUGE bug %s:%lu",__FILE__,__LINE__);

    __iTM2IndentationComponent * IC = nil;
    __iTM2IndentationComponent * firstCommentedIC = nil;
    __iTM2IndentationComponent * lastIC = nil;
    
    iTM2LiteScanner * LS = [self liteScannerWithString:actualS];
    LS.scanLimit = actualS.length;
    LS.scanLocation = actualIndex;
    //  scan actualS to split the indentation prefix into the parts before and after the first commented sequence
    NSMutableArray * ICsBefore = [NSMutableArray array];
    NSMutableArray * ICsAfter  = [NSMutableArray array];
    [self getIndentationComponents:&ICsBefore:&ICsAfter withScanner:LS];
    firstCommentedIC = ICsAfter.count?[ICsAfter objectAtIndex:ZER0]:nil;
    lastIC = ICsAfter.lastObject?:ICsBefore.lastObject;

    if (ICsBefore.count) {
        IC = [ICsBefore objectAtIndex:ZER0];
        affectedRangeRef->location = IC.location;
        affectedRangeRef->length = lastIC.nextLocation - affectedRangeRef->location;
    } else if (firstCommentedIC) {
        affectedRangeRef->location = firstCommentedIC.location;
        affectedRangeRef->length = lastIC.nextLocation - affectedRangeRef->location;
    } else {
        //  No indentation prefix at all
        affectedRangeRef->location = actualIndex;
        affectedRangeRef->length = ZER0;
        *stringRef = ZER0;
        return;
    }
    if (changeInDepth == ZER0) {
        * stringRef = affectedRangeRef->length?[actualS substringWithRange:*affectedRangeRef]:@"";
        return;
    }
    NSUInteger expectedReminder = lastIC.endsWithTab? ZER0: lastIC.length%self.numberOfSpacesPerTab;
    NSUInteger actualReminder = ZER0;
    //  We will try to keep the expected reminder
    NSUInteger depth = [ICsAfter indentationDepth4iTM3];
    NSString * S1 = @"";
    NSString * S2 = @"";
    NSUInteger lastBreak = ZER0;
    NSUInteger expectedDepth = ZER0;
    NSUInteger expectedLength = ZER0;
    NSUInteger expectedLocation = ZER0;
    NSUInteger idx = ZER0;
    NSRange R = iTM3MakeRange(actualIndex,ZER0);
    if (depth - firstCommentedIC.depth >= changeInDepth) {
        //  firstCommentedIC.depth >ZER0(easy to proove)
        expectedDepth = depth - changeInDepth;
        //  expectedDepth is related to the expected depth once the unindentation is complete
        //  What will be removed comes from this part which is
        //  located after the first commented indentation component
        //  What components will be kept as is?
        /// We skip over the first objects of ICsAfter that will not be removed
        R.location = affectedRangeRef->location;
        //  We keep firstCommentedIC
        expectedDepth -= firstCommentedIC.depth;
        idx = 1;
        while (idx < ICsAfter.count) {
            //  expectedDepth >=ZER0=> ICsAfter.count >ZER0            IC = [ICsAfter objectAtIndex:idx++];
            R.length = IC.location - R.location;
            if (IC.depth <= expectedDepth) {
                //  we can safely keep this component
                expectedDepth -= IC.depth;
                //  we still have depth >=ZER0                continue;
            } else if (expectedDepth) {
                S1 = [actualS substringWithRange:R];// what has been registered so far
                //  We will return the method from this block
                //  IC is too big because IC.depth > expectedDepth >ZER0                //  We have IC.depth
                //  We want instead expectedDepth
                //  The expected length is exactly (no tab):
                expectedLength = expectedDepth * self.numberOfSpacesPerTab;
                //  Can I break IC just before the expected length?
                R.location = LS.scanLocation = IC.location;
                expectedLocation = R.location + expectedLength;
                actualReminder = ZER0;
                depth = ZER0;
                while (LS.scanLocation < expectedLocation) {
                    if ([LS scanCharacter:'\t']) {
                        ++R.length;
                        ++depth;
                        actualReminder = ZER0;
                        break;
                    } else if ([LS scanCommentCharacter] || [LS scanCharacter:' ']) {
                        ++R.length;
                    } else if ([LS scanCommentSequence] && (LS.scanLocation <= expectedLocation)) {
                        R.length = LS.scanLocation - R.location;
                    } else {
                        break;
                    }
                    actualReminder = R.length % self.numberOfSpacesPerTab;
                    depth = R.length / self.numberOfSpacesPerTab;
                }
                //  actualReminder and depth are properly set
                S2 = [actualS substringWithRange:R];
                S1 = [S1 stringByAppendingString:S2];
                if (depth < expectedDepth) {
                    S2 = [self stringComplementForLength:lastBreak];
                    S1 = [S1 stringByAppendingString:S2];
                    actualReminder = ZER0;
                    if (S1.length) {
                        --depth;
                    }
                    S2 = [self indentationStringWithDepth:depth];
                    S1 = [S1 stringByAppendingString:S2];
                    //  actualReminder is still 0
                    //  Should I complete partially ?
                    if ([S1 hasSuffix:@"\t"]) {
                        actualReminder = ZER0;
                    }
                }
            }
            //  try to keep the same reminder
            if (expectedReminder > actualReminder) {
                S2 = [@"" stringByPaddingToLength:expectedReminder-actualReminder withString:@" " startingAtIndex:ZER0];
                S1 = [S1 stringByAppendingString:S2];
            }
            *stringRef = S1;
            return;
        }
        UNREACHABLE_CODE4iTM3;
        *stringRef = S1;
        return;
    }
    //  all the components following firstUncommentedIC in ICsAfter are removed
    //  depth - firstCommentedIC.depth < changeInDepth
    changeInDepth -= depth - firstCommentedIC.depth;
    //  depth = ZER0;
    //  changeInDepth is now what we have to remove from either firstCommentedIC or what is before
    //  S1 = @"";
    //  We build the replacement string finally stored in *stringRef from the rhs
    if (firstCommentedIC) {
        //  We remove stuff from firstCommentedIC, but we must keep the comment sequence or character
        //  If this is not sufficient we will also remove stuff from what is before in ICsBefore
        R.location = LS.scanLocation = firstCommentedIC.location;
        //  scan leading spaces
        NSUInteger leading = ZER0;
        while ([LS scanCharacter:' ']) {
            ++leading;
        }
        //  scan a comment to keep in afterwards
        [LS scanCommentSequence] || [LS scanCommentCharacter];
        R.length = LS.scanLocation - R.location;
        expectedDepth = firstCommentedIC.depth >= changeInDepth? firstCommentedIC.depth - changeInDepth:ZER0;
        expectedLength = expectedDepth * self.numberOfSpacesPerTab + expectedReminder;// this will be the trailer
        if (!expectedLength) {
            expectedDepth = 1;
            expectedLength = self.numberOfSpacesPerTab;
        }
        expectedLocation = R.location + expectedLength;
        actualReminder = R.length % self.numberOfSpacesPerTab;
        depth = R.length / self.numberOfSpacesPerTab;
        while (LS.scanLocation < expectedLocation) {
            if ([LS scanCharacter:'\t']) {
                ++R.length;
                ++depth;
                actualReminder = ZER0;
                break;
            } else if ([LS scanCommentCharacter] || [LS scanCharacter:' ']) {
                ++R.length;
            } else if ([LS scanCommentSequence] && (LS.scanLocation <= expectedLocation)) {
                R.length = LS.scanLocation - R.location;
            } else {
                break;
            }
            actualReminder = R.length % self.numberOfSpacesPerTab;
            depth = R.length / self.numberOfSpacesPerTab;
        }
        //  R.length >= expectedLength;
        //  What did we really remove from the first commented IC:
        if (R.length > expectedLength && leading) {
            //  too big, try without the leading spaces
            R.location += leading;
            LS.scanLocation = R.location;
            [LS scanCommentSequence] || [LS scanCommentCharacter];
            R.length = LS.scanLocation - R.location;
            expectedDepth = firstCommentedIC.depth >= changeInDepth? firstCommentedIC.depth - changeInDepth:ZER0;
            expectedLength = expectedDepth * self.numberOfSpacesPerTab + expectedReminder;
            if (!expectedLength) {
                expectedDepth = 1;
                expectedLength = self.numberOfSpacesPerTab;
            }
            expectedLocation = R.location + expectedLength;
            actualReminder = R.length % self.numberOfSpacesPerTab;
            depth = R.length / self.numberOfSpacesPerTab;
            while (LS.scanLocation < expectedLocation) {
                if ([LS scanCharacter:'\t']) {
                    ++R.length;
                    ++depth;
                    actualReminder = ZER0;
                    break;
                } else if ([LS scanCommentCharacter] || [LS scanCharacter:' ']) {
                    ++R.length;
                } else if ([LS scanCommentSequence] && (LS.scanLocation <= expectedLocation)) {
                    R.length = LS.scanLocation - R.location;
                } else {
                    break;
                }
                actualReminder = R.length % self.numberOfSpacesPerTab;
                depth = R.length / self.numberOfSpacesPerTab;
            }
            //  R.length >= expectedLength;
            //  What did we really remove from the first commented IC:
        }
        S1 = [actualS substringWithRange:R];
        if (depth < expectedDepth) {
            //  we must complete
            S2 = [self stringComplementForLength:S1.length];
            if (S2.length) {
                S1 = [S1 stringByAppendingString:S2];
                ++depth;
            }
            actualReminder = ZER0;
            if (depth < expectedDepth) {
                S2 = [self indentationStringWithDepth:expectedDepth - depth];
                S1 = [S1 stringByAppendingString:S2];
            }
            //  How many uncommented components should be removed from ICsBefore:
            changeInDepth = ZER0;
        } else {
            // depth >= expectedDepth
            //  How many uncommented components should be removed from ICsBefore:
            //  firstCommentedIC.depth - depth is what was removed from firstCommentedIC
            depth = firstCommentedIC.depth - depth;
            if (changeInDepth > depth) {
                changeInDepth -= depth;
            } else {
                changeInDepth = ZER0;
            }
        }
        if (actualReminder > expectedReminder) {
            if (ICsBefore.count>changeInDepth+1) {
                ++changeInDepth;
                S2 = [self stringComplementForLength:S1.length];
                S1 = [S1 stringByAppendingString:S2];
                S2 = [@"" stringByPaddingToLength:expectedReminder withString:@" " startingAtIndex:ZER0];
                S1 = [S1 stringByAppendingString:S2];
            }
        } else if (expectedReminder > actualReminder) {
            S2 = [@"" stringByPaddingToLength:expectedReminder-actualReminder
                withString:@" " startingAtIndex:ZER0];
            S1 = [S1 stringByAppendingString:S2];
        }
    } else if (expectedReminder) {
        S2 = [@"" stringByPaddingToLength:expectedReminder withString:@" " startingAtIndex:ZER0];
        S1 = [S1 stringByAppendingString:S2];
    }
    //  Finally, recover the uncommented indentation components
    //  ICsBefore.count - 1 is the depth of all the uncommented indentation components of ICsBefore
    if (changeInDepth && (changeInDepth < ICsBefore.count)) {
        //  if changeInDepth is too big, we remove everything
        //  here we only remove parts
        R.location = affectedRangeRef->location;
        IC = [ICsBefore objectAtIndex:ICsBefore.count-changeInDepth];
        R.length = IC.location - R.location;
        S2 = [actualS substringWithRange:R];
        S1 = [S2 stringByAppendingString:S1];
    }
    *stringRef = S1;
    return;
}
- (NSString *)_stringByUnindentingString:(NSString *)aString;
{
    iTM2LiteScanner * S = [self liteScannerWithString:aString];
    S.scanLocation = ZER0;
    NSMutableString * result = [NSMutableString string];
    NSUInteger index;
next_character:
    index = S.scanLocation;
    if ([S scanCommentSequence])
    {
        [result appendString:[aString substringWithRange:iTM3MakeRange(index,S.scanLocation-index)]];
        while(![S isAtEnd])
        {
            if ([S scanCharacter:' '])
            {
                [result appendString:@" "];
                return result;
            }
            index = S.scanLocation;
            if ([S scanCommentSequence])
            {
                [result appendString:[aString substringWithRange:iTM3MakeRange(index,S.scanLocation-index)]];
                continue;
            }
            else if ([S scanCharacter:'\t'])
            {
                continue;
            }
            break;
        }
        return result;
    }
    else if ([S scanCharacter:'\t'] || [S scanCharacter:' '])
    {
        goto next_character;
    }
    return result;
}
- (NSString *)_stringByIndentingString:(NSString *)aString;
{
    // aString should not contain any tab character
    // this does not prevent the method to work but the overall result would not be as expected
    if (aString.length>=self.numberOfSpacesPerTab)
    {
        return aString;
    }
    iTM2LiteScanner * LS = [self liteScannerWithString:aString];
    LS.scanLocation = ZER0;
    NSMutableString * result = [NSMutableString string];
    NSUInteger index;
    index = LS.scanLocation;
    if ([LS scanCommentSequence])
    {
        [result appendString:[aString substringWithRange:iTM3MakeRange(index,LS.scanLocation-index)]];
        while(![LS isAtEnd])
        {
            if ([LS scanCharacter:' '])
            {
                [result appendString:@" "];
terminate:
                if (self.usesTabs)
                {
                    [result appendString:@"\t"];
                    return result;
                }
                else
                {
                    return [result stringByPaddingToLength:self.numberOfSpacesPerTab withString:@" " startingAtIndex:ZER0];
                }
            }
            else if ([LS scanCharacter:' ']||[LS scanCommentSequence])
            {
                continue;
            }
            break;
        }
        goto terminate;
    }
    else if ([LS scanCharacter:' '])
    {
        [result appendString:self.indentationString];
        [result appendString:aString];
        return result;
    }
    return self.indentationString;
}
- (BOOL)_remove:(NSUInteger)level indentationComponentsIn:(NSMutableArray *)ICs forString:(NSString *)aString;
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSUInteger depth = [[ICs valueForKeyPath:@"self.@sum.depth"] unsignedIntegerValue];
    _iTM2IndentationComponent * IC = nil;
    _iTM2IndentationComponent * ic = nil;
    if (level>=depth)
    {
        // we must remove all the indentation components
        // but we must not remove the comments
        // so retrieve the starting comment sequence if any
        NSArray * copy = [ICs.copy autorelease];
        [ICs removeAllObjects];
        for(IC in copy)
        {
            if (IC.commentLength)
            {
                // is the last indentation a commented object too?
                ic = copy.lastObject;
                if (ic.commentLength)
                {
                    // yes it is.
                    ic = ic.clone;// don't mess up with the originals
                    ic.depth = ZER0;
                    if (level==depth)
                    {
                        ic.contentLength = ZER0;
                    }
                    [ICs addObject:ic];
                    break;
                }
                // there is a comment here
                // we keep this component but set its depth as 0
                // the client will take the appropriate actions
                IC.depth = ZER0;
                [ICs addObject:IC];
                break;
            }
        }
        // What about the last indentation object?
        if (!ICs.count && level == depth)
        {
            if (YES)
            {
            }
        }
        return YES;
    }
    // level < depth
    // we must not remove all the components
    // first we record the indexes of the items we want to remove.
    NSMutableIndexSet * MIS = [NSMutableIndexSet indexSet];
    // the fist index corresponds to the first component which is not commented
    if (level)
    {
        NSUInteger idx = ZER0;
        while(idx<ICs.count)
        {
            IC = [ICs objectAtIndex:idx];
            if (IC.commentLength)
            {
                // keep this index
                // remove the following ones as long as necessary
                // first try to remove the biggest components
                NSUInteger track = idx;
                while(++idx<ICs.count)
                {
                    IC = [ICs objectAtIndex:idx];
                    if (IC.depth>level)
                    {
                        // If I remove this component, the indentation will not be deep enough
                        // insert indentation strings to compensate
                        ic = [_iTM2IndentationComponent indentationComponent];
                        ic.location = IC.location;
                        ic.depth = IC.depth-level;
                        [ICs insertObject:ic.clone atIndex:idx+1];// this object has a 0 length but a non zero depth, clients will manage this properly
                        [MIS addIndex:idx];
                        [ICs removeObjectsAtIndexes:MIS];
                        return YES;
                    }
                    else if (IC.depth)
                    {
                        [MIS addIndex:idx];
                        if (level -= IC.depth)
                        {
                            continue;
                        }
                        [ICs removeObjectsAtIndexes:MIS];
                        return YES;                        
                    }
                }
                // every true indentation component but the first commented one (at index "track") is removed
                IC = [ICs objectAtIndex:track];
                if (IC.depth>level)
                {
                    IC.depth -= level;
                    IC.contentLength = ZER0;
                    [ICs removeObjectsAtIndexes:MIS];
                    return YES;                        
                }
                else if (IC.depth==level)
                {
                    // if the last component is a 0 depth commented component, remove object at index track
                    // but keep the last object
                    ic = ICs.lastObject;
                    if (ic.depth==ZER0)
                    {
                        if (ic.commentLength)
                        {
                            [MIS addIndex:track];
                            [ICs removeObjectsAtIndexes:MIS];
                            return YES;                        
                        }
                        else
                        {
                            // remove the last indentation component
                            [MIS addIndex:ICs.count-1];// ICs.count 0 here!
                        }
                    }
                    IC.depth = ZER0;
                    IC.contentLength = ZER0;
                    [ICs removeObjectsAtIndexes:MIS];
                    return YES;                        
                }
                return NO;
            }
            else if (IC.depth > 1)
            {
                // we assume that uncommented indentation components are of depth 1
                NSAssert(NO,@"Internal inconsistency, bad programming in _remove:indentationComponentsIn:");
            }
            else if (IC.depth)
            {
                [MIS addIndex:idx];
                level -= IC.depth;
                if (!level)
                {
                    [ICs removeObjectsAtIndexes:MIS];
                    return YES;                        
                }
            }
            ++idx;
        }
        // not enough full components to be removed
        // the only acceptable situation where the return value is YES is level == 1 and one component left
        if ((level == 1) && ((IC = ICs.lastObject),!IC.depth))
        {
            IC.contentLength = ZER0;
            [ICs removeObjectsAtIndexes:MIS];
            return YES;                        
        }
        return NO;
    }
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByNormalizingIndentationInString:
- (NSString *)stringByNormalizingIndentationInString:(NSString *)aString;
/*"Description forthcoming.
 Version history: jlaurens AT users.sourceforge.net
 - 2.0: 
 To Do List: ?
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	NSArray * lineComponents = [aString lineComponents4iTM3];
	NSMutableArray * normalizedComponents = [NSMutableArray arrayWithCapacity:lineComponents.count];
	for(NSString * line in lineComponents)
	{
        NSArray * indentationComponents = [self _indentationComponentsInString:line atIndex:ZER0 uncommentedOnly:NO];
        NSEnumerator * E = indentationComponents.objectEnumerator;
        NSNumber * N = nil;
        NSString * IC = nil;
        NSUInteger charIndex = ZER0;
        while((N = E.nextObject) && (IC = E.nextObject))
        {
            charIndex += [N unsignedIntegerValue];
            [normalizedComponents addObject:IC];
        }
        if (charIndex<line.length)
        {
            NSString * tail = [line substringFromIndex:charIndex];
            [normalizedComponents addObject:tail];
        }
	}
	//END4iTM3;
	return [normalizedComponents componentsJoinedByString:@""];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringWithIndentationLevel:atIndex:inString:
- (NSString *)stringWithIndentationLevel:(NSUInteger)indentation atIndex:(NSUInteger)index inString:(NSString *)aString;
/*"Description forthcoming.
 Version history: jlaurens AT users.sourceforge.net
 - 2.0: 02/15/2006
 To Do List: ?
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
    NSUInteger numberOfSpacesPerTab = self.numberOfSpacesPerTab;
	NSMutableString * result = [NSMutableString string];
	NSRange lineRange = iTM3MakeRange(index,ZER0);
	lineRange = [aString lineRangeForRange:lineRange];// the line range containing the given index
	NSString * string = [aString substringToIndex:lineRange.location];// everything before the line
	[result appendString:string];// copied as is
	// now append the expected indentation for the line containing index
	NSString * tabString = nil;
	NSUInteger idx = numberOfSpacesPerTab;
	if (idx<ZER0)
	{
		tabString = @"\t";
	}
	else
	{
		NSMutableString * MS = [NSMutableString string];
		while(idx--)
		{
			[MS appendString:@" "];
		}
		tabString = [[MS copy] autorelease];
	}
	while(indentation--)
	{
		[result appendString:tabString];
	}
	// now copying the line without its white prefix
	NSUInteger top = iTM3MaxRange(lineRange);
	NSCharacterSet * whiteSet = [NSCharacterSet whitespaceCharacterSet];
	while(lineRange.location<top)
	{
		unichar theChar = [aString characterAtIndex:lineRange.location];
		if (![whiteSet characterIsMember:theChar])
		{
			break;
		}
		++lineRange.location;
	}
	lineRange.length = top - lineRange.location;
	string = [aString substringWithRange:lineRange];
	[result appendString:string];
	// finally copy the rest of the receiver as is
	string = [aString substringFromIndex:top];
	[result appendString:string];
	//END4iTM3;
	return result;
}
- (NSInteger)__prepareIndentationChange:(NSUInteger)depthChange atIndex:(NSUInteger)idx inString:(NSString *)S withReplacementString:(NSMutableArray *)replacementStrings affectedRanges:(NSMutableArray *)affectedRanges;
/* Explanation of the indentation
The "indentation prefix" is the set of all spaces, tabs and comment sequences at the beginning of a line.
It is used to align the text between lines. The alignment is measured by the indentation depth, see below.
It is a sequence of indentation components.
The indentation components are sequences of space, tabs and comment subsequences following those rules
R1: ends with a tab
R2: the tab is only at the end
R3: if R1 is not fullfilled, the number of characters is an integer multiple of the "number of spaces per tab"
R4: the length is the smallest one to follow rules R1, R2 and R3 from the beginning of the line.
These indentation components are named ICs.
The depth of the indentation component is calculated as follows:
1 - replace all the characters of the comment sequences by a space character
2 - reapply the rule Rs above
3 - the depth of the component is exactly the number of components obtained
The depth of the indentation prefix is the sum of the depth of all the indentation components.
Notice that an indentation component can have an arbitrary depth.
The purpose of this method is to remove some indentation components.
On return, the given replacementStrings and affectedRanges contain enough information to make the changes.
What is the rule to remove the indentation components?
We need some rule because we do not want to ignore comment sequences.
A comment sequence is not a neutral command. If we simply remove an indentation component that contains a comment sequence,
we can activate the end of the line and change the meaning of the input text.
This first problem is even more difficult because indentation components can have a depth greater than one.
*/
{
    NSInteger changeInLength = ZER0;
    if (idx>S.length || depthChange <= ZER0)
    {
        return changeInLength;
    }
    NSRange affected = iTM3MakeRange(idx,ZER0);
    NSString * replacement = @"";
    [S getLineStart:&affected.location end:nil contentsEnd:nil forRange:affected];
    iTM2LiteScanner * LS = [self liteScannerWithString:S];
    LS.scanLocation = affected.location;
    NSUInteger numberOfPendingChars = ZER0;
#pragma mark 1 - scan leading uncommented ICs
    while(YES) {
        if ([LS scanCharacter:' ']) {
            ++numberOfPendingChars;
            if (numberOfPendingChars < self.numberOfSpacesPerTab
                    || ((numberOfPendingChars = ZER0),--depthChange)) {
                continue;
            }
            affected.length = LS.scanLocation - affected.location;
            //ZER0== depthChange
            // we remove the full indentation components that are just before the last comment.
            // this is not for the case with comments
        } else if ([LS scanCharacter:'\t']) {
            numberOfPendingChars = ZER0;
            if (--depthChange) {
                continue;
            }
        } else if ((idx = LS.scanLocation), [LS scanCommentSequence]) {
            // jump to "complete the first commented IC" below
            break;
        } else {
            // we have reached the end of the head part of the line
            // with no comment
            // depthChange is still >ZER0 the requested modification cannot be honored
            // we remove everything
        }
        affected.length = LS.scanLocation - affected.location;
#define REGISTER(STRING)\
        if (affected.length || STRING.length)\
        {\
            [replacementStrings addObject:STRING];\
            [affectedRanges addObject:[NSValue valueWithRange:affected]];\
            changeInLength -= affected.length - replacement.length;\
            affected.location += affected.length;\
            affected.length = ZER0;\
        }
register_and_terminate:
        REGISTER(replacement);
        return changeInLength;
    }
    // a comment was found
    // remove the white ICs found so far
#pragma mark 2 - complete the first commented IC
    // we record the exact composition of this commented IC
    // starting with the leading spaces
    // we scan characters until we find a tab, the proper number of chars or the end of the line white prefix
    NSUInteger lastCommentedICLocation, commentDepth, newNumberOfPendingChars, numberOfTrailingWhites, breakLocation;
    NSIndexPath * ICsComment, * uncommentedICsAfter;
    NSRange commentRange;
did_start_last_commented_IC_candidate:
    lastCommentedICLocation = idx - numberOfPendingChars;
    affected.length = lastCommentedICLocation - affected.location;
    REGISTER(replacement);
    // range of the first comment sequence in S
    commentRange.location = idx;
    commentRange.length = LS.scanLocation - commentRange.location;
    ICsComment = nil;// record the possible break point
    uncommentedICsAfter = nil;
    numberOfPendingChars += LS.scanLocation-idx;
    numberOfTrailingWhites = ZER0;
    breakLocation = LS.scanLocation-idx;// same as numberOfPendingChars but ignores previous spaces
    while(YES) {
        if ([LS scanCharacter:' ']) {
            // record the composition of the IC
            ++ numberOfTrailingWhites;
            if (++breakLocation % self.numberOfSpacesPerTab == ZER0) {
                ICsComment = ICsComment?
                    [ICsComment indexPathByAddingIndex:LS.scanLocation]:
                    [NSIndexPath indexPathWithIndex:LS.scanLocation];
                ICsComment = [ICsComment indexPathByAddingIndex:1];            
                // reset breakLocation
                breakLocation = ZER0;
            }
            if ((newNumberOfPendingChars = ++numberOfPendingChars % self.numberOfSpacesPerTab)) {
                // this is not the end of the component
                continue;
            }
            // proper number of chars: the commented component is complete
            // now scan for all the uncommented ICs after
#pragma mark 3 - Scan uncommented ICs
scan_uncommented_ICs:
            commentDepth = numberOfPendingChars / self.numberOfSpacesPerTab;
            numberOfPendingChars = ZER0;
            uncommentedICsAfter = [NSIndexPath indexPathWithIndex:LS.scanLocation];
            while(YES) {
                // in this loop, only spaces and tabs
                if ([LS scanCharacter:' ']) {
                    if (++numberOfPendingChars<self.numberOfSpacesPerTab) {
                        continue;
                    }
                    uncommentedICsAfter = [uncommentedICsAfter indexPathByAddingIndex:LS.scanLocation];
                    numberOfPendingChars = ZER0;
                    continue;
                } else if ([LS scanCharacter:'\t']) {
                    uncommentedICsAfter = [uncommentedICsAfter indexPathByAddingIndex:LS.scanLocation];
                    numberOfPendingChars = ZER0;
                    continue;
                } else if ((idx = LS.scanLocation), [LS scanCommentSequence]) {
                    // I found a new comment
                    // what is the actual depth?
                    if (commentDepth + uncommentedICsAfter.length - 1 < depthChange) {
                        // not enough material, but we can safely remove what is before idx - numberOfPendingChars
                        goto did_start_last_commented_IC_candidate;
                    }
                    // we have enough material
                    // commentDepth + uncommentedICsAfter.length - 1 >= depthChange
                    if (commentDepth <= depthChange) {
                        // we remove the comment and enough following uncommented ICs
                        affected.location = lastCommentedICLocation;
                        affected.length = [uncommentedICsAfter indexAtPosition:commentDepth - depthChange] - affected.location;
                        goto register_and_terminate;
                    }
                    // commentDepth > depthChange
                    // Removing the comment will remove too much
                    // we must compensation and insert as many indentation strings as necessary
                    affected.location = lastCommentedICLocation;
                    affected.length = [uncommentedICsAfter indexAtPosition:ZER0] - affected.location;
                    commentDepth -= depthChange;
                    NSMutableArray * MRA = [NSMutableArray arrayWithCapacity:commentDepth];
                    while(commentDepth--) {
                        [MRA addObject:self.indentationString];
                    }
                    replacement = [MRA componentsJoinedByString:@""];
                    goto register_and_terminate;
                } else {
                    // the end of the white line prefix is reached
                    // no other comment was found
                    // can I remove only white components?
                    if (uncommentedICsAfter.length - 1 >= depthChange) {
                        // leave the commented IC as is
                        // remove what comes next
                        affected.location = [uncommentedICsAfter indexAtPosition:ZER0];
                        affected.length = [uncommentedICsAfter indexAtPosition:depthChange] - affected.location;
                        goto register_and_terminate;
                    }
                    // uncommentedICsAfter.length < depthChange
                    // remove what can be removed after the comment and replace properly the commented IC
                    depthChange -= uncommentedICsAfter.length - 1;
                    // now I must remove depthChange from the commented IC
                    // The actual length of the comment is
                    // [uncommentedICsAfter indexAtPosition:ZER0] - lastCommentedICLocation
                    // the comment depth is therefore
edit_commented_IC:
                    affected.location = lastCommentedICLocation;
                    affected.length = LS.scanLocation - affected.location;
                    commentDepth = 1 + ([uncommentedICsAfter indexAtPosition:ZER0] - lastCommentedICLocation - 1)
                        / self.numberOfSpacesPerTab; // true whether the commented IC ends with a tab or not
                    // if the commented IC starts with a series of spaces, it is possible that removing these leading spaces
                    // changes the depth of the whole IC.
                    // the expected depth is commentDepth - depthChange
                    if (commentDepth>depthChange) {
                        NSUInteger alreadySpace = ZER0;
                        commentDepth -= depthChange;
                        for(idx = ZER0; idx<ICsComment.length;++idx) {
                            commentRange.length = [ICsComment indexAtPosition:idx] - commentRange.location;
                            alreadySpace = [ICsComment indexAtPosition:++idx];
                            if (1+(commentRange.length - 1)/self.numberOfSpacesPerTab >= commentDepth) {
                                break;
                            }
                        }
                        replacement = [S substringWithRange:commentRange];
                        if (!alreadySpace && (numberOfTrailingWhites || uncommentedICsAfter.length > 1)) {
                            replacement = [replacement stringByAppendingString:@" "];
                        }
                        goto register_and_terminate;
                    }
                    replacement = [S substringWithRange:commentRange];
                    if (numberOfTrailingWhites || uncommentedICsAfter.length > 1) {
                        replacement = [replacement stringByAppendingString:@" "];
                    }
                    goto register_and_terminate;
                }
                // unreachable code
            }
            // unreachable code
        } else if ([LS scanCharacter:'\t']) {
            // this ends the component
            // record the composition of the IC
            ++ numberOfTrailingWhites;
            ICsComment = ICsComment?
                [ICsComment indexPathByAddingIndex:LS.scanLocation]:
                [NSIndexPath indexPathWithIndex:LS.scanLocation];
            ICsComment = [ICsComment indexPathByAddingIndex:1];            
            // reset breakLocation
            breakLocation = ZER0;
            goto scan_uncommented_ICs;
        } else if ((idx = LS.scanLocation), [LS scanCommentSequence]) {
            // record the composition of the IC
            numberOfTrailingWhites = ZER0;
            if ((breakLocation += LS.scanLocation - idx) % self.numberOfSpacesPerTab == ZER0) {
                ICsComment = [ICsComment indexPathByAddingIndex:LS.scanLocation];
                ICsComment = [ICsComment indexPathByAddingIndex:ZER0];            
                // reset breakLocation
                breakLocation = ZER0;
            }
            if ((newNumberOfPendingChars = (numberOfPendingChars += LS.scanLocation - idx) % self.numberOfSpacesPerTab)) {
                // this is not the end of the component
                continue;
            }
            goto scan_uncommented_ICs;
        } else {
            // The commented IC is not complete
            uncommentedICsAfter = [NSIndexPath indexPathWithIndex:LS.scanLocation];
            goto edit_commented_IC;
        }
    }
    UNREACHABLE_CODE4iTM3;
    #undef REGISTER
}
- (NSInteger)___prepareIndentationChange:(NSInteger)change atIndex:(NSUInteger)start inString:(NSString *)S withReplacementString:(NSMutableArray *)replacementStrings affectedRanges:(NSMutableArray *)affectedRanges;
{
    NSArray * ICs = [self _indentationComponentsInString:S atIndex:start uncommentedOnly:NO];
    iTM2IndentationComponent * IC = nil;
    NSRange R = iTM3VoidRange;
    NSInteger changeInLength = ZER0;
    NSUInteger length = ZER0;
    NSUInteger idx = ZER0;
    NSString * replacement = @"";
#define REGISTER(STRING)\
    if (R.length || STRING.length)\
    {\
        [replacementStrings addObject:STRING];\
        [affectedRanges addObject:[NSValue valueWithRange:R]];\
        changeInLength -= R.length - replacement.length;\
    }
    NSUInteger totalDepth = [[ICs valueForKeyPath:@"self.@sum.depth"] unsignedIntegerValue];
    NSUInteger totalCommentLength = [[ICs valueForKeyPath:@"self.@sum.commentLength"] unsignedIntegerValue];
    NSInteger excedent = change;
    R.location = [[ICs objectAtIndex:ZER0] location];
    NSEnumerator * E = ICs.objectEnumerator;
    BOOL addWhiteAfterReplacement = NO;
    iTM2LiteScanner * LS = nil;
    while((IC = E.nextObject))
    {
        totalCommentLength -= IC.commentLength;
        if (IC.depth < excedent)
        {
            excedent -= IC.depth; // still >ZER0            totalDepth -= IC.depth;
            if (!totalCommentLength)
            {
                // this is the last commented component
                replacement = [S substringWithRange:iTM3MakeRange(IC.location+IC.contentLength,IC.commentLength+IC.blackLength)];
                addWhiteAfterReplacement = IC.afterLength > ZER0;
                R.length = IC.nextLocation - R.location;
                // all the forthcoming components are not commented and of depth 1, except the last one eventually
                while(totalDepth)
                {
                    IC = E.nextObject;
                    excedent -= IC.depth;
                    totalDepth -= IC.depth;
                }
                R.length = IC.nextLocation - R.location;
                if ((IC = E.nextObject))
                {
                    R.length = IC.nextLocation - R.location;
                    if (IC.depth)
                    {
                        if (replacement.length < self.numberOfSpacesPerTab)
                        {
                            if (self.usesTabs)
                            {
                                replacement = [replacement stringByAppendingString:@"\t"];
                            }
                            else
                            {
                                replacement = [replacement stringByPaddingToLength:self.numberOfSpacesPerTab withString:@" " startingAtIndex:ZER0];
                            }
                        }
                    }
                    else if (IC.length>replacement.length || addWhiteAfterReplacement)
                    {
                        replacement = [replacement stringByPaddingToLength:IC.length withString:@" " startingAtIndex:ZER0];
                    }
                }
                else if (IC.length>replacement.length || addWhiteAfterReplacement)
                {
                    replacement = [replacement stringByAppendingString:@" "];
                }
                REGISTER(replacement);
                return changeInLength;
            }
            // this is not the last comment
            continue;
        }
        else if (IC.depth > excedent)
        {
            // remove excedent components form IC and keep almost everything up to the end
            // the loop will end here
            // We have IC.depth > excedent > 0 so IC.depth >= 2
            // After the change IC will have depth IC.depth - excedent
            // IC is a commented component
            // rescan the string to find out what substring to find
            length = (IC.depth - excedent)*self.numberOfSpacesPerTab;
            if (length <= IC.commentLength)
            {
                replacement = [S substringWithRange:iTM3MakeRange(IC.location + IC.contentLength, IC.contentLength)];
            }
            else if (length <= IC.contentLength + IC.commentLength)
            {
                replacement = [S substringWithRange:iTM3MakeRange(IC.location + IC.contentLength + IC.commentLength - length, length)];
            }
            else
            {
                length -= IC.contentLength + IC.commentLength;
                LS = [self liteScannerWithString:S];
                LS.scanLocation = IC.location + IC.contentLength + IC.commentLength;
                while(length)
                {
                    if ([LS scanCharacter:' '])
                    {
                        --length;
                    }
                    else if ((idx = LS.scanLocation),[LS scanCommentSequence])
                    {
                        if (LS.scanLocation>idx+length)
                        {
                            break;
                        }
                        length -= LS.scanLocation - idx;
                    }
                    else
                    {
                        break;
                    }
                }
                replacement = [S substringWithRange:iTM3MakeRange(IC.location, LS.scanLocation - IC.location)];
                if (length)
                {
                    if (self.usesTabs)
                    {
                        replacement = [replacement stringByAppendingString:@"\t"];
                    }
                    else
                    {
                        replacement = [replacement stringByPaddingToLength:replacement.length+length withString:@" " startingAtIndex:ZER0];
                    }
                }
            }
            R.length = IC.nextLocation - R.location;
            break;
        }
        else// if (IC.depth == excedent)
        {
            // remove IC and keep almost everything up to the end, problems with comments
            // the loop will end here
            if (IC.commentLength)
            {
                replacement = [S substringWithRange:iTM3MakeRange(IC.location + IC.contentLength, IC.commentLength)];
                // problem
                __iTM2IndentationComponent * ic = E.nextObject;
                if (ic.commentLength)
                {
                    break;
                }
                else if (ic.depth)
                {
                    if (self.usesTabs)
                    {
                        replacement = [replacement stringByAppendingString:@"\t"];
                        if (self.numberOfSpacesPerTab > replacement.length)
                        {
                            replacement = [[@"" stringByPaddingToLength:MIN(IC.contentLength,self.numberOfSpacesPerTab - replacement.length) withString:@" " startingAtIndex:ZER0]
                                stringByAppendingString:replacement];
                        }
                    }
                    else
                    {
                        if (IC.afterLength)
                        {
                            replacement = [replacement stringByAppendingString:@" "];
                        }
                        if (self.numberOfSpacesPerTab > replacement.length)
                        {
                            replacement = [[@"" stringByPaddingToLength:MIN(IC.contentLength,self.numberOfSpacesPerTab - replacement.length) withString:@" " startingAtIndex:ZER0]
                                stringByAppendingString:replacement];
                        }
                        replacement = [replacement stringByPaddingToLength:self.numberOfSpacesPerTab withString:@" " startingAtIndex:ZER0];
                    }
                    IC = ic;
                }
                else
                {
                    if (IC.afterLength || IC.blackLength)
                    {
                        replacement = [replacement stringByAppendingString:@" "];
                    }
                    if (ic)
                    {
                        replacement = [replacement stringByPaddingToLength:ic.length withString:@" " startingAtIndex:ZER0];
                        IC = ic;
                    }
                }
            }
            R.length = IC.nextLocation - R.location;
            break;
        }
    }
    REGISTER(replacement);
    return changeInLength;
}
- (NSInteger)_prepareIndentationChange:(NSInteger)change atIndex:(NSUInteger)start inString:(NSString *)S withReplacementString:(NSMutableArray *)replacementStrings affectedRanges:(NSMutableArray *)affectedRanges indentations:(NSArray *)theICs inString:(NSString *)theReference;
{
    if (change==ZER0)
    {
        return ZER0;
    }
    if (change<ZER0)
    {
        return [self __prepareIndentationChange:-change atIndex:start inString:S withReplacementString:replacementStrings affectedRanges:affectedRanges];
    }
    // the string to insert, in general
    NSMutableArray * MRA = [NSMutableArray array];
    NSInteger i = change;
    NSRange R = iTM3MakeRange(NSNotFound,ZER0);
    NSString * replacement = @"";
    iTM2IndentationComponent * theIC = nil;
    //  When you insert indentation components from a reference string, leading comments are treated separately.
    //  If the actual prefix does not start with a comment but the replacement starts
    //  with a commented indentation component with no leading space,
    //  then the new indentation should start with the same component.
    NSArray * ICs = [self _indentationComponentsInString:S atIndex:start uncommentedOnly:NO];
    iTM2IndentationComponent * IC = nil;
    if (theICs.count) {
        //  indentation components come from the reference string
        if (ICs.count) {
            IC = [ICs objectAtIndex:ZER0];
            if (!IC.commentLength) {
                //  manage the first commented indentation component
                //  insert this component, and recursively call the same method
                theIC = [theICs objectAtIndex:ZER0];
                if (!theIC.contentLength && theIC.commentLength) {
                    R = iTM3MakeRange(theIC.location,theIC.length);
                    replacement = [theReference substringWithRange:R];
                    R = iTM3MakeRange(IC.location,ZER0);
                    [affectedRanges addObject:[NSValue valueWithRange:R]];
                    [replacementStrings addObject:replacement];
                    i = replacement.length - R.length;
                    //  remove theIC from theICs
                    R = iTM3MakeRange(1,theICs.count-1);
                    theICs = [theICs subarrayWithRange:R];
                    //  update the change
                    change -= theIC.depth;
                    return i + [self _prepareIndentationChange:change atIndex:start inString:S withReplacementString:replacementStrings affectedRanges:affectedRanges indentations:theICs inString:theReference];
                }
            }
        }
        for (theIC in theICs) {
            if (theIC.depth <= i) {
                i -= theIC.depth;
                if (R.length) {
                    R.length += theIC.length;
                } else {
                    R.location = theIC.location;
                    R.length = theIC.length;
                }
            } else {
                break;
            }
        }
        if (R.length) {
            [MRA addObject:[theReference substringWithRange:R]];
        }
    }
    while (i--) {
        [MRA addObject:self.indentationString];
    }
    replacement = [MRA componentsJoinedByString:@""];
    ICs = [self _indentationComponentsInString:S atIndex:start uncommentedOnly:NO];
    R = iTM3MakeRange(start,ZER0);
    if (ICs.count)
    {
        // In general insert at the end, after the last full indentation component
        // but before any uncomplete one
        for(IC in ICs)
        {
            if (!IC.commentLength)
            {
                //IC starts with spaces or a tab
                //indent before
                R.location = IC.location;
                goto terminate;
            }
        }
        for(IC in ICs)
        {
            if (IC.contentLength)
            {
                //IC starts with spaces or a tab
                //indent before
                R.location = IC.location;
                goto terminate;
            }
        }
        // every indentation component is commented out
        // the last component starts with a comment
        IC = ICs.lastObject;
        switch([S characterAtIndex:IC.nextLocation-1])
        {
            case ' ':
                R.location = IC.nextLocation;
                if (!self.usesTabs)
                {
                    NSInteger changeInLength = change*self.indentationString.length-IC.length % self.numberOfSpacesPerTab;
                    replacement = [@"" stringByPaddingToLength:changeInLength withString:@" " startingAtIndex:ZER0];
                }
                break;
            case '\t':
                R.location = IC.nextLocation;
                break;
            default:
                R.location = IC.location;
                break;
        }
    }
terminate:
    [affectedRanges addObject:[NSValue valueWithRange:R]];
    [replacementStrings addObject:replacement];
    return replacement.length - R.length;
}
- (NSInteger)_prepareUnindentationAtIndex:(NSUInteger)start inString:(NSString *)S withReplacementString:(NSMutableArray *)replacementStrings affectedRanges:(NSMutableArray *)affectedRanges;
{
    NSArray * ICs = [self _indentationComponentsInString:S atIndex:start uncommentedOnly:NO];
    iTM2IndentationComponent * IC = nil;
    if (ICs.count)
    {
        // In general insert at the end, after the last full indentation component
        // but before any uncomplete one
        IC = ICs.lastObject;
        if (IC.contentLength)
        {
            //IC starts with spaces or a tab
            //indent before
            [affectedRanges addObject:[NSValue valueWithRange:iTM3MakeRange(IC.location,ZER0)]];
            [replacementStrings addObject:self.indentationString];
            return self.indentationString.length;                
        }
        else
        {
            // the last component starts with a comment
            switch([S characterAtIndex:IC.nextLocation-1])
            {
                case ' ':
                    [affectedRanges addObject:[NSValue valueWithRange:iTM3MakeRange(IC.nextLocation,ZER0)]];
                    if (self.usesTabs)
                    {
                        [replacementStrings addObject:self.indentationString];
                        return self.indentationString.length;                
                    }
                    else
                    {
                        NSInteger changeInLength = IC.length % self.numberOfSpacesPerTab;
                        changeInLength = self.indentationString.length-changeInLength;
                        [replacementStrings addObject:[@"" stringByPaddingToLength:changeInLength withString:@" " startingAtIndex:ZER0]];
                        return changeInLength;                
                    }
                case '\t':
                    [affectedRanges addObject:[NSValue valueWithRange:iTM3MakeRange(IC.nextLocation,ZER0)]];
                    [replacementStrings addObject:self.indentationString];
                    return self.indentationString.length;                
                default:
                    [affectedRanges addObject:[NSValue valueWithRange:iTM3MakeRange(IC.location,ZER0)]];
                    [replacementStrings addObject:self.indentationString];
                    return self.indentationString.length;                
            }
        }
    }
    else
    {
        [affectedRanges addObject:[NSValue valueWithRange:iTM3MakeRange(start,ZER0)]];
        [replacementStrings addObject:self.indentationString];
        return self.indentationString.length;
    }
    return ZER0;
}
@synthesize macroTypes=_macroTypes;
@synthesize delegate=_delegate;
@end

@implementation NSTextView(iTM2StringControllerKit)
- (id)stringController4iTM3;
{
    return [[self.layoutManager textStorage] stringController4iTM3];
}

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  indentSelection:
- (void)indentSelection:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0:
To Do List: Nothing at first glance.
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSArray * selectedRanges = self.selectedRanges;
	NSSortDescriptor * SD = [[[NSSortDescriptor alloc] initWithKey:@"locationValueOfRangeValue4iTM3" ascending:YES] autorelease];
	NSArray * sortDescriptors = [NSArray arrayWithObject:SD];
	selectedRanges = [selectedRanges sortedArrayUsingDescriptors:sortDescriptors];
    // the selected ranges are now ordered according to the location

	NSMutableArray * replacementStrings = [NSMutableArray array];
	NSMutableArray * affectedRanges = [NSMutableArray array];
	NSMutableArray * newSelectedRanges = [NSMutableArray array];
    
	iTM2StringController * SC = self.stringController4iTM3;
	
	NSInteger off7 = ZER0;
	NSInteger changeInLength = ZER0;
    NSUInteger start, end;
	NSString * S = self.string;

    NSEnumerator * E = selectedRanges.objectEnumerator;
    NSValue * V = nil;
	NSRange R = iTM3VoidRange;
    if ((V = E.nextObject))
	{
        // the first iteration of the loop is very different from the other ones
		R = V.rangeValue;
		R.length = ZER0;
        // get the indexes for the first line of the selection
		[S getLineStart:&start end:&end contentsEnd:nil forRange:R];
        // get the indentation for this line
        changeInLength = [SC _prepareIndentationAtIndex:start inString:S withReplacementString:replacementStrings affectedRanges:affectedRanges];
        [newSelectedRanges addObject:[NSValue valueWithRange:iTM3MakeRange(start+off7,end-start+changeInLength)]];
        off7 += changeInLength;

        while((V = E.nextObject))
        {
            R = V.rangeValue;
            if (R.location>=end)
            {
                R.length = ZER0;
                // get the indexes for the first line of the selection
                [S getLineStart:&start end:&end contentsEnd:nil forRange:R];
                changeInLength = [SC _prepareIndentationAtIndex:start inString:S withReplacementString:replacementStrings affectedRanges:affectedRanges];
                [newSelectedRanges addObject:[NSValue valueWithRange:iTM3MakeRange(start+off7,end-start+changeInLength)]];
            }
        }
        NSAssert(replacementStrings.count==affectedRanges.count, @"**** There is an awful BUG, affectedRanges and replacementStrings are not consistent...");
        if (affectedRanges.count && [self shouldChangeTextInRanges:affectedRanges replacementStrings:replacementStrings])
        {
            E  = affectedRanges.reverseObjectEnumerator;
            NSEnumerator * EE = replacementStrings.reverseObjectEnumerator;
            while((V = E.nextObject) && (S = EE.nextObject))
            {
                R = V.rangeValue;
                [self replaceCharactersInRange:R withString:S];
            }
            self.didChangeText;
            R = self.selectedRange;
            if (!R.length)
            {
                if (selectedRanges.count>1)
                {
                    [self setSelectedRanges:newSelectedRanges];
                }
                else if ((V = selectedRanges.lastObject))
                {
                    R = V.rangeValue;
                    if (R.length)
                    {
                        [self setSelectedRanges:newSelectedRanges];
                    }
                }
            }
        }
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  unindentSelection:
- (void)unindentSelection:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSArray * selectedRanges = self.selectedRanges;
	NSSortDescriptor * SD = [[[NSSortDescriptor alloc] initWithKey:@"locationValueOfRangeValue4iTM3" ascending:YES] autorelease];
	NSArray * sortDescriptors = [NSArray arrayWithObject:SD];
	selectedRanges = [selectedRanges sortedArrayUsingDescriptors:sortDescriptors];

	NSMutableArray * replacementStrings = [NSMutableArray array];
	NSMutableArray * affectedRanges = [NSMutableArray array];
	NSMutableArray * newSelectedRanges = [NSMutableArray array];

	iTM2StringController * SC = self.stringController4iTM3;
	
	NSInteger off7 = ZER0;
	NSInteger changeInLength = ZER0;
    NSUInteger start, end;
	NSString * S = self.string;

    NSEnumerator * E = selectedRanges.objectEnumerator;
    NSValue * V;
    if (((V = E.nextObject)))
	{
        // the first iteration of the loop is very different from the other ones
        NSRange R = V.rangeValue;
		R.length = ZER0;
        // get the indexes for the first line of the selection
		[S getLineStart:&start end:&end contentsEnd:nil forRange:R];
        // get the indentation for this line
        NSArray * ICs = [SC _indentationComponentsInString:S atIndex:start uncommentedOnly:NO];
        iTM2IndentationComponent * IC = nil;
        NSEnumerator * EE = nil;
        if (ICs.count)
        {
            // where should I delete a tab?
            // if the line does not start with a comment
            // delete the first indentation component
            // otherwise, insert at the end, after the last full indentation component
            IC = [ICs objectAtIndex:ZER0];
            if (IC.commentLength == NSNotFound)
            {
                [affectedRanges addObject:[NSValue valueWithRange:iTM3MakeRange(IC.location,IC.length)]];
                [replacementStrings addObject:@""];
                changeInLength = -IC.length;
            }
            // the first indentation component is commented out
            else
            {
                IC = ICs.lastObject;
                if (IC.depth && (ICs.count>1))
                {
                    // this is not the same as the first object
                    [affectedRanges addObject:[NSValue valueWithRange:iTM3MakeRange(IC.location,IC.length)]];
                    [replacementStrings addObject:@""];
                    changeInLength = -IC.length;
                }
                else if (ICs.count>2)
                {
                    // remove the penultimate component
                    EE = ICs.reverseObjectEnumerator;
                    IC = EE.nextObject,EE.nextObject;
                    [affectedRanges addObject:[NSValue valueWithRange:iTM3MakeRange(IC.location,IC.length)]];
                    [replacementStrings addObject:@""];
                    changeInLength = -IC.length;
                }
                else
                {
                    // first critical situation
                    // we have either
                    // - a full indentation component with comment characters
                    // followed by a partial indentation component
                    // - or a partial indentation component with comment
                    // In both situations, ask the string controller for the replacement
                    R = iTM3MakeRange(start,IC.location+IC.length-start);
                    NSString * replacement = [SC _stringByUnindentingString:[S substringWithRange:R]];
                    [affectedRanges addObject:[NSValue valueWithRange:R]];
                    [replacementStrings addObject:replacement];
                    changeInLength = replacement.length-R.length;
                }
            }
            [newSelectedRanges addObject:[NSValue valueWithRange:iTM3MakeRange(start+off7,end-start+changeInLength)]];
            off7 += changeInLength;
        }

        while((V = E.nextObject))
        {
            R = V.rangeValue;
            if (R.location>=end)// this is where things change compared with the first iteration above
            {
                R.length = ZER0;
                // get the indexes for the first line of the selection
                [S getLineStart:&start end:&end contentsEnd:nil forRange:R];
                // get the indentation for this line
                ICs = [SC _indentationComponentsInString:S atIndex:start uncommentedOnly:NO];
                if (ICs.count)
                {
                    // where should I delete a tab?
                    // if the line does not start with a comment
                    // delete the first indentation component
                    // otherwise, insert at the end, after the last full indentation component
                    IC = [ICs objectAtIndex:ZER0];
                    if (IC.commentLength == NSNotFound)
                    {
                        [affectedRanges addObject:[NSValue valueWithRange:iTM3MakeRange(IC.location,IC.length)]];
                        [replacementStrings addObject:@""];
                        changeInLength = -IC.length;
                    }
                    else
                    {
                        IC = ICs.lastObject;
                        if (IC.depth && (ICs.count>1))
                        {
                            [affectedRanges addObject:[NSValue valueWithRange:iTM3MakeRange(IC.location,IC.length)]];
                            [replacementStrings addObject:@""];
                            changeInLength = -IC.length;
                        }
                        else if (ICs.count>2)
                        {
                            // remove the penultimate component
                            EE = ICs.reverseObjectEnumerator;
                            IC = EE.nextObject,EE.nextObject;
                            [affectedRanges addObject:[NSValue valueWithRange:iTM3MakeRange(IC.location,IC.length)]];
                            [replacementStrings addObject:@""];
                            changeInLength = -IC.length;
                        }
                        else
                        {
                            // first critical situation
                            // we have either
                            // - a full indentation component with comment characters
                            // followed by a partial indentation component
                            // - or a partial indentation component with comment
                            // In both situations, ask the string controller for the replacement
                            R = iTM3MakeRange(start,IC.location+IC.length-start);
                            NSString * replacement = [SC _stringByUnindentingString:[S substringWithRange:R]];
                            [affectedRanges addObject:[NSValue valueWithRange:R]];
                            [replacementStrings addObject:replacement];
                            changeInLength = replacement.length-R.length;
                        }
                    }
                    [newSelectedRanges addObject:[NSValue valueWithRange:iTM3MakeRange(start+off7,end-start+changeInLength)]];
                    off7 += changeInLength;
                }
            }
        }
        NSAssert(replacementStrings.count==affectedRanges.count, @"**** There is an awful BUG, affectedRanges and replacementStrings are not consistent...");
        if (affectedRanges.count && [self shouldChangeTextInRanges:affectedRanges replacementStrings:replacementStrings])
        {
            E  = affectedRanges.reverseObjectEnumerator;
            NSEnumerator * EE = replacementStrings.reverseObjectEnumerator;
            while((V = E.nextObject) && (S = EE.nextObject))
            {
                R = V.rangeValue;
                [self replaceCharactersInRange:R withString:S];
            }
            self.didChangeText;
            R = self.selectedRange;
            if (!R.length)
            {
                if (selectedRanges.count>1)
                {
                    self.selectedRanges = newSelectedRanges;
                }
                else if ((V = selectedRanges.lastObject))
                {
                    R = V.rangeValue;
                    if (R.length)
                    {
                        self.selectedRanges = newSelectedRanges;
                    }
                }
            }
        }
    }
//END4iTM3;
    return;
}

@end

@implementation NSArray(Action4iTM3)
- (NSUInteger)indentationDepth4iTM3;
{
    return [[self valueForKeyPath:@"self.@sum.depth"] unsignedIntegerValue];
}
- (NSUInteger)indentationWhiteDepth4iTM3;
{
    return [[self valueForKeyPath:@"self.@sum.whiteDepth"] unsignedIntegerValue];
}
- (NSUInteger)indentationLength4iTM3;
{
    return [[self valueForKeyPath:@"self.@sum.length"] unsignedIntegerValue];
}
- (NSRange)indentationRange4iTM3;
{
    if (self.count) {
        iTM2IndentationComponent * IC = [self objectAtIndex:ZER0];
        if ([IC isKindOfClass:[iTM2IndentationComponent class]]) {
            return iTM3MakeRange(IC.location,self.indentationLength4iTM3);
        }
    }
    return iTM3MakeRange(ZER0,ZER0);
}
- (iTM2IndentationComponent *)firstCommentedIndentationComponent4iTM3;
{
    for (iTM2IndentationComponent * IC in self) {
        if ([IC isKindOfClass:[iTM2IndentationComponent class]] && IC.commentLength > ZER0) {
            return IC;
        }
    }
    return nil;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2StringControllerKit

