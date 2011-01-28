#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys, os, os.path, re, io

def main():
    if len(sys.argv)!=3:
        sys.exit("One parameter exactly needed");
    frmwk_src_path = sys.argv[1]
    test_dir = sys.argv[2]
    frmk_name = os.path.basename(frmwk_src_path)
    if len(frmk_name) == 0:
        frmk_name = os.path.basename(os.path.dirname(frmwk_src_path))
        if len(frmk_name) == 0:
            sys.exit("Bad 1st parameter");
    path = os.path.join(sys.argv[2],frmk_name)
    if not os.path.exists(path):
        os.makedirs(path)
    testCases = []
    testCaseInvocations = []
    for root, subFolders, files in os.walk(frmwk_src_path):
        for file in files:
            candidate = os.path.join(root,file)
            if re.match(".*iTM2.*\\.m$",candidate) and not re.search("iTM2.*test",candidate,re.I) and not re.search("/Archive/",candidate,re.I):
                headers = []
                setups = []
                teardowns = []
                tests = []
                f = open(candidate, "r")
                lines = f.readlines()
                #print "#warning CANDIDATE:"+candidate
                n = 0
                c = 0
                __CODE_TAG__ = "NONE"
                depth = 0
                while len(lines)>0:
                    c = c+1
                    line = lines.pop(0)
                    if re.match("#\\s*if\\s*0",line):
                        depth = depth + 1;
                        #print "#warning <<< %i, line %i" %(depth,c)
                    elif depth>0:
                        if re.match("#\\s*endif",line):
                            depth = depth - 1
                            #print "#warning >>> %i, line %i"%(depth,c)
                        elif re.match("#\\s*if",line):
                            depth = depth+1
                            #print "#warning <<<<<< %i, line %i" %(depth,c)
                    elif re.match("#\\s*ifdef\\s*__EMBEDDED_TEST_HEADER__",line):
                        while len(lines)>0:
                            c = c+1
                            line = lines.pop(0)
                            headers.append(line)
                            if re.match("#\\s*if",line):
                                depth = depth + 1;
                            elif re.match("#\\s*endif",line):
                                if depth > 0:
                                    depth = depth-1
                                else:
                                    headers.pop(-1)
                                    break
                    elif re.match("#\\s*ifdef\\s*__EMBEDDED_TEST_SETUP__",line):
                        while len(lines)>0:
                            c = c+1
                            line = lines.pop(0)
                            setups.append(line)
                            if re.match("#\\s*if",line):
                                depth = depth + 1;
                            elif re.match("#\\s*endif",line):
                                if depth > 0:
                                    depth = depth-1
                                else:
                                    setups.pop(-1)
                                    break
                    elif re.match("#\\s*ifdef\\s*__EMBEDDED_TEST_TEARDOWN__",line):
                        while len(lines)>0:
                            c = c+1
                            line = lines.pop(0)
                            teardowns.append(line)
                            if re.match("#\\s*if",line):
                                depth = depth + 1;
                            elif re.match("#\\s*endif",line):
                                if depth > 0:
                                    depth = depth-1
                                else:
                                    teardowns.pop(-1)
                                    break
                    elif re.match("#\\s*ifdef\\s*__EMBEDDED_TEST_BEGIN__",line):
                        n = n+1
                        tests.append("-(void)testCase_%i;\n{\n"%n)
                        tests.append("\tNSString * __CODE_TAG__ = %s;"%__CODE_TAG__)
                        while len(lines)>0:
                            line = lines.pop(0)
                            c = c+1
                            tests.append(line)
                            if re.match("#\\s*if",line):
                                depth = depth + 1;
                            elif re.match("#\\s*endif",line):
                                if depth > 0:
                                    depth = depth-1
                                else:
                                    tests.pop(-1)
                                    break
                    elif re.match("#\\s*ifdef\\s*__EMBEDDED_TEST_CONTINUE__",line):
                        while len(lines)>0:
                            line = lines.pop(0)
                            c = c+1
                            tests.append(line)
                            if re.match("#\\s*if",line):
                                depth = depth + 1;
                            elif re.match("#\\s*endif",line):
                                if depth > 0:
                                    depth = depth-1
                                else:
                                    tests.pop(-1)
                                    break
                    elif re.match("#\\s*ifdef\\s*__EMBEDDED_TEST_END__",line):
                        while len(lines)>0:
                            c = c+1
                            line = lines.pop(0)
                            tests.append(line)
                            if re.match("#\\s*if",line):
                                depth = depth + 1;
                            elif re.match("#\\s*endif",line):
                                if depth > 0:
                                    depth = depth-1
                                else:
                                    tests.pop(-1)
                                    break
                        tests.append("}\n")
                    elif re.match("#\\s*ifdef\\s*__EMBEDDED_TEST__",line):
                        n = n+1
                        tests.append("-(void)testCase_%i;\n{\n"%n)
                        tests.append("\tNSString * __CODE_TAG__ = %s;\n"%__CODE_TAG__)
                        while len(lines)>0:
                            c = c+1
                            line = lines.pop(0)
                            tests.append(line)
                            if re.match("#\\s*if",line):
                                depth = depth + 1;
                            elif re.match("#\\s*endif",line):
                                if depth > 0:
                                    depth = depth-1
                                else:
                                    tests.pop(-1)
                                    break
                        tests.append("}\n")
                    else:
                        m = re.search("ReachCode4iTM3\\s*\\(\\s*(@\".*?\")\\s*\\)",line)
                        if m:
                            __CODE_TAG__ = m.group(1)
                        else:
                            m = re.search("ReachCode4iTM3\\s*\\(\\s*(REACH_CODE_ARGS.*?\\s*\\(\\s*@\".*?\"\\s*\\))\\s*\\)",line)
                            if m:
                                __CODE_TAG__ = m.group(1)

                f.close()
                if len(setups):
                    setups.insert(0,"-(void)setUp;\n{\n")
                    setups.append("}\n")
                if len(teardowns):
                    teardowns.insert(0,"-(void)tearDown;\n{\n")
                    teardowns.append("}\n")

                setups.extend(teardowns)
                setups.extend(tests)
                if len(setups):
                    class_name = "%sTestCases"%os.path.splitext(file)[0];
                    setups.insert(0,"\n@implementation %s\n"%class_name)
                    setups.append("@end\n")
                    setups.insert(0,"#import \"iTM3SenTestKit.h\"\n@interface %s : SenTestCase {\n}\n@end\n"%class_name)
                    if len(headers):
                        testCases.insert(0,"\n".join(headers))
                    setups.insert(0,"//This file was generated automatically by the 'Prepare Embedded Tests' build phase.\n")
                    try:
                        # This will create a new file or **overwrite an existing file**.
                        f = open(os.path.join(test_dir,os.path.join(frmk_name,class_name+".m")), "w")
                        try:
                            f.writelines(setups) # Write a sequence of strings to a file
                        finally:
                            f.close()
                    except IOError:
                        sys.exit("I/O error (1)")
                    testCases.append("#import \"%s/%s.m\""%(frmk_name,class_name))
                    testCaseInvocations.append("    [[[%s alloc] init] invokeTest];"%class_name)
    if len(testCases):
        testCases.append("#warning %s\nvoid invoke_%s_testCases(void);\nvoid invoke_%s_testCases(void) {"%(frmk_name,frmk_name,frmk_name))
        testCases.extend(testCaseInvocations)
        testCases.append("}")
        testCases.insert(0,"//This file was generated automatically by the 'Prepare Embedded Tests' build phase.")
        try:
            f = open(os.path.join(test_dir,"%sTestCases.m"%frmk_name), "w")
            try:
                f.write("\n".join(testCases))
            finally:
                f.close()
        except IOError:
            sys.exit("I/O error (2)")
    
if __name__ == "__main__":
    sys.exit(main())
