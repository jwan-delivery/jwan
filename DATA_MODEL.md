# Jawan Firestore Data Model

## users/{uid}

```text
role: customer | driver | admin | super_admin
name
phone
address
status: pending | active | suspended | rejected
privacyAccepted
termsAccepted
createdAt
lastActiveAt
```

## orders/{orderId}

```text
customerId
driverId
type
description
destination
deliveryFee
pricingMode: customer | admin
status
createdAt
acceptedAt
startedAt
deliveredAt
customerConfirmedAt
driverConfirmedAt
completedAt
cancelledAt
cancelReason
driverComment
distanceText
```

## wallets/{driverUid}

```text
balance
totalCommission
totalTopups
totalWithdrawals
updatedAt
```

## walletTransactions/{txId}

```text
userId
type: activation | commission | topup | withdrawal | adjustment
amount
balanceBefore
balanceAfter
orderId
topupRequestId
createdAt
createdBy
```

## topupRequests/{id}

```text
driverId
amount
paymentMethod
status: pending | approved | rejected
submittedAt
reviewedAt
reviewedBy
reviewNote
whatsappVerified: true|false
```

## withdrawalRequests/{id}

```text
driverId
amount
paymentMethod
accountReference
status: pending | approved | rejected | paid
createdAt
reviewedAt
reviewedBy
```

## ratings/{id}

```text
orderId
customerId
driverId
rating
comment
createdAt
```

## supportMessages/{id}

```text
userId
role
message
reply
status: open | answered
createdAt
repliedAt
repliedBy
```

## driverActivity/{id} (محجوزة للمستقبل)

هذا المجموعة معدّة لتتبع حضور السائق (Presence) لحظة بلحظة، وتحتاج تسجيل
نبضات دورية أثناء تصفح السائق للتطبيق. النسخة الحالية لا تكتب فيها،
وتحسب "أيام النشاط" في صفحة التحليلات مباشرة من الطلبات المكتملة بدلًا
من ذلك. أضف قاعدة وصول لها في `firestore.rules` عند تفعيلها لاحقًا.

```text
driverId
date
active
ordersAccepted
ordersCompleted
ordersCancelled
onlineMinutes
```

## notifications/{id}

```text
userId
type
title
body
read
createdAt
```

## auditLogs/{id}

```text
actorUid
actorRole
action
targetType
targetId
metadata
createdAt
```
