//
//  iTM2Test0C
//  iTM2Foundation
//
//  Created by Jérôme Laurens on 16/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "RegexKitLite.h"
#import "ICURegEx.h"
#import "iTM2StringKit.h"
#import "iTM2Runtime.h"
#import "iTeXMac2.h"
#import "iTM2BundleKit.h"
#import "iTM2DistributedObjectKit.h"
#import "iTM2FileManagerKit.h"
#import "iTM2Implementation.h"
#import "iTM2InstallationKit.h"
#import "iTM2Invocation.h"
#import "iTM2NotificationKit.h"
#import "iTM2ObjectServer.h"
#import "iTM2PathUtilities.h"
#import "iTM2TreeKit.h"

#import "iTM2ButtonKit.h"
#import "iTM2CursorKit.h"
#import "iTM2EventKit.h"
#import "iTM2ImageKit.h"
#import "iTM2MenuKit.h"
#import "iTM2ResponderKit.h"
#import "iTM2ValidationKit.h"
#import "iTM2ViewKit.h"
#import "iTM2WindowKit.h"

#import "iTM2ContextKit.h"
#import "iTM2AutoKit.h"
#import "iTM2MacroKit.h"
#import "iTM2MacroKit_String.h"
#import "iTM2DocumentKit.h"
#import "iTM2InheritanceKit.h"
#import "iTM2ApplicationDelegate.h"
#import "iTM2StringControllerKit.h"
#import "iTM2LiteScanner.h"
#import "iTM2StringControllerKitPrivate.h"

#import "iTM2Test0D.h"

@interface iTM2Test0D()
@property (assign) NSArray * ICsA;
@property (assign) NSArray * ICsB;
@end

