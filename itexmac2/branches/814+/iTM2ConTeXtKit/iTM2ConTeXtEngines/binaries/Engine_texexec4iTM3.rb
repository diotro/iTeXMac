#!/bin/sh -f
# this is iTM2_Engine_TeXExec for iTeXMac2 2.0
# © 2005 jlaurens AT users DOT sourceforge DOT net
# This is a TeXExec 5.2.4 - ConTeXt / PRAGMA ADE 1997-2005 wrapper
iTM2_TeXExec_Engine_Version=1.1
iTM2_Debug="1"
iTM2_TeXExec_Engine="texexec"
iTM2_TeXExec_EnginePath="$(zsh -c "which \"${iTM2_TeXExec_Engine}\"")"#"
iTM2TeXEngineUsage()
{
cat <<EOF
Welcome to $(basename "$0") version ${iTM2_TeXExec_Engine_Version}
This is iTeXMac2 built in script to wrap the TeXExec engine
($(which "$0"))
© 2004 jlaurens AT users DOT sourceforge DOT net
Usage: $(basename "$0") with environment variables
	TWSMaster: the main input file
	TWSFront: the front file
Standard:
	iTM2_TeXExec_verbose: --verbose # shows some additional info
	iTM2_TeXExec_silent: --silent # minimize (status) messages
	iTM2_TeXExec_once: --once # run TeX only once (no TeXUtil either)
	iTM2_TeXExec_fast: --fast # skip as much as possible
	iTM2_TeXExec_final: --final # add a final run without skipping
	iTM2_TeXExec_batch: --batch # run in batch mode (don't pause)
	iTM2_TeXExec_nonstop: --nonstop # run in non stop mode (don't pause)
	iTM2_TeXExec_USE_result: 1 or 0 # 
	iTM2_TeXExec_result: --result # resulting file
	iTM2_TeXExec_USE_mode: 1 or 0 # 
	iTM2_TeXExec_mode: --mode # running mode =list     : modes to set
	iTM2_TeXExec_USE_XeTeX: 1 or 0 # 
	iTM2_TeXExec_USE_passon: 1 or 0 # 
	iTM2_TeXExec_passon: --passon # switches to pass to TeX (--src for MikTeX)
    iTM2_TeXExec_USE_TXC_passon: 0 or 1 #
    iTM2_TeXExec_TXC_passon: ... # switches to pass to TeXExec
	iTM2_TeXExec_output: --output # specials to use
#	                        =dvipdfm  : Mark Wicks' dvi to pdf converter
#                           =dvipdfmx : Jin-Hwan Cho's extended dvipdfm
#                           =dvips    : Thomas Rokicky's dvi to ps converter
#                           =dvipsone : YandY's dvi to ps converter
#                           =dviwindo : YandY's windows previewer
#                           =pdftex   : Han The Than's pdf backend
Advanced:
	iTM2_TeXExec_runs: --runs # maximum number of TeX runs
	iTM2_TeXExec_alone : --alone  #  bypass utilities (e.g. fmtutil for non-standard fmt'
	iTM2_TeXExec_arrange: --arrange # 
	iTM2_TeXExec_automprun: --automprun # 
	iTM2_TeXExec_nomp: --nomp # 
	iTM2_TeXExec_nomprun: --nomprun # 
	iTM2_TeXExec_USE_mpformat: 1 or 0 # 
	iTM2_TeXExec_mpformat: --mpformat # 
	iTM2_TeXExec_mptex: --mptex # 
	iTM2_TeXExec_mpxtex: --mpxtex # 
	iTM2_TeXExec_centerpage: --centerpage # 
	iTM2_TeXExec_color: --color # 
	iTM2_TeXExec_USE_figures: 1 or 0 # 
	iTM2_TeXExec_figures: --figures # 
	iTM2_TeXExec_USE_interface: 1 or 0 # 
	iTM2_TeXExec_interface: --interface # 
	iTM2_TeXExec_USE_language: 1 or 0 # 
	iTM2_TeXExec_language: --language # 
	iTM2_TeXExec_listing: --listing # 
	iTM2_TeXExec_USE_input: 1 or 0 # 
	iTM2_TeXExec_input: --input # 
	iTM2_TeXExec_USE_pages: 1 or 0 # 
	iTM2_TeXExec_pages: --pages # 
	iTM2_TeXExec_paper: --paper # 
	iTM2_TeXExec_print: --print # 
	iTM2_TeXExec_USE_suffix: 1 or 0 # 
	iTM2_TeXExec_suffix: --suffix # 
	iTM2_TeXExec_USE_path: 1 or 0 # 
	iTM2_TeXExec_path: --path # 
	iTM2_TeXExec_screensaver: --screensaver # 
	iTM2_TeXExec_USE_setfile: 1 or 0 # 
	iTM2_TeXExec_setfile: --setfile # 
	iTM2_TeXExec_make: --make # 
	iTM2_TeXExec_USE_format: 1 or 0 # 
	iTM2_TeXExec_format: --format # 
	iTM2_TeXExec_tex: --tex # 
	iTM2_TeXExec_USE_textree: 1 or 0 # 
	iTM2_TeXExec_textree: --textree # 
	iTM2_TeXExec_USE_texroot: 1 or 0 # 
	iTM2_TeXExec_texroot: --texroot # 
	iTM2_TeXExec_texutil: --texutil # 
	iTM2_TeXExec_USE_usemodule: 1 or 0 # 
	iTM2_TeXExec_usemodule: --usemodule # 
	iTM2_TeXExec_USE_environment: 1 or 0 # 
	iTM2_TeXExec_environment: --environment # 
	iTM2_TeXExec_USE_xmlfilter: 1 or 0 # 
	iTM2_TeXExec_xmlfilter: --xmlfilter
EOF
}
"$iTM2_CMD_Notify" echo "Welcome to $(basename "$0") version ${iTM2_TeXExec_Engine_Version}
This is iTeXMac2 built in script to wrap the TeXExec engine
© 2005 jlaurens AT users DOT sourceforge DOT net"
if [ "${iTM2_Debug:-0}" != "0" ]
then
	"$iTM2_CMD_Notify" start comment
	"$iTM2_CMD_Notify" echo "The $0 specific environment is:"
	for iTM2VAR in ${!iTM2_TeXExec_*}
	do
		echo "${iTM2VAR} is: ${!iTM2VAR}"
	done
	"$iTM2_CMD_Notify" stop comment
