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
      Application.setCurrentPage(currentPage)
      Application.setPerPage(perPage)
      Application.setPage("transactions")
    }
  }

  /transactions {
    sequence {
      Application.setCurrentPage("0")
      Application.setPerPage("10")  
      Application.setPage("transactions")
    }
  }

 /blocks/:blockId/transactions?page=:currentPage&perPage=:perPage (blockId : String, currentPage : String, perPage : String) {
    sequence {
      Application.setBlockId(blockId)
      Application.setCurrentPage(currentPage)
      Application.setPerPage(perPage)  
      Application.setPage("block_transactions")
    }
  }

  /blocks/:blockId/transactions (blockId : String) {
    sequence {
      Application.setBlockId(blockId)
      Application.setCurrentPage("0")
      Application.setPerPage("10")  
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
      Application.setAddress(address)
      Application.setCurrentPage(currentPage)
      Application.setPerPage(perPage)  
      Application.setPage("address")
    }
  }

  /domain/:domain?page=:currentPage&perPage=:perPage (domain : String, currentPage : String, perPage : String) {
    sequence {
      Application.setAddress(domain)
      Application.setCurrentPage(currentPage)
      Application.setPerPage(perPage)  
      Application.setPage("domain")
    }
  }

  /address/:address (address : String) {
    sequence {
      Application.setAddress(address)
       Application.setCurrentPage("0")
      Application.setPerPage("10")  
      Application.setPage("address")
    }
  }

  /domain/:domain (domain : String) {
    sequence {
      Application.setAddress(domain)
      Application.setCurrentPage("0")
      Application.setPerPage("10")  
      Application.setPage("domain")
    }
  }

  /blocks?page=:currentPage&perPage=:perPage (currentPage : String, perPage : String) {
    sequence {
      Application.setCurrentPage(currentPage)
      Application.setPerPage(perPage)
      Application.setPage("blocks")
    }
  }

  /blocks {
    sequence {
      Application.setCurrentPage("0")
      Application.setPerPage("10")
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
