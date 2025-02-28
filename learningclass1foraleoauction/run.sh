#!/bin/bash
# First check that Leo is installed.
if ! command -v leo &> /dev/null
then
    echo "leo is not installed."
    exit
fi

# The private key and address of the first bidder.
# Swap these into program.json, when running transactions as the first bidder.
# NETWORK=testnet
# PRIVATE_KEY=APrivateKey1zkp8CZNn3yeCseEtxuVPbDCwSyhGW6yZKUYKfgXmcpoGPWH

# The private key and address of the second bidder.
# Swap these into program.json, when running transactions as the second bidder.
# NETWORK=testnet
# PRIVATE_KEY=APrivateKey1zkp2RWGDcde3efb89rjhME1VYA8QMxcxep5DShNBR6n8Yjh


# The private key and address of the auctioneer.
# Swap these into program.json, when running transactions as the auctioneer.
# NETWORK=testnet
# PRIVATE_KEY=APrivateKey1zkp2GUmKbVsuc1NSj28pa1WTQuZaK5f1DQJAT6vPcHyWokG


echo "
###############################################################################
########                                                               ########
########            STEP 0: Initialize a new 2-party auction           ########
########                                                               ########
########                -------------------------------                ########
########                |  OPEN   |    A    |    B    |                ########
########                -------------------------------                ########
########                |   Bid   |         |         |                ########
########                -------------------------------                ########
########                                                               ########
###############################################################################
"
# Swap in the private key and address of the first bidder to .env.
echo "NETWORK=testnet
PRIVATE_KEY=APrivateKey1zkpCSGqV7j1UZzyRUwJtL4uL5zKmFM3tBbDWgsh1FdNLnBd
ENDPOINT=http://localhost:3030
" > .env

# Have the first bidder place a bid of 10.
echo "
###############################################################################
########                                                               ########
########          STEP 1: The first bidder places a bid of 10          ########
########                                                               ########
########                -------------------------------                ########
########                |  OPEN   |    A    |    B    |                ########
########                -------------------------------                ########
########                |   Bid   |   10    |         |                ########
########                -------------------------------                ########
########                                                               ########
###############################################################################
"
leo run place_bid aleo1kxvktl9vre8ytrmhfr6q9em6wfaf3avp3dwmfk68a4ckppjwd5gqvszy8d 10u64 || exit

# Swap in the private key and address of the second bidder to .env.
echo "NETWORK=testnet
PRIVATE_KEY=APrivateKey1zkpA9XfcTt3yDGmuETDnvg5cr1sX4vguZ6iihknmS4qYJ8N
ENDPOINT=http://localhost:3030
" > .env

# Have the second bidder place a bid of 90.
echo "
###############################################################################
########                                                               ########
########         STEP 2: The second bidder places a bid of 90          ########
########                                                               ########
########                -------------------------------                ########
########                |  OPEN   |    A    |    B    |                ########
########                -------------------------------                ########
########                |   Bid   |   10    |   90    |                ########
########                -------------------------------                ########
########                                                               ########
###############################################################################
"
leo run place_bid aleo1l7zxrhcr8420tnueqa3gw6xrd9v7dt9fs86vacm377tz7lg56gpqaf2xup 90u64 || exit

# Swap in the private key and address of the auctioneer to .env.
echo "NETWORK=testnet
PRIVATE_KEY=APrivateKey1zkpGefCtUeiZCNUF1tCRcC4YshBj4KDDkJ9QVUafEzTU7R2
ENDPOINT=http://localhost:3030
" > .env

# Have the auctioneer select the winning bid.
echo "
###############################################################################
########                                                               ########
########       STEP 3: The auctioneer selects the winning bidder       ########
########                                                               ########
########                -------------------------------                ########
########                |  OPEN   |    A    |  → B ←  |                ########
########                -------------------------------                ########
########                |   Bid   |   10    |  → 90 ← |                ########
########                -------------------------------                ########
########                                                               ########
###############################################################################
"
leo run resolve "{
        owner: aleo1g24j0aa2fw69y7n05aehk3gp7cf8tr9ea2nnpnavx3qdpmc5r5rse08kl2.private,
        bidder: aleo1kxvktl9vre8ytrmhfr6q9em6wfaf3avp3dwmfk68a4ckppjwd5gqvszy8d.private,
        amount: 10u64.private,
        is_winner: false.private,
        _nonce: 6052523601338618010366348391882590397848697985905986069201832739979216059637group.public
        }" "{
        owner: aleo1g24j0aa2fw69y7n05aehk3gp7cf8tr9ea2nnpnavx3qdpmc5r5rse08kl2.private,
        bidder: aleo1l7zxrhcr8420tnueqa3gw6xrd9v7dt9fs86vacm377tz7lg56gpqaf2xup.private,
        amount: 90u64.private,
        is_winner: false.private,
        _nonce: 8061888333948719965458030159183401613387241184660857037229834704079264166818group.public
        }" || exit

# Have the auctioneer finish the auction.
echo "
###############################################################################
########                                                               ########
########         STEP 4: The auctioneer completes the auction.         ########
########                                                               ########
########                -------------------------------                ########
########                |  CLOSE  |    A    |  → B ←  |                ########
########                -------------------------------                ########
########                |   Bid   |   10    |  → 90 ← |                ########
########                -------------------------------                ########
########                                                               ########
###############################################################################
"
leo run finish "{
    owner: aleo1g24j0aa2fw69y7n05aehk3gp7cf8tr9ea2nnpnavx3qdpmc5r5rse08kl2.private,
    bidder: aleo1l7zxrhcr8420tnueqa3gw6xrd9v7dt9fs86vacm377tz7lg56gpqaf2xup.private,
    amount: 90u64.private,
    is_winner: false.private,
    _nonce: 5007061680182881660404536607103738493700785693479229034391686216993694904652group.public
    }" || exit


# Restore the .env file to its original state.
echo "NETWORK=testnet
PRIVATE_KEY=APrivateKey1zkp8CZNn3yeCseEtxuVPbDCwSyhGW6yZKUYKfgXmcpoGPWH
ENDPOINT=http://localhost:3030
" > .env






