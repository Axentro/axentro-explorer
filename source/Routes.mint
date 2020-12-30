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
      TransactionStore.setCurrentPage(currentPage)
      TransactionStore.setPerPage(perPage)
      TransactionStore.getAllTransactions()
      Application.setPage("transactions")
    }
  }

  /transactions {
     sequence {
      TransactionStore.setCurrentPage("0")
      TransactionStore.setPerPage("10") 
      TransactionStore.getAllTransactions()
      Application.setPage("transactions")
     }
  }

 /blocks/:blockId/transactions?page=:currentPage&perPage=:perPage (blockId : String, currentPage : String, perPage : String) {
    sequence {
      TransactionStore.setBlockId(blockId)
      TransactionStore.setCurrentPage(currentPage)
      TransactionStore.setPerPage(perPage)  
      TransactionStore.setSource(TransactionState::Block)  
      TransactionStore.getBlockTransactions()
      Application.setPage("block_transactions")
    }
  }

  /blocks/:blockId/transactions (blockId : String) {
    sequence {
      TransactionStore.setBlockId(blockId)
      TransactionStore.setCurrentPage("0")
      TransactionStore.setPerPage("10") 
      TransactionStore.setSource(TransactionState::Block)  
      TransactionStore.getBlockTransactions()
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
      TransactionStore.setAddress(address)
      TransactionStore.setCurrentPage(currentPage)
      TransactionStore.setPerPage(perPage)
      TransactionStore.setSource(TransactionState::Address)   
      TransactionStore.getAddressTransactions() 
      TransactionStore.getWalletInfo()
      Application.setPage("address")
    }
  }

  /domain/:domain?page=:currentPage&perPage=:perPage (domain : String, currentPage : String, perPage : String) {
    sequence {
     TransactionStore.setAddress(domain)
      TransactionStore.setCurrentPage(currentPage)
      TransactionStore.setPerPage(perPage)
      TransactionStore.setSource(TransactionState::Domain)   
      TransactionStore.getDomainTransactions() 
      TransactionStore.getWalletInfo()
      Application.setPage("domain")
    }
  }

  /address/:address (address : String) {
    sequence {
      TransactionStore.setAddress(address)
      TransactionStore.setCurrentPage("0")
      TransactionStore.setPerPage("10") 
      TransactionStore.setSource(TransactionState::Address)   
      TransactionStore.getAddressTransactions()  
      TransactionStore.getWalletInfo()
      Application.setPage("address")
    }
  }

  /domain/:domain (domain : String) {
    sequence {
      TransactionStore.setAddress(domain)
      TransactionStore.setCurrentPage("0")
      TransactionStore.setPerPage("10")  
      TransactionStore.setSource(TransactionState::Domain)   
      TransactionStore.getDomainTransactions() 
      TransactionStore.getWalletInfo()
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
      BlockStore.setCurrentPage("0")
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
