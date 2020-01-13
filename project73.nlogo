;; Owen Yaggy
;; Fahad Sikder
;; Rayat Roy

;; Annual Intro to CS
;; Final Project

;; One of the biggest and most important aspects of our code is
;; the use of data files for each level. The reading of these
;; files takes up more than 500 lines of code.
;; However, this makes it really easy for anyone to modify how
;; this game runs, and even create their own levels.
;; It also gives us more flexibility to expand the game, since
;; the code is already built to handle a level with virtually
;; any combination of the variables associated with it.

globals
[
  ;; Setup:

  side-width ;; side-width determines the width of the barrier around the world
  exits ;; exits is a list containing which exits are shown
  ;; the exits are "left" "right" "top" "bottom" and are updated by level files
  exit-width ;; exit-width determines how wide each exit is
  fancy-background ;; boolean if textured background or not

  ;; Different start settings:

  player-type ;; what version of the character is
  attack-damage ;; how much damage is dealt per attack

  ;; Keeping track of user:

  level ;; level is current floor
  room ;; room is current room (there are a certain number of rooms for each level)
  exit-on ;; string - which exit the user is on, or none
  level-number ;; the overall number of the room (0-24)

  ;; User info

  inventory
  hp

  ;; User movement:

  speed ;; speed determines how far fd the character moves in the event of a keypress
  mx my nmx nmy ;; mx, my, nmx, and nmy, which mean (new) mouse-xcor/ycor, are used in the procedure directional
  ;; i.e. they're used to help point the character in the right direction
  strafe-realign ;; whether or not strafing causes the character's heading to point back toward the mouse
  mouse-based ;; whether or not movement is based on w = up or w = toward mouse pointer

  ;; Projectiles:

  ptype ;; what type of projectile the character has
  ptimer ;; projectile waiting timer
  ptimer-max ;; how long until new projectile can be fired (ticks)
  projectile-can-fire ;; if a projectile can fire right now

  ;; Level files:

  line ;; the current line being read and checked
  r-exit ;; which room is the right exit
  l-exit ;; which room is the left exit
  t-exit ;; which room is the top exit
  b-exit ;; which room is the bottom exit
  locks ;; list with strings (Top/Right/etc.)

  ;; Initial level files loading - all have prefix l

  lexits ;; ex: ["Exits: Right Left" "Exits: Top Right" "Exits: "Left Bottom"]
  lmelee ;; ex: [0 1 0 2 0 0] # exits per file
  lmagic ;; same
  lrange ;; same
  lboss ;; same
  lfinal ;; [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1]
  lchests ;; ex: [0 0 0 1 0 0 0 0 0 0 0 0 0 1 0 0 0] 1 = chest room, 0 = not
  litem ;; ex: [0 0 0 "sword" 0 0 0 0 0 0 0 0 0 "hp" 0 0 0] 0 = no item, string = item name
  lkey ;; ex: [0 0 0 0 0 "mob" 0 0 0 1 0 0 0] 0 = no key in room, 1 = key in room, "mob" = key dropped by mob
  lmobdrop ;; ex: [0 0 0 0 0 0 0 "hp" 0 0 0 0 0 "bow" 0 0 0]
  lr-exit ;; ex: ["0-1" "0-0" "0-2 locked" "0-1"] etc., where right exit in room leads, add locked if door locked
  ll-exit ;; same, but for left
  ltexit ;; same, but for top REMEMBER NO DASH! (due to conflict with lt actually meaning something)
  lb-exit ;; same, but for bottom
  level-load ;; which level is being loaded, 0-24

  ;; Arrow animation, tutorial stuff

  arx ;; xpos
  ary ;; ypos
  ars ;; speed
  ard ;; direction
  watching
  w-pressed ;; if the player has tried to press w yet
  old-player-type
  fire-length
  sword-down
  can-attack ;; if sword can be used
  attack-timer
  max-attack

  ;; Testing:

  test
  save
  document
  one-time
  ;;mob globals
   ar1
 damage1
  time
]

breed[projectiles projectile]
projectiles-own[
  pspeed ;; p is a prefix designating projectiles-________ (e.g. speed, heading)
  pheading
  ;; Need more
]

turtles-own [
  target-health
  on-fire
]
breed [;;enemy breed
  mobs mob]

breed [players player]
breed [mprojectiles mprojectile]
mprojectiles-own [dist mar damage2]
patches-own[;;for when magic mobs poison patches
  poisoned? pdamage dtime ocolor]
mobs-own [
  ;; amount of damage per attack
  damage
  ;;attack speed. sas is used to reset the mob attack speed after it attacks
  as
  sas
  ;;movement speed
  mspeed
  ;; is it chasing the player?
  relaxed?
  ;; range
  ar
  ;; starting x coordinate
  x
  ;; starting y coordinate
  y
  ;; meele, ranged, or magic
  class]


to load-levels
  set lexits []
  set lmelee []
  set lmagic []
  set lrange []
  set lboss []
  set lfinal []
  set lchests []
  set litem []
  set lkey []
  set lmobdrop []
  set lr-exit []
  set ll-exit []
  set ltexit []
  set lb-exit []
  set level-load 0
  file-open "Level Files/0-0.txt"
  read-file
  file-close-all
  set level-load 1
  file-open "Level Files/0-1.txt"
  read-file
  file-close-all
  set level-load 2
  file-open "Level Files/0-2.txt"
  read-file
  file-close-all
  set level-load 3
  file-open "Level Files/0-3.txt"
  read-file
  file-close-all
  set level-load 4
  file-open "Level Files/0-4.txt"
  read-file
  file-close-all
  set level-load 5
  file-open "Level Files/1-0.txt"
  read-file
  file-close-all
  set level-load 6
  file-open "Level Files/1-1.txt"
  read-file
  file-close-all
  set level-load 7
  file-open "Level Files/1-2.txt"
  read-file
  file-close-all
  set level-load 8
  file-open "Level Files/1-3.txt"
  read-file
  file-close-all
  set level-load 9
  file-open "Level Files/1-4.txt"
  read-file
  file-close-all
  set level-load 10
  file-open "Level Files/2-0.txt"
  read-file
  file-close-all
  set level-load 11
  file-open "Level Files/2-1.txt"
  read-file
  file-close-all
  set level-load 12
  file-open "Level Files/2-2.txt"
  read-file
  file-close-all
  set level-load 13
  file-open "Level Files/2-3.txt"
  read-file
  file-close-all
  set level-load 14
  file-open "Level Files/2-4.txt"
  read-file
  file-close-all
  set level-load 15
  file-open "Level Files/3-0.txt"
  read-file
  file-close-all
  set level-load 16
  file-open "Level Files/3-1.txt"
  read-file
  file-close-all
  set level-load 17
  file-open "Level Files/3-2.txt"
  read-file
  file-close-all
  set level-load 18
  file-open "Level Files/3-3.txt"
  read-file
  file-close-all
  set level-load 19
  file-open "Level Files/3-4.txt"
  read-file
  file-close-all
  set level-load 20
  file-open "Level Files/4-0.txt"
  read-file
  file-close-all
  set level-load 21
  file-open "Level Files/4-1.txt"
  read-file
  file-close-all
  set level-load 22
  file-open "Level Files/4-2.txt"
  read-file
  file-close-all
  set level-load 23
  file-open "Level Files/4-3.txt"
  read-file
  file-close-all
  set level-load 24
  file-open "Level Files/4-4.txt"
  read-file
  file-close-all
end

to read-file
  while [not file-at-end?] [
    set line file-read-line
    ;; Exits
    if member? "Exits" line [
      let whole ""
      if member? "Left" line [set whole word whole " left"]
      if member? "Right" line [set whole word whole " right"]
      if member? "Top" line [set whole word whole " top"]
      if member? "Bottom" line [set whole word whole " bottom"]
      set lexits lput whole lexits
    ]
    ;; Mobs
    ;; Melee
    if member? "Melee" line [
      ifelse  member? "1" line [
        set lmelee lput 1 lmelee
      ] [
        ifelse member? "2" line [
          set lmelee lput 2 lmelee
        ] [
          ifelse member? "3" line [
            set lmelee lput 3 lmelee
          ] [
            ifelse member? "4" line [
              set lmelee lput 4 lmelee
            ] [
              ifelse member? "5" line [
                set lmelee lput 5 lmelee
      ] [set lmelee lput 0 lmelee]]]]]
    ]
    ;; Magic
    if member? "Magic" line [
      ifelse member? "1" line [
        set lmagic lput 1 lmagic
      ] [
        ifelse member? "2" line [
          set lmagic lput 2 lmagic
        ] [
          ifelse member? "3" line [
            set lmagic lput 3 lmagic
          ] [
            ifelse member? "4" line [
              set lmagic lput 4 lmagic
            ] [
              ifelse member? "5" line [
                set lmagic lput 5 lmagic
      ] [set lmagic lput 0 lmagic]]]]]
    ]
    ;; Range
    if member? "Range" line [
      ifelse member? "1" line [
        set lrange lput 1 lrange
      ] [
        ifelse member? "2" line [
          set lrange lput 2 lrange
        ] [
          ifelse member? "3" line [
            set lrange lput 3 lrange
          ] [
            ifelse member? "4" line [
              set lrange lput 4 lrange
            ] [
              ifelse member? "5" line [
                set lrange lput 5 lrange
      ] [set lrange lput 0 lrange]]]]]
    ]
    ;; Level Boss (not final)
    if member? "Boss" line and not member? "Final" line [
      ifelse member? "1" line [
        set lboss lput 1 lboss
      ] [
        ifelse member? "2" line [
          set lboss lput 2 lboss
        ] [
          ifelse member? "3" line [
            set lboss lput 3 lboss
          ] [
            ifelse member? "4" line [
              set lboss lput 4 lboss
            ] [
              ifelse member? "5" line [
                set lboss lput 5 lboss
      ] [set lboss lput 0 lboss]]]]]
    ]
    ;; Final Boss
    if member? "Final Boss" line [
      ifelse member? "1" line [
        set lfinal lput 1 lfinal
      ] [set lfinal lput 0 lfinal]
    ]
    if member? "Chests" line [
      ifelse member? "1" line [
        set lchests lput 1 lchests
      ] [set lchests lput 0 lchests]
    ]
    if member? "Item" line [
      ifelse member? "Item 1" line [
        set litem lput "Item 1" litem
      ] [
        ifelse member? "Item 2" line [
          set litem lput "Item 2" litem
        ] [
          ifelse member? "Item 3" line [
            set litem lput "Item 3" litem
          ] [
            ifelse member? "Item 4" line [
              set litem lput "Item 4" litem
            ] [set litem lput 0 litem]]]]
    ]
    if member? "KEY" line [
      ifelse member? "MOB" line [
        set lkey lput "mob" lkey
      ] [
        set lkey lput 1 lkey
      ]
    ]
    ifelse member? "MOB DROP" line [
      set lmobdrop lput 1 lmobdrop
    ] [set lmobdrop lput 0 lmobdrop]
    if not member? "Exit" line and not member? "Locked" line [
      if member? "Right" line [
        if member? "0-0" line [set lr-exit lput "0-0" lr-exit]
        if member? "0-1" line [set lr-exit lput "0-1" lr-exit]
        if member? "0-2" line [set lr-exit lput "0-2" lr-exit]
        if member? "0-3" line [set lr-exit lput "0-3" lr-exit]
        if member? "0-4" line [set lr-exit lput "0-4" lr-exit]
        if member? "1-0" line [set lr-exit lput "1-0" lr-exit]
        if member? "1-1" line [set lr-exit lput "1-1" lr-exit]
        if member? "1-2" line [set lr-exit lput "1-2" lr-exit]
        if member? "1-3" line [set lr-exit lput "1-3" lr-exit]
        if member? "1-4" line [set lr-exit lput "1-4" lr-exit]
        if member? "2-0" line [set lr-exit lput "2-0" lr-exit]
        if member? "2-1" line [set lr-exit lput "2-1" lr-exit]
        if member? "2-2" line [set lr-exit lput "2-2" lr-exit]
        if member? "2-3" line [set lr-exit lput "2-3" lr-exit]
        if member? "2-4" line [set lr-exit lput "2-4" lr-exit]
        if member? "3-0" line [set lr-exit lput "3-0" lr-exit]
        if member? "3-1" line [set lr-exit lput "3-1" lr-exit]
        if member? "3-2" line [set lr-exit lput "3-2" lr-exit]
        if member? "3-3" line [set lr-exit lput "3-3" lr-exit]
        if member? "3-4" line [set lr-exit lput "3-4" lr-exit]
        if member? "4-0" line [set lr-exit lput "4-0" lr-exit]
        if member? "4-1" line [set lr-exit lput "4-1" lr-exit]
        if member? "4-2" line [set lr-exit lput "4-2" lr-exit]
        if member? "4-3" line [set lr-exit lput "4-3" lr-exit]
        if member? "4-4" line [set lr-exit lput "4-4" lr-exit]
      ]
      if member? "Left" line [
        if member? "0-0" line [set ll-exit lput "0-0" ll-exit]
        if member? "0-1" line [set ll-exit lput "0-1" ll-exit]
        if member? "0-2" line [set ll-exit lput "0-2" ll-exit]
        if member? "0-3" line [set ll-exit lput "0-3" ll-exit]
        if member? "0-4" line [set ll-exit lput "0-4" ll-exit]
        if member? "1-0" line [set ll-exit lput "1-0" ll-exit]
        if member? "1-1" line [set ll-exit lput "1-1" ll-exit]
        if member? "1-2" line [set ll-exit lput "1-2" ll-exit]
        if member? "1-3" line [set ll-exit lput "1-3" ll-exit]
        if member? "1-4" line [set ll-exit lput "1-4" ll-exit]
        if member? "2-0" line [set ll-exit lput "2-0" ll-exit]
        if member? "2-1" line [set ll-exit lput "2-1" ll-exit]
        if member? "2-2" line [set ll-exit lput "2-2" ll-exit]
        if member? "2-3" line [set ll-exit lput "2-3" ll-exit]
        if member? "2-4" line [set ll-exit lput "2-4" ll-exit]
        if member? "3-0" line [set ll-exit lput "3-0" ll-exit]
        if member? "3-1" line [set ll-exit lput "3-1" ll-exit]
        if member? "3-2" line [set ll-exit lput "3-2" ll-exit]
        if member? "3-3" line [set ll-exit lput "3-3" ll-exit]
        if member? "3-4" line [set ll-exit lput "3-4" ll-exit]
        if member? "4-0" line [set ll-exit lput "4-0" ll-exit]
        if member? "4-1" line [set ll-exit lput "4-1" ll-exit]
        if member? "4-2" line [set ll-exit lput "4-2" ll-exit]
        if member? "4-3" line [set ll-exit lput "4-3" ll-exit]
        if member? "4-4" line [set ll-exit lput "4-4" ll-exit]
      ]
      if member? "Top" line [
        if member? "0-0" line [set ltexit lput "0-0" ltexit]
        if member? "0-1" line [set ltexit lput "0-1" ltexit]
        if member? "0-2" line [set ltexit lput "0-2" ltexit]
        if member? "0-3" line [set ltexit lput "0-3" ltexit]
        if member? "0-4" line [set ltexit lput "0-4" ltexit]
        if member? "1-0" line [set ltexit lput "1-0" ltexit]
        if member? "1-1" line [set ltexit lput "1-1" ltexit]
        if member? "1-2" line [set ltexit lput "1-2" ltexit]
        if member? "1-3" line [set ltexit lput "1-3" ltexit]
        if member? "1-4" line [set ltexit lput "1-4" ltexit]
        if member? "2-0" line [set ltexit lput "2-0" ltexit]
        if member? "2-1" line [set ltexit lput "2-1" ltexit]
        if member? "2-2" line [set ltexit lput "2-2" ltexit]
        if member? "2-3" line [set ltexit lput "2-3" ltexit]
        if member? "2-4" line [set ltexit lput "2-4" ltexit]
        if member? "3-0" line [set ltexit lput "3-0" ltexit]
        if member? "3-1" line [set ltexit lput "3-1" ltexit]
        if member? "3-2" line [set ltexit lput "3-2" ltexit]
        if member? "3-3" line [set ltexit lput "3-3" ltexit]
        if member? "3-4" line [set ltexit lput "3-4" ltexit]
        if member? "4-0" line [set ltexit lput "4-0" ltexit]
        if member? "4-1" line [set ltexit lput "4-1" ltexit]
        if member? "4-2" line [set ltexit lput "4-2" ltexit]
        if member? "4-3" line [set ltexit lput "4-3" ltexit]
        if member? "4-4" line [set ltexit lput "4-4" ltexit]
      ]
      if member? "Bottom" line [
        if member? "0-0" line [set lb-exit lput "0-0" lb-exit]
        if member? "0-1" line [set lb-exit lput "0-1" lb-exit]
        if member? "0-2" line [set lb-exit lput "0-2" lb-exit]
        if member? "0-3" line [set lb-exit lput "0-3" lb-exit]
        if member? "0-4" line [set lb-exit lput "0-4" lb-exit]
        if member? "1-0" line [set lb-exit lput "1-0" lb-exit]
        if member? "1-1" line [set lb-exit lput "1-1" lb-exit]
        if member? "1-2" line [set lb-exit lput "1-2" lb-exit]
        if member? "1-3" line [set lb-exit lput "1-3" lb-exit]
        if member? "1-4" line [set lb-exit lput "1-4" lb-exit]
        if member? "2-0" line [set lb-exit lput "2-0" lb-exit]
        if member? "2-1" line [set lb-exit lput "2-1" lb-exit]
        if member? "2-2" line [set lb-exit lput "2-2" lb-exit]
        if member? "2-3" line [set lb-exit lput "2-3" lb-exit]
        if member? "2-4" line [set lb-exit lput "2-4" lb-exit]
        if member? "3-0" line [set lb-exit lput "3-0" lb-exit]
        if member? "3-1" line [set lb-exit lput "3-1" lb-exit]
        if member? "3-2" line [set lb-exit lput "3-2" lb-exit]
        if member? "3-3" line [set lb-exit lput "3-3" lb-exit]
        if member? "3-4" line [set lb-exit lput "3-4" lb-exit]
        if member? "4-0" line [set lb-exit lput "4-0" lb-exit]
        if member? "4-1" line [set lb-exit lput "4-1" lb-exit]
        if member? "4-2" line [set lb-exit lput "4-2" lb-exit]
        if member? "4-3" line [set lb-exit lput "4-3" lb-exit]
        if member? "4-4" line [set lb-exit lput "4-4" lb-exit]
      ]
    ]
    if not member? "Exits" line and member? "Locked" line [
      if member? "Right" line [
        if member? "0-0" line [set lr-exit lput "0-0 locked" lr-exit]
        if member? "0-1" line [set lr-exit lput "0-1 locked" lr-exit]
        if member? "0-2" line [set lr-exit lput "0-2 locked" lr-exit]
        if member? "0-3" line [set lr-exit lput "0-3 locked" lr-exit]
        if member? "0-4" line [set lr-exit lput "0-4 locked" lr-exit]
        if member? "1-0" line [set lr-exit lput "1-0 locked" lr-exit]
        if member? "1-1" line [set lr-exit lput "1-1 locked" lr-exit]
        if member? "1-2" line [set lr-exit lput "1-2 locked" lr-exit]
        if member? "1-3" line [set lr-exit lput "1-3 locked" lr-exit]
        if member? "1-4" line [set lr-exit lput "1-4 locked" lr-exit]
        if member? "2-0" line [set lr-exit lput "2-0 locked" lr-exit]
        if member? "2-1" line [set lr-exit lput "2-1 locked" lr-exit]
        if member? "2-2" line [set lr-exit lput "2-2 locked" lr-exit]
        if member? "2-3" line [set lr-exit lput "2-3 locked" lr-exit]
        if member? "2-4" line [set lr-exit lput "2-4 locked" lr-exit]
        if member? "3-0" line [set lr-exit lput "3-0 locked" lr-exit]
        if member? "3-1" line [set lr-exit lput "3-1 locked" lr-exit]
        if member? "3-2" line [set lr-exit lput "3-2 locked" lr-exit]
        if member? "3-3" line [set lr-exit lput "3-3 locked" lr-exit]
        if member? "3-4" line [set lr-exit lput "3-4 locked" lr-exit]
        if member? "4-0" line [set lr-exit lput "4-0 locked" lr-exit]
        if member? "4-1" line [set lr-exit lput "4-1 locked" lr-exit]
        if member? "4-2" line [set lr-exit lput "4-2 locked" lr-exit]
        if member? "4-3" line [set lr-exit lput "4-3 locked" lr-exit]
        if member? "4-4" line [set lr-exit lput "4-4 locked" lr-exit]
      ]
      if member? "Left" line [
        if member? "0-0" line [set ll-exit lput "0-0 locked" ll-exit]
        if member? "0-1" line [set ll-exit lput "0-1 locked" ll-exit]
        if member? "0-2" line [set ll-exit lput "0-2 locked" ll-exit]
        if member? "0-3" line [set ll-exit lput "0-3 locked" ll-exit]
        if member? "0-4" line [set ll-exit lput "0-4 locked" ll-exit]
        if member? "1-0" line [set ll-exit lput "1-0 locked" ll-exit]
        if member? "1-1" line [set ll-exit lput "1-1 locked" ll-exit]
        if member? "1-2" line [set ll-exit lput "1-2 locked" ll-exit]
        if member? "1-3" line [set ll-exit lput "1-3 locked" ll-exit]
        if member? "1-4" line [set ll-exit lput "1-4 locked" ll-exit]
        if member? "2-0" line [set ll-exit lput "2-0 locked" ll-exit]
        if member? "2-1" line [set ll-exit lput "2-1 locked" ll-exit]
        if member? "2-2" line [set ll-exit lput "2-2 locked" ll-exit]
        if member? "2-3" line [set ll-exit lput "2-3 locked" ll-exit]
        if member? "2-4" line [set ll-exit lput "2-4 locked" ll-exit]
        if member? "3-0" line [set ll-exit lput "3-0 locked" ll-exit]
        if member? "3-1" line [set ll-exit lput "3-1 locked" ll-exit]
        if member? "3-2" line [set ll-exit lput "3-2 locked" ll-exit]
        if member? "3-3" line [set ll-exit lput "3-3 locked" ll-exit]
        if member? "3-4" line [set ll-exit lput "3-4 locked" ll-exit]
        if member? "4-0" line [set ll-exit lput "4-0 locked" ll-exit]
        if member? "4-1" line [set ll-exit lput "4-1 locked" ll-exit]
        if member? "4-2" line [set ll-exit lput "4-2 locked" ll-exit]
        if member? "4-3" line [set ll-exit lput "4-3 locked" ll-exit]
        if member? "4-4" line [set ll-exit lput "4-4 locked" ll-exit]
      ]
      if member? "Top" line [
        if member? "0-0" line [set ltexit lput "0-0 locked" ltexit]
        if member? "0-1" line [set ltexit lput "0-1 locked" ltexit]
        if member? "0-2" line [set ltexit lput "0-2 locked" ltexit]
        if member? "0-3" line [set ltexit lput "0-3 locked" ltexit]
        if member? "0-4" line [set ltexit lput "0-4 locked" ltexit]
        if member? "1-0" line [set ltexit lput "1-0 locked" ltexit]
        if member? "1-1" line [set ltexit lput "1-1 locked" ltexit]
        if member? "1-2" line [set ltexit lput "1-2 locked" ltexit]
        if member? "1-3" line [set ltexit lput "1-3 locked" ltexit]
        if member? "1-4" line [set ltexit lput "1-4 locked" ltexit]
        if member? "2-0" line [set ltexit lput "2-0 locked" ltexit]
        if member? "2-1" line [set ltexit lput "2-1 locked" ltexit]
        if member? "2-2" line [set ltexit lput "2-2 locked" ltexit]
        if member? "2-3" line [set ltexit lput "2-3 locked" ltexit]
        if member? "2-4" line [set ltexit lput "2-4 locked" ltexit]
        if member? "3-0" line [set ltexit lput "3-0 locked" ltexit]
        if member? "3-1" line [set ltexit lput "3-1 locked" ltexit]
        if member? "3-2" line [set ltexit lput "3-2 locked" ltexit]
        if member? "3-3" line [set ltexit lput "3-3 locked" ltexit]
        if member? "3-4" line [set ltexit lput "3-4 locked" ltexit]
        if member? "4-0" line [set ltexit lput "4-0 locked" ltexit]
        if member? "4-1" line [set ltexit lput "4-1 locked" ltexit]
        if member? "4-2" line [set ltexit lput "4-2 locked" ltexit]
        if member? "4-3" line [set ltexit lput "4-3 locked" ltexit]
        if member? "4-4" line [set ltexit lput "4-4 locked" ltexit]
      ]
      if member? "Bottom" line [
        if member? "0-0" line [set lb-exit lput "0-0 locked" lb-exit]
        if member? "0-1" line [set lb-exit lput "0-1 locked" lb-exit]
        if member? "0-2" line [set lb-exit lput "0-2 locked" lb-exit]
        if member? "0-3" line [set lb-exit lput "0-3 locked" lb-exit]
        if member? "0-4" line [set lb-exit lput "0-4 locked" lb-exit]
        if member? "1-0" line [set lb-exit lput "1-0 locked" lb-exit]
        if member? "1-1" line [set lb-exit lput "1-1 locked" lb-exit]
        if member? "1-2" line [set lb-exit lput "1-2 locked" lb-exit]
        if member? "1-3" line [set lb-exit lput "1-3 locked" lb-exit]
        if member? "1-4" line [set lb-exit lput "1-4 locked" lb-exit]
        if member? "2-0" line [set lb-exit lput "2-0 locked" lb-exit]
        if member? "2-1" line [set lb-exit lput "2-1 locked" lb-exit]
        if member? "2-2" line [set lb-exit lput "2-2 locked" lb-exit]
        if member? "2-3" line [set lb-exit lput "2-3 locked" lb-exit]
        if member? "2-4" line [set lb-exit lput "2-4 locked" lb-exit]
        if member? "3-0" line [set lb-exit lput "3-0 locked" lb-exit]
        if member? "3-1" line [set lb-exit lput "3-1 locked" lb-exit]
        if member? "3-2" line [set lb-exit lput "3-2 locked" lb-exit]
        if member? "3-3" line [set lb-exit lput "3-3 locked" lb-exit]
        if member? "3-4" line [set lb-exit lput "3-4 locked" lb-exit]
        if member? "4-0" line [set lb-exit lput "4-0 locked" lb-exit]
        if member? "4-1" line [set lb-exit lput "4-1 locked" lb-exit]
        if member? "4-2" line [set lb-exit lput "4-2 locked" lb-exit]
        if member? "4-3" line [set lb-exit lput "4-3 locked" lb-exit]
        if member? "4-4" line [set lb-exit lput "4-4 locked" lb-exit]
      ]
    ]
  ]
  ;; Correcting for deleted lines in files: (where quantity is 0)
    if length lmelee < (level-load + 1) [set lmelee lput 0 lmelee]
    if length lrange < (level-load + 1) [set lrange lput 0 lrange]
    if length lmagic < (level-load + 1) [set lmagic lput 0 lmagic]
    if length lboss < (level-load + 1) [set lboss lput 0 lboss]
    if length lfinal < (level-load + 1) [set lfinal lput 0 lfinal]
    if length lchests < (level-load + 1) [set lchests lput 0 lchests]
    if length litem < (level-load + 1) [set litem lput 0 litem]
    if length lkey < (level-load + 1) [set lkey lput 0 lkey]
    if length lmobdrop < (level-load + 1) [set lmobdrop lput 0 lmobdrop]
    if length lr-exit < (level-load + 1) [set lr-exit lput "0" lr-exit]
    if length ll-exit < (level-load + 1) [set ll-exit lput "0" ll-exit]
    if length ltexit < (level-load + 1) [set ltexit lput "0" ltexit]
    if length lb-exit < (level-load + 1) [set lb-exit lput "0" lb-exit]
end

to setup
  ca
  clear
  load-levels
  set-variables
  adjust-world
  setup-level
  create-exits
  setup-character ;; creates the character
   ask patches [set ocolor pcolor] ;;this is for when patches get poisoned
end

to setup1

 ;;create-mobs 1 [setxy random-xcor random-ycor set shape "spider" set size 30.69420 set damage 3 set mspeed 0.5 set as 8 set sas 50 set relaxed? true
   ;;set ar 30 set class "meele"]
  ;;create-mobs 1 [setxy random-xcor random-ycor set shape "bug" set size 20.69420 set damage 2 set mspeed 0.5 set as 4 set sas 200 set ar 150 set relaxed? true
   ;; set class "ranged"]
  create-mobs 3 [setxy random-xcor random-ycor set shape "butterfly" set size 20.69420 set damage 1 set mspeed 0.8 set relaxed? true
    set class "magic" set ar 80]
end

to set-variables
  set fire-length 25000 ;; length of an enemy being on fire
  set can-attack true ;; if sword can be used
  set attack-timer 0 ;; timer between sword attacks
  set max-attack 1000 ;; time between sword attacks
  set sword-down false ;; if sword is in attack position
  ask turtles [set on-fire 0]
  set one-time 0
  set old-player-type 10
  set w-pressed false
  set watching false
  set test 0
  set document []
  set save "None"
  set r-exit "None"
  set l-exit "None"
  set t-exit "None"
  set b-exit "None"
  set inventory []
  set hp 100 ;; NEED TO CHANGE THIS
  set player-type 0 ;; default (no character) 1 = knight, 2 = archer, 3 = wizard
  set side-width 15
  set exit-width 90
  set speed 5
  carefully [
    set level Start-Level
  ] [set level 0]
  set room -1
  set level-number 0
  set exits []
  set exits lput item 0 lexits exits
  set nmx mouse-xcor
  set nmy mouse-ycor
  set strafe-realign false ;; every time the character strafes, they DO NOT face toward the mouse
  set ptype 1 ;; default projectile type
  set ptimer 0
  set ptimer-max 5000 ;; modify this number to change the time (in ticks) before a projectile can be fired again
  set projectile-can-fire true
  set line ""
  set mouse-based true ;; true: w goes toward mouse, false: w goes up
  set locks []
  set exit-on "None"
end

to adjust-world
  resize-world -300 300 -200 200 ;; rectangle world size
  set-patch-size 1 ;; small patch size
  ifelse fancy-background = false [
    ask patches [set pcolor black]
  ] [
    ask patches [
      ifelse random 4 = 0 [set pcolor 9]
      [ifelse random 3 = 0 [set pcolor 8]
        [ifelse random 2 = 0 [set pcolor 7]
          [set pcolor 6]]]
    ]
  ]
  create-barrier
end

to create-barrier
  ask patches [
    if pxcor > (max-pxcor - side-width) or pxcor < (min-pxcor + side-width) or pycor > (max-pycor - side-width) or pycor < (min-pycor + side-width) [
      set pcolor blue ;; creates barrier
    ]
  ]
end

to create-exits
  if member? "top" exits [ask patches with [pycor > (max-pycor - side-width) and abs(pxcor) < (exit-width / 2)] [set pcolor black]]
  if member? "bottom" exits [ask patches with [pycor < (min-pycor + side-width) and abs(pxcor) < (exit-width / 2)] [set pcolor black]]
  if member? "right" exits [ask patches with [pxcor > (max-pxcor - side-width) and abs(pycor) < (exit-width / 2)] [set pcolor black]]
  if member? "left" exits [ask patches with [pxcor < (min-pxcor + side-width) and abs(pycor) < (exit-width / 2)] [set pcolor black]] ;; these create the exits
  if member? "locked" t-exit [ask patches with [pycor > (max-pycor - side-width) and abs(pxcor) < (exit-width / 2)] [set pcolor orange]]
  if member? "locked" b-exit [ask patches with [pycor < (min-pycor + side-width) and abs(pxcor) < (exit-width / 2)] [set pcolor orange]]
  if member? "locked" r-exit [ask patches with [pxcor > (max-pxcor - side-width) and abs(pycor) < (exit-width / 2)] [set pcolor orange]]
  if member? "locked" l-exit [ask patches with [pxcor < (min-pxcor + side-width) and abs(pycor) < (exit-width / 2)] [set pcolor orange]] ;; these make them orange if they are locked
end

to setup-character
  create-players 1
  ask turtle 0 [
    set size 50
    set heading 0
    set hidden? true
    set color white
  ]
end

to go
  ;;every .1 [
  if room = -1 [
    tutorial
  ]
  ifelse mouse-based = true [
    directional
  ] [ask turtle 0 [set heading 0]]
  ifelse player-type = 1 [
    set ptimer-max 1000
  ] [set ptimer-max 5000]
  show-health
  knight-weapon
  burning
  firing
  ;; if mouse-down? [shoot] ;; this is too laggy
  if count projectiles > 75 [ask projectiles [die] show "Too many projectiles were fired."]
  if ptimer = 0 [set projectile-can-fire true]
  if ptimer != 0 [set projectile-can-fire false]
  if projectile-can-fire = false [set ptimer (ptimer + 1) if ptimer >= ptimer-max [set ptimer 0 set projectile-can-fire true]]
  ifelse watch-character = true [watch turtle 0] [if watching = false [reset-perspective]]
  sense-exits
  ifelse use-mouse-to-point? = true [set mouse-based true] [set mouse-based false]
  ;;]
  every .125 [ask turtles with [shape != "back1"] [wander]
  setpoison]
end

to directional
  set mx nmx
  set my nmy
  set nmx mouse-xcor
  set nmy mouse-ycor
  if mx != nmx [point] ;; only repoints character if mouse moves
end

to point ;; points character to mouse
  ask turtle 0 [face patch mouse-xcor mouse-ycor]
end

to w ;; if w pressed / "forward"
  if player-type != 0 and one-time > 2 [ask turtle 0 [fd speed check]]
  if one-time = 3 [set one-time 4]
end

to a ;; if a pressed / "left"
  if player-type != 0 [
    ask turtle 0 [
      let oldh heading ;; creates a variable to store the turtle's previous heading
      set heading heading - 90
      fd speed
      check
      set heading oldh
      if strafe-realign = true [point]
    ]
  ]
end

to d ;; if d pressed / "right"
  if player-type != 0 [
    ask turtle 0 [
      let oldh heading ;; creates a variable to store the turtle's previous heading
      set heading heading + 90
      fd speed
      check
      set heading oldh
      if strafe-realign = true [point]
    ]
  ]
end

to s ;; if s pressed / "backwards"
  if player-type != 0 [ask turtle 0 [fd (-1 * speed) check]]
end

to check ;; checks if there is a barrier
  ;; currently this only works for the exact center of the character
  if pcolor = blue or pcolor = orange [fd (speed * -1)]
  carefully [if [pcolor] of patch-ahead 15 = blue or [pcolor] of patch-ahead 15 = orange [fd (speed * -1)]]
  [if pcolor = blue or pcolor = orange [fd (speed * -1)]]
  carefully [if [pcolor] of patch-ahead -15 = blue or [pcolor] of patch-ahead -15 = orange [fd (speed * 1)]]
  [if pcolor = blue or pcolor = orange [fd (speed * 1)]]
end

to sense-exits
  ;; Determining what exit turtle on:
  ask turtle 0 [
    ifelse pcolor = black [
      ifelse xcor > max-pxcor - side-width and ycor < exit-width / 2 and ycor > 0 - exit-width / 2 [
        set exit-on "Right"
      ] [
        ifelse xcor < min-pxcor + side-width and ycor < exit-width / 2 and ycor > 0 - exit-width / 2 [
          set exit-on "Left"
        ] [
          ifelse ycor < min-pycor + side-width and xcor < exit-width / 2 and xcor > 0 - exit-width / 2 [
            set exit-on "Bottom"
          ] [
            ifelse ycor > max-pycor - side-width and xcor < exit-width / 2 and xcor > 0 - exit-width / 2 [
              set exit-on "Top"
            ] [
              set exit-on "None"
  ]]]]] [set exit-on "None"]]
  if exit-on = "Right" [
    carefully [
    set room read-from-string item 2 r-exit
    ] [set room room]
    advance-level
  ]
  if exit-on = "Left" [
    carefully [
      set room read-from-string item 2 l-exit
    ] [set room room]
    advance-level
  ]
  if exit-on = "Top" and (room != -1 or one-time = 10) [
    carefully [
      set room read-from-string item 2 t-exit
    ] [set room room]
     advance-level
  ]
  if exit-on = "Bottom" [
    carefully [
      set room read-from-string item 2 b-exit
    ] [set room room]
    advance-level
  ]
end

to show-health
end

to attack
  if player-type = 1 [hit]
  if player-type = 2 [shoot]
  if player-type = 3 [shoot]
end

to knight-weapon
  ;; - 21 x
  ;; + 16 y
  ;;if count turtles with [member? "sword" shape] = 0 and player-type = 1 [
   ;; cro 1 [set size 24 set heading -45 set shape "basic-sword" setxy [xcor] of turtle 0 - 21 [ycor] of turtle 0 + 16]
  ;;]
  ;;ask turtles with [member? "sword" shape] [setxy [xcor] of turtle 0 - 21 [ycor] of turtle 0 + 16]
  ;;if player-type != 1 [ask turtles with [member? "sword" shape] [die]]
  ;;if player-type = 1 [set shape "knight2"]
end

to hit
  ask turtles with [player-type = 1] [
    if can-attack = true [
    ]
  ]
end

to setup-projectile
  if ptype = 0 [set shape "circle" set color white set size 20 set pspeed 0.1]
  if ptype = 1 [set shape "circle" set color black set size 15 set pspeed 0.1]
  if ptype = 2 [set shape "fireball" set size 120 set pspeed 0.1]
end

to shoot
  if (projectile-can-fire = true and room != -1) or (room = -1 and (one-time > 100 or one-time = 10) and projectile-can-fire = true) [
    set projectile-can-fire false
    ask turtle 0 [set ptimer 1 hatch-projectiles 1 [
      setup-projectile
      ifelse mouse-based = true [
        set pheading [heading] of turtle 0
      ][
        ask turtle 0 [face patch mouse-xcor mouse-ycor]
        set pheading [heading] of turtle 0
        ask turtle 0 [set heading 0]
    ]
    ]]
  ]
end

to firing
  ask projectiles [
    set heading pheading
    fd pspeed
    ;; Projectile-type specific behavior:
    if ptype = 0 [ if pcolor = blue or xcor >= max-pxcor or ycor >= max-pycor or ycor <= min-pycor or xcor <= min-pxcor [die] ]
    if ptype = 1 [ ;; ARCHER type 1
      if pcolor = blue or xcor >= max-pxcor or ycor >= max-pycor or ycor <= min-pycor or xcor <= min-pxcor [die]
      if count turtles with [shape = "target"] in-radius 27.5 >= 1 [ask turtles with [shape = "target"] [set target-health target-health - 20] die]
    ]
    if ptype = 2 [ ;; FIREBALL
      if pcolor = blue or xcor >= max-pxcor or ycor >= max-pycor or ycor <= min-pycor or xcor <= min-pxcor [die]
      if count turtles with [shape = "target"] in-radius 27.5 >= 1 [ask turtles with [shape = "target"] [set target-health target-health - 10 set on-fire fire-length] die]
    ]
  ]
end

to advance-level
  ask turtle 0 [
    if exit-on = "Top" [
      setxy 0 (min-pycor + 50)
    ]
    if exit-on = "Bottom" [
      setxy 0 (max-pycor - 50)
    ]
    if exit-on = "Right" [
      setxy (min-pxcor + 50) 0
    ]
    if exit-on = "Left" [
      setxy (max-pxcor - 50) 0
    ]
    if exit-on = "None" [
      setxy 0 0
    ]
  ]
  ;;set exits []
  setup-level
  create-barrier
  create-exits
end

to setup-level
  set-level-number
  if room >= 0 [
    set r-exit item level-number lr-exit
    set l-exit item level-number ll-exit
    set t-exit item level-number ltexit
    set b-exit item level-number lb-exit
    set exits item level-number lexits
  ]
  if room = -1 [
    set exits ["top"]
    set t-exit "0-0"
  ]
end

to set-level-number
  if room = -1 [set level-number -1]
  if level = 0 [
     if room = 0 [set level-number 0]
     if room = 1 [set level-number 1]
     if room = 2 [set level-number 2]
     if room = 3 [set level-number 3]
     if room = 4 [set level-number 4]
  ]
  if level = 1 [
     if room = 0 [set level-number 5]
     if room = 1 [set level-number 6]
     if room = 2 [set level-number 7]
     if room = 3 [set level-number 8]
     if room = 4 [set level-number 9]
  ]
  if level = 2 [
     if room = 0 [set level-number 10]
     if room = 1 [set level-number 11]
     if room = 2 [set level-number 12]
     if room = 3 [set level-number 13]
     if room = 4 [set level-number 14]
  ]
  if level = 3 [
     if room = 0 [set level-number 15]
     if room = 1 [set level-number 16]
     if room = 2 [set level-number 17]
     if room = 3 [set level-number 18]
     if room = 4 [set level-number 19]
  ]
  if level = 4 [
     if room = 0 [set level-number 20]
     if room = 1 [set level-number 21]
     if room = 2 [set level-number 22]
     if room = 3 [set level-number 23]
     if room = 4 [set level-number 24]
  ]
end

to set-character-knight
  ifelse (room = -1 and one-time = 10) or player-type = 0 [set player-type 1] [show "You can't change your character now!"]
end

to set-character-archer
  ifelse (room = -1 and one-time = 10) or player-type = 0 [set player-type 2] [show "You can't change your character now!"]
end

to set-character-wizard
  ifelse (room = -1 and one-time = 10) or player-type = 0 [set player-type 3] [show "You can't change your character now!"]
end

to tutorial
  set test test + 1
  if one-time = 0 [clear set arx 220 set ard 1 show "Select a character on the right!" set one-time 1 crt 1 [set shape "arrow" set heading 90 set color blue set size 85 setxy arx 140]]
  ask turtle 0 [
    if old-player-type = 10 [
      if player-type = 1 [ifelse sword-down = true [set shape "knight4"] [set shape "knight5"] set size 60 set color 4 set hidden? false]
      if player-type = 2 [set shape "person soldier" set hidden? false]
      if player-type = 3 [set shape "person graduate" set hidden? false]
    ]
    if old-player-type != 10 [
      if player-type != old-player-type and one-time >= 9 and one-time < 100 [
        if player-type = 1 [ifelse sword-down = true [set shape "knight4"] [set shape "knight5"] set size 60 set color 4 set hidden? false]
        if player-type = 2 [set shape "person soldier" set hidden? false]
        if player-type = 3 [set shape "person graduate" set hidden? false]
        set one-time 7
        set old-player-type player-type
      ]
    ]
  ]
  if player-type = 0 [
    ask turtle 1 [
      if ard = 1 [ set arx arx + 0.005 ]
      if ard = 0 [ set arx arx - 0.005 ]
      if arx > 240 [ set ard 0 ]
      if arx < 200 [ set ard 1 ]
      set xcor arx
    ]
  ]
  if one-time = 1 and player-type != 0 [
    ask turtle 1 [die]
    clear
    show "First click your mouse outside of the world."
    show "Then move your mouse to the highlighted area."
    set one-time 2
  ]
  if one-time = 2 [
    watch patch 250 -150 set watching true
    if mouse-xcor > 235 and mouse-xcor < 265 and mouse-ycor < -135 and mouse-ycor > -165 [
      set watching false
      reset-perspective
      set w-pressed false
      clear
      show "Good job! Now press W, and try holding it down"
      set one-time 3
    ]
  ]
  ;; W being pressed when one-time is 3 will set one-time to 4
  if one-time = 4 [
    clear
    show "Good job!"
    show "Now you can move your mouse around to change direction,"
    show "and press W to move forward."
    set one-time 5
    set arx 0
  ]
  if one-time = 5 [
    set arx arx + 1
    if arx > 75000 [set one-time 6 set arx 0]
  ]
  if one-time = 6 [
    clear
    show "Each character has a different combat specialty."
    set one-time 7
  ]
  if one-time = 7 [
    if player-type = 1 [show "Your specialty is melee combat."]
    if player-type = 2 [show "Your specialty is range combat."]
    if player-type = 3 [show "Your specialty is magic-type combat."]
    set one-time 8
  ]
  if one-time = 8 [
    ;; Need to create visual for melee combat
    if player-type = 1 [
      ;; Instructions for how to use melee combat
      set one-time 110 ;; one-time specific for knight
    ]
    if player-type = 2 [
      ;; Instructions for how to use range combat
      show "Press E to fire a projectile in the direction of your mouse."
      set one-time 120 ;; one-time specific for archer
    ]
    if player-type = 3 [
      ;; Instructions for how to use magic combat
      show "Press E to throw a fireball in the direction of your mouse."
      show "Note that fireballs can only harm enemies that aren't already on fire."
      set one-time 130 ;; one-time specific for wizard
    ]
  ]
  if one-time = 110 [ ;; one-time specific for knight
  ]
  if one-time = 120 [ ;; one-time specific for archer
    ;; Create target that needs to be destroyed by being hit 5 times
    cro 1 [set shape "target" set size 40 setxy 0 0 set target-health 100]
    show "Destroy this target!"
    set ars 0.01
    set ard 280
    set one-time 121
    set ptype 1
  ]
  if one-time = 121 [
    ask turtles with [shape = "target"] [
      set heading ard
      fd ars
      if xcor - 20 < min-pxcor + side-width [
        set ard 360 - ard
      ]
      if xcor + 20 > max-pxcor - side-width [
        set ard 360 - ard
      ]
      if ycor + 20 > max-pycor - side-width [
        set ard 180 - ard
      ]
      if ycor - 20 < min-pycor + side-width [
        set ard 180 - ard
      ]
      if target-health <= 0 [
        set one-time 9
        die
      ]
    ]
  ]
  if one-time = 130 [ ;; one-time specific for wizard
    cro 1 [set shape "target" set size 40 setxy 0 0 set target-health 100]
    show "Destroy this target!"
    set ars 0.01
    set ard 280
    set one-time 131
    set ptype 2
  ]
  if one-time = 131 [
    ask turtles with [shape = "target" or shape = "target-fire1" or shape = "target-fire2"] [
      set heading ard
      fd ars
      if xcor - 20 < min-pxcor + side-width [
        set ard 360 - ard
      ]
      if xcor + 20 > max-pxcor - side-width [
        set ard 360 - ard
      ]
      if ycor + 20 > max-pycor - side-width [
        set ard 180 - ard
      ]
      if ycor - 20 < min-pycor + side-width [
        set ard 180 - ard
      ]
      if target-health <= 0.1 [
        set one-time 9
        die
      ]
    ]
  ]
  if one-time = 9 [
    clear
    show "You did it!"
    show "You can try out a different character, or exit the tutorial through the top!"
    set old-player-type player-type
    set one-time 10
  ]
  ;; Add ability to try out new characters by using:
  ;; if one-time > x in the button for each character choice, set one-time 7
end

to skip-tutorial
  ifelse player-type != 0 [
    set one-time 9
    reset-perspective
    set watching false
  ] [
    show ""
    show "You need to pick a character first!"
  ]
end

to burning
  ask turtles with [on-fire > 0] [
    if shape = "target-fire1" or shape = "target-fire2" [
      set target-health target-health - (15 / fire-length)
    ]
    if shape = "target" [set shape "target-fire1"]
    if shape = "target-fire1" [
      if random 1000 = 0 [set shape "target-fire2"]
    ]
    if shape = "target-fire2" [
      if random 1000 = 0 [set shape "target-fire1"]
    ]
    set on-fire on-fire - 1
    if on-fire <= 0 [
      set on-fire 0
      if shape = "target-fire1" or shape = "target-fire2" [
        set shape "target"
      ]
    ]
  ]
end

to clear
  repeat 30 [show ""]
end

to mattack
  ask mobs [if class = "meele"  [ifelse count players in-radius ar > 0 and as <= 0 [set hp hp - damage set as sas ask player 0[fd 10]] [set as as - 1]]]
  ask mobs [set ar1 ar set damage1 damage if class = "ranged"
    [ifelse count players in-radius ar > 0 and as <= 0
      [ask patch xcor ycor [sprout-mprojectiles 1 [face player 0 set mar ar1 set size 15 set damage2 damage1]] set as sas]
      [set as as - 1]]]
  ask mobs [if class = "magic" [ifelse count players in-radius ar > 0 and as <= 0 [set damage1 damage set as sas ask patches in-cone 4 40
    [set poisoned? true set pdamage damage1]]   [set as as - 1]]]



end

to chase
  ask mobs [if count players in-radius 80 > 0 [set relaxed? false]]
  ask mobs [ifelse count players in-radius 75 > 0 [face player 0 fd mspeed] [ifelse relaxed? = true [relax] [rt random 60 lt random 60 fd mspeed]] ]

end


to relax

  ask mobs [
    rt random 60 lt random 60 fd mspeed]
   ;; if [pxcor] of patch-here  > (x + 120) or [pxcor] of patch-here < (x - 120) or [pycor] of patch-here > (y + 40) or [pycor] of patch-here < (y - 40) and relaxed? = true
    ;;[face patch x y]]