fi
if ! [ -x "${iTM2_TeXExec_EnginePath}" ]
then
	"$iTM2_CMD_Notify" error "Unknown command ${iTM2_TeXExec_Engine}."
	iTM2TeXEngineUsage
	exit 1
fi
if ! [ -r "${TWSMaster}" ]
then
	if ! [ -r "${TWSFront}" ]
	then
		"$iTM2_CMD_Notify" error "No readable file at ${TWSMaster} nor ${TWSFront}."
		iTM2TeXEngineUsage
		exit 2
	else
		"$iTM2_CMD_Notify" comment "No master given: front chosen"
		TWSMaster="${TWSFront}"
	fi
fi
"$iTM2_CMD_Notify" comment "TWSMaster is: ${TWSMaster}"
iTM2_TeXExec_Arguments=""
if [ "${iTM2_TeXExec_verbose:-0}" != "0" ]
then
    iTM2_TeXExec_Arguments="${iTM2_TeXExec_Arguments} --verbose"
fi
if [ "${iTM2_TeXExec_silent:-0}" != "0" ]
then
    iTM2_TeXExec_Arguments="${iTM2_TeXExec_Arguments} --silent"
fi
if [ "${iTM2_TeXExec_once:-0}" != "0" ]
then
    iTM2_TeXExec_Arguments="${iTM2_TeXExec_Arguments}  --once"
fi
if [ "${iTM2_TeXExec_fast:-0}" != "0" ]
then
    iTM2_TeXExec_Arguments="${iTM2_TeXExec_Arguments} --fast"
fi
if [ "${iTM2_TeXExec_final:-0}" != "0" ]
then
    iTM2_TeXExec_Arguments="${iTM2_TeXExec_Arguments} --final"
fi
if [ "${iTM2_TeXExec_batch:-0}" != "0" ]
then
    iTM2_TeXExec_Arguments="${iTM2_TeXExec_Arguments} --batch"
fi
if [ "${iTM2_TeXExec_nonstop:-0}" != "0" ]
then
    iTM2_TeXExec_Arguments="${iTM2_TeXExec_Arguments} --nonstop"
