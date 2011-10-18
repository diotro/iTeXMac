# this is iTM2_Engine_PDFTeX.rb for iTeXMac2 2.0
# © 2007 jlaurens AT users DOT sourceforge DOT net
# This is a pdfeTeX 3.141592-1.20a-2.2 (Web2C 7.5.3) wrapper
# the purpose of this script is to create a shell script for iTM2_Command_Compile.rb

require 'iTM2_Engine_PDFTeX'

$engine = "xetex"

class XeTeXWrapper<PDFTeXWrapper
	
	def key_prefix
		'iTM2_XeTeX_'
	end

	def options
		opts=" "
		if _ini.yes?
			opts << "-ini "
			opts << "-enc " if _enc.yes?
			opts << "-mltex " if _mltex.yes?
		end
		opts << "-jobname=\"#{_jobname}\" " if _USE_jobname.yes? and _jobname.length?
		if _USE_output_directory.yes? and _output_directory.length?
			opts << "-output-directory=\"#{_output_directory}\" "
		elsif _iTM2_USE_output_directory.yes? and _iTM2_output_directory.length?
			opts << "-output-directory=\"#{_iTM2_output_directory}\" "
		end
		@format = _fmt('plain').downcase
		if _PARSE_first_line.yes?
			opts << "-parse-first-line "
			if _USE_translate_file.yes? and _translate_file.length?
				opts <<((_PARSE_translate_file.yes?)?("-default-translate-file"):("-translate-file"))
				opts << "=\"#{_translate_file}\" "
			end
			opts << "-progname=#{_progname} " if _USE_progname.yes? and _progname.length?
		else
			if _USE_progname.yes? and _progname.length?
				opts << "-progname=#{_progname} "
				if @format.length?
					if "@format" == "plain"
						@format="xetex"
					elsif @format !~ /xe/
						@format="xe#{@format}"
					end
				else
					@format="xetex"
				end
				opts << "-fmt=#{@format} "
			elsif "@format" == "plain"
				opts << "-progname=xetex "
			elsif @format.length?
				if @format !~ /xe/
					@format="xe#{@format}"
				end
				opts << "-progname=#{@format} "
			end
			opts << "-translate-file=\"#{_translate_file}\" " if _USE_translate_file.yes? and _translate_file.length?
		end
		opts << "-etex " if _enable_etex.yes?
		opts << "-8bit " if _eigh_bit.yes?
		opts << "-recorder " if _recorder.yes?
		opts << "-file-line-error " if _file_line_error.yes?
		opts << "-halt-on-error " if _halt_on_error.yes? or _iTM2_ContinuousCompile.yes?
		notify("error","-kpathsea-debug no yet supported.") if _kpathsea_debug.yes?
		opts << "-interaction=#{_interaction} " if _interaction.yes? and _iTM2_ContinuousCompile.no?
		opts << "#{_MoreArgument} " if _USE_MoreArgument.yes? and _MoreArgument.length?
		opts <<((_iTM2_AllTeX_shell_escape.yes?)?("-shell-escape "):("-no-shell-escape "))
		if _USE_jobname.yes? and _jobname.length?
			@job = jobname
			opts << "-jobname=\"#{@job}\" "
		end
		case _output_driver
			when "XeTeX"
			when "iTeXMac2"
				opts << "-no-pdf "
			when "custom"
				opts << "-output-driver=\"#{_custom_output_driver}\" " if _custom_output_driver.length?
		end
		if _output_driver.yes?
		end
		opts
	end

	def engine_shortcut
								# this part belongs to the method
								if /^fr/ =~ @format
									if FileTest.executable?(`which FrenchPro`.chomp)
										frenchpro = true
									else
										bail("FrenchPro is not available, install FrenchPro or change the format in #{project.name.basename.to_s} settings.")
									end
								end
								if ! FileTest.executable?(`which xetex`.chomp)
									bail("xetex is not available, either install a more complete TeX distribution or change the format in #{project.name.basename.to_s} settings.")
								end
								opts = options # here for the side effects
								@job = project.job_name.to_s if @job.nil?
								if opts =~ /-no-pdf/ # create the xdv and let iTM2 translate to pdf
								# unless in draft mode from the command line
								# nothing more to do than create the xdv file
								# feeding the script file:
# the parts below belong to the script
									engine_shortcut = <<EOF
