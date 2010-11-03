//
//  iTM2Test2
//  iTM2Foundation
//
//  Created by Jérôme Laurens on 16/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
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
#import "iTM2Runtime.h"
#import "iTM2TreeKit.h"
#import "RegexKitLite.h"
#import "ICURegEx.h"

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

#import "iTM2ProjectDocumentKit.h"
#import "iTM2ProjectControllerKit.h"
#import "iTM2InfoWrapperKit.h"

#import "iTM2SystemSignalKit.h"
#import "iTM2Responders.h"
#import "iTM2SpellKit.h"
#import "iTM2ProjectSpellKit.h"
#import "iTM2TaskKit.h"
#import "iTM2StartupKit.h"

#import "iTM2Test2.h"

@implementation iTM2Test2
- (void) setUp
{
    // Create data structures here.
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:@"/Applications"];
}

- (void) tearDown
{
    // Release data structures here.
}
#define BIGLOG(URL)\
    do {\
        NSURL * __U = URL;\
        NSLog(@"%s%@(0x%X)","BIGLOG "#URL":",__U,__U);\
        NSLog(@"base:%@",__U.baseURL);\
        NSLog(@"absoluteString:%@",__U.absoluteString);\
        NSLog(@"relativeString:%@",__U.relativeString);\
        NSLog(@"scheme:%@",__U.scheme);\
        NSLog(@"resourceSpecifier:%@",__U.resourceSpecifier);\
        NSLog(@"host:%@",__U.host);\
        NSLog(@"port:%@",__U.port);\
        NSLog(@"user:%@",__U.user);\
        NSLog(@"password:%@",__U.password);\
        NSLog(@"path:%@",__U.path);\
        NSLog(@"fragment:%@",__U.fragment);\
        NSLog(@"parameterString:%@",__U.parameterString);\
        NSLog(@"query:%@",__U.query);\
        NSLog(@"relativePath:%@",__U.relativePath);\
        NSLog(@"absoluteURL:%@",__U.absoluteURL);\
        NSLog(@"standardizedURL:%@",__U.standardizedURL);\
        NSLog(@"absoluteURL.standardizedURL:%@",__U.absoluteURL.standardizedURL);\
    } while (NO)

- (void) testCase0
{
    //  Ultimate test for NSURL behaviour
    //  This is for Mac OS X 10.6.2 (10C540)
    //  Testing URL basic functions
    NSURL * U = nil;
    NSURL * u = nil;
    NSURL * UU = nil;
    NSURL * uu = nil;
    //  Very basic tests
    #define BIGTEST(U,ABSOLUTE_STRING,RELATIVE_STRING,SCHEME,RESOURCE_SPEC,HOST,PORT,USER,PASSWD,PATH,FRAGMENT,PARAMETER,QUERY,RELATIVE_PATH,BASE_URL)\
    do {\
        if (ABSOLUTE_STRING) STAssertEqualObjects(U.absoluteString,ABSOLUTE_STRING,@"MISSED",nil);\
        else STAssertNil(U.absoluteString,@"MISSED",nil);\
        if (RELATIVE_STRING) STAssertEqualObjects(U.relativeString,RELATIVE_STRING,@"MISSED",nil);\
        else STAssertNil(U.absoluteString,@"MISSED",nil);\
        if (SCHEME) STAssertEqualObjects(U.scheme,SCHEME,@"MISSED",nil);\
        else STAssertNil(U.scheme,@"MISSED",nil);\
        if (RESOURCE_SPEC) STAssertEqualObjects(U.resourceSpecifier,RESOURCE_SPEC,@"MISSED",nil);\
        else STAssertNil(U.resourceSpecifier,@"MISSED",nil);\
        if (HOST) STAssertEqualObjects(U.host,HOST,@"MISSED",nil);\
        else STAssertNil(U.host,@"MISSED",nil);\
        if (PORT) STAssertEqualObjects(U.port,PORT,@"MISSED",nil);\
        else STAssertNil(U.port,@"MISSED",nil);\
        if (USER) STAssertEqualObjects(U.user,USER,@"MISSED",nil);\
        else STAssertNil(U.user,@"MISSED",nil);\
        if (PASSWD) STAssertEqualObjects(U.password,PASSWD,@"MISSED",nil);\
        else STAssertNil(U.password,@"MISSED",nil);\
        if (PATH) STAssertEqualObjects(U.path,PATH,@"MISSED",nil);\
        else STAssertNil(U.path,@"MISSED",nil);\
        if (FRAGMENT) STAssertEqualObjects(U.fragment,FRAGMENT,@"MISSED",nil);\
        else STAssertNil(U.fragment,@"MISSED",nil);\
        if (PARAMETER) STAssertEqualObjects(U.parameterString,PARAMETER,@"MISSED",nil);\
        else STAssertNil(U.parameterString,@"MISSED",nil);\
        if (QUERY) STAssertEqualObjects(U.query,QUERY,@"MISSED",nil);\
        else STAssertNil(U.query,@"MISSED",nil);\
        if (RELATIVE_PATH) STAssertEqualObjects(U.relativePath,RELATIVE_PATH,@"MISSED",nil);\
        else STAssertNil(U.relativePath,@"MISSED",nil);\
        NSURL * ___BASE_URL = BASE_URL;\
        if (___BASE_URL) STAssertEqualObjects(U.baseURL,___BASE_URL.absoluteURL,@"MISSED",nil);\
        else STAssertNil(U.baseURL,@"MISSED",nil);\
    } while(NO)
	U = [NSURL URLWithString:@"myScheme://jlaurens:password@my_host:81/root/subdirectory;parameters?truc=much&machin=zob#counard"];
    BIGTEST(U,
        @"myScheme://jlaurens:password@my_host:81/root/subdirectory;parameters?truc=much&machin=zob#counard",
        @"myScheme://jlaurens:password@my_host:81/root/subdirectory;parameters?truc=much&machin=zob#counard",
        @"myScheme",
        @"//jlaurens:password@my_host:81/root/subdirectory;parameters?truc=much&machin=zob#counard",
        @"my_host",
        [NSNumber numberWithInteger:81],
        @"jlaurens",
        @"password",
        @"/root/subdirectory",
        @"counard",
        @"parameters",
        @"truc=much&machin=zob",
        @"/root/subdirectory",
        nil);
    //  Parent URL
    u = [NSURL URLWithString:@".." relativeToURL:U];
    STAssertEqualObjects(u.absoluteString,@"myScheme://jlaurens:password@my_host:81/",@"MISSED",nil);
    STAssertEqualObjects(u.relativeString,@"..",@"MISSED",nil);
    STAssertEqualObjects(u.scheme,@"myScheme",@"MISSED",nil);
    STAssertEqualObjects(u.resourceSpecifier,@"..",@"MISSED",nil);
    STAssertEqualObjects(u.host,@"my_host",@"MISSED",nil);
    STAssertEqualObjects(u.port,[NSNumber numberWithInteger:81],@"MISSED",nil);
    STAssertEqualObjects(u.user,@"jlaurens",@"MISSED",nil);
    STAssertEqualObjects(u.password,@"password",@"MISSED",nil);
    STAssertEqualObjects(u.path,@"/",@"MISSED",nil);
    STAssertNil(u.fragment,@"MISSED",nil);
    STAssertNil(u.parameterString,@"MISSED",nil);
    STAssertNil(u.query,@"MISSED",nil);
    STAssertEqualObjects(u.relativePath,@"..",@"MISSED",nil);
    STAssertEqualObjects(u.baseURL,U,@"MISSED",nil);
    u = [NSURL URLWithString:@"." relativeToURL:U];
    STAssertEqualObjects(u.absoluteString,@"myScheme://jlaurens:password@my_host:81/root/",@"MISSED",nil);
    STAssertEqualObjects(u.relativeString,@".",@"MISSED",nil);
    STAssertEqualObjects(u.scheme,@"myScheme",@"MISSED",nil);
    STAssertEqualObjects(u.resourceSpecifier,@".",@"MISSED",nil);
    STAssertEqualObjects(u.host,@"my_host",@"MISSED",nil);
    STAssertEqualObjects(u.port,[NSNumber numberWithInteger:81],@"MISSED",nil);
    STAssertEqualObjects(u.user,@"jlaurens",@"MISSED",nil);
    STAssertEqualObjects(u.password,@"password",@"MISSED",nil);
    STAssertEqualObjects(u.path,@"/root",@"MISSED",nil);
    STAssertNil(u.fragment,@"MISSED",nil);
    STAssertNil(u.parameterString,@"MISSED",nil);
    STAssertNil(u.query,@"MISSED",nil);
    STAssertEqualObjects(u.relativePath,@".",@"MISSED",nil);
    STAssertEqualObjects(u.baseURL,U,@"MISSED",nil);
    UU = [U URLByAppendingPathComponent:@"component"];
    STAssertEqualObjects(UU.absoluteString,@"myScheme://jlaurens:password@my_host:81/root/subdirectory/component;parameters?truc=much&machin=zob#counard",@"MISSED",nil);
    STAssertEqualObjects(UU.relativeString,@"myScheme://jlaurens:password@my_host:81/root/subdirectory/component;parameters?truc=much&machin=zob#counard",@"MISSED",nil);
    STAssertEqualObjects(UU.scheme,@"myScheme",@"MISSED",nil);
    STAssertEqualObjects(UU.resourceSpecifier,@"//jlaurens:password@my_host:81/root/subdirectory/component;parameters?truc=much&machin=zob#counard",@"MISSED",nil);
    STAssertEqualObjects(UU.host,@"my_host",@"MISSED",nil);
    STAssertEqualObjects(UU.port,[NSNumber numberWithInteger:81],@"MISSED",nil);
    STAssertEqualObjects(UU.user,@"jlaurens",@"MISSED",nil);
    STAssertEqualObjects(UU.password,@"password",@"MISSED",nil);
    STAssertEqualObjects(UU.path,@"/root/subdirectory/component",@"MISSED",nil);
    STAssertEqualObjects(UU.fragment,@"counard",@"MISSED",nil);
    STAssertEqualObjects(UU.parameterString,@"parameters",@"MISSED",nil);
    STAssertEqualObjects(UU.query,@"truc=much&machin=zob",@"MISSED",nil);
    STAssertEqualObjects(UU.relativePath,@"/root/subdirectory/component",@"MISSED",nil);
    STAssertNil(UU.baseURL,@"MISSED",nil);
    uu = [UU URLByDeletingLastPathComponent];
    STAssertEqualObjects(uu.absoluteString,@"myScheme://jlaurens:password@my_host:81/root/subdirectory/;parameters?truc=much&machin=zob#counard",@"MISSED",nil);
    STAssertEqualObjects(uu.relativeString,@"myScheme://jlaurens:password@my_host:81/root/subdirectory/;parameters?truc=much&machin=zob#counard",@"MISSED",nil);
    STAssertEqualObjects(uu.scheme,@"myScheme",@"MISSED",nil);
    STAssertEqualObjects(uu.resourceSpecifier,@"//jlaurens:password@my_host:81/root/subdirectory/;parameters?truc=much&machin=zob#counard",@"MISSED",nil);
    STAssertEqualObjects(uu.host,@"my_host",@"MISSED",nil);
    STAssertEqualObjects(uu.port,[NSNumber numberWithInteger:81],@"MISSED",nil);
    STAssertEqualObjects(uu.user,@"jlaurens",@"MISSED",nil);
    STAssertEqualObjects(uu.password,@"password",@"MISSED",nil);
    STAssertEqualObjects(uu.path,@"/root/subdirectory",@"MISSED",nil);
    STAssertEqualObjects(uu.fragment,@"counard",@"MISSED",nil);
    STAssertEqualObjects(uu.parameterString,@"parameters",@"MISSED",nil);
    STAssertEqualObjects(uu.query,@"truc=much&machin=zob",@"MISSED",nil);
    STAssertEqualObjects(uu.relativePath,@"/root/subdirectory",@"MISSED",nil);
    STAssertNil(uu.baseURL,@"MISSED",nil);
    UU = [u URLByAppendingPathComponent:@"component"];
    STAssertEqualObjects(UU.absoluteString,@"myScheme://jlaurens:password@my_host:81/root/component",@"MISSED",nil);
    STAssertEqualObjects(UU.relativeString,@"./component",@"MISSED",nil);
    STAssertEqualObjects(UU.scheme,@"myScheme",@"MISSED",nil);
    STAssertEqualObjects(UU.resourceSpecifier,@"./component",@"MISSED",nil);
    STAssertEqualObjects(UU.host,@"my_host",@"MISSED",nil);
    STAssertEqualObjects(UU.port,[NSNumber numberWithInteger:81],@"MISSED",nil);
    STAssertEqualObjects(UU.user,@"jlaurens",@"MISSED",nil);
    STAssertEqualObjects(UU.password,@"password",@"MISSED",nil);
    STAssertEqualObjects(UU.path,@"/root/component",@"MISSED",nil);
    STAssertNil(UU.fragment,@"MISSED",nil);
    STAssertNil(UU.parameterString,@"MISSED",nil);
    STAssertNil(UU.query,@"MISSED",nil);
    STAssertEqualObjects(UU.relativePath,@"./component",@"MISSED",nil);
    STAssertEqualObjects(UU.baseURL,U,@"MISSED",nil);
    uu = [UU URLByDeletingLastPathComponent];
    STAssertEqualObjects(uu.absoluteString,@"myScheme://jlaurens:password@my_host:81/root/",@"MISSED",nil);
    STAssertEqualObjects(uu.relativeString,@"./",@"MISSED",nil);
    STAssertEqualObjects(uu.scheme,@"myScheme",@"MISSED",nil);
    STAssertEqualObjects(uu.resourceSpecifier,@"./",@"MISSED",nil);
    STAssertEqualObjects(uu.host,@"my_host",@"MISSED",nil);
    STAssertEqualObjects(uu.port,[NSNumber numberWithInteger:81],@"MISSED",nil);
    STAssertEqualObjects(uu.user,@"jlaurens",@"MISSED",nil);
    STAssertEqualObjects(uu.password,@"password",@"MISSED",nil);
    STAssertEqualObjects(uu.path,@"/root",@"MISSED",nil);
    STAssertNil(uu.fragment,@"MISSED",nil);
    STAssertNil(uu.parameterString,@"MISSED",nil);
    STAssertNil(uu.query,@"MISSED",nil);
    STAssertEqualObjects(uu.relativePath,@".",@"MISSED",nil);
    STAssertEqualObjects(uu.baseURL,U,@"MISSED",nil);
    //  What I need is something rather safe
    //  The problem only lies in the management of paths
    //  Whether there is a terminating '/' will change things dramatically
    //  It is indeed a fact that xhttp://where/my/ and xhttp://where/my are not the same
    //  In the former case, this really points to xhttp://where/my/index.html
    //  (forget the leading x, I put it there to prevent syntax highlighting)
    //  Testing URLByAppendingPathComponent
    U = [NSURL URLWithString:@"myScheme://localhost/root/subdirectory"];
    UU = [U URLByAppendingPathComponent:@"component"];
    STAssertEqualObjects(UU.absoluteString,@"myScheme://localhost/root/subdirectory/component",@"MISSED",nil);
    STAssertEqualObjects(UU.relativeString,@"myScheme://localhost/root/subdirectory/component",@"MISSED",nil);
    STAssertEqualObjects(UU.path,@"/root/subdirectory/component",@"MISSED",nil);
    STAssertEqualObjects(UU.relativePath,@"/root/subdirectory/component",@"MISSED",nil);
    //  Appending a component with a terminating '/' ends up with a terminating '//' in the URL
    //  It does not make any kind of difference whether or not the original URL ends with a '/'.
    UU = [U URLByAppendingPathComponent:@"component/"];
    STAssertEqualObjects(UU.absoluteString,@"myScheme://localhost/root/subdirectory/component//",@"MISSED",nil);
    STAssertEqualObjects(UU.relativeString,@"myScheme://localhost/root/subdirectory/component//",@"MISSED",nil);
    STAssertEqualObjects(UU.path,@"/root/subdirectory/component/",@"MISSED",nil);
    STAssertEqualObjects(UU.relativePath,@"/root/subdirectory/component/",@"MISSED",nil);
    U = [NSURL URLWithString:@"myScheme://localhost/root/subdirectory/"];
    UU = [U URLByAppendingPathComponent:@"component/below"];
    STAssertEqualObjects(UU.absoluteString,@"myScheme://localhost/root/subdirectory/component/below",@"MISSED",nil);
    STAssertEqualObjects(UU.relativeString,@"myScheme://localhost/root/subdirectory/component/below",@"MISSED",nil);
    STAssertEqualObjects(UU.path,@"/root/subdirectory/component/below",@"MISSED",nil);
    STAssertEqualObjects(UU.relativePath,@"/root/subdirectory/component/below",@"MISSED",nil);
    UU = [U URLByAppendingPathComponent:@"component"];
    STAssertEqualObjects(UU.absoluteString,@"myScheme://localhost/root/subdirectory/component",@"MISSED",nil);
    STAssertEqualObjects(UU.relativeString,@"myScheme://localhost/root/subdirectory/component",@"MISSED",nil);
    STAssertEqualObjects(UU.path,@"/root/subdirectory/component",@"MISSED",nil);
    STAssertEqualObjects(UU.relativePath,@"/root/subdirectory/component",@"MISSED",nil);
    UU = [U URLByAppendingPathComponent:@"component/"];
    STAssertEqualObjects(UU.absoluteString,@"myScheme://localhost/root/subdirectory/component//",@"MISSED",nil);
    STAssertEqualObjects(UU.relativeString,@"myScheme://localhost/root/subdirectory/component//",@"MISSED",nil);
    STAssertEqualObjects(UU.path,@"/root/subdirectory/component/",@"MISSED",nil);
    STAssertEqualObjects(UU.relativePath,@"/root/subdirectory/component/",@"MISSED",nil);
    UU = [U URLByAppendingPathComponent:@"component/below"];
    STAssertEqualObjects(UU.absoluteString,@"myScheme://localhost/root/subdirectory/component/below",@"MISSED",nil);
    STAssertEqualObjects(UU.relativeString,@"myScheme://localhost/root/subdirectory/component/below",@"MISSED",nil);
    STAssertEqualObjects(UU.path,@"/root/subdirectory/component/below",@"MISSED",nil);
    STAssertEqualObjects(UU.relativePath,@"/root/subdirectory/component/below",@"MISSED",nil);
    //  Test relative URLs
    //  Things are completely different whether the base URL ends with a '/' or not.
    //  There are 8x3 kinds of relative URLs depending on the relative string and the base url
    //  3 base urls : "myScheme://localhost/root/subdirectory(?:|/|/.)"
    //  8 relative strings: "|/|.|..|[^/]+|[^/]+/|/[^/]+|[^/]+/[^/]+"
    #undef TEST
    #define TEST(URL,BASE_URL,STRING,ABSOLUTE_STRING,RELATIVE_STRING,PATH,RELATIVE_PATH)\
    URL = [NSURL URLWithString:STRING relativeToURL:BASE_URL];\
    if (BASE_URL) STAssertEqualObjects(URL.baseURL,BASE_URL,@"MISSED",nil);\
    else STAssertNil(BASE_URL,@"MISSED",nil);\
    if (ABSOLUTE_STRING) STAssertEqualObjects(URL.absoluteString,ABSOLUTE_STRING,@"MISSED",nil);\
    else STAssertNil(ABSOLUTE_STRING,@"MISSED",nil);\
    if (RELATIVE_STRING) STAssertEqualObjects(URL.relativeString,RELATIVE_STRING,@"MISSED",nil);\
    else STAssertNil(RELATIVE_STRING,@"MISSED",nil);\
    if (PATH) STAssertEqualObjects(URL.path,PATH,@"MISSED",nil);\
    else STAssertNil(PATH,@"MISSED",nil);\
    if (RELATIVE_PATH) STAssertEqualObjects(URL.relativePath,RELATIVE_PATH,@"MISSED",nil);\
    else STAssertNil(RELATIVE_PATH,@"MISSED",nil)
    U = [NSURL URLWithString:@"myScheme://localhost/root/subdirectory"];
    TEST(u,
        U,
        @"",
        @"myScheme://localhost/root/subdirectory",
        @"",
        @"/root/subdirectory",
        nil);
    TEST(u,
        U,
        @"/",
        @"myScheme://localhost/",
        @"/",
        @"/",
        @"/");
    TEST(u,
        U,
        @".",
        @"myScheme://localhost/root/",
        @".",
        @"/root",
        @".");
    TEST(u,
        U,
        @"..",
        @"myScheme://localhost/",
        @"..",
        @"/",
        @"..");
    TEST(u,
        U,
        @"component",
        @"myScheme://localhost/root/component",
        @"component",
        @"/root/component",
        @"component");
    TEST(u,
        U,
        @"component/",
        @"myScheme://localhost/root/component/",
        @"component/",
        @"/root/component",
        @"component");
    TEST(u,
        U,
        @"./",
        @"myScheme://localhost/root/",
        @"./",
        @"/root",
        nil);
    TEST(u,
        U,
        @"../",
        @"myScheme://localhost/",
        @"../",
        @"/",
        nil);
    TEST(u,
        U,
        @"/component",
        @"myScheme://localhost/component",
        @"/component",
        @"/component",
        @"/component");
    TEST(u,
        U,
        @"/.",
        @"myScheme://localhost/.",
        @"/.",
        @"/.",
        nil);
    //  Borderline tests: go up too much
    TEST(u,
        U,
        @"/..",
        @"myScheme://localhost/..",
        @"/..",
        @"/..",
        nil);
    TEST(u,
        U,
        @"component/subcomponent",
        @"myScheme://localhost/root/component/subcomponent",
        @"component/subcomponent",
        @"/root/component/subcomponent",
        @"component/subcomponent");
    U = [NSURL URLWithString:@"myScheme://localhost/root/subdirectory/"];
    TEST(u,
        U,
        @"",
        @"myScheme://localhost/root/subdirectory/",
        @"",
        @"/root/subdirectory",
        nil);
    TEST(u,
        U,
        @"/",
        @"myScheme://localhost/",
        @"/",
        @"/",
        @"/");
    TEST(u,
        U,
        @".",
        @"myScheme://localhost/root/subdirectory/",
        @".",
        @"/root/subdirectory",
        @".");
    TEST(u,
        U,
        @"..",
        @"myScheme://localhost/root/",
        @"..",
        @"/root",
        @"..");
    TEST(u,
        U,
        @"component",
        @"myScheme://localhost/root/subdirectory/component",
        @"component",
        @"/root/subdirectory/component",
        @"component");
    TEST(u,
        U,
        @"component/",
        @"myScheme://localhost/root/subdirectory/component/",
        @"component/",
        @"/root/subdirectory/component",
        @"component");
    TEST(u,
        U,
        @"./",
        @"myScheme://localhost/root/subdirectory/",
        @"./",
        @"/root/subdirectory",
        nil);
    TEST(u,
        U,
        @"../",
        @"myScheme://localhost/root/",
        @"../",
        @"/root",
        nil);
    TEST(u,
        U,
        @"/component",
        @"myScheme://localhost/component",
        @"/component",
        @"/component",
        @"/component");
    TEST(u,
        U,
        @"/.",
        @"myScheme://localhost/.",
        @"/.",
        @"/.",
        nil);
    //  Borderline tests: go up too much
    TEST(u,
        U,
        @"/..",
        @"myScheme://localhost/..",
        @"/..",
        @"/..",
        nil);
    TEST(u,
        U,
        @"component/subcomponent",
        @"myScheme://localhost/root/subdirectory/component/subcomponent",
        @"component/subcomponent",
        @"/root/subdirectory/component/subcomponent",
        @"component/subcomponent");
    U = [NSURL URLWithString:@"myScheme://localhost/root/subdirectory/."];
    TEST(u,
        U,
        @"",
        @"myScheme://localhost/root/subdirectory/.",
        @"",
        @"/root/subdirectory/.",
        nil);
    TEST(u,
        U,
        @"/",
        @"myScheme://localhost/",
        @"/",
        @"/",
        @"/");
    TEST(u,
        U,
        @".",
        @"myScheme://localhost/root/subdirectory/",
        @".",
        @"/root/subdirectory",
        @".");
    TEST(u,
        U,
        @"..",
        @"myScheme://localhost/root/",
        @"..",
        @"/root",
        @"..");
    TEST(u,
        U,
        @"component",
        @"myScheme://localhost/root/subdirectory/component",
        @"component",
        @"/root/subdirectory/component",
        @"component");
    TEST(u,
        U,
        @"component/",
        @"myScheme://localhost/root/subdirectory/component/",
        @"component/",
        @"/root/subdirectory/component",
        @"component");
    TEST(u,
        U,
        @"./",
        @"myScheme://localhost/root/subdirectory/",
        @"./",
        @"/root/subdirectory",
        nil);
    TEST(u,
        U,
        @"../",
        @"myScheme://localhost/root/",
        @"../",
        @"/root",
        nil);
    TEST(u,
        U,
        @"/component",
        @"myScheme://localhost/component",
        @"/component",
        @"/component",
        @"/component");
    TEST(u,
        U,
        @"/.",
        @"myScheme://localhost/.",
        @"/.",
        @"/.",
        nil);
    //  Borderline tests: go up too much
    TEST(u,
        U,
        @"/..",
        @"myScheme://localhost/..",
        @"/..",
        @"/..",
        nil);
    TEST(u,
        U,
        @"component/subcomponent",
        @"myScheme://localhost/root/subdirectory/component/subcomponent",
        @"component/subcomponent",
        @"/root/subdirectory/component/subcomponent",
        @"component/subcomponent");
    
/*
scheme:myScheme
2010-03-16 11:54:36.828 otest-i386[96836:903] base:myScheme://jlaurens:password@my_host:81/root/subdirectory;parameters?truc=much&machin=zob#counard
2010-03-16 11:54:36.837 otest-i386[96836:903] absoluteString:myScheme://jlaurens:password@my_host:81/
2010-03-16 11:54:36.841 otest-i386[96836:903] relativeString:..
2010-03-16 11:54:36.842 otest-i386[96836:903] scheme:myScheme
2010-03-16 11:54:36.842 otest-i386[96836:903] resourceSpecifier:..
2010-03-16 11:54:36.843 otest-i386[96836:903] host:my_host
2010-03-16 11:54:36.844 otest-i386[96836:903] port:81
2010-03-16 11:54:36.845 otest-i386[96836:903] user:jlaurens
2010-03-16 11:54:36.845 otest-i386[96836:903] password:password
2010-03-16 11:54:36.846 otest-i386[96836:903] path:/
2010-03-16 11:54:36.847 otest-i386[96836:903] fragment:(null)
2010-03-16 11:54:36.848 otest-i386[96836:903] parameterString:(null)
2010-03-16 11:54:36.849 otest-i386[96836:903] query:(null)
2010-03-16 11:54:36.851 otest-i386[96836:903] relativePath:..


2010-03-16 11:39:37.075 otest-i386[96620:903] resourceSpecifier://jlaurens:password@my_host:81/root;parameters?truc=much&machin=zob#counard
2010-03-16 11:39:37.076 otest-i386[96620:903] host:my_host
2010-03-16 11:39:37.083 otest-i386[96620:903] port:81
2010-03-16 11:39:37.084 otest-i386[96620:903] user:jlaurens
2010-03-16 11:39:37.086 otest-i386[96620:903] password:password
2010-03-16 11:39:37.087 otest-i386[96620:903] path:/root
2010-03-16 11:39:37.088 otest-i386[96620:903] fragment:counard
2010-03-16 11:39:37.089 otest-i386[96620:903] parameterString:parameters
2010-03-16 11:39:37.092 otest-i386[96620:903] query:truc=much&machin=zob
2010-03-16 11:39:37.093 otest-i386[96620:903] relativePath:/root
    #define U u
    NSLog(@"url0:%@",U);
    NSLog(@"base:%@",U.baseURL);
	NSLog(@"absoluteString:%@",[U absoluteString]);
	NSLog(@"relativeString:%@",[U relativeString]); // The relative portion of a URL.  If baseURL is nil, or if the receiver is itself absolute, this is the same as absoluteString
// Any URL is composed of these two basic pieces.  The full URL would be the concatenation of [myURL scheme], ':', [myURL resourceSpecifier]
	NSLog(@"scheme:%@",[U scheme]);
	NSLog(@"resourceSpecifier:%@",[U resourceSpecifier]);
//  If the URL conforms to rfc 1808 (the most common form of URL), the following accessors will return the various components; otherwise they return nil.  The litmus test for conformance is as recommended in RFC 1808 - whether the first two characters of resourceSpecifier is @"//".  In all cases, they return the component's value after resolving the receiver against its base URL.
	NSLog(@"host:%@",[U host]);
	NSLog(@"port:%@",[U port]);
	NSLog(@"user:%@",[U user]);
	NSLog(@"password:%@",[U password]);
	NSLog(@"path:%@",[U path]);
	NSLog(@"fragment:%@",[U fragment]);
	NSLog(@"parameterString:%@",[U parameterString]);
	NSLog(@"query:%@",[U query]);
	NSLog(@"relativePath:%@",[U relativePath]); // The same as path if baseURL is nil
*/
#   undef TEST
}
- (void) testCase_isEquivalentToURL4iTM3
{
#   define TEST(S1,B,S2)\
    if ([B length]) {\
        NSURL * __lhs = [NSURL URLWithString:S1 relativeToURL:[NSURL fileURLWithPath:B]];\
        NSURL * __rhs = [NSURL fileURLWithPath:S2];\
        BOOL __yorn = [__lhs isEquivalentToURL4iTM3:__rhs];\
        if (!__yorn) {\
            BIGLOG(__lhs);\
            BIGLOG(__rhs);\
        }\
        STAssertTrue(__yorn,@"MISSED",nil);\
    } else {\
        STAssertTrue([[NSURL fileURLWithPath:S1] isEquivalentToURL4iTM3:[NSURL fileURLWithPath:S2]],@"MISSED",nil);\
    }
    TEST(@"",@"/a/b/",@"/a/b/");
    TEST(@".",@"/a/b/",@"/a/b/");
    TEST(@"",@"/a/b/c",@"/a/b/c");
    TEST(@".",@"/a/b/c",@"/a/b/");
    TEST(@"c",@"/a/b/",@"/a/b/c");
    TEST(@"b/",@"/a/",@"/a/b/");
    TEST(@"b/.",@"/a/",@"/a/b/");
    TEST(@"b/c",@"/a/",@"/a/b/c");
    TEST(@"a/b/",@"/",@"/a/b/");
    TEST(@"a/b/.",@"/",@"/a/b/");
    TEST(@"a/b/c",@"/",@"/a/b/c");
    TEST(@"/a/b/",@"",@"/a/b/");
    TEST(@"/a/b/.",@"",@"/a/b/");
    TEST(@"/a/b/c",@"",@"/a/b/c");
#   undef TEST
}
- (void) testCase_fileURLWithPath4iTM3
{
    STAssertTrue([[NSURL fileURLWithPath:@"a/"] isEqualToFileURL4iTM3:[NSURL fileURLWithPath:@"/Applications/a"]],@"MISSED",nil);
    STAssertTrue([[NSURL fileURLWithPath:@"a/"] isEquivalentToURL4iTM3:[NSURL fileURLWithPath:@"/Applications/a"]],@"MISSED",nil);
    //  Unexpected results
    STAssertFalse([[NSURL fileURLWithPath:@"a/"] isEquivalentToURL4iTM3:[NSURL fileURLWithPath:@"/Applications/a/"]],@"MISSED",nil);
    STAssertTrue([[NSURL fileURLWithPath:@"a/"] isEqualToFileURL4iTM3:[NSURL fileURLWithPath:@"/Applications/a" isDirectory:YES]],@"MISSED",nil);
    //  Unexpected results
    STAssertTrue([[NSURL fileURLWithPath:@"a/"] isEquivalentToURL4iTM3:[NSURL fileURLWithPath:@"/Applications/a" isDirectory:NO]],@"MISSED",nil);
    STAssertFalse([[NSURL fileURLWithPath:@"a/"] isEquivalentToURL4iTM3:[NSURL fileURLWithPath:@"/Applications/a" isDirectory:YES]],@"MISSED",nil);
    
    STAssertTrue([[NSURL fileURLWithPath4iTM3:@"a" isDirectory:NO] isEqualToFileURL4iTM3:[NSURL fileURLWithPath:@"/Applications/a" isDirectory:NO]],@"MISSED",nil);
    STAssertTrue([[NSURL fileURLWithPath4iTM3:@"a" isDirectory:YES] isEqualToFileURL4iTM3:[NSURL fileURLWithPath:@"/Applications/a" isDirectory:YES]],@"MISSED",nil);
    STAssertTrue([[NSURL fileURLWithPath4iTM3:@"a/" isDirectory:YES] isEqualToFileURL4iTM3:[NSURL fileURLWithPath:@"/Applications/a" isDirectory:YES]],@"MISSED",nil);
    STAssertTrue([[NSURL fileURLWithPath4iTM3:@"a/" isDirectory:NO] isEqualToFileURL4iTM3:[NSURL fileURLWithPath:@"/Applications/a" isDirectory:YES]],@"MISSED",nil);
    STAssertTrue([[NSURL fileURLWithPath4iTM3:@"a/"] isEqualToFileURL4iTM3:[NSURL fileURLWithPath:@"/Applications/a" isDirectory:YES]],@"MISSED",nil);
    
    STAssertTrue([[NSURL fileURLWithPath:@"a/"] isEquivalentToURL4iTM3:[NSURL fileURLWithPath:@"/Applications/a"]],@"MISSED",nil);
    STAssertTrue([[NSURL fileURLWithPath:@"a/"] isEquivalentToURL4iTM3:[NSURL fileURLWithPath:@"/Applications/a" isDirectory:NO]],@"MISSED",nil);
    STAssertTrue([[NSURL fileURLWithPath4iTM3:@"a"] isEquivalentToURL4iTM3:[NSURL fileURLWithPath:@"/Applications/a" isDirectory:NO]],@"MISSED",nil);
    STAssertTrue([[NSURL fileURLWithPath4iTM3:@"a" isDirectory:NO] isEquivalentToURL4iTM3:[NSURL fileURLWithPath:@"/Applications/a" isDirectory:NO]],@"MISSED",nil);
    STAssertTrue([[NSURL fileURLWithPath4iTM3:@"a" isDirectory:YES] isEquivalentToURL4iTM3:[NSURL fileURLWithPath:@"/Applications/a" isDirectory:YES]],@"MISSED",nil);
    STAssertTrue([[NSURL fileURLWithPath4iTM3:@"a/"] isEquivalentToURL4iTM3:[NSURL fileURLWithPath:@"/Applications/a" isDirectory:YES]],@"MISSED",nil);
    STAssertTrue([[NSURL fileURLWithPath4iTM3:@"a/" isDirectory:YES] isEquivalentToURL4iTM3:[NSURL fileURLWithPath:@"/Applications/a" isDirectory:YES]],@"MISSED",nil);
    STAssertTrue([[NSURL fileURLWithPath4iTM3:@"a/" isDirectory:NO] isEquivalentToURL4iTM3:[NSURL fileURLWithPath:@"/Applications/a" isDirectory:YES]],@"MISSED",nil);
    STAssertTrue([[NSURL fileURLWithPath4iTM3:@"a/"] isEquivalentToURL4iTM3:[NSURL fileURLWithPath:@"/Applications/a" isDirectory:YES]],@"MISSED",nil);
}
- (void) testCase_isEqualToFileURL4iTM3
{
    STAssertTrue([[NSURL fileURLWithPath:@"a/b/c"] isEqualToFileURL4iTM3:[NSURL fileURLWithPath:@"a/b/c"]],@"MISSED",nil);
    STAssertTrue([[NSURL URLWithString:@"b/c" relativeToURL:[NSURL fileURLWithPath:@"a"]] isEqualToFileURL4iTM3:[NSURL fileURLWithPath:@"/Applications/b/c"]],@"MISSED",nil);
    STAssertTrue([[NSURL URLWithString:@"b/c" relativeToURL:[NSURL fileURLWithPath:@"a/"]] isEqualToFileURL4iTM3:[NSURL fileURLWithPath:@"/Applications/b/c"]],@"MISSED",nil);
    STAssertTrue([[NSURL URLWithString:@"b/c" relativeToURL:[NSURL fileURLWithPath:@"a/" isDirectory:YES]] isEqualToFileURL4iTM3:[NSURL fileURLWithPath:@"/Applications/a/b/c"]],@"MISSED",nil);
    STAssertTrue([[NSURL URLWithString:@"b/c" relativeToURL:[NSURL fileURLWithPath:@"/a/"]] isEqualToFileURL4iTM3:[NSURL fileURLWithPath:@"/a/b/c"]],@"MISSED",nil);
    STAssertTrue([[NSURL URLWithString:@"b/c" relativeToURL:[NSURL fileURLWithPath:@"/a"]] isEqualToFileURL4iTM3:[NSURL fileURLWithPath:@"/b/c"]],@"MISSED",nil);
    STAssertTrue([[NSURL URLWithString:@"c" relativeToURL:[NSURL fileURLWithPath:@"a/b"]] isEqualToFileURL4iTM3:[NSURL fileURLWithPath:@"/Applications/a/c"]],@"MISSED",nil);
    STAssertTrue([[NSURL URLWithString:@"c" relativeToURL:[NSURL fileURLWithPath:@"/a/b/"]] isEqualToFileURL4iTM3:[NSURL fileURLWithPath:@"/a/b/c"]],@"MISSED",nil);
    STAssertTrue([[NSURL URLWithString:@"c" relativeToURL:[NSURL fileURLWithPath:@"/a/b"]] isEqualToFileURL4iTM3:[NSURL fileURLWithPath:@"/a/c"]],@"MISSED",nil);
    STAssertTrue([[NSURL URLWithString:@"c" relativeToURL:[NSURL fileURLWithPath:@"a/b/"]] isEqualToFileURL4iTM3:[NSURL fileURLWithPath:@"/Applications/a/c"]],@"MISSED",nil);
    
    STAssertFalse([[NSURL URLWithString:@"b/c"] isEqualToFileURL4iTM3:[NSURL fileURLWithPath:@"a/b/c"]],@"MISSED",nil);
}
- (void) testCase_directoryURL4iTM3
{
    //  directoryURL4iTM3
#   define TEST(S1,YORN1,S2,YORN2)\
    if (YORN1 == -2) {\
        if (YORN2 == -2) {\
            STAssertTrue([[[NSURL fileURLWithPath:S1] directoryURL4iTM3] isEquivalentToURL4iTM3:[NSURL fileURLWithPath4iTM3:S2]],@"MISSED",nil);\
        } else {\
            STAssertTrue([[[NSURL fileURLWithPath:S1] directoryURL4iTM3] isEquivalentToURL4iTM3:[NSURL fileURLWithPath4iTM3:S2 isDirectory:YORN2]],@"MISSED",nil);\
        }\
    } else if (YORN2 == -2) {\
        STAssertTrue([[[NSURL fileURLWithPath:S1 isDirectory:YORN1] directoryURL4iTM3] isEquivalentToURL4iTM3:[NSURL fileURLWithPath4iTM3:S2]],@"MISSED",nil);\
    } else {\
        STAssertTrue([[[NSURL fileURLWithPath:S1 isDirectory:YORN1] directoryURL4iTM3] isEquivalentToURL4iTM3:[NSURL fileURLWithPath4iTM3:S2 isDirectory:YORN2]],@"MISSED",nil);\
    }
    TEST(@"a",YES,@"a",YES);
    TEST(@"a/b",YES,@"a/b",YES);
    TEST(@"a/b",YES,@"a/b/",YES);
    TEST(@"a/b",YES,@"a/b/",NO);
    TEST(@"a/b",YES,@"a/b/",-2);
    TEST(@"a/b/c",NO,@"a/b",YES);
    TEST(@"a/b/c",NO,@"a/b/",YES);
    TEST(@"a/b/c",NO,@"a/b/",NO);
    TEST(@"a/b/c",NO,@"a/b/",-2);
    TEST(@"a/b/c",-2,@"a/b",YES);
    TEST(@"a/b/c",-2,@"a/b/",YES);
    TEST(@"a/b/c",-2,@"a/b/",NO);
    TEST(@"a/b/c",-2,@"a/b/",-2);
    TEST(@"a",YES,@"/Applications/a",YES);
    TEST(@"a/b",YES,@"/Applications/a/b",YES);
    TEST(@"a/b",YES,@"/Applications/a/b/",YES);
    TEST(@"a/b",YES,@"/Applications/a/b/",NO);
    TEST(@"a/b",YES,@"/Applications/a/b/",-2);
    TEST(@"a/b/c",NO,@"/Applications/a/b",YES);
    TEST(@"a/b/c",NO,@"/Applications/a/b/",YES);
    TEST(@"a/b/c",NO,@"/Applications/a/b/",NO);
    TEST(@"a/b/c",NO,@"/Applications/a/b/",-2);
    TEST(@"a/b/c",-2,@"/Applications/a/b",YES);
    TEST(@"a/b/c",-2,@"/Applications/a/b/",YES);
    TEST(@"a/b/c",-2,@"/Applications/a/b/",NO);
    TEST(@"a/b/c",-2,@"/Applications/a/b/",-2);
    TEST(@"/a/b",YES,@"/a/b",YES);
    TEST(@"/a/b",YES,@"/a/b/",YES);
    TEST(@"/a/b",YES,@"/a/b/",NO);
    TEST(@"/a/b",YES,@"/a/b/",-2);
    TEST(@"/a/b/c",NO,@"/a/b",YES);
    TEST(@"/a/b/c",NO,@"/a/b/",YES);
    TEST(@"/a/b/c",NO,@"/a/b/",NO);
    TEST(@"/a/b/c",NO,@"/a/b/",-2);
    TEST(@"/a/b/c",-2,@"/a/b",YES);
    TEST(@"/a/b/c",-2,@"/a/b/",YES);
    TEST(@"/a/b/c",-2,@"/a/b/",NO);
    TEST(@"/a/b/c",-2,@"/a/b/",-2);
#   undef TEST
#   define TEST(S1,S2)\
    STAssertTrue([[[NSURL fileURLWithPath4iTM3:S1] directoryURL4iTM3] isEquivalentToURL4iTM3:[NSURL fileURLWithPath4iTM3:S2]],@"MISSED",nil)
    TEST(@"",@"/Applications/");
    TEST(@".",@"/Applications/");
    TEST(@"..",@"/");
    TEST(@"/",@"/");
    TEST(@"a/",@"a/");
    TEST(@"a/b/",@"a/b/");
    TEST(@"a/b/c",@"a/b/");
    TEST(@"a/",@"/Applications/a/");
    TEST(@"a/b/",@"/Applications/a/b/");
    TEST(@"a/b/c",@"/Applications/a/b/");
    TEST(@"a/b/c",@"/Applications/a/b/");
    TEST(@"/a/b/",@"/a/b/");
    TEST(@"/a/b/c",@"/a/b/");
#   undef TEST
}
- (void) testCase_parentDirectoryURL4iTM3
{
    //  parentDirectoryURL4iTM3
    NSURL * U = [NSURL URLWithString:@";COUCOU" relativeToURL:[NSURL fileURLWithPath:@"/a/b/"]];
    STAssertNil([U URLByAppendingPathComponent:@".."],@"MISSED",nil);
    U = [NSURL URLWithString:@"." relativeToURL:[NSURL fileURLWithPath:@"/a/b/"]];
    STAssertNotNil([U URLByAppendingPathComponent:@".."],@"MISSED",nil);
    //  parentDirectoryURL4iTM3 without baseURL
#   define TEST(S1,YORN1,S2,YORN2)\
    if (YORN1 == -2) {\
        if (YORN2 == -2) {\
            STAssertTrue([[[NSURL fileURLWithPath:S1] parentDirectoryURL4iTM3] isEquivalentToURL4iTM3:[NSURL fileURLWithPath:S2]],@"MISSED",nil);\
        } else {\
            STAssertTrue([[[NSURL fileURLWithPath:S1] parentDirectoryURL4iTM3] isEquivalentToURL4iTM3:[NSURL fileURLWithPath:S2 isDirectory:YORN2]],@"MISSED",nil);\
        }\
    } else if (YORN2 == -2) {\
        STAssertTrue([[[NSURL fileURLWithPath:S1 isDirectory:YORN1] parentDirectoryURL4iTM3] isEquivalentToURL4iTM3:[NSURL fileURLWithPath:S2]],@"MISSED",nil);\
    } else {\
        STAssertTrue([[[NSURL fileURLWithPath:S1 isDirectory:YORN1] parentDirectoryURL4iTM3] isEquivalentToURL4iTM3:[NSURL fileURLWithPath:S2 isDirectory:YORN2]],@"MISSED",nil);\
    }
    TEST(@"/a/b",YES,@"/a",YES);
    TEST(@"/a/b",YES,@"/a/",YES);
    TEST(@"/a/b",YES,@"/a/",NO);
    TEST(@"/a/b",YES,@"/a/",-2);
    TEST(@"/a/b/c",NO,@"/a",YES);
    TEST(@"/a/b/c",NO,@"/a/",YES);
    TEST(@"/a/b/c",NO,@"/a/",NO);
    TEST(@"/a/b/c",NO,@"/a/",-2);
    TEST(@"/a/b/c",-2,@"/a",YES);
    TEST(@"/a/b/c",-2,@"/a/",YES);
    TEST(@"/a/b/c",-2,@"/a/",NO);
    TEST(@"/a/b/c",-2,@"/a/",-2);
    TEST(@"a/b/c",-2,@"/Applications/a/",-2);
#   undef TEST
    //  parentDirectoryURL4iTM3 with baseURL
#   define TEST(S1,B,S2)\
    if ([B length]) {\
        STAssertTrue([[[NSURL URLWithString:S1 relativeToURL:[NSURL fileURLWithPath:B]] parentDirectoryURL4iTM3] isEquivalentToURL4iTM3:[NSURL fileURLWithPath:S2]],@"MISSED",nil);\
    } else {\
        STAssertTrue([[[NSURL fileURLWithPath:S1] parentDirectoryURL4iTM3] isEquivalentToURL4iTM3:[NSURL fileURLWithPath:S2]],@"MISSED",nil);\
    }
    TEST(@"",@"/a/b/",@"/a/");
    TEST(@".",@"/a/b/",@"/a/");
    TEST(@"",@"/a/b/c",@"/a/");
    TEST(@".",@"/a/b/c",@"/a/");
    TEST(@"c",@"/a/b/",@"/a/");
    TEST(@"b/",@"/a/",@"/a/");
    TEST(@"b/.",@"/a/",@"/a/");
    TEST(@"b/c",@"/a/",@"/a/");
    TEST(@"a/b/",@"/",@"/a/");
    TEST(@"a/b/.",@"/",@"/a/");
    TEST(@"a/b/c",@"/",@"/a/");
    TEST(@"/a/b/",@"",@"/a/");
    TEST(@"/a/b/.",@"",@"/a/");
    TEST(@"/a/b/c",@"",@"/a/");
    TEST(@"a/b/c",@"",@"/Applications/a/");
#   undef TEST
}
- (void) testCase_isRelativeToURL4iTM3
{
#   define TEST(S1,S2)\
    STAssertTrue([[NSURL fileURLWithPath4iTM3:S1] isRelativeToURL4iTM3:[NSURL fileURLWithPath4iTM3:S2]],@"MISSED",nil)
    TEST(@"/a",@"/");
    TEST(@"a",@"/");
    TEST(@"a",@"/Applications");
    TEST(@"/a/b",@"/");
    TEST(@"/a/b",@"/a");
    TEST(@"/a/b",@"/a/");
    TEST(@"/a/b",@"/a/b");
    TEST(@"/a/b",@"/a/b/");
    TEST(@"a",@"/");
    TEST(@"a",@"/Applications");
    TEST(@"a/b",@"/");
    TEST(@"a/b",@"/Applications");
    TEST(@"a/b",@"/Applications/");
    TEST(@"a/b",@"/Applications/a");
    TEST(@"a/b",@"/Applications/a/");
    TEST(@"/a",@"/c/..");
    TEST(@"a",@"/c/..");
    TEST(@"a",@"/Applications/c/..");
    TEST(@"/a/b",@"/c/..");
    TEST(@"/a/b",@"/a/c/..");
    TEST(@"/a/b",@"/a/c/../");
    TEST(@"/a/b",@"/a/b/c/..");
    TEST(@"a",@"/Applications/c/..");
    TEST(@"a",@"/Applications/c/../");
    TEST(@"a/b",@"/Applications/c/..");
    TEST(@"a/b",@"/Applications/c/../");
    TEST(@"a/b",@"/Applications/a/c/..");
    TEST(@"a/b",@"/Applications/a/c/../");
    TEST(@"a/b/u/..",@"/Applications/a/c/../");
#   undef TEST
#   define TEST(S1,S2)\
    STAssertFalse([[NSURL fileURLWithPath4iTM3:S1] isRelativeToURL4iTM3:[NSURL fileURLWithPath4iTM3:S2]],@"MISSED",nil)
    TEST(@"/a",@"/b");
    TEST(@"a",@"/b");
#   undef TEST
}
- (void) testCase_path4iTM3
{
    STAssertTrue([[NSURL fileURLWithPath4iTM3:@"TextEdit.app"]isEquivalentToURL4iTM3:[NSURL fileURLWithPath4iTM3:@"/Applications/TextEdit.app/"]],@"MISSED",nil);
    STAssertTrue([[NSURL fileURLWithPath4iTM3:@"TextEdit.appx"]isEquivalentToURL4iTM3:[NSURL fileURLWithPath4iTM3:@"/Applications/TextEdit.appx"]],@"MISSED",nil);
    STAssertFalse([[NSURL fileURLWithPath4iTM3:@"TextEdit.appx"]isEquivalentToURL4iTM3:[NSURL fileURLWithPath4iTM3:@"/Applications/TextEdit.appx/"]],@"MISSED",nil);
}
- (void) testCase_pathWithComponents4iTM3
{
#   define TEST(P,Q,...)\
    STAssertEqualObjects(P,([NSString pathWithComponents:[NSArray arrayWithObjects:__VA_ARGS__,nil]]),@"MISSED",nil);\
    STAssertEqualObjects(Q,([NSString pathWithComponents4iTM3:[NSArray arrayWithObjects:__VA_ARGS__,nil]]),@"MISSED",nil)
    TEST(@"",@"",@"");
    TEST(@"/",@"/",@"/");
    TEST(@"/a",@"/a",@"/",@"a");
    TEST(@"/a",@"/a/",@"/",@"a",@"");
    TEST(@"a",@"/a/",@"",@"a",@"");
#   undef TEST
}
- (void) testCase_pathComponents
{
#   define TEST(P,...)\
    STAssertEqualObjects([P pathComponents],([NSArray arrayWithObjects:__VA_ARGS__,nil]),@"MISSED",nil)
    TEST(@"",nil);
    TEST(@"/",@"/");
    TEST(@"/a",@"/",@"a");
    TEST(@"/a/",@"/",@"a",@"/");
#   undef TEST
}
- (void) testCase_pathComponents4iTM3
{
#   define TEST(P,...)\
    STAssertEqualObjects(([[NSURL fileURLWithPath4iTM3:P] pathComponents4iTM3]),([NSArray arrayWithObjects:__VA_ARGS__,nil]),@"MISSED",nil);
    TEST(@"/",@"/");
    TEST(@"/a",@"/",@"a");
    TEST(@"/a/",@"/",@"a",@"/");
    TEST(@"/a/b",@"/",@"a",@"b");
    TEST(@"/a/b/",@"/",@"a",@"b",@"/");
    TEST(@"",@"/",@"Applications",@"/");
    TEST(@".",@"/",@"Applications",@"/");
    TEST(@"..",@"/");
    TEST(nil,nil);
#   undef TEST
#   define TEST(P,...)\
    STAssertTrue(([[NSURL fileURLWithPath4iTM3:P] isEquivalentToURL4iTM3:[NSURL fileURLWithPathComponents4iTM3:[NSArray arrayWithObjects:__VA_ARGS__,nil]]]),@"MISSED",nil);
    TEST(@"/",@"/");
    TEST(@"/a",@"/",@"a");
    TEST(@"/a/",@"/",@"a",@"/");
    TEST(@"/a/b",@"/",@"a",@"b");
    TEST(@"/a/b/",@"/",@"a",@"b",@"/");
    TEST(@"",@"/",@"Applications",@"/");
    TEST(@".",@"/",@"Applications",@"/");
    TEST(@"..",@"/");
    TEST(nil,nil);
#   undef TEST
}
- (void) testCase_URLWithPath4iTM3_relativeToURL
{
//+ (id)URLWithPath4iTM3:(NSString *)path relativeToURL:(NSURL *)baseURL;
#   define TEST(S)\
    STAssertTrue([[NSURL URLWithPath4iTM3:S relativeToURL:nil]isEquivalentToURL4iTM3:[NSURL fileURLWithPath4iTM3:S]],@"MISSED",nil);
    TEST(nil);
    TEST(@"");
    TEST(@"/");
    TEST(@".");
    TEST(@"..");
    TEST(@"/.");
    TEST(@"/..");
    TEST(@"./");
    TEST(@"../");
    TEST(@"a");
    TEST(@"/a");
    TEST(@"./a");
    TEST(@"../a");
    TEST(@"a/");
    TEST(@"a/b");
    TEST(@"a/.");
    TEST(@"a/..");
    TEST(@"a/b/");
    TEST(@"a/./");
    TEST(@"a/../");
#   undef TEST
#   define TEST(S1,S2,S3)\
    STAssertTrue([[NSURL URLWithPath4iTM3:S1 relativeToURL:[NSURL fileURLWithPath4iTM3:S2]]isEquivalentToURL4iTM3:[NSURL fileURLWithPath4iTM3:S3]],@"MISSED",nil);
    TEST(nil,@"/",nil);
    TEST(@"",@"/",@"/");
    TEST(@"/",@"/",@"/");
    TEST(@".",@"/",@"/");
    TEST(@"..",@"/",nil);
    TEST(@"/.",@"/",@"/");
    TEST(@"/..",@"/",nil);
    TEST(@"./",@"/",@"/");
    TEST(@"../",@"/",nil);
    TEST(@"a",@"/",@"/a");
    TEST(@"/a",@"/",@"/a");
    TEST(@"./a",@"/",@"/a");
    TEST(@"../a",@"/",@"/a");
    TEST(@"a/",@"/",@"/a/");
    TEST(@"a/b",@"/",@"/a/b");
    TEST(@"a/.",@"/",@"/a/");
    TEST(@"a/..",@"/",@"/");
    TEST(@"a/b/",@"/",@"/a/b/");
    TEST(@"a/./",@"/",@"/a/");
    TEST(@"a/../",@"/",@"/");
    TEST(nil,@"/c",nil);
    TEST(@"",@"/c",@"/");
    TEST(@"/",@"/c",@"/");
    TEST(@".",@"/c",@"/");
    TEST(@"..",@"/c",nil);
    TEST(@"/.",@"/c",@"/");
    TEST(@"/..",@"/c",nil);
    TEST(@"./",@"/c",@"/");
    TEST(@"../",@"/c",nil);
    TEST(@"a",@"/c",@"/a");
    TEST(@"/a",@"/c",@"/a");
    TEST(@"./a",@"/c",@"/a");
    TEST(@"../a",@"/c",@"/a");
    TEST(@"a/",@"/c",@"/a/");
    TEST(@"a/b",@"/c",@"/a/b");
    TEST(@"a/.",@"/c",@"/a/");
    TEST(@"a/..",@"/c",@"/");
    TEST(@"a/b/",@"/c",@"/a/b/");
    TEST(@"a/./",@"/c",@"/a/");
    TEST(@"a/../",@"/c",@"/");
    TEST(nil,@"/c/",nil);
    TEST(@"",@"/c/",@"/c/");
    TEST(@"/",@"/c/",@"/");
    TEST(@".",@"/c/",@"/c/");
    TEST(@"..",@"/c/",@"/");
    TEST(@"/.",@"/c/",@"/");
    TEST(@"/..",@"/c/",nil);
    TEST(@"./",@"/c/",@"/c/");
    TEST(@"../",@"/c/",@"/");
    TEST(@"a",@"/c/",@"/c/a");
    TEST(@"/a",@"/c/",@"/a");
    TEST(@"./a",@"/c/",@"/c/a");
    TEST(@"../a",@"/c/",@"/a");
    TEST(@"a/",@"/c/",@"/c/a/");
    TEST(@"a/b",@"/c/",@"/c/a/b");
    TEST(@"a/.",@"/c/",@"/c/a/");
    TEST(@"a/..",@"/c/",@"/c/");
    TEST(@"a/b/",@"/c/",@"/c/a/b/");
    TEST(@"a/./",@"/c/",@"/c/a/");
    TEST(@"a/../",@"/c/",@"/c/");
#   undef TEST

}
- (void) testCase_stringByNormalizingPath4iTM3
{
#   define TEST(S1,S2)\
    STAssertEqualObjects([S1 stringByNormalizingPath4iTM3],S2,@"MISSED",nil);
    TEST(@"a",@"a");
    TEST(@"/",@"/");
    TEST(@"/a",@"/a");
    TEST(@"a/",@"a/");
    TEST(@"/a/b",@"/a/b");
    TEST(@"a/b",@"a/b");
    TEST(@"/a/b/",@"/a/b/");
    TEST(@"a/b/",@"a/b/");
    TEST(@"a/./b",@"a/b");
    TEST(@"a/../b",@"b");
    TEST(@"/a/../b",@"/b");
    TEST(@"a/../b/",@"b/");
    TEST(@"/a/../b/",@"/b/");
    TEST(@"..",@"../");
    TEST(@".",@"./");
    TEST(@"../",@"../");
    TEST(@"./",@"./");
    TEST(@"./a",@"a");
    TEST(@"./a/",@"a/");
#   undef TEST
}
- (void) testCase_standardizedURL
{
    STAssertNil([[NSURL URLWithString:@"./.." relativeToURL:[NSURL fileURLWithPath:@"a"]] standardizedURL],@"MISSED",nil);
}
- (void) testCase_URLByDeletingLastPathComponent
{
#   define TEST(S1,S2)\
    STAssertTrue([[[NSURL fileURLWithPath4iTM3:S1] URLByDeletingLastPathComponent] isEquivalentToURL4iTM3:[NSURL fileURLWithPath4iTM3:S2]],@"MISSED",nil);
    TEST(@"a/b",@"a/");
    TEST(@"/a",@"/");
    TEST(@"a/b/",@"a/");
    TEST(@"/a/",@"/");
    TEST(@"/.",nil);
    TEST(@"/..",nil);
#   undef TEST
}
- (void) testCase_stringByAbbreviatingWithDotsRelativeToDirectory4iTM3
{
#   define TEST(S1,S2,P)\
    STAssertEqualObjects([S1 stringByAbbreviatingWithDotsRelativeToDirectory4iTM3:S2],P,@"MISSED",nil);
    TEST(@"/",@"/",@".");
    TEST(@"/a",@"/",@"a");
    TEST(@"/",@"/a",@"..");
#   undef TEST
}
- (void) testCase_pathRelativeToURL4iTM3
{
#   define TEST(S1,S2,P)\
    STAssertEqualObjects([[NSURL fileURLWithPath4iTM3:S1] pathRelativeToURL4iTM3:[NSURL fileURLWithPath4iTM3:S2]],P,@"MISSED\nleft:%@\nright:%@",[[NSURL fileURLWithPath4iTM3:S1] pathRelativeToURL4iTM3:[NSURL fileURLWithPath4iTM3:S2]],P,nil);
    TEST(@"/",@"/",@".");
    TEST(@"a",@"a",@"a");
    TEST(@"/a",@"/a",@"a");
    TEST(@"a/",@"a/",@".");
    TEST(@"/a/",@"/a/",@".");
    TEST(@"a/",@"a",@"a/.");
    TEST(@"/a/",@"/a",@"a/.");
    TEST(@"a/b/",@"a/b",@"b/.");
    TEST(@"/a/b/",@"/a/b",@"b/.");
    TEST(@"a/b/",@"a/b/c",@".");
    TEST(@"/a/b/",@"/a/b/c",@".");
    TEST(@"a/b/",@"a/b/c/",@"..");
    TEST(@"/a/b/",@"/a/b/c/",@"..");
    TEST(@"a/b/d",@"a/b/c/",@"../d");
    TEST(@"/a/b/d",@"/a/b/c/",@"../d");
    TEST(@"a/b/d/",@"a/b/c/",@"../d/.");
    TEST(@"/a/b/d/",@"/a/b/c/",@"../d/.");
#   undef TEST
#   define TEST(S1,S2,P)\
    STAssertEqualObjects([[NSURL fileURLWithPath4iTM3:S1] pathRelativeToURL4iTM3:[NSURL fileURLWithPath4iTM3:S2]],P,@"MISSED",nil);
    TEST(@"/a/b/c",@"/a/",@"b/c");
    TEST(@"/a/b/c",@"/a/foo",@"b/c");
    TEST(@"a/b/c",@"a/",@"b/c");
    TEST(@"a/b/c",@"a/foo",@"b/c");
#   undef TEST
}
- (void) testCase_URLWithPath4iTM3
{
    NSURL * U = [NSURL URLWithString:@"compo%20nent"];
    BIGTEST(U,
        @"compo%20nent",
        @"compo%20nent",
        nil,
        @"compo%20nent",
        nil,
        nil,
        nil,
        nil,
        @"compo nent",
        nil,
        nil,
        nil,
        @"compo nent",
        nil);
    U = [NSURL URLWithString:@"/component"];
    BIGTEST(U,
        @"/component",
        @"/component",
        nil,
        @"/component",
        nil,
        nil,
        nil,
        nil,
        @"/component",
        nil,
        nil,
        nil,
        @"/component",
        nil);
    U = [NSURL URLWithPath4iTM3:@"compo nent" relativeToURL:nil];
    BIGTEST(U,
        @"file://localhost/Applications/compo%20nent",
        @"compo%20nent",
        @"file",
        @"compo%20nent",
        @"localhost",
        nil,
        nil,
        nil,
        @"/Applications/compo nent",
        nil,
        nil,
        nil,
        @"compo nent",
        [NSURL fileURLWithPath4iTM3:@""]);
    U = [NSURL URLWithPath4iTM3:@"/compo nent" relativeToURL:nil];
    BIGTEST(U,
        @"file://localhost/compo%20nent",
        @"file://localhost/compo%20nent",
        @"file",
        @"//localhost/compo%20nent",
        @"localhost",
        nil,
        nil,
        nil,
        @"/compo nent",
        nil,
        nil,
        nil,
        @"/compo nent",
        nil);
    NSURL * u = [NSURL fileURLWithPath:@"/root/subdirectory" isDirectory:YES];
    U = [NSURL URLWithPath4iTM3:@"/root/subdirectory/compo nent" relativeToURL:u];
    BIGTEST(U,
        @"file://localhost/root/subdirectory/compo%20nent",
        @"file://localhost/root/subdirectory/compo%20nent",
        @"file",
        @"//localhost/root/subdirectory/compo%20nent",
        @"localhost",
        nil,
        nil,
        nil,
        @"/root/subdirectory/compo nent",
        nil,
        nil,
        nil,
        @"/root/subdirectory/compo nent",
        nil);
    u = [NSURL fileURLWithPath4iTM3:@"root/"];
    U = [NSURL URLWithPath4iTM3:@"subdirectory/compo nent" relativeToURL:u];
    BIGTEST(U,
        @"file://localhost/Applications/root/subdirectory/compo%20nent",
        @"subdirectory/compo%20nent",
        @"file",
        @"subdirectory/compo%20nent",
        @"localhost",
        nil,
        nil,
        nil,
        @"/Applications/root/subdirectory/compo nent",
        nil,
        nil,
        nil,
        @"subdirectory/compo nent",
        u);
    u = [NSURL fileURLWithPath4iTM3:@"root/X"];
    U = [NSURL URLWithPath4iTM3:@"subdirectory/compo nent/" relativeToURL:u];
    BIGTEST(U,
        @"file://localhost/Applications/root/subdirectory/compo%20nent/",
        @"subdirectory/compo%20nent/",
        @"file",
        @"subdirectory/compo%20nent/",
        @"localhost",
        nil,
        nil,
        nil,
        @"/Applications/root/subdirectory/compo nent",
        nil,
        nil,
        nil,
        @"subdirectory/compo nent",
        u);

}
- (void) XtestCase1
{
    //  testing builtin path related methods of NSURL instances
    //  The problem is to decide whether the directory information is used or not
    NSURL * URL = nil;
    NSURL * url = nil;
    URL = [NSURL fileURLWithPath:@"/Applications" isDirectory:YES];
    #define MEDTEST(U,ABSOLUTE_STRING,RELATIVE_STRING,SCHEME,RESOURCE_SPEC,HOST,PATH,RELATIVE_PATH,BASE_URL)\
    BIGTEST(U,ABSOLUTE_STRING,RELATIVE_STRING,SCHEME,RESOURCE_SPEC,HOST,nil,nil,nil,PATH,nil,nil,nil,RELATIVE_PATH,BASE_URL)
	MEDTEST(URL,
        @"file://localhost/Applications/",
        @"file://localhost/Applications/",
        @"file",
        @"//localhost/Applications/",
        @"localhost",
        @"/Applications",
        @"/Applications",
        nil);
    url = [NSURL URLWithString:@"TextEdit.app" relativeToURL:URL];
	MEDTEST(url,
        @"file://localhost/Applications/TextEdit.app",
        @"TextEdit.app",
        @"file",
        @"TextEdit.app",
        @"localhost",
        @"/Applications/TextEdit.app",
        @"TextEdit.app",
        URL);
    //  Now test with other options
    URL = [NSURL fileURLWithPath:@"/Applications"];
	MEDTEST(URL,
        @"file://localhost/Applications/",
        @"file://localhost/Applications/",
        @"file",
        @"//localhost/Applications/",
        @"localhost",
        @"/Applications",
        @"/Applications",
        nil);
    
    URL = [NSURL fileURLWithPath:@"/Applications"];
    url = [URL URLByAppendingPathComponent:@"TextEdit.app"];
	MEDTEST(url,
        @"file://localhost/Applications/TextEdit.app/",
        @"file://localhost/Applications/TextEdit.app/",
        @"file",
        @"//localhost/Applications/TextEdit.app/",
        @"localhost",
        @"/Applications/TextEdit.app",
        @"/Applications/TextEdit.app",
        nil);
    //  Now we are adding a component for an unexisting location
    //  The file manager does not know if this is a file or a folder
    //  (it can be anyone of them)
    //  By default it says it is a file
    url = [URL URLByAppendingPathComponent:@"TextEdit"];
	MEDTEST(url,
        @"file://localhost/Applications/TextEdit",
        @"file://localhost/Applications/TextEdit",
        @"file",
        @"//localhost/Applications/TextEdit",
        @"localhost",
        @"/Applications/TextEdit",
        @"/Applications/TextEdit",
        nil);
    url = [url URLByAppendingPathComponent:@"component"];
	MEDTEST(url,
        @"file://localhost/Applications/TextEdit/component",
        @"file://localhost/Applications/TextEdit/component",
        @"file",
        @"//localhost/Applications/TextEdit/component",
        @"localhost",
        @"/Applications/TextEdit/component",
        @"/Applications/TextEdit/component",
        nil);
    //  Testing URLByAppendingPathComponent with relative URLs
    URL = [NSURL fileURLWithPath:@"/Applications"];
    url = [NSURL URLWithString:@"TextEdit.app" relativeToURL:URL];
	MEDTEST(url,
        @"file://localhost/Applications/TextEdit.app",
        @"TextEdit.app",
        @"file",
        @"TextEdit.app",
        @"localhost",
        @"/Applications/TextEdit.app",
        @"TextEdit.app",
        URL);
    //  Testing URLByAppendingPathComponent with relative URLs
    url = [url URLByAppendingPathComponent:@"Contents"];
	MEDTEST(url,
        @"file://localhost/Applications/TextEdit.app/Contents",
        @"TextEdit.app/Contents",
        @"file",
        @"TextEdit.app/Contents",
        @"localhost",
        @"/Applications/TextEdit.app/Contents",
        @"TextEdit.app/Contents",
        URL);
    //  Testing creation methods with doubly relative URLs
    //  It seems that the base URL is always an absolute URL
    NSURL * u;
    u = [NSURL URLWithString:@"subdirectory" relativeToURL:url];
	MEDTEST(u,
        @"file://localhost/Applications/TextEdit.app/subdirectory",
        @"subdirectory",
        @"file",
        @"subdirectory",
        @"localhost",
        @"/Applications/TextEdit.app/subdirectory",
        @"subdirectory",
        url);
   
}
- (void) XtestCase2
{
    //  testing path4iTM3
    //  against the url of a directory
    NSArray * RA = NSSearchPathForDirectoriesInDomains(NSUserDirectory, NSAllDomainsMask, NO);
    STAssertTrue(RA.count>ZER0,@"MISSED",nil);
    NSString * path = [RA objectAtIndex:ZER0];
    NSURL * URL = [NSURL fileURLWithPath:path];
    STAssertEqualObjects(path,URL.path,@"MISSED",nil);
    STAssertEqualObjects([path stringByAppendingString:iTM2PathComponentsSeparator],URL.path4iTM3,@"MISSED",nil);
    //  against the url of something else
    path = [path stringByAppendingPathComponent:@"..."];
    URL = [NSURL fileURLWithPath:path];
    STAssertEqualObjects(path,URL.path,@"MISSED",nil);
    STAssertEqualObjects(path,URL.path4iTM3,@"MISSED",nil);
}

@end

