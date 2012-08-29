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
  
  it "compares two points for their difference", ->
    expect(@anotherPoint.differenceTo(@point)).toEqual(new Point(-5, -15))
    expect(@point.differenceTo(@anotherPoint)).toEqual(new Point(5, 15))

  it "calculates whether two points are equal", ->
    expect(@point.isEqualTo(@anotherPoint)).toBeFalsy()
    @anotherPoint = new Point(10, 5)
    expect(@point.isEqualTo(@anotherPoint)).toBeTruthy()

  it "calculates whether a point is greater than another", ->
    expect(@point.isGreaterThanOrEqualTo(@anotherPoint)).toBeFalsy()
    expect(@anotherPoint.isGreaterThanOrEqualTo(@point)).toBeTruthy()
