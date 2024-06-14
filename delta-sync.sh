echo 'start delta-sync'

# path='/home/ted/Dropbox/Delta Emulator'
path='/home/ted/Downloads/GBA Roms/Delta-Emulator-Data/vault'

# We only need to track gameId, title, and index
# We can load games from dropbox, but cant save games to dropbox

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
