component AllBlocks {

  state blocks : Maybe(Array(BlocksResponse)) = Maybe.nothing()
  state error : String = ""
  state selectedPerPage : String = "10"
  state currentPage : Number = 0

  fun componentDidMount : Promise(Never, Void) {
      sequence {
        getBlocks()
      }
  }

   fun getBlocks : Promise(Never, Void) {
      sequence {
          response = 
           Http.get("http://localhost:3000/api/v1/blockchain?page=" + page + "&per_page=" + perPage + "&sort_field=time")
           |> Http.send()
    
          json = 
            Json.parse(response.body)
            |> Maybe.toResult("Json parsing error with blocks")

          result = 
            decode json as ApiResponseBlocks

          next { blocks = Maybe.just(result.blocks) }   
      } catch {
          next { error = "Could not fetch blocks"}
      }
  } where {
	  perPage = selectedPerPage
	  page = Number.toString(currentPage)
  }

  fun renderBodyRow(row : BlocksResponse) : Html {
	  <tr>
	  <td class="text-muted"><{renderBlockId(row)}></td>
      <td class="text-muted"><{renderBlockKind(row)}></td>
	  <td class="text-muted"><{renderAge(row)}></td>
	  <td class="text-muted"><{renderTransactionCount(row)}></td>
														
       <td class="text-muted"><{renderAmount(row)}></td>
	  </tr>
  }

  fun renderBlockKind(row : BlocksResponse) : Html {
	  if (row.kind == "SLOW") {
        <h6 class="tag tag-teal">"SLOW"</h6>
	  } else {
         <h6 class="tag tag-pink">"FAST"</h6>
	  }
  }

 fun renderTransactionCount(row : BlocksResponse) : Html {
   <a href={"/block/" + blockId + "/transactions"}><{count}></a>
 } where {
  blockId = Number.toString(row.index)
  count = Number.toString(row.transactions |> Array.size)
 }

 fun renderAmount(row : BlocksResponse) : Html {
	<h6 class="tag tag-blue"><{amount}> <span class="tag-addon tag-azure">"  AXNT"</span></h6>   
   } where {
	   amount = UiHelper.displayAmount(
	   row.transactions
	   |> Array.flatMap((t : ApiTransaction) { t.recipients })
	   |> Array.map((r : ApiRecipient) { r.amount })
	   |> Array.sum)
   }

    fun renderAge(row : BlocksResponse) : String {
     UiHelper.timeAgo(row.timestamp)
   }

   fun renderBlockId(row : BlocksResponse) : Html {
	   <a href={"/blocks/" + blockId}><{ blockId }></a>
   } where {
	   blockId = Number.toString(row.index)
   }

   get perPageOptions : Array(String) {
	   ["10","25","50","100"]
   }

    fun onPerPage (event : Html.Event) {
		sequence {
           next { selectedPerPage = Dom.getValue(event.target) }
		   getBlocks()
		}
  }
   
   fun onPrevPage (event : Html.Event) {
	   sequence {
	   next { currentPage = Math.max(0, currentPage - 1) }
	   getBlocks()
	   }
   }

    fun onNextPage (event : Html.Event) {
		sequence {
	   next { currentPage = currentPage + 1 }
	   getBlocks()
		}
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

   fun render : Html {
       <div class="card overflow-hidden">
									<div class="card-header">
										<div class="col-md-12">
										<div class="float-left">
											<h3 class="card-title">"Blocks"</h3> 
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
														<th class="border-bottom-0">"Block Id"</th>
														<th class="border-bottom-0">"Kind"</th>
														<th class="border-bottom-0">"Age"</th>
														<th class="border-bottom-0">"Transactions"</th>
														<th class="border-bottom-0">"Amount"</th>
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
	   allBlocks = blocks |> Maybe.withDefault([] of BlocksResponse)
   }

}