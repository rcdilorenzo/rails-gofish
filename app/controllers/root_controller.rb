class RootController < ApplicationController
  # index.erb
  def index
    ranks = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King', 'Ace']
    suits = ['Clubs', 'Diamonds', 'Hearts', 'Spades']
    @imgStrings = []
    for rank in ranks
      for suit in suits
        if rank.class == Fixnum
          @imgStrings.push("./assets/#{suit[0].downcase}#{rank}.png")
        else
          @imgStrings.push("./assets/#{suit[0].downcase}#{rank[0].downcase}.png")
        end
      end
    end
    @imgStrings.push("./assets/backs_blue.png")
    @imgStrings.push("./assets/backs_red.png")
    # render :graphics
  end

  def drawing
    puts params
    render :text => ''
  end
end
