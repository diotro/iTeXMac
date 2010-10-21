//
//  iTM2TestA
//  iTM2Foundation
//
//  Created by Jérôme Laurens on 16/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "iTeXMac2.h"
#import "RegexKitLite.h"
#import "ICURegEx.h"
#import "iTM2Test_RE.h"
#import "iTM2MacroKit_String.h"

@implementation iTM2Test_RE
- (void) setUp
{
    // Create data structures here.
}

- (void) tearDown
{
    // Release data structures here.
}
- (void) testCase_EOL
{
    NSString * inputString = [NSString stringWithFormat:
        @"LF:    Line Feed,                    U+000A\n"
        @"CR:    Carriage Return,              U+000D\r"
        @"CR+LF: CR (U+000D) followed by LF (U+000A)\r\n"
        @"NEL:   Next Line,                    U+0085%C"
        @"FF:    Form Feed,                          \f"
        @"LS:    Line Separator,               U+2028%C"
        @"PS:    Paragraph Separator,          U+2029%C",
            0x0085,0x2028,0x2029];
    ICURegEx * RE = [ICURegEx regExWithSearchPattern:@"\\r\\n|\\r|\\n|\\f|\\u0085|\\u2028|\\u2029" error:NULL];//[ICURegEx regExForKey:iTM2RegExpEOLKey];
    [RE setInputString:inputString];
    STAssertTrue([RE nextMatch]&&[[RE substringOfMatch] isEqual:@"\n"],@"MISSED LF",NULL);
    STAssertTrue([RE nextMatch]&&[[RE substringOfMatch] isEqual:@"\r"],@"MISSED CR",NULL);
    STAssertTrue([RE nextMatch]&&[[RE substringOfMatch] isEqual:@"\r\n"],@"MISSED CR+LF",NULL);
    STAssertTrue([RE nextMatch]&&[[RE substringOfMatch] isEqual:([NSString stringWithFormat:@"%C",0x0085])],@"MISSED NEL",NULL);
    STAssertTrue([RE nextMatch]&&[[RE substringOfMatch] isEqual:@"\f"],@"MISSED FF",NULL);
    STAssertTrue([RE nextMatch]&&[[RE substringOfMatch] isEqual:([NSString stringWithFormat:@"%C",0x2028])],@"MISSED LS",NULL);
    STAssertTrue([RE nextMatch]&&[[RE substringOfMatch] isEqual:([NSString stringWithFormat:@"%C",0x2029])],@"MISSED PS",NULL);
    RE = [ICURegEx regExForKey:iTM2RegExpEOLKey error:NULL];
    [RE setInputString:inputString];
    STAssertTrue([RE nextMatch]&&[[RE substringOfMatch] isEqual:@"\n"],@"MISSED LF",NULL);
    STAssertTrue([RE nextMatch]&&[[RE substringOfMatch] isEqual:@"\r"],@"MISSED CR",NULL);
    STAssertTrue([RE nextMatch]&&[[RE substringOfMatch] isEqual:@"\r\n"],@"MISSED CR+LF",NULL);
    STAssertTrue([RE nextMatch]&&[[RE substringOfMatch] isEqual:([NSString stringWithFormat:@"%C",0x0085])],@"MISSED NEL",NULL);
    STAssertTrue([RE nextMatch]&&[[RE substringOfMatch] isEqual:@"\f"],@"MISSED FF",NULL);
    STAssertTrue([RE nextMatch]&&[[RE substringOfMatch] isEqual:([NSString stringWithFormat:@"%C",0x2028])],@"MISSED LS",NULL);
    STAssertTrue([RE nextMatch]&&[[RE substringOfMatch] isEqual:([NSString stringWithFormat:@"%C",0x2029])],@"MISSED PS",NULL);
    return;
}
- (void) testCase_Placeholders
{
        //  first test
        NSString * inputString = [NSString stringWithFormat:
@"LF:    Line Feed,                    U+000A\n"
@"CR:    Carriage Return,              U+000D\r"
@"CR+LF: CR (U+000D) followed by LF (U+000A)\r\n"
@"NEL:   Next Line,                    U+0085%C"
@"FF:    Form Feed,                          \f"
@"LS:    Line Separator,               U+2028%C"
@"PS:    Paragraph Separator,          U+2029%C",
            0x0085,0x2028,0x2029];
        ICURegEx * RE = nil;
        NSUInteger i = 0;
        //  trying some shortcut for EOL:
        //  next re is expected to match for each character preceding a start of line
        //  it can match new line characters
        //  ^ matches at each beginning of a line
        RE = [ICURegEx regExWithSearchPattern:@"(?ms:(.)^)" error:NULL];
        RE.inputString = inputString;
        while (RE.nextMatch) {
            ++i;
        }
        STAssertTrue(i==6,([NSString stringWithFormat:@"OUPS:%s:%lu\n",__FILE__,__LINE__]),NULL);
        NSLog(@"====================================");
        RE = [ICURegEx regExWithSearchPattern:@"(?ms:$(.))" error:NULL];// proper regex for EOL
        RE.inputString = inputString;
        i = 0;
        while (RE.nextMatch) {
            ++i;
        }
        STAssertTrue(i==7,([NSString stringWithFormat:@"OUPS:%s:%lu\n",__FILE__,__LINE__]),NULL);
        NSLog(@"====================================");
        RE = [ICURegEx regExForKey:iTM2RegExpEOLKey error:NULL];// proper regex for EOL
        RE.inputString = inputString;
        i = 0;
        while (RE.nextMatch) {
            ++i;
        }
        STAssertTrue(i==7,([NSString stringWithFormat:@"OUPS:%s:%lu\n",__FILE__,__LINE__]),NULL);
        NSLog(@"====================================");
        RE = [ICURegEx regExForKey:@"SEL" error:NULL];
        RE.inputString = @"coucou SEL  [  last  - 23   ]: defaut valeur     ";
#define TEST_MATCH \
        STAssertTrue(RE.nextMatch,([NSString stringWithFormat:@"OUPS:%s:%lu\n",__FILE__,__LINE__]),NULL); \
        RE.displayMatchResult
        TEST_MATCH;
#define TEST(NAME,RIGHT) STAssertTrue([[RE substringOfCaptureGroupWithName:NAME] isEqual:RIGHT],([NSString stringWithFormat:@"OUPS:%s:%lu\n",__FILE__,__LINE__]),NULL)
        TEST(@"end",@"last");
        TEST(@"-index",@"23");
        TEST(@"index",@"");
        TEST(@"default",@"");
        RE = [ICURegEx regExForKey:@"SEL" error:NULL];
        RE.inputString = @"coucou SEL  [ 23   ]: defaut valeur     ";
        TEST_MATCH;
        TEST(@"end",@"");
        TEST(@"-index",@"");
        TEST(@"index",@"23");
        TEST(@"default",@"");
        RE = [ICURegEx regExForKey:@"SEL..." error:NULL];
        RE.inputString = @"coucou SEL  [  last  - 23   ]: defaut valeur     ";
        TEST_MATCH;
        TEST(@"end",@"last");
        TEST(@"-index",@"23");
        TEST(@"index",@"");
        TEST(@"Default",@" defaut valeur     ");
        RE = [ICURegEx regExForKey:@"SEL|TYPE..." error:NULL];
        RE.inputString = @" SEL  [  last  - 23   ]: defaut valeur     ";
        TEST_MATCH;
        TEST(@"end",@"last");
        TEST(@"-index",@"23");
        TEST(@"index",@"");
        TEST(@"Default",@" defaut valeur     ");
        TEST(@"TYPE",@"");
        RE = [ICURegEx regExForKey:@"TYPE..." error:NULL];
        RE.inputString = @"coucou SEL  [  last  - 23   ]: defaut valeur     ";
        TEST_MATCH;
        TEST(@"end",@"");
        TEST(@"-index",@"");
        TEST(@"index",@"");
        TEST(@"Default",@" defaut valeur     ");
        TEST(@"TYPE",@"]");
        RE = [ICURegEx regExForKey:@"SEL|TYPE..." error:NULL];
        RE.inputString = @"coucou SAL  [  last  - 23   ]: defaut valeur     ";
        RE.displayMatchResult;
        TEST_MATCH;
        TEST(@"end",@"");
        TEST(@"-index",@"");
        TEST(@"index",@"");
        TEST(@"Default",@" defaut valeur     ");
        TEST(@"TYPE",@"]");
//      TYPE:X SaL:Y
        RE = [ICURegEx regExForKey:@"SEL" error:NULL];
        NSLog(@"SEL:%@",RE.searchPattern);
        RE = [ICURegEx regExForKey:@"TYPE" error:NULL];
        NSLog(@"TYPE:%@",RE.searchPattern);
        RE = [ICURegEx regExForKey:@"Default" error:NULL];
        NSLog(@"Default:%@",RE.searchPattern);
        RE = [ICURegEx regExForKey:@"SEL|TYPE..." error:NULL];
        NSLog(@"SEL|TYPE...:%@",RE.searchPattern);
        RE = [ICURegEx regExForKey:@"__(SEL|TYPE...)__|EOL" error:NULL];
        NSLog(@"__(SEL|TYPE...)__|EOL:%@",RE.searchPattern);
        RE.inputString =
            @"start __( SEL[0] : defaut valeur0  )__ after \n"
            @"middle __( TYPE : defaut valeur1  )__ after \n"
            @"middle __( SEL[1]: defaut valeur2  )__ after \n"
            ;
        TEST_MATCH;

        TEST(@"end",@"");
        TEST(@"-index",@"");
        TEST(@"index",@"0");
        TEST(@"Default",@" defaut valeur0  ");
        TEST(@"TYPE",@"");
        TEST(@"EOL",@"");

        TEST_MATCH;
        TEST(@"end",@"");
        TEST(@"-index",@"");
        TEST(@"index",@"");
        TEST(@"Default",@"");
        TEST(@"TYPE",@"");
        TEST(@"EOL",@"\n");

        TEST_MATCH;
        TEST(@"end",@"");
        TEST(@"-index",@"");
        TEST(@"index",@"");
        TEST(@"Default",@" defaut valeur1  ");
        TEST(@"TYPE",@"TYPE");
        TEST(@"EOL",@"");

        TEST_MATCH;
        TEST(@"end",@"");
        TEST(@"-index",@"");
        TEST(@"index",@"");
        TEST(@"Default",@"");
        TEST(@"TYPE",@"");
        TEST(@"EOL",@"\n");

        TEST_MATCH;
        TEST(@"end",@"");
        TEST(@"-index",@"");
        TEST(@"index",@"1");
        TEST(@"Default",@" defaut valeur2  ");
        TEST(@"TYPE",@"");
        TEST(@"EOL",@"");

        TEST_MATCH;
        TEST(@"end",@"");
        TEST(@"-index",@"");
        TEST(@"index",@"");
        TEST(@"Default",@"");
        TEST(@"TYPE",@"");
        TEST(@"EOL",@"\n");

        if (RE.nextMatch) {
            LOG4iTM3(@"one:<%@>",[RE substringOfCaptureGroupWithName:@"one"]);
            LOG4iTM3(@"two:<%@>",[RE substringOfCaptureGroupWithName:@"two"]);
            LOG4iTM3(@"three:<%@>",[RE substringOfCaptureGroupWithName:@"three"]);
        }
#undef TEST
#undef TEST_MATCH
}
- (void) testCase_A
{
        //  first test
        NSString * inputString = [NSString stringWithFormat:
@"LF:    Line Feed,                    U+000A\n"
@"CR:    Carriage Return,              U+000D\r"
@"CR+LF: CR (U+000D) followed by LF (U+000A)\r\n"
@"NEL:   Next Line,                    U+0085%C"
@"FF:    Form Feed,                          \f"
@"LS:    Line Separator,               U+2028%C"
@"PS:    Paragraph Separator,          U+2029%C",
            0x0085,0x2028,0x2029];
#define OUPS ([NSString stringWithFormat:@"OUPS:%s:%lu\n",__FILE__,__LINE__])
#define NEXT_MATCH(F1RST,LAST)\
        STAssertTrue(RE.nextMatch,OUPS,NULL);\
        RE.displayMatchResult;\
        STAssertTrue((NSEqualRanges(NSMakeRange(F1RST,LAST-F1RST+1),RE.rangeOfMatch) || (NSLog(@"R:%@",NSStringFromRange(RE.rangeOfMatch)),NO)),OUPS,NULL)
#define TEST(NAME,RIGHT) STAssertTrue([[RE substringOfCaptureGroupWithName:NAME] isEqual:RIGHT],OUPS,NULL)
#define FULL_TEST(END,INDEXFROMEND,INDEX,DEFAULT,COMMENT,TYPE,EOL)\
        TEST(iTM2RegExpMKEndName,         END);\
        TEST(iTM2RegExpMKIndexFromEndName,INDEXFROMEND);\
        TEST(iTM2RegExpMKIndexName,       INDEX);\
        TEST(iTM2RegExpMKDefaultName,     DEFAULT);\
        TEST(iTM2RegExpMKCommentName,     COMMENT);\
        TEST(iTM2RegExpMKTypeName,        TYPE);\
        TEST(iTM2RegExpMKEOLName,         EOL)

        NSError * ROR = nil;
        ICURegEx * RE = [ICURegEx regExForKey:iTM2RegExpMKPlaceholderOrEOLKey error:&ROR];
        STAssertNil(ROR,@"MISSED",nil);
        STAssertNotNil(RE,OUPS,NULL);
        RE.inputString =
        //0123456789-012345678-9012-3456789012345678901234567890123456789
        @"00 __(T:D\\%C'D)__ \n320\n";
        NEXT_MATCH(0,16);
        FULL_TEST(@"",@"",@"",@"D\\%C'D",@"",@"T",@"");
        if (RE.nextMatch) {
            NSLog(@"=> 1 EOL found");
        } else {
            NSLog(@"=> 1 NO EOL found");
        }
        RE.inputString =
        //0123456789-012345678-9012-3456789012345678901234567890123456789
        @"00 __(T:D\\%C'D)__ \n320\n";
        NEXT_MATCH(0,16);
        FULL_TEST(@"",@"",@"",@"D\\%C'D",@"",@"T",@"");
        if (RE.nextMatch) {
            NSLog(@"=> 2 EOL found");
        } else {
            NSLog(@"=> 2 NO EOL found");
        }
#if 0
        RE.inputString =
        //0123456789-012345678-9012-3456789012345678901234567890123456789
        @"00 __(T:D\\%C'D)__ \n320\n";
        NEXT_MATCH(0,16);
        FULL_TEST(@"",@"",@"",@"D\\%C'D",@"",@"T",@"");
        NEXT_MATCH(18,18);
        FULL_TEST(@"",@"",@"",@"",@"",@"",@"\n");
        NEXT_MATCH(22,22);
        FULL_TEST(@"",@"",@"",@"",@"",@"",@"\n");
        STAssertFalse(RE.nextMatch,OUPS,NULL);
#else
         RE.inputString =
        //0123456789-01234567890123456789012345678901234567890123456789
        @"000 one  \n"
        //0         0         0         0         0         0         -
        //1         2         3         4         5         6         -
        //012345678901234567890123456789012345678901234567890123456789-
        @"010 two __(TYPE:DEFAULT%COMMENT'D)__ twotwotw __(TYPE:DEFA-\n"
        //0         0         0         -1         1         1         
        //7         8         9         -0         1         2         
        //012345678901234567890123456789-012345678901234567890123456789
        @"070 ULT%COMMENT'D)__ twotwot \n"
        //1         1         1         -1         1         1         
        //0         1         2         -3         4         5         
        //012345678901234567890123456789-012345678901234567890123456789
        @"100 three__(TYPE:DEFAULT%COM-\n"
        //1         1         -1         1         1         1         
        //3         4         -5         6         7         8         
        //01234567890123456789-0123456789012345678901234567890123456789
        @"130 MENT'D)__ twot \n"
        //1         1         1         1         1         -2         
        //5         6         7         8         9         -0         
        //01234567890123456789012345678901234567890123456789-0123456789
        @"150 three __(TYPE%COMMENT'D)__ three __(TYPE%COM-\n"
        //2         2         -2         2         2         2         
        //0         1         -2         3         4         5         
        //01234567890123456789-0123456789012345678901234567890123456789
        @"200 MENT'D)__ twot \n"
        //2         2         2      -   2         2         -2         
        //2         3         4      -   5         6         -7         
        //012345678901234567890123456-78901234567890123456789-0123456789
        @"220 threethreethre __(TYPE\\:DEFAULT%COMMENT'D)__ \n"
        //2         2         2         3    -     3         -3         
        //7         8         9         0    -     1         -2         
        //01234567890123456789012345678901234-567890123456789-0123456789
        @"270 fourfourfourfo __(TYPE:DEFAULT\\XCOMMENT'D)__ \n"
        //3   -      3         3         3         3         3         
        //2   -      3         4         5         6         7         
        //0123-45678901234567890123456789012345678901234567890123456789
        @"320\n";
        NEXT_MATCH(9,9);
        FULL_TEST(@"",@"",@"",@"",@"",@"",@"\n");
        NEXT_MATCH(10,45);
        FULL_TEST(@"",@"",@"",@"DEFAULT",@"COMMENT'D",@"TYPE",@"");
        NEXT_MATCH(46,89);
        FULL_TEST(@"",@"",@"",@"DEFA-\n070 ULT",@"COMMENT'D",@"TYPE",@"");
        NEXT_MATCH(99,99);
        FULL_TEST(@"",@"",@"",@"",@"",@"",@"\n");
        NEXT_MATCH(100,142);
        FULL_TEST(@"",@"",@"",@"DEFAULT",@"COM-\n130 MENT'D",@"TYPE",@"");
        NEXT_MATCH(149,149);
        FULL_TEST(@"",@"",@"",@"",@"",@"",@"\n");
        NEXT_MATCH(150,179);
        FULL_TEST(@"",@"",@"",@"",@"COMMENT'D",@"TYPE",@"");
        NEXT_MATCH(180,212);
        FULL_TEST(@"",@"",@"",@"",@"COM-\n200 MENT'D",@"TYPE",@"");
        NEXT_MATCH(219,219);
        FULL_TEST(@"",@"",@"",@"",@"",@"",@"\n");
        NEXT_MATCH(220,267);
        FULL_TEST(@"",@"",@"",@"DEFAULT",@"COMMENT'D",@"TYPE\\",@"");
        NEXT_MATCH(269,269);
        FULL_TEST(@"",@"",@"",@"",@"",@"",@"\n");
        NEXT_MATCH(270,317);
        FULL_TEST(@"",@"",@"",@"DEFAULT\\XCOMMENT'D",@"",@"TYPE",@"");
        NEXT_MATCH(319,319);
        FULL_TEST(@"",@"",@"",@"",@"",@"",@"\n");
        NEXT_MATCH(323,323);
        FULL_TEST(@"",@"",@"",@"",@"",@"",@"\n");
        STAssertFalse(RE.nextMatch,OUPS,NULL);
#endif       
        NSUInteger i = 0;
        //  trying some shortcut for EOL:
        //  next re is expected to match for each character preceding a start of line
        //  it can match new line characters
        //  ^ matches at each beginning of a line
        RE = [ICURegEx regExWithSearchPattern:@"(?ms:(.)^)" error:NULL];
        RE.inputString = inputString;
        while (RE.nextMatch) {
            ++i;
        }
        STAssertTrue(i==6,OUPS,NULL);
        NSLog(@"====================================");
        RE = [ICURegEx regExWithSearchPattern:@"(?ms:$(.))" error:NULL];// proper regex for EOL
        RE.inputString = inputString;
        i = 0;
        while (RE.nextMatch) {
            ++i;
        }
        STAssertTrue(i==7,OUPS,NULL);
        NSLog(@"====================================");
        RE = [ICURegEx regExForKey:@"SEL" error:&ROR];
        STAssertTrue(!ROR,@"MISSED",nil);
        RE.inputString = @"coucou SEL  [  last  - 23   ]: defaut valeur     ";
        STAssertTrue(RE.nextMatch,OUPS,NULL);
        RE.displayMatchResult;
        TEST(iTM2RegExpMKEndName,@"last");
        TEST(iTM2RegExpMKIndexFromEndName,@"23");
        TEST(iTM2RegExpMKIndexName,@"");
        TEST(@"default",@"");
        RE = [ICURegEx regExForKey:@"SEL" error:&ROR];
        STAssertTrue(!ROR,@"MISSED",nil);
        RE.inputString = @"coucou SEL  [ 23   ]: defaut valeur     ";
        STAssertTrue(RE.nextMatch,OUPS,NULL);
        RE.displayMatchResult;
        TEST(iTM2RegExpMKEndName,@"");
        TEST(iTM2RegExpMKIndexFromEndName,@"");
        TEST(iTM2RegExpMKIndexName,@"23");
        TEST(@"default",@"");
        RE = [ICURegEx regExForKey:@"SEL..." error:&ROR];
        STAssertTrue(!ROR,@"MISSED",nil);
        RE.inputString = @"coucou SEL  [  last  - 23   ]: defaut valeur     ";
        STAssertTrue(RE.nextMatch,OUPS,NULL);
        RE.displayMatchResult;
        TEST(iTM2RegExpMKEndName,@"last");
        TEST(iTM2RegExpMKIndexFromEndName,@"23");
        TEST(iTM2RegExpMKIndexName,@"");
        TEST(iTM2RegExpMKDefaultName,@" defaut valeur     ");
        RE = [ICURegEx regExForKey:@"SEL|TYPE..." error:&ROR];
        STAssertTrue(!ROR,@"MISSED",nil);
        RE.inputString = @" SEL  [  last  - 23   ]: defaut valeur     ";
        STAssertTrue(RE.nextMatch,OUPS,NULL);
        RE.displayMatchResult;
        TEST(iTM2RegExpMKEndName,@"last");
        TEST(iTM2RegExpMKIndexFromEndName,@"23");
        TEST(iTM2RegExpMKIndexName,@"");
        TEST(iTM2RegExpMKDefaultName,@" defaut valeur     ");
        TEST(iTM2RegExpMKTypeName,@"");
        RE = [ICURegEx regExForKey:@"TYPE..." error:&ROR];
        STAssertTrue(!ROR,@"MISSED",nil);
        RE.inputString = @"coucou SEL  [  last  - 23   ]: defaut valeur     ";
        STAssertTrue(RE.nextMatch,OUPS,NULL);
        RE.displayMatchResult;
        TEST(iTM2RegExpMKEndName,@"");
        TEST(iTM2RegExpMKIndexFromEndName,@"");
        TEST(iTM2RegExpMKIndexName,@"");
        TEST(iTM2RegExpMKDefaultName,@" defaut valeur     ");
        RE = [ICURegEx regExForKey:@"SEL|TYPE..." error:&ROR];
        STAssertTrue(!ROR,@"MISSED",nil);
        RE.inputString = @"coucou SAL  [  last  - 23   ]: defaut valeur     ";
        RE.displayMatchResult;
        STAssertTrue(RE.nextMatch,OUPS,NULL);
        RE.displayMatchResult;
        TEST(iTM2RegExpMKEndName,@"");
        TEST(iTM2RegExpMKIndexFromEndName,@"");
        TEST(iTM2RegExpMKIndexName,@"");
        TEST(iTM2RegExpMKDefaultName,@" defaut valeur     ");
        TEST(iTM2RegExpMKTypeName,@"]");
//      TYPE:X SaL:Y
        RE = [ICURegEx regExForKey:@"SEL" error:&ROR];
        STAssertTrue(!ROR,@"MISSED",nil);
        NSLog(@"SEL:%@",RE.searchPattern);
        RE = [ICURegEx regExForKey:iTM2RegExpMKTypeName error:&ROR];
        STAssertTrue(!ROR,@"MISSED",nil);
        NSLog(@"TYPE:%@",RE.searchPattern);
        RE = [ICURegEx regExForKey:iTM2RegExpMKDefaultName error:&ROR];
        STAssertTrue(!ROR,@"MISSED",nil);
        NSLog(@"Default:%@",RE.searchPattern);
        RE = [ICURegEx regExForKey:@"SEL|TYPE..." error:&ROR];
        STAssertTrue(!ROR,@"MISSED",nil);
        NSLog(@"SEL|TYPE...:%@",RE.searchPattern);
        RE = [ICURegEx regExForKey:@"__(SEL|TYPE...)__|EOL" error:&ROR];
        STAssertTrue(!ROR,@"MISSED",nil);
        NSLog(@"__(SEL|TYPE...)__|EOL:%@",RE.searchPattern);
        RE.inputString =
            @"start __( SEL[0] : defaut valeur0  )__ after \n"
            @"middle __( TYPE : defaut valeur1  )__ after \n"
            @"middle __( SEL[1]: defaut valeur2  )__ after \n"
            ;
        STAssertTrue(RE.nextMatch,OUPS,NULL);
        RE.displayMatchResult;

        TEST(iTM2RegExpMKEndName,@"");
        TEST(iTM2RegExpMKIndexFromEndName,@"");
        TEST(iTM2RegExpMKIndexName,@"0");
        TEST(iTM2RegExpMKDefaultName,@" defaut valeur0  ");
        TEST(iTM2RegExpMKTypeName,@"");
        TEST(iTM2RegExpMKEOLName,@"");

        STAssertTrue(RE.nextMatch,OUPS,NULL);
        RE.displayMatchResult;
        TEST(iTM2RegExpMKEndName,@"");
        TEST(iTM2RegExpMKIndexFromEndName,@"");
        TEST(iTM2RegExpMKIndexName,@"");
        TEST(iTM2RegExpMKDefaultName,@"");
        TEST(iTM2RegExpMKTypeName,@"");
        TEST(iTM2RegExpMKEOLName,@"\n");

        STAssertTrue(RE.nextMatch,OUPS,NULL);
        RE.displayMatchResult;
        TEST(iTM2RegExpMKEndName,@"");
        TEST(iTM2RegExpMKIndexFromEndName,@"");
        TEST(iTM2RegExpMKIndexName,@"");
        TEST(iTM2RegExpMKDefaultName,@" defaut valeur1  ");
        TEST(iTM2RegExpMKTypeName,iTM2RegExpMKTypeName);
        TEST(iTM2RegExpMKEOLName,@"");

        STAssertTrue(RE.nextMatch,OUPS,NULL);
        RE.displayMatchResult;
        TEST(iTM2RegExpMKEndName,@"");
        TEST(iTM2RegExpMKIndexFromEndName,@"");
        TEST(iTM2RegExpMKIndexName,@"");
        TEST(iTM2RegExpMKDefaultName,@"");
        TEST(iTM2RegExpMKTypeName,@"");
        TEST(iTM2RegExpMKEOLName,@"\n");

        STAssertTrue(RE.nextMatch,OUPS,NULL);
        RE.displayMatchResult;
        TEST(iTM2RegExpMKEndName,@"");
        TEST(iTM2RegExpMKIndexFromEndName,@"");
        TEST(iTM2RegExpMKIndexName,@"1");
        TEST(iTM2RegExpMKDefaultName,@" defaut valeur2  ");
        TEST(iTM2RegExpMKTypeName,@"");
        TEST(iTM2RegExpMKEOLName,@"");

        STAssertTrue(RE.nextMatch,OUPS,NULL);
        RE.displayMatchResult;
        TEST(iTM2RegExpMKEndName,@"");
        TEST(iTM2RegExpMKIndexFromEndName,@"");
        TEST(iTM2RegExpMKIndexName,@"");
        TEST(iTM2RegExpMKDefaultName,@"");
        TEST(iTM2RegExpMKTypeName,@"");
        TEST(iTM2RegExpMKEOLName,@"\n");

        if (RE.nextMatch) {
            LOG4iTM3(@"one:<%@>",[RE substringOfCaptureGroupWithName:@"one"]);
            LOG4iTM3(@"two:<%@>",[RE substringOfCaptureGroupWithName:@"two"]);
            LOG4iTM3(@"three:<%@>",[RE substringOfCaptureGroupWithName:@"three"]);
        }
#undef NEXT_MATCH
#undef FULL_TEST
#undef TEST
#undef OUPS
}
- (void) XtestCase_C
{
	NSString * testString = @"#!/usr/bin/env/lua -h \nSecond line\nThird line\nAnd so on";
	NSLog(@"testString:%@",testString);
	ICURegEx * RE;
    NSLog(@"A create ----------------------------");
	NSError * localError = nil;
	RE = [[[ICURegEx alloc] initWithSearchPattern:@"abc+" options:0 error:&localError] autorelease];
    STAssertNotNil(RE,@"MISSED: %@",localError);
	NSLog(@"B match ----------------------------");
	[RE setInputString:@"abccccc"];
    STAssertTrue([RE matchesAtIndex:0 extendToTheEnd:YES],@"MISSED 1, error:%@", [RE error]);
	[RE setInputString:@"xabccccc"];
    STAssertFalse([RE matchesAtIndex:0 extendToTheEnd:YES],@"MISSED 2, error:%@", [RE error]);
    STAssertTrue([RE matchesAtIndex:1 extendToTheEnd:YES],@"MISSED 3, error:%@", [RE error]);
#pragma mark C
	NSLog(@"C look ----------------------------");
	[RE setInputString:@"abccccd"];
    STAssertTrue([RE matchesAtIndex:0 extendToTheEnd:NO],@"MISSED 4, error:%@", [RE error]);
	[RE setInputString:@"xabccccd"];
    STAssertFalse([RE matchesAtIndex:0 extendToTheEnd:NO],@"MISSED 5, error:%@", [RE error]);
    STAssertTrue([RE matchesAtIndex:1 extendToTheEnd:NO],@"MISSED 6, error:%@", [RE error]);
#pragma mark D
	NSLog(@"D find ----------------------------");
	RE = [[[ICURegEx alloc] initWithSearchPattern:@"a(b*)(c+)" options:0 error:&localError] autorelease];
    STAssertNotNil(RE,@"MISSED: %@",localError);
	[RE setInputString:@"xacccyyabbczzabbeeee"];
    STAssertTrue([RE nextMatch],@"MISSED 7, error:%@", [RE error]);
    STAssertTrue([[RE substringOfMatch] isEqual:@"accc"],@"MISSED 7a, error:%@", [RE error]);
    STAssertTrue([[RE substringOfCaptureGroupAtIndex:1] isEqual:@""],@"MISSED 7b, error:%@", [RE error]);
    STAssertTrue([[RE substringOfCaptureGroupAtIndex:2] isEqual:@"ccc"],@"MISSED 7c, error:%@", [RE error]);
    STAssertFalse([[RE substringOfCaptureGroupAtIndex:3] isEqual:@"xxx"],@"MISSED 7d, error:%@", [RE error]);
    STAssertTrue([RE nextMatch],@"MISSED 8, error:%@", [RE error]);
    STAssertTrue([[RE substringOfMatch] isEqual:@"abbc"],@"MISSED 8a, error:%@", [RE error]);
    STAssertTrue([[RE substringOfCaptureGroupAtIndex:1] isEqual:@"bb"],@"MISSED 8b, error:%@", [RE error]);
    STAssertTrue([[RE substringOfCaptureGroupAtIndex:2] isEqual:@"c"],@"MISSED 8c, error:%@", [RE error]);
    STAssertFalse([[RE substringOfCaptureGroupAtIndex:3] isEqual:@"xxx"],@"MISSED 8d, error:%@", [RE error]);
    STAssertFalse([RE nextMatch],@"MISSED 9, error:%@", [RE error]);
	STAssertTrue([RE nextMatchAfterIndex:2],@"MISSED 10, error:%@", [RE error]);
    [RE displayMatchResult];
	[RE setReplacementPattern:@"0:/$0/\n1:/$1/\n2:/$2/"];
	NSLog(@"[RE replacementString]:%@",[RE replacementString]);
    STAssertNil([RE error],@"MISSED 10",NULL);
	STAssertTrue([[RE replacementString] isEqual:@"0:/abbc/\n1:/bb/\n2:/c/"],@"MISSED 11, error:%@", [RE error]);
#pragma mark E
	NSLog(@"E find ----------------------------");
	NSString * input = [NSString stringWithUTF8String:"ઔકખਅਆਦਤઔકખਅਆਦਤઔકખਅਆਦਤઔકખਅਆਦਤ"];
	NSError * error;
	NSMutableString * MS;
	MS = [NSMutableString stringWithString:input];
	NSLog(@"Avant:%@",MS);
	NSString * pattern = [NSString stringWithUTF8String:"(ખ..).*(ਆ+)"];
	[MS replaceOccurrencesOfICUREPattern:pattern withPattern:@"$2$1$2$1" options:0 range:iTM3MakeRange(0,MS.length) error:&error];
	NSLog(@"Apres:%@",MS);
	MS = [NSMutableString stringWithString:input];
	NSLog(@"Avant:%@",MS);
	[MS replaceOccurrencesOfICUREPattern:pattern withPattern:@"$2$1$2$1" options:0 range:iTM3MakeRange(2,MS.length-3) error:&error];
	NSLog(@"Apres:%@",MS);
    STAssertTrue([MS isEqual:[NSString stringWithUTF8String:"ઔકਆખਅਆਆખਅਆਦਤ"]],@"MISSED 11, found:%@", MS);
#pragma mark F
	NSLog(@"F find ----------------------------");
	RE = [[[ICURegEx alloc] initWithSearchPattern:@"a(b*)(c+)" options:0 error:&localError] autorelease];
    STAssertFalse([RE nextMatch],@"MISSED 10, error:%@", [RE error]);
    STAssertNotNil([RE error],@"MISSED 10, error:%@", [RE error]);
#pragma mark G
//	NSString * S = [NSString * stringWithUTF8String:"“‘ÁØå’”"];
	

    RE = [[[ICURegEx alloc] initWithSearchPattern:@"N(OO)P" options:0 error:&error] autorelease];
    [RE displayMatchResult];
    [RE setInputString:@"0123456789NOOP0123456789"];
    STAssertTrue([RE nextMatch],@"MISSED 1",NULL);
    STAssertTrue([RE numberOfCaptureGroups]==1,@"MISSED 2",NULL);
    STAssertTrue([[RE substringOfMatch] isEqual:@"NOOP"],@"MISSED 3",NULL);
    STAssertTrue([[RE substringOfCaptureGroupAtIndex:0] isEqual:@"NOOP"],@"MISSED 4",NULL);
    STAssertTrue([[RE substringOfCaptureGroupAtIndex:1] isEqual:@"OO"],@"MISSED 5",NULL);
    [RE setInputString:@"0123456789NOOP0123456789" range:iTM3MakeRange(10,4)];
    STAssertTrue([RE nextMatch],@"MISSED 6",NULL);
    [RE setInputString:@"0123456789NOOP0123456789" range:iTM3MakeRange(9,4)];
    STAssertFalse([RE nextMatch],@"MISSED 7",NULL);
    [RE setInputString:@"0123456789NOOP0123456789" range:iTM3MakeRange(11,4)];
    STAssertFalse([RE nextMatch],@"MISSED 8",NULL);
	return;
}
- (void) testCase_B
{
    //  We are currently testing the placeholder regexes
}
@end
