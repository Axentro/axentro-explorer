component AllTransactions {
  connect TransactionStore exposing { blockId, address, source, currentPage, perPage, transactions, transactionError, getAllTransactions, getAddressTransactions, getDomainTransactions, getBlockTransactions }

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
      <{ "Block " + blockId }>
    </a>
  } where {
    blockId =
      Number.toString(row.blockId)
  }

  fun renderAge (row : TransactionsResponse) : String {
    UiHelper.timeAgo(row.transaction.timestamp)
  }

    fun renderDate (row : TransactionsResponse) : String {
    UiHelper.shortDateFrom(row.transaction.timestamp)
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
        <div>
        <{ renderAge(row) }>
        </div>
        <div>
        <i><{ renderDate(row) }></i>
        </div>
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
    case (source) {
      TransactionState::All => Window.navigate("/transactions?page=" + currentPage + "&perPage=" + currentPerPageValue)
      TransactionState::Address => Window.navigate("/address/" + address + "?page=" + currentPage + "&perPage=" + currentPerPageValue)
      TransactionState::Domain => Window.navigate("/domain/" + address + "?page=" + currentPage + "&perPage=" + currentPerPageValue)
      TransactionState::Block => Window.navigate("/blocks/" + blockId + "/transactions?page=" + currentPage + "&perPage=" + currentPerPageValue)
    }
  } where {
    currentPerPageValue = Dom.getValue(event.target)
  }

  fun onPrevPage (event : Html.Event) {
    case (source) {
      TransactionState::All => Window.navigate("/transactions?page=" + currentPageValue + "&perPage=" + perPage)
      TransactionState::Address => Window.navigate("/address/" + address + "?page=" + currentPageValue + "&perPage=" + perPage)
      TransactionState::Domain => Window.navigate("/domain/" + address + "?page=" + currentPageValue + "&perPage=" + perPage)
      TransactionState::Block => Window.navigate("/blocks/" + blockId + "/transactions?page=" + currentPageValue + "&perPage=" + perPage)
    }
  } where {
    currentPageValue = Number.toString(Math.max(0, (currentPage |> Number.fromString() |> Maybe.withDefault(0)) - 1))
  }

  fun onNextPage (event : Html.Event) {
    case (source) {
      TransactionState::All => Window.navigate("/transactions?page=" + currentPageValue + "&perPage=" + perPage)
      TransactionState::Address => Window.navigate("/address/" + address + "?page=" + currentPageValue + "&perPage=" + perPage)
      TransactionState::Domain => Window.navigate("/domain/" + address + "?page=" + currentPageValue + "&perPage=" + perPage)
      TransactionState::Block => Window.navigate("/blocks/" + blockId + "/transactions?page=" + currentPageValue + "&perPage=" + perPage)
    }
  } where {
    currentPageValue = Number.toString((currentPage |> Number.fromString() |> Maybe.withDefault(0)) + 1)
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
              selectedPerPage={perPage}
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
