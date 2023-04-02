(() => {
  document.addEventListener('DOMContentLoaded', () => {
    const $canvas = document.getElementById("canvas")

    $canvas.width = window.innerWidth
    $canvas.height = window.innerHeight

    let initialPositionX = window.innerWidth / 2
    let initialPositionY = window.innerHeight / 2

    const $context = $canvas.getContext('2d')

    const drawInstructions = () => {
      $context.font = "12px sans-serif";
      $context.fillText("Move your mouse or click to define the position of the circle.", 50, 50)
    }

    const drawPoint = (x, y) => {
      $context.fillRect(x, y, 1, 1)
    }


    const drawCircle = (size, [x, y]) => {
      for(let angle = 0; angle < 360; angle += 1) {
        drawPoint(Math.cos(angle) * size + x, Math.sin(angle) * size + y)
      }
    }

    const draw = (clientX, clientY) => {
      $context.clearRect(0, 0, $canvas.width, $canvas.height)

      const baseCircleSize = 100

      for(let i = 0; i <= baseCircleSize; i += baseCircleSize / 100) {
        const factor = 1 - (i / 100)
        const color = Math.floor(factor * 0xff).toString(16).padStart(2)
        $context.fillStyle = "#" + color + color + color

        drawCircle(i, [initialPositionX + ((clientX - initialPositionX) * factor),
                       initialPositionY + ((clientY - initialPositionY) * factor)])
      }
      drawInstructions()
    }

    drawInstructions()

    document.addEventListener('click', (e) => {
      initialPositionX = e.clientX
      initialPositionY = e.clientY
      draw(e.clientX, e.clientY)
    })

    document.addEventListener('mousemove', (e) => {
      draw(e.clientX, e.clientY)
    })
  })
})()
