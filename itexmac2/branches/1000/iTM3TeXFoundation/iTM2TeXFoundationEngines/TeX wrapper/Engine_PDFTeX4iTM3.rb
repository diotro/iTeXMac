# this is iTM2_Engine_PDFTeX.rb for iTeXMac2 2.0
# © 2007 jlaurens AT users DOT sourceforge DOT net
# This is a pdfeTeX 3.141592-1.20a-2.2 (Web2C 7.5.3) wrapper
# the purpose of this script is to create a shell script for iTM2_Command_Compile.rb

class PDFTeXWrapper<EngineWrapper
	
	def key_prefix
		'iTM2_PDFTeX_'
	end
	
	def options
		if _ini.yes?
			opts = "-ini "
			opts << "-enc " if _enc.yes?
			opts << "-mltex " if _mltex.yes?
			opts << "-output-format="
			opts << ((_output_format == "dvi")?("dvi "):("pdf "))
		else
			opts = "-output-format="
			if _output_format == "dvi"
				@output_extension = "dvi"
				opts << "dvi "
				opts << "-out-comment=\"#{_out_comment}\" " if _USE_out_comment.yes? and _out_comment.length?
			else
				@output_extension = "pdf"
				opts << "pdf "
				notify("error","PDFSYNC no yet supported") if _PDFSYNC.yes?
			end
		end
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
				if @format == "plain"
					opts << "-fmt=pdftex "
				else
					if ! ( /^pdf/ =~ @format )
						pdffmt="pdf"+@format
						if `kpsewhich #{@format}.fmt`.length?
							@format=pdffmt
						end
					end
					opts << "-fmt=#{@format} "
				end
			elsif @format == "plain"
				opts << "-progname=pdftex "
			else
				if ! ( /^pdf/ =~ @format )
					pdffmt="pdf"+@format
					if `kpsewhich #{pdffmt}.fmt`.length?
						@format=pdffmt
					end
				end
				opts << "-progname=#{@format} "
			end
			opts << "-translate-file=\"#{_translate_file}\" " if _USE_translate_file.yes? and _translate_file.length?
		end
		opts << "-recorder " if _recorder.yes?
		opts << "-8bit " if _eigh_bit.yes?
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
								if ! FileTest.executable?(`which pdftex`.chomp)
									bail("pdftex is not available, either install a more complete TeX distribution or change the format in #{project.name.basename.to_s} settings.")
								end
								opts = options # here for the side effect, before what is after...
								@job = project.job_name.to_s if @job.nil?
								product = @job+'.'+@output_extension
								pdfout = @job+'.pdf'
								# feeding the script file:
# the parts below belong to the script
								if opts =~ /-draftmode/
									# just launch the engine, nothing special afterwards
									engine_shortcut = <<EOF
$job = "#{@job}"
$product = "#{product}"
$pdfsync = "#{@job+'.pdfsync'}"
File.delete($pdfsync) if FileTest.exist?($pdfsync)
$sync = "#{@job+'.sync'}"
File.delete($sync) if FileTest.exist?($sync)
$verb = "#{((frenchpro.yes?)?('/bin/sh -c #{frenchpro} pdftex '):('pdftex '))}"
$options = "#{opts}"
$command = $verb+$options+'"'+$master+'"'
$command.gsub!(/"/,'\"')
notify("comment","Performing \#{$command} (draft)")
if ! system($command)
	notify("error","#{$me} FAILED(#{$?}).")
	exit $?
end
EOF
								elsif @output_extension == 'dvi' # we do have to turn this into a pdf...
									engine_shortcut = <<EOF # NOEOF
$job = "#{@job}"
$dviout = "#{@job+'.dvi'}"
FileUtils.rm_f($dviout) if FileTest.symlink?($dviout)
$pdfsync = "#{@job+'.pdfsync'}"
File.delete($pdfsync) if FileTest.exist?($pdfsync)
$sync = "#{@job+'.sync'}"
File.delete($sync) if FileTest.exist?($sync)
$verb = "#{((frenchpro.yes?)?('/bin/sh -c #{frenchpro} pdftex '):('pdftex '))}"
$options = "#{opts}"
if ENV.key?('TWS_draft_mode') and ENV['TWS_draft_mode'] != '0'
	$options.gsub!(/ -output-format=.../,'')
	$command = $verb+$options+'-draftmode "'+$master+'"'
	$command.gsub!(/"/,'\"')
	notify("comment","Performing \#{$command} (draft)")
	if ! system($command)
		notify("error","#{$me} FAILED(#{$?}).")
		exit $?
	end
else
	$command = $verb+$options+'"'+$master+'"'
	$command.gsub!(/"/,'\"')
	notify("comment","Performing \#{$command}")
	if ! system($command)
		notify("error","#{$me} FAILED(#{$?}).")
		exit $?
	end
	$pdfout = "#{pdfout}"
	if Kernel.test(?s,$dviout)
		if !system("#{$0}",'-p',$project,'-a','Compile','-m',$dviout)
			system("iTeXMac2","markerror","-file",$pdfout,"-project",$project)
		end
	else
		$aux = "#{@job+'.aux'}"
		FileUtils.rm($aux,:force => true) if Kernel.test(?s,$aux)
		system("iTeXMac2","markerror","-file",$pdfout,"-project",$project)
	end
end
EOF
								else # pdf output
									engine_shortcut = <<EOF # NOEOF
$job = "#{@job}"
$pdfout = "#{pdfout}"
FileUtils.rm_f($pdfout) if FileTest.symlink?($pdfout)
$pdfsync = "#{@job+'.pdfsync'}"
File.delete($pdfsync) if FileTest.exist?($pdfsync)
$sync = "#{@job+'.sync'}"
File.delete($sync) if FileTest.exist?($sync)
$pdfout = "#{pdfout}"
$verb = "#{((frenchpro.yes?)?('/bin/sh -c #{frenchpro} pdftex '):('pdftex '))}"
$options = "#{opts}"
if ENV.key?('TWS_draft_mode') and ENV['TWS_draft_mode'] != '0'
	$options.gsub!(/ -output-format=.../,'')
	$command = $verb+$options+'-draftmode "'+$master+'"'
	$command.gsub!(/"/,'\"')
	notify("comment","Performing \#{$command}")
	if ! system($command)
		notify("error","#{$me} FAILED(#{$?}).")
		exit $?
	end
else
	$command = $verb+$options+'"'+$master+'"'
	$command.gsub!(/"/,'\"')
	notify("comment","Performing \#{$command}")
	if ! system($command)
		notify("error","#{$me} FAILED(#{$?}).")
		exit $?
	end
	if Kernel.test(?s,$pdfout)
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
puts "! I got here"
$launcher.engine_wrapper = PDFTeXWrapper.new
