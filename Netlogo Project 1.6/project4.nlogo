;; Notes
;; Maybe level 0 can be the tutorial level?
;; We can also have the initial character selection be level -1,
;; in order to differentiate it?
;; Need to adjust the way barriers work when moving sideways (a/d)
;; Need to improve barrier detection for points other than center, front, and back
;; Currently only checks for barriers in 3 places

globals
[
  ;; Setup:

  side-width ;; side-width determines the width of the barrier around the world
  exits ;; exits is a list containing which exits are shown
  ;; the exits are "left" "right" "top" "bottom" and are updated by level files
  exit-width ;; exit-width determines how wide each exit is
  fancy-background ;; boolean if textured background or not

  ;; Keeping track of user:

  level ;; level is current floor
  room ;; room is current room (there are a certain number of rooms for each level)
  exit-on ;; string - which exit the user is on, or none

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
  litem ;; ex: [0 0 0 "sword" 0 0 0 0 0 0 0 0 0 "health" 0 0 0] 0 = no item, string = item name
  lkey ;; ex: [0 0 0 0 0 "mob" 0 0 0 1 0 0 0] 0 = no key in room, 1 = key in room, "mob" = key dropped by mob
  lmobdrop ;; ex: [0 0 0 0 0 0 0 "health" 0 0 0 0 0 "bow" 0 0 0]
  lr-exit ;; ex: ["0-1" "0-0" "0-2 locked" "0-1"] etc., where right exit in room leads, add locked if door locked
  ll-exit ;; same, but for left
  lt-exit ;; same, but for top
  lb-exit ;; same, but for bottom

  ;; Testing:

  test
  save
  document
]

breed[projectiles projectile]
projectiles-own[
  pspeed ;; p is a prefix designating projectiles-________ (e.g. speed, heading)
  pheading
  ;; Need more
]

to load-levels
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
  set lt-exit []
  set lb-exit []
  file-open "Level Files/0-0.txt"
  read-file
  close-all
end

to read-file
  set lexits []
  while [not file-at-end?] [
    set line file-read-line
    ;; Exits
    if member? "Exits" line [
      if member? "Left" line [set lexits lput "left" lexits]
      if member? "Right" line [set lexits lput "right" lexits]
      if member? "Top" line [set lexits lput "top" lexits]
      if member? "Bottom" line [set lexits lput "bottom" lexits]
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
      ] [ something here]]]]]
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
    
  ]
  set exits lput lexits exits
end

to setup
  ca
  set-variables
  adjust-world
  create-exits
  setup-character ;; creates the character
end

to set-variables
  set test false
  set document []
  set save "None"
  set r-exit "None"
  set l-exit "None"
  set t-exit "None"
  set b-exit "None"
  set side-width 15
  set exit-width 90
  set speed 5
  set level 0
  set room 0
  set exits []
  ;;set exits ["left" "right" "top"]
  read ;; this is a file-based way of setting exits
  set nmx mouse-xcor
  set nmy mouse-ycor
  set strafe-realign false ;; every time the character strafes, they DO NOT face toward the mouse
  set ptype 0 ;; default projectile type
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
end

to setup-character
  crt 1
  ask turtle 0 [
    set shape "person"
    set color green
    set size 50
    set heading 0
  ]
end

to go
  ;;every .1 [
  ifelse mouse-based = true [
    directional
  ] [ask turtle 0 [set heading 0]]
  firing
  ;; if mouse-down? [shoot] ;; this is too laggy
  if count projectiles > 75 [ask projectiles [die] show "Too many projectiles were fired."]
  if ptimer = 0 [set projectile-can-fire true]
  if ptimer != 0 [set projectile-can-fire false]
  if projectile-can-fire = false [set ptimer (ptimer + 1) if ptimer >= ptimer-max [set ptimer 0 set projectile-can-fire true]]
  ifelse watch-character = true [watch turtle 0] [reset-perspective]
  sense-exits
  ;;]
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
  ask turtle 0 [fd speed check]
end

to a ;; if a pressed / "left"
  ask turtle 0 [
    let oldh heading ;; creates a variable to store the turtle's previous heading
    set heading heading - 90
    fd speed
    check
    set heading oldh
    if strafe-realign = true [point]
  ]
end