end
to wander
    ask mobs [set color orange]
    ask mprojectiles [set color orange]
  if hp <= 0 [ask players [setxy random-xcor random-ycor set color brown set hp 100]]

    chase
    mattack
    rchase
    poison

    ask mobs [if [pxcor] of patch-here = min-pxcor + side-width or [pxcor] of patch-here = max-pxcor - side-width
    or [pycor] of patch-here = min-pycor + side-width or [pycor] of patch-here = max-pycor - side-width
      [ifelse random 2 = 0 [rt 150] [lt 150]]]

end

to rchase
  ask mprojectiles [fd 5.5 set dist dist + 1]
  ask mprojectiles [if dist > mar [die]]
  ask mprojectiles [if count players in-radius size > 0 [set hp hp - damage2]]
end
to setpoison
    ask patches [if poisoned? = true and dtime <= 50[set pcolor red]]
  ask patches [if poisoned? = true and dtime > 50[set pcolor ocolor set poisoned? false set dtime 0 set pdamage 0]]
  ask patches [if poisoned? = true [set dtime dtime + 1]]
end
to poison
  ask player 0[ask patch-here [if poisoned? = true [set hp hp - pdamage]]]
end
to-report playerHP
  report hp
end
@#$#@#$#@
GRAPHICS-WINDOW
209
59
818
469
-1
-1
1.0
1
10
1
1
1
0
0
0
1
-300
300
-200
200
0
0
1
ticks
30.0

