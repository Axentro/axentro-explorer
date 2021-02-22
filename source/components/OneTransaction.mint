component OneTransaction {
  property transactions : Array(ApiTransactionResponse)

  fun render : Array(Html) {
    for (transaction of transactions) {
      renderTransaction(transaction)
    }
  }

  fun renderRecipients (row : ApiTransactionResponse) : Html {
    <table>
      <thead>
        <th>"Address"</th>
        <th>"Amount"</th>
      </thead>

      <tbody>
        for (r of row.transaction.recipients) {
          renderRecipientData(r, row.transaction.token)
        }
      </tbody>
    </table>
  }

  fun renderRecipientData (r : ApiRecipient, token : String) : Html {
    <tr>
      <td>
        <div>
          <a href={"/address/" + r.address}>
            <{ r.address }>
          </a>
        </div>
      </td>

      <td>
        <{ renderAmount(r.amount, token) }>
      </td>
    </tr>
  }

  fun renderSenders (row : ApiTransactionResponse) : Html {
    if (Array.isEmpty(row.transaction.senders)) {
      <div/>
    } else {
      <table>
        <thead>
          <th>"Address"</th>
          <th>"Amount"</th>
          <th>"Fee"</th>
          <th>"Public Key"</th>
          <th>"Signature"</th>
        </thead>

        <tbody>
          for (r of row.transaction.senders) {
            renderSenderData(r, row.transaction.token)
          }
        </tbody>
      </table>
    }
  }

  fun renderSenderData (s : ApiSender, token : String) : Html {
    <tr>
      <td>
        <div>
          <a href={"/address/" + s.address}>
            <{ s.address }>
          </a>
        </div>
      </td>

      <td>
        <{ renderAmount(s.amount, token) }>
      </td>

      <td>
        <{ renderAmount(s.fee, "AXNT") }>
      </td>

      <td>
        <{ s.publicKey }>
      </td>

      <td>
        <{ s.signature }>
      </td>
    </tr>
  }

  fun renderAmount (rawAmount : Number, token : String) : Html {
    renderTokenAmount({token = token, amount = amount})
  } where {
    amount =
      UiHelper.displayAmount(rawAmount)
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

  fun renderTransactionKind (row : ApiTransactionResponse) : Html {
    if (row.transaction.kind == "SLOW") {
      <h6 class="tag tag-teal">
        "SLOW"
      </h6>
    } else {
      <h6 class="tag tag-pink">
        "FAST"
      </h6>
    }
  }

  fun renderAge (row : ApiTransactionResponse) : String {
    UiHelper.timeAgo(row.transaction.timestamp)
  }

  fun renderDate (row : ApiTransactionResponse) : String {
    UiHelper.dateFrom(row.transaction.timestamp)
  }

  fun renderTransaction (transaction : ApiTransactionResponse) : Html {
    <div class="card overflow-hidden">
      <div class="card-header">
        <h3 class="card-title">
          <{ "Transaction: " + transaction.transaction.id }>
        </h3>
      </div>

      <div class="card-body">
        <div class="table-responsive orders-table">
          <table
            id="example"
            class="table table-bordered text-nowrap  mb-0">

            <tr class="bold border-bottom">
              <th class="border-bottom-0">
                "Transaction id"
              </th>

              <td>
                <{ transaction.transaction.id }>
              </td>
            </tr>

            <tr class="bold border-bottom">
              <th class="border-bottom-0">
                "Kind"
              </th>

              <td>
                <{ renderTransactionKind(transaction) }>
              </td>
            </tr>

            <tr class="bold border-bottom">
              <th class="border-bottom-0">
                "Age"
              </th>

              <td>
                <div>
                  <div>
                    <{ renderAge(transaction) }>
                  </div>

                  <div>
                    <{ renderDate(transaction) }>
                  </div>
                </div>
              </td>
            </tr>

            <tr class="bold border-bottom">
              <th class="border-bottom-0">
                "Confirmations"
              </th>

              <td>
                <{ transaction.confirmations |> Number.toString }>
              </td>
            </tr>

            <tr class="bold border-bottom">
              <th class="border-bottom-0">
                "Action"
              </th>

              <td>
                <{ transaction.transaction.action }>
              </td>
            </tr>

            <tr class="bold border-bottom">
              <th class="border-bottom-0">
                "Token"
              </th>

              <td>
                <{ transaction.transaction.token }>
              </td>
            </tr>

            <tr class="bold border-bottom">
              <th class="border-bottom-0">
                "From"
              </th>

              <td>
                <{ renderSenders(transaction) }>
              </td>
            </tr>

            <tr class="bold border-bottom">
              <th class="border-bottom-0">
                "To"
              </th>

              <td>
                <{ renderRecipients(transaction) }>
              </td>
            </tr>

            <tr class="bold border-bottom">
              <th class="border-bottom-0">
                "Message"
              </th>

              <td>
                <{ transaction.transaction.message }>
              </td>
            </tr>

            <tr class="bold border-bottom">
              <th class="border-bottom-0">
                "Previous Hash"
              </th>

              <td>
                <{ transaction.transaction.previousHash }>
              </td>
            </tr>

          </table>
        </div>
      </div>
    </div>
  }
}
