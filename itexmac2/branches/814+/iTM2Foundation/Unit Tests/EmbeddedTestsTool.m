#import <Cocoa/Cocoa.h>
#import "ICURegEx.h"

int main (int argc, const char * argv[]) {
    if (argc < 3) {
        return 1;
    }
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    NSURL * url = [NSURL fileURLWithPath:[NSString stringWithUTF8String:argv[1]]];
    if (!url) {
        NSLog(@"**** ROR-1:%@",url);
        return -1;
    }
    NSLog(@"where:%@",url);
    NSString * frameworkName = [url.lastPathComponent stringByDeletingPathExtension];
    NSString * path = [NSString stringWithUTF8String:argv[2]];
    path = [path stringByAppendingPathComponent:url.lastPathComponent];
    NSFileManager * DFM = [NSFileManager defaultManager];
    NSError * ROR = nil;
    if (![DFM createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&ROR]) {
        NSLog(@"**** ROR-1:%@",ROR);
        return -1;
    }
    NSURL * embeddedURL = [NSURL fileURLWithPath:path];
    NSLog(@"embeddedURL:%@",embeddedURL);
    if (!embeddedURL) {
        NSLog(@"**** ROR--1:'%@'",[NSString stringWithUTF8String:argv[2]]);
        return -1;
    }
    NSDirectoryEnumerator * DE = [DFM enumeratorAtURL:url includingPropertiesForKeys:[NSArray arrayWithObject:NSFileTypeRegular] options:NSDirectoryEnumerationSkipsPackageDescendants|NSDirectoryEnumerationSkipsHiddenFiles errorHandler:NULL];
    ICURegEx * RE1 = [ICURegEx regExWithSearchPattern:@".*iTM2.*\\.m" error:&ROR];
    if (ROR) {
        NSLog(@"**** ROR1:%@",ROR);
        return 1;
    }
    ICURegEx * RE2 = [ICURegEx regExWithSearchPattern:@"(?i:iTM2.*test)" error:&ROR];
    if (ROR) {
        NSLog(@"**** ROR2:%@",ROR);
        return 2;
    }
    ICURegEx * RE_EOL = [ICURegEx regExWithSearchPattern:@"\\r\\n|\\r|\\n|\\f|\\u0085|\\u2028|\\u2029" error:&ROR];
    if (ROR) {
        NSLog(@"**** ROR3:%@",ROR);
        return 3;
    }
    ICURegEx * RE_SETUP = [ICURegEx regExWithSearchPattern:@"#\\s*ifdef\\s*__EMBEDDED_TEST_SETUP__" error:&ROR];
    if (ROR) {
        NSLog(@"**** ROR4a:%@",ROR);
        return 41;
    }
    ICURegEx * RE_TEARDOWN = [ICURegEx regExWithSearchPattern:@"#\\s*ifdef\\s*__EMBEDDED_TEST_TEARDOWN__" error:&ROR];
    if (ROR) {
        NSLog(@"**** ROR4b:%@",ROR);
        return 42;
    }
    ICURegEx * RE_BEGIN = [ICURegEx regExWithSearchPattern:@"#\\s*ifdef\\s*__EMBEDDED_TEST_BEGIN__" error:&ROR];
    if (ROR) {
        NSLog(@"**** ROR4c:%@",ROR);
        return 43;
    }
    ICURegEx * RE_CONTINUE = [ICURegEx regExWithSearchPattern:@"#\\s*ifdef\\s*__EMBEDDED_TEST_CONTINUE__" error:&ROR];
    if (ROR) {
        NSLog(@"**** ROR4d:%@",ROR);
        return 44;
    }
    ICURegEx * RE_END = [ICURegEx regExWithSearchPattern:@"#\\s*ifdef\\s*__EMBEDDED_TEST_END__" error:&ROR];
    if (ROR) {
        NSLog(@"**** ROR4e:%@",ROR);
        return 45;
    }
    ICURegEx * RE_TESTCASE = [ICURegEx regExWithSearchPattern:@"#\\s*ifdef\\s*__EMBEDDED_TEST__" error:&ROR];
    if (ROR) {
        NSLog(@"**** ROR4f:%@",ROR);
        return 46;
    }
    ICURegEx * RE_REACH = [ICURegEx regExWithSearchPattern:@"ReachCode4iTM3\\s*\\(\\s*(@\".*?\")\\s*\\)" error:&ROR];
    NSLog(@"warning: testing RE_REACH",RE_REACH);
    if (ROR) {
        NSLog(@"**** ROR4g:%@",ROR);
        return 47;
    }
    if (![RE_REACH matchString:@"                    ReachCode4iTM3(@\"textStorageDidDeleteCharacterAtIndex_2\");"]) {
        NSLog(@"**** ROR4ga: bad RE_REACH-1");
        return 47;
    }
    if (![@"@\"textStorageDidDeleteCharacterAtIndex_2\"" isEqual:[RE_REACH substringOfCaptureGroupAtIndex:1]]) {
        NSLog(@"**** ROR4ga: bad RE_REACH-2");
        return 47;
    }
    ICURegEx * RE5 = [ICURegEx regExWithSearchPattern:@"#\\s*endif" error:&ROR];
    if (ROR) {
        NSLog(@"**** ROR5:%@",ROR);
        return 5;
    }
    ICURegEx * RE6 = [ICURegEx regExWithSearchPattern:@"(?i:/Archive/)" error:&ROR];
    if (ROR) {
        NSLog(@"**** ROR6:%@",ROR);
        return 6;
    }
    NSMutableArray * testCaseInvocations = NSMutableArray.new;
    NSMutableArray * testCases = NSMutableArray.new;
    NSStringEncoding encoding = NSUTF8StringEncoding;
    for (NSURL * URL in DE) {
        NSNumber * N = nil;
        if ([URL getResourceValue:&N forKey:NSURLIsRegularFileKey error:&ROR] && [N boolValue]) {
            if ([RE1 matchString:URL.path] &&! [RE2 matchString:URL.path] &&! [RE6 matchString:URL.path]) {
                NSString * content = [NSString stringWithContentsOfURL:URL usedEncoding:&encoding error:&ROR];
                RE_EOL.inputString = content;
                NSMutableArray * setups = NSMutableArray.array;
                NSMutableArray * teardowns = NSMutableArray.array;
                NSMutableArray * tests = NSMutableArray.array;
                NSEnumerator * E = RE_EOL.componentsBySplitting.objectEnumerator;
                NSString * line = nil;
                NSUInteger n = 0;
                NSString * __CODE_TAG__ = @"NONE";
                while ((line = E.nextObject)) {
                    if ([RE_SETUP matchString:line]) {
                        while ((line = E.nextObject)) {
                            if ([RE5 matchString:line]) {
                                break;
                            } else {
                                [setups addObject:line];
                            }
                        }
                    } else if ([RE_TEARDOWN matchString:line]) {
                        while ((line = E.nextObject)) {
                            if ([RE5 matchString:line]) {
                                break;
                            } else {
                                [teardowns addObject:line];
                            }
                        }
                    } else if ([RE_REACH matchString:line]) {
                        __CODE_TAG__ = [RE_REACH substringOfCaptureGroupAtIndex:1];
                    } else if ([RE_BEGIN matchString:line]) {
                        ++n;
                        [tests addObject:[NSString stringWithFormat:@"-(void)testCase_%li;\n{",n]];
                        [tests addObject:[NSString stringWithFormat:@"\tNSString * __CODE_TAG__ = %@;",__CODE_TAG__]];
                        while ((line = E.nextObject)) {
                            if ([RE5 matchString:line]) {
                                break;
                            } else {
                                [tests addObject:line];
                            }
                        }
                    } else if ([RE_CONTINUE matchString:line]) {
                        while ((line = E.nextObject)) {
                            if ([RE5 matchString:line]) {
                                break;
                            } else {
                                [tests addObject:line];
                            }
                        }
                    } else if ([RE_END matchString:line]) {
                        while ((line = E.nextObject)) {
                            [tests addObject:@"}\n"];
                            break;
                        }
                    } else if ([RE_TESTCASE matchString:line]) {
                        ++n;
                        [tests addObject:[NSString stringWithFormat:@"-(void)testCase_%li;\n{",n]];
                        [tests addObject:[NSString stringWithFormat:@"\tNSString * __CODE_TAG__ = %@;",__CODE_TAG__]];
                        while ((line = E.nextObject)) {
                            if ([RE5 matchString:line]) {
                                [tests addObject:@"}\n"];
                                break;
                            } else {
                                [tests addObject:line];
                            }
                        }
                    }
                }
                if (setups.count) {
                    [setups insertObject:@"{" atIndex:0];
                    [setups insertObject:@"-(void)setUp;" atIndex:0];
                    [setups addObject:@"}"];
                }
                if (teardowns.count) {
                    [teardowns insertObject:@"{" atIndex:0];
                    [teardowns insertObject:@"-(void)tearDown;" atIndex:0];
                    [teardowns addObject:@"}"];
                }
                [setups addObjectsFromArray:teardowns];
                [setups addObjectsFromArray:tests];
                if (setups.count) {
                    NSString * className = [NSString stringWithFormat:@"%@TestCases",[URL.lastPathComponent stringByDeletingPathExtension]];
                    NSURL * baseNameURL = [NSURL URLWithString:className relativeToURL:embeddedURL];
                    [setups insertObject:[NSString stringWithFormat:@"@implementation %@",className] atIndex:0];
                    [setups addObject:@"@end"];
                    NSString * header = [NSString stringWithFormat:@"#import \"iTM3SenTestKit.h\"\n"
                        @"@interface %@ : SenTestCase {\n"
                        @"}\n"
                        @"@end\n",className];
                    [setups insertObject:header atIndex:0];
                    [setups insertObject:@"//This file was generated automatically by the 'Prepare Embedded Tests' build phase." atIndex:0];
                    NSString * source = [setups componentsJoinedByString:@"\n"];
                    if (![source writeToURL:[baseNameURL URLByAppendingPathExtension:@"m"] atomically:YES encoding:encoding error:&ROR]) {
                        NSLog(@"ROR:%@",ROR);
                        return -2;
                    }
                    [testCases addObject:[NSString stringWithFormat:@"#import \"%@/%@.m\"",frameworkName,className]];
                    [testCaseInvocations addObject:[NSString stringWithFormat:@"    [[[%@ alloc] init] invokeTest];",className]];
                }
            }
        } else if (ROR) {
            NSLog(@"**** ROR:%@",ROR);
            ROR = nil;
        }
    }
    if (testCases.count) {
        NSString * S = [NSString stringWithFormat:@"%@TestCases.m",frameworkName];
        NSURL * URL = [NSURL URLWithString:S relativeToURL:[embeddedURL URLByDeletingLastPathComponent]];
        [testCases addObject:[NSString stringWithFormat:@"#warning %@\nvoid invoke_%@_testCases(void);\nvoid invoke_%@_testCases(void) {",frameworkName,frameworkName,frameworkName]];
        [testCases addObjectsFromArray:testCaseInvocations];
        [testCases addObject:@"}"];
        [testCases insertObject:@"//This file was generated automatically by the 'Prepare Embedded Tests' build phase." atIndex:0];
        S = [testCases componentsJoinedByString:@"\n"];
        if (![S writeToURL:URL atomically:YES encoding:encoding error:&ROR]) {
            NSLog(@"ROR:%@",ROR);
            return -2;
        }
    }
    [pool drain];
    return 0;
}
