
component BlockTransactions {

 connect Application exposing { blockId }

  state transactions : Maybe(BlockTransactionsResponse) = Maybe.nothing()
  state error : String = ""

  fun render : Html {
    <Layout
      navigation=[<Navigation/>]
      content=[pageContent()]/>
  }

  fun componentDidMount : Promise(Never, Void) {
      sequence {
        getTransactions()
      }
  }

   fun getTransactions : Promise(Never, Void) {
    sequence {
    response = 
     Http.get("http://localhost:3000/api/v1/block/" + blockId + "/transactions?per_page=10")
     |> Http.send()

     json = 
      Json.parse(response.body)
      |> Maybe.toResult("Json parsing error with block transactions")

      Debug.log(json)
      result = 
        decode json as ApiResponseBlockTransactions

      next { transactions = Maybe.just(result.result) }
    } catch {
      next { error = "Could not fetch block transactions"}
    }
  } 

 
  fun pageContent : Html {
    <div class="app-content toggle-content">
					<div class="side-app">
						<div class="page-header">
							<div class="page-leftheader">
								<h1 class="page-title">" Axentro Blockchain Explorer"</h1>
								<ol class="breadcrumb">
									<li class="breadcrumb-item"><a href="/dashboard"><i class="las la-home mr-2 fs-16"></i>"Dashboard"</a></li>
									<li class="breadcrumb-item active" aria-current="page"><a href="/transactions">"Transactions"</a></li>
								</ol>
							</div>
							<div class="page-rightheader">
								
							</div>
						</div>
					
					
					
				
						<div class="row row-deck">
							<div class="col-lg-12 col-12">
								
							</div>
                    
						</div>
						


					</div>

				

				</div>
  } where {
      recentTransactions = (transactions |> Maybe.map((t : BlockTransactionsResponse) { t.transactions}) |> Maybe.withDefault([] of ApiTransaction))

  }
}