BUTTON
19
20
92
53
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
57
101
139
134
Forward
w
NIL
1
T
OBSERVER
NIL
W
NIL
NIL
1

BUTTON
405
507
474
540
Right
d
NIL
1
T
OBSERVER
NIL
D
NIL
NIL
0

BUTTON
344
507
407
540
Left
a
NIL
1
T
OBSERVER
NIL
A
NIL
NIL
0

BUTTON
368
539
439
572
Down
s
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
0

BUTTON
91
20
199
53
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
97
174
177
219
NIL
room
17
1
11

MONITOR
20
174
98
219
NIL
level
17
1
11

BUTTON
64
133
135
166
Attack
attack
NIL
1
T
OBSERVER
NIL
E
NIL
NIL
1

SWITCH
473
505
631
538
watch-character
watch-character
1
1
-1000

SWITCH
438
538
630
571
use-mouse-to-point?
use-mouse-to-point?
0
1
-1000

TEXTBOX
213
10
822
53
TITLE OF OUR DUNGEON GAME
40
0.0
1

SLIDER
14
241
186
274
Start-Level
Start-Level
0
3
0.0
1
1
NIL
HORIZONTAL

BUTTON
819
75
948
108
Knight
set-character-knight
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
819
106
948
139
Archer
set-character-archer
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
818
138
948
171
Wizard
set-character-wizard
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
443
488
593
506
Are these needed?
11
0.0
1

