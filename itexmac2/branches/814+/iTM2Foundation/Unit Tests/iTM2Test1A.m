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

#import "iTM2MacroKit_String.h"
#import "iTM2KeyBindingsKit.h"
#import "iTM2MacroKit.h"
#import "iTM2MacroKit_Action.h"
#import "iTM2MacroKit_Controller.h"
#import "iTM2MacroKit_Prefs.h"
#import "iTM2MacroKit_Tree.h"
#import "iTM2TextCompletionKit.h"

#import "iTM2Test1A.h"

NSString * const iTM2RegExpTestsName = @"iTM2RegExTests";

@interface NSObject(NOTHING)
- (NSRange)rangeOfMacroTypeAtIndex:(NSUInteger)index inString:(NSString *)aString;
@end


@implementation iTM2Test1A
- (void) setUp
{
    fullLines = [[NSArray arrayWithObjects:
        [NSArray arrayWithObjects:@"",nil],
        [NSArray arrayWithObjects:@"^START\n",@"...\n",@"...\n",@"END\n",nil],
            nil] retain];
    fullLinesPrefix = [[NSArray arrayWithObjects:
        [NSArray array],
        [NSArray arrayWithObjects:[NSArray array],[NSArray array],[NSArray array],[NSArray array],nil],
            nil] retain];
    partsOfLine = [[NSArray arrayWithObjects:@"",@"ONE",@"TWO",@"THREE",nil] retain];
    partsOfLinePrefix = [[NSArray arrayWithObjects:
        [NSArray array],
        [NSArray array],
        [NSArray array],
        [NSArray array],
            nil] retain];
    endsOfLine = [[NSArray arrayWithObjects:@"\n",@"END OF LINE\n",nil] retain];
    SELPlaceholders = [[NSArray arrayWithObjects:@"__(SEL:ZERO)__",@"__(SEL[1]:ONE)__",nil] retain];
    XPCTD_SELPlaceholders = [[NSArray arrayWithObjects:
        [NSArray arrayWithObjects:[NSNumber numberWithInteger:0],@"ZERO",nil],
        [NSArray arrayWithObjects:[NSNumber numberWithInteger:1],@"ONE",nil],
            nil] retain];
}