to d ;; if d pressed / "right"
  ask turtle 0 [
    let oldh heading ;; creates a variable to store the turtle's previous heading
    set heading heading + 90
    fd speed
    check
    set heading oldh
    if strafe-realign = true [point]
  ]
end

to s ;; if s pressed / "backwards"
  ask turtle 0 [fd (-1 * speed) check]
end

to check ;; checks if there is a barrier
  ;; currently this only works for the exact center of the character
  if pcolor = blue [fd (speed * -1)]
  carefully [if [pcolor] of patch-ahead 15 = blue [fd (speed * -1)]]
  [if pcolor = blue [fd (speed * -1)]]
  carefully [if [pcolor] of patch-ahead -15 = blue [fd (speed * 1)]]
  [if pcolor = blue [fd (speed * 1)]]
end

to sense-exits
  ;; Determining what exit turtle on:
  ask turtle 0 [
    if pcolor = black [
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
  ]]]]]]
  if exit-on = "Right" [
    set room last r-exit
    open-the-file
    file-open "Level Files/0-2.txt"
    read
    advance-level
  ]
  if exit-on = "Left" [
    set room last l-exit
    advance-level
  ]
  if exit-on = "Top" [
    set room last t-exit
    advance-level
  ]
  if exit-on = "Bottom" [
    set room last b-exit
    advance-level
  ]
end

to setup-projectile
  if ptype = 0 [set shape "circle" set color white set size 20 set pspeed 0.1]
end

to shoot
  if projectile-can-fire = true [
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
    fire
  ]
end

to fire
  set heading pheading
  fd pspeed
  ;; Projectile-type specific behavior:
  if ptype = 0 [ if pcolor = blue or xcor >= max-pxcor or ycor >= max-pycor or ycor <= min-pycor or xcor <= min-pxcor [die] ]
end

to open-the-file
  if level = 0 [
      if room = 0 [file-open "Level Files/0-0.txt"]
      if room = 1 [file-open "Level Files/0-1.txt"]
      if room = 2 [file-open "Level Files/0-2.txt"]
      if room = 3 [file-open "Level Files/0-3.txt"]
      if room = 4 [file-open "Level Files/0-4.txt"]
    ]
    if level = 1 [
      if room = 0 [file-open "Level Files/1-0.txt"]
      if room = 1 [file-open "Level Files/1-1.txt"]
      if room = 2 [file-open "Level Files/1-2.txt"]
      if room = 3 [file-open "Level Files/1-3.txt"]
      if room = 4 [file-open "Level Files/1-4.txt"]
    ]
    if level = 2 [
      if room = 0 [file-open "Level Files/2-0.txt"]
      if room = 1 [file-open "Level Files/2-1.txt"]
      if room = 2 [file-open "Level Files/2-2.txt"]
      if room = 3 [file-open "Level Files/2-3.txt"]
      if room = 4 [file-open "Level Files/2-4.txt"]
    ]
    if level = 3 [
      if room = 0 [file-open "Level Files/3-0.txt"]
      if room = 1 [file-open "Level Files/3-1.txt"]
      if room = 2 [file-open "Level Files/3-2.txt"]
      if room = 3 [file-open "Level Files/3-3.txt"]
      if room = 4 [file-open "Level Files/3-4.txt"]
    ]
    if level = 4 [
      if room = 0 [file-open "Level Files/4-0.txt"]
      if room = 1 [file-open "Level Files/4-1.txt"]
      if room = 2 [file-open "Level Files/4-2.txt"]
      if room = 3 [file-open "Level Files/4-3.txt"]
      if room = 4 [file-open "Level Files/4-4.txt"]
    ]
end

to read
  ;;carefully [ ;; used for error handling
    open-the-file
  carefully [
    while [file-at-end? = false]
    [set line file-read-line check-line]
    file-close
  ] [
    open-the-file
    while [file-at-end? = false]
    [set line file-read-line check-line]
    file-close
  ]
  ;;][ ;; If error in reading file:
  ;;  show "There was an error loading your level."
  ;;  show "You will be returned to the beginning of this floor."
  ;;  show "Sorry for the inconvenience!"
  ;;  carefully [
  ;;    set room 0 setup-level
  ;;  ] [
  ;;    show "Whoops! Another error occured."
  ;;    show "You will be returned to the start of the game."
  ;;    show "Sorry again for the error!"
  ;;    carefully [
  ;;     set level 0 set room 0 setup-level
  ;;   ] [
  ;;     show "The game is giving up now."
  ;;    ]
  ;;  ]
  ;;]
