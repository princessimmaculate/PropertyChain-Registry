;; PropertyChain Registry - Decentralized real estate ownership and transfer system
(define-non-fungible-token property-deed uint)

;; Storage
(define-map property-records uint {registrar: principal, property-address: (string-utf8 64), legal-description: (string-utf8 256), document-hash: (string-utf8 256), transfer-fee: uint})
(define-data-var deed-number uint u0)

;; Error codes
(define-constant err-registrar-required (err u600))
(define-constant err-property-not-registered (err u601))
(define-constant err-transfer-payment-failed (err u602))
(define-constant err-missing-address (err u603))
(define-constant err-missing-description (err u604))
(define-constant err-invalid-document (err u605))
(define-constant err-invalid-fee (err u606))
(define-constant err-invalid-deed-number (err u607))

;; Register a new property deed
(define-public (register-property (property-address (string-utf8 64)) (legal-description (string-utf8 256)) (document-hash (string-utf8 256)) (transfer-fee uint))
  (begin
    ;; Validate property information
    (asserts! (> (len property-address) u0) err-missing-address)
    (asserts! (> (len legal-description) u0) err-missing-description)
    (asserts! (> (len document-hash) u0) err-invalid-document)
    (asserts! (> transfer-fee u0) err-invalid-fee)
    
    (let
      ((deed-id (var-get deed-number))
       (registrar tx-sender))
      
      ;; Mint property deed NFT
      (try! (nft-mint? property-deed deed-id registrar))
      
      ;; Record property information
      (map-set property-records deed-id {registrar: registrar, property-address: property-address, legal-description: legal-description, document-hash: document-hash, transfer-fee: transfer-fee})
      
      ;; Increment deed counter
      (var-set deed-number (+ deed-id u1))
      
      (ok deed-id))))

;; Transfer property ownership
(define-public (transfer-property (deed-id uint))
  (begin
    ;; Validate deed ID
    (asserts! (< deed-id (var-get deed-number)) err-invalid-deed-number)
    
    (let
      ((property-info (unwrap! (map-get? property-records deed-id) err-property-not-registered))
       (fee (get transfer-fee property-info))
       (registrar (get registrar property-info))
       (current-owner (unwrap! (nft-get-owner? property-deed deed-id) err-property-not-registered)))
      
      ;; Check buyer has sufficient funds
      (asserts! (>= (stx-get-balance tx-sender) fee) err-transfer-payment-failed)
      
      ;; Pay transfer fee to registrar
      (try! (stx-transfer? fee tx-sender registrar))
      
      ;; Transfer deed to new owner
      (try! (nft-transfer? property-deed deed-id current-owner tx-sender))
      
      (ok true))))

;; Get property information
(define-read-only (get-property-info (deed-id uint))
  (map-get? property-records deed-id))

;; Verify property ownership
(define-read-only (verify-ownership (deed-id uint) (owner principal))
  (is-eq (some owner) (nft-get-owner? property-deed deed-id)))

;; Get property owner
(define-read-only (get-property-owner (deed-id uint))
  (nft-get-owner? property-deed deed-id))
