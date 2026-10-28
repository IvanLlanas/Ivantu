source $IVANTU_SCRIPTS_DIR/conio.sh

#exit

function create_link ()
{
   local folder1=$1
   local file1=$2
   local file2=$3

   if [ ! -d "$folder1" ]; then
      ___print_error_bg "Secondary directory not found: <1>$folder1<0>."
      exit
   fi

   cd "$folder1"
   if [ -f "$file2" ]; then
      ___print_warning "Deleting <1>$file2<0>..."
      rm "$file2"
   fi
   ln -s "$file1" "$file2"
   cd ..
}


function create_links ()
{
   create_link places folder.png inode-directory.png

   create_link apps calculator-app.png accessories-calculator.png
   create_link apps calculator-app.png org.gnome.Calculator.png
   create_link apps calculator-app.png gnome-calculator.png

   create_link apps calendar-app.png office-calendar.png
   create_link apps calendar-app.png calendar.png
   create_link apps calendar-app.png gnome-calendar.png
   create_link apps calendar-app.png org.gnome.Calendar.png

   create_link apps clock-app.png org.gnome.clocks.png
   create_link apps clock-app.png gnome-clocks.png
   create_link apps clock-app.png org.gnome.Clocks.png

   create_link apps disk-usage-app.png baobab.png
   create_link apps disk-usage-app.png mate-disk-usage-analyzer.png
   create_link apps disk-usage-app.png org.gnome.baobab.png

   create_link apps disk-utility-app.png org.gnome.DiskUtility.png
   create_link apps disk-utility-app.png gnome-disks.png
   create_link apps disk-utility-app.png org.gnome.Disks.png

   create_link apps filemanager-app.png system-file-manager.png
   create_link apps filemanager-app.png file-manager.png
   create_link apps filemanager-app.png nautilus.png
   create_link apps filemanager-app.png org.gnome.Nautilus.png

   create_link apps terminal-app.png gnome-terminal.png
   create_link apps terminal-app.png utilities-terminal.png
   create_link apps terminal-app.png org.gnome.Terminal.png
   create_link apps terminal-app.png terminal.png
   create_link apps terminal-app.png bash.png

   create_link apps tweaks-app.png applications-system.png
   create_link apps tweaks-app.png gnome-tweak-tool.png
   create_link apps tweaks-app.png unity-tweak-tool.png
   create_link apps tweaks-app.png org.gnome.tweaks.png
   create_link apps tweaks-app.png preferences-desktop.png
   create_link apps tweaks-app.png org.gnome.Tweaks.png

   create_link apps system-settings.png preferences-system.png
   create_link apps system-settings.png org.gnome.Settings.png
   create_link apps system-settings.png gnome-control-center.png

   create_link apps system-monitor-app.png utilities-system-monitor.png
   create_link apps system-monitor-app.png org.gnome.SystemMonitor.png
   create_link apps system-monitor-app.png gnome-system-monitor.png
   create_link apps system-monitor-app.png htop.png

   create_link devices media-optical.png gnome-dev-disk-dvdrw.png
   create_link devices media-optical.png gnome-dev-cdrom.png
   create_link devices media-optical.png media-optical-cd-audio.png
   create_link devices media-optical.png media-optical-bd.png
   create_link devices media-optical.png gnome-dev-disk-cdrom.png
   create_link devices media-optical.png media-optical-dvd-ram.png
   create_link devices media-optical.png cdwriter-unmount.png
   create_link devices media-optical.png media-optical-cdr.png
   create_link devices media-optical.png cdrom-unmount.png
   create_link devices media-optical.png gnome-dev-disc-cdrom.png
   create_link devices media-optical.png media-cdrom.png
   create_link devices media-optical.png drive-cdrom.png
   create_link devices media-optical.png gtk-cdrom.png
   create_link devices media-optical.png media-dvdrw.png
   create_link devices media-optical.png gnome-dev-disk-cdr.png
   create_link devices media-optical.png media-optical-dvd-rw.png
   create_link devices media-optical.png gnome-dev-disk-dvdram.png
   create_link devices media-optical.png gnome-dev-disk-cdrw.png
   create_link devices media-optical.png media-dvd.png
   create_link devices media-optical.png media-cdr.png
   create_link devices media-optical.png media-optical-dvd-r-plus.png
   create_link devices media-optical.png media-cdrw.png
   create_link devices media-optical.png gnome-cd.png
   create_link devices media-optical.png media-optical-dvd-rom.png
   create_link devices media-optical.png gnome-dev-dvd-alt.png
   create_link devices media-optical.png media-optical-dvd.png
   create_link devices media-optical.png gnome-dev-disk-dvdrom.png
   create_link devices media-optical.png gnome-dev-disk-dvdr.png
   create_link devices media-optical.png gnome-dev-cdrom-audio.png
   create_link devices media-optical.png dvd-unmount.png
   create_link devices media-optical.png media-optical-dvd-r.png
   create_link devices media-optical.png media-optical-cd-r.png
   create_link devices media-optical.png gnome-dev-disk-dvdr-plus.png
   create_link devices media-optical.png media-optical-cd-rw.png
   create_link devices media-optical.png media-optical-cd.png

   create_link mimetypes application-apk.png application-vnd.android.package-archive.png

   create_link mimetypes application-illustrator.png image-vnd.adobe.illustrator.png

   create_link mimetypes application-pdf.png application-x-pdf.png
   create_link mimetypes application-pdf.png application-x-bzpdf.png
   create_link mimetypes application-pdf.png application-x-gzpdf.png

   create_link mimetypes application-photoshop.png image-vnd.adobe.photoshop.png

   create_link mimetypes application-x-addon.png application-x-xpinstall.png
   create_link mimetypes application-x-addon.png extension.png

   create_link mimetypes application-x-executable.png application-x-sharedlib.png

   create_link mimetypes application-x-gzip.png application-gzip.png

   create_link mimetypes application-x-ms-dos-executable.png application-x-msi.png
   create_link mimetypes application-x-ms-dos-executable.png application-vnd.microsoft.portable-executable.png

   create_link mimetypes application-x-rar.png application-rar.png
   create_link mimetypes application-x-rar.png rar.png
   create_link mimetypes application-x-rar.png gnome-mime-application-x-rar.png
   create_link mimetypes application-x-rar.png application-vnd.rar.png

   create_link mimetypes application-x-zip.png application-zip.png
   create_link mimetypes application-x-zip.png application-archive-zip.png
   create_link mimetypes application-x-zip.png zip.png

   create_link mimetypes audio-x-flac.png audio-x-flac+ogg.png
   create_link mimetypes audio-x-flac.png audio-flac.png

   create_link mimetypes audio-x-mpeg.png audio-mpeg.png

   create_link mimetypes audio-x-wav.png audio-x-adpcm.png

   create_link mimetypes font-x-generic.png font-ttf.png
   create_link mimetypes font-x-generic.png font.png
   create_link mimetypes font-x-generic.png font-otf.png
   create_link mimetypes font-x-generic.png application-font.png

   create_link mimetypes image-x-xcf.png image-x-compressed-xcf.png

   create_link mimetypes package-x-generic.png gnome-mime-application-x-compress.png
   create_link mimetypes package-x-generic.png application-x-archive.png
   create_link mimetypes package-x-generic.png application-x-compress.png
   create_link mimetypes package-x-generic.png gnome-package.png
   create_link mimetypes package-x-generic.png package.png
   create_link mimetypes package-x-generic.png application-archive.png

   create_link mimetypes rom.png application-x-genesis-rom.png
   create_link mimetypes rom.png application-x-nintendo-ds-rom.png
   create_link mimetypes rom.png application-x-sms-rom.png
   create_link mimetypes rom.png application-x-nes-rom.png
   create_link mimetypes rom.png application-x-genesis-32x-rom.png
   create_link mimetypes rom.png application-x-n64-rom.png
   create_link mimetypes rom.png application-x-gba-rom.png
   create_link mimetypes rom.png application-x-gameboy-rom.png

   create_link mimetypes text-html.png text-htmlh.png
   create_link mimetypes text-html.png html.png

   create_link mimetypes text-richtext.png text-enriched.png
   create_link mimetypes text-richtext.png application-rtf.png

   create_link mimetypes text-x-c.png text-x-csrc.png

   create_link mimetypes text-x-cpp.png text-x-c++src.png
   create_link mimetypes text-x-cpp.png text-x-c++.png
   create_link mimetypes text-x-cpp.png text-x-cppsrc.png

   create_link mimetypes text-x-generic.png text-plain.png
   create_link mimetypes text-x-generic.png text-x-plain.png
   create_link mimetypes text-x-generic.png application-x-wine-extension-ini.png
   create_link mimetypes text-x-generic.png text.png

   create_link mimetypes text-xml.png application-xml.png

   create_link mimetypes text-x-preview.png empty.png
   create_link mimetypes text-x-preview.png application-x-zerosize.png

   create_link mimetypes x-office-document.png document.png
   create_link mimetypes x-office-document.png office-document.png
   create_link mimetypes x-office-document.png text-document.png
}

function create_links_to ()
{
   local folder0=$1
   if [ ! -d "$folder0" ]; then
      ___print_error_bg "Primary directory not found: <1>$folder0<0>."
      exit
   fi
   ___print_info_bg "Entering <1>$folder0<0>..."
   cd $folder0
   create_links
   cd ..
}


create_links_to 16x16
create_links_to 16x16@2x
create_links_to 24x24
create_links_to 24x24@2x
create_links_to 32x32
create_links_to 32x32@2x
create_links_to 48x48
create_links_to 48x48@2x
create_links_to 256x256
create_links_to 256x256@2x
