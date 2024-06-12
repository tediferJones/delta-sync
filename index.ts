import { readdir } from 'fs/promises';

interface Test {
  path?: string,
  info?: object,
}

interface Games {
  [key: string]: {
    // [key: string]: Test,
    // game: Test,
    // save: Test,
    [key: string]: any
    // game?: string,
    // savesave?: string,
    // info?: {
    //   gamesave?: any,
    //   game?: any,
    // }
  }
}

const dropboxPath = '/home/ted/Dropbox/Delta Emulator/';
const dir = await readdir(dropboxPath)
const games: Games = {};
// dir.forEach(file => {
//   // const match = file.match(/^Game(?:Save)?-([\w\d]+)/)
//   if (file.match(/\.gba$/)) return
//   const match = file.match(/^(\w+)-([\w\d]+)-?(\w+)?/)
//   console.log(match, file)
//   if (match) {
//     const [full, prefix, id, suffex] = match; 
//     if (!games[id]) games[id] = {};
//     if (suffex) {
//       games[id][prefix.toLowerCase()] = full
//     } else {
//       if (!games[id].info) games[id].info = {}
//       games[id].info[prefix] = full
//       // games[id].info[prefix] = await Bun.file(dropboxPath + full).text()
//     }
//   }
// })

await Promise.all(dir.map(async file => {
  if (file.match(/\.gba$/)) return
  const match = file.match(/^(\w+)-([\w\d]+)-?(\w+)?/)
  // console.log(match, file)
  if (match) {
    const [full, prefix, id, suffex] = match; 
    if (!games[id]) games[id] = { game: {}, save: {} };
    // games[id]
    //   [prefix.toLowerCase()]
    //   [suffex ? 'path' : 'info'] = (
    //     suffex ? full : await Bun.file().text()
    //   )
    if (suffex) {
      games[id][prefix.toLowerCase()] = full
    } else {
      if (!games[id].info) games[id].info = {}
      // games[id].info[prefix] = full
      const readFile = await Bun.file(dropboxPath + full).text()
      games[id].info[prefix.toLowerCase()] = JSON.parse(readFile)

      return readFile
      // games[id].info[prefix] = await Bun.file(dropboxPath + full).text()
    }
  }
}))

// console.log(games)
Object.keys(games).forEach(id => {
  console.log('TITLE:', games[id].info.game.record.name)
  // console.log('gamePath', games[id].game)
  // console.log('gamesavePath', games[id].gamesave)
  // console.log('gameInfo', games[id].info)
})

