describe "Point", ->
  beforeEach ->
    @point = new Point(10, 5)
    @anotherPoint = new Point(15, 20)

  it "should return x and y", ->
    expect(@point.x()).toBe(10)
    expect(@point.y()).toBe(5)

  it "subtracts from another point", ->
    offsetPoint = @point.offsetBy(new Point(2, 2))
    expect(offsetPoint.x()).toBe(12)
    expect(offsetPoint.y()).toBe(7)

  it "offsets x from another point", ->
    offsetPoint = @anotherPoint.offsetByX(10)
    expect(offsetPoint.x()).toBe(25)
    expect(offsetPoint.y()).toBe(20)

  it "offsets y from another point", ->
    offsetPoint = @anotherPoint.offsetByY(10)
    expect(offsetPoint.x()).toBe(15)
    expect(offsetPoint.y()).toBe(30)

