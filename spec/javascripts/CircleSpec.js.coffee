describe "Circle", ->
  beforeEach ->
    @circle = new Circle(100, 50, 20, {fillStyle: 'red'})

  
  it "should create a circle with the prescribed arguments", ->
    expect(@circle.radius).toBe(20)
    expect(@circle.x).toBe(100)
    expect(@circle.y).toBe(50)
    expect(@circle.properties).toBe({fillStyle: 'red'})
