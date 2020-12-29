store TransactionStore {
  state blockId : String = ""
  state transactionId : String = ""
  state address : String = ""
  state currentPage : String = "0"
  state perPage : String = "10"
  state walletInfo : Maybe(ApiAddressInfo) = Maybe.nothing()
  state walletError : String = ""
  state transactions : Maybe(PaginatedTransactions) = Maybe.nothing()
  state transactionError : String = ""
  state source : TransactionState = TransactionState::All

  fun setAddress (address : String) : Promise(Never, Void) {
    next { address = address }
  }

  fun setBlockId (blockId : String) : Promise(Never, Void) {
    next { blockId = blockId }
  }

 fun setSource(source : TransactionState) : Promise(Never, Void) {
    next { source = source }
  }

 fun setCurrentPage(currentPage : String) : Promise(Never, Void) {
    next { currentPage = currentPage }
  }

   fun setPerPage(perPage : String) : Promise(Never, Void) {
    next { perPage = perPage }
  }

    fun getWalletInfo : Promise(Never, Void) {
    sequence {
      response =
        Http.get(Network.baseUrl() + "/api/v1/wallet/" + address)
        |> Http.send()

      json =
        Json.parse(response.body)
        |> Maybe.toResult("Json parsing error with wallet")

      result =
        decode json as ApiResponseWallet

      next { walletInfo = Maybe.just(result.result) }
    } catch {
      next { walletError = "Could not fetch wallet info" }
    }
  }

   fun getAllTransactions () : Promise(Never, Void) {
    sequence {
      response =
        Http.get(Network.baseUrl() + "/api/v1/transactions?page=" + currentPage + "&per_page=" + perPage + "&sort_field=time")
        |> Http.send()

      json =
        Json.parse(response.body)
        |> Maybe.toResult("Json parsing error with transactions")

      result =
        decode json as ApiResponseTransactions

      next { transactions = Maybe.just(result.transactions) }
    } catch {
      next { transactionError = "Could not fetch transactions" }
    }
  }

  fun getBlockTransactions () : Promise(Never, Void) {
    sequence {
      response =
        Http.get(Network.baseUrl() + "/api/v1/block/" + blockId + "/transactions?page=" + currentPage + "&per_page=" + perPage + "&sort_field=time")
        |> Http.send()

      json =
        Json.parse(response.body)
        |> Maybe.toResult("Json parsing error with transactions")

      Debug.log(json)

      result =
        decode json as ApiResponseBlockTransactions

      txns =
        result.result.transactions
        |> Array.map(
          (t : ApiTransaction) {
            {
              transaction = t,
              confirmations = result.result.confirmations,
              blockId = result.result.blockId
            }
          })

      modified =
        {
          transactions = txns,
          pagination = result.result.pagination
        }

      next { transactions = Maybe.just(modified) }
    } catch {
      next { transactionError = "Could not fetch transactions" }
    }
  }

  fun getAddressTransactions () : Promise(Never, Void) {
    sequence {
      response =
        Http.get(Network.baseUrl() + "/api/v1/address/" + address + "/transactions?page=" + currentPage + "&per_page=" + perPage + "&sort_field=time")
        |> Http.send()

      json =
        Json.parse(response.body)
        |> Maybe.toResult("Json parsing error with transactions")

      Debug.log(json)

      result =
        decode json as ApiResponseAddressTransactions

      txns =
        result.result.transactions
        |> Array.map(
          (t : TransactionsResponse) {
            {
              transaction = t.transaction,
              confirmations = t.confirmations,
              blockId = t.blockId
            }
          })

      modified =
        {
          transactions = txns,
          pagination = result.result.pagination
        }

      next { transactions = Maybe.just(modified) }
    } catch {
      next { transactionError = "Could not fetch transactions" }
    }
  }

  fun getDomainTransactions () : Promise(Never, Void) {
    sequence {
      response =
        Http.get(Network.baseUrl() + "/api/v1/domain/" + address + "/transactions?page=" + currentPage + "&per_page=" + perPage + "&sort_field=time")
        |> Http.send()

      json =
        Json.parse(response.body)
        |> Maybe.toResult("Json parsing error with transactions")

      Debug.log(json)

      result =
        decode json as ApiResponseAddressTransactions

      txns =
        result.result.transactions
        |> Array.map(
          (t : TransactionsResponse) {
            {
              transaction = t.transaction,
              confirmations = t.confirmations,
              blockId = t.blockId
            }
          })

      modified =
        {
          transactions = txns,
          pagination = result.result.pagination
        }

      next { transactions = Maybe.just(modified) }
    } catch {
      next { transactionError = "Could not fetch transactions" }
    }
  }

  

}