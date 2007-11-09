# this is pstopdf wrapper
# © 2007 jlaurens AT users DOT sourceforge DOT net

class PSTOPDFWrapper < EngineWrapper

	def key_prefix
		#subclassers will override this
		'iTM2_pstopdf_'
	end

	def options
		opts = " "
		opts << "-l " if _write_to_log.yes?
		opts << "-p " if _progress_message.yes?
		if _USE_output.yes? and _output.length?
			@pdfout = _output
			@pdfout << ".pdf" if @pdfout!~/\.pdf$/
			opts << "-o \"#{@pdfout}\" "
		end
		opts
	end

	def engine_shortcut
						command = "pstopdf #{options} \"#{project.master_name}\""
						@pdfout = project.master_name.to_s.sub(/(\.ps)?$/,".pdf") if ! @pdfout
						pdfsrc = (project.source_folder+@pdfout).to_s
						# opening the script file:
						engine_shortcut = <<EOF
$pdfout = "#{@pdfout}"
$pdfsrc = "#{pdfsrc}"
File.delete($pdfout) if FileTest.symlink?($pdfout) or FileTest.exist?($pdfout)
$command = "#{command.gsub(/"/,'\"')}"
notify("comment","Performing \#{$command}")
if ! system($command)
	notify("error","#{$me} FAILED(#{$?}).")
	exit $?
elsif ! Kernel.test(?s,$pdfout)
	notify("error","#{$me} FAILED(#{$?}).")
	exit $?
else
EOF
						if project.source_folder.writable?
							engine_shortcut <<= <<EOF
	FileUtils.rm_f($pdfsrc) if FileTest.symlink?($pdfsrc) or FileTest.exist?($pdfsrc)
	FileUtils.mv($pdfout,$source_folder,:force => true)
	$pdfsync = "#{@job+'.pdfsync'}"
	if FileTest.exist?($pdfsync)
		$pdfsyncsrc = "#{(project.source_folder+(@job+'.pdfsync')).to_s}"
		FileUtils.rm_f($pdfsyncsrc) if FileTest.symlink?($pdfsyncsrc) or FileTest.exist?($pdfsyncsrc)
		FileUtils.mv($pdfsync,$source_folder,:force => true)
		FileUtils.touch($pdfsyncsrc)
	end
	$sync = "#{@job+'.sync'}"
	if FileTest.exist?($sync)
		$syncsrc = "#{(project.source_folder+(@job+'.sync')).to_s}"
		FileUtils.rm_f($syncsrc) if FileTest.symlink?($syncsrc) or FileTest.exist?($syncsrc)
		FileUtils.mv($sync,$source_folder,:force => true)
		FileUtils.touch($syncsrc)
	end
	system("iTeXMac2","update","-file",$pdfsrc,"-project",$project)
	puts "Output written on "+$pdfout+" ("+File.size($pdfsrc).to_s+" bytes)"
EOF
						else
							engine_shortcut << <<EOF
	$pdfsync = "#{@job+'.pdfsync'}"
	if FileTest.exist?($pdfsync)
		FileUtils.touch($pdfsync)
	end
	$sync = "#{@job+'.sync'}"
	if FileTest.exist?($sync)
		FileUtils.touch($sync)
	end
	system("iTeXMac2","update","-file",$pwd+'/'+$pdfout,"-project",$project)
	puts "Output written on "+$pdfout+" ("+File.size($pdfout).to_s+" bytes)"
EOF
						end
						engine_shortcut << <<EOF
end
EOF
						engine_shortcut
	end

end
$launcher.engine_wrapper = PSTOPDFWrapper.new
