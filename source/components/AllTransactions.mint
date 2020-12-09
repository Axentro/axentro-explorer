component AllTransactions {
  connect Application exposing { blockId, address }

  property source : TransactionState
  state transactions : Maybe(PaginatedTransactions) = Maybe.nothing()
  state error : String = ""

  state selectedPerPage : String = "10"
  state currentPage : Number = 0

  fun componentDidMount : Promise(Never, Void) {
    sequence {
      getTransactions()
    }
  }

  fun getAllTransactions (page : String, perPage : String) : Promise(Never, Void) {
    sequence {
      response =
        Http.get(Network.baseUrl() + "/api/v1/transactions?page=" + page + "&per_page=" + perPage + "&sort_field=time")
        |> Http.send()

      json =
        Json.parse(response.body)
        |> Maybe.toResult("Json parsing error with transactions")

      result =
        decode json as ApiResponseTransactions

      next { transactions = Maybe.just(result.transactions) }
    } catch {
      next { error = "Could not fetch transactions" }
    }
  }

  fun getBlockTransactions (page : String, perPage : String) : Promise(Never, Void) {
    sequence {
      response =
        Http.get(Network.baseUrl() + "/api/v1/block/" + blockId + "/transactions?page=" + page + "&per_page=" + perPage + "&sort_field=time")
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
      next { error = "Could not fetch transactions" }
    }
  }

  fun getAddressTransactions (page : String, perPage : String) : Promise(Never, Void) {
    sequence {
      response =
        Http.get(Network.baseUrl() + "/api/v1/address/" + address + "/transactions?page=" + page + "&per_page=" + perPage + "&sort_field=time")
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
      next { error = "Could not fetch transactions" }
    }
  }

   fun getDomainTransactions (page : String, perPage : String) : Promise(Never, Void) {
    sequence {
      response =
        Http.get(Network.baseUrl() + "/api/v1/domain/" + address + "/transactions?page=" + page + "&per_page=" + perPage + "&sort_field=time")
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
      next { error = "Could not fetch transactions" }
    }
  }

  fun getTransactions : Promise(Never, Void) {
    case (source) {
      TransactionState::All => getAllTransactions(page, perPage)
      TransactionState::Address => getAddressTransactions(page, perPage)
      TransactionState::Domain => getDomainTransactions(page, perPage)
      TransactionState::Block => getBlockTransactions(page, perPage)
    }
  } where {
    perPage =
      selectedPerPage

    page =
      Number.toString(currentPage)
  }

  fun renderAddresses (addresses : Array(String)) : Array(Html) {
    for (address of addresses) {
      <div>
        <a href={"/address/" + address}>
          <{ UiHelper.capLength(address, 24) }>
        </a>
      </div>
    }
  }

  fun renderTransactionId (row : TransactionsResponse) : Html {
    <a href={"/transactions/" + transactionId}>
      <{ UiHelper.capLength(transactionId, 24) }>
    </a>
  } where {
    transactionId =
      row.transaction.id
  }

  fun renderBlockId (row : TransactionsResponse) : Html {
    <a href={"/blocks/" + blockId}>
      <{ blockId }>
    </a>
  } where {
    blockId =
      Number.toString(row.blockId)
  }

  fun renderAge (row : TransactionsResponse) : String {
    UiHelper.timeAgo(row.transaction.timestamp)
  }

  fun renderAmount (row : TransactionsResponse) : Html {
    <h6 class="tag tag-blue">
      <{ amount }>

      <span class="tag-addon tag-azure">
        "  AXNT"
      </span>
    </h6>
  } where {
    amount =
      UiHelper.displayAmount(
        row.transaction.recipients
        |> Array.map((r : ApiRecipient) { r.amount })
        |> Array.sum)
  }

  fun renderFee (row : TransactionsResponse) : Html {
    <h6 class="tag tag-gray">
      <{ amount }>

      <span class="tag-addon tag-azure">
        "  AXNT"
      </span>
    </h6>
  } where {
    amount =
      UiHelper.displayAmount(
        row.transaction.senders
        |> Array.map((s : ApiSender) { s.fee })
        |> Array.sum)
  }

  fun renderBodyRow (row : TransactionsResponse) : Html {
    <tr>
      <td class="text-muted">
        <{ renderTransactionId(row) }>
      </td>

      <td class="text-muted">
        <{ renderBlockId(row) }>
      </td>

      <td class="text-muted">
        <{ renderAge(row) }>
      </td>

      <td class="text-muted">
        <{
          if (Array.isEmpty(senderAddresses)) {
            <div/>
          } else {
            <{ renderAddresses(senderAddresses) }>
          }
        }>
      </td>

      <td class="text-muted">
        <{ renderAddresses(recipientAddresses) }>
      </td>

      <td class="text-muted">
        <{ renderAmount(row) }>
      </td>

      <td class="text-muted">
        <{ renderFee(row) }>
      </td>
    </tr>
  } where {
    recipientAddresses =
      row.transaction.recipients
      |> Array.map((r : ApiRecipient) { r.address })

    senderAddresses =
      row.transaction.senders
      |> Array.map((s : ApiSender) { s.address })
  }

  fun onPerPage (event : Html.Event) {
    sequence {
      next { selectedPerPage = Dom.getValue(event.target) }
      getTransactions()
    }
  }

  fun onPrevPage (event : Html.Event) {
    sequence {
      next { currentPage = Math.max(0, currentPage - 1) }
      getTransactions()
    }
  }

  fun onNextPage (event : Html.Event) {
    sequence {
      next { currentPage = currentPage + 1 }
      getTransactions()
    }
  }

  fun render : Html {
    <div class="card overflow-hidden">
      <div class="card-header">
        <div class="col-md-12">
          <div class="float-left">
            <h3 class="card-title">
              "Transactions"
            </h3>
          </div>

          <div class="float-right">
            <Pagination
              paginationKind={PaginationKind::Transaction(paginationData)}
              selectedPerPage={selectedPerPage}
              onPerPage={onPerPage}
              onPrevPage={onPrevPage}
              onNextPage={onNextPage}/>
          </div>
        </div>
      </div>

      <div class="card-body">
        <div class="table-responsive orders-table">
          <table
            id="example"
            class="table table-bordered text-nowrap  mb-0">

            <thead>
              <tr class="bold border-bottom">
                <th class="border-bottom-0">
                  "Transaction id"
                </th>

                <th class="border-bottom-0">
                  "Block id"
                </th>

                <th class="border-bottom-0">
                  "Age"
                </th>

                <th class="border-bottom-0">
                  "From"
                </th>

                <th class="border-bottom-0">
                  "To"
                </th>

                <th class="border-bottom-0">
                  "Amount"
                </th>

                <th class="border-bottom-0">
                  "Fee"
                </th>
              </tr>
            </thead>

            <tbody>
              for (row of recentTransactions) {
                renderBodyRow(row)
              }
            </tbody>

          </table>
        </div>
      </div>
    </div>
  } where {
    recentTransactions =
      (transactions
      |> Maybe.map(.transactions)
      |> Maybe.withDefault([] of TransactionsResponse))

    paginationData =
      transactions
      |> Maybe.map(.pagination)
      |> Maybe.withDefault(
        {
          page = 0,
          totalCount = 0
        })
  }
}
