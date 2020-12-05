component AllBlocks {

  state blocks : Maybe(BlocksResponse) = Maybe.nothing()
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
           Http.get(Network.baseUrl() + "/api/v1/blockchain?page=" + page + "&per_page=" + perPage + "&sort_field=time")
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

  fun renderBodyRow(row : ApiBlock) : Html {
	  <tr>
	  <td class="text-muted"><{renderBlockId(row)}></td>
      <td class="text-muted"><{renderBlockKind(row)}></td>
	  <td class="text-muted"><{renderAge(row)}></td>
	  <td class="text-muted"><{renderTransactionCount(row)}></td>
														
       <td class="text-muted"><{renderAmount(row)}></td>
	  </tr>
  }

  fun renderBlockKind(row : ApiBlock) : Html {
	  if (row.kind == "SLOW") {
        <h6 class="tag tag-teal">"SLOW"</h6>
	  } else {
         <h6 class="tag tag-pink">"FAST"</h6>
	  }
  }

 fun renderTransactionCount(row : ApiBlock) : Html {
   <a href={"/block/" + blockId + "/transactions"}><{count}></a>
 } where {
  blockId = Number.toString(row.index)
  count = Number.toString(row.transactions |> Array.size)
 }

 fun renderAmount(row : ApiBlock) : Html {
	<h6 class="tag tag-blue"><{amount}> <span class="tag-addon tag-azure">"  AXNT"</span></h6>   
   } where {
	   amount = UiHelper.displayAmount(
	   row.transactions
	   |> Array.flatMap((t : ApiTransaction) { t.recipients })
	   |> Array.map((r : ApiRecipient) { r.amount })
	   |> Array.sum)
   }

    fun renderAge(row : ApiBlock) : String {
     UiHelper.timeAgo(row.timestamp)
   }

   fun renderBlockId(row : ApiBlock) : Html {
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

   fun pagination(paginationData : BlockPagination) : Html {
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
	     <span class="mr-5 tag tag-indigo"><{"Page " + page + " of " + total}></span>
	    <{ showPaginationPrev(pageNumber) }>
	    <{ showPaginationNext(pageNumber, totalCountNumber) }>
	   </div>	    
	   </div>
	   </div>
   } where {
     pageNumber = paginationData.page + 1
	   page = Number.toString(pageNumber)
     selectedPerPageNumber = Number.fromString(selectedPerPage) |> Maybe.withDefault(0)
     totalCountNumber = (paginationData.totalCount / selectedPerPageNumber)
     total = Number.toString(UiHelper.roundUp(totalCountNumber))
   }

   fun showPaginationPrev(pageNumber : Number) : Html {
     if (pageNumber <= 1) {
       <button disabled={true} class="btn btn-outline-primary disabled">"Prev"</button>  
     } else {
       <button onClick={onPrevPage} class="btn btn-outline-primary">"Prev"</button>
     }
   }

    fun showPaginationNext(pageNumber : Number, totalCount : Number) : Html {
     if (pageNumber >= totalCount) {
       <button disabled={true} class="btn btn-outline-primary disabled">"Next"</button>  
     } else {
        <button onClick={onNextPage} class="btn btn-outline-primary">"Next"</button>
     }
   }

  property paginationKind : PaginationKind
   property selectedPerPage : String
   property onPerPage : Function(Html.Event, Promise(Never,Void))
   property onPrevPage : Function(Html.Event, Promise(Never,Void))
   property onNextPage : Function(Html.Event, Promise(Never,Void))

   fun render : Html {
       <div class="card overflow-hidden">
									<div class="card-header">
										<div class="col-md-12">
										<div class="float-left">
											<h3 class="card-title">"Blocks"</h3> 
									    </div>
										<div class="float-right">		
											<{ <Pagination paginationKind={paginationData} />}>
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
	   allBlocks = blocks |> Maybe.map(.data) |> Maybe.withDefault([] of ApiBlock)
     paginationData = blocks |> Maybe.map(.pagination) |> Maybe.withDefault({ page = 0, totalCount = 0})
   }

}