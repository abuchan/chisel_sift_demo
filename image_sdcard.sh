read -p "Enter device to image (e.g. /dev/sdb): " sdcard

read -p "WARNING! You are about to image $sdcard. Do you wish to continue (yes/no)?: " yn

while true; do
  case $yn in
    yes ) echo "Imaging $sdcard with $1:";
      # Use pv (pipe viewer) to display progress if it exists)
      if hash pv 2>/dev/null; then
        pv $1 | dd bs=4M of=$sdcard
      else
        dd if=$1 bs=4M of=$sdcard
      fi
      echo "Imaging $sdcard complete.";
      break;;
    * ) echo "Imaging $sdcard aborted"; break;;
  esac
done

