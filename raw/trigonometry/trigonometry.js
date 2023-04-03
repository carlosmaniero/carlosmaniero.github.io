(() => {
  document.addEventListener('DOMContentLoaded', () => {
    const $canvas = document.getElementById("canvas")
    const hasMultitouch = 'maxTouchPoints' in navigator && navigator.maxTouchPoints > 1
    const instructionText = hasMultitouch
          ? "Use a two-finger gesture to control the drawing."
          : "Move your mouse or click to define the position of the circle."

    let baseCircleSize
    let initialPositionX
    let initialPositionY

    const setDefaults = () => {
      $canvas.width = window.innerWidth
      $canvas.height = window.innerHeight

      baseCircleSize = Math.floor(Math.min(window.innerHeight, window.innerWidth, 200 / 0.4) * 0.4) // 80% of screen size

      initialPositionX = $canvas.width / 2
      initialPositionY = $canvas.height / 2
    }

    setDefaults()

    let clientX = initialPositionX
    let clientY = initialPositionY

    const $context = $canvas.getContext('2d')

    const drawInstructions = () => {
      $context.fillStyle = 'white'
      $context.font = "12px sans-serif"
      $context.fillText(instructionText, 12, 28)
    }

    const drawPoint = (imageData, color, x, y) => {
      if (x > imageData.width - 1 || y > imageData.height - 1 || x < 1 || y < 1) {
        return
      }
      const index = (Math.round(y) * imageData.width + Math.round(x)) * 4
      imageData.data[index] = color
      imageData.data[index + 1] = color
      imageData.data[index + 2] = color
      imageData.data[index + 3] = 255
    }

    const fullTurnInRadians = 2 * Math.PI

    const numberOfPixelsRequiredToRenderACircleWithRadius = (radius) => {
      const perimiter = radius * 2 * Math.PI
      return fullTurnInRadians / perimiter
    }

    const drawCircle = (imageData, color, radius, [x, y]) => {
      const factor = numberOfPixelsRequiredToRenderACircleWithRadius(radius)

      for(let radians = 0; radians < fullTurnInRadians; radians += factor) {
        drawPoint(imageData, color, Math.cos(radians) * radius + x, Math.sin(radians) * radius + y)
      }
    }


    const draw = (currentClientX, currentClientY) => {
      if (currentClientX != clientX || currentClientY != clientY) {
        return
      }

      $context.clearRect(0, 0, $canvas.width, $canvas.height)

      const imageData = $context.createImageData($canvas.width, $canvas.height)

      for(let i = 0; i <= baseCircleSize; i += baseCircleSize / 100) {
        const factor = 1 - (i / baseCircleSize)
        const color = Math.round((i / baseCircleSize) * 255)

        drawCircle(imageData, color, i, [initialPositionX + ((clientX - initialPositionX) * factor),
                       initialPositionY + ((clientY - initialPositionY) * factor)])
      }
      $context.putImageData(imageData, 0, 0)

      drawInstructions()
    }

    const animate = () => {
      draw(clientX, clientY)
      requestAnimationFrame(animate)
    }

    animate()

    document.addEventListener('click', (e) => {
      clientX = initialPositionX = e.clientX
      clientY = initialPositionY = e.clientY
    })

    document.addEventListener('mousemove', (e) => {
      clientX = e.clientX
      clientY = e.clientY
    })

    document.addEventListener('touchmove', (e) => {
      e.preventDefault()
      clientX = e.touches[0].clientX
      clientY = e.touches[0].clientY

      if (e.touches[1]) {
        initialPositionX = e.touches[1].clientX
        initialPositionY = e.touches[1].clientY
      }
    })
    window.addEventListener('resize', () => setDefaults())
  })
})()
