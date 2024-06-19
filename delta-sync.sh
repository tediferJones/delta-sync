echo "start delta-sync"

# path='/home/ted/Dropbox/Delta Emulator'
# path='/home/ted/Downloads/GBA Roms/Delta-Emulator-Data/vault'

# Put these in a config file
# If you define the config like so:
# path=pathToDropbox
# tempDir=tempDirPath
# Then you can just source the file like so: ./ds.config
path="./notes/testVault"
tempDir="./notes/temp"

# We only need to track gameId, title, and index
# We can load games from dropbox, but cant save games to dropbox
#
# WE NEED TO UPDATE SAVEINFO
# We can get the right sha-1 hash for a save file (see notes/hasher.ts)
# Time format of these is in seconds from 'January 1, 2001, 00:00:00 UTC'
# To get correct time do: (Date.now() - new Date(Jan1)) / 1000
# VersionIdentifier is just a random string, can be anything
# No idea how to generate root.sha1Hash
#   - And this is apparently going to be a problem
#   - the hash we need to generate is a sha1 hash of the file object, with keys ordered alphabetically
#     - But how can replicate this file object locally?
#   - versionIdentifier usually somewhat matches
#   - still have no idea how to generate root hash for saveInfo

# files=$(ls "$path")
# fileIds=()

# Create a key value pair, with gameId as key and game title as value
declare -A myObj
for file in $(ls "$path"); do
  if [[ $file =~ ^Game-([0-9a-zA-Z]+)$ ]]; then
    id=$(echo $file | sed "s/Game-//")
    myObj[$id]=$(jq -r .record.name "$path/$file")
  fi
done

keys=(${!myObj[@]})

# Print game names and associated index
for i in $(seq 1 "${#keys[@]}"); do
  echo "$i: ${myObj[${keys[i - 1]}]}"
done

# Get index of game user wants to play
read -p "Game Number: " gameIndex

if ((gameIndex < 1 || gameIndex > ${#keys[@]})); then
  echo 'wrong answer'
  # Use a while loop instead of exiting, if number is wrong then reprint options
  exit
fi

gameId=${keys[$gameIndex - 1]}
echo $gameId

# If temp dir doesn't exist, create it
if [ ! -d $tempDir ]; then
  echo 'cant find dir'
  mkdir "$tempDir"
fi

# Copy all files associated with gameId to temp dir
cp $path/*"$gameId"* "$tempDir"

# Rename files as need
# Game file needs to end with appropriate file extension
# Save file needs to be named same as Game file with its own appropriate file extension
for file in $(ls $tempDir); do
  echo $file
  case "$file" in 
    Game-*-game)
      echo 'Found Game'
      ;;
    *)
      echo 'Found not game'
      ;;
  esac
done
# rm $tempDir/*

# echo ${myObj[]}
# echo $keys
# echo ${keys:$gameIndex-1:$gameIndex}

# for key in "${!myObj[@]}"; do 
#   echo "Key: $key, Value: ${myObj[$key]}"
# done

# files=($(ls "$path" | grep "Game-[0-9a-zA-Z]\+$"))
# 
# for line in $(seq 1 $((${#files[@]}))); do
#   printf "$line: ${files[$line - 1]}\n"
#   cat "$path/${files[$line - 1]}"
#   printf "\n\n"
# done
