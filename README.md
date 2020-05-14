# eda-test

Test for Event Driven Architecture

## Objectives

Using the latest technologies in Ruby/Rails, sidekiq, redis, MySQL, and Kafka develop
two distinct Event Driven Architectures.  The common technical stack across include:

1. Ruby on Rails
2. MySQL

## Getting Started

```bash
git clone https://github.com/sweetat-xfers/eda-test.git
cd eda-test
docker-compose up -d
docker-compose logs --follow
```

Go to [test](http://localhost:3000/txns)

For redis test

```bash
git clone https://github.com/sweetat-xfers/eda-test.git
cd eda-test
docker-compose -f redis-docker-compose.yml up -d --build
docker-compose -f redis-docker-compose.yml web run bundle exec rake db:migrate:reset db:seed
```

Go to [test](http://localhost:3000/sidekiq)

## Educational Text

### Mediator Based EDA

#### Why the current implementation is deemed to be mediator based EDA

The primary characteristics of the mediator based EDA is the mediator where all
activities/events must pass through in order to progress to the next phase.

Current mediator in Xfers rails application is the Contract class.

![Mediator EDA](https://www.oreilly.com/library/view/software-architecture-patterns/9781491971437/assets/sapr_0201.png)

#### Technology Stack (Mediator EDA)

1. [sidekiq](https://sidekiq.org/)
2. [Redis](https://redis.io/)
3. [AASM](https://github.com/aasm/aasm)

### Broker Based EDA

![Broker EDA](https://miro.medium.com/max/2462/0*iGkuegluZ0UhcRGC.png)

#### Technology Stack (Broker EDA)

1. [Kafka](https://kafka.apache.org/)
2. [Ruby-kafka](https://github.com/zendesk/ruby-kafka)
3. [Phobos](https://github.com/phobos/phobos)

### Comparison

We will share the voting on the comparison of the above on the following characteristics:

1. Agility
    1. Ability to add new workflows
    2. New business product offerings
2. Scalability
    1. 1,000 txns per second
3. Appropriate Coupling
    1. Domain objects do not depend on classes from a different domain
    2. Agility improved by very loose coupling
4. Maintainability
    1. Developers know how to read the code quickly
5. Reliability
    1. Shutdown of infrastructure components do not render business service failure
    2. Recovery from failure (ambiguous target)
6. Performance
    1. Events should complete within specific time
    2. Time taken to handle events in processor
7. Guaranteed Ordering
    1. Ordering of events based on event time
8. Exactly Once Semantics
    1. Exactly Once Semantics - only one transaction executes
9. Transition Time
    1. Smoothness of path to transition to new stack

### Workflow

To compare, the 2 systems will perform the following sets of functions:

#### Rails

1. User requests a transaction via Rails
2. Rails passes the transaction into the technology stack
3. Rails replies to user that transaction is currently processing
    1. Some merchants want transactions to complete immediately

#### Reporting

1. User should be able to read the state of the transaction from some report screen
2. Admin should be able to read the state of the transaction and bank_row from some report screen

#### Stream1: Transaction

1. Save transaction in persistence store
2. Parallel processing
    1. Perform pre-trade check (eg. check if user balance is sufficient)
    2. Calculate Xfers fees for transaction
3. Fire Bank instruction against Mock service that has 50% failure rate
    1. If bank instruction fails, DO NOT retry
    2. Mark bank instruction tried - in production system it is "Paid"
4. Save processed bank transaction

#### Stream2: Bank Recon

1. Read CSV file from directory or simple curl upload file
    1. @victor mentioned that we need an ability to handle situation where data needs
       to be edited.  Eg. CSV file has 1 bank_row, and bank_row disappears half an hour later
2. Parallel processing
    1. Save data in persistence store
    2. Extract each bank row, and fire bank_row events

#### Stream3: BankRow event

1. Parallel processing
    1. Save bank row in persistence store (?? do we need to do this? we saved raw csv earlier?)
    2. Interpret Bank Row
2. Link Txn with Bank Row, and mark as reconciled
