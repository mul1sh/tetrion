import store from '../vuex/store'

const AudioContext =
  window.AudioContext ||
  window.webkitAudioContext ||
  window.mozAudioContext ||
  window.oAudioContext ||
  window.msAudioContext

export const hasWebAudioAPI = {
  data: !!AudioContext && location.protocol.indexOf('http') !== -1
}

export const music = {}
;(() => {
  if (!hasWebAudioAPI.data) {
    return
  }
  const url = './static/music.mp3'
  const context = new AudioContext()
  const req = new XMLHttpRequest()
  req.open('GET', url, true)
  req.responseType = 'arraybuffer'

  req.onload = () => {
    context.decodeAudioData(
      req.response,
      buf => {
        const getSource = () => {

          const source = context.createBufferSource()
          source.buffer = buf
          source.connect(context.destination)
          return source
        }

        music.killStart = () => {
          
          music.start = () => {}
        }

        music.start = () => {
        
          music.killStart()
          if (!store.state.music) {
            return
          }
          getSource().start(0, 3.7202, 3.6224)
        }

        music.clear = () => {
       
          if (!store.state.music) {
            return
          }
          getSource().start(0, 0, 0.7675)
        }

        music.fall = () => {
       
          if (!store.state.music) {
            return
          }
          getSource().start(0, 1.2558, 0.3546)
        }

        music.gameover = () => {
        
          if (!store.state.music) {
            return
          }
          getSource().start(0, 8.1276, 1.1437)
        }

        music.rotate = () => {

          if (!store.state.music) {
            return
          }
          getSource().start(0, 2.2471, 0.0807)
        }

        music.move = () => {

          if (!store.state.music) {
            return
          }
          getSource().start(0, 2.9088, 0.1437)
        }
      },
      error => {
        if (window.console && window.console.error) {
          window.console.error(`音频: ${url} 读取错误`, error)
          hasWebAudioAPI.data = false
        }
      }
    )
  }

  req.send()
})()
