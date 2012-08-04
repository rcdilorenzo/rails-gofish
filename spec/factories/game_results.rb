# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game_result do
    user

    after(:build) do |result|
      result.game = GoFishGame.new(result.user.name, "Bob") # FactoryGirl.build(:game)
    end
  end  
end

# FactoryGirl.define do
#   factory :ended_game_result do
#     user
    
#     after(:build) do |result|
#       result.game = FactoryGirl.build(:ended_game_with_single_winner)
#       result.winner = result.game.winner
#       game_player_index = 0
#       result.game.players.each do |player|
#         player_score = Score.new
#         player_score.player_index = game_player_index
#         player_score.score = player.books.size
#         player_score.game_result = result.game
#         game_player_index += 1
#         result.player_scores << player_score
#       end
#       puts result.inspect
#     end
#   end
# end