end

to check-line
  if length line > 0 [
    if member? "Exits" line [
      if member? "Left" line [set exits lput "left" exits]
      if member? "Right" line [set exits lput "right" exits]
      if member? "Top" line [set exits lput "top" exits]
      if member? "Bottom" line [set exits lput "bottom" exits]
    ]
    if not member? "Exits" line [
      set-exits ;; Sets variables so exits will actually lead to rooms
    ]
  ]
end

to set-exits
  if (member? "Right" line) [
    if (member? "0-0" line) [set r-exit "0-0"]
    if (member? "0-1" line) [set r-exit "0-1"]
    if (member? "0-2" line) [set r-exit "0-2"]
    if (member? "0-3" line) [set r-exit "0-3"]
    if (member? "0-4" line) [set r-exit "0-4"]
    if (member? "1-0" line) [set r-exit "1-0"]
    if (member? "1-1" line) [set r-exit "1-1"]
    if (member? "1-2" line) [set r-exit "1-2"]
    if (member? "1-3" line) [set r-exit "1-3"]
    if (member? "1-4" line) [set r-exit "1-4"]
    if (member? "2-0" line) [set r-exit "2-0"]
    if (member? "2-1" line) [set r-exit "2-1"]
    if (member? "2-2" line) [set r-exit "2-2"]
    if (member? "2-3" line) [set r-exit "2-3"]
    if (member? "2-4" line) [set r-exit "2-4"]
    if (member? "3-0" line) [set r-exit "3-0"]
    if (member? "3-1" line) [set r-exit "3-1"]
    if (member? "3-2" line) [set r-exit "3-2"]
    if (member? "3-3" line) [set r-exit "3-3"]
    if (member? "3-4" line) [set r-exit "3-4"]
    if (member? "4-0" line) [set r-exit "4-0"]
    if (member? "4-1" line) [set r-exit "4-1"]
    if (member? "4-2" line) [set r-exit "4-2"]
    if (member? "4-3" line) [set r-exit "4-3"]
    if (member? "4-4" line) [set r-exit "4-4"]
  ]
  if (member? "Left" line) [
    if (member? "0-0" line) [set l-exit "0-0"]
    if (member? "0-1" line) [set l-exit "0-1"]
    if (member? "0-2" line) [set l-exit "0-2"]
    if (member? "0-3" line) [set l-exit "0-3"]
    if (member? "0-4" line) [set l-exit "0-4"]
    if (member? "1-0" line) [set l-exit "1-0"]
    if (member? "1-1" line) [set l-exit "1-1"]
    if (member? "1-2" line) [set l-exit "1-2"]
    if (member? "1-3" line) [set l-exit "1-3"]
    if (member? "1-4" line) [set l-exit "1-4"]
    if (member? "2-0" line) [set l-exit "2-0"]
    if (member? "2-1" line) [set l-exit "2-1"]
    if (member? "2-2" line) [set l-exit "2-2"]
    if (member? "2-3" line) [set l-exit "2-3"]
    if (member? "2-4" line) [set l-exit "2-4"]
    if (member? "3-0" line) [set l-exit "3-0"]
    if (member? "3-1" line) [set l-exit "3-1"]
    if (member? "3-2" line) [set l-exit "3-2"]
    if (member? "3-3" line) [set l-exit "3-3"]
    if (member? "3-4" line) [set l-exit "3-4"]
    if (member? "4-0" line) [set l-exit "4-0"]
    if (member? "4-1" line) [set l-exit "4-1"]
    if (member? "4-2" line) [set l-exit "4-2"]
    if (member? "4-3" line) [set l-exit "4-3"]
    if (member? "4-4" line) [set l-exit "4-4"]
  ]
  if (member? "Top" line) [
    if (member? "0-0" line) [set t-exit "0-0"]
    if (member? "0-1" line) [set t-exit "0-1"]
    if (member? "0-2" line) [set t-exit "0-2"]
    if (member? "0-3" line) [set t-exit "0-3"]
    if (member? "0-4" line) [set t-exit "0-4"]
    if (member? "1-0" line) [set t-exit "1-0"]
    if (member? "1-1" line) [set t-exit "1-1"]
    if (member? "1-2" line) [set t-exit "1-2"]
    if (member? "1-3" line) [set t-exit "1-3"]
    if (member? "1-4" line) [set t-exit "1-4"]
    if (member? "2-0" line) [set t-exit "2-0"]
    if (member? "2-1" line) [set t-exit "2-1"]
    if (member? "2-2" line) [set t-exit "2-2"]
    if (member? "2-3" line) [set t-exit "2-3"]
    if (member? "2-4" line) [set t-exit "2-4"]
    if (member? "3-0" line) [set t-exit "3-0"]
    if (member? "3-1" line) [set t-exit "3-1"]
    if (member? "3-2" line) [set t-exit "3-2"]
    if (member? "3-3" line) [set t-exit "3-3"]
    if (member? "3-4" line) [set t-exit "3-4"]
    if (member? "4-0" line) [set t-exit "4-0"]
    if (member? "4-1" line) [set t-exit "4-1"]
    if (member? "4-2" line) [set t-exit "4-2"]
    if (member? "4-3" line) [set t-exit "4-3"]
    if (member? "4-4" line) [set t-exit "4-4"]
  ]
  if (member? "Bottom" line) [
    if (member? "0-0" line) [set b-exit "0-0"]
    if (member? "0-1" line) [set b-exit "0-1"]
    if (member? "0-2" line) [set b-exit "0-2"]
    if (member? "0-3" line) [set b-exit "0-3"]
    if (member? "0-4" line) [set b-exit "0-4"]
    if (member? "1-0" line) [set b-exit "1-0"]
    if (member? "1-1" line) [set b-exit "1-1"]
    if (member? "1-2" line) [set b-exit "1-2"]
    if (member? "1-3" line) [set b-exit "1-3"]
    if (member? "1-4" line) [set b-exit "1-4"]
    if (member? "2-0" line) [set b-exit "2-0"]
    if (member? "2-1" line) [set b-exit "2-1"]
    if (member? "2-2" line) [set b-exit "2-2"]
    if (member? "2-3" line) [set b-exit "2-3"]
    if (member? "2-4" line) [set b-exit "2-4"]
    if (member? "3-0" line) [set b-exit "3-0"]
    if (member? "3-1" line) [set b-exit "3-1"]
    if (member? "3-2" line) [set b-exit "3-2"]
    if (member? "3-3" line) [set b-exit "3-3"]
    if (member? "3-4" line) [set b-exit "3-4"]
    if (member? "4-0" line) [set b-exit "4-0"]
    if (member? "4-1" line) [set b-exit "4-1"]
    if (member? "4-2" line) [set b-exit "4-2"]
    if (member? "4-3" line) [set b-exit "4-3"]
    if (member? "4-4" line) [set b-exit "4-4"]
  ]
