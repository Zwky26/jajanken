#lang typed/racket
(require "../include/cs151-core.rkt")
(require "../include/cs151-image.rkt");; like package
(: sears-tower Image)
(define sears-tower
  (above (beside (rectangle 2 11 "solid" "black")
                 (rectangle 3 1 "solid" "white")
                 (rectangle 2 11 "solid" "black"))
         (rectangle 10 30 "solid" "black")
         (rectangle 20 100 "solid" "black")))

9
(+ 9 1)
(+ 1 9)
(- 9 1)
(- 1 9)

(* 9 1)
(* 1 9)
(/ 9 1)
(/ 1 9)

(+ (* 9 9) 2)
(- (* 3 3) (* 2 2 2))

(= (expt 9 1) (expt 9 2))
(< (expt 9 1) (expt 9 2))
(> (expt 9 1) (expt 9 2))

(: a Integer)
(define a 7)

(: b Integer)
(define b 8)

(* a b)
(- (* b b) (* a a))