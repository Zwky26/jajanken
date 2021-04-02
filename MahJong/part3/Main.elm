{-Zack Wang Mahjong Final Project -}
module Main exposing (..)

import Browser
import Browser.Events
import Browser.Dom
import Json.Decode as Decode
import Html exposing (..)
import Html.Attributes as Attr
import Task
import Tuple
import Dict.Extra as DictExtra
import Dict as Dict
import Array 

import Random.List as RL
import Random

import Collage exposing (..)
import Collage.Events exposing (onClick, onDoubleClick)
import Collage.Layout exposing (..)
import Collage.Render exposing (svg)
import Collage.Text as Text exposing (..)
import Color exposing (..)

-- MAIN

{- we need no flags, init makes dummy width and height
sends commands to fetch viewport, update actual dimensions of 
window and make the deck data structure-}

type alias Flags = 
  ()

init : Flags -> (Model, Cmd Msg)
init () =
  (
     { mode = "Starting" 
     , width = 5
     , height = 5
     , player1 = colPlayer p1Red
     , player2 = colPlayer p2Green
     , player3 = colPlayer p3Pink
     , player4 = colPlayer p4Orange
     , deck = []
     , discard = []
     , clicked = []
     , currentPlayer = 1
     , currentPhase = Starting
     , pongingPlayer = 0
     , pongingTile = (0, "")
     , storedInd = -1
     }
    , Cmd.batch [
        (Task.perform GetView Browser.Dom.getViewport)
        , initDeck
      ]
  )

main : Program Flags Model Msg
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- MODEL -------------------------------------------------

{- our model stores the phase (playing, game over, starting, or awaiting a pong),
dimensions of window, respective hands/deck for each player, 
currently selected tiles, current player, and some other info for 
ponging to save info -}

type alias Model = 
  { mode : String
  , width : Int
  , height : Int
  , player1 : Player
  , player2 : Player
  , player3 : Player
  , player4 : Player
  , deck : Deck
  , discard : Deck
  , clicked : List Int
  , currentPlayer : Int
  , currentPhase : Phase
  , pongingPlayer : Int
  , pongingTile : Tile
  , storedInd : Int
  }


type Phase = 
  Playing | GameOver | Starting | AwaitingPong | Won

{- the hand is a list for displaying, as a dictionary of frequencies for
checking things quickly. locked are tiles that 
you cannot change, pongAble are cached values of tiles
that can be ponged if they come up. backCol is color scheme -}
type alias Player = 
  { handAsList : Hand
  , handAsDict : Dict.Dict (Int, String) Int
  , locked : Hand
  , pongAble : List Tile
  , backCol : Color
  }

{-blank player, only used for init -}
nullPlayer : Player
nullPlayer = 
  { handAsList = []
  , handAsDict = Dict.empty
  , locked = []
  , pongAble = []
  , backCol = white
  }

colPlayer : Color -> Player
colPlayer c = 
  {nullPlayer | backCol = c}

-- VIEW ---------------------------------------------

{-using collage to make image, broken into sections 
corresponding to players -}

{- makes the view depending on mode 
standardView is almost always used, with a popup over it sometimes-}

view : Model -> Html Msg
view model = 
  case model.currentPhase of
    Starting -> 
      overlay model (popUp model "starting") |> svg
    GameOver -> overlay model (popUp model "draw") |> svg
    Won -> winningImage model |> svg
    Playing -> 
      (standardView model) |> svg
    AwaitingPong -> 
      overlay model (popUp model "pong") |> svg

{-layers a popup onto the standardView -}
overlay : Model -> Collage Msg -> Collage Msg
overlay model fore = 
  stack [fore , center (opacity 0.4 (standardView model))] 
 
{- makes a popup over the screen
popups occur when a player decides to pong, when the game
hasnt started, or when its over -}
popUp : Model -> String -> Collage Msg
popUp model mode = 
  let 
    w = toFloat model.width
    h = toFloat model.height
  in
  case mode of
    "starting" ->
      image (w * 0.8, h * 0.8) "tileImg/startingPopUp.png" 
    "draw" ->
      image (w * 0.8, h * 0.8) "tileImg/draw.png"
    _ -> makePongStatement model

{- custom pong popup for each player name -}
makePongStatement : Model -> Collage Msg
makePongStatement m =
  let
    w = toFloat m.width
    h = toFloat m.height
    discT = m.pongingTile
    decidingP = m.currentPlayer
    img = 
      case decidingP of
        1 -> "tileImg/marioPong.png"
        2 -> "tileImg/luigiPong.png"
        3 -> "tileImg/peachPong.png"
        _ -> "tileImg/daisyPong.png" 
  in
  stack [ tileToCollage 100 120 "faceup" discT
  , image (w * 0.5, h * 0.5) img] 

