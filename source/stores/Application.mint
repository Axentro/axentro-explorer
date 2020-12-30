store Application {
  state page : String = ""
  state blockId : String = ""
  state transactionId : String = ""
  state searchTerm : String = ""

  fun setPage (page : String) : Promise(Never, Void) {
    sequence {
      Http.abortAll()
      next { page = page }
    }
  }

  fun setBlockId (blockId : String) : Promise(Never, Void) {
    next { blockId = blockId }
  }

  fun setTransactionId (transactionId : String) : Promise(Never, Void) {
    next { transactionId = transactionId }
  }

  fun setSearchTerm (term : String) : Promise(Never, Void) {
    next { searchTerm = term }
  }

}
