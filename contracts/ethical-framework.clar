;; Ethical Framework Contract

;; Constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_NOT_AUTHORIZED (err u100))
(define-constant ERR_INVALID_ASSESSMENT (err u101))

;; Data variables
(define-data-var assessment-count uint u0)

;; Data maps
(define-map ethical-assessments
  uint
  {
    assessor: principal,
    proposal-id: uint,
    environmental-impact: int,
    societal-impact: int,
    technological-risk: int,
    long-term-consequences: int,
    overall-rating: int,
    justification: (string-utf8 1024),
    timestamp: uint
  }
)

;; Public functions
(define-public (submit-ethical-assessment (proposal-id uint) (environmental-impact int) (societal-impact int) (technological-risk int) (long-term-consequences int) (overall-rating int) (justification (string-utf8 1024)))
  (let
    (
      (assessment-id (+ (var-get assessment-count) u1))
    )
    (asserts! (and (>= environmental-impact -10) (<= environmental-impact 10)) ERR_INVALID_ASSESSMENT)
    (asserts! (and (>= societal-impact -10) (<= societal-impact 10)) ERR_INVALID_ASSESSMENT)
    (asserts! (and (>= technological-risk -10) (<= technological-risk 10)) ERR_INVALID_ASSESSMENT)
    (asserts! (and (>= long-term-consequences -10) (<= long-term-consequences 10)) ERR_INVALID_ASSESSMENT)
    (asserts! (and (>= overall-rating -10) (<= overall-rating 10)) ERR_INVALID_ASSESSMENT)
    (map-set ethical-assessments
      assessment-id
      {
        assessor: tx-sender,
        proposal-id: proposal-id,
        environmental-impact: environmental-impact,
        societal-impact: societal-impact,
        technological-risk: technological-risk,
        long-term-consequences: long-term-consequences,
        overall-rating: overall-rating,
        justification: justification,
        timestamp: block-height
      }
    )
    (var-set assessment-count assessment-id)
    (ok assessment-id)
  )
)

;; Read-only functions
(define-read-only (get-ethical-assessment (assessment-id uint))
  (map-get? ethical-assessments assessment-id)
)

(define-read-only (get-assessment-count)
  (var-get assessment-count)
)

