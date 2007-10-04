# this is iTM2_Engine_PDFTeX.rb for iTeXMac2 2.0
# © 2007 jlaurens AT users DOT sourceforge DOT net
# This is a pdfeTeX 3.141592-1.20a-2.2 (Web2C 7.5.3) wrapper
# the purpose of this script is to create a shell script for iTM2_Command_Compile.rb

$engine = "pdftex"

class PDFTeXWrapper<EngineWrapper
	
	def key_prefix
		'iTM2_PDFTeX_'
	end
	
	def command_arguments
		args=" "
		if ini.yes?
			args="-ini "
			args << "-enc " if enc.yes?
			args << "-mltex " if mltex.yes?
			args << "-output-format "
			args << ((output_format == "dvi")?("dvi "):("pdf "))
		else
			args << "-output-format "
			if output_format == "dvi"
				args << "dvi "
				if use_out_comment.yes? and out_comment.length?
					args << "-out-comment \"#{out_comment}\" "
				end
			else
				args << "pdf "
				if config('PDFSYNC').yes?
					notify("error","PDFSYNC no yet supported")
				end
			end
		end
		if use_out_directory.yes? and out_directory.length?
			args << "-out-directory \"#{out_directory}\" "
		elsif iTM2_USE_out_directory.yes? and iTM2_out_directory.length?
			args << "-out-directory \"#{iTM2_out_directory}\" "
		end
		if @format=fmt
			@format = @format.downcase
		else
			@format = "plain"
		end
		if parse_first_line.yes?
			args << "-parse-first-line "
			if use_translate_file.yes? and translate_file.length?
				args << ((parse_translate_file.yes?)?("-default-translate-file "):("-translate-file "))
				args << "\"#{translate_file}\" "
			end
			args << "-progname #{progname} " if use_progname.yes? and progname.length?
		else
			if use_progname.yes? and progname.length?
					args << "-progname #{progname} "
				if @format == "plain"
					args << "-fmt pdftex "
				else
					if ! ( /^pdf/ =~ @format )
						pdffmt="pdf"+@format
						if `kpsewhich #{@format}.fmt`.length?
							@format=pdffmt
						end
					end
					args << "-fmt #{@format} "
				end
			elsif @format == "plain"
				args << "-progname pdftex "
			else
				if ! ( /^pdf/ =~ @format )
					pdffmt="pdf"+@format
					if `kpsewhich #{pdffmt}.fmt`.length?
						@format=pdffmt
					end
				end
				args << "-progname #{@format} "
			end
			args << "-translate-file \"#{translate_file}\" " if use_translate_file.yes? and translate_file.length?
		end
		args << "-recorder " if recorder.yes?
		args << "-file-line-error " if file_line_error.yes?
		args << "-halt-on-error " if halt_on_error.yes? or iTM2_ContinuousCompile.yes?
		notify("error","-kpathsea-debug no yet supported.") if kpathsea_debug.yes?
		args << "-interaction #{interaction} " if interaction.yes? and iTM2_ContinuousCompile.yes?
		args << "#{MoreArgument} " if use_MoreArgument.yes? and MoreArgument.length?
		args << ((iTM2_AllTeX_shell_escape.yes?)?("-shell-escape "):("-no-shell-escape "))
		if use_jobname.yes? and jobname.length?
			@job = jobname
			args << "-jobname \"#{@job}\" "
		end
		args
	end
	
	def engine_shortcut
		frenchpro = ""
		if /^fr/ =~ @format
			frenchpro=`which FrenchPro`
			if ! FileTest.executable?(frenchpro)
				itexmac2_error("FrenchPro is not available, install FrenchPro or change the #{project.name.basename.to_s} settings.")
				frenchpro=""
			end
		end
		command = ""
		args = command_arguments
		master_name = project.master_name
		if frenchpro.length?
			command = "/bin/sh -c #{frenchpro} #{$engine} #{args} \"#{master_name.to_s}\""
		else
			command = "#{$engine} #{args} \"#{master_name.to_s}\""
		end
		notify("comment","Performing #{command}")
		if ! @job
			@job = project.job_name.to_s
		end
		pdfsync = @job+'.pdfsync'
		File.delete(pdfsync) if FileTest.exist?(pdfsync)
		sync = @job+'.sync'
		File.delete(sync) if FileTest.exist?(sync)
		pdfout = @job+'.pdf'
		File.delete(pdfout) if FileTest.symlink?(pdfout.to_s)
		dviout = @job+'.dvi'
		File.delete(dviout) if FileTest.symlink?(dviout.to_s)
		pdfsrc = (project.source_folder+pdfout).to_s
		# opening the script file:
		engine_shortcut = <<EOF
puts `which pdftex`
$pdfout = "#{pdfout}"
$pdfsync = "#{pdfsync}"
$sync = "#{sync}"
$pdfsrc = "#{pdfsrc}"
File.delete($pdfout) if FileTest.exist?($pdfout)
File.delete($pdfsync) if FileTest.exist?($pdfsync)
File.delete($sync) if FileTest.exist?($sync)
command = "#{command.gsub(/"/,'\"')}"
notify("comment","Performing \#{command}")
if system(command)
	puts "\#{$me} %.2f" % Time.now.to_f
EOF
		if output_format == "dvi" # no external viewer supported...
			engine_shortcut << <<EOF
	master = "$pwd+'/'+#{@job}".gsub(/"/,'\\"')#'
	notify("comment","Swicthing to a dvi to ps or pdf filter for "+master)
	if ! system("#{$0}",'-p',$project,'-m','#{dviout}', '-a','Compile')
		notify("error","Helper iTM2_Engine_PDFTeX FAILED(#{$?}).")
		exit $?
	end
EOF
		end # if config('output_format'...
		engine_shortcut <<= <<EOF
	if Kernel.test(?s,$pdfout)
EOF
		if project.source_folder.writable?
			engine_shortcut <<= <<EOF
		if FileTest.symlink?($pdfsrc) or FileTest.exist?($pdfsrc)
			FileUtils.rm_f($pdfsrc)
		end
		FileUtils.mv($pdfout,$source_folder,:force => true)
		system("iTeXMac2","update","-file",$pdfsrc,"-project",$project)
EOF
		else
			engine_shortcut <<= <<EOF
system("iTeXMac2","update","-file",$pwd+'/'+$pdfout,"-project",$project)
EOF
		end
		aux = @job+'.aux'
		log = @job+'.log'
		engine_shortcut <<= <<EOF
	else
		system("iTeXMac2","markerror","-file",$pdfsrc,"-project",$project)
		$aux = "#{aux}"
		if Kernel.test(?s,$aux)
			FileUtils.rm($aux,:force => true)
		end
		if FileTest.exist?($pdfout)
			FileUtils.rm($pdfout,:force => true)
		end
	end
	$log = "#{log}"
	if Kernel.test(?s,$log)
		system("iTeXMac2","log","-file",$log,"-project",$project,"-dont-order-front")
	end
EOF
		if iTM2_Debug.yes?
			engine_shortcut <<= <<EOF
	notify("comment","#{$me} complete.")
EOF
		end
		engine_shortcut <<= <<EOF
	puts "\#{$me} exit: %.2f" % Time.now.to_f
	exit 0
else
	notify("error","#{$me} FAILED(#{$?}).")
	puts "\#{$me} exit: %.2f" % Time.now.to_f
	exit $?
end
EOF
		engine_shortcut
	end

end
$launcher.engine_wrapper = PDFTeXWrapper.new
