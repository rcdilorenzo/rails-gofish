describe "Message", ->
  beforeEach ->
    context = null
    arrayOfMessages = ["Hello, how are you doing?", "Hola, como hace usted?"]
    @message = new Message(arrayOfMessages)

  it "should create text with specified style + default values", ->
    expect(@message.text).toEqual(["Hello, how are you doing?", "Hola, como hace usted?"])
    @message.draw(null, null, null, {color: [255, 0, 0]})
    expect(@message.parameters).toEqual({
      color: [0, 0, 0],
      delay: 1,
      speed: 5,
      font: 'American Typewriter',
      fontWeight: '',
      fontSize: '16pt',
      fade: true,
      maxWidth: 450,
      fontSizeNumber: 16
    })

  it "should be able to draw", ->
    expect(@message.draw(null, null, null)).not.toBe(null)
