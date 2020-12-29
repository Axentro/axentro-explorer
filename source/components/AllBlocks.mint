component AllBlocks {

  connect BlockStore exposing { currentPage, perPage, blocks, blockError }

  fun renderBodyRow (row : ApiBlock) : Html {
    <tr>
      <td class="text-muted">
        <{ renderBlockId(row) }>
      </td>

      <td class="text-muted">
        <{ renderBlockKind(row) }>
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
        <{ renderTransactionCount(row) }>
      </td>

      <td class="text-muted">
        <{ renderAmount(row) }>
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

  fun renderTransactionCount (row : ApiBlock) : Html {
    <a href={"/blocks/" + blockId + "/transactions"}>
      <{ count + " transactions" }>
    </a>
  } where {
    blockId =
      Number.toString(row.index)

    count =
      Number.toString(
        row.transactions
        |> Array.size)
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

  fun renderAge (row : ApiBlock) : String {
    UiHelper.timeAgo(row.timestamp)
  }

  fun renderDate (row : ApiBlock) : String {
    UiHelper.shortDateFrom(row.timestamp)
  }


  fun renderBlockId (row : ApiBlock) : Html {
    <a href={"/blocks/" + blockId}>
      <{ "Block " + blockId }>
    </a>
  } where {
    blockId =
      Number.toString(row.index)
  }

  fun onPerPage (event : Html.Event) {
    Window.navigate("/blocks?page=" + currentPage + "&perPage=" + perPageValue)
  } where {
    perPageValue = Dom.getValue(event.target)
  }

  fun onPrevPage (event : Html.Event) {
    Window.navigate("/blocks?page=" + currentPageValue + "&perPage=" + perPage)
  } where {
    currentPageValue = Number.toString(Math.max(0, (Number.fromString(currentPage) |> Maybe.withDefault(0)) - 1))
  }

  fun onNextPage (event : Html.Event) {
    Window.navigate("/blocks?page=" + currentPageValue + "&perPage=" + perPage)
  } where {
    currentPageValue = Number.toString((currentPage |> Number.fromString |> Maybe.withDefault(0)) + 1)
  }

  fun render : Html {
    <div class="card overflow-hidden">
      <div class="card-header">
        <div class="col-md-12">
          <div class="float-left">
            <h3 class="card-title">
              "Blocks"
            </h3>
          </div>

          <div class="float-right">
            <Pagination
              paginationKind={PaginationKind::Block(paginationData)}
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
                  "Block Id"
                </th>

                <th class="border-bottom-0">
                  "Kind"
                </th>

                <th class="border-bottom-0">
                  "Age"
                </th>

                <th class="border-bottom-0">
                  "Transactions"
                </th>

                <th class="border-bottom-0">
                  "Amount"
                </th>
              </tr>
            </thead>

            <tbody>
              for (row of allBlocks) {
                renderBodyRow(row)
              }
            </tbody>

          </table>
        </div>
      </div>
    </div>
  } where {
    allBlocks =
      blocks
      |> Maybe.map(.data)
      |> Maybe.withDefault([] of ApiBlock)

    paginationData =
      blocks
      |> Maybe.map(.pagination)
      |> Maybe.withDefault(
        {
          page = 0,
          totalCount = 0
        })
  }
}