fi
if [ "${iTM2_TeXExec_USE_result:-0}" != "0" ] && [ ${#iTM2_TeXExec_result} -ne 0 ]
then
        iTM2_TeXExec_Arguments="${iTM2_TeXExec_Arguments} --result \"${iTM2_TeXExec_result}\""
fi
if [ "${iTM2_TeXExec_USE_mode:-0}" != "0" ] && [ ${#iTM2_TeXExec_mode} -ne 0 ]
then
        iTM2_TeXExec_Arguments="${iTM2_TeXExec_Arguments} --mode \"${iTM2_TeXExec_mode}\""
fi
if [ "${iTM2_TeXExec_USE_passon:-0}" != "0" ] && [ ${#iTM2_TeXExec_passon} -ne 0 ]
then
        iTM2_TeXExec_Arguments="${iTM2_TeXExec_Arguments} -passon \"${iTM2_TeXExec_passon}\""
fi
if [ "${iTM2_TeXExec_USE_XeTeX:-0}" != "0" ]
then
    iTM2_TeXExec_Arguments="${iTM2_TeXExec_Arguments} --xtx"
elif [ "${#iTM2_TeXExec_output}" != "0" ]
then
    iTM2_TeXExec_Arguments="${iTM2_TeXExec_Arguments} --output ${iTM2_TeXExec_output}"
else
    iTM2_TeXExec_Arguments="${iTM2_TeXExec_Arguments} --pdf"
fi
if [ "${iTM2_TeXExec_USE_TXC_passon:-0}" != "0" ] && [ ${#iTM2_TeXExec_TXC_passon} -ne 0 ]
then
    iTM2_TeXExec_Arguments="${iTM2_TeXExec_Arguments} ${iTM2_TeXExec_USE_TXC_passon}"
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
	"$iTM2_CMD_Notify" error "No readable file at ${TWSMaster} (in $(pwd))."
	iTM2TeXEngineUsage
	exit 2
fi
if [ "${iTM2_TeXExec_USE_result:-0}" != "0" ] && [ ${#iTM2_TeXExec_result} -ne 0 ]
then
	OUTPUT="${iTM2_TeXExec_result%.*}"
else
	OUTPUT="${TWSMasterBase%.*}"
fi
# working directory?
if [ ${#TWSProject} -gt 0 ]
then
	iTM2_PWD="$(dirname "${TWSProject}")"
	iTM2_PWD_Real="${iTM2_PWD##*Projects.put_aside}"
	iTM2_PWD_Real="${iTM2_PWD_Real%/*.texd*}"
	if [ ${#iTM2_PWD_Real} -lt ${#iTM2_PWD} ]
	then
		iTM2_PWD_Real="$(dirname "${TWSMaster}")"
		if [ ${#TEXINPUTS} -gt 0 ]
		then
			export TEXINPUTS=".:${iTM2_PWD_Real}:${TEXINPUTS}:"
		else
			export TEXINPUTS=".:${iTM2_PWD_Real}:"
		fi
		if [ ${#MPINPUTS} -gt 0 ]
		then
			export MPINPUTS=".:${iTM2_PWD_Real}:${MPINPUTS}:"
		else
			export MPINPUTS=".:${iTM2_PWD_Real}:"
		fi
		if [ ${#iTM2_PWD} -gt 0 ] && ! [ -r "${iTM2_PWD}/${TWSMasterBase}" ]
		then
			ln -sf "{TWSMaster}" "${iTM2_PWD}"
		fi
	fi
else
	iTM2_PWD_Real="$(dirname "${TWSMaster}")"
	iTM2_PWD="${iTM2_PWD_Real}"
fi
pushd "${iTM2_PWD}" > /dev/null
"$iTM2_CMD_Notify" comment "Performing  ${iTM2_TeXExec_EnginePath} ${iTM2_TeXExec_Arguments} \"${TWSMasterBase%}\""
${iTM2_TeXExec_EnginePath} ${iTM2_TeXExec_Arguments} "${TWSMasterBase%}"
iTM2_Status="$?"
if [ "${iTM2_Status}" != "0" ]
then
	popd > /dev/null
	"$iTM2_CMD_Notify" error "$0 FAILED(${iTM2_Status})."
	exit ${iTM2_Status}
fi
OUTPUT="${OUTPUT%.*}.log"
if [ -s "${OUTPUT}" ]
then	
	"${iTM2_TemporaryDirectory}/bin/iTeXMac2" update -file "${iTM2_PWD}/${OUTPUT}" -project "${TWSProject}"
fi
OUTPUT="${OUTPUT%.*}.pdf"
if [ -s "${OUTPUT}" ]
then	
	if [ ${#iTM2_PWD_Real} -lt ${#iTM2_PWD} ] && [ -w "${iTM2_PWD_Real}" ]
	then
		mv -f "${OUTPUT}" "${iTM2_PWD_Real}"
	fi
	"${iTM2_TemporaryDirectory}/bin/iTeXMac2" update -file "${iTM2_PWD_Real}/${OUTPUT}" -project "${TWSProject}"
else
	"${iTM2_TemporaryDirectory}/bin/iTeXMac2" markerror -file "${iTM2_PWD_Real}/${OUTPUT}" -project "${TWSProject}"
fi
if [ "${iTM2_Status}" != "0" ]
then
	"$iTM2_CMD_Notify" error "$0 FAILED(${iTM2_Status})."
	popd > /dev/null
	exit ${iTM2_Status}
elif [ "${iTM2_Debug}" != "0" ]
then
	"${iTM2_CMD_Notify}" comment "$0 complete."
fi
popd > /dev/null
exit


popd > /dev/null
if [ "${iTM2_Debug:-0}" != "0" ]
then
	"$iTM2_CMD_Notify" comment "$0 complete."
fi
if [ "${iTM2_TeXExec_USE_result:-0}" != "0" ] && [ ${#iTM2_TeXExec_result} -ne 0 ]
then
    "${iTM2_TemporaryDirectory}/bin/iTeXMac2" update -file "${iTM2_PWD}/${iTM2_TeXExec_result%.*}.pdf" -project "${TWSProject}"
else
    "${iTM2_TemporaryDirectory}/bin/iTeXMac2" update -file "${iTM2_PWD}/${TWSMaster%.*}.pdf" -project "${TWSProject}"
fi
exit
