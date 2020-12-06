component Block {
  connect Application exposing { blockId }

  state blocks : Maybe(Array(ApiBlock)) = Maybe.nothing()
  state error : String = ""

  fun render : Html {
    <Layout
      navigation=[<Navigation current="blocks"/>]
      content=[pageContent()]/>
  }

  fun componentDidMount : Promise(Never, Void) {
    sequence {
      getBlock()
    }
  }

  fun getBlock : Promise(Never, Void) {
    sequence {
      response =
        Http.get(Network.baseUrl() + "/api/v1/block/" + blockId)
        |> Http.send()

      json =
        Json.parse(response.body)
        |> Maybe.toResult("Json parsing error with transaction")

      result =
        decode json as ApiResponseSingleBlock

      next { blocks = Maybe.just([result.block.block]) }
    } catch {
      next { error = "Could not fetch block" }
    }
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

              <li
                class="breadcrumb-item active"
                aria-current="page">

                <a href="/blocks">
                  "Blocks"
                </a>

              </li>

              <li
                class="breadcrumb-item active"
                aria-current="page">

                <a href={"/blocks/" + blockId}>
                  <{ "Block " + blockId }>
                </a>

              </li>
            </ol>
          </div>

          <div class="page-rightheader"/>
        </div>

        <div class="row row-deck">
          <div class="col-lg-12 col-12">
            <OneBlock blocks={recentBlocks}/>
          </div>
        </div>
      </div>
    </div>
  } where {
    recentBlocks =
      (blocks
      |> Maybe.withDefault([] of ApiBlock))
  }
}
