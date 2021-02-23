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

  /transactions?page=:currentPage&perPage=:perPage (currentPage : String, perPage : String) {
    sequence {
      TransactionStore.initAllTransactions(currentPage, perPage)
      Application.setPage("transactions")
    }
  }

  /transactions {
    sequence {
      TransactionStore.initAllTransactions("1", "10")
      Application.setPage("transactions")
    }
  }

  /blocks/:blockId/transactions?page=:currentPage&perPage=:perPage (blockId : String, currentPage : String, perPage : String) {
    sequence {
      TransactionStore.initBlockTransactions(blockId, currentPage, perPage)
      Application.setPage("block_transactions")
    }
  }

  /blocks/:blockId/transactions (blockId : String) {
    sequence {
      TransactionStore.initBlockTransactions(blockId, "1", "10")
      Application.setPage("block_transactions")
    }
  }

  /blocks/:blockId (blockId : String) {
    sequence {
      Application.setBlockId(blockId)
      Application.setPage("block")
    }
  }

  /address/:address?page=:currentPage&perPage=:perPage (address : String, currentPage : String, perPage : String) {
    sequence {
      TransactionStore.initAddressTransactions(address, currentPage, perPage)
      Application.setPage("address")
    }
  }

  /domain/:domain?page=:currentPage&perPage=:perPage (domain : String, currentPage : String, perPage : String) {
    sequence {
      TransactionStore.initDomainTransactions(domain, currentPage, perPage)
      Application.setPage("domain")
    }
  }

  /address/:address (address : String) {
    sequence {
      TransactionStore.initAddressTransactions(address, "1", "10")
      Application.setPage("address")
    }
  }

  /domain/:domain (domain : String) {
    sequence {
      TransactionStore.initDomainTransactions(domain, "1", "10")
      Application.setPage("domain")
    }
  }

  /blocks?page=:currentPage&perPage=:perPage (currentPage : String, perPage : String) {
    sequence {
      BlockStore.setCurrentPage(currentPage)
      BlockStore.setPerPage(perPage)
      BlockStore.getBlocks()
      Application.setPage("blocks")
    }
  }

  /blocks {
    sequence {
      BlockStore.setCurrentPage("1")
      BlockStore.setPerPage("10")
      BlockStore.getBlocks()
      Application.setPage("blocks")
    }
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