{- custom winning screen for each player, along with the winning hand -}
winningImage : Model -> Collage Msg
winningImage model =
  let 
    curr = model.currentPlayer
    str = 
      case curr of
        1 -> "tileImg/marioWin.png"
        2 -> "tileImg/luigiWin.png"
        3 -> "tileImg/peachWin.png"
        _ -> "tileImg/daisyWin.png" 
    p = getPlayer model curr 
    hand = center (horizontal (List.map (tileToCollage 180 200 "faceup") 
                              (p.handAsList ++ p.locked)))
    img = image (toFloat model.width, toFloat model.height) str
  in
  stack [hand, img]

{-view while playing the game. Collage made of a leftPlayer (player whose turn
is before you) topPlayer, rightPlayer (up next), and bottom toolbar, with your hand.
In the middle is the table with discarded tiles -}

standardView : Model -> Collage Msg
standardView model = 
  let
    w = toFloat model.width
    h = toFloat model.height 
    colSc = arrangePlayers model
    south = colSc.bottom
    west = colSc.left
    north = colSc.top
    east = colSc.right
  in
  ([ ([makeLeftPic w h west 
      , center (vertical [makeTopPic w h north 
                , makeTablePic w h model.discard]
               ) 
      , makeRightPic w h east] 
        |> List.map (align top)
        |> horizontal
      )
    , makeToolBar w h model south] 
      |> List.map (align left)
      |> vertical
   )

-- COLORS ------------------------------------------------

type alias ColorScheme = 
  { bottom : Player
  , left : Player
  , top : Player
  , right : Player
  }

{-custom color scheme in elm, could refactor in css but this works too -}
arrangePlayers : Model -> ColorScheme
arrangePlayers m = 
  case m.currentPlayer of
    1 ->
      { bottom = m.player1
      , left = m.player4
      , top = m.player3
      , right = m.player2
      }
    2 ->
      { bottom = m.player2
      , left = m.player1
      , top = m.player4
      , right = m.player3
      }
    3 -> 
      { bottom = m.player3
      , left = m.player2
      , top = m.player1
      , right = m.player4
      }
    _ -> 
      { bottom = m.player4
      , left = m.player3
      , top = m.player2
      , right = m.player1
      }

mahJongGreen : Color
mahJongGreen = 
  rgb255 62 120 5

p1Red : Color
p1Red = 
  rgb255 229 37 33

p2Green : Color
p2Green = 
  rgb255 67 176 71

p3Pink : Color
p3Pink =  
  rgb255 249 134 237

p4Orange: Color
p4Orange = 
  rgb255 254 207 55


----VISUAL HELPERS------------------------------
{-these make the collage for each of the regions. Left means the left 
rectangle, for the player clockwise to the current playe, who is always at the bottom 
of the screen -}

makeLeftPic : Float -> Float -> Player -> Collage Msg
makeLeftPic w h p =
  let 
    pic = rotate (degrees 270) 
              (horizontal (List.map (tileToCollage 100 120 "facedown") p.handAsList))
    picH = Collage.Layout.height pic
    locked = (rotate (degrees 270) (makeLocked p.locked)) |> align right
    hand = center (scale ((h * 0.55) / picH) pic)
    background = rectangle (w / 6) (2 * h / 3) |> styled (uniform p.backCol, solid thin (uniform black))
  in 
  if (List.length p.locked > 0) then
    stack [ hand, background] |> at right locked
  else 
    stack [hand, background]

makeTopPic : Float -> Float -> Player -> Collage Msg 
makeTopPic w h p =
  let
    pic = (rotate (degrees 180)
                   (horizontal (List.map (tileToCollage 100 120 "facedown") p.handAsList))) 
    picH = Collage.Layout.height pic
    locked = (rotate (degrees 180) (makeLocked p.locked)) |> align bottom
    hand = center (scale ((h * 0.1) / picH) pic) |> shift (0, 20)
    background = rectangle (2 * w / 3) (h / 5) |> styled (uniform p.backCol, solid thin (uniform black))
  in
  if (List.length p.locked > 0) then
    stack [ hand, background] |> at bottom locked
  else
    stack [hand, background]
 
