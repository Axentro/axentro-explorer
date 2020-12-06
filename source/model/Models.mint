/* Stats */
record ApiResponseStats {
  status : String,
  stats : StatsResponse using "result"
}

record StatsResponse {
  totals : Stats
}

record Stats {
  totalFastBlocks : Number using "total_fast",
  totalSlowBlocks : Number using "total_slow",
  totalBlocks : Number using "total_size",
  totalFastTransactions : Number using "total_txns_fast",
  totalSlowTransactions : Number using "total_txns_slow",
  difficulty : Number
}

/* Transactions */
record ApiResponseTransactions {
  status : String,
  transactions : PaginatedTransactions using "result"
}

record PaginatedTransactions {
  transactions : Array(TransactionsResponse),
  pagination : TransactionPagination
}

record TransactionPagination {
  page : Number,
  totalCount : Number using "total_count"
}

record ApiResponseTransaction {
  status : String,
  transaction : ApiTransactionResponse using "result"
}

record ApiTransactionResponse {
  status : String,
  transaction : ApiTransaction,
  confirmations : Number
}

record ApiResponseBlockTransactions {
  status : String,
  result : BlockTransactionsResponse
}

record BlockTransactionsResponse {
  transactions : Array(ApiTransaction),
  confirmations : Number,
  blockId : Number using "block_id",
  pagination : BlockPagination
}

record ApiResponseAddressTransactions {
  status : String,
  result : AddressTransactionsResponse
}

record AddressTransactionsResponse {
  transactions : Array(AddressTransactionResponse),
  pagination : TransactionPagination
}

record AddressTransactionResponse {
  transaction : ApiTransaction,
  confirmations : Number
}


record TransactionsResponse {
  transaction : ApiTransaction,
  confirmations : Number,
  blockId : Number using "block_id"
}

record ApiTransaction {
  id : String,
  action : String,
  senders : Array(ApiSender),
  recipients : Array(ApiRecipient),
  token : String,
  timestamp : Number,
  kind : String,
  message : String,
  previousHash : String using "prev_hash"
}

record ApiSender {
  address : String,
  amount : Number,
  publicKey : String using "public_key",
  fee : Number,
  signature : String
}

record ApiRecipient {
  address : String,
  amount : Number
}

/* Blocks */
record ApiResponseBlocks {
  status : String,
  blocks : BlocksResponse using "result"
}

record ApiResponseBlock {
  status : String,
  block : ApiBlockResponse using "result"
}

record ApiResponseSingleBlock {
  status : String,
  block : SingleBlockResponse using "result"
}

record SingleBlockResponse {
  block : ApiBlock
}

record ApiBlockResponse {
  block : BlocksResponse
}

record BlocksResponse {
  data : Array(ApiBlock),
  pagination : BlockPagination
}

record BlockPagination {
  page : Number,
  totalCount : Number using "total_count"
}

record ApiBlock {
  index : Number,
  transactions : Array(ApiTransaction),
  nonce : Maybe(String),
  previousHash : String using "prev_hash",
  merkleTreeRoot : String using "merkle_tree_root",
  timestamp : Number,
  difficulty : Maybe(Number),
  kind : String,
  address : String,
  hash : Maybe(String),
  publicKey : Maybe(String) using "public_key",
  signature : Maybe(String)
}

/* Wallet */
record ApiResponseWallet {
  status : String,
  result : ApiAddressInfo
}

record ApiAddressInfo {
  address : String,
  readable : Array(String),
  tokens : Array(ApiAddressToken)
}

record ApiAddressToken {
  name : String using "token",
  isLocked : Bool using "is_locked",
  isMine : Bool using "is_mine",
  amount : String
}
