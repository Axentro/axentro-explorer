record Ui.Pager.Item {
  contents : Html,
  name : String
}

component Main {
  connect Application exposing { page }

  get pages : Array(Ui.Pager.Item) {
    [
      {
        name = "dashboard",
        contents = <Dashboard/>
      },
      {
        name = "transactions",
        contents = <Transactions/>
      },
      {
        name = "blocks",
        contents = <Blocks/>
      },
      {
        name = "block",
        contents = <Block/>
      },
      {
        name = "transaction",
        contents = <Transaction/>
      },
      {
        name = "block_transactions",
        contents = <BlockTransactions/>
      },
      {
        name = "address",
        contents = <Address/>
      },
      {
        name = "domain",
        contents = <Domain/>
      },
      {
        name = "no_search",
        contents = <NoSearch/>
      },
      {
        name = "not_found",
        contents = <NotFound/>
      }
    ]
  }

  fun preloader (contents : Html) : Html {
    <div>
      <{ contents }>
    </div>
  }

  fun render : Html {
    pages
    |> Array.find(
      (item : Ui.Pager.Item) : Bool { item.name == page })
    |> Maybe.map(
      (item : Ui.Pager.Item) : Html { preloader(item.contents) })
    |> Maybe.withDefault(<div/>)
  }
}