makeRightPic : Float -> Float -> Player -> Collage Msg 
makeRightPic w h p =
  let
    pic = rotate (degrees 90) 
                    (horizontal (List.map (tileToCollage 100 120 "facedown") p.handAsList))
    picH = Collage.Layout.height pic
    locked = (rotate (degrees 90) (makeLocked p.locked)) |> align left
    hand = center (scale ((h * 0.55) / picH) pic)
    background = rectangle (w / 6) (2 * h / 3) |> styled (uniform p.backCol, solid thin (uniform black)) 
  in
  if (List.length p.locked > 0) then
    stack [ hand, background] |> at left locked
  else
    stack [hand, background]

makeTablePic : Float -> Float -> Deck -> Collage Msg
makeTablePic w h disc =
  stack [ (displayDeck (2 * w / 3)  (7 * h / 15) disc) 
  ,  
  rectangle (2 * w / 3) (7 * h / 15)
    |> styled
         ( uniform mahJongGreen
         , solid thin (uniform black)
         )
  ]

{-takes in long list of tiles in the discard, makes rows of 16.
will be used to display all discard tiles in the center -}
displayDeck : Float -> Float -> Deck -> Collage Msg
displayDeck w h disc =
  if (List.length disc > 16) then
    let
      first16 = List.take 16 disc
      first16Img = center (horizontal (List.map (tileToCollage 100 120 "faceup") first16))
      rest = List.drop 16 disc
    in
    center (vertical ((center first16Img) :: [displayDeck w h rest]))
  else 
    center (horizontal (List.map (tileToCollage 100  120 "faceup") disc))


---- CURRENT PLAYER DISPLAY --------------------------------------------
{-helper functions specifically for the current player -}

{-visual layering -}
makeToolBar : Float -> Float -> Model -> Player -> Collage Msg
makeToolBar w h model p =
  let
    hand = displayPlayerHand w h model p.handAsList
    locked = makeLocked p.locked |> align top
    background = rectangle w (h / 3) |> styled (uniform p.backCol, solid thin (uniform black))
  in
  if (List.length p.locked > 0) then
    stack [hand , background] |> at top locked
  else 
    stack [ hand, background] 

displayPlayerHand : Float -> Float -> Model -> Hand -> Collage Msg
displayPlayerHand w h model tiles = 
  center (horizontal (makePlayerHand 0 w h model tiles))

{-makes list of collages, each with a custom emitter for if its clicked
or double clicked -}
makePlayerHand : Int -> Float -> Float -> Model -> Hand -> List (Collage Msg)
makePlayerHand i w h model tiles = 
  case tiles of
    [] -> []
    t :: rest ->
      let
        tileImg = (tileToCollage (w / 15) (3 * h / 10) "faceup" t) 
                    |> onClick (Clicked i)
                    |> onDoubleClick (Discard i)
        shifted = 
          if (List.member i model.clicked) then
            shiftY 50 tileImg
          else tileImg
      in 
      shifted :: (makePlayerHand (i + 1) w h model rest)

--TILE TO COLLAGE ----------------------------------------------------------
{-helper functions that convert some list of tiles to either a locked
or a hand -}

makeLocked : List Tile -> Collage Msg
makeLocked l =
    let
      lock = image (100, 100) "tileImg/lock.png"
      tiles = List.map (tileToCollage 90 100 "faceup") l
    in 
    center (horizontal (lock :: tiles)) |> showOrigin 

{- makes a single collage for a tile. Note w and h mean the w h of the tile
not the region -}
tileToCollage : Float -> Float -> String -> Tile -> Collage Msg
tileToCollage w h mode tile = 
  case mode of
    "faceup" ->
      let
        suit = Tuple.second tile
        num = Debug.toString (Tuple.first tile)
      in
        image (w, h) (String.concat ["tileImg/", num, suit, ".jpg"])
    "facedown" ->
      roundedRectangle w h 5 
        |> styled (uniform black, solid thin (uniform white))
    _ -> Debug.todo "Impossible this func is internal only" 
 

-- SUBSCRIPTIONS ------------------------
{-basic subscriptions, taken from lecture notes -}

keyDecoder : Decode.Decoder String
keyDecoder =
  Decode.field "key" Decode.string

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Browser.Events.onMouseDown 
        (Decode.succeed MouseDown)
    , Browser.Events.onKeyDown
        (Decode.map (\key -> if (key == "Y") || (key == "y") then YDown 
                               else if (key == "N") || (key == "n") then NDown
                               else OtherKeyDown) 
         keyDecoder)
    ]

-- TILES ----------------------------------------------------
{-a tile has a numerical value and a suit. For nonnumerical tiles, 
the default number is set to 1 -}

