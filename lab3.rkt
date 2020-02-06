#lang typed/racket

(require typed/test-engine/racket-tests)

(require "../include/cs151-core.rkt")
(require "../include/cs151-image.rkt")

;; assuming garbage in garbage out

(define-struct Click
  ([displacement-horizontal : Integer]
   [displacement-vertical   : Integer]))
;; simply inputting a coordinate, corresponding to pixel from top left over

(define-struct VisualStyle
  ([text-area-width : Integer]
   [text-area-height : Integer]
   [spacer-height : Integer]
   [text-background-color : Image-Color]
   [spacer-color : Image-Color]))
;; specify dimensions and aspects of a background

(define-struct MultipleChoice
  ([question-text : String]
   [choice1 : String]
   [choice2 : String]
   [choice3 : String]
   [choice4 : String]
   [correct-choice : Integer]))
;; provide strings for question
;; correct-choice has no use for this lab


(: display-question : VisualStyle MultipleChoice -> Image)
;; input a visualstyle and the actual text from multiplechoice
;; overlays text onto visualstyle
;; important note that we need to procedurally overlay the string onto rectangle
;; THEN "above" each of the rectangles
(define (display-question vstyle question)
  (match* (vstyle question)
    [((VisualStyle rectwidth rectheight spaceheight backgroundcolor spacecolor)
      (MultipleChoice q ans1 ans2 ans3 ans4 correct))
     (local
       {(define (make-Text-Rect rectnumber)
          (match rectnumber
            [0 (overlay (text q 16 "black")
                        (rectangle rectwidth rectheight "solid"
                                   backgroundcolor))]
            [1 (overlay (text (cat "1. " ans1) 16 "black")
                        (rectangle rectwidth rectheight "solid"
                                   backgroundcolor))]
            [2 (overlay (text (cat "2. " ans2) 16 "black")
                        (rectangle rectwidth rectheight "solid"
                                   backgroundcolor))]
            [3 (overlay (text (cat "3. " ans3) 16 "black")
                        (rectangle rectwidth rectheight "solid"
                                   backgroundcolor))]
            [4 (overlay (text (cat "4. " ans4) 16 "black")
                        (rectangle rectwidth rectheight "solid"
                                   backgroundcolor))]))
        (define (make-Spacer-Rect)
          (rectangle rectwidth spaceheight "solid" spacecolor))}
        (above
         (make-Text-Rect 0)
         (make-Spacer-Rect)
         (make-Text-Rect 1)
         (make-Spacer-Rect)
         (make-Text-Rect 2)
         (make-Spacer-Rect)
         (make-Text-Rect 3)
         (make-Spacer-Rect)
         (make-Text-Rect 4)))]))

;; take in dimensions of inputs using match
;; locally defined helper function to make "types" of rectangles based on input
;; used above to stack types of rectangles

(: choice-clicked : VisualStyle Click -> Integer)
;; takes in two integers
;; returns what rectangle this coordinate corresponds to
;; check the horizontal first
;; if it is possibly in a rectangle (not too far left or right)
;; check vertical to see if spacer or text rectangle
(define (choice-clicked vstyle clickpoint)
  (match* (vstyle clickpoint)
    [((VisualStyle rectwidth rectheight spaceheight backgroundcolor spacecolor)
      (Click horizontal vertical))    
     (cond
       [(or (> horizontal rectwidth) (<= horizontal 0)) 0]
       [else (cond
               [(and (> vertical (+ rectheight spaceheight))
                     (<= vertical (+ (* 2 rectheight) spaceheight))) 1]
               [(and (> vertical (* 2 (+ rectheight spaceheight)))
                     (<= vertical (+ (* 3 rectheight) (* 2 spaceheight)))) 2]
               [(and (> vertical (* 3 (+ rectheight spaceheight)))
                     (<= vertical (+ (* 4 rectheight) (* 3 spaceheight)))) 3]
               [(and (> vertical (* 4 (+ rectheight spaceheight)))
                     (<= vertical (+ (* 5 rectheight) (* 4 spaceheight)))) 4]
               [else 0])])]))

;; take in inputs using match
;; conditional to test whether it could feasibly be inside
;; our area based on horizontal
;; tried making helper functions to check which rectangle

                
               
(check-expect (choice-clicked
               (VisualStyle 100 5 1 "goldenrod" "white")
               (Click 0 0)) 0)
(check-expect (choice-clicked
               (VisualStyle 100 5 1 "goldenrod" "white")
               (Click 105 0)) 0)
(check-expect (choice-clicked
               (VisualStyle 100 5 1 "goldenrod" "white")
               (Click 50 8)) 1)
(check-expect (choice-clicked
               (VisualStyle 100 5 1 "goldenrod" "white")
               (Click 60 13)) 2)
(check-expect (choice-clicked
               (VisualStyle 100 5 1 "goldenrod" "white")
               (Click 60 100000)) 0)
(check-expect (choice-clicked
               (VisualStyle 100 5 1 "goldenrod" "white")
               (Click 1000000000000 14)) 0)
(check-expect (choice-clicked
               (VisualStyle 100 5 1 "goldenrod" "white")
               (Click -20 10)) 0)
(check-expect (choice-clicked
               (VisualStyle 100 5 1 "goldenrod" "white")
               (Click 20 -14)) 0)

(test)
      
     
     