- (void) tearDown
{
    // Release data structures here.
    [fullLines release];
    [fullLinesPrefix release];
    [partsOfLine release];
    [partsOfLinePrefix release];
    [endsOfLine release];
    [SELPlaceholders release];
    [XPCTD_SELPlaceholders release];
}
- (void) testCaseRegExps
{
    NSBundle * bundle = [NSBundle bundleForClass:self.class];
    NSURL * url = [bundle URLForResource:iTM2RegExpTestsName withExtension:@"plist"];
    NSDictionary * tests = [NSDictionary dictionaryWithContentsOfURL:url];
    STAssertTrue(tests.count,@"MISSED",NULL);
    for (NSString * K in tests.allKeys) {
        NSError * ROR = nil;
        ICURegEx * RE = [ICURegEx regExForKey:K error:&ROR];
        STAssertNotNil(RE,@"MISSED",NULL);
        NSDictionary * D = [tests objectForKey:K];
        STAssertTrue(D.count,@"MISSED",NULL);
        for (NSString * search in D.allKeys) {
            NSDictionary * d = [D objectForKey:search];
            if (d.count) {
                STAssertTrue([RE matchString:search],@"MISSED matching %@",search);
                [RE displayMatchResult];
                for (NSString * name in d.allKeys) {
                    STAssertEqualObjects([RE substringOfCaptureGroupWithName:name],[d objectForKey:name],
                        @"MISSED %@: %@<!>%@",name,[RE substringOfCaptureGroupWithName:name],[d objectForKey:name]);
                }
            } else {
                STAssertFalse([RE matchString:search],@"MISSED NO matching %@",search);
            }
        }
    }
/*
    
    ICURegEx * RE = nil;
#   define TEST_1(NAME,VALUE) do {\
        STAssertEqualObjects([RE substringOfCaptureGroupWithName:NAME],VALUE,@"MISSED %@: %@<!>%@",NAME,[RE substringOfCaptureGroupWithName:NAME],VALUE);\
    } while (NO)
#   define TEST_2(EOL,END,INDEXFROMEND,INDEX,TYPE,SEL,DEFAULT,COMMENT) do {\
        [RE displayMatchResult];\
        TEST_1(iTM2RegExpMKEOLName,EOL);\
        TEST_1(iTM2RegExpMKEndName,END);\
        TEST_1(iTM2RegExpMKIndexFromEndName,INDEXFROMEND);\
        TEST_1(iTM2RegExpMKIndexName,INDEX);\
        TEST_1(iTM2RegExpMKTypeName,TYPE);\
        TEST_1(iTM2RegExpMKSELName,SEL);\
        TEST_1(iTM2RegExpMKDefaultName,DEFAULT);\
        TEST_1(iTM2RegExpMKCommentName,COMMENT);\
    } while (NO)
#   define TEST(SEARCH,EOL,END,INDEXFROMEND,INDEX,TYPE,SEL,DEFAULT,COMMENT) do {\
        STAssertTrue([RE matchString:SEARCH],@"MISSED1 not matching %@",SEARCH);\
        TEST_2(EOL,END,INDEXFROMEND,INDEX,TYPE,SEL,DEFAULT,COMMENT);\
    } while (NO)
#   define TEST_NO(SEARCH,EOL,END,INDEXFROMEND,INDEX,TYPE,SEL,DEFAULT,COMMENT) do {\
        STAssertFalse([RE matchString:SEARCH],@"MISSED NO not matching %@",SEARCH);\
    } while (NO)
    
    RE = [ICURegEx regExForKey:iTM2RegExpMKSELKey error:NULL];
    TEST(@"   __(   SEL  )__",@"",@"",@"",@"",@"",@"",@"",@"");
    TEST(@"   __(   SEL : DEFAULT VALUE     )__",@"",@"",@"",@"",@"",@"",@"",@"");
    TEST(@"   __(   SEL  [ end  -  12   ]  )__",@"",@"end",@"12",@"",@"",@"",@"",@"");
    TEST(@"   __(   SEL [ end  -  12   ]  : DEFAULT VALUE     )__",@"",@"end",@"12",@"",@"",@"",@"",@"");
    TEST(@"   __(   SEL  [ 120   ]  )__",@"",@"",@"",@"120",@"",@"",@"",@"");
    TEST(@"   __(   SEL  [ 120   ]  : DEFAULT VALUE     )__",@"",@"",@"",@"120",@"",@"",@"",@"");
    TEST(@"   )__(   SEL  )__",@"",@"",@"",@"",@"",@"",@"",@"");
    TEST(@"   __(   SEL  %% COMMENTAIRE )__",@"",@"",@"",@"",@"",@"",@"",@"");
    TEST(@"   __(   SEL : DEFAULT VALUE     %% COMMENTAIRE )__",@"",@"",@"",@"",@"",@"",@"",@"");
    TEST(@"   __(   SEL  [ end  -  12   ]  %% COMMENTAIRE )__",@"",@"end",@"12",@"",@"",@"",@"",@"");
    TEST(@"   __(   SEL [ end  -  12   ]  : DEFAULT VALUE     %% COMMENTAIRE )__",@"",@"end",@"12",@"",@"",@"",@"",@"");
    TEST(@"   __(   SEL  [ 120   ]  %% COMMENTAIRE )__",@"",@"",@"",@"120",@"",@"",@"",@"");
    TEST(@"   __(   SEL  [ 120   ]  : DEFAULT VALUE     %% COMMENTAIRE )__",@"",@"",@"",@"120",@"",@"",@"",@"");
    TEST(@"   )__(   SEL  )__",@"",@"",@"",@"",@"",@"",@"",@"");
    RE = [ICURegEx regExForKey:iTM2RegExpMKTypeKey error:NULL];
    TEST(@"   __(   SEL  )__",@"",@"",@"",@"",@"SEL",@"",@"",@"");
    TEST(@"   __(   SEL : DEFAULT VALUE     )__",@"",@"",@"",@"",@"SEL",@"",@"",@"");
    TEST(@"   __(   SEL  [ end  -  12   ]  )__",@"",@"",@"",@"",@"]",@"",@"",@"");
    TEST(@"   __(   SEL [ end  -  12   ]  : DEFAULT VALUE     )__",@"",@"",@"",@"",@"]",@"",@"",@"");
    TEST(@"   __(   SEL  [ 120   ]  )__",@"",@"",@"",@"",@"]",@"",@"",@"");
    TEST(@"   __(   SEL  [ 120   ]  : DEFAULT VALUE     )__",@"",@"",@"",@"",@"]",@"",@"",@"");
    TEST(@"   )__(   SEL  )__",@"",@"",@"",@"",@"SEL",@"",@"",@"");
    TEST(@"   __(   SEL  %% COMMENTAIRE )__",@"",@"",@"",@"",@"SEL",@"",@"",@"");
    TEST(@"   __(   SEL : DEFAULT VALUE     %% COMMENTAIRE )__",@"",@"",@"",@"",@"SEL",@"",@"",@"");
    TEST(@"   __(   SEL  [ end  -  12   ]  %% COMMENTAIRE )__",@"",@"",@"",@"",@"]",@"",@"",@"");
    TEST(@"   __(   SEL [ end  -  12   ]  : DEFAULT VALUE     %% COMMENTAIRE )__",@"",@"",@"",@"",@"]",@"",@"",@"");
    TEST(@"   __(   SEL  [ 120   ]  %% COMMENTAIRE )__",@"",@"",@"",@"",@"]",@"",@"",@"");
    TEST(@"   __(   SEL  [ 120   ]  : DEFAULT VALUE     %% COMMENTAIRE )__",@"",@"",@"",@"",@"]",@"",@"",@"");
    TEST(@"   )__(   SEL  )__",@"",@"",@"",@"",@"SEL",@"",@"",@"");
    RE = [ICURegEx regExForKey:iTM2RegExpMKDefaultName error:NULL];
    TEST_NO(@"   __(   SEL  )__",@"",@"",@"",@"",@"",@"",@"",@"");
    TEST(@"   __(   SEL : DEFAULT VALUE     )__",@"",@"",@"",@"",@"",@"",@" DEFAULT VALUE     ",@"");
    TEST_NO(@"   __(   SEL  [ end  -  12   ]  )__",@"",@"",@"",@"",@"",@"",@"",@"");
    TEST(@"   __(   SEL [ end  -  12   ]  : DEFAULT VALUE     )__",@"",@"",@"",@"",@"",@"",@" DEFAULT VALUE     ",@"");
    TEST_NO(@"   __(   SEL  [ 120   ]  )__",@"",@"",@"",@"120",@"",@"",@"",@"");
    TEST(@"   __(   SEL  [ 120   ]  : DEFAULT VALUE     )__",@"",@"",@"",@"",@"",@"",@" DEFAULT VALUE     ",@"");
    TEST_NO(@"   )__(   SEL  )__",@"",@"",@"",@"",@"",@"",@"",@"");
    TEST_NO(@"   __(   SEL  %% COMMENTAIRE )__",@"",@"",@"",@"",@"",@"",@"",@"");
    TEST(@"   __(   SEL : DEFAULT VALUE     %% COMMENTAIRE )__",@"",@"",@"",@"",@"",@"",@" DEFAULT VALUE     % COMMENTAIRE ",@"");
    TEST_NO(@"   __(   SEL  [ end  -  12   ]  %% COMMENTAIRE )__",@"",@"",@"",@"",@"",@"",@"",@"");
    TEST(@"   __(   SEL [ end  -  12   ]  : DEFAULT VALUE     %% COMMENTAIRE )__",@"",@"",@"",@"",@"",@"",@" DEFAULT VALUE     % COMMENTAIRE ",@"");
    TEST_NO(@"   __(   SEL  [ 120   ]  %% COMMENTAIRE )__",@"",@"",@"",@"120",@"",@"",@"",@"");
    TEST(@"   __(   SEL  [ 120   ]  : DEFAULT VALUE     %% COMMENTAIRE )__",@"",@"",@"",@"",@"",@"",@" DEFAULT VALUE     % COMMENTAIRE ",@"");
    TEST_NO(@"   )__(   SEL  )__",@"",@"",@"",@"",@"",@"",@"",@"");
    RE = [ICURegEx regExForKey:iTM2RegExpMKSelectorArgumentKey error:NULL];
    TEST(@"   __(   SEL  )__",@"",@"",@"",@"",@"",@"",@"",@"");
    TEST(@"   __(   SEL : DEFAULT VALUE     )__",@"",@"",@"",@"",@"",@"",@" DEFAULT VALUE     ",@"");
    TEST(@"   __(   SEL  [ end  -  12   ]  )__",@"",@"end",@"12",@"",@"",@"",@"",@"");
    TEST(@"   __(   SEL [ end  -  12   ]  : DEFAULT VALUE     )__",@"",@"end",@"12",@"",@"",@"",@" DEFAULT VALUE     ",@"");
    TEST(@"   __(   SEL  [ 120   ]  )__",@"",@"",@"",@"120",@"",@"",@"",@"");
    TEST(@"   __(   SEL  [ 120   ]  : DEFAULT VALUE     )__",@"",@"",@"",@"120",@"",@"",@" DEFAULT VALUE     ",@"");
    TEST(@"   )__(   SEL  )__",@"",@"",@"",@"",@"",@"",@"",@"");
    TEST(@"   __(   SEL  %% COMMENTAIRE )__",@"",@"",@"",@"",@"",@"",@"",@"% COMMENTAIRE ");
    TEST(@"   __(   SEL : DEFAULT VALUE     %% COMMENTAIRE )__",@"",@"",@"",@"",@"",@"",@" DEFAULT VALUE     %% COMMENTAIRE ",@"");
    TEST(@"   __(   SEL  [ end  -  12   ]  %% COMMENTAIRE )__",@"",@"end",@"12",@"",@"",@"",@"",@"COMMENTAIRE");
    TEST(@"   __(   SEL [ end  -  12   ]  : DEFAULT VALUE     %% COMMENTAIRE )__",@"",@"end",@"12",@"",@"",@"",@" DEFAULT VALUE     %% COMMENTAIRE ",@"");
    TEST(@"   __(   SEL  [ 120   ]  %% COMMENTAIRE )__",@"",@"",@"",@"120",@"",@"",@"",@"% COMMENTAIRE ");
    TEST(@"   __(   SEL  [ 120   ]  : DEFAULT VALUE     %% COMMENTAIRE )__",@"",@"",@"",@"120",@"",@"",@" DEFAULT VALUE     %% COMMENTAIRE ",@"");
    TEST(@"   )__(   SEL  )__",@"",@"",@"",@"",@"",@"",@"",@"");

NSString * const iTM2RegExpMKEOLKey = @"EOL";
NSString * const iTM2RegExpMKSELKey = @"SEL";
NSString * const iTM2RegExpMKTypeKey = @"TYPE";
NSString * const iTM2RegExpMKSelectorArgumentKey = @"SEL...";


NSString * const iTM2RegExpMKSELPlaceholderKey = @"__(SEL...)__";
NSString * const iTM2RegExpMKSELOrEOLKey = @"__(SEL...)__|EOL";
NSString * const iTM2RegExpMKPlaceholderMarkKey = @"__(|)__";
NSString * const iTM2RegExpMKStartPlaceholderMarkKey = @"__(";
NSString * const iTM2RegExpMKStopPlaceholderMarkKey = @")__";
NSString * const iTM2RegExpMKSELOrTypeKey = @"SEL|TYPE...";
NSString * const iTM2RegExpMKPlaceholderKey = @"__(SEL|TYPE...)__";
NSString * const iTM2RegExpMKPlaceholderOrEOLKey = @"__(SEL|TYPE...)__|EOL";
*/

#   undef TEST_NO
#   undef TEST
#   undef TEST_2
#   undef TEST_1
}
- (void) testCase_SELOrEOL
{
    ICURegEx * RE = [ICURegEx regExForKey:iTM2RegExpMKSELOrEOLKey error:NULL];
    NSString * inputString = [NSString stringWithFormat:
@"LF:    Line Feed,                    U+000A\n"
@"CR:    Carriage Return,              U+000D\r"
@"CR+LF: CR (U+000D) followed by LF (U+000A)\r\n"
@"NEL:   Next Line,                    U+0085%C"
@"FF:    Form Feed,                          \f"
@"LS:    Line Separator,               U+2028%C"
@"PS:    Paragraph Separator,          U+2029%C",
        0x0085,0x2028,0x2029];
    [RE setInputString:inputString];
    STAssertTrue([RE nextMatch]&&[[RE substringOfCaptureGroupWithName:iTM2RegExpMKEOLName] isEqual:@"\n"],@"MISSED LF",NULL);
    STAssertTrue([RE nextMatch]&&[[RE substringOfCaptureGroupWithName:iTM2RegExpMKEOLName] isEqual:@"\r"],@"MISSED CR",NULL);
    STAssertTrue([RE nextMatch]&&[[RE substringOfCaptureGroupWithName:iTM2RegExpMKEOLName] isEqual:@"\r\n"],@"MISSED CR+LF",NULL);
    STAssertTrue([RE nextMatch]&&[[RE substringOfCaptureGroupWithName:iTM2RegExpMKEOLName] isEqual:([NSString stringWithFormat:@"%C",0x0085])],@"MISSED NEL",NULL);
    STAssertTrue([RE nextMatch]&&[[RE substringOfCaptureGroupWithName:iTM2RegExpMKEOLName] isEqual:@"\f"],@"MISSED FF",NULL);
    STAssertTrue([RE nextMatch]&&[[RE substringOfCaptureGroupWithName:iTM2RegExpMKEOLName] isEqual:([NSString stringWithFormat:@"%C",0x2028])],@"MISSED LS",NULL);
    STAssertTrue([RE nextMatch]&&[[RE substringOfCaptureGroupWithName:iTM2RegExpMKEOLName] isEqual:([NSString stringWithFormat:@"%C",0x2029])],@"MISSED PS",NULL);
    return;
}
- (BOOL)test_iTM2_componentsOfMacroForInsertionWithIndexPath:(NSIndexPath *)IP;
{
    if (IP.length==0) {
        return NO;
    }
    //NSLog(@"Test:%@",IP);
    NSString * test;
    NSMutableArray * test_parts = nil;
    NSMutableArray * XPCTD_test = nil;
    NSMutableArray * expected = nil;
    NSMutableArray * lines = nil;
    // testing lines only
    test_parts = [NSMutableArray array];
    XPCTD_test = [NSMutableArray array];
    expected = [NSMutableArray array];
    NSUInteger i = 0;
    NSUInteger n = 0;
    NSString * s = nil;
    NSEnumerator * E1;
    NSEnumerator * E2;
    id O;
    while(YES) {
        // start with full lines
        n = [IP indexAtPosition:i];
        if (n>=fullLines.count) {
            n = 0;
        }
#       define OBJECT_n objectAtIndex:n
        s = [[fullLines OBJECT_n] componentsJoinedByString:@""];
        if (s.length) {
            lines = [NSMutableArray array];
            [XPCTD_test addObject:lines];
            E1 = [[fullLinesPrefix OBJECT_n] objectEnumerator];
            E2 = [[fullLines OBJECT_n] objectEnumerator];
            while (O = [E1 nextObject]) {
                [lines addObject:O];
                O = [E2 nextObject];
                [lines addObject:O];
            }
            [test_parts addObject:s];
        }
        // now a line with SELs place holders
#       define NEXT_i_AND_n \
        if (++i>=IP.length) {return NO;}\
        n = [IP indexAtPosition:i]
        NEXT_i_AND_n;
        if (n>=partsOfLine.count) {
            n = 0;
        }
        [XPCTD_test addObject:[partsOfLinePrefix OBJECT_n]];
        [XPCTD_test addObject:[partsOfLine OBJECT_n]];
        [test_parts addObject:[partsOfLine OBJECT_n]];
        NEXT_i_AND_n;
        NSMutableArray * MRA = [NSMutableArray array];
        [XPCTD_test addObject:MRA];
        while(YES) {
            if (n>=SELPlaceholders.count) {
                n = 0;
            }
            [MRA addObjectsFromArray:[XPCTD_SELPlaceholders OBJECT_n]];
            [test_parts addObject:[SELPlaceholders OBJECT_n]];
            NEXT_i_AND_n;
            if (n>=partsOfLine.count) {
                // no more SELs
                break;
            }
            [MRA addObject:[partsOfLine OBJECT_n]];
            [test_parts addObject:[partsOfLine OBJECT_n]];
            NEXT_i_AND_n;
        }
        NEXT_i_AND_n;
        if (n>=endsOfLine.count) {
make_the_test_and_return:
            test = [test_parts componentsJoinedByString:@""];
            if ([XPCTD_test isEqual:[self.stringController4iTM3 componentsOfMacroForInsertion:test]]) {
                //NSLog(@"SUCCESS");
            } else {
                NSLog(@"XPCTD:%@",XPCTD_test);
                NSLog(@"FOUND:%@",[self.stringController4iTM3 componentsOfMacroForInsertion:test]);
            }
            return [XPCTD_test isEqual:[self.stringController4iTM3 componentsOfMacroForInsertion:test]];
        }
        [XPCTD_test addObject:[endsOfLine OBJECT_n]];
        [test_parts addObject:[endsOfLine OBJECT_n]];
        // the line is complete
        // another similar block?
        NEXT_i_AND_n;
        if (n>=fullLines.count) {
            goto make_the_test_and_return;
        }
    }
    s = [[fullLines OBJECT_n] componentsJoinedByString:@""];
    if (s.length) {
        lines = [NSMutableArray array];
        [XPCTD_test addObject:lines];
        E1 = [[fullLinesPrefix OBJECT_n] objectEnumerator];
        E2 = [[fullLines OBJECT_n] objectEnumerator];
        while (O = [E1 nextObject]) {
            [lines addObject:O];
            O = [E2 nextObject];
            [lines addObject:O];
        }
        [test_parts addObject:s];
    }
    NEXT_i_AND_n;
    if (n<partsOfLine.count) {
        [XPCTD_test addObject:[partsOfLine OBJECT_n]];
        [test_parts addObject:[partsOfLine OBJECT_n]];
    }
    goto make_the_test_and_return;
}
- (void)IGNORE_testCase_iTM2_componentsOfMacroForInsertion;
{
    // how the test strings are built?
    // * blocks:
    // *-- leading full lines
    // --- SEL line:
    // *---- SEL blocks:
    // *------ leading chars
    // *------ SEL placeholder
    // *---- ending line part
    // * ending full lines
    // * ending chars
    NSUInteger indexes[]={0,0,0,0,0,0,0,0,0,0,
                          0,0,0,0,0,0,0,0,0,0,
                          0,0,0,0,0,0,0,0,0,0,
                          0,0,0,0,0,0,0,0,0,0};
    NSUInteger i = 0;
    // 0, 0, 1, 2147483647, 1, 1, 3, 0, 3, 1, 2147483647, 2, 2147483647, 1, 0
    indexes[2]=1;
    indexes[3]=NSNotFound;
    indexes[4]=1;
    indexes[5]=1;
    indexes[6]=3;
    indexes[8]=3;
    indexes[9]=1;
    indexes[10]=NSNotFound;
    indexes[11]=2;
    indexes[12]=NSNotFound;
    indexes[13]=1;
    NSIndexPath * IP = [NSIndexPath indexPathWithIndexes:indexes length:14];
    STAssertTrue([self test_iTM2_componentsOfMacroForInsertionWithIndexPath:IP],@"MISSED:%@",IP);
    // an example:
    // indexes[  i]=0;// first block:  leading full line
    // indexes[++i]=0;//               SEL line: 1st leading chars
    // indexes[++i]=0;//                         placeholder
    // indexes[++i]=0;//                         2nd leading chars
    // indexes[++i]=0;//                         placeholder
    // indexes[++i]=NSNotFound;//                no more placeholders
    // indexes[++i]=1;//                         ending line chars, stop here if NSNotFound
    // indexes[  i]=0;// second block: leading full line
    // indexes[++i]=0;//               SEL line: 1st leading chars
    // indexes[++i]=0;//                         placeholder
    // indexes[++i]=0;//                         2nd leading chars
    // indexes[++i]=0;//                         placeholder
    // indexes[++i]=0;//                         3rd leading chars
    // indexes[++i]=0;//                         placeholder
    // indexes[++i]=NSNotFound;//                no more placeholders
    // indexes[++i]=1;//                         ending line chars, stop here if NSNotFound
    // indexes[++i]=NSNotFound;// No more block
    // indexes[++i]=0;// trailing full lines
    // indexes[++i]=0;// trailing chars, stop here
    // STAssertTrue(i<40,@"OUT OF BOUNDS",NULL);
    // simple sample
    i = 0;
    indexes[  i]=0;
    indexes[++i]=0;
    indexes[++i]=0;
    indexes[++i]=NSNotFound;
    indexes[++i]=NSNotFound;//stop here
    IP = [NSIndexPath indexPathWithIndexes:indexes length:++i];
    STAssertTrue([self test_iTM2_componentsOfMacroForInsertionWithIndexPath:IP],@"MISSED:%@",IP);
#   define LOOP(LEVEL,MAX_LEVEL) for(indexes[LEVEL]=0;indexes[LEVEL]<MAX_LEVEL;++indexes[LEVEL])
#   define NUMBER_OF_LINES fullLines.count
#   define NUMBER_OF_PARTS partsOfLine.count
#   define NUMBER_OF_SELS SELPlaceholders.count
#   define NUMBER_OF_ENDS endsOfLine.count
    NSLog(@"Short Test 1");
    LOOP(0,NUMBER_OF_LINES) {// full line
        LOOP(1,NUMBER_OF_PARTS) {// line header
            LOOP(2,NUMBER_OF_SELS) {// SEL
                indexes[3]=NSNotFound;// no more SELs
                indexes[4]=NSNotFound;//stop here
                IP = [NSIndexPath indexPathWithIndexes:indexes length:5];
                STAssertTrue([self test_iTM2_componentsOfMacroForInsertionWithIndexPath:IP],@"MISSED:%@",IP);
            }
        }
    }
    NSLog(@"Less Short Test 2");
    LOOP(0,NUMBER_OF_LINES) {// full line
        LOOP(1,NUMBER_OF_PARTS) {// line header
            LOOP(2,NUMBER_OF_SELS) {// SEL
                indexes[3]=NSNotFound;// no more SELs
                LOOP(4,NUMBER_OF_PARTS) {// end of line
                    indexes[5]=NSNotFound;//stop here
                    IP = [NSIndexPath indexPathWithIndexes:indexes length:6];
                    STAssertTrue([self test_iTM2_componentsOfMacroForInsertionWithIndexPath:IP],@"MISSED:%@",IP);
                }
            }
        }
    }
    NSLog(@"Lesser Short Test 3");
    LOOP(0,NUMBER_OF_LINES) {// full line
        LOOP(1,NUMBER_OF_PARTS) {// line header
            LOOP(2,NUMBER_OF_SELS) {// SEL
                indexes[3]=NSNotFound;// no more SELs
                LOOP(4,NUMBER_OF_PARTS) {// end of line
                    indexes[5]=NSNotFound;// no more SEL block
                    LOOP(6,NUMBER_OF_LINES) {// full line
                        indexes[7]=NSNotFound;//stop here
                        IP = [NSIndexPath indexPathWithIndexes:indexes length:8];
                        STAssertTrue([self test_iTM2_componentsOfMacroForInsertionWithIndexPath:IP],@"MISSED:%@",IP);
                    }
                }
            }
        }
    }
    NSLog(@"Even lesser Short Test 4");
    LOOP(0,NUMBER_OF_LINES) {// full line
        LOOP(1,NUMBER_OF_PARTS) {// line header
            LOOP(2,NUMBER_OF_SELS) {// SEL
                indexes[3]=NSNotFound;// no more SELs
                LOOP(4,NUMBER_OF_PARTS) {// end of line
                    indexes[5]=NSNotFound;// no more SEL block
                    LOOP(6,NUMBER_OF_LINES) {// full line
                        LOOP(7,NUMBER_OF_PARTS) {// terminating part
                            IP = [NSIndexPath indexPathWithIndexes:indexes length:8];
                            STAssertTrue([self test_iTM2_componentsOfMacroForInsertionWithIndexPath:IP],@"MISSED:%@",IP);
                        }
                    }
                }
            }
        }
    }
    NSLog(@"Medium Test 5");
    LOOP(0,NUMBER_OF_LINES) {// full line
        LOOP(1,NUMBER_OF_PARTS) {// line header
            LOOP(2,NUMBER_OF_SELS) {// SEL
        LOOP(3,NUMBER_OF_PARTS) {// line header
            LOOP(4,NUMBER_OF_SELS) {// SEL
                indexes[5]=NSNotFound;// no more SELs
                indexes[6]=NSNotFound;//stop here
                IP = [NSIndexPath indexPathWithIndexes:indexes length:7];
                STAssertTrue([self test_iTM2_componentsOfMacroForInsertionWithIndexPath:IP],@"MISSED:%@",IP);
            }
        }
            }
        }
    }
    NSLog(@"Huge Test 6");
    LOOP(0,NUMBER_OF_LINES) {// full line
        LOOP(1,NUMBER_OF_PARTS) {// line header
            LOOP(2,NUMBER_OF_SELS) {// SEL
                indexes[3]=NSNotFound;// no more SELs
                LOOP(4,NUMBER_OF_PARTS) {// end of line
    LOOP(5,NUMBER_OF_LINES) {// another block, full line
        LOOP(6,NUMBER_OF_PARTS) {// line header
            LOOP(7,NUMBER_OF_SELS) {// SEL
        LOOP(8,NUMBER_OF_PARTS) {// line header
            LOOP(9,NUMBER_OF_SELS) {// SEL
                indexes[10]=NSNotFound;// no more SELs
                LOOP(11,NUMBER_OF_PARTS) {// end of line
                    indexes[12]=NSNotFound;// no more SEL block
                    LOOP(13,NUMBER_OF_LINES) {// full line
                        LOOP(14,NUMBER_OF_PARTS) {// terminating part
                            IP = [NSIndexPath indexPathWithIndexes:indexes length:15];
                            STAssertTrue([self test_iTM2_componentsOfMacroForInsertionWithIndexPath:IP],@"MISSED %@",IP);
                        }
                    }
                }
            }
        }
            }
        }
    }
                }
            }
        }
    }
}
- (void)testCaseInsertMacroInRange;
{
    //NSTextView * TV = nil;
}
@synthesize fullLines;
@synthesize fullLinesPrefix;
@synthesize partsOfLine;
@synthesize partsOfLinePrefix;
@synthesize endsOfLine;
@synthesize SELPlaceholders;
@synthesize XPCTD_SELPlaceholders;
@end

