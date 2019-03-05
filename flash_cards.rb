class Card
  attr_accessor :question, :answer, :category

  def initialize(question, answer, category)
    @question = question
    @answer = answer
    @category = category
  end
end

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

class Deck
  attr_accessor :cards, :count

  def initialize(cards)
    @cards = cards
    @count = cards.length
  end

  def cards_in_category(category)
    list = []
    @cards.each do |card|
      if card.category == category
        list << card
      end
    end
    list
  end
end

class Round
  attr_accessor :deck, :count, :current_card, :turns, :number_correct

  def initialize(deck)
    @deck = deck
    @count = 0
    @current_card = @deck.cards[@count]
    @turns = []
    @number_correct = 0
    @totals = {}
  end

  def take_turn(guess)
    current_turn = Turn.new(guess, @current_card)
    totals_update(current_turn.card.category, current_turn.correct?)
    if current_turn.correct?
      @number_correct += 1
    end
    @turns << current_turn
    @count += 1
    @current_card = @deck.cards[@count]
  end

  def totals_update(category, correct_bool)
    if @totals[category]
      @totals[category][:total] += 1
      if correct_bool
        @totals[category][:number_correct] += 1
      end
    else
      @totals[category] = {:total => 1, :number_correct => 0}
      if correct_bool
        @totals[category][:number_correct] += 1
      end
    end
  end

  def number_correct_by_category(category)
    @totals[category][:number_correct]
  end

  def percent_correct
    @percent_correct = @number_correct.to_f / @count.to_f * 100
  end

  def percent_correct_by_category(category)
    if @totals[category][:total] == 0
      0.0
    else
      @totals[category][:number_correct].to_f / @totals[category][:total].to_f * 100
    end
  end
end

card_1 = Card.new('What is the capital of Alaska?', 'Juneau', :Geography)
card_2 = Card.new('The Viking spacecraft sent back to Earth photographs and reports about the surface of which planet?', 'Mars', :STEM)
card_3 = Card.new('Describe in words the exact direction that is 697.5° clockwise from due north?', 'North north west', :STEM)
deck = Deck.new([card_1, card_2, card_3])
round = Round.new(deck)
round.take_turn('Juneau')
round.take_turn('Venus')
puts round.percent_correct_by_category(:Geography)
puts round.current_card