type alias Tile = 
  (Int, Suit)

type alias Suit = 
  String

type alias Deck = 
  List Tile

{-this will run once per loading of the program, makes a long list and shuffles tiles -}
initDeck : Cmd Msg 
initDeck = 
  let 
    unshuffled =     
      (makePartialDeck 9 "Tiao") ++ 
      (makePartialDeck 9 "Bing") ++
      (makePartialDeck 9 "Wan") ++
      (makePartialDeck 1 "Dong") ++
      (makePartialDeck 1 "Nan") ++
      (makePartialDeck 1 "Xi") ++
      (makePartialDeck 1 "Bei") ++ 
      (makePartialDeck 1 "Zhong") ++
      (makePartialDeck 1 "FaCai")
  in 
  Random.generate FreshDeck (RL.shuffle unshuffled)

makePartialDeck : Int -> Suit -> List Tile
makePartialDeck i s = 
  if (i <= 0) then
    []
  else
    let 
      t = (i, s)
    in
    (List.repeat 4 t) ++ (makePartialDeck (i-1) s)

type alias Hand = 
  List Tile


-- UPDATE  --------------------------------------------------------

{-types of messages:
getView is ran at the start of init, refreshes window size
freshdeck makes a new deck and shuffles
ydown and ndown are for pong verification
clicked means a tile was clicked, if one already clicked swaps
discard means a tile was double clicked, discard that tile
drawtile is ran after discard, deals out a tile to player
-}

type Msg
  = MouseDown
  | YDown
  | NDown
  | OtherKeyDown
  | GetView Browser.Dom.Viewport
  | FreshDeck Deck
  | Clicked Int
  | Discard Int 
  | DrawTile 


{- most complicated part, will have inline comments for steps -}

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GetView vp ->
      ( {model | width = (round vp.scene.width)
               , height = (round vp.scene.height)}
      , Cmd.none
      )

{- freshdeck makes a set list of all tiles, shuffles it using dict.extra 
then it peels of 13 at a time, assigns them to player hands
this is done at the start of the game to "deal out" the hands -}

    FreshDeck d -> 
      let 
        hands = List.take 52 d
        restDeck = List.drop 52 d
        hand1 = List.take 13 hands
        afterHand1 = List.drop 13 hands 
        hand2 = List.take 13 afterHand1
        afterHand2 = List.drop 13 afterHand1 
        hand3 = List.take 13 afterHand2
        afterHand3 = List.drop 13 afterHand2 
        hand4 = List.take 13 afterHand3
      in
      ( {model | player1 = (updatePlayerHand model.player1 hand1)
               , player2 = (updatePlayerHand model.player2 hand2)
               , player3 = (updatePlayerHand model.player3 hand3)
               , player4 = (updatePlayerHand model.player4 hand4) 
               , deck = restDeck}
      , Cmd.none
      )

{-Clicked i happens when a tile in the toolbar was clicked 
if not currently Playing mode, does nothing. If Playing, we check if it 
was already clicked, if so it will be "unclicked". If one is already clicked
we swap the two tiles. Otherwise we add the index to clicked -}

    Clicked i ->
      case model.currentPhase of
        Playing ->
          if (List.member i model.clicked) then
            ({model | clicked = (List.filter (\x -> not (x == i)) model.clicked)} , Cmd.none)
          else if (List.length model.clicked) == 1 then
            (swapTiles model i, Cmd.none) 
          else
            ( {model | clicked = i :: model.clicked }
            , Cmd.none
            )
        _ -> (model, Cmd.none)

{-this happens when a tile is double clicked. This tile is removed from that
players hand, that player is updated, and then we check if it could be ponged 
or if it can be taken for the win. If it can, we save some info and move
into a new phase, where the player can decide if they want to take the tile
Otherwise, it gets added to the discard pool, the turns cycle, and 
we draw a tile for the next player -}

    Discard i ->
      case model.currentPhase of
        Playing ->
          let
            (t, oldP) = discardTile (getPlayer model model.currentPlayer) i
            pongCheck = checkIfWanted model t 
            winCheck = checkIfWon model t
          in
          if winCheck > 0 then
             let
               winningPlayer = getPlayer model winCheck
               newHand = t :: winningPlayer.handAsList 
               newModel = updatePlayerInMod model winCheck (updatePlayerHand winningPlayer newHand)
             in
            ({newModel | currentPlayer = winCheck
                   , currentPhase = Won}, Cmd.none)
          else if pongCheck > 0 then
            let
              newer = updatePlayerInMod model model.currentPlayer oldP
            in
            ({newer | currentPhase = AwaitingPong
                    , pongingTile = t
                    , pongingPlayer = model.currentPlayer
                    , currentPlayer = pongCheck
                    , storedInd = i}, Cmd.none)
          else 
            update DrawTile (discardModel model model.currentPlayer i) 
        _ -> (model, Cmd.none) 

