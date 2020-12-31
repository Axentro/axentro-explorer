component Dashboard {
  state stats : Maybe(Stats) = Maybe.nothing()
  state transactions : Maybe(Array(TransactionsResponse)) = Maybe.nothing()
  state blocks : Maybe(Array(ApiBlock)) = Maybe.nothing()
  state error : String = ""

  fun render : Html {
    <Layout
      navigation=[<Navigation current="dashboard"/>]
      content=[pageContent()]/>
  }

  fun componentDidMount : Promise(Never, Void) {
    sequence {
      getStats()
      getTransactions()
      getBlocks()
    }
  }

  fun getStats : Promise(Never, Void) {
    sequence {
      response =
        Http.get(Network.baseUrl() + "/api/v1/blockchain/size")
        |> Http.send()

      json =
        Json.parse(response.body)
        |> Maybe.toResult("Json parsing error with blockchain size")

      result =
        decode json as ApiResponseStats

      next { stats = Maybe.just(result.stats.totals) }
    } catch {
      next { error = "Could not fetch blockchain size" }
    }
  }

  fun getTransactions : Promise(Never, Void) {
    sequence {
      response =
        Http.get(Network.baseUrl() + "/api/v1/transactions?per_page=10&sort_field=time")
        |> Http.send()

      json =
        Json.parse(response.body)
        |> Maybe.toResult("Json parsing error with transactions")

      result =
        decode json as ApiResponseTransactions

      next { transactions = Maybe.just(result.transactions.transactions) }
    } catch {
      next { error = "Could not fetch transactions" }
    }
  }

  fun getBlocks : Promise(Never, Void) {
    sequence {
      response =
        Http.get(Network.baseUrl() + "/api/v1/blockchain?per_page=15&sort_field=time")
        |> Http.send()

      json =
        Json.parse(response.body)
        |> Maybe.toResult("Json parsing error with blocks")

      result =
        decode json as ApiResponseBlocks

      next { blocks = Maybe.just(result.blocks.data) }
    } catch {
      next { error = "Could not fetch blocks" }
    }
  }

  get loadingPageContent : Html {
    <div>"LOADING"</div>
  }

  get renderStatsOrNone : Html {
    stats
    |> Maybe.map(renderStats)
    |> Maybe.withDefault(renderNoStats)
  }

  fun renderStats (stats : Stats) : Html {
    <div class="row">
      <div class="col-lg-3 col-md-6">
        <ColourMetric
          title="Total Transactions"
          value={stats.totalFastTransactions + stats.totalSlowTransactions}
          icon="tasks"
          colour="bg-gradient-secondary"/>
      </div>

      <div class="col-lg-3 col-md-6">
        <ColourMetric
          title="Latest Difficulty"
          value={stats.difficulty}
          icon="dashboard"
          colour="bg-gradient-success"/>
      </div>

      <div class="col-lg-3 col-md-6">
        <ColourMetric
          title="Total Fast Blocks"
          value={stats.totalFastBlocks}
          icon="cube"
          colour="bg-gradient-danger"/>
      </div>

      <div class="col-lg-3 col-md-6">
        <ColourMetric
          title="Total Slow Blocks"
          value={stats.totalSlowBlocks}
          icon="cube"
          colour="bg-gradient-info"/>
      </div>
    </div>
  }

  get renderNoStats : Html {
    <div class="row">
      <div class="col-lg-3 col-md-6">
        <ColourMetric
          title="Total Transactions"
          value={0}
          icon="tasks"
          colour="bg-gray"/>
      </div>

      <div class="col-lg-3 col-md-6">
        <ColourMetric
          title="Latest Difficulty"
          value={0}
          icon="dashboard"
          colour="bg-gray"/>
      </div>

      <div class="col-lg-3 col-md-6">
        <ColourMetric
          title="Total Fast Blocks"
          value={0}
          icon="cube"
          colour="bg-gray"/>
      </div>

      <div class="col-lg-3 col-md-6">
        <ColourMetric
          title="Total Slow Blocks"
          value={0}
          icon="cube"
          colour="bg-gray"/>
      </div>
    </div>
  }

  fun pageContent : Html {
    <div class="app-content toggle-content">
      <div class="side-app">
        <div class="page-header">
          <div class="page-leftheader">
            <h1 class="page-title">
              " Axentro Blockchain Explorer"
            </h1>

            <ol class="breadcrumb">
              <li class="breadcrumb-item">
                <a href="/dashboard">
                  <i class="las la-home mr-2 fs-16"/>
                  "Dashboard"
                </a>
              </li>
            </ol>
          </div>

          <div class="page-rightheader"/>
        </div>

        <{ renderStatsOrNone }>

        <div class="row row-deck">
          <div class="col-lg-6 col-12">
            <RecentBlocks blocks={recentBlocks}/>
          </div>

          <div class="col-lg-6 col-12">
            <RecentTransactions transactions={recentTransactions}/>
          </div>
        </div>
      </div>
    </div>
  } where {
    recentTransactions =
      (transactions
      |> Maybe.withDefault([] of TransactionsResponse))

    recentBlocks =
      (blocks
      |> Maybe.withDefault([] of ApiBlock))
  }
}
