#lang typed/racket

(require typed/test-engine/racket-tests)

(require "../include/cs151-core.rkt")
(require "../include/cs151-image.rkt")

(: leaf Image)
(define leaf
(bitmap/url "http://people.cs.uchicago.edu/~adamshaw/images/leaf128.jpg"))
(: chicago Image)
(define chicago
(bitmap/url "http://people.cs.uchicago.edu/~adamshaw/images/chicago128.jpg"))
(: teddy Image)
(define teddy
(bitmap/url "http://people.cs.uchicago.edu/~adamshaw/images/tr128.jpg"))

(: rounded-side : Integer -> Real)
;; helper function
;; takes in the original length
;; if x is original, computes exact-floor( ln(x)/ln(2) )
;; 2^returned value should be new length
(define (rounded-side n)
  (cond
    [(> n 0) (expt 2 (floor (/ (log n) (log 2))))]
    [else (error "Input not positive integer")]))

(check-within (rounded-side 14) 8 .01)
(check-within (rounded-side 4) 4 .01)
(check-within (rounded-side 258) 256 .01)

(: scale-down-power-2 : Image -> Image)
;; first, check to see if image size is a square
;; then, use rounded size to determine scale factor and scale it

(define (scale-down-power-2 image)
  (cond
    [(= (image-height image) (image-width image))
     (scale (/ (rounded-side (image-height image))
               (image-height image)) image)]   
    [else (error "Not a square.")]))

(check-expect (scale-down-power-2 (square 40 'solid 'red)) (square 32 'solid 'red))
(check-expect (scale-down-power-2 (square 13 'solid 'blue)) (square 8 'solid 'blue))

;;================================== part 2 SICP

;; thinking aloud, lets look at the top right quadrant
;; as that happens to match the initial image
;; we 'halve' the image, making a new one 'halved-image
;; we make a row of two halved-images
;; as well as a column of two halved-images
;; we glue these to the top and side of original image,
;; this gives us an 'L' shape which will be our recursive thing
;; we do the same process to the 'halved-image' and place it in the open slot
;; tangent to the top right corner of the original image
;; once this is done, we mirror it with flip-vertical and flip-horizontal

;; given image used to test sicp
(: thing64 Image)
(define thing64
  (overlay/xy (circle 10 'solid 'red)
	      -40
	      -10
	      (square 64 'outline 'black)))

(: vertically : Image -> Image)
;;given a square, make a fractal tower
(define (vertically image)
  (cond
    [(<= (image-height image) 2) empty-image]
    [else (above (vertically (beside (scale .5 image) (scale .5 image)))
                 image)]))

;; can't check expect but turns out right when testing with thing64
;; and other shapes provided

(: horizontally : Image -> Image)
;;given a square, make a fractal...hallway?
(define (horizontally image)
  (cond
    [(<= (image-width image) 2) empty-image]
    [else (beside image (horizontally (above (scale .5 image) (scale .5 image))))]))

;; can't check expect but turns out right when testing with thing64
;; and other shapes provided

(: l-shape : Image -> Image)
;; overlays the two
;; will be the unit we recurse in the corner again and again
;; make sure the dots dont get weird when overlay/align 
(define (l-shape square)
  (overlay/align "left" "bottom"
   (vertically square) (horizontally square)))

(: vertical-mirror : Image -> Image)
;takes an image, reflects over bottom and fuses both
(define (vertical-mirror image)
  (above image (flip-vertical image)))

;; this test works, but also tested for more complex images
(check-expect (vertical-mirror (square 30 "solid" "blue")) (rectangle 30 60 "solid" "blue"))

(: horizontal-mirror : Image -> Image)
;takes an image, reflects over left and fuses both
(define (horizontal-mirror image)
  (beside (flip-horizontal image) image))

;; this test works, but also tested for more complex images
(check-expect (horizontal-mirror (square 30 "solid" "blue")) (rectangle 60 30 "solid" "blue"))


(: makeL : Image -> Image)
;; glues the two together to form the actual l
(define (makeL original)
  (cond
    [(<= (image-height original) 2) empty-image]
    [else (overlay/align "right" "top"
                         (l-shape original)
                         (makeL (scale .5 original)))]))

(: northsouth : Image -> Image)
;; make the right side of the final image
(define (northsouth l)
  (vertical-mirror (makeL l)))

(: sicp : Image -> Image)
;; make the final trippy image!
;; turns out correctly
(define (sicp l)
  (horizontal-mirror (northsouth l)))

(test)



;; korega...recursion...da