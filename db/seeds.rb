[
  {
    display: "General",
    rank: "general",
    value: 8,
    action: Action.new(
      behavior: "LoseIfDiscarded",
      display: "Lose if discarded.",
    ),
  },
  {
    display: "Colonel",
    rank: "colonel",
    value: 7,
    action: Action.new(
      behavior: "MustBePlayed",
      display: "Must be played if you have Major or Captain in hand.",
    ),
  },
  {
    display: "Major",
    rank: "major",
    value: 6,
    action:   Action.new(
      behavior: "TradeHands",
      display: "Trade hands with another player.",
    ),
  },
  {
    display: "Captain",
    rank: "captain",
    value: 5,
    action: Action.new(
      behavior: "ChoosePlayerNewHand",
      display: "Choose a player. They discard their hand and draw a new card.",
    ),
  },
  {
    display: "Lieutenant",
    rank: "lieutenant",
    value: 4,
    action: Action.new(
      behavior: "CannotBeChosen",
      display: "You cannot be chosen until your next turn.",
    ),
  },
  {
    display: "Sergeant",
    rank: "sergeant",
    value: 3,
    action: Action.new(
      behavior: "CompareLowerOut",
      display: "Compare hands with another player; lower number is out.",
    ),
  },
  {
    display: "Corporal",
    rank: "corporal",
    value: 2,
    action: Action.new(
      behavior: "SeeOtherHand",
      display: "Look at a player's hand.",
    ),
  },
  {
    display: "Private",
    rank: "private",
    value: 1,
    action: Action.new(
      behavior: "GuessAndKnockOut",
      display: "Guess a player's hand; if correct the player is out.",
    ),
  },
].each { |c| Character.create(c) }
