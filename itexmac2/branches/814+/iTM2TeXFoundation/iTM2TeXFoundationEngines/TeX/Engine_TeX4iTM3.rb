#!/usr/bin/env ruby
# this is Engine_TeX4iTM3.rb for iTeXMac2 2.0
# © 2007 jlaurens AT users DOT sourceforge DOT net
# This is a pdfeTeX 3.141592-1.20a-2.2 (Web2C 7.5.3) wrapper
# the purpose of this script is to create a shell script for iTM2_Command_Compile.rb

require 'Engine_PDFTeX4iTM3'

class TeXWrapper < PDFTeXWrapper

	def options
		opts=" "
		if _ini.yes?
			opts="-ini "
			opts << "-enc " if _enc.yes?
			opts << "-mltex " if _mltex.yes?
		end
		if _USE_out_directory.yes? and _out_directory.length?
			opts << "-out-directory \"#{_out_directory}\" "
		elsif _iTM2_USE_out_directory.yes? and _iTM2_out_directory.length?
			opts << "-out-directory \"#{_iTM2_out_directory}\" "
		end
		@format = _fmt('plain').downcase
		if _PARSE_first_line.yes?
			opts << "-parse-first-line "
			if _USE_translate_file.yes? and _translate_file.length?
				if _PARSE_translate_file.yes?
					opts << "-default-translate-file "
				else
					opts << "-translate-file "
				end
				opts << "\"#{_translate_file}\" "
			end
			if _USE_progname.yes? and _progname.length?
					opts << "-progname #{_progname} "
			end
		else
			if _USE_progname.yes? and _progname.length?
				opts << "-progname #{_progname} "
				opts << "-fmt #{@format} "
			elsif @format == "plain"
				opts << "-progname tex "
			else
				opts << "-progname #{@format} "
			end
			if _USE_translate_file.yes? and _translate_file.length?
					opts << "-translate-file \"#{_translate_file}\" "
			end
		end
		if _recorder.yes?
			opts << "-recorder "
		end
		if _file_line_error.yes?
			opts << "-file-line-error "
		end
		if _halt_on_error.yes?
			opts << "-halt-on-error "
		elsif _iTM2_ContinuousCompile.yes?
			opts << "-halt-on-error "
		end
		notify("error","-kpathsea-debug no yet supported.") if _kpathsea_debug.yes?
		opts << "-interaction #{_interaction} " if _interaction.yes? and _iTM2_ContinuousCompile.yes?
		opts << "#{_MoreArgument} " if _USE_MoreArgument.yes? and _MoreArgument.length?
		opts << ((_iTM2_AllTeX_shell_escape.yes?)?("-shell-escape "):("-no-shell-escape "))
		if _USE_jobname.yes? and _jobname.length?
			@job = jobname
			opts << "-jobname \"#{@job}\" "
		end
		opts
	end
	
							def engine_shortcut
								if /^fr/ =~ @format
									if FileTest.executable?(`which FrenchPro`.chomp)
										frenchpro = true
									else
										bail("FrenchPro is not available, install FrenchPro or change the #{project_pathname.basename.to_s} settings.")
									end
								end
								bail("tex is not available, please install a TeX distribution.") if ! FileTest.executable?(`which tex`.chomp)
								opts = options # here for the side effects
								@job = project.job_name.to_s if @job.nil?
								# opening the script file:
puts "!"
print @job
								engine_shortcut = <<EOF
$job = "#{@job}"
$dviout = "#{@job+'.dvi'}"
FileUtils.rm_f($dviout) if FileTest.symlink?($dviout)
$sync = "#{@job+'.sync'}"
File.delete($sync) if FileTest.exist?($sync)
$verb = "#{((frenchpro.yes?)?('/bin/sh -c frenchpro tex '):('tex '))}"
$options = "#{options}"
$command = $verb+$options+'"'+$master+'"'
$pretty_command = $command.gsub(/"/,'\"')
notify("comment","Performing \#{$pretty_command}")
if ! system($command)
	notify("error","#{$me} FAILED(#{$?}).")
	exit $?
elsif !ENV.key?('TWS_draft_mode') or ENV['TWS_draft_mode'] == '0'
	master = $pwd+'/'+$job.gsub(/"/,'\"')
	notify("comment","Switching to a dvi to ps or pdf filter for "+master)
	if ! Kernel.test(?s,$dviout)
		system("iTeXMac2","markerror","-file",$dviout,"-project",$project)
		$aux = "#{@aux}"
		FileUtils.rm($aux,:force => true) if Kernel.test(?s,$aux)
		FileUtils.rm($dviout,:force => true) if FileTest.exist?($dviout)
		notify("error","Command FAILED: no dvi avalable.")
		exit $?
	elsif ! system("#{$0}",'-a','Compile','-p',$project,'-m',$dviout)
		notify("error","Helper #{me} FAILED(#{$?}).")
		exit $?
	elsif Kernel.test(?s,$log)
		$log = "#{@log}"
		system("iTeXMac2","log","-file",$log,"-project",$project,"-dont-order-front")
	end
end
EOF
								engine_shortcut
							end
	
end
bail("TeX original engine is no longer supported by iTeXMac2")
$launcher.engine_wrapper = TeXWrapper.new
