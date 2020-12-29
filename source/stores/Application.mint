store Application {
  state page : String = ""
  state blockId : String = ""
  state transactionId : String = ""
  state searchTerm : String = ""
  state currentPage : String = "1"
  state perPage : String = "10"

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

  fun setCurrentPage(currentPage : String) : Promise(Never, Void) {
    next { currentPage = currentPage }
  }

   fun setPerPage(perPage : String) : Promise(Never, Void) {
    next { perPage = perPage }
  }
}
