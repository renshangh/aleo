Implemented a new feature of block_height. The function trasfer_private checks the current block heigh and only allow the execution when it passed a predefined number.   

Here is the deploy info.

➜  linkgear_mining_dao_token git:(main) ✗ leo deploy
       Leo ✅ Compiled 'linkgear_mining_dao_token.aleo' into Aleo instructions
📦 Creating deployment transaction for 'linkgear_mining_dao_token.aleo'...

📊 Deployment Summary:
      Total Variables:      217,824
      Total Constraints:    155,686

Base deployment cost for 'linkgear_mining_dao_token.aleo' is 15.23075 credits.

+--------------------------------+----------------+
| linkgear_mining_dao_token.aleo | Cost (credits) |
+--------------------------------+----------------+
| Transaction Storage            | 4.893000       |
+--------------------------------+----------------+
| Program Synthesis              | 9.337750       |
+--------------------------------+----------------+
| Namespace                      | 1.000000       |
+--------------------------------+----------------+
| Priority Fee                   | 0.000000       |
+--------------------------------+----------------+
| Total                          | 15.230750      |
+--------------------------------+----------------+

Your current public balance is 104.880665 credits.

? Do you want to submit deployment of program `linkgear_mining_dao_token.aleo` to network testnet via endpoint https://a
✔ Do you want to submit deployment of program `linkgear_mining_dao_token.aleo` to network testnet via endpoint https://api.explorer.provable.com/v1 using address aleo1g24j0aa2fw69y7n05aehk3gp7cf8tr9ea2nnpnavx3qdpmc5r5rse08kl2? · yes
✅ Created deployment transaction for 'linkgear_mining_dao_token.aleo'

Broadcasting transaction to https://api.explorer.provable.com/v1/testnet/transaction/broadcast...

⌛ Deployment at1r9v8hprsnyaak8r9hqfg8ucnwmlkltas8tlfuz95jv6kc9pjw5rq8zd253 ('linkgear_mining_dao_token.aleo') has been broadcast to https://api.explorer.provable.com/v1/testnet/transaction/broadcast.



leo run transfer_private "{owner: aleo1g24j0aa2fw69y7n05aehk3gp7cf8tr9ea2nnpnavx3qdpmc5r5rse08kl2.private, 
amount: 1000000000000000u128.private, 
token_id: 71619063553950105623552field.private, 
external_authorization_required: true.private, 
authorized_until: 4294967295u32.private, 
_nonce: 4171342428487949176087471229466059149427987590264190336989689461864714570288group.public }" "{ owner: aleo1g24j0aa2fw69y7n05aehk3gp7cf8tr9ea2nnpnavx3qdpmc5r5rse08kl2.private, 
amount_spent: 0u128.private, 
epoch_spent: 0u32.private, 
_nonce: 752514431784115870595676085969032676294182558689481203097690104756728941221group.public }" "100_000_000u128" "aleo1q5taq9mdcq7cvv4mq67fmvum2my3z2qzszgwm9ju70eplprx0sfqnszn4m" "1u32"
