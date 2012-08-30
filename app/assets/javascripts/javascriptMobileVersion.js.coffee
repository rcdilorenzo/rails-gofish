$ ->
  signupForm = $('#new-user')[0]
  if signupForm
    signupForm.setAttribute('id', '') if window.innerWidth < 450
    $(window).resize( =>
      signupForm.setAttribute('id', '') if window.innerWidth < 450
      signupForm.setAttribute('id', 'new-user') if window.innerWidth >= 450
    )

  board = $('#board')[0]
  if board
    board.setAttribute('id', '') if window.innerWidth < 450
    $(window).resize( =>
      board.setAttribute('id', '') if window.innerWidth < 450
      board.setAttribute('id', 'board') if window.innerWidth >= 450
    )
#     console.log($('html'))
#       board.setAttribute('style', "margin-left:#{window.innerWidth/2 - parseInt(board.getAttribute('width')[0..-3])/2}px")
#     console.log($('html'))
#       board.setAttribute('style', "margin-left:#{window.innerWidth/2 - parseInt(board.getAttribute('width')[0..-3])/2}px")
