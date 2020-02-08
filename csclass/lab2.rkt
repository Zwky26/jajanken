#lang typed/racket

(require typed/test-engine/racket-tests)
(require "../include/cs151-core.rkt")

;;given struct of all the information needed for the inputs
;;making a matrix structure used for rest of functions
(define-struct TaxReturn
  ([num-adults : Integer]
   [num-children : Integer]
   [num-dogs : Integer]
   [income : Integer]
   [charity : Integer]))

;;uses structure, returns integer
(: adjusted-income : TaxReturn -> Integer)
;;take income, subtract by charity
;;returns income that will then be deducted based on dependents
(define (adjusted-income i)
  (- (TaxReturn-income i) (TaxReturn-charity i)))

(check-expect (adjusted-income (TaxReturn 1 1 1 10000 2000)) 8000)
(check-expect (adjusted-income (TaxReturn 3 4 2 50000 30000)) 20000)


(: plausible? : TaxReturn -> Boolean)
;;checks the inputs of structure
;;also checks if adjusted income is not below zero
;;checks if num-adults > 0, rest of entries is >= 0
(define (plausible? i)
   (and (> (TaxReturn-num-adults i) 0) (>= (TaxReturn-num-children i) 0)
        (>= (TaxReturn-num-dogs i) 0) (>= (TaxReturn-income i) 0)
        (>= (TaxReturn-charity i) 0) (>= (adjusted-income i) 0)))

(check-expect (plausible? (TaxReturn 1 1 1 10000 2000)) #t)
(check-expect (plausible? (TaxReturn 1 -1 1 0 -2000)) #f)


(: income-tax : Integer -> Integer)
;;input is adjusted income from TaxReturn
;;conditionals to determine the bracket of income, from highest to lowest
;;for each bracket, marginal tax rate for income
;;start with highest earning bracket to avoid too many conditionals
;;returns income-tax of givens
(define (income-tax adjusted)
  (cond
    [(> adjusted 40000) (exact-round(+ (* 10000 .1) (* 10000 .2)
                                       (* 10000 .3) (* (- adjusted 40000) .4)))]
    [(> adjusted 30000) (exact-round(+ (* 10000 .1) (* 10000 .2)
                                       (* (- adjusted 30000) .3)))]
    [(> adjusted 20000) (exact-round(+ (* 10000 .1)
                                       (* (- adjusted 20000) .2)))]
    [(> adjusted 10000) (exact-round(* (- adjusted 10000) .1))]
    [else 0]))

(check-expect (income-tax 1000) 0)
(check-expect (income-tax 12000) 200)

(: child-deduction : TaxReturn -> Integer)
;;the deduction is c/12 multiplied by the income tax
;;multiply fraction to income-tax
(define (child-deduction c)
  (exact-round(* (/ (TaxReturn-num-children c) 12) (income-tax (adjusted-income c)))))

(check-expect (child-deduction (TaxReturn 1 2 1 22000 0)) 233)
(check-expect (child-deduction (TaxReturn 1 2 1 10000 0)) 0)


(: dog-deduction : TaxReturn -> Integer)
;;the dog deduction is additive instead of multiplication
;;multiply number of dogs by 100
(define (dog-deduction doggies)
  (* (TaxReturn-num-dogs doggies) 100))

(check-expect (dog-deduction (TaxReturn 1 2 1 22000 0)) 100)
(check-expect (dog-deduction (TaxReturn 1 2 3 10000 0)) 300)

(: tax-owed : TaxReturn -> Integer)
;;takes in the taxreturn structure
;;calculates adjusted income
;;calculates income-tax from the adjusted
;;deduct the child and dog deductions from the tax needed to be paid
;;output final tax owed
(define (tax-owed taxes)
     (- (- (income-tax (adjusted-income taxes))
           (child-deduction taxes)) (dog-deduction taxes)))

(check-expect (tax-owed (TaxReturn 2 3 1 60000 5000)) 8900)
(check-expect (tax-owed (TaxReturn 1 0 1 20000 0)) 900)


(test)