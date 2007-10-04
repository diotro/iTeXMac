# this is iTM2_Engine_TeX.rb for iTeXMac2 2.0
# © 2007 jlaurens AT users DOT sourceforge DOT net
# This is a pdfeTeX 3.141592-1.20a-2.2 (Web2C 7.5.3) wrapper
# the purpose of this script is to create a shell script for iTM2_Command_Compile.rb

$engine = "pdftex"

class Launcher
	
	def command_arguments
		args=" "
		if ( config('iTM2_TeX_ini') != "0" )
			args="-ini "
			if ( config('iTM2_TeX_enc') != "0" )
					args = args + "-enc "
			end
			if ( config('iTM2_TeX_mltex') != "0" )
					args = args + "-mltex "
			end
		end
		if ( config('iTM2_TeX_USE_out_directory') != "0" and config('iTM2_TeX_out_directory').length > 0 )
			args = args + "-out-directory \"#{config('iTM2_TeX_out_directory')}\" "
		elsif ( config('iTM2_USE_out_directory') != "0" and config('iTM2_out_directory').length > 0 )
			args = args + "-out-directory \"#{config('iTM2_out_directory')}\" "
		end
		@format=config('iTM2_TeX_fmt')
		if(@format)
			@format = @format.downcase
		else
			@format = "plain"
		end
		if ( config('iTM2_TeX_parse_first_line') != "0" )
			args = args + "-parse-first-line "
			if ( config('iTM2_TeX_USE_translate_file') != "0" and config('iTM2_TeX_translate_file').length > 0 )
				if ( config('iTM2_TeX_PARSE_translate_file') != "0" )
					args = args + "-default-translate-file "
				else
					args = args + "-translate-file "
				end
				args = args + "\"#{config('iTM2_TeX_translate_file')}\" "
			end
			if ( config('iTM2_TeX_USE_progname') != "0" and config('iTM2_TeX_progname').length > 0 )
					args = args + "-progname #{config('iTM2_TeX_progname')} "
			end
		else
			if ( config('iTM2_TeX_USE_progname') != "0" and config('iTM2_TeX_progname').length > 0 )
				args = args + "-progname #{config('iTM2_TeX_progname')} "
				args = args + "-fmt #{@format} "
			elsif ( @format == "plain" )
				args = args + "-progname tex "
			else
				args = args + "-progname #{@format} "
			end
			if ( config('iTM2_TeX_USE_translate_file') != "0" and config('iTM2_TeX_translate_file').length > 0 )
					args = args + "-translate-file \"#{config('iTM2_TeX_translate_file')}\" "
			end
		end
		if ( config('iTM2_TeX_recorder') != "0" )
			args = args + "-recorder "
		end
		if ( config('iTM2_TeX_file_line_error') != "0" )
			args = args + "-file-line-error "
		end
		if ( config('iTM2_TeX_halt_on_error') != "0" )
			args = args + "-halt-on-error "
		elsif ( config('iTM2_ContinuousCompile') != "0" )
			args = args + "-halt-on-error "
		end
		if (config('iTM2_TeX_kpathsea_debug') != "0" )
			notify("error","-kpathsea-debug no yet supported.")
		end
		if ( config('iTM2_TeX_interaction') != "0" and config('iTM2_ContinuousCompile') != "0" )
			args = args + "-interaction #{config('iTM2_TeX_interaction')} "
		end
		if ( config('iTM2_TeX_USE_MoreArgument') != "0" and config('iTM2_TeX_MoreArgument').length > 0 )
			args = args + "#{config('iTM2_TeX_MoreArgument')} "
		end
		if ( config('iTM2_AllTeX_shell_escape') != "0" )
			args = args + "-shell-escape "
		else
			args = args + "-no-shell-escape "
		end
		@job = ""
		if ( config('iTM2_TeX_USE_jobname') != "0" and config('iTM2_TeX_jobname').length > 0 )
			@job = config('iTM2_TeX_jobname')
			args = args + "-jobname \"#{@job}\" "
		else
			@job = @master_pathname.to_s.gsub(/(.*)\..*/,'\1')
		end
		args
	end
	
	def setup_engine
		frenchpro = ""
		if ( /^fr/ =~ @format )
			frenchpro=`which FrenchPro`
			if ( ! FileTest.executable?(frenchpro) )
				itexmac2_error("FrenchPro is not available, install FrenchPro or change the #{project_pathname.basename.to_s} settings.")
				frenchpro=""
			end
		end
		command = ""
		args = self.command_arguments
		if ( frenchpro.length > 0 )
			command = "/bin/sh -c #{frenchpro} #{$engine} #{args} \"#{@master_pathname.to_s}\""
		else
			command = "#{$engine} #{args} \"#{@master_pathname.to_s}\""
		end
		notify("comment","Performing #{command}")
		@dviout=@job+".dvi"
		if ( FileTest.symlink?(@pdfout) )
			File.delete(@pdfout)
		end
		@srcdvi = @contents_pathname+@pdfout
		@srcpdf = @srcpdf.to_s
		@aux = @job+'.aux'
		@log = @job+'.log'
		# opening the script file:
		@engine = <<EOF