@implementation iTM2Test0D
- (void) setUp
{
    // Create data structures here.
    ICsA = [[NSArray arrayWithObjects:
    /*
    ZER0 : IC component
	1 : IC component
	2 : IC component
	3 : IC component
	4 : seed
	5 : change
	6 : result with tab
	7 : result with no tab
*/
        @"0,1,ZER0,1,"
            @"seed,%\t,"
            @"change1,1,%\t\t,%\t   ,"
            @"change2,-1,%\t,%\t,FIN",
        @"0,1,ZER0,2,"
            @"seed,%  ,"
            @"change1,1,%  \t,%     ,"
			@"change2,-1,%  ,%  ,FIN",
        @"0,1,ZER0,2,"
            @"seed,% \t,"
            @"change1,1,% \t\t,% \t   ,"
			@"change2,-1,% \t,% \t,FIN",
        @"0,1,ZER0,2,"
            @"seed,% %,"
            @"change1,1,% %\t,% %   ,"
			@"change2,-1,% %,% %,FIN",
        @"0,2,ZER0,1,"
            @"seed,%%\t,"
            @"change1,1,%%\t\t,%%\t   ,"
			@"change2,-1,%%\t,%%\t,FIN",
        @"0,2,ZER0,1,"
            @"seed,%% ,"
            @"change1,1,%% \t,%%    ,"
			@"change2,-1,%% ,%% ,FIN",
        @"0,3,ZER0,ZER0,"
            @"seed,%%%,"
            @"change1,1,%%%\t,%%%   ,"
			@"change2,-1,%%%,%%%,FIN",
        @"0,1,2,ZER0,"
            @"seed,%%!,"
            @"change1,1,%%!\t,%%!   ,"
			@"change2,-1,%%!,%%!,FIN",
        @"0,2,ZER0,1,"
            @"seed,%! ,"
            @"change1,1,%! \t,%!    ,"
			@"change2,-1,%! ,%! ,FIN",
        @"0,2,1,ZER0,"
            @"seed,%!%,"
            @"change1,1,%!%\t,%!%   ,"
			@"change2,-1,%!%,%!%,FIN",
        @"0,2,ZER0,1,"
            @"seed,%!\t,"
            @"change1,1,%!\t\t,%!\t   ,"
			@"change2,-1,%!\t,%!\t,FIN",
        @"1,ZER0,ZER0,ZER0,"
            @"seed,\t,"
            @"change1,1,\t\t,\t   ,"
			@"change2,-1,,more,,FIN",
        @"1,1,ZER0,1,"
            @"seed, % ,"
            @"change1,1, % \t, %    ,"
			@"change2,-1, % , % ,FIN",
        @"1,2,ZER0,ZER0,"
            @"seed, %%,"
            @"change1,1, %%\t, %%   ,"
			@"change2,-1, %%, %%,FIN",
        @"1,1,ZER0,1,"
            @"seed, %\t,"
            @"change1,1, %\t\t, %\t   ,"
			@"change2,-1, %\t, %\t,FIN",
        @"1,2,ZER0,ZER0,"
            @"seed, %!,"
            @"change1,1, %!\t, %!   ,"
			@"change2,-1, %!, %!,FIN",
        @"3,ZER0,ZER0,ZER0,"
            @"seed,   ,"
            @"change1,1,   \t,      ,"
			@"change2,-1,,more,,FIN",
        @"2,2,ZER0,2,"
            @"seed,  %!  ,"
            @"change1,1,  %!  \t,  %!     ,"
			@"change2,-1,%! ,%! ,FIN",
        @"2,2,1,1,"
            @"seed,  %!% ,"
            @"change1,1,  %!% \t,  %!%    ,"
			@"change2,-1,%!%,%!%,FIN",
        @"2,2,ZER0,2,"
            @"seed,  %! %,"
            @"change1,1,  %! %\t,  %! %   ,"
			@"change2,-1,%! ,%! ,FIN",
        @"2,2,2,ZER0,"
            @"seed,  %!%%,"
            @"change1,1,  %!%%\t,  %!%%   ,"
			@"change2,-1,%!%,%!%,FIN",
        @"2,2,2,ZER0,"
            @"seed,  %!%!,"
            @"change1,1,  %!%!\t,  %!%!   ,"
			@"change2,-1,%!\t,%! ,FIN",
        @"2,2,ZER0,2,"
            @"seed,  %! \t,"
            @"change1,1,  %! \t\t,  %! \t   ,"
			@"change2,-1,%! ,%! ,FIN",
        @"2,2,1,1,"
            @"seed,  %!%\t,"
            @"change1,1,  %!%\t\t,  %!%\t   ,"
			@"change2,-1,%!%,%!%,FIN",
        @"2,2,ZER0,4,"
            @"seed,  %! %!\t,"
            @"change1,1,  %! %!\t\t,  %! %!\t   ,"
			@"change2,-1,  %! \t,  %!  ,FIN",
        @"2,2,ZER0,5,"
            @"seed,  %! %! \t,"
            @"change1,1,  %! %! \t\t,  %! %! \t   ,"
			@"change2,-1,  %! \t,  %!  ,FIN",
        @"2,2,ZER0,5,"
            @"seed,  %! %!%\t,"
            @"change1,1,  %! %!%\t\t,  %! %!%\t   ,"
			@"change2,-1,  %! \t,  %!  ,FIN",
        @"2,2,ZER0,5,"
            @"seed,  %! %!  ,"
            @"change1,1,  %! %!  \t,  %! %!     ,"
			@"change2,-1,  %! \t,  %!  ,FIN",
        @"2,2,ZER0,5,"
            @"seed,  %! %!% ,"
            @"change1,1,  %! %!% \t,  %! %!%    ,"
			@"change2,-1,  %! \t,  %!  ,FIN",
        @"2,2,ZER0,5,"
            @"seed,  %! %! %,"
            @"change1,1,  %! %! %\t,  %! %! %   ,"
			@"change2,-1,  %! \t,  %!  ,FIN",
        @"2,2,ZER0,5,"
            @"seed,  %! %!%%,"
            @"change1,1,  %! %!%%\t,  %! %!%%   ,"
			@"change2,-1,  %! \t,  %!  ,FIN",
        @"2,2,ZER0,5,"
            @"seed,  %! %!%!,"
            @"change1,1,  %! %!%!\t,  %! %!%!   ,"
			@"change2,-1,  %! \t,  %!  ,FIN",
            nil] retain];
    ICsB = [[NSArray arrayWithObjects:
        @"0,1,ZER0,ZER0,"
            @"seed,%,"
            @"change1,1,%\t ,%   ,"
			@"change2,-1,%,%,FIN",
        @"0,1,ZER0,1,"
            @"seed,% ,"
            @"change1,1,%\t  ,%    ,"
			@"change2,-1,% ,% ,FIN",
        @"0,2,ZER0,ZER0,"
            @"seed,%%,"
            @"change1,1,%%\t  ,%%   ,"
			@"change2,-1,%%,%%,FIN",
        @"0,2,ZER0,ZER0,"
            @"seed,%!,"
            @"change1,1,%!\t  ,%!   ,"
			@"change2,-1,%!,%!,FIN",
        @"1,ZER0,ZER0,ZER0,"
            @"seed, ,"
            @"change1,1,\t ,    ,"
			@"change2,-1, ,more, ,FIN",
        @"1,1,ZER0,ZER0,"
            @"seed, %,"
            @"change1,1, %\t  , %   ,"
			@"change2,-1, %, %,FIN",
        @"2,ZER0,ZER0,ZER0,"
            @"seed,  ,"
            @"change1,1,\t  ,     ,"
			@"change2,-1,  ,more,  ,FIN",
        @"2,2,ZER0,1,"
            @"seed,  %! ,"
            @"change1,1,  %!\t  ,  %!    ,"
			@"change2,-1,%!,%!,FIN",
        @"2,2,1,ZER0,"
            @"seed,  %!%,"
            @"change1,1,  %!%\t  ,  %!%   ,"
			@"change2,-1,%!,%!,FIN",
                nil] retain];
}

