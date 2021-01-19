component RecentBlocks {
  property blocks : Array(ApiBlock)

  fun renderBodyRow (row : ApiBlock) : Html {
    <tr>
      <td class="text-muted">
        <{ renderBlockId(row) }>
      </td>

      <td class="text-muted">
        <{ renderBlockKind(row) }>
      </td>

      <td class="text-muted">
        <{ renderTokenAmounts(row) }>
      </td>
    </tr>
  }

  fun renderBlockKind (row : ApiBlock) : Html {
    if (row.kind == "SLOW") {
      <h6 class="tag tag-teal">
        "SLOW"
      </h6>
    } else {
      <h6 class="tag tag-pink">
        "FAST"
      </h6>
    }
  }

  fun renderAmount (row : ApiBlock) : Html {
    <h6 class="tag tag-blue">
      <{ amount }>

      <span class="tag-addon tag-azure">
        "  AXNT"
      </span>
    </h6>
  } where {
    amount =
      UiHelper.displayAmount(
        row.transactions
        |> Array.flatMap((t : ApiTransaction) { t.recipients })
        |> Array.map((r : ApiRecipient) { r.amount })
        |> Array.sum)     
  }

  fun renderTokenAmounts(row : ApiBlock) : Array(Html) {
      tokenAmounts
      |> Array.map(renderTokenAmount)
  } where {
    uniqueTokens = Set.fromArray(row.transactions |> Array.map(.token)) |> Set.toArray()
    tokenAmounts = uniqueTokens 
                   |> Array.map((token : String){
                      { token = token, 
                       amount =  UiHelper.displayAmount(row.transactions 
                       |> Array.select((t : ApiTransaction){ t.token == token }) 
                       |> Array.flatMap((t : ApiTransaction) { t.recipients })
                       |> Array.map((r : ApiRecipient) { r.amount })
                       |> Array.sum)
                     }
                      })
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

  fun renderBlockId (row : ApiBlock) : Html {
    <div>
      <a href={"/blocks/" + blockId}>
        <{ "Block " + blockId }>
      </a>

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
        <div>
        <i>
        <{ renderDifficulty(row) }>
        </i>
        </div>
      </div>
    </div>
  } where {
    blockId =
      Number.toString(row.index)
  }

  fun renderDifficulty(row : ApiBlock) : Html {
    if (row.kind == "SLOW"){
      row.difficulty 
      |> Maybe.map((d : Number) { <div>"Difficulty: " <b> <{Number.toString(d) }> </b></div> })
      |> Maybe.withDefault(<span></span>)
    } else {
      <span></span>
    }
  }

  fun renderDate (row : ApiBlock) : String {
    UiHelper.shortDateFrom(row.timestamp)
  }

  fun calculateTimeAgo (row : ApiBlock) : String {
    UiHelper.timeAgo(row.timestamp)
  }

  fun render : Html {
    <div class="card overflow-hidden">
      <div class="card-header">
        <div class="col-md-12">
          <div class="float-left">
            <h3 class="card-title">
              "Latest Blocks"
            </h3>
          </div>

          <div class="float-right">
            <a
              href="/blocks"
              class="btn btn-app btn-indigo">

              <i class="fa fa-cube"/>
              "  View all blocks"

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
                  "Block id"
                </th>

                <th class="border-bottom-0">
                  "Kind"
                </th>

                <th class="border-bottom-0">
                  "Amount"
                </th>
              </tr>
            </thead>

            <tbody>
              for (row of blocks) {
                renderBodyRow(row)
              }
            </tbody>

          </table>
        </div>
      </div>
    </div>
  }
}
