routes {
  / {
    Application.setPage("dashboard")
  }

  /dashboard {
    Application.setPage("dashboard")
  }

  /transactions/:transactionId (transactionId : String) {
    sequence {
      Application.setTransactionId(transactionId)
      Application.setPage("transaction")
    }
  }

  /transactions {
    Application.setPage("transactions")
  }

  /blocks/:blockId/transactions (blockId : String) {
    sequence {
      Application.setBlockId(blockId)
      Application.setPage("block_transactions")
    }
  }

  /blocks/:blockId (blockId : String) {
    sequence {
      Application.setBlockId(blockId)
      Application.setPage("block")
    }
  }

  /address/:address (address : String) {
    sequence {
      Application.setAddress(address)
      Application.setPage("address")
    }
  }

  /domain/:domain (domain : String) {
    sequence {
      Application.setAddress(domain)
      Application.setPage("domain")
    }
  }

  /blocks {
    Application.setPage("blocks")
  }

  /no_search/:term (term : String) {
    sequence {
      Application.setSearchTerm(term)
      Application.setPage("no_search")
    }
  }

  * {
    Application.setPage("not_found")
  }
}
