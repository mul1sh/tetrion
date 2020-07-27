import { blockType, StorageKey } from './const'
const hiddenProperty = (() => {
  let names = ['hidden', 'webkitHidden', 'mozHidden', 'msHidden']
  names = names.filter(e => e in document)
  return names.length > 0 ? names[0] : false
})()
const unit = {
  getNextType() {
    const len = blockType.length
    console.log("len for next type is", len)
    const randomNext = Math.floor(Math.random() * len)
    console.log("random next is ", randomNext)
    return blockType[randomNext]
  },
  want(next, matrix) {
  
    const xy = next.xy
    const shape = next.shape
    const horizontal = shape[0].length
    return shape.every((m, k1) =>
      m.every((n, k2) => {
        if (xy[1] < 0) {
          // left
          return false
        }
        if (xy[1] + horizontal > 10) {
          // right
          return false
        }
        if (xy[0] + k1 < 0) {
          // top
          return true
        }
        if (xy[0] + k1 >= 20) {
          // bottom
          return false
        }
        if (n) {
          if (matrix[xy[0] + k1][xy[1] + k2]) {
            return false
          }
          return true
        }
        return true
      })
    )
  },
  isClear(matrix) {

    const clearLines = []
    matrix.forEach((m, k) => {
      if (m.every(n => !!n)) {
        clearLines.push(k)
      }
    })
    if (clearLines.length === 0) {
      return false
    }
    return clearLines
  },
  isOver(matrix) {
  
    return matrix[0].some(n => !!n)
  },
  subscribeRecord(store) {
  
    store.subscribe(() => {
      let data = store.state
      if (data.lock) {
        return
      }
      data = JSON.stringify(data)
      data = encodeURIComponent(data)
      if (window.btoa) {
        data = btoa(data)
      }
      window.localStorage.setItem(StorageKey, data)
    })
  },
  isMobile() {
    const ua = navigator.userAgent
    const android = /Android (\d+\.\d+)/.test(ua)
    const iphone = ua.indexOf('iPhone') > -1
    const ipod = ua.indexOf('iPod') > -1
    const ipad = ua.indexOf('iPad') > -1
    const nokiaN = ua.indexOf('NokiaN') > -1
    return android || iphone || ipod || ipad || nokiaN
  },
  visibilityChangeEvent: (() => {
    if (!hiddenProperty) {
      return false
    }
    return hiddenProperty.replace(/hidden/i, 'visibilitychange')
  })(),
  isFocus: () => {
    if (!hiddenProperty) {
      return true
    }
    return !document[hiddenProperty]
  }
}
export const {
  getNextType,
  isMobile,
  want,
  isClear,
  isOver,
  subscribeRecord,
  visibilityChangeEvent,
  isFocus
} = unit
