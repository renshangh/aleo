// The 'learningclass1foraleoauction' program.
// Replace the 'aleo1g24j0aa2fw69y7n05aehk3gp7cf8tr9ea2nnpnavx3qdpmc5r5rse08kl2' address with your own address.
// owner: aleo1g24j0aa2fw69y7n05aehk3gp7cf8tr9ea2nnpnavx3qdpmc5r5rse08kl2 -account1
// bid 1: aleo1ecyryek3a4c7h5ymrksh33h8fvzs9lf4vg9wfmcf44nvhdmakqgse4gns0 -account2
// bid 2: aleo1vxmpuetu7ausmx7hnhh2xltg9ckrwge50l9syzp6kkcwwyfp6gpqldkecn -account3
program learningclass1foraleoauction.aleo {
    // A bid in an auction.
    // - `owner`     : The address of the account that owns the record associated with this bid.
    //                 This is separate from the address of the account that placed the bid.
    // - `bidder`    : The address of the account that placed the bid.
    // - `amount`    : The amount of the bid.
    // - `is_winner` : Whether the bid is the winning bid.
    record Bid {
        owner: address,
        bidder: address,
        amount: u64,
        is_winner: bool,
    }

    // Returns a new bid.
    // - `bidder` : The address of the account that placed the bid.
    // - `amount` : The amount of the bid.
    // Requires that `bidder` matches the function caller.
    // The owner of the record is set to the entity responsible for running the auction (auction runner).
    // The address of the auction runner is aleo1g24j0aa2fw69y7n05aehk3gp7cf8tr9ea2nnpnavx3qdpmc5r5rse08kl2.
    transition place_bid(bidder: address, amount: u64) -> Bid {
        // Ensure the caller is the auction bidder.
        assert_eq(self.caller, bidder);
        // Return a new 'Bid' record for the auction bidder.
        return Bid {
            owner: aleo1g24j0aa2fw69y7n05aehk3gp7cf8tr9ea2nnpnavx3qdpmc5r5rse08kl2,
            bidder: bidder,
            amount: amount,
            is_winner: false,
        };
    }

    // Returns the winning bid.
    // - `first`  : The first bid.
    // - `second` : The second bid.
    // Requires that the function caller is the auction runner.
    // Assumes that the function is invoked only after the bidding period has ended.
    // In the event of a tie, the first bid is selected.
    transition resolve(first: Bid, second: Bid) -> Bid {
        // Ensure the caller is the auctioneer.
        assert_eq(self.caller, aleo1g24j0aa2fw69y7n05aehk3gp7cf8tr9ea2nnpnavx3qdpmc5r5rse08kl2);
        // Resolve the winner of the auction.
        if (first.amount >= second.amount) {
            return first;
        } else {
            return second;
        }
    }

    // Returns ownership of the bid to bidder.
    // - `bid` : The winning bid.
    // Requires that the function caller is the auction runner.
    // Assumes that the function is invoked only after all bids have been resolved.
    transition finish(bid: Bid) -> Bid {
        // Ensure the caller is the auctioneer.
        assert_eq(self.caller, aleo1g24j0aa2fw69y7n05aehk3gp7cf8tr9ea2nnpnavx3qdpmc5r5rse08kl2);
        // Return 'is_winner' as 'true' in the winning 'Bid'.
        return Bid {
            owner: bid.bidder,
            bidder: bid.bidder,
            amount: bid.amount,
            is_winner: true,
        };
    }
}


