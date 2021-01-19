component RecentTransactions {
  property transactions : Array(TransactionsResponse)

  fun sendersAndRecipients (row : TransactionsResponse) : Html {
    <div>
      <{
        if (Array.isEmpty(senderAddresses)) {
          <div/>
        } else {
          <div>
            "From: "
            <{ renderSenderAddresses(senderAddresses, row) }>
          </div>
        }
      }>

      <div>
        "To: "
        <{ renderRecipientAddresses(recipientAddresses, row) }>
      </div>
    </div>
  } where {
    senderAddresses =
      row.transaction.senders
      |> Array.map((s : ApiSender) { s.address })

    recipientAddresses =
      row.transaction.recipients
      |> Array.map((r : ApiRecipient) { r.address })
  }

 fun renderRemainingAddresses(total : Number, remaining : Number, capped : Number, transactionId : String) : Html {
   if (remaining > 0) {
   <div>
     <a href={"/transactions/" + transactionId}>
       <b><{ "showing " + cappedString + " of " + totalString }></b>
    </a>
    </div>
  } else {
    <div></div>
  }
  } where {
    totalString = total |> Number.toString()
    remainingString = remaining |> Number.toString()
    cappedString = capped |> Number.toString()
  }

  fun renderRecipientAddresses (addresses : Array(String), row : TransactionsResponse) : Html {
    <div>
    for (address of cappedAddressList) {
      <div>
        <a href={"/address/" + address}>
          <{ UiHelper.capLength(address, 24) }>
        </a>
      </div>
    }
    <{ renderRemainingAddresses(total, remaining, capped, transactionId) }>
    </div>
  } where {
    cappedAddressList = addresses |> Array.take(3) 
    capped = cappedAddressList |> Array.size()
    total = addresses |> Array.size()
    remaining = total - (cappedAddressList |> Array.size())
    transactionId = row.transaction.id
  }

 fun renderSenderAddresses (addresses : Array(String), row : TransactionsResponse) : Html {
    <div>
    for (address of cappedAddressList) {
      <div>
        <a href={"/address/" + address}>
          <{ UiHelper.capLength(address, 24) }>
        </a>
      </div>
    }
     <{ renderRemainingAddresses(total, remaining, capped, transactionId) }>
    </div>
  } where {
    cappedAddressList = addresses |> Array.take(3) 
    capped = cappedAddressList |> Array.size()
    total = addresses |> Array.size()
    remaining = total - (cappedAddressList |> Array.size())
    transactionId = row.transaction.id
  }

  fun renderTransactionId (row : TransactionsResponse) : Html {
    <div>
      <a href={"/transactions/" + transactionId}>
        <{ UiHelper.capLength(transactionId, 24) }>
      </a>

      <div>
        <a href={"/blocks/" + blockId}>
          <i>
            <{ "Block " + blockId }>
          </i>
        </a>
      </div>

      <div>
        <div>
          <b>
            <{ calculateTimeAgo(row) }>
          </b>
        </div>

        <div>
          <i>
            <{ renderDate(row) }>
          </i>
        </div>
      </div>
    </div>
  } where {
    transactionId =
      row.transaction.id

    blockId =
      Number.toString(row.blockId)
  }

  fun calculateTimeAgo (row : TransactionsResponse) : String {
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

   fun renderTokenAmounts(row : TransactionsResponse) : Html {
      renderTokenAmount(tokenAmount)
  } where {
    amount =
      UiHelper.displayAmount(
        row.transaction.recipients
        |> Array.map((r : ApiRecipient) { r.amount })
        |> Array.sum)
    tokenAmount = { token = row.transaction.token, amount = amount}
  }

  fun renderTokenAmount(tokenAmount : TokenAmount) : Html {
    if (tokenAmount.token == "AXNT"){
      <div>
       <h6 class="tag tag-blue">
      <{ tokenAmount.amount }>

      <span class="tag-addon tag-azure">
        "  AXNT"
      </span>
    </h6>
    </div>
    } else {
      <div>
      <h6 class="tag tag-lime">
      <{ tokenAmount.amount }>

      <span class="tag-addon tag-purple">
        <{ tokenAmount.token }>
      </span>
    </h6>
    </div>
    }
  }

  fun renderBodyRow (row : TransactionsResponse) : Html {
    <tr>
      <td class="text-muted">
        <{ renderTransactionId(row) }>
      </td>

      <td class="text-muted">
        <{ sendersAndRecipients(row) }>
      </td>

      <td class="text-muted">
        <{ renderTokenAmounts(row) }>
      </td>
    </tr>
  }

  fun render : Html {
    <div class="card overflow-hidden">
      <div class="card-header">
        <div class="col-md-12">
          <div class="float-left">
            <h3 class="card-title">
              "Latest Transactions"
            </h3>
          </div>

          <div class="float-right">
            <a
              href="/transactions"
              class="btn btn-app btn-indigo">

              <i class="fa fa-tasks"/>
              "  View all transactions"

            </a>
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
                  "From / To"
                </th>

                <th class="border-bottom-0">
                  "Amount"
                </th>
              </tr>
            </thead>

            <tbody>
              for (row of transactions) {
                renderBodyRow(row)
              }
            </tbody>

          </table>
        </div>
      </div>
    </div>
  }
}
