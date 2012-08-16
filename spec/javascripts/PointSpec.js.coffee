describe "Point", ->
  beforeEach ->
    @point = new Point(10, 5)

  it "should return x and y", ->
    expect(@point.x()).toBe(10)
    expect(@point.y()).toBe(5)
