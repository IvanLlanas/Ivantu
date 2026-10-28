source "$IVANTU_SCRIPTS_DIR/conio.sh"

_inas="192.168.1.101"
_vol1="videoteca"
_vol2="filter"

function ___samba_mount ()
{
   echo
   ___print_info_bg "Mounting <1>SAMBA<0> volumes..."
   ___print_info    "   $_vol1..."
   sudo mount -t cifs -o user,uid=1000,gid=1000,credentials=/root/.cifs  //$_inas/$_vol1/  /home/ivan/Media/$_vol1
   ___print_info    "   $_vol2..."
   sudo mount -t cifs -o user,uid=1000,gid=1000,credentials=/root/.cifs  //$_inas/$_vol2/  /home/ivan/Media/$_vol2
   echo
}

function ___nfs_mount ()
{
   echo
   ___print_info_bg "Mounting <1>NFS<0> volumes..."
   ___print_info "   $_vol1..."
   sudo mount -t nfs $_inas:/shared/$_vol1  /home/ivan/Media/$_vol1
   ___print_info "   $_vol2..."
   sudo mount -t nfs $_inas:/shared/$_vol2  /home/ivan/Media/$_vol2
   echo
}

function ___umount ()
{
   echo
   ___print_info_bg "<1>Unmounting<0> volumes and <2>shutting down<0>......"
   ___print_info "   $_vol1..."
   sudo umount /home/ivan/Media/$_vol1
   ___print_info "   $_vol2..."
   sudo umount /home/ivan/Media/$_vol2
   ___print_warning_bg "<1>Shutting down<0>..."
   echo -ne $_ansi_lred
   ssh poweroff@192.168.1.101
   echo -e $_ansi_off
}


function main ()
{
   local answer
   local indent="   "

   ___print_info "Connecting..."
   if ping -c 1 $_inas &> /dev/null
   then
      echo
   else
      ___print_error "INAS (<1>$_inas<0>) not reachable."
      exit
   fi

   ___print_info "$indent""INAS: <1>$_inas<0> (<2>$_vol1<0>, <2>$_vol2<0>)"
   echo
   ___print_info "$indent$indent""<2>1<0>. - Mount <1>NFS<0> volumes"
   ___print_info "$indent$indent""<2>2<0>. - Mount <1>SAMBA<0> volumes"
   ___print_info "$indent$indent""<2>3<0>. - <1>Unmount<0> volumes and <1>shutdown<0> server"
   echo
   echo -n "$indent""? "
   read answer
   case $answer in
      '1') ___nfs_mount;;
      '2') ___samba_mount;;
      '3') ___umount;;
        *) ___print_error "Cancelled."
           echo
           exit;;
   esac
}

main