{- this is internally called, after the turn changes. It takes a tile
from the deck and adds it to the current player's hand -}

    DrawTile ->
      (drawTile model, Cmd.none)

{-used to start the game, or start a new one after game over -}

    MouseDown ->
      case model.currentPhase of
        Starting -> 
          let 
            newModel = {model | currentPhase = Playing} 
          in
          update DrawTile newModel 
        GameOver ->
          init ()
        Won -> 
          init ()
        _ -> (model, Cmd.none)

{-used to confirm or decline a pong opportunity. If they
accept, we move the tile into locked, as well as two copies of that tile
from the hand into locked. It is then their turn to discard a tile, and regular play resumes. 
If they reject, we use the saved data in pongingPlayer, pongingTile to return
to regular play -}

    YDown ->
      case model.currentPhase of
        AwaitingPong ->
          (pongedModel model 
          , Cmd.none)
        _ -> (model, Cmd.none)
    NDown ->
      case model.currentPhase of
        AwaitingPong ->
          let 
            newModel = {model | currentPlayer = model.pongingPlayer
                              , currentPhase = Playing
                              , discard = model.pongingTile :: model.discard
                       } 
            newer = {newModel | currentPlayer = nextPlayer newModel}
          in
          update DrawTile newer
        _ -> (model, Cmd.none) 
    _ ->
      (model, Cmd.none)

--DISCARD AND PONG --------------------------------------------
{-convenience helper function, fetches a player from the model -}

getPlayer : Model -> Int -> Player
getPlayer m i =
  case i of
    1 -> m.player1
    2 -> m.player2
    3 -> m.player3
    _ -> m.player4

{-helper function that case matches the int to edit the corresponding 
player field -}

updatePlayerInMod : Model -> Int -> Player -> Model
updatePlayerInMod m i p =
  case i of
    1 -> {m | player1 = p}
    2 -> {m | player2 = p}
    3 -> {m | player3 = p}
    _ -> {m | player4 = p}

{-given input of player and array index
splits a player into the discarded tile and remaining hand -}
discardTile : Player -> Int -> (Tile, Player)
discardTile p i = 
  let
    oldHand = p.handAsList 
    newHalf = (List.take i oldHand) 
    secondHalf = List.drop i oldHand
    (discardedT, newSecond)  = 
      case secondHalf of
        x :: xs -> (x, xs)
        _ -> Debug.todo "Never"
    newHand = newHalf ++ newSecond
  in
  (discardedT, updatePlayerHand p newHand)

{-hideous but needs to be checked in this order 
because of ordering of turn priority. We check
each player in a counterclockwise order to see if 
they can potentially pong the tile given -}
checkIfWanted : Model -> Tile ->  Int
checkIfWanted m t =
  let
    onePongable = List.member t m.player1.pongAble
    twoPongable = List.member t m.player2.pongAble
    threePongable = List.member t m.player3.pongAble
    fourPongable = List.member t m.player4.pongAble
  in 
  case m.currentPlayer of
    1 -> returnFirst [(twoPongable, 2), (threePongable, 3), (fourPongable, 4)]
    2 -> returnFirst [(threePongable, 3), (fourPongable, 4), (onePongable, 1)]   
    3 ->  returnFirst [(fourPongable, 4), (onePongable, 1), (twoPongable, 2)]   
    _ -> returnFirst [(onePongable, 1), (twoPongable, 2), (threePongable, 3)] 

{- similar to checkIfWanted, except instead of checking if
each player can pong, we check if they can win with said tile.
It need not be a triple for the player to take it -}

checkIfWon : Model -> Tile -> Int
checkIfWon m t = 
  let
    oneWins = isWinningHand (incrDict m.player1.handAsDict t 1)
    twoWins = isWinningHand (incrDict m.player2.handAsDict t 1)
    threeWins = isWinningHand (incrDict m.player3.handAsDict t 1)
    fourWins = isWinningHand (incrDict m.player4.handAsDict t 1)
  in
  case m.currentPlayer of
    1 -> returnFirst [(twoWins, 2), (threeWins, 3), (fourWins, 4)]
    2 -> returnFirst [(threeWins, 3), (fourWins, 4), (oneWins, 1)]
    3 -> returnFirst [(fourWins, 4), (oneWins, 1), (twoWins, 2)]
    _ -> returnFirst [(oneWins, 1), (twoWins, 2), (threeWins, 3)]

{-helper function for testing checkIfWanted and checkIfWon -}

returnFirst : List (Bool, Int) -> Int
returnFirst ls = 
  case ls of
    [] -> 0
    (True, x) :: rest ->
      x
    (False, x) :: rest ->
      returnFirst rest

{- on the signal to discard, makes a new model with that discarded -}
discardModel : Model -> Int -> Int -> Model
discardModel m player i = 
 let newM = {m | currentPlayer = nextPlayer m
                , clicked = []}
 in
 case player of
   1 ->
     let (t, newP) = discardTile m.player1 i in 
     {newM | player1 = newP
        , discard = t :: m.discard
     }
   2 ->
     let (t, newP) = discardTile m.player2 i in 
     {newM | player2 = newP
        , discard = t :: m.discard
     }
   3 ->
     let (t, newP) = discardTile m.player3 i in 
     {newM | player3 = newP
        , discard = t :: m.discard
     }
   _ ->
     let (t, newP) = discardTile m.player4 i in 
     {newM | player4 = newP
        , discard = t :: m.discard
     }


{-on signal that pong was accepted, makes the new model -}
pongedModel : Model -> Model
pongedModel m = 
  let
    t = m.pongingTile
    curr = getPlayer m m.currentPlayer
    l = curr.locked
    newL = (List.repeat 3 t) ++ l
    filtered = List.filter (\x -> not (x == t)) curr.handAsList
    newH = 
      case (fetch t curr.handAsDict) of
        3 -> t :: filtered
        _ -> filtered
    updatedPlayer = updatePlayerHand curr newH
    newPlayer = {updatedPlayer | locked = newL}  
    newM = {m | currentPhase = Playing}
  in
  updatePlayerInMod newM m.currentPlayer newPlayer

-- HELPER FUNCS ---------------------------------------------

{- rotates the current player counterclockwise -}
nextPlayer : Model -> Int
nextPlayer m = 
  let 
    current  = m.currentPlayer
  in
  if (current + 1) > 4 then
    1
  else 
    current + 1

{-pass in some hand, will update all fields of the player-}
updatePlayerHand : Player -> Hand -> Player
updatePlayerHand p h = 
  let
    newHand = DictExtra.frequencies h
  in
  {p | handAsList = h
     , handAsDict = newHand
     , pongAble = Dict.keys (Dict.filter (\_ v -> v >= 2) newHand)
  }


{- on signal to swap within hand, visually changes order of hand -}
swapTiles : Model -> Int -> Model
swapTiles model i = 
  let
    curr = getPlayer model model.currentPlayer
    currentH = curr.handAsList 
    currArr = Array.fromList currentH
    oldClicked = 
      case model.clicked of
        x :: xs -> x
        [] -> 0
    itemA = 
      case (Array.get oldClicked currArr) of
        Just a -> a
        _ -> Debug.todo "Never"
    itemB = 
      case (Array.get i currArr) of
        Just b -> b
        _ -> Debug.todo "Never"
    newArr = Array.set oldClicked itemB currArr
    newestArr = Array.set i itemA newArr
    swapped = Array.toList newestArr    
    noClicked = {model | clicked = []} 
  in
  case model.currentPlayer of
      1 -> {noClicked | player1 = updatePlayerHand model.player1 swapped}
      2 -> {noClicked | player2 = updatePlayerHand model.player2 swapped}
      3 -> {noClicked | player3 = updatePlayerHand model.player3 swapped}
      _ -> {noClicked | player4 = updatePlayerHand model.player4 swapped}

{-on the signal to draw a tile, updates the model with the new tile and deck -}
drawTile : Model -> Model
drawTile model = 
  case model.deck of 
    x :: rest ->
      let newModel = {model | deck = rest} in
      case model.currentPlayer of
        1 ->
          let 
            newHand = x :: model.player1.handAsList 
            newDict = DictExtra.frequencies newHand
          in
          if (isWinningHand newDict) then
            {newModel | currentPhase = Won}
          else
            updatePlayerInMod newModel 1 (updatePlayerHand model.player1 newHand) 
        2 -> 
          let
            newHand = x :: model.player2.handAsList
            newDict = DictExtra.frequencies newHand
          in
          if (isWinningHand newDict) then
            {newModel | currentPhase = Won}
          else
            updatePlayerInMod newModel 2 (updatePlayerHand model.player2 newHand)
        3 -> 
          let
            newHand = x :: model.player3.handAsList
            newDict = DictExtra.frequencies newHand
          in
          if (isWinningHand newDict) then
            {newModel | currentPhase = Won}
          else
            updatePlayerInMod newModel 3 (updatePlayerHand model.player3 newHand)
        _ -> 
          let
            newHand = x :: model.player4.handAsList
            newDict = DictExtra.frequencies newHand
          in
          if (isWinningHand newDict) then
            {newModel | currentPhase = Won}
          else
            updatePlayerInMod newModel 4 (updatePlayerHand model.player4 newHand)
    [] -> {model | currentPhase = GameOver} 

--WIN CONDITION --------------------------------------------------------------------------------

{-this is the hardest part. MahJong is a classic problem in combinatorics for
finding a winning hand. A winning hand in MahJong is 14 tiles, with one pair
of the same tile and 12 tiles used in Sets. A set is either a triplet (exact
same tile thrice) or a Run (numeric tiles in a row, like 1 Tiao 2 Tiao 3 Tiao).
So first we identify a piar. If there is exactly one, we test if the rest are all sets.
If there are none, then that means a triple or quadruple can be broken up into a pair.
We do that for all possibilities and test if the rest is a set.
If there are more than 1 pair, we consider the hand where each is the pair 
and test the rest. So 3 cases for pairs.

From there, we need a function to determine if the remaining hand can
be expressed as exclusively sets. For every tile, it must be a triple OR
a run. If it is both, we must consider either case and keep going.
-}

isWinningHand : Dict.Dict Tile Int -> Bool
isWinningHand d =
  let
    removedPair = removePair d
  in  
  case removedPair of
    [] -> False
    _ -> List.member True (List.map (\x -> allSets (Dict.keys x) 0 0 0 0 x) removedPair)

{-removes the potential pair. Three cases : only one pair, zero pairs and we 
deconstruct a triple\quadruple to find one, multiple pairs and we pick one -}
removePair : Dict.Dict Tile Int -> List (Dict.Dict Tile Int)
removePair d = 
  let
    pairs = Dict.filter (\k v -> v == 2) d
    numPairs = List.length (Dict.values pairs)
  in
  if numPairs == 1 then
    [(Dict.diff d pairs)]
  else if numPairs == 0 then
    let
      tripOrQuad = Dict.filter (\k y -> y >= 3) d
      numTOrQ = List.length (Dict.values tripOrQuad)
    in
    if numTOrQ == 0 then 
      []
    else 
      List.map (\q -> decrDict d q 2) (Dict.keys tripOrQuad) 
  else
    List.map (\x -> Dict.remove x d) (Dict.keys pairs) 


{- checks if inputted dictionary is comprised of only sets
for each tile in the list of all tiles left, three cases:
it is only a triple
it is only part of a run (broken into bottomOfRun, middleOfRun, topOfRun)
it is some combination of both
-}
allSets : List Tile -> Int -> Int -> Int -> Int -> Dict.Dict Tile Int -> Bool
allSets tiles a b c d orig= 
  case tiles of
    [] -> True
    x :: xs -> 
      if orig == Dict.empty then
        True
      else
        let
          count = fetch x orig
          newTilesIfTrip = 
            case count of
              4 -> tiles
              _ -> xs
          newTilesIfRun = 
            case count of
              1 -> xs
              _ -> tiles
          isTriple = 
            count >= 3 
          (isBotOfRun, newHB, newTilesIfBot) = botOfRun x orig newTilesIfRun
          (isMidOfRun, newHM, newTilesIfMid) = midOfRun x orig newTilesIfRun
          (isTopOfRun, newHT, newTilesIfTop)= topOfRun x orig newTilesIfRun
        in
        if isTriple && (a == 0) then
          (allSets newTilesIfTrip 0 0 0 0 (decrDict orig x 3)) || (allSets tiles 1 b c d orig)
        else if isBotOfRun && (b == 0) then
          (allSets newTilesIfBot 0 0 0 0 newHB) || (allSets tiles a 1 c d orig)
        else if isMidOfRun && (c == 0) then
          (allSets newTilesIfMid 0 0 0 0 newHM) || (allSets tiles a b 1 d orig)
        else if isTopOfRun && (d == 0) then
          (allSets newTilesIfTop 0 0 0 0 newHT) || (allSets tiles a b c 1 orig)
        else False

{- if any of these suits are seen, automatically cannot be a run, as
they are nonnumeric -}

notAllowed : List String
notAllowed =
  ["Dong", "Nan", "Xi", "Bei", "Zhong", "FaCai"]

{- checks if the given tile is the "top" of a run, ie its numeric value is n
the hand has some tile of the same suit with (n-1) AND (n-2). If so,
we return true, the new dictionary that was decremented, and the updated
list of tiles to keep searching for. We need the third argument in the
returned to account for how tiles are allocated -}

topOfRun : Tile -> Dict.Dict Tile Int -> List Tile -> (Bool, Dict.Dict Tile Int, List Tile)
topOfRun t d ls=
  let
    num = Tuple.first t 
    suit = Tuple.second t
    fail = (False, Dict.empty, [])
  in
  if (List.member suit notAllowed) then
    fail
  else
    let
      below1 = (num - 1, suit)
      below2 = (num - 2, suit)
      below1Count = fetch below1 d
      below2Count = fetch below2 d
    in
    if (below1Count > 0) && (below2Count > 0) then
      let
        min1 = decrDict d below1 1 
        min2 = decrDict min1 below2 1
        newLs = if below1Count == 1 then
          List.filter (\x -> not (x == below1)) ls else ls
        newerLs = if below2Count == 1 then
          List.filter (\x -> not (x == below2)) newLs else newLs
      in
      (True, decrDict min2 t 1, newerLs)
    else 
      fail 

{- similar to topOfRun, except we check for a tile above and below the given tile's
numerical value. -}

midOfRun : Tile -> Dict.Dict Tile Int -> List Tile -> (Bool, Dict.Dict Tile Int, List Tile)
midOfRun t d ls=
  let
    num = Tuple.first t
    suit = Tuple.second t
    fail = (False, Dict.empty, [])
  in
  if (List.member suit notAllowed) then
    fail
  else
    let
      below1 = (num - 1, suit)
      above1 = (num + 1, suit)
      below1Count = fetch below1 d
      above1Count = fetch above1 d
    in
    if (below1Count > 0) && (above1Count > 0) then
      let
        min1 = decrDict d below1 1
        next1 = decrDict min1 above1 1
        newLs = if above1Count == 1 then
          List.filter (\x -> not (x == above1)) ls else ls
        newerLs = if below1Count == 1 then
          List.filter (\x -> not (x == below1)) newLs else newLs
      in
      (True, decrDict next1 t 1, newerLs)
    else 
      fail

{- similar to topOfRun, except if tile t has a numerical value n, we check if we can 
find two tiles with numerical value (n+1) AND (n+2) in the hand of the same suit. -}

botOfRun : Tile -> Dict.Dict Tile Int -> List Tile -> (Bool, Dict.Dict Tile Int, List Tile)
botOfRun t d ls=
  let
    num = Tuple.first t
    suit = Tuple.second t
    fail = (False, Dict.empty, [])
  in
  if (List.member suit notAllowed) then
    fail
  else
    let
      above1 = (num + 1, suit)
      above2 = (num + 2, suit)
      above1Count = fetch above1 d
      above2Count = fetch above2 d
    in
    if (above1Count > 0) && (above2Count > 0) then
      let
        add1 = decrDict d above1 1
        add2 = decrDict add1 above2 1 
        newLs = if above1Count == 1 then
          List.filter (\x -> not (x == above1)) ls else ls
        newerLs = if above2Count == 1 then
          List.filter (\x -> not (x == above2)) newLs else newLs      
      in
      (True, decrDict add2 t 1, newerLs)
    else 
      fail
  
{-given a dictionary, key, and value decrement key by that value. If it
goes to zero, remove that key entirely -}
decrDict : Dict.Dict comparable Int -> comparable -> Int -> Dict.Dict comparable Int
decrDict d k val = 
  case (Dict.get k d) of
    Just v ->
      if (v == val) then
        Dict.remove k d
      else
        Dict.update k (Maybe.map (\x -> x - val)) d 
    _ -> d

{-the opposite of incrDict, except we don't want to remove the key entirely
if the value drops to zero -}

incrDict : Dict.Dict comparable Int -> comparable -> Int -> Dict.Dict comparable Int
incrDict d k val =
  case (Dict.get k d) of
    Just v ->
      Dict.update k (Maybe.map (\x -> x + val)) d 
    _ -> Dict.insert k val d

{-convenience helper that fetches a value from a dictionary, unwraps 
the maybe type of the built-in-operation -}

fetch : comparable -> Dict.Dict comparable Int -> Int
fetch k d =
  case (Dict.get k d) of
    Just x -> x
    _ -> 0
