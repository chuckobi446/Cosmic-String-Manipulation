;; Cosmic String NFT Contract

(define-non-fungible-token cosmic-string-nft uint)

;; Constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_NOT_AUTHORIZED (err u100))
(define-constant ERR_INVALID_NFT (err u101))

;; Data variables
(define-data-var last-token-id uint u0)

;; Data maps
(define-map token-metadata
  uint
  {
    creator: principal,
    name: (string-ascii 64),
    description: (string-utf8 256),
    segment-length: uint,
    energy-potential: uint,
    discovery-time: uint,
    image-url: (string-ascii 256)
  }
)

;; Public functions
(define-public (mint-cosmic-string (name (string-ascii 64)) (description (string-utf8 256)) (segment-length uint) (energy-potential uint) (image-url (string-ascii 256)))
  (let
    (
      (token-id (+ (var-get last-token-id) u1))
    )
    (try! (nft-mint? cosmic-string-nft token-id tx-sender))
    (map-set token-metadata
      token-id
      {
        creator: tx-sender,
        name: name,
        description: description,
        segment-length: segment-length,
        energy-potential: energy-potential,
        discovery-time: block-height,
        image-url: image-url
      }
    )
    (var-set last-token-id token-id)
    (ok token-id)
  )
)

(define-public (transfer-cosmic-string (token-id uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender (unwrap! (nft-get-owner? cosmic-string-nft token-id) ERR_INVALID_NFT)) ERR_NOT_AUTHORIZED)
    (try! (nft-transfer? cosmic-string-nft token-id tx-sender recipient))
    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-cosmic-string-metadata (token-id uint))
  (map-get? token-metadata token-id)
)

(define-read-only (get-cosmic-string-owner (token-id uint))
  (nft-get-owner? cosmic-string-nft token-id)
)

(define-read-only (get-last-token-id)
  (var-get last-token-id)
)