- (void) tearDown
{
    // Release data structures here.
    [ICsA release];
    ICsA = nil;
    [ICsB release];
    ICsB = nil;
}
- (void) testCase
{
}
#if 0
- (unichar)standaloneCharacterAtIndex:(NSUInteger)index inString:(NSString *)aString;

/*!
	@method		isEscapedCharacterAtIndex:inString:
	@abstract	Abstract forthcoming.
	@discussion	YES iff index>ZER0 and there is an unescaped control sequence at index-1.
                Subclassers will use there own definition.
	@param		index.
	@param		aString.
    @result     yorn
*/
- (BOOL)isEscapedCharacterAtIndex:(NSUInteger)index inString:(NSString *)aString;

/*!
	@method		commentString
	@abstract	Abstract forthcoming.
	@discussion	The default implementation returns @"%". Subclassers may want to change this.
                This is readonly because it is synchronized with the is...Comment... methods.
	@param		None.
    @result     a string
*/
@property (readonly) NSString * commentString;
#endif
- (void) testCase_commentString
{
    iTM2StringController * SC = [iTM2StringController defaultController];
    STAssertEqualObjects(SC.commentString,@"%",@"MISSED",nil);
}
- (void) testCase_indentation_1
{
    iTM2StringController * SC = [iTM2StringController defaultController];
    STAssertNotNil(SC,@"Lost",NULL);
    NSString * aString = @"\\\\\\\\";
    STAssertFalse([SC isEscapedCharacterAtIndex:ZER0 inString:aString],@"Missed 3a",NULL);
    STAssertTrue([SC isEscapedCharacterAtIndex:1 inString:aString],@"Missed 3b",NULL);
    STAssertFalse([SC isEscapedCharacterAtIndex:2 inString:aString],@"Missed 3c",NULL);
    STAssertTrue([SC isEscapedCharacterAtIndex:3 inString:aString],@"Missed 3d",NULL);
    STAssertTrue([SC isControlCharacterAtIndex:ZER0 inString:aString],@"Missed 3xd",NULL);
    STAssertFalse([SC isControlCharacterAtIndex:1 inString:aString],@"Missed 3xa",NULL);
    STAssertTrue([SC isControlCharacterAtIndex:2 inString:aString],@"Missed 3xb",NULL);
    STAssertFalse([SC isControlCharacterAtIndex:3 inString:aString],@"Missed 3xc",NULL);
    aString = @"\\%%\\\\\\%%\\\\%";
    STAssertFalse([SC isCommentCharacterAtIndex:ZER0 inString:aString],@"Missed 3ya",NULL);
    STAssertFalse([SC isCommentCharacterAtIndex:1 inString:aString],@"Missed 3yz",NULL);
    STAssertTrue ([SC isCommentCharacterAtIndex:2 inString:aString],@"Missed 3ye",NULL);
    STAssertFalse([SC isCommentCharacterAtIndex:3 inString:aString],@"Missed 3yr",NULL);
    STAssertFalse([SC isCommentCharacterAtIndex:4 inString:aString],@"Missed 3yt",NULL);
    STAssertFalse([SC isCommentCharacterAtIndex:5 inString:aString],@"Missed 3yy",NULL);
    STAssertFalse([SC isCommentCharacterAtIndex:6 inString:aString],@"Missed 3yu",NULL);
    STAssertTrue ([SC isCommentCharacterAtIndex:7 inString:aString],@"Missed 3yi",NULL);
    STAssertFalse([SC isCommentCharacterAtIndex:8 inString:aString],@"Missed 3yo",NULL);
    STAssertFalse([SC isCommentCharacterAtIndex:9 inString:aString],@"Missed 3yp",NULL);
    STAssertTrue ([SC isCommentCharacterAtIndex:10 inString:aString],@"Missed 3yq",NULL);
}
- (void) testCase_indentation_01;
{
    iTM2StringController * SC = [iTM2StringController defaultController];
    SC.numberOfSpacesPerTab=3;
    
    NSArray * ICsAll = [ICsA arrayByAddingObjectsFromArray:ICsB];
    STAssertTrue(ICsA.count,@"Nonsense",NULL);
    NSArray * RA = nil;
    NSUInteger level = 3;
    NSMutableArray * strings = [NSMutableArray array];
    [strings addObject:@""];// see below
    NSMutableArray * ICs = [NSMutableArray array];
    _iTM2IndentationComponent * IC = nil;
    NSUInteger location = ZER0;
    NSMutableArray * Ns = [NSMutableArray array];
    NSUInteger i = ZER0;
    while(YES)
    {
        while(strings.count<level)// beware, the first string does not count
        {
            RA = [[ICsA objectAtIndex:i] componentsSeparatedByString:@","];
            IC = [_iTM2IndentationComponent indentationComponent];
            IC.location = location;
            IC.contentLength = [[RA objectAtIndex:ZER0] integerValue];
            IC.commentLength = [[RA objectAtIndex:1] integerValue];
            IC.blackLength = [[RA objectAtIndex:2] integerValue];
            IC.afterLength = [[RA objectAtIndex:3] integerValue];
            IC.depth = [[RA objectAtIndex:4] integerValue];
            if (![strings.lastObject hasSuffix:@"%"] || ![[RA objectAtIndex:5] hasSuffix:@"%"]) {
                [strings addObject:[strings.lastObject stringByAppendingString:[RA objectAtIndex:5]]];// this is where the first @"" of strings is used
            } else {
                // if both components contain a % merging them will create a component with depth 2
                break;
            }
            [ICs addObject:IC];
            [Ns addObject:[NSNumber numberWithUnsignedInteger:i]];
            location = IC.nextLocation;
            i = ZER0;
        }
        // At the end of the loop: strings.count==level-1
        // Add an ultimate index
        if (level && strings.count==level-1)
        {
            LOG4iTM3(@"Testing with %ld component(s)",(long)level);
            for(NSString * S in ICsAll)
            {
                RA = [S componentsSeparatedByString:@","];
                S = nil;
                IC = [_iTM2IndentationComponent indentationComponent];
                IC.location = location;
                IC.contentLength = [[RA objectAtIndex:ZER0] integerValue];
                IC.commentLength = [[RA objectAtIndex:1] integerValue];
                IC.blackLength = [[RA objectAtIndex:2] integerValue];
                IC.afterLength = [[RA objectAtIndex:3] integerValue];
                IC.depth = [[RA objectAtIndex:4] integerValue];
                [ICs addObject:IC];
                S = [strings.lastObject stringByAppendingString:[RA objectAtIndex:5]];
                RA = [SC _indentationComponentsInString:S atIndex:ZER0];// this is also where the first @"" of strings is used
                //LOG4iTM3(@"Testing <%@>\nICs:%@\nRA:%@",S,ICs,RA);
                STAssertTrue([RA isEqual:ICs],@"Missed: unexpected %@",[[RA description] stringByAppendingFormat:@"<>%@, for string:%@",ICs,S]);
                [ICs removeLastObject];
                location = [ICs.lastObject nextLocation];
            }
            while(YES)
            {
                if (Ns.count)
                {
                    i = [Ns.lastObject unsignedIntegerValue];
                    [Ns removeLastObject];
                    [strings removeLastObject];
                    [ICs removeLastObject];
                    location = [ICs.lastObject nextLocation];
                    if (++i==ICsA.count)
                    {
                        continue;
                    }
                }
                else
                {
                    i = ZER0;
                    --level;
                }
                break;
            }
        }
        else
        {        
            LOG4iTM3(@"%@",@"OK");
            return;
        }
    }
}
- (void) testCase_indentation_02;
{
    iTM2StringController * SC = [iTM2StringController defaultController];
    SC.numberOfSpacesPerTab=3;
    NSArray * ICs = [ICsA arrayByAddingObjectsFromArray:ICsB];
    NSString * S;
    NSArray * RA = nil;
    NSMutableString * MS;
    NSRange R;
    NSUInteger change = ZER0;
    NSString * prefix;
    ICURegEx * RE = [ICURegEx regExWithSearchPattern:@",(?:[^,]*(?:change|seed|more)[^,]*,)?" error:NULL];
    for(S in ICs) {
        S = [ICsB objectAtIndex:ZER0];
        [RE setInputString:S];
        RA = [RE componentsBySplitting];
        NSLog(@"TEST:\"%@\",\n%@,FIN",S,RA);
        S = nil;
#       define seed4iTM3 [RA objectAtIndex:4]
#       define change4iTM3 [[RA objectAtIndex:change] integerValue]
#       define result14iTM3 [RA objectAtIndex:change+1]
#       define result24iTM3 [RA objectAtIndex:change+2]
        change = 5;
        SC.usesTabs = YES;
        MS = [NSMutableString stringWithString:seed4iTM3];
        [SC getIndentationPrefix:&prefix:&R change:change4iTM3 inString:MS:ZER0 availablePrefix:nil:ZER0];
        [MS replaceCharactersInRange:R withString:prefix];
        STAssertEqualObjects(result14iTM3,MS,@"MISSED FIN",nil);
        SC.usesTabs = NO;
        MS = [NSMutableString stringWithString:seed4iTM3];
        [SC getIndentationPrefix:&prefix:&R change:change4iTM3 inString:MS:ZER0 availablePrefix:nil:ZER0];
        [MS replaceCharactersInRange:R withString:prefix];
        STAssertEqualObjects(result24iTM3,MS,@"MISSED FIN",nil);
        change = 8;
        SC.usesTabs = YES;
        MS = [NSMutableString stringWithString:seed4iTM3];
        [SC getUnindentationPrefix:&prefix:&R change:-1*change4iTM3 inString:MS:ZER0];
        [MS replaceCharactersInRange:R withString:prefix];
        STAssertEqualObjects(result14iTM3,MS,@"MISSED FIN",nil);
        SC.usesTabs = NO;
        MS = [NSMutableString stringWithString:seed4iTM3];
        [SC getUnindentationPrefix:&prefix:&R change:-1*change4iTM3 inString:MS:ZER0];
        [MS replaceCharactersInRange:R withString:prefix];
        STAssertEqualObjects(result24iTM3,MS,@"MISSED FIN",nil);
    }
}
@synthesize ICsA;
@synthesize ICsB;
@end

