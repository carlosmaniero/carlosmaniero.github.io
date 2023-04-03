(() => {
  document.addEventListener('DOMContentLoaded', () => {
    const $canvas = document.getElementById("canvas")
    const hasMultitouch = 'maxTouchPoints' in navigator && navigator.maxTouchPoints > 1
    const instructionText = hasMultitouch
          ? "Use a two-finger gesture to control the drawing."
          : "Move your mouse or click to define the position of the circle."

    $canvas.width = window.innerWidth
    $canvas.height = window.innerHeight

    let initialPositionX = window.innerWidth / 2
    let initialPositionY = window.innerHeight / 2

    let clientX = initialPositionX
    let clientY = initialPositionY

    const $context = $canvas.getContext('2d')

    const drawInstructions = () => {
      $context.font = "12px sans-serif"
      $context.fillText(instructionText, 50, 50)
    }

    const drawPoint = (x, y) => {
      $context.fillRect(x, y, 1, 1)
    }

    const fullTurnInRadians = 2 * Math.PI

    const numberOfPixelsRequiredToRenderACircleWithRadius = (radius) => {
      const perimiter = radius * 2 * Math.PI
      return fullTurnInRadians / perimiter
    }

    const drawCircle = (radius, [x, y]) => {
      const factor = numberOfPixelsRequiredToRenderACircleWithRadius(radius)

      for(let radians = 0; radians < fullTurnInRadians; radians += factor) {
        drawPoint(Math.cos(radians) * radius + x, Math.sin(radians) * radius + y)
      }
    }

    const draw = (currentClientX, currentClientY) => {
      if (currentClientX != clientX || currentClientY != clientY) {
        return
      }

      $context.clearRect(0, 0, $canvas.width, $canvas.height)

      const baseCircleSize = 100

      for(let i = 0; i <= baseCircleSize; i += baseCircleSize / 100) {
        const factor = 1 - (i / 100)
        const color = Math.floor((i / 100) * 0xff).toString(16).padStart(2, '0')
        $context.fillStyle = "#" + color + color + color

        drawCircle(i, [initialPositionX + ((clientX - initialPositionX) * factor),
                       initialPositionY + ((clientY - initialPositionY) * factor)])
      }
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
  })
})()
