filename = 'flash_cards.txt'
file = File.open(filename, 'r').read
lines = []
file.each_line do |line|
  lines << line.chomp.split(',')
end

# trivia/flash card
class Card
  attr_accessor :question, :answer, :category

  def initialize(question, answer, category)
    @question = question
    @answer = answer
    @category = category
  end
end

# turn evaluates the guess
class Turn
  attr_accessor :guess, :card

  def initialize(guess, card)
    @guess = guess
    @card = card
  end

  def correct?
    @guess == @card.answer
  end

  def feedback
    if correct?
      'Correct!'
    else
      'Incorrect.'
    end
  end
end

# deck of Cards
class Deck
  attr_accessor :cards, :count

  def initialize(cards)
    @cards = cards
    @count = cards.length
  end

  def cards_in_category(category)
    list = []
    @cards.each do |card|
      list << card if card.category == category
    end
    list
  end
end

# make guess, store results, move to next Card in Deck
class Round
  attr_accessor :deck, :count, :current_card, :turns, :number_correct

  def initialize(deck)
    @deck = deck
    @count = 0
    @current_card = @deck.cards[@count]
    @turns = []
    @number_correct = 0
    @totals = {}
    puts "Welcome! You're playing with #{@deck.count} cards."
  end

  def start
    @deck.cards.each do
      take_turn
    end
    puts 'GAME OVER'
    puts "You had #{@number_correct} correct guesses out of #{@deck.count} for a total score of #{percent_correct.to_i}%."
    @totals.keys.each do |key|
      puts "#{key} - #{percent_correct_by_category(key)}% correct."
    end
  end

  def take_turn
    puts "This is card number #{@count + 1} out of #{deck.count}."
    puts @current_card.question
    guess = gets.chomp
    current_turn = Turn.new(guess, @current_card)
    puts current_turn.feedback
    totals_update(current_turn.card.category, current_turn.correct?)
    @number_correct += 1 if current_turn.correct?
    @turns << current_turn
    @count += 1
    @current_card = @deck.cards[@count]
  end

  def totals_update(category, correct_bool)
    if @totals[category]
      @totals[category][:total] += 1
    else
      @totals[category] = { total: 1, number_correct: 0 }
    end
    @totals[category][:number_correct] += 1 if correct_bool
  end

  def number_correct_by_category(category)
    @totals[category][:number_correct]
  end

  def percent_correct
    @percent_correct = @number_correct.to_f / @count.to_f * 100
  end

  def percent_correct_by_category(category)
    if (@totals[category][:total]).zero?
      0.0
    else
      @totals[category][:number_correct].to_f / @totals[category][:total].to_f * 100
    end
  end
end

# card1 = Card.new('What is the capital of Alaska?', 'Juneau', :Geography)
# card2 = Card.new('The Viking spacecraft sent back to Earth photographs and reports about the surface of which planet?', 'Mars', :STEM)
# card3 = Card.new('Describe in words the exact direction that is 697.5 degrees clockwise from due north?', 'North north west', :STEM)
card1 = Card.new(lines[0][0], lines[0][1], lines[0][2])
card2 = Card.new(lines[1][0], lines[1][1], lines[1][2])
card3 = Card.new(lines[2][0], lines[2][1], lines[2][2])
deck = Deck.new([card1, card2, card3])
round = Round.new(deck)
round.start
