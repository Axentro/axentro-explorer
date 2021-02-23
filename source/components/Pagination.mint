enum PaginationKind {
  Block(BlockPagination)
  Transaction(TransactionPagination)
}

component Pagination {
  property paginationKind : PaginationKind
  property selectedPerPage : String
  property onPerPage : Function(Html.Event, Promise(Never, Void))
  property onPrevPage : Function(Html.Event, Promise(Never, Void))
  property onNextPage : Function(Html.Event, Promise(Never, Void))

  fun render : Html {
    case (paginationKind) {
      PaginationKind::Block blockPagination => renderBlockPagination(blockPagination)
      PaginationKind::Transaction transactionPagination => renderTransactionPagination(transactionPagination)
    }
  }

  fun renderTransactionPagination (paginationData : TransactionPagination) : Html {
    <div class="col">
      <div class="ml-2 float-right">
        <select
          onChange={onPerPage}
          class="form-control"
          id="perPage">

          <{ UiHelper.selectNameOptions(selectedPerPage, perPageOptions) }>

        </select>
      </div>

      <div class="float-left">
        <div class="mt-1 btn-list">
          <span class="mr-5 tag tag-indigo">
            <{ "Page " + page + " of " + total }>
          </span>

          <{ showPaginationPrev(pageNumber) }>
          <{ showPaginationNext(pageNumber, totalCountNumber) }>
        </div>
      </div>
    </div>
  } where {
    pageNumber =
      paginationData.page

    page =
      Number.toString(pageNumber)

    selectedPerPageNumber =
      Number.fromString(selectedPerPage)
      |> Maybe.withDefault(1)

    totalCountNumber =
      UiHelper.roundDown(paginationData.totalCount / selectedPerPageNumber)

    total =
      Number.toString(totalCountNumber)
  }

  fun renderBlockPagination (paginationData : BlockPagination) : Html {
    <div class="col">
      <div class="ml-2 float-right">
        <select
          onChange={onPerPage}
          class="form-control"
          id="perPage">

          <{ UiHelper.selectNameOptions(selectedPerPage, perPageOptions) }>

        </select>
      </div>

      <div class="float-left">
        <div class="mt-1 btn-list">
          <span class="mr-5 tag tag-indigo">
            <{ "Page " + page + " of " + total }>
          </span>

          <{ showPaginationPrev(pageNumber) }>
          <{ showPaginationNext(pageNumber, totalCountNumber) }>
        </div>
      </div>
    </div>
  } where {
    pageNumber =
      paginationData.page

    page =
      Number.toString(pageNumber)

    selectedPerPageNumber =
      Number.fromString(selectedPerPage)
      |> Maybe.withDefault(1)

    totalCountNumber =
      UiHelper.roundDown(paginationData.totalCount / selectedPerPageNumber)

    total =
      Number.toString(totalCountNumber)
  }

  fun showPaginationPrev (pageNumber : Number) : Html {
    if (pageNumber <= 1) {
      <button
        disabled={true}
        class="btn btn-outline-primary disabled">

        "Prev"

      </button>
    } else {
      <button
        onClick={onPrevPage}
        class="btn btn-outline-primary">

        "Prev"

      </button>
    }
  }

  fun showPaginationNext (pageNumber : Number, totalCount : Number) : Html {
    if (pageNumber >= totalCount) {
      <button
        disabled={true}
        class="btn btn-outline-primary disabled">

        "Next"

      </button>
    } else {
      <button
        onClick={onNextPage}
        class="btn btn-outline-primary">

        "Next"

      </button>
    }
  }

  get perPageOptions : Array(String) {
    ["10", "25", "50", "100"]
  }
}
