echo 'start delta-sync'

# path='/home/ted/Dropbox/Delta Emulator'
path='/home/ted/Downloads/GBA Roms/Delta-Emulator-Data/vault'

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

files=$(ls "$path")
fileIds=()
for file in $files; do
  if [[ $file =~ Game-([0-9a-zA-Z]+)$ ]]; then
    echo "file: $file"
    echo "id: ${BASH_REMATCH[1]}"
    # echo $(cat "$path/$file" | grep -o "\"name\":\"[^\"]\+\"")
    echo $(cat "$path/$file" | grep -Po '"name":"[^"]+"')
    printf "\n\n"
  fi
done

# files=($(ls "$path" | grep "Game-[0-9a-zA-Z]\+$"))
# 
# for line in $(seq 1 $((${#files[@]}))); do
#   printf "$line: ${files[$line - 1]}\n"
#   cat "$path/${files[$line - 1]}"
#   printf "\n\n"
# done
