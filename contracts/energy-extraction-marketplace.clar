;; Energy Extraction Marketplace Contract

;; Constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_NOT_AUTHORIZED (err u100))
(define-constant ERR_INVALID_LISTING (err u101))
(define-constant ERR_INSUFFICIENT_BALANCE (err u102))

;; Data variables
(define-data-var listing-count uint u0)

;; Data maps
(define-map listings
  uint
  {
    seller: principal,
    title: (string-ascii 64),
    description: (string-utf8 256),
    price: uint,
    efficiency: uint,
    risk-factor: uint,
    data-url: (string-ascii 256),
    creation-time: uint
  }
)

;; Public functions
(define-public (create-listing (title (string-ascii 64)) (description (string-utf8 256)) (price uint) (efficiency uint) (risk-factor uint) (data-url (string-ascii 256)))
  (let
    (
      (listing-id (+ (var-get listing-count) u1))
    )
    (map-set listings
      listing-id
      {
        seller: tx-sender,
        title: title,
        description: description,
        price: price,
        efficiency: efficiency,
        risk-factor: risk-factor,
        data-url: data-url,
        creation-time: block-height
      }
    )
    (var-set listing-count listing-id)
    (ok listing-id)
  )
)

(define-public (purchase-listing (listing-id uint))
  (let
    (
      (listing (unwrap! (map-get? listings listing-id) ERR_INVALID_LISTING))
      (buyer tx-sender)
    )
    (asserts! (>= (stx-get-balance buyer) (get price listing)) ERR_INSUFFICIENT_BALANCE)
    (try! (stx-transfer? (get price listing) buyer (get seller listing)))
    (ok true)
  )
)

(define-public (remove-listing (listing-id uint))
  (let
    (
      (listing (unwrap! (map-get? listings listing-id) ERR_INVALID_LISTING))
    )
    (asserts! (is-eq tx-sender (get seller listing)) ERR_NOT_AUTHORIZED)
    (map-delete listings listing-id)
    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-listing (listing-id uint))
  (map-get? listings listing-id)
)

(define-read-only (get-listing-count)
  (var-get listing-count)
)

