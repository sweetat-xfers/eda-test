# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user1 = User.create(
   name: 'User1', 
   dob: 30.years.ago ,
   mobile: '1234567',
   email: 'a@b.c'
   )

user2 = User.create(
   name: 'User2', 
   dob: 29.years.ago ,
   mobile: '1234567',
   email: 'a@b.c'
   )

txnStatus1 = TxnStatus.create(name: "New")
TxnStatus.create(name: "Processing")
TxnStatus.create(name: "Cancelled")
TxnStatus.create(name: "Bank Instruction Sent")
TxnStatus.create(name: "Pending Bank Row Reconciliation")
TxnStatus.create(name: "PreTrade Check Success")
TxnStatus.create(name: "PreTrade Check Failed")

txnType1 = TxnType.create(name: "Disbursement")
TxnType.create(name: "TopUp")

bank1 = Bank.create(name:"Bank1")
bank2 = Bank.create(name:"Bank2")

txn1 = Txn.create(
    amt: 100.2,
    user: user1,
    txn_type: txnType1,
    txn_status: txnStatus1,
    src_bank: bank1,
    dst_bank: bank2,
    )

txn2 = Txn.new(
    amt: 200.1,
    user_id: 1,
    txn_type_id: 1,
    txn_status_id: 1,
    src_bank_id: 1,
    dst_bank_id: 2,
    )
txn2.save