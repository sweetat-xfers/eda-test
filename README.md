# eda-test
Test for Event Driven Architecture

# Objectives
Using the latest technologies in Ruby/Rails, sidekiq, redis, MySQL, and Kafka develop
two distinct Event Driven Architectures.  The common technical stack across include:
1. Ruby on Rails
2. MySQL

# Getting Started

```
git clone https://github.com/sweetat-xfers/eda-test.git
cd eda-test
docker-compose up -d
docker-compose logs --follow
```

# Educational Text

## Mediator Based EDA
![Mediator EDA](https://www.oreilly.com/library/view/software-architecture-patterns/9781491971437/assets/sapr_0201.png)

### Technology Stack
1. [sidekiq](https://sidekiq.org/)
2. [Redis](https://redis.io/)
3. [AASM](https://github.com/aasm/aasm)

## Broker Based EDA
![Broker EDA](https://miro.medium.com/max/2462/0*iGkuegluZ0UhcRGC.png)

### Technology Stack
1. [Kafka](https://kafka.apache.org/)
2. [Ruby-kafka](https://github.com/zendesk/ruby-kafka)
3. [Phobos](https://github.com/phobos/phobos)

## Comparison

We will share the voting on the comparison of the above on the following characteristics:
1. Agility
2. Scalability
3. Appropriate Coupling
4. Maintainability
5. Reliability

## Workflow
To compare, the 2 systems will perform the following sets of functions:

### Rails
1. User requests a transaction via Rails
2. Rails passes the transaction into the technology stack
3. Rails replies to user that transaction is currently processing

#### Reporting
4. User should be able to read the state of the transaction from some report screen
5. Admin should be able to read the state of the transaction and bank_row from some report screen

### Stream1: Transaction

1. Parallel processing
    1. Save transaction in persistence store
    2. Perform pre-trade check (eg. check if user balance is sufficient)
    3. Calculate Xfers fees for transaction
2. Fire Bank transaction against Mock service that has 50% failure rate
3. Save processed bank transaction

### Stream2: Bank Recon

1. Read CSV file from directory or simple curl upload file
2. Parallel processing
    1. Save data in persistence store
    2. Extract each bank row, and fire bank_row events

### Stream3: BankRow event

1. Parallel processing
    1. Save bank row in persistence store (?? do we need to do this? we saved raw csv earlier?)
    2. Interpret Bank Row
2. Link Txn with Bank Row, and mark as reconciled