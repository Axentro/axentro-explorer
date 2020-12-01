routes {
  / {
    Application.setPage("dashboard")
  }

  /dashboard {
    Application.setPage("dashboard")
  }

   /transactions/:transactionId (transactionId: String) {
    sequence {
      Application.setTransactionId(transactionId)
      Application.setPage("transaction")
    }
  }

   /transactions {
    Application.setPage("transactions")
  }

   /blocks/:blockId/transactions (blockId: String) {
    sequence {
      Application.setBlockId(blockId)
      Application.setPage("block_transactions")
    }
  }

  /blocks/:blockId (blockId: String) {
    sequence {
      Application.setBlockId(blockId)
      Application.setPage("block")
    }
  }

  /blocks {
    Application.setPage("blocks")
  }

  * {
    Application.setPage("not_found")
  }
}
