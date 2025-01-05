;; Cosmic String Management Contract

;; Constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_NOT_AUTHORIZED (err u100))
(define-constant ERR_INVALID_PROPOSAL (err u101))
(define-constant ERR_INVALID_VOTE (err u102))

;; Data variables
(define-data-var proposal-count uint u0)

;; Data maps
(define-map proposals
  uint
  {
    creator: principal,
    title: (string-ascii 64),
    description: (string-utf8 1024),
    detection-method: (string-ascii 64),
    manipulation-technique: (string-ascii 64),
    energy-estimate: uint,
    creation-time: uint,
    votes: int,
    status: (string-ascii 20)
  }
)

(define-map proposal-votes
  { proposal-id: uint, voter: principal }
  { vote: int }
)

;; Public functions
(define-public (submit-proposal (title (string-ascii 64)) (description (string-utf8 1024)) (detection-method (string-ascii 64)) (manipulation-technique (string-ascii 64)) (energy-estimate uint))
  (let
    (
      (proposal-id (+ (var-get proposal-count) u1))
    )
    (map-set proposals
      proposal-id
      {
        creator: tx-sender,
        title: title,
        description: description,
        detection-method: detection-method,
        manipulation-technique: manipulation-technique,
        energy-estimate: energy-estimate,
        creation-time: block-height,
        votes: 0,
        status: "pending"
      }
    )
    (var-set proposal-count proposal-id)
    (ok proposal-id)
  )
)

(define-public (vote-on-proposal (proposal-id uint) (vote int))
  (let
    (
      (proposal (unwrap! (map-get? proposals proposal-id) ERR_INVALID_PROPOSAL))
      (previous-vote (default-to { vote: 0 } (map-get? proposal-votes { proposal-id: proposal-id, voter: tx-sender })))
    )
    (asserts! (and (>= vote -1) (<= vote 1)) ERR_INVALID_VOTE)
    (map-set proposal-votes
      { proposal-id: proposal-id, voter: tx-sender }
      { vote: vote }
    )
    (map-set proposals
      proposal-id
      (merge proposal {
        votes: (+ (get votes proposal) (- vote (get vote previous-vote)))
      })
    )
    (ok true)
  )
)

(define-public (update-proposal-status (proposal-id uint) (new-status (string-ascii 20)))
  (let
    (
      (proposal (unwrap! (map-get? proposals proposal-id) ERR_INVALID_PROPOSAL))
    )
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_NOT_AUTHORIZED)
    (ok (map-set proposals
      proposal-id
      (merge proposal { status: new-status })
    ))
  )
)

;; Read-only functions
(define-read-only (get-proposal (proposal-id uint))
  (map-get? proposals proposal-id)
)

(define-read-only (get-proposal-vote (proposal-id uint) (voter principal))
  (map-get? proposal-votes { proposal-id: proposal-id, voter: voter })
)

(define-read-only (get-proposal-count)
  (var-get proposal-count)
)

