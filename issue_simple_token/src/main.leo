import token_registry.aleo;
import credits.aleo;

program token_vesting_linear.aleo {

	record LockedTokensReceipt {
		owner: address,
		lock_id: field
	}
	struct LockedTokens {
		lock_id: field,
		token_id: field,
		locked_amount: u128,
		claimed_amount: u128,
		start_block: u32,
		blocks_count_per_part: u32
	}

	mapping locks: field => LockedTokens; // lock_id => LockedTokens

	async transition create_lock_private(
		t: token_registry.aleo/Token, 
		amount: u128, receiver: address, 
		public block_start: u32, 
		public block_length: u32
		) -> (token_registry.aleo/Token, LockedTokensReceipt, Future) {
		// Check that the sender is the owner of the token
		assert t.owner == self.address;
		// Create a new vesting contract
		let tranfer_result: (token_registry.aleo/Token, Future) = 
		token_registry.aleo/transfer_private_to_public(
			self.address, amount, t);
		
		//
		let receipt: LockedTokensReceipt = LockedTokensReceipt(
			owner: receiver, lock_id: lock_id);

		// Store the receipt
		credits.aleo/store_locked_tokens_receipt(receipt);

		// Return the future
		return (
			tranfer_result.0, 
			receipt, 
			f_create_lock_private(
				tranfer_result.1, lock_id, t.token_id, block_length, amount, block_start)
		)
	}		
	
	async function f_create_lock_private (
		f0: Future,
		lock_id: field,
		token_id: field,
		block_length: u32,
		amount: u128,
		block_start: u32
	) {
		f0.await();
		asset(!locks.contains(lock_id));
		locks.set(lock_id, LockedTokens(
			lock_id: lock_id,
			token_id: token_id,
			locked_amount: amount,
			claimed_amount: 0u128,
			start_block: block_start,
			blocks_count_per_part: block_length
		));
	}

	async transition claim(
		receipt: LockedTokensReceipt,
		locked: LockedTokens,
		amount: u128,
		is_authorized_token: bool
	) -> (
		token_registry.aleo/Token, 
		LockedTokensReceipt,
		Future
	) {
	
		let claimed_amount: u128 = locked.claimed_amount + amount;
		assert_eq(receipt.lock_id, locked.lock_id);
		assert(claimed_amount <= locked.locked_amount);

		let transfer_result: (token_registry.aleo/Token, Future) =
		token_registry.aleo/transfer_public_to_private(
			locked.token_id, receipt.owner, amount, is_authorized_token);

		let claimed_part: u128 = (claimed_amount * 1000u128) / locked.locked_amount;

		return(
			transfer_result.0,
			receipt,
			f_claim(
				transfer_result.1,
				locked.lock_id,
				BHP256::hash_to_field(lock_id),
				claimed_part,
				claimed_amount				
			)
		)
	}

	async function f_claim(
		f0: Future,
		lock_id: field,
		lock_hash: field,
		claimed_amount_part: u128,
		claimed_amount: u128
	) {
		f0.await();
		let lock: LockedTokens = locks.get(lock_id);
		asset_eq(lock_hash, BHP256::hash_to_field(lock));

		let available_parts: u128 = (block.height - lock.start_block)/lock.blocks_count_per_part;
		
		asset(claimed_amount_part <= available_parts);

		locks.set(lock_id, LockedTokens(
			lock_id: lock.lock_id,
			token_id: lock.token_id,
			locked_amount: lock.locked_amount,
			claimed_amount: claimed_amount,
			start_block: lock.start_block,
			blocks_count_per_part: lock.blocks_count_per_part
		));
	}
	