end

to advance-level
  set r-exit "None"
  set l-exit "None"
  set t-exit "None"
  set b-exit "None"
  ask turtle 0 [setxy 0 0]
  ;;set room room + 1
  ;;if room > 4 [set level level + 1 set room 0]
  setup-level
end

to reset
  set exits []
end

to setup-level
  reset
  read
  create-barrier
  create-exits
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
819
420
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
45
30
118
63
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
44
93
107
126
Up
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
81
127
150
160
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
1

BUTTON
19
125
82
158
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
1

BUTTON
49
159
120
192
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
1

BUTTON
29
232
137
265
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

BUTTON
28
268
145
301
NIL
advance-level
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
103
340
160
385
NIL
room
17
1
11

MONITOR
22
337
79
382
NIL
level
17
1
11

BUTTON
49
192
116
225
NIL
shoot
NIL
1
T
OBSERVER
NIL
E
NIL
NIL
1

MONITOR
28
399
155
444
NIL
projectile-can-fire
17
1
11

MONITOR
25
460
82
505
NIL
ticks
17
1
11

MONITOR
106
460
163
505
NIL
ptimer
17
1
11

MONITOR
194
467
311
512
NIL
count projectiles
17
1
11

SWITCH
379
466
537
499
watch-character
watch-character
1
1
-1000

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
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

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