#!/usr/bin/env ruby
# this is a one shot script, you might remove it safely, iTeXMac2 would recreate it on demand
$me = File.basename($0)
puts "\#{$me} entrance: %.2f" % Time.now.to_f
require 'fileutils'
def notify(type,msg)
	system("iTeXMac2","notify",type,msg)
end
$pwd = "#{Pathname.pwd.to_s}"
Dir.chdir($pwd)
$src = "#{@contents_pathname.to_s}"
$project = "#{@project_pathname.to_s}"
ENV['PATH'] = "#{ENV['PATH']}"
$job = "#{@job}"
$pdfout = "#{@pdfout}"
$pdfsync = "#{@pdfsync}"
$srcpdf = "#{@srcpdf}"
if ( FileTest.exist?($pdfout) )
	File.delete($pdfout)
end
if ( FileTest.exist?($pdfsync) )
	File.delete($pdfsync)
end
command = "#{command.gsub(/"/,'\"')}"
notify("comment","Performing \#{command}")
if ( system(command) )
	puts "\#{$me} %.2f" % Time.now.to_f
EOF
		if ( config('iTM2_TeX_out_format') == "dvi" ) # no external viewer supported...
			@engine <<= <<EOF
	master = "#{$pwd+'/'+@job}".gsub(/"/,'\"')#"
	notify("comment","Swicthing to a dvi to ps or pdf filter for "+master)
	dvi = File.dirname(master)+'/'+File.basename(master,File.extname(master))+'.dvi'
	if ( ! system("#{$0}",'Compile',$project,dvi) )
		notify("error","Helper iTM2_Engine_TeX FAILED(#{$?}).")
		exit $?
	end
EOF
		end # if ( config('iTM2_TeX_out_format'...
		@engine <<= <<EOF
	if ( Kernel.test(?s,$pdfout) )
EOF
		if ( @contents_pathname.writable? )
			@engine <<= <<EOF
		if(FileTest.exist?($srcpdf))
			FileUtils.rm_f($srcpdf)
		end
		FileUtils.mv($pdfout,$src,:force => true)
		system("iTeXMac2","update","-file",$srcpdf,"-project",$project)
EOF
		else
			@engine <<= <<EOF
system("iTeXMac2","update","-file",$pwd+'/'+$pdfout,"-project",$project)
EOF
		end
		@engine <<= <<EOF
	else
		system("iTeXMac2","markerror","-file",$srcpdf,"-project",$project)
		$aux = "#{@aux}"
		if ( Kernel.test(?s,$aux) )
			FileUtils.rm($aux,:force => true)
		end
		if ( FileTest.exist?($pdfout) )
			FileUtils.rm($pdfout,:force => true)
		end
	end
	$log = "#{@log}"
	if ( Kernel.test(?s,$log) )
		system("iTeXMac2","log","-file",$log,"-project",$project,"-dont-order-front")
	end
EOF
		if ( config('iTM2_Debug') != "0" )
			@engine <<= <<EOF
	notify("comment","#{$me} complete.")
EOF
		end
		@engine <<= <<EOF
	puts "\#{$me} exit: %.2f" % Time.now.to_f
	exit 0
else
	notify("error","#{$me} FAILED(#{$?}).")
	puts "\#{$me} exit: %.2f" % Time.now.to_f
	exit $?
end
EOF
	end
	
end
$launcher.setup_engine


$engine = "pdftex"

iTM2_TeX_Engine_Version=1.1
iTM2TeXEngineUsage()
{
iTM2_USAGE="Welcome to $(basename "$0") version ${iTM2_TeX_Engine_Version}
This is iTeXMac2 built in script to wrap the tex engine
($(which tex))
© 2006 jlaurens AT users DOT sourceforge DOT net
Usage: $(basename "$0") with environment variables
	TWSMaster: the main input file (actually \"${TWSMaster}\")
	TWSProject: the project file, if any, full path, unused
	TWSWrapper: the wrapper file, if any, full path, unused
	iTM2_USE_output_directory: 1 or void (common)
	iTM2_output_directory: the common output directory
	iTM2_TeX_ini: 1 or void, be initex, for dumping formats
	iTM2_TeX_mltex: 1 or void, enable MLTeX extensions such as \charsubdef
	iTM2_TeX_enc: 1 or void,
	iTM2_TeX_MoreArgument:
	iTM2_TeX_mktex: 1 or void,
	iTM2_TeX_USE_output_directory: 1 or void
	iTM2_TeX_output_directory:
	iTM2_TeX_fmt: = FMTNAME, use the value instead of program name or a %& line
	iTM2_TeX_parse_first_line: 1 or void, parse of the first line of the input file
	iTM2_TeX_USE_progname: 1 or void,
	iTM2_TeX_progname: = STRING, set program (and fmt) name to STRING
	iTM2_TeX_USE_jobname: 1 or void,
	iTM2_TeX_jobname: = STRING, set the job name to STRING
	iTM2_AllTeX_shell_escape: 1 or void, enable \write18{SHELL COMMAND}
	iTM2_TeX_src_specials: 1 or void, insert source specials into the DVI file
	iTM2_TeX_src_specials_where_no_cr: 1 or void,
	iTM2_TeX_src_specials_where_no_display: 1 or void,
	iTM2_TeX_src_specials_where_no_hbox: 1 or void,
	iTM2_TeX_src_specials_where_no_parent: 1 or void,
	iTM2_TeX_src_specials_where_no_par: 1 or void,
	iTM2_TeX_src_specials_where_no_math: 1 or void,
	iTM2_TeX_src_specials_where_no_vbox: 1 or void,
	iTM2_TeX_USE_output_comment: 1 or void,
	iTM2_TeX_output_comment:
	iTM2_TeX_USE_translate_file: 1 or void,
	iTM2_TeX_translate_file := TCXNAME, use the TCX file TCXNAME
	iTM2_TeX_PARSE_translate_file: 1 or void,
	iTM2_TeX_recorder: 1 or void, enable filename recorder
	iTM2_TeX_file_line_error: 1 or void, print file:line:error style messages
	iTM2_TeX_halt_on_error: 1 or void,
	iTM2_TeX_interaction: batchmode/nonstopmode/scrollmode/errorstopmode, set interaction mode
	iTM2_TeX_kpathsea_debug:
	iTM2_TeX_MoreArgument: more arguments"
	echo "$iTM2_USAGE"
}
"${iTM2_CMD_Notify}" notify comment "Welcome to $(basename "$0") version ${iTM2_TeX_Engine_Version}
This is iTeXMac2 built in script to wrap the tex engine
© 2006 jlaurens AT users DOT sourceforge DOT net"
if [ "${iTM2_Debug}" != "0" ]
then
	"${iTM2_CMD_Notify}" notify start comment
	"${iTM2_CMD_Notify}" notify echo "The $0 specific environment is:"
	for iTM2VAR in ${!iTM2_TeX_*}
	do
		"${iTM2_CMD_Notify}" notify echo "${iTM2VAR} is: ${!iTM2VAR}"
	done
	"${iTM2_CMD_Notify}" notify stop comment
fi
# the engine part

iTM2_TeX_Engine="tex"
iTM2_TeX_EnginePath="$(which "${iTM2_TeX_Engine}")"
if ! [ -x "${iTM2_TeX_EnginePath}" ]
then
	"${iTM2_CMD_Notify}" notify error "Unknown command ${iTM2_TeX_Engine}."
	iTM2TeXEngineUsage
	exit 1
fi



if [ "${iTM2_TeX_USE_output_directory:-0}" != "0" ] && [ ${#iTM2_TeX_output_directory} -ne 0 ]
then
	iTM2_TeX_Arguments="${iTM2_TeX_Arguments} -output-directory \"${iTM2_TeX_output_directory}\""
elif [ "${iTM2_USE_output_directory:-0}" != "0" ] && [ ${#iTM2_output_directory} -ne 0 ]
then
	iTM2_TeX_Arguments="${iTM2_TeX_Arguments} -output-directory \"${iTM2_output_directory}\""
fi



# the file name part
TWSMasterBase="$(basename "${TWSMaster}")"
EXTENSION="${TWSMasterBase##*.}"
if [ ${#EXTENSION} -ne 0 ]
then
	EXTENSION="$(echo "${EXTENSION}" | tr [:upper:] [:lower:])"
	if [ "${EXTENSION}" != "tex" ] && [ "${EXTENSION}" != "dtx" ] && [ "${EXTENSION}" != "ins" ] && [ "${EXTENSION}" != "ltx" ]
	then
		TWSMaster="${TWSMaster%.*}.tex"
	fi
fi
if ! [ -r "${TWSMaster}" ]
then
	"${iTM2_CMD_Notify}" notify error "No readable file at ${TWSMaster} (in $(pwd))."
	iTM2TeXEngineUsage
	exit 2
fi
if [ "${iTM2_TeX_USE_jobname:-0}" != "0" ] && [ ${#iTM2_TeX_jobname} -ne 0 ]
then
	iTM2_TeX_Arguments="${iTM2_TeX_Arguments} -jobname \"${iTM2_TeX_jobname}\""
	OUTPUT="${iTM2_TeX_jobname}"
else
	OUTPUT="${TWSMasterBase%.*}"
fi
pushd "${iTM2_PWD}"
iTM2_DOT_PDFSYNC="${TWSMasterBase%.*}.pdfsync"
if [ -f "${iTM2_DOT_PDFSYNC}" ]
then
	rm -f "${iTM2_DOT_PDFSYNC}"
fi
if [ "${iTM2_TeX_fmt:0:2}" == "fr" ]
then
	iTM2_Preparator="$(which FrenchPro)"
	if [ ${#iTM2_Preparator} -eq 0 ]
	then
		iTeXMac2 error -project "${TWSProject}" -reason "FrenchPro is not available, install FrenchPro or change the project settings."
	fi
fi
if [ ${#iTM2_Preparator} -gt 0 ]
then
	/bin/sh -c "\"${iTM2_Preparator}\" \"${iTM2_TeX_EnginePath}\" ${iTM2_TeX_Arguments} \"${TWSMasterBase}\""
else
	/bin/sh -c "\"${iTM2_TeX_EnginePath}\" ${iTM2_TeX_Arguments} \"${TWSMasterBase}\""
fi
"${iTM2_CMD_Notify}" notify comment "Performing ${iTM2_Preparator} ${iTM2_TeX_EnginePath} ${iTM2_TeX_Arguments} \"${TARGET}\""
"${iTM2_TeX_EnginePath}" ${iTM2_TeX_Arguments} "${TWSMasterBase}"
iTM2_Status="$?"
if [ "${iTM2_Status}" != "0" ]
then
	popd
	"${iTM2_CMD_Notify}" notify error "$0 FAILED(${iTM2_Status})."
	exit ${iTM2_Status}
fi
PDFOUTPUT="${OUTPUT%.*}.pdf"
if [ -L "${PDFOUTPUT}" ]
then	
	rm -f "${PDFOUTPUT}"
fi
iTM2_Command_Compile --master "${iTM2_PWD}/${OUTPUT%.*}" --switch dvi
iTM2_Status="$?"
if [ "${iTM2ExportOutput:-0}" != "0" ]
then
	OUTPUT="${OUTPUT%.*}.ps"
	if [ -s "${OUTPUT}" ]
	then	
		if [ ${#iTM2_PWD_Real} -lt ${#iTM2_PWD} ] && [ -w "${iTM2_PWD_Real}" ]
		then
			mv -f "${OUTPUT}" "${iTM2_PWD_Real}"
		fi
	else
		iTeXMac2 markerror -file "${iTM2_PWD_Real}/${OUTPUT}" -project "${TWSProject}"
	fi
fi
if [ -s "${PDFOUTPUT}" ]
then	
	if [ ${#iTM2_PWD_Real} -lt ${#iTM2_PWD} ] && [ -w "${iTM2_PWD_Real}" ]
	then
		mv -f "${PDFOUTPUT}" "${iTM2_PWD_Real}"
	fi
	iTeXMac2 update -file "${iTM2_PWD_Real}/${PDFOUTPUT}" -project "${TWSProject}"
else
	iTeXMac2 markerror -file "${iTM2_PWD_Real}/${PDFOUTPUT}" -project "${TWSProject}"
	OUTPUT="${OUTPUT%.*}.aux"
	if [ -s "${OUTPUT}" ]
	then
		rm -f "${OUTPUT}"
	fi
	OUTPUT="${OUTPUT%.*}.out"
	if [ -s "${OUTPUT}" ]
	then
		rm -f "${OUTPUT}"
	fi
fi
OUTPUT="${OUTPUT%.*}.log"
if [ -s "${OUTPUT}" ]
then	
	iTeXMac2 log -file "${iTM2_PWD}/${OUTPUT}" -project "${TWSProject}" -dont-order-front
fi
if [ "${iTM2_Status}" != "0" ]
then
	"${iTM2_CMD_Notify}" notify error "$0 FAILED(${iTM2_Status})."
	popd
	exit ${iTM2_Status}
elif [ "${iTM2_Debug}" != "0" ]
then
	"${iTM2_CMD_Notify}" notify comment "$0 complete."
fi
popd
exit
