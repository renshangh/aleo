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
        owner: aleo1ashyu96tjwe63u0gtnnv8z5lhapdu4l5pjsl2kha7fv7hvz2eqxs5dz0rg.private,
        bidder: aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px.private,
        amount: 10u64.private,
        is_winner: false.private,
        _nonce: 143615537336487518231260507449657115217148420102194585767286561830487900075group.public
    }" "{
        owner: aleo1ashyu96tjwe63u0gtnnv8z5lhapdu4l5pjsl2kha7fv7hvz2eqxs5dz0rg.private,
        bidder: aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t.private,
        amount: 90u64.private,
        is_winner: false.private,
        _nonce: 6467846572146524919011604714643822427734288518702182985678678101776343830750group.public
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
        owner: aleo1ashyu96tjwe63u0gtnnv8z5lhapdu4l5pjsl2kha7fv7hvz2eqxs5dz0rg.private,
        bidder: aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t.private,
        amount: 90u64.private,
        is_winner: false.private,
        _nonce:5295450145728903416898002358374704886257487492344414839814928116124564429158group.public
    }" || exit


# Restore the .env file to its original state.
echo "NETWORK=testnet
PRIVATE_KEY=APrivateKey1zkp8CZNn3yeCseEtxuVPbDCwSyhGW6yZKUYKfgXmcpoGPWH
ENDPOINT=http://localhost:3030
" > .env






