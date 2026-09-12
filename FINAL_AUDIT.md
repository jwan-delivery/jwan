# Jawan Delivery — Final Integration Audit

## 2026-09-09 integration updates
- Customers are created as `active`; drivers remain `pending`.
- Driver must submit the first negotiation offer. After the driver offer is rejected, either participant may submit a counter-offer.
- Negotiation offers are numeric amounts only; the UI uses accept (✓) and reject (✕).
- Firestore negotiation rules require authenticated participants and prevent first offers from customers.
- Negotiation duration remains 30 minutes and cannot be extended by later offers.
- Admin order view includes an expandable detailed view with state, vehicle/service details, route, passenger/cargo data, agreed fee, negotiation status, and participant profile information.
- Google sign-in is available for accounts that have linked a Google provider; existing phone/password users can link Google from their customer/driver dashboard.
- Password recovery is admin-assisted via WhatsApp because the legacy phone login uses synthetic `phone@jawan.app` authentication emails and does not have a real user mailbox.

## Validation
- JavaScript syntax checks passed for changed files.
- JSON parsing passed for Firebase configuration/indexes.
- Firestore Rules compile check must be run with `firebase deploy --only firestore:rules --dry-run` from Termux.
- This package does not deploy automatically.
