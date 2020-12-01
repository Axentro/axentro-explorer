component AllTransactions {


  state transactions : Maybe(Array(TransactionsResponse)) = Maybe.nothing()
  state error : String = ""

  state selectedPerPage : String = "10"
  state currentPage : Number = 0

  fun componentDidMount : Promise(Never, Void) {
      sequence {
        getTransactions()
      }
  }

   fun getTransactions : Promise(Never, Void) {
    sequence {
    response = 
     Http.get("http://localhost:3000/api/v1/transactions?page=" + page + "&per_page=" + perPage + "&sort_field=time")
     |> Http.send()

     json = 
      Json.parse(response.body)
      |> Maybe.toResult("Json parsing error with transactions")

      result = 
        decode json as ApiResponseTransactions

      next { transactions = Maybe.just(result.transactions) }
    } catch {
      next { error = "Could not fetch transactions"}
    }
  } where {
	  perPage = selectedPerPage
	  page = Number.toString(currentPage)
  }

  fun renderAddresses(addresses : Array(String)) : Array(Html) {
	   for (address of addresses) {
		   <div><a href={"/addresses/" + address}><{ UiHelper.capLength(address, 24)}></a></div>
       }
   }

   fun renderTransactionId(row : TransactionsResponse) : Html {
	   <a href={"/transactions/" + transactionId}><{ UiHelper.capLength(transactionId, 24)}></a>
   } where {
	   transactionId = row.transaction.id
   }

    fun renderBlockId(row : TransactionsResponse) : Html {
	   <a href={"/blocks/" + blockId}><{ blockId }></a>
   } where {
	   blockId = Number.toString(row.blockId)
   }

   fun renderAge(row : TransactionsResponse) : String {
     UiHelper.timeAgo(row.transaction.timestamp)
   }

  fun renderAmount(row : TransactionsResponse) : Html {
	<h6 class="tag tag-blue"><{amount}> <span class="tag-addon tag-azure">"  AXNT"</span></h6>   
   } where {
	   amount = UiHelper.displayAmount(row.transaction.recipients
	   |> Array.map((r : ApiRecipient) { r.amount })
	   |> Array.sum)
   }

   fun renderFee(row : TransactionsResponse) : Html {
    <h6 class="tag tag-gray"><{amount}> <span class="tag-addon tag-azure">"  AXNT"</span></h6>     
   } where {
       amount = UiHelper.displayAmount(row.transaction.senders
        |> Array.map((s : ApiSender) { s.fee})
        |> Array.sum)
   }

   fun renderBodyRow(row : TransactionsResponse) : Html {
       <tr>
				
														<td class="text-muted"><{renderTransactionId(row)}></td>
														<td class="text-muted"><{renderBlockId(row)}></td>
														<td class="text-muted"><{renderAge(row)}></td>
														<td class="text-muted"> <{ if (Array.isEmpty(senderAddresses)) { <div></div> } else { <{renderAddresses(senderAddresses)}> }}></td>
														<td class="text-muted"><{renderAddresses(recipientAddresses)}></td>
														<td class="text-muted"><{renderAmount(row)}></td>
														<td class="text-muted"><{renderFee(row)}></td>
													</tr>
   } where {
        recipientAddresses = row.transaction.recipients
       |> Array.map((r : ApiRecipient) { r.address })
       senderAddresses = row.transaction.senders
       |> Array.map((s : ApiSender) { s.address }) 
   }


 fun pagination : Html {
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
	     <span class="mr-5 tag tag-indigo"><{"Page " + page}></span>
	     <button onClick={onPrevPage} class="btn btn-outline-primary">"Prev"</button>
	     <button onClick={onNextPage} class="btn btn-outline-primary">"Next"</button>
	   </div>	    
	   </div>
	   </div>
   } where {
	   page = Number.toString(currentPage + 1)
   }

   get perPageOptions : Array(String) {
	   ["10","25","50","100"]
   }

    fun onPerPage (event : Html.Event) {
		sequence {
           next { selectedPerPage = Dom.getValue(event.target) }
		   getTransactions()
		}
  }
   
   fun onPrevPage (event : Html.Event) {
	   sequence {
	   next { currentPage = Math.max(0, currentPage - 1) }
	   getTransactions()
	   }
   }

    fun onNextPage (event : Html.Event) {
		sequence {
	   next { currentPage = currentPage + 1 }
	   getTransactions()
		}
   }

   fun render : Html {
       <div class="card overflow-hidden">
									<div class="card-header">
									<div class="col-md-12">
										<div class="float-left">
											<h3 class="card-title">"Transactions"</h3> 
									    </div>
										<div class="float-right">		
											<{ pagination() }>
										</div>
										</div>
									</div>
									<div class="card-body">
										<div class="table-responsive orders-table">
											<table id="example" class="table table-bordered text-nowrap  mb-0">
												<thead>
													<tr class="bold border-bottom">
														<th class="border-bottom-0">"Transaction id"</th>
														<th class="border-bottom-0">"Block id"</th>
														<th class="border-bottom-0">"Age"</th>
														<th class="border-bottom-0">"From"</th>
														<th class="border-bottom-0">"To"</th>
														<th class="border-bottom-0">"Amount"</th>
														<th class="border-bottom-0">"Fee"</th>
													</tr>
												</thead>

                                                 <tbody>
                                               for (row of recentTransactions) {
                                                 renderBodyRow(row)
                                                }
                                                 </tbody>
												
											</table>
										</div>
									</div>
									</div>
   } where {
      recentTransactions = (transactions |> Maybe.withDefault([] of TransactionsResponse))

  }

}