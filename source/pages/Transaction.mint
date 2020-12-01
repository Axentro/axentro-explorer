component Transaction {

    connect Application exposing { transactionId }
   
     state transactions : Maybe(Array(ApiTransactionResponse)) = Maybe.nothing()
     state error : String = ""
   
     fun render : Html {
       <Layout
         navigation=[<Navigation/>]
         content=[pageContent()]/>
     }
   
     fun componentDidMount : Promise(Never, Void) {
         sequence {
           getTransaction()
         }
     }
   
      fun getTransaction : Promise(Never, Void) {
         sequence {
             response = 
              Http.get("http://localhost:3000/api/v1/transaction/" + transactionId)
              |> Http.send()
       
             json = 
               Json.parse(response.body)
               |> Maybe.toResult("Json parsing error with transaction")
   
   
   Debug.log(json)
   
             result = 
               decode json as ApiResponseTransaction
   
            Debug.log(result)
   
             next { transactions = Maybe.just([result.transaction]) }   
         } catch {
             next { error = "Could not fetch block"}
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
                                       <li class="breadcrumb-item active" aria-current="page"><a href={"/transactions/" + transactionId}><{"Transaction " + transactionId}></a></li>
                                   </ol>
                               </div>
                               <div class="page-rightheader">
                                   
                               </div>
                           </div>
                       
       
                           <div class="row row-deck">
                               <div class="col-lg-12 col-12">
                                   <OneTransaction transactions={recentTransactions}/>
                               </div>
                       
                           </div>
                           
   
   
                       </div>
   
                   
   
                   </div>
     } where {
         recentTransactions = (transactions |> Maybe.withDefault([] of ApiTransactionResponse))
     }
   }
   
   