TEXTBOX
842
58
992
76
Pick a character:
11
0.0
1

MONITOR
838
297
928
342
NIL
mouse-xcor
17
1
11

MONITOR
840
355
929
400
NIL
mouse-ycor
17
1
11

TEXTBOX
36
55
208
97
Press setup, then go to start.\nThe Command Center has\ninstructions!
11
0.0
1

MONITOR
978
238
1147
283
NIL
[target-health] of turtle 2
17
1
11

BUTTON
819
196
950
229
Skip Tutorial
skip-tutorial
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
743
510
983
555
NIL
count turtles with [shape = \"fireball\"]
17
1
11

MONITOR
844
429
1424
474
NIL
[on-fire] of turtles with [shape = \"target\" or shape = \"target-fire1\" or shape = \"target-fire2\"]
17
1
11

BUTTON
958
308
1186
341
Reset Target Health (for testing)
ask turtles with [shape = \"target\"] [set target-health 1000]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
25
275
175
293
Used to skip levels in demo
11
0.0
1

TEXTBOX
950
108
1271
136
Fires arrows that do a fair amount of damage.
11
0.0
1

TEXTBOX
950
142
1270
184
Throws fireballs which cause some damage and set enemy on fire, causing more damage.
11
0.0
1

TEXTBOX
950
78
1269
103
Uses a sword to defeat enemies. Causes a fair amount of damage.
11
0.0
1

TEXTBOX
949
53
1281
75
All characters cause the same amount of damage per attack.\n------------------------------------------------------
11
0.0
1

MONITOR
24
317
151
362
NIL
projectile-can-fire
17
1
11

MONITOR
23
379
80
424
NIL
ptimer
17
1
11

BUTTON
97
389
168
422
switch
ask turtles [\n ifelse shape = \"knight4\" [set shape \"knight5\"]\n [if shape = \"knight5\" [set shape \"knight4\"]]\n]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
60
470
134
503
NIL
setup1
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
152
525
219
570
NIL
playerHP
17
1
11

BUTTON
1219
209
1360
242
setupbackground
setup\ncro 6 [set shape \"back1\" set size 300 set heading 0]\nask turtle 1 [fd 80 set heading 90 fd 180]\nask turtle 2 [fd 80 set heading -90 fd 180]\nask turtle 3 [set heading 180 fd 80 set heading -90 fd 180]\nask turtle 4 [set heading 180 fd 80 set heading 90 fd 180]\nask turtle 5 [set heading 180 fd 80]\nask turtle 6 [fd 80]\n\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

back1
true
4
Rectangle -1184463 true true 45 45 255 255

back11
true
4
Rectangle -1184463 true true 45 45 255 255
Polygon -2674135 true false 165 75 90 165 195 195 240 135 165 75 165 75

back2
true
0
Rectangle -7500403 true true 105 120 195 180

back3
true
0
Rectangle -2674135 true false 45 75 255 225

basic-sword
true
0
Rectangle -6459832 true false 0 285 15 300
Rectangle -7500403 true true 0 255 45 300
Rectangle -6459832 true false 30 240 60 270
Rectangle -6459832 true false 45 225 75 255
Rectangle -6459832 true false 15 270 30 285
Rectangle -7500403 true true 45 240 60 255
Rectangle -7500403 true true 60 210 75 225
Rectangle -7500403 true true 45 180 60 210
Rectangle -7500403 true true 30 150 45 180
Rectangle -7500403 true true 60 165 60 165
Rectangle -7500403 true true 45 150 60 165
Rectangle -7500403 true true 60 165 75 180
Rectangle -7500403 true true 75 180 90 210
Rectangle -7500403 true true 90 210 120 225
Rectangle -7500403 true true 120 225 135 240
Rectangle -7500403 true true 135 240 150 270
Rectangle -7500403 true true 120 255 135 270
Rectangle -7500403 true true 90 240 120 255
Rectangle -7500403 true true 75 225 90 240
Polygon -6459832 true false 90 210 90 165 105 165 105 150 120 150 120 135 135 135 135 120 150 120 150 105 165 105 165 90 180 90 180 75 195 75 195 60 240 60 240 105 225 105 225 120 210 120 210 135 195 135 195 150 180 150 180 165 165 165 165 180 150 180 150 195 135 195 135 210 90 210 90 210
Rectangle -6459832 true false 45 165 60 180
Rectangle -6459832 true false 60 180 75 195
Rectangle -6459832 true false 75 210 90 225
Rectangle -6459832 true false 60 195 75 210
Rectangle -6459832 true false 90 225 105 240
Rectangle -6459832 true false 105 225 120 240
Rectangle -6459832 true false 120 240 135 255
Rectangle -7500403 true true 120 165 135 180
Rectangle -7500403 true true 135 150 150 165
Rectangle -7500403 true true 165 120 180 135
Rectangle -7500403 true true 195 90 210 105

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

butto
false
0
Polygon -13345367 true false 15 60 45 60 50 46 33 39 50 28 45 15 15 15 15 15
Polygon -13345367 true false 60 15 60 60 105 60 105 15 90 15 90 45 75 45 75 15 60 15 60 15 60 15
Polygon -13345367 true false 135 60 135 30 120 30 120 15 165 15 165 30 150 30 150 60
Polygon -13345367 true false 195 60 210 60 210 45 210 30 225 30 225 15 180 15 180 30 195 30 195 60
Polygon -13345367 true false 240 15 240 60 285 60 285 15 240 15 240 15

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

click
false
0
Rectangle -13345367 true false 15 15 30 30
Rectangle -13345367 true false 15 30 30 45
Polygon -13345367 true false 15 45 15 45 15 60 60 60 60 45 30 45 30 30 60 30 60 15 30 15 30 15 15 15 15 60 15 60 15 45
Polygon -13345367 true false 75 15 75 60 120 60 120 45 90 45 90 15
Polygon -13345367 true false 135 15 135 60 150 60 150 15 135 15 135 15 135 15
Polygon -13345367 true false 165 45 165 45 165 60 210 60 210 45 180 45 180 30 210 30 210 15 180 15 180 15 165 15 165 60 165 60 165 45
Polygon -13345367 true false 225 15 225 60 240 60 240 15
Polygon -13345367 true false 240 30 255 15 255 30 240 45 240 30 240 30 240 30 240 45 240 45
Polygon -13345367 true false 255 60 255 45 240 30 240 45 255 60 255 60
Polygon -13345367 true false 255 45 270 60 255 60
Polygon -13345367 true false 255 30 270 15 255 15

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fire
false
0
Polygon -7500403 true true 151 286 134 282 103 282 59 248 40 210 32 157 37 108 68 146 71 109 83 72 111 27 127 55 148 11 167 41 180 112 195 57 217 91 226 126 227 203 256 156 256 201 238 263 213 278 183 281
Polygon -955883 true false 126 284 91 251 85 212 91 168 103 132 118 153 125 181 135 141 151 96 185 161 195 203 193 253 164 286
Polygon -2674135 true false 155 284 172 268 172 243 162 224 148 201 130 233 131 260 135 282

fireball
true
0
Polygon -955883 true false 135 150 150 165 149 156
Polygon -955883 true false 135 151 138 202 148 175 156 229 165 149 165 149
Circle -2674135 true false 135 135 30

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

knight
false
0
Rectangle -13345367 true false 32 90 272 195
Polygon -16777216 true false 37 102 37 185 46 185 47 155 66 181 77 183 49 145 75 114 80 106 63 106 48 133 49 105
Polygon -16777216 true false 84 104 82 182 93 184 95 129 114 182 125 181 123 108 114 108 115 157 97 107 88 107
Polygon -16777216 true false 139 108 139 180 146 180 148 105
Polygon -16777216 true false 134 273
Rectangle -13345367 true false 201 119 227 147
Polygon -16777216 true false 198 138 189 139 188 132 184 128 177 124 171 125 164 128 163 135 162 140 160 147 160 155 163 164 167 169 175 171 184 170 188 166 190 159 183 159 177 159 174 159 176 151 198 151 199 155 199 160 197 170 192 178 185 179 177 180 169 180 159 178 155 171 153 164 152 152 152 144 153 135 156 127 160 120 168 114 175 112 182 112 187 113 189 116 189 118 194 127 197 131
Polygon -16777216 true false 202 107 203 180 210 179 209 153 221 153 221 178 229 178 231 110 224 110 220 144 211 144 212 112
Polygon -16777216 true false 255 177 247 177 248 121 236 121 236 113 270 113 270 122 257 123

knight1
false
0
Polygon -7500403 true true 92 106 89 123 83 129 77 134 68 138 58 141 54 141 52 122 64 118 67 114 66 114 65 116 69 112 71 108 74 103 75 95 78 79 98 84
Polygon -7500403 true true 113 276 117 234 127 189 133 178 144 154 132 153 119 152 108 150 98 147 93 162 88 186 87 211 87 234 87 253 90 265
Polygon -7500403 true true 166 273 177 280 185 283 191 284 199 285 199 291 144 290 140 284 141 279 166 269
Polygon -7500403 true true 142 291 138 249 128 204 122 193 111 169 123 168 136 167 147 165 157 162 162 177 167 201 168 226 168 249 168 268 165 280
Polygon -16777216 true false 134 230 140 227 150 226 162 223 168 221 168 227 152 233 139 236 136 237
Polygon -16777216 true false 119 228 113 225 103 224 91 221 85 219 85 225 101 231 114 234 117 235
Polygon -1 true false 156 219 152 227 154 233 164 236 168 233 173 227 174 225 172 221 167 216 160 217
Polygon -16777216 true false 112 281 113 273 88 262 89 269
Polygon -16777216 true false 140 286 140 279 167 269 167 277
Polygon -7500403 true true 87 274 76 281 68 284 62 285 54 286 54 292 109 291 113 285 112 280 87 270
Polygon -7500403 true true 169 185 140 193 128 193 104 194 81 192 95 141 110 146 125 147 138 147 154 146 161 145
Polygon -7500403 true true 96 149 87 79 99 68 159 68 167 76 160 149
Polygon -6459832 true false 130 180 173 204 206 175 202 142 200 110 198 79 188 85 182 86 171 87 155 87 146 88 136 88 125 86
Polygon -7500403 true true 160 70 192 83 186 86 172 87 163 87 159 83
Polygon -7500403 true true 199 92 215 108 214 117 211 121 201 133
Polygon -16777216 false false 81 192 121 196 138 196 157 195 127 198
Polygon -1 true false 173 66 178 66 178 69 178 74 177 79 174 83 169 86 165 86 161 83 159 80 157 74 156 69 156 68 155 64 155 60 159 62 164 63 169 61 171 65
Polygon -16777216 false false 97 144 105 151 111 151 119 153 129 154 130 154 120 154 112 151 106 151 96 145
Line -16777216 false 90 112 89 91
Line -16777216 false 67 115 80 128
Polygon -16777216 true false 54 119 57 144 40 144 32 143 29 139 37 138 40 136 33 133 33 129 42 132 42 127 33 126 34 123
Polygon -7500403 true true 129 68 137 70 148 70 151 65 148 59 144 54 144 47 147 42 143 41 135 45 130 45 130 54 130 61 130 67
Polygon -7500403 true true 125 69 117 71 106 71 103 66 106 60 110 55 110 48 107 43 111 42 119 46 124 46 124 55 124 62 124 68
Polygon -16777216 true false 125 67 130 67 130 46 138 45 141 42 143 40 135 39 130 39 123 39 117 39 111 39 109 41 108 43 112 43 115 45 119 45 125 45 125 48
Polygon -16777216 false false 103 66 112 70 118 69 124 68 129 68 129 68 143 71 148 70 151 67 151 65 148 58 145 53 145 49 145 40 146 43 146 42 141 40 114 39 112 41 110 42 109 44 106 44 107 48 109 51 109 55 106 59
Polygon -7500403 true true 109 40 109 35 113 29 116 27 124 26 132 26 139 27 141 29 143 32 143 34 144 40
Line -16777216 false 121 52 120 64
Line -16777216 false 116 52 114 65
Line -16777216 false 135 52 136 65
Line -16777216 false 141 53 144 66
Polygon -1 true false 83 71 78 71 78 74 78 79 79 84 82 88 87 91 91 91 95 88 97 85 99 79 100 74 100 73 101 69 101 65 97 67 92 68 87 66 85 70
Line -1184463 false 162 89 172 203
Polygon -1 true false 99 219 103 227 101 233 91 236 87 233 82 227 81 225 83 221 88 216 95 217
Line -1184463 false 127 122 199 116

knight2
false
0
Polygon -7500403 true true 92 106 89 123 83 129 77 134 68 138 58 141 54 141 52 122 64 118 67 114 66 114 65 116 69 112 71 108 74 103 75 95 78 79 98 84
Polygon -7500403 true true 113 276 117 234 127 189 133 178 144 154 132 153 119 152 108 150 98 147 93 162 88 186 87 211 87 234 87 253 90 265
Polygon -7500403 true true 166 273 177 280 185 283 191 284 199 285 199 291 144 290 140 284 141 279 166 269
Polygon -7500403 true true 142 291 138 249 128 204 122 193 111 169 123 168 136 167 147 165 157 162 162 177 167 201 168 226 168 249 168 268 165 280
Polygon -16777216 true false 134 230 140 227 150 226 162 223 168 221 168 227 152 233 139 236 136 237
Polygon -16777216 true false 119 228 113 225 103 224 91 221 85 219 85 225 101 231 114 234 117 235
Polygon -1 true false 156 219 152 227 154 233 164 236 168 233 173 227 174 225 172 221 167 216 160 217
Polygon -16777216 true false 112 281 113 273 88 262 89 269
Polygon -16777216 true false 140 286 140 279 167 269 167 277
Polygon -7500403 true true 87 274 76 281 68 284 62 285 54 286 54 292 109 291 113 285 112 280 87 270
Polygon -7500403 true true 169 185 140 193 128 193 104 194 81 192 95 141 110 146 125 147 138 147 154 146 161 145
Polygon -7500403 true true 96 149 87 79 99 68 159 68 167 76 160 149
Polygon -6459832 true false 130 180 173 204 206 175 202 142 200 110 198 79 188 85 182 86 171 87 155 87 146 88 136 88 125 86
Polygon -7500403 true true 160 70 192 83 186 86 172 87 163 87 159 83
Polygon -7500403 true true 199 92 215 108 214 117 211 121 201 133
Polygon -16777216 false false 81 192 121 196 138 196 157 195 127 198
Polygon -1 true false 173 66 178 66 178 69 178 74 177 79 174 83 169 86 165 86 161 83 159 80 157 74 156 69 156 68 155 64 155 60 159 62 164 63 169 61 171 65
Polygon -16777216 false false 97 144 105 151 111 151 119 153 129 154 130 154 120 154 112 151 106 151 96 145
Line -16777216 false 90 112 89 91
Line -16777216 false 67 115 80 128
Polygon -16777216 true false 54 119 57 144 40 144 32 143 29 139 37 138 40 136 33 133 33 129 42 132 42 127 33 126 34 123
Polygon -7500403 true true 129 68 137 70 148 70 151 65 148 59 144 54 144 47 147 42 143 41 135 45 130 45 130 54 130 61 130 67
Polygon -7500403 true true 125 69 117 71 106 71 103 66 106 60 110 55 110 48 107 43 111 42 119 46 124 46 124 55 124 62 124 68
Polygon -16777216 true false 125 67 130 67 130 46 138 45 141 42 143 40 135 39 130 39 123 39 117 39 111 39 109 41 108 43 112 43 115 45 119 45 125 45 125 48
Polygon -16777216 false false 103 66 112 70 118 69 124 68 129 68 129 68 143 71 148 70 151 67 151 65 148 58 145 53 145 49 145 40 146 43 146 42 141 40 114 39 112 41 110 42 109 44 106 44 107 48 109 51 109 55 106 59
Polygon -7500403 true true 109 40 109 35 113 29 116 27 124 26 132 26 139 27 141 29 143 32 143 34 144 40
Line -16777216 false 121 52 120 64
Line -16777216 false 116 52 114 65
Line -16777216 false 135 52 136 65
Line -16777216 false 141 53 144 66
Polygon -1 true false 83 71 78 71 78 74 78 79 79 84 82 88 87 91 91 91 95 88 97 85 99 79 100 74 100 73 101 69 101 65 97 67 92 68 87 66 85 70
Line -1184463 false 162 89 172 203
Polygon -1 true false 99 219 103 227 101 233 91 236 87 233 82 227 81 225 83 221 88 216 95 217
Line -1184463 false 127 122 199 116
Polygon -7500403 true true 41 146 31 146 31 125 20 125 20 113 53 113 53 125 41 125
Polygon -7500403 true true 41 116 41 20 36 17 31 21 30 113 32 118

knight3
false
0
Polygon -7500403 true true 92 106 89 123 83 129 77 134 68 138 58 141 54 141 52 122 64 118 67 114 66 114 65 116 69 112 71 108 74 103 75 95 78 79 98 84
Polygon -7500403 true true 113 276 117 234 127 189 133 178 144 154 132 153 119 152 108 150 98 147 93 162 88 186 87 211 87 234 87 253 90 265
Polygon -7500403 true true 166 273 177 280 185 283 191 284 199 285 199 291 144 290 140 284 141 279 166 269
Polygon -7500403 true true 142 291 138 249 128 204 122 193 111 169 123 168 136 167 147 165 157 162 162 177 167 201 168 226 168 249 168 268 165 280
Polygon -16777216 true false 134 230 140 227 150 226 162 223 168 221 168 227 152 233 139 236 136 237
Polygon -16777216 true false 119 228 113 225 103 224 91 221 85 219 85 225 101 231 114 234 117 235
Polygon -1 true false 156 219 152 227 154 233 164 236 168 233 173 227 174 225 172 221 167 216 160 217
Polygon -16777216 true false 112 281 113 273 88 262 89 269
Polygon -16777216 true false 140 286 140 279 167 269 167 277
Polygon -7500403 true true 87 274 76 281 68 284 62 285 54 286 54 292 109 291 113 285 112 280 87 270
Polygon -7500403 true true 169 185 140 193 128 193 104 194 81 192 95 141 110 146 125 147 138 147 154 146 161 145
Polygon -7500403 true true 96 149 87 79 99 68 159 68 167 76 160 149
Polygon -6459832 true false 130 180 173 204 206 175 202 142 200 110 198 79 188 85 182 86 171 87 155 87 146 88 136 88 125 86
Polygon -7500403 true true 160 70 192 83 186 86 172 87 163 87 159 83
Polygon -7500403 true true 199 92 215 108 214 117 211 121 201 133
Polygon -16777216 false false 81 192 121 196 138 196 157 195 127 198
Polygon -1 true false 173 66 178 66 178 69 178 74 177 79 174 83 169 86 165 86 161 83 159 80 157 74 156 69 156 68 155 64 155 60 159 62 164 63 169 61 171 65
Polygon -16777216 false false 97 144 105 151 111 151 119 153 129 154 130 154 120 154 112 151 106 151 96 145
Line -16777216 false 90 112 89 91
Line -16777216 false 67 115 80 128
Polygon -16777216 true false 54 119 57 144 40 144 32 143 29 139 37 138 40 136 33 133 33 129 42 132 42 127 33 126 34 123
Polygon -7500403 true true 129 68 137 70 148 70 151 65 148 59 144 54 144 47 147 42 143 41 135 45 130 45 130 54 130 61 130 67
Polygon -7500403 true true 125 69 117 71 106 71 103 66 106 60 110 55 110 48 107 43 111 42 119 46 124 46 124 55 124 62 124 68
Polygon -16777216 true false 125 67 130 67 130 46 138 45 141 42 143 40 135 39 130 39 123 39 117 39 111 39 109 41 108 43 112 43 115 45 119 45 125 45 125 48
Polygon -16777216 false false 103 66 112 70 118 69 124 68 129 68 129 68 143 71 148 70 151 67 151 65 148 58 145 53 145 49 145 40 146 43 146 42 141 40 114 39 112 41 110 42 109 44 106 44 107 48 109 51 109 55 106 59
Polygon -7500403 true true 109 40 109 35 113 29 116 27 124 26 132 26 139 27 141 29 143 32 143 34 144 40
Line -16777216 false 121 52 120 64
Line -16777216 false 116 52 114 65
Line -16777216 false 135 52 136 65
Line -16777216 false 141 53 144 66
Polygon -1 true false 83 71 78 71 78 74 78 79 79 84 82 88 87 91 91 91 95 88 97 85 99 79 100 74 100 73 101 69 101 65 97 67 92 68 87 66 85 70
Line -1184463 false 162 89 172 203
Polygon -1 true false 99 219 103 227 101 233 91 236 87 233 82 227 81 225 83 221 88 216 95 217
Line -1184463 false 127 122 199 116
Polygon -7500403 true true 46 146 37 147 30 132 19 134 14 126 51 115 53 125 41 129
Polygon -7500403 true true 40 119 11 20 2 11 1 22 28 125

knight4
false
0
Polygon -7500403 true true 223 72 241 76 246 80 253 87 226 93
Polygon -7500403 true true 152 106 149 123 143 129 137 134 128 138 118 141 114 141 112 122 124 118 127 114 126 114 125 116 129 112 131 108 134 103 135 95 138 79 158 84
Polygon -7500403 true true 173 276 177 234 187 189 193 178 204 154 192 153 179 152 168 150 158 147 153 162 148 186 147 211 147 234 147 253 150 265
Polygon -7500403 true true 241 273 252 280 260 283 266 284 274 285 274 291 219 290 215 284 216 279 241 269
Polygon -7500403 true true 217 291 213 249 203 204 197 193 186 169 198 168 211 167 222 165 232 162 237 177 242 201 243 226 243 249 243 268 240 280
Polygon -16777216 true false 209 230 215 227 225 226 237 223 243 221 243 227 227 233 214 236 211 237
Polygon -16777216 true false 179 228 173 225 163 224 151 221 145 219 145 225 161 231 174 234 177 235
Polygon -1 true false 231 219 227 227 229 233 239 236 243 233 248 227 249 225 247 221 242 216 235 217
Polygon -16777216 true false 172 281 173 273 148 262 149 269
Polygon -16777216 true false 215 286 215 279 242 269 242 277
Polygon -7500403 true true 147 274 136 281 128 284 122 285 114 286 114 292 169 291 173 285 172 280 147 270
Polygon -7500403 true true 229 185 200 193 188 193 164 194 141 192 155 141 170 146 185 147 198 147 214 146 221 145
Polygon -7500403 true true 156 149 147 79 159 68 219 68 227 76 220 149
Polygon -6459832 true false 190 180 233 204 266 175 262 142 260 110 258 79 248 85 242 86 231 87 215 87 206 88 196 88 185 86
Polygon -7500403 true true 160 70 192 83 186 86 172 87 163 87 159 83
Polygon -7500403 true true 259 92 275 108 274 117 271 121 261 133
Polygon -1 true false 233 66 238 66 238 69 238 74 237 79 234 83 229 86 225 86 221 83 219 80 217 74 216 69 216 68 215 64 215 60 219 62 224 63 229 61 231 65
Line -16777216 false 127 115 140 128
Polygon -16777216 true false 114 119 117 144 100 144 92 143 89 139 97 138 100 136 93 133 93 129 102 132 102 127 93 126 94 123
Polygon -7500403 true true 189 68 197 70 208 70 211 65 208 59 204 54 204 47 207 42 203 41 195 45 190 45 190 54 190 61 190 67
Polygon -7500403 true true 185 69 177 71 166 71 163 66 166 60 170 55 170 48 167 43 171 42 179 46 184 46 184 55 184 62 184 68
Polygon -16777216 true false 185 67 190 67 190 46 198 45 201 42 203 40 195 39 190 39 183 39 177 39 171 39 169 41 168 43 172 43 175 45 179 45 185 45 185 48
Polygon -16777216 false false 163 66 172 70 178 69 184 68 189 68 189 68 203 71 208 70 211 67 211 65 208 58 205 53 205 49 205 40 206 43 206 42 201 40 174 39 172 41 170 42 169 44 166 44 167 48 169 51 169 55 166 59
Polygon -7500403 true true 169 40 169 35 173 29 176 27 184 26 192 26 199 27 201 29 203 32 203 34 204 40
Line -16777216 false 181 52 180 64
Line -16777216 false 176 52 174 65
Line -16777216 false 195 52 196 65
Line -16777216 false 201 53 204 66
Polygon -1 true false 143 71 138 71 138 74 138 79 139 84 142 88 147 91 151 91 155 88 157 85 159 79 160 74 160 73 161 69 161 65 157 67 152 68 147 66 145 70
Line -1184463 false 222 89 232 203
Polygon -1 true false 159 219 163 227 161 233 151 236 147 233 142 227 141 225 143 221 148 216 155 217
Line -1184463 false 187 122 259 116
Polygon -7500403 true true 101 146 91 146 91 125 80 125 80 113 113 113 113 125 101 125
Polygon -7500403 true true 101 116 101 20 96 17 91 21 90 113 92 118
Line -16777216 false 155 141 175 146
Line -16777216 false 176 146 188 145
Line -16777216 false 151 113 151 92
Line -16777216 false 142 192 213 193

knight5
false
0
Polygon -7500403 true true 223 72 241 76 246 80 253 87 226 93
Polygon -7500403 true true 152 106 149 123 143 129 137 134 128 138 118 141 114 141 112 122 124 118 127 114 126 114 125 116 129 112 131 108 134 103 135 95 138 79 158 84
Polygon -7500403 true true 173 276 177 234 187 189 193 178 204 154 192 153 179 152 168 150 158 147 153 162 148 186 147 211 147 234 147 253 150 265
Polygon -7500403 true true 241 273 252 280 260 283 266 284 274 285 274 291 219 290 215 284 216 279 241 269
Polygon -7500403 true true 217 291 213 249 203 204 197 193 186 169 198 168 211 167 222 165 232 162 237 177 242 201 243 226 243 249 243 268 240 280
Polygon -16777216 true false 209 230 215 227 225 226 237 223 243 221 243 227 227 233 214 236 211 237
Polygon -16777216 true false 179 228 173 225 163 224 151 221 145 219 145 225 161 231 174 234 177 235
Polygon -1 true false 231 219 227 227 229 233 239 236 243 233 248 227 249 225 247 221 242 216 235 217
Polygon -16777216 true false 172 281 173 273 148 262 149 269
Polygon -16777216 true false 215 286 215 279 242 269 242 277
Polygon -7500403 true true 147 274 136 281 128 284 122 285 114 286 114 292 169 291 173 285 172 280 147 270
Polygon -7500403 true true 229 185 200 193 188 193 164 194 141 192 155 141 170 146 185 147 198 147 214 146 221 145
Polygon -7500403 true true 156 149 147 79 159 68 219 68 227 76 220 149
Polygon -6459832 true false 190 180 233 204 266 175 262 142 260 110 258 79 248 85 242 86 231 87 215 87 206 88 196 88 185 86
Polygon -7500403 true true 160 70 192 83 186 86 172 87 163 87 159 83
Polygon -7500403 true true 259 92 275 108 274 117 271 121 261 133
Polygon -1 true false 233 66 238 66 238 69 238 74 237 79 234 83 229 86 225 86 221 83 219 80 217 74 216 69 216 68 215 64 215 60 219 62 224 63 229 61 231 65
Line -16777216 false 127 115 140 128
Polygon -16777216 true false 114 119 117 144 100 144 92 143 89 139 97 138 100 136 93 133 93 129 102 132 102 127 93 126 94 123
Polygon -7500403 true true 189 68 197 70 208 70 211 65 208 59 204 54 204 47 207 42 203 41 195 45 190 45 190 54 190 61 190 67
Polygon -7500403 true true 185 69 177 71 166 71 163 66 166 60 170 55 170 48 167 43 171 42 179 46 184 46 184 55 184 62 184 68
Polygon -16777216 true false 185 67 190 67 190 46 198 45 201 42 203 40 195 39 190 39 183 39 177 39 171 39 169 41 168 43 172 43 175 45 179 45 185 45 185 48
Polygon -16777216 false false 163 66 172 70 178 69 184 68 189 68 189 68 203 71 208 70 211 67 211 65 208 58 205 53 205 49 205 40 206 43 206 42 201 40 174 39 172 41 170 42 169 44 166 44 167 48 169 51 169 55 166 59
Polygon -7500403 true true 169 40 169 35 173 29 176 27 184 26 192 26 199 27 201 29 203 32 203 34 204 40
Line -16777216 false 181 52 180 64
Line -16777216 false 176 52 174 65
Line -16777216 false 195 52 196 65
Line -16777216 false 201 53 204 66
Polygon -1 true false 143 71 138 71 138 74 138 79 139 84 142 88 147 91 151 91 155 88 157 85 159 79 160 74 160 73 161 69 161 65 157 67 152 68 147 66 145 70
Line -1184463 false 222 89 232 203
Polygon -1 true false 159 219 163 227 161 233 151 236 147 233 142 227 141 225 143 221 148 216 155 217
Line -1184463 false 187 122 259 116
Polygon -7500403 true true 116 133 108 142 92 129 81 137 73 128 97 102 109 112 100 122
Polygon -7500403 true true 93 114 16 50 6 50 7 62 82 123 88 120
Line -16777216 false 155 141 175 146
Line -16777216 false 176 146 188 145
Line -16777216 false 151 113 151 92
Line -16777216 false 142 192 213 193

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

meele
false
0
Rectangle -7500403 true true 120 30 135 45
Rectangle -7500403 true true 105 45 120 60
Polygon -1 true false 165 30 135 30 135 45 120 45 120 60 105 60 105 105 135 105 135 120 150 120 150 135 180 135 180 120 195 120 195 60 180 60 180 45 165 45 165 30
Rectangle -7500403 true true 135 120 150 135
Rectangle -7500403 true true 150 135 165 150
Rectangle -7500403 true true 120 105 135 120
Rectangle -7500403 true true 150 165 165 180
Rectangle -7500403 true true 150 195 165 210
Rectangle -1 true false 150 180 165 195
Rectangle -1 true false 150 210 165 225
Rectangle -1 true false 150 150 165 165
Rectangle -7500403 true true 165 270 180 285
Rectangle -7500403 true true 135 270 150 285
Rectangle -7500403 true true 165 240 180 255
Rectangle -7500403 true true 150 225 165 240
Rectangle -7500403 true true 135 240 150 255
Rectangle -7500403 true true 165 210 180 225
Rectangle -7500403 true true 135 210 150 225
Rectangle -1 true false 135 225 150 240
Rectangle -1 true false 165 255 180 270
Rectangle -1 true false 165 225 180 240
Rectangle -1 true false 135 255 150 270
Rectangle -16777216 true false 180 75 195 90
Rectangle -16777216 true false 165 90 180 105
Rectangle -16777216 true false 135 75 150 90
Rectangle -7500403 true true 165 150 210 165
Rectangle -1 true false 165 165 210 180
Rectangle -6459832 true false 210 135 225 180
Rectangle -7500403 true true 210 180 225 195
Polygon -7500403 true true 210 135 210 60 225 75 225 135

n
false
0
Polygon -13345367 true false 15 60 15 15 60 15 60 60 45 60 45 30 30 30 30 60 15 60 15 60

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

person graduate
false
0
Circle -16777216 false false 39 183 20
Polygon -1 true false 50 203 85 213 118 227 119 207 89 204 52 185
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -8630108 true false 90 19 150 37 210 19 195 4 105 4
Polygon -8630108 true false 120 90 105 90 60 195 90 210 120 165 90 285 105 300 195 300 210 285 180 165 210 210 240 195 195 90
Polygon -1184463 true false 135 90 120 90 150 135 180 90 165 90 150 105
Line -2674135 false 195 90 150 135
Line -2674135 false 105 90 150 135
Polygon -1 true false 135 90 150 105 165 90
Circle -1 true false 104 205 20
Circle -1 true false 41 184 20
Circle -16777216 false false 106 206 18
Line -2674135 false 208 22 208 57

person police
false
0
Polygon -1 true false 124 91 150 165 178 91
Polygon -13345367 true false 134 91 149 106 134 181 149 196 164 181 149 106 164 91
Polygon -13345367 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Polygon -13345367 true false 120 90 105 90 60 195 90 210 116 158 120 195 180 195 184 158 210 210 240 195 195 90 180 90 165 105 150 165 135 105 120 90
Rectangle -7500403 true true 123 76 176 92
Circle -7500403 true true 110 5 80
Polygon -13345367 true false 150 26 110 41 97 29 137 -1 158 6 185 0 201 6 196 23 204 34 180 33
Line -13345367 false 121 90 194 90
Line -16777216 false 148 143 150 196
Rectangle -16777216 true false 116 186 182 198
Rectangle -16777216 true false 109 183 124 227
Rectangle -16777216 true false 176 183 195 205
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Polygon -1184463 true false 172 112 191 112 185 133 179 133
Polygon -1184463 true false 175 6 194 6 189 21 180 21
Line -1184463 false 149 24 197 24
Rectangle -16777216 true false 101 177 122 187
Rectangle -16777216 true false 179 164 183 186

person soldier
false
0
Rectangle -7500403 true true 127 79 172 94
Polygon -10899396 true false 105 90 60 195 90 210 135 105
Polygon -10899396 true false 195 90 240 195 210 210 165 105
Circle -7500403 true true 110 5 80
Polygon -10899396 true false 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -6459832 true false 120 90 105 90 180 195 180 165
Line -6459832 false 109 105 139 105
Line -6459832 false 122 125 151 117
Line -6459832 false 137 143 159 134
Line -6459832 false 158 179 181 158
Line -6459832 false 146 160 169 146
Rectangle -6459832 true false 120 193 180 201
Polygon -6459832 true false 122 4 107 16 102 39 105 53 148 34 192 27 189 17 172 2 145 0
Polygon -16777216 true false 183 90 240 15 247 22 193 90
Rectangle -6459832 true false 114 187 128 208
Rectangle -6459832 true false 177 187 191 208

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -2674135 true false 0 0 300
Circle -1 true false 30 30 240
Circle -2674135 true false 60 60 180
Circle -1 true false 90 90 120
Circle -2674135 true false 120 120 60

target-fire1
false
0
Circle -2674135 true false 0 0 300
Circle -1 true false 30 30 240
Circle -2674135 true false 60 60 180
Circle -1 true false 90 90 120
Circle -2674135 true false 120 120 60
Polygon -955883 true false 105 255 75 240 60 210 45 150 45 120 75 150 90 135 75 105 90 60 105 45 120 60 135 30 150 45 150 60 150 75 165 60 180 75 195 90 210 120 225 150 225 195 255 165 255 195 240 225 195 255 165 270 105 255 105 255
Polygon -2674135 true false 165 270 120 240 90 210 90 165 105 120 120 150 150 90 165 120 180 150 195 195 195 225 165 270
Polygon -955883 true false 164 270 150 254 141 243 130 215 146 216 149 192 157 213 166 210 168 221 183 204 172 238 174 249 168 258 167 264

target-fire2
false
0
Circle -2674135 true false 0 0 300
Circle -1 true false 30 30 240
Circle -2674135 true false 60 60 180
Circle -1 true false 90 90 120
Circle -2674135 true false 120 120 60
Polygon -955883 true false 105 256 75 241 51 215 23 169 28 126 75 151 45 98 75 106 81 57 115 72 115 31 141 42 161 27 165 51 174 62 169 79 211 69 217 108 248 99 225 151 225 196 255 166 255 196 240 226 195 256 165 271 105 256 105 256
Polygon -2674135 true false 165 270 120 240 75 212 90 165 105 120 120 150 150 90 177 107 207 123 195 195 195 225 165 270
Polygon -955883 true false 163 269 149 253 135 233 129 214 142 189 149 206 166 187 165 209 173 196 177 218 171 237 173 248 167 257 166 263

temp-sword
true
0
Polygon -6459832 true false 165 150 150 135 270 15 285 30

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
