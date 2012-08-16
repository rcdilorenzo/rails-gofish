describe "RoundedRectangle", ->
  beforeEach ->
    @rect = new RoundedRectangle(300, 300, 140, 200, 10)

  it "should contain relevent point", ->
    expect(@rect.contains(new Point(320, 320))).toBe(true)