$job = "#{@job}"
$xdvout = "#{@job+'.xdv'}"
$sync = "#{@job+'.sync'}"
File.delete($sync) if FileTest.exist?($sync)
$pdfsync = "#{@job+'.pdfsync'}"
File.delete($pdfsync) if FileTest.exist?($pdfsync)
$verb = "#{((frenchpro.yes?)?('/bin/sh -c frenchpro xetex '):('xetex '))}"
$options = "#{options}"
$command = $verb+$options+'"'+$master+'"'
$pretty_command = $command.gsub(/"/,'\"')
notify("comment","Performing \#{$pretty_command}")
if ! system($command)
	notify("error","#{$me} FAILED(#{$?}).")
	exit $?
end
if ! ENV.key?('TWS_draft_mode') or ENV['TWS_draft_mode'] == '0'
	$pdfout = "#{@job+'.pdf'}"
	if Kernel.test(?s,$xdvout)
		if ! system("#{$0}",'-p',$project,'-a','Compile','-m',$xdvout) or ! Kernel.test(?s,$pdfout)
			system("iTeXMac2","markerror","-file",$pdfout,"-project",$project)
		end
	else
		$aux = "#{@job+'.aux'}"
		FileUtils.rm($aux,:force => true) if Kernel.test(?s,$aux)
		system("iTeXMac2","markerror","-file",$pdfout,"-project",$project)
	end
end
EOF
								else
									# we've been given a driver, the output is pdf
									engine_shortcut = <<EOF
$job = "#{@job}"
$pdfout = "#{@job+'.pdf'}"
FileUtils.rm_f($pdfout) if FileTest.symlink?($pdfout)
$pdfsync = "#{@job+'.pdfsync'}"
File.delete($pdfsync) if FileTest.exist?($pdfsync)
$sync = "#{@job+'.sync'}"
File.delete($sync) if FileTest.exist?($sync)
$verb = "#{((frenchpro.yes?)?('/bin/sh -c frenchpro xetex '):('xetex '))}"
$options = "#{options}"
if ENV.key?('TWS_draft_mode') and ENV['TWS_draft_mode'] != '0'
	$command = $verb+$options+'-no-pdf "'+$master+'"'
	$pretty_command = $command.gsub(/"/,'\"')
	notify("comment","Performing \#{$pretty_command}")
	if ! system($command)
		notify("error","#{$me} FAILED(#{$?}).")
		exit $?
	end
else
	$command = $verb+$options+'"'+$master+'"'
	$pretty_command = $command.gsub(/"/,'\"')
	notify("comment","Performing \#{$pretty_command}")
	if ! system($command)
		notify("error","#{$me} FAILED(#{$?}).")
		exit $?
	elsif Kernel.test(?s,$pdfout)
EOF
									if project.source_folder.writable? and project.source_folder != Pathname.pwd
										engine_shortcut << <<EOF
		$pdfsrc = "#{(project.source_folder+(@job+'.pdf')).to_s}"
		FileUtils.rm_f($pdfsrc) if FileTest.symlink?($pdfsrc) or FileTest.exist?($pdfsrc)
		FileUtils.mv($pdfout,$source_folder,:force => true)
		if FileTest.exist?($pdfsync)
			$pdfsyncsrc = "#{(project.source_folder+(@job+'.pdfsync')).to_s}"
			FileUtils.rm_f($pdfsyncsrc) if FileTest.symlink?($pdfsyncsrc) or FileTest.exist?($pdfsyncsrc)
			FileUtils.mv($pdfsync,$source_folder,:force => true)
			FileUtils.touch($pdfsyncsrc)
		end
		if FileTest.exist?($sync)
			$syncsrc = "#{(project.source_folder+(@job+'.sync')).to_s}"
			FileUtils.rm_f($syncsrc) if FileTest.symlink?($syncsrc) or FileTest.exist?($syncsrc)
			FileUtils.mv($sync,$source_folder,:force => true)
			FileUtils.touch($syncsrc)
		end
		system("iTeXMac2","update","-file",$pdfout,"-project",$project)
EOF
									else # not writable, just touch the sync files
									engine_shortcut <<= <<EOF # NOEOF
		if FileTest.exist?($pdfsync)
			FileUtils.touch($pdfsync)
		end
		if FileTest.exist?($sync)
			FileUtils.touch($sync)
		end
		system("iTeXMac2","update","-file",$pdfout,"-project",$project)
EOF
									end
									engine_shortcut <<= <<EOF # NOEOF
	else
		$aux = "#{@job+'.aux'}"
		FileUtils.rm($aux,:force => true) if Kernel.test(?s,$aux)
		system("iTeXMac2","markerror","-file",$pdfout,"-project",$project)
	end
end
EOF
								end # NOEOF
								engine_shortcut
	end
						
end
$launcher.engine_wrapper = XeTeXWrapper.